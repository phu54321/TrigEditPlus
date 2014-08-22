#include "StringCast.h"

std::string Int2String(int value) {
	char str[512];
	sprintf(str, "%d", value);
	return str;
}
