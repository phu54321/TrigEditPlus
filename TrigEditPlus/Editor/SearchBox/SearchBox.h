#pragma once

#include <string>

#define SEARCHMODE_FIND        0
#define SEARCHMODE_FINDALL     1
#define SEARCHMODE_REPLACE     2
#define SEARCHMODE_REPLACEALL  3

#define SEARCHFLAG_USEREGEXP      0x1
#define SEARCHFLAG_CASESENSITIVE  0x2
#define SEARCHFLAG_WHOLEWORD      0x4
#define SEARCHFLAG_INSELECTION    0x10

struct SearchQuery {
	std::string searchFor;
	std::string replaceTo;
	int mode; // 0:find, 1:findall 2:replace 3:replaceall
	unsigned int searchFlag;
};

int RunSearchBox(HWND parent, const char* query);
int QuitSearchBox();