#include "StringCast.h"
#include "../EncodeError.h"


static int ParseXDigit(int ch) {
	if('0' <= ch && ch <= '9') return ch - '0';
	else if('a' <= ch && ch <= 'f') return ch - 'a' + 10;
	else if('A' <= ch && ch <= 'F') return ch - 'A' + 10;
	else return -1;
}


static char XDigitToChar(int hexdigit) {
	if(0 <= hexdigit && hexdigit <= 9) return '0' + hexdigit;
	else if(10 <= hexdigit && hexdigit <= 15) return 'A' + (hexdigit - 10);
	else return -1;
}


// Raw string -> C-style escaped string
std::string Raw2CString(const std::string& str) {
	const size_t slen = str.size();
	char *output = new char[slen * 4 + 3];
	char *p = output;

	*p++ = '\"';

    for(unsigned char ch : str) {
        switch(ch) {
        case '\\':  *p++ = '\\'; *p++ = '\\'; break;
        case '\"':  *p++ = '\\'; *p++ = '\"'; break;
        case '\n':  *p++ = '\\'; *p++ = 'n'; break;
        case '\r':  *p++ = '\\'; *p++ = 'r'; break;
        case '\t':  *p++ = '\\'; *p++ = 't'; break;
        default:
            {
                if(0x1C <= ch && 0x1F <= 31) {
					// 0x1C ~ 0x1F are not representable on windows editbox.
                    *p++ = '\\';
                    *p++ = 'x';
                    *p++ = XDigitToChar(ch >> 4);
                    *p++ = XDigitToChar(ch & 0xf);
                }

                else {
                    *p++ = ch;
                }
            }
        }
    }
    
	*p++ = '\"';
	*p = '\0';
	std::string s(output);
	delete[] output;
	return s;
}


// C-style escaped string -> Raw string
std::string CString2Raw(const std::string& str) {
	const size_t slen = str.size();
	
	// Check " at each side of the string
	if(slen <= 1 || str[0] != '\"' || str[slen - 1] != '\"') {
		char errmsg[512];
		sprintf(errmsg, "Cannot parse %.30s as string", str.c_str());
		throw EncodeError(errmsg);
	}

	/* TODO : IMPLEMENT THIS */
	return "";
}