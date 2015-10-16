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

#include "../Lua/lib/lua.hpp"
#include "../TriggerEditor.h"

bool CallConditionHook(lua_State* L, const TrigCond& cond, std::string& ret)
{
	lua_getglobal(L, "__trigeditplus_conditionhooks");
	lua_pushnil(L);
	while(lua_next(L, -2) != 0)
	{
		lua_pushinteger(L, cond.locid);
		lua_pushinteger(L, cond.player);
		lua_pushinteger(L, cond.res);
		lua_pushinteger(L, cond.uid);
		lua_pushinteger(L, cond.setting);
		lua_pushinteger(L, cond.condtype);
		lua_pushinteger(L, cond.res_setting);
		lua_pushinteger(L, cond.prop);

		if(lua_pcall(L, 8, 1, 0) != LUA_OK)
		{
			fprintf(stderr, "[CallConditionHook] Error on parsing condition (%d, %d, %d, %d, %d, %d, %d, %d) :\n%s\n",
				cond.locid, cond.player, cond.res, cond.uid, cond.setting, cond.condtype, cond.res_setting, cond.prop,
				lua_tostring(L, -1));
			lua_pop(L, 1);
		}
		else if(lua_isstring(L, -1))
		{
			ret = lua_tostring(L, -1);
			lua_pop(L, 2);
			return true;
		}
		else lua_pop(L, 1);
	}
	lua_pop(L, 1);
	return false;
}



bool CallActionHook(lua_State* L, const TrigAct& act, std::string& ret)
{
	lua_getglobal(L, "__trigeditplus_actionhooks");
	lua_pushnil(L);
	while(lua_next(L, -2) != 0)
	{
		lua_pushinteger(L, act.locid);
		lua_pushinteger(L, act.strid);
		lua_pushinteger(L, act.wavid);
		lua_pushinteger(L, act.time);
		lua_pushinteger(L, act.player);
		lua_pushinteger(L, act.target);
		lua_pushinteger(L, act.setting);
		lua_pushinteger(L, act.acttype);
		lua_pushinteger(L, act.num);
		lua_pushinteger(L, act.prop);

		if(lua_pcall(L, 10, 1, 0) != LUA_OK)
		{
			fprintf(stderr, "[CallActionHook] Error on parsing condition (%d, %d, %d, %d, %d, %d, %d, %d, %d, %d) :\n%s\n",
				act.locid, act.strid, act.wavid, act.time, act.player, act.target, act.setting, act.acttype, act.num, act.prop,
				lua_tostring(L, -1));
			lua_pop(L, 1);
		}
		else if(lua_isstring(L, -1))
		{
			ret = lua_tostring(L, -1);
			lua_pop(L, 2);
			return true;
		}
		else lua_pop(L, 1);
	}
	lua_pop(L, 1);
	return false;
}
