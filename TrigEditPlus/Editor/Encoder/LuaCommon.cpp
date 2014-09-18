#include "LuaCommon.h"

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <vector>

#include "Lua/lua.hpp"


int LuaErrorf(lua_State* L, const char* format, ...) {
	char errmsg[512];
	va_list v;
	va_start(v, format);
	vsnprintf(errmsg, 512, format, v);
	va_end(v);

	lua_pushstring(L, errmsg);
	return lua_error(L);
}

void LuaCheckTableEntry(lua_State* L, std::vector<std::string> accepted) {
	if(!lua_istable(L, -1)) {
		LuaErrorf(L, "table expected, got %s", lua_typename(L, lua_type(L, -1)));
		return;
	}

	lua_pushnil(L);
	/* table is in the stack at index 't' */
	lua_pushnil(L);  /* first key */
	while (lua_next(L, -2) != 0) {
		lua_pop(L, 1); // Remove value.

		if(!lua_isstring(L, -1)) {
			LuaErrorf(L, "table has non-string key of type %s", lua_typename(L, lua_type(L, -1)));
			return;
		}

		const char* key = lua_tostring(L, -1);
		bool accept = false;
		for(auto entryname : accepted) {
			if(key == entryname) accept = true;
		}

		if(!accept) {
			LuaErrorf(L, "unknown key %s to table", key);
			return;
		}
	}
}
