/*
 * Copyright (c) 2014 trgk(phu54321@naver.com)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "SCMDPlugin.h"


// __thiscall emulator. First argument -> ecx.
#define DECLARE_THISCALL(decl, offset) \
__declspec( naked ) decl \
{ \
    _asm pop eax \
    _asm pop ecx \
    _asm push eax \
    _asm mov eax, [ecx] \
    _asm mov eax, [eax + offset] \
    _asm jmp eax \
}

// SICStringList uses virtual function calls. We should emulate __thiscall.

// Any function with SCMD2 in their middle takes SCMDraft2 style text as their input/output.
// Any function with _RawIndex in their last counts from stringtable string #1 as 0. (eg. stringID == -1 for enmpty string)
DECLARE_THISCALL(int           __stdcall StringTable_FindString_RawIndex(SI_VirtSCStringList*, const char *), 0x0C)
DECLARE_THISCALL(const char*   __stdcall StringTable_GetString(SI_VirtSCStringList*, int), 0x10)
DECLARE_THISCALL(int           __stdcall StringTable_AddSCMD2String(SI_VirtSCStringList*, const char *, int , char), 0x18)
DECLARE_THISCALL(int           __stdcall StringTable_Dereference(SI_VirtSCStringList*, __int16 , int , int), 0x1C)
DECLARE_THISCALL(int           __stdcall StringTable_DerefAndAddString(SI_VirtSCStringList*, const char *, int , int), 0x20)
DECLARE_THISCALL(char          __stdcall StringTable_SetSCMD2Text(SI_VirtSCStringList*, const char *, int), 0x24)
DECLARE_THISCALL(int           __stdcall StringTable_GetTotalStringNum(SI_VirtSCStringList*), 0x2C)
DECLARE_THISCALL(char          __stdcall StringTable_BackupStrings(SI_VirtSCStringList*), 0x3C)
DECLARE_THISCALL(char          __stdcall StringTable_RestoreBackup(SI_VirtSCStringList*), 0x40)
DECLARE_THISCALL(char          __stdcall StringTable_ClearBackup(SI_VirtSCStringList*), 0x44)




static int ParseXDigit(int ch) {
	if('0' <= ch && ch <= '9') return ch - '0';
	else if('a' <= ch && ch <= 'f') return ch - 'a' + 10;
	else return ch - 'A' + 10;
}

static char XDigitToChar(int hexdigit) {
	if(0 <= hexdigit && hexdigit <= 9) return '0' + hexdigit;
	else if(10 <= hexdigit && hexdigit <= 15) return 'A' + (hexdigit - 10);
	else return '*';
}



// SCMDraft2 mixes SCMDraft2 style text & Raw text.
// We need conversion routines here
static char* ConvertString_RawToSCMD2(const char* rawtext) {
	// calculate string length
	int slen = 0;
	for(const char *p = rawtext ; *p ; p++) {
		if(*p == '\n' || *p == '\r' || *p == '\t') slen++; // as-is
		else if(0 < *p && *p < 32) slen += 4; // <%02X>
		else if(*p == '<' || *p == '>') slen += 2; // "\\>", "\\<"
		else slen++; // as-is
	}

	char* outtext = (char*)scmd2_malloc(slen + 1);
	char* outp = outtext;

	for(const BYTE *p = (BYTE*)rawtext ; *p ; p++) {
		if(*p == '\n' || *p == '\r' || *p == '\t') *outp++ = *p;
		else if(0 < *p && *p < 32) {
			*outp++ = '<';
			*outp++ = XDigitToChar(*p >> 4);
			*outp++ = XDigitToChar(*p & 0xF);
			*outp++ = '>';
		}

		else if(*p == '<' || *p == '>') {
			*outp++ = '\\';
			*outp++ = *p;
		}

		else *outp++ = *p;
	}

	*outp = 0;
	return outtext;
}


static char* ConvertString_SCMD2ToRaw(const char* scmd2text) {
	int slen = strlen(scmd2text);
	char *text = (char*)scmd2_malloc(slen + 1);
	char *pout = text, *porigtext = text;
	memset(text, 0, slen + 1);

	const char* p;
	for(p = scmd2text ; *p != 0 ; p++) {
		if(strncmp((const char*)p, "\\<", 2) == 0) {
			*pout++ = '<';
			p += 1;
		}

		else if(strncmp((const char*)p, "\\>", 2) == 0) {
			*pout++ = '>';
			p += 1;
		}

		else if(strncmp((const char*)p, "<R>", 3) == 0) {
			*pout++ = 0x12;
			p += 2;
		}

		else if(strncmp((const char*)p, "<C>", 3) == 0) {
			*pout++ = 0x13;
			p += 2;
		}

		else if(p[0] == '<' && isxdigit(p[1]) && p[2] == '>') {
			*pout++ = ParseXDigit(p[1]);
			p += 2;
		}

		else if(p[0] == '<' && isxdigit(p[1]) && isxdigit(p[2]) && p[3] == '>') {
			*pout++ = ParseXDigit(p[1]) << 4 | ParseXDigit(p[2]);
			p += 3;
		}

		else if(p[0] == '\r') continue; //ignore
		else *pout++ = *p;
	}

	*pout = 0;
	return text;
}


// -1 index patch
int __stdcall StringTable_FindString(SI_VirtSCStringList* strtb, const char *string) {
	if(*string == 0) return 0; //empty string
	else {
		int retval = StringTable_FindString_RawIndex(strtb, string);
		if(retval == -1) return -1;
		else return retval + 1;
	}
}


//SCMD2Text patch
int __stdcall StringTable_AddString(SI_VirtSCStringList *strtb, const char *text, int SectionName, char AlwaysCreate) {
	char* scmd2text = ConvertString_RawToSCMD2(text);
	int retval = StringTable_AddSCMD2String(strtb, scmd2text, SectionName, AlwaysCreate);
	scmd2_free(scmd2text);
	return retval;
}

char __stdcall StringTable_SetText(SI_VirtSCStringList *strtb, const char *string, int stringID) {
	char* scmd2text = ConvertString_RawToSCMD2(string);
	int retval = StringTable_SetSCMD2Text(strtb, scmd2text, stringID);
	scmd2_free(scmd2text);
	return retval;
}
