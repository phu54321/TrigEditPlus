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
