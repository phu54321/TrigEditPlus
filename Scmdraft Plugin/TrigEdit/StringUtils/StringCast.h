#pragma once

#include <string>

// Raw string <-> C-style conversion
std::string Raw2CString(const std::string& rawstr);

// String <-> number conversion
std::string Int2String(int value);