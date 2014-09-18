/*
#define SCFIND_WHOLEWORD 0x2
#define SCFIND_MATCHCASE 0x4
#define SCFIND_WORDSTART 0x00100000
#define SCFIND_REGEXP 0x00200000
#define SCFIND_POSIX 0x00400000
*/

#include <string>
#include "../Scintilla/Scintilla.h"

struct SearchQuery {
	std::string searchFor;
	std::string replaceTo;

	unsigned int searchFlag;
};

