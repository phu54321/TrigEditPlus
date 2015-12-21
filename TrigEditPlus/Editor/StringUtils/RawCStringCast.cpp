#include "StringCast.h"


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
	char *output = static_cast<char*>(alloca(slen * 4 + 3));
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
                if(1 <= ch && ch <= 31) {
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
	return s;
}
