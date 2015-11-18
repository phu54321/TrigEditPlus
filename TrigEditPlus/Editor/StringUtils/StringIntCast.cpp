#include "StringCast.h"

std::string Int2String(int value) {
	char str[512];
	_itoa(value, str, 10);
	return str;
}
