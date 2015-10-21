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

#include "../TriggerEditor.h"
#include "../Lua/lib/lua.hpp"

TriggerEditor* LuaGetEditor(lua_State* L);

#define LUA_MAKENSPARSER(target, targetstr) \
int LuaParse ## target (lua_State* L) {\
    TriggerEditor* e = LuaGetEditor(L);\
\
    /* number -> return as-is */ \
    /* if(lua_isnumber(L, -1)) { <-- Don't use this. Argument may be "00" thing */ \
	if(lua_type(L, -1) == LUA_TNUMBER) { \
        return 1; /* return arg1 as ret1. */ \
    }\
\
    /* string -> parse */ \
    const char* unitname = luaL_checkstring(L, -1);\
	int unitid = e->Encode ## target(unitname);\
    if(unitid == -1) {\
        char errmsg[512];\
        sprintf(errmsg, "Cannot parse string \"%.30s\" as " targetstr, unitname);\
        lua_pushstring(L, errmsg);\
        return lua_error(L);\
    }\
\
    lua_pushnumber(L, unitid);\
    return 1;\
}\

LUA_MAKENSPARSER(Unit, "unit name");
LUA_MAKENSPARSER(Location, "location");
LUA_MAKENSPARSER(SwitchName, "switch");
LUA_MAKENSPARSER(String, "string"); // This won't make any error.

