/*
 * Copyright (c) 2014 trgk(phu54321@naver.com)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "LuaCommon.h"

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <vector>

#include "lib/lua.hpp"


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
			LuaErrorf(L, "\"%s\" as a key of this table is disallowed", key);
			return;
		}
	}
}
