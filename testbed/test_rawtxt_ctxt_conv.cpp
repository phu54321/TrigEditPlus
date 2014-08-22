#include <string>
#include <iostream>

static int ParseXDigit(int ch) {
	if('0' <= ch && ch <= '9') return ch - '0';
	else if('a' <= ch && ch <= 'f') return ch - 'a' + 10;
	else if('A' <= ch && ch <= 'F') return ch - 'A' + 10;
	else return -1;
}


static char XDigitToChar(int hexdigit) {
	if(0 <= hexdigit && hexdigit <= 9) return '0' + hexdigit;
	else if(10 <= hexdigit && hexdigit <= 15) return 'A' + (hexdigit - 10);
	else return '*';
}


std::string EncodeRawString(const std::string& str) {
	const int slen = str.size();
	char *output = new char[slen * 4 + 3];
	char *p = output;

    for(auto ch : str) {
        switch(ch) {
        case '\\':  *p++ = '\\'; *p++ = '\\'; break;
        case '\"':  *p++ = '\\'; *p++ = '\"'; break;
        case '\n':  *p++ = '\\'; *p++ = 'n'; break;
        case '\r':  *p++ = '\\'; *p++ = 'r'; break;
        case '\t':  *p++ = '\\'; *p++ = 't'; break;
        default:
            {
                if(1 <= ch && ch <= 31) { //Special characters
                    *p++ = '\\';
                    *p++ = 'x';
                    *p++ = ParseXDigit(*p >> 4);
                    *p++ = ParseXDigit(*p & 0xf);
                }

                else {
                    *p++ = ch;
                }
            }
        }
    }
    *p = '\0';
	std::string s(output);
	delete[] output;
	return s;
}

std::string DecodeRawString(const std::string& str) {
	const int slen = str.size();
	char *output = new char[slen * 4 + 1];
	char *p = output;

    for(int i = 0 ; i < slen ; ) {
		char ch = str[i];
		
        if(ch == '\\') {
			if(i+1 == slen) { // "\\\0". treat as \\.
                *p++ = '\\';
				i++;
                continue;
            }

			char nextchar = str[i+1];
			/**/ if(nextchar == '\\') {* p++ = '\\'; i+=2; }
            else if(nextchar == '\"') { *p++ = '\"'; i+=2; }
            else if(nextchar == 'n') { *p++ = '\n'; i+=2; }
            else if(nextchar == 'r') { *p++ = '\r'; i+=2; }
            else if(nextchar == 't') { *p++ = '\t'; i+=2; }
            else if(nextchar == 'x') {
				if(i+3 >= slen) { //treat as stray \x
					*p++ = '\\';
					*p++ = 'x';
					i += 2;
				}
				else {
					char hex1 = ParseXDigit(str[i+2]);
					char hex2 = ParseXDigit(str[i+3]);
					if(hex1 == -1 || hex2 == -1) { // \x*& thing. treat \x as stray \x.
						*p++ = '\\';
						*p++ = 'x';
						i += 2;
					}
					else {
						*p++ = hex1<<4 | hex2;
						i += 4;
					}
				}
            }
			else { // normal characters.
				*p = ch;
				i++;
			}
        }
        else {
			*p++ = ch;
			i++;
		}
    }

    *p = '\0';
	std::string s(output);
	delete[] output;
	return s;
}

int main() {
	while(1) {
		char buf[512];
		fgets(buf, 512, stdin);
		std::string s = DecodeRawString(buf);
		std::cout << s << std::endl;
	}
	getchar();
	return 0;
}