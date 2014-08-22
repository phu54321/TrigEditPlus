#include "StringCast.h"
#include "../EncodeError.h"

std::string Int2String(int value) {
	char str[512];
	sprintf(str, "%d", value);
	return str;
}

int String2Int(const std::string& str) {
	int number;
	if(sscanf(str.c_str(), "%i", &number) == 0) {
		char errmsg[512];
		sprintf(errmsg, "Cannot parse string \"%s\"", str.c_str());
		throw EncodeError(errmsg);
	}
	return number;
}
