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
#include "../Lua/LuaCommon.h"

TriggerEditor* LuaGetEditor(lua_State* L);

int LuaEncodeSpecialData(lua_State* L)
{
	// Get arguments
	int callerLine = luaL_checkint(L, -3);
	uint32_t code = luaL_checkinteger(L, -2);
	const char* data = luaL_checkstring(L, -1);
	int datalen = lua_rawlen(L, -1);

	// Pack to trigger
	int condlen = min(datalen, 296);
	int actlen = min(datalen - condlen, 32 * 63);
	
	Trig outputTrigger;
	memset(&outputTrigger, 0, 2400);
	memcpy(&outputTrigger.cond[1], &code, 4);
	memcpy(reinterpret_cast<char*>(&outputTrigger.cond[1]) + 4, data, condlen);
	memcpy(&outputTrigger.act[1], data + condlen, actlen);

	// Add to trigger list
	TriggerEditor* e = LuaGetEditor(L);
	TrigBufferEntry tbe = { outputTrigger, callerLine };
	e->_trigbuffer.push_back(tbe);

	return 0;

}