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
#include "../UnitProp.h"

TriggerEditor* LuaGetEditor(lua_State* L);

#define LUA_MAKENSDECODER(target, targetstr) \
int LuaDecode ## target (lua_State* L) {\
    TriggerEditor* e = LuaGetEditor(L);\
\
    /* not number -> return as-is */ \
	if(lua_type(L, -1) != LUA_TNUMBER) { \
        return 1; /* return arg1 as ret1. */ \
	}\
\
    /* string -> parse */ \
    int id = luaL_checkint(L, -1);\
	lua_pushstring(L, e->Decode ## target(id).c_str()); \
    return 1;\
}\

LUA_MAKENSDECODER(Unit, "unit name");
LUA_MAKENSDECODER(Location, "location");
LUA_MAKENSDECODER(SwitchName, "switch");
LUA_MAKENSDECODER(String, "string"); // This won't make any error.


std::string DecodeUPRPData(const UPRPData* data);
int LuaDecodeUPRP(lua_State* L)
{
	TriggerEditor* e = LuaGetEditor(L);

	/* not number -> return as-is */
	if(lua_type(L, -1) != LUA_TNUMBER)
	{
		return 1; /* return arg1 as ret1. */
	}
	int id = luaL_checkint(L, -1);
	UPRPData* uprp = &((UPRPData*)e->_editordata->UnitProperties->ChunkData)[id - 1];
	lua_pushstring(L, DecodeUPRPData(uprp).c_str());
	return 1;
}
