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

#include "../TriggerEditor.h"
#include "lib/lua.hpp"
#include "../../resource.h"
#include <Windows.h>
#include <vector>


void LuaRunResource(lua_State* L, LPCSTR respath, LPCSTR resname)
{
	HRSRC res = FindResource(hInstance, respath, RT_RCDATA);
	if(res)
	{
		HGLOBAL resd = LoadResource(hInstance, res);
		size_t fsize = SizeofResource(hInstance, res);
		void* data = LockResource(resd);
		char* str = new char[fsize + 1];
		memcpy(str, data, fsize);
		str[fsize] = '\0';
		UnlockResource(resd);

		if(luaL_loadbuffer(L, str, fsize, resname) || lua_pcall(L, 0, 0, 0))
		{
			char str[1024];
			_snprintf(str, 1023, "resource \"%s\" load failed : \n%s", resname, lua_tostring(L, -1));
			str[1023] = '\0';
			MessageBox(NULL, str, "lua init error", MB_OK);
			lua_pop(L, 1);
		}
		delete[] str;
	}
	else
	{
		char str[1024];
		_snprintf(str, 1023, "resource \"%s\" load failed : %d\n", resname, GetLastError());
		str[1023] = '\0';
		MessageBox(NULL, str, "lua init error", MB_OK);
	}
}


static void LuaRequire(lua_State* L, const char* modulePath, const char* moduleName)
{
	FILE* fp = fopen(modulePath, "rb");
	if(fp == NULL) return;
	fseek(fp, 0, SEEK_END);
	size_t fsize = ftell(fp);
	std::vector<char> fcontent(fsize);
	rewind(fp);
	fread(fcontent.data(), 1, fsize, fp);
	fclose(fp);

	if(luaL_loadbuffer(L, fcontent.data(), fsize, moduleName) || lua_pcall(L, 0, 0, 0))
	{
		char str[1024];
		_snprintf(str, 1023, "resource \"%s\" load failed : \n%s", moduleName, lua_tostring(L, -1));
		str[1023] = '\0';
		MessageBox(NULL, str, "lua init error", MB_OK);
		lua_pop(L, 1);
	}
}


// Recursive directory iterator
void LoadUserLuaLibs_Sub(lua_State* L)
{
	WIN32_FIND_DATA ffd;
	HANDLE hFind = FindFirstFile("*.*", &ffd);
	if(INVALID_HANDLE_VALUE == hFind) return;
	do
	{
		if(ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
		{
			if(ffd.cFileName[0] != '.' && SetCurrentDirectory(ffd.cFileName))
			{
				LoadUserLuaLibs_Sub(L);
				SetCurrentDirectory("..");
			}
		}
		else
		{
			// Check extension
			int slen = strlen(ffd.cFileName);
			if(slen > 4 && strcmp(ffd.cFileName + slen - 4, ".lua") == 0)
			{
				LuaRequire(L, ffd.cFileName, ffd.cFileName);
			}
		}
	} while(FindNextFile(hFind, &ffd) != 0);

	FindClose(hFind);
}



BOOL DirectoryExists(LPCTSTR szPath)
{
	DWORD dwAttrib = GetFileAttributes(szPath);

	return (dwAttrib != INVALID_FILE_ATTRIBUTES &&
		(dwAttrib & FILE_ATTRIBUTE_DIRECTORY));
}


void LoadUserLuaLibs(lua_State* L)
{
	// Backup current directory
	char currentPath[MAX_PATH];
	GetCurrentDirectory(MAX_PATH, currentPath);

	// Goto root directory
	char path[MAX_PATH];
	GetModuleFileName(NULL, path, MAX_PATH);
	char *lastslash = strrchr(path, '\\');
	if(!lastslash) lastslash = path;
	else lastslash++;
	strcpy(lastslash, "lua");
	
	// If 'lua' directory exists -> require all
	if (SetCurrentDirectory(path)) {
		// Check if #basescript folder exists. If they do, then bug can occur.
		if(DirectoryExists(TEXT("#basescript")))
		{
			MessageBox(NULL, "[Warning] Remove \"lua\\#basescript\" directory.", "Potential bug", MB_OK);
		}
		LoadUserLuaLibs_Sub(L);
		SetCurrentDirectory(currentPath);
	}
}



// --------------------

int LuaLog(lua_State* L);

int LuaEncodeUnit(lua_State* L);
int LuaEncodeLocation(lua_State* L);
int LuaEncodeSwitchName(lua_State* L);
int LuaEncodeString(lua_State* L);
int LuaEncodeUPRP(lua_State* L);

int LuaDecodeUnit(lua_State* L);
int LuaDecodeLocation(lua_State* L);
int LuaDecodeSwitchName(lua_State* L);
int LuaDecodeString(lua_State* L);
int LuaDecodeUPRP(lua_State* L);

void LuaAutoRequireLibs(lua_State* L)
{
	luaL_openlibs(L);

	// Load basic script.
	// basescript.lua contains case-insensitive patch, so this should be called
	// before any variable is declared

	// Load basic functions.
	
	lua_register(L, "Log", LuaLog);

	// Parse~ keeped for back-compatibility
	lua_register(L, "ParseUnit", LuaEncodeUnit);
	lua_register(L, "ParseLocation", LuaEncodeLocation);
	lua_register(L, "ParseSwitchName", LuaEncodeSwitchName);
	lua_register(L, "ParseString", LuaEncodeString);
	lua_register(L, "ParseUPRP", LuaEncodeUPRP);

	// Encoder
	lua_register(L, "EncodeUnit", LuaEncodeUnit);
	lua_register(L, "EncodeLocation", LuaEncodeLocation);
	lua_register(L, "EncodeSwitchName", LuaEncodeSwitchName);
	lua_register(L, "EncodeString", LuaEncodeString);
	lua_register(L, "EncodeUPRP", LuaEncodeUPRP);

	// Decoder
	lua_register(L, "DecodeUnit", LuaDecodeUnit);
	lua_register(L, "DecodeLocation", LuaDecodeLocation);
	lua_register(L, "DecodeSwitchName", LuaDecodeSwitchName);
	lua_register(L, "DecodeString", LuaDecodeString);
	lua_register(L, "DecodeUPRP", LuaDecodeUPRP);

	LuaRunResource(L, MAKEINTRESOURCE(IDR_BASESCRIPT), "basescript");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_LUAHOOK), "luahook");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_STOCKCOND), "stockcond");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_STOCKACT), "stockact");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_STOCKCONDHOOK), "stockcondhook");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_STOCKACTHOOK), "stockacthook");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_CONSTPARSER), "constparser");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_CONSTDECODER), "constdecoder");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_MEMSMEM), "memsmem");
	LuaRunResource(L, MAKEINTRESOURCE(IDR_SPECIALDATA), "specialdata");

	// Load user-specific scripts.
	// NOTE : USER LIBRARY SHOULDN'T ADD ANY TRIGGERS OR SOMETHING. TO ENFORCE IT, WE LOAD
	// USER LIBRARY BEFORE DECLARING VARIOUS __internal__AddTrigger function.
	LoadUserLuaLibs(L);

	// Sort hooks
	lua_getglobal(L, "SortHooks");
	lua_call(L, 0, 0);
}
