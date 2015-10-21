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

#include "LuaKeywords.h"

static std::vector<std::string> LuaGetGlobalNameList(lua_State* L)
{
	std::vector<std::string> ret;

	lua_pushglobaltable(L);
	lua_pushnil(L);

	while(lua_next(L, -2) != 0)
	{
		const char* str = lua_tostring(L, -2);
		if(str[0] != '_') ret.push_back(str);
		lua_pop(L, 1);
	}

	lua_pop(L, 1);
	return ret;
}

static std::vector<std::string> _keywords;

void UpdateLuaKeywords(lua_State* L)
{
	_keywords = LuaGetGlobalNameList(L);
}

const std::vector<std::string>& GetLuaKeywords()
{
	return _keywords;
}
