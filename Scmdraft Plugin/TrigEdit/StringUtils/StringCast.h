#pragma once

#include <string>

// Raw string <-> C-style conversion
std::string CString2Raw(const std::string& formatted);
std::string Raw2CString(const std::string& rawstr);

// String <-> number conversion
int String2Int(const std::string& formatted);
std::string Int2String(int value);