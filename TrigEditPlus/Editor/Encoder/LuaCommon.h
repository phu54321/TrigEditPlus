#pragma once

#include "Lua/lua.hpp"
#include <vector>

int LuaErrorf(lua_State* L, const char* format, ...);
void LuaCheckTableEntry(lua_State* L, std::vector<std::string> accepted);
