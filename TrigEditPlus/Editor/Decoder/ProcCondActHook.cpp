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
#include <sstream>

TriggerEditor* LuaGetEditor(lua_State* L);

static int stderr_errorreporter(lua_State* L)
{
	std::stringstream ss;
	ss << "Error on hook processing";

	// Create traceback
	lua_State *L1 = luaL_newstate();
	luaL_traceback(L1, L, NULL, 1);
	ss << "error : " << lua_tostring(L, -1) << "\n" << lua_tostring(L1, -1);
	lua_close(L1);

	// Messagebox
	auto te = LuaGetEditor(L);
	MessageBox(te->hTrigDlg, ss.str().c_str(), "Error", MB_OK);
	return 0;
}


bool DecodeConditions(lua_State* L, const TrigCond conds[16], std::string* ret)
{
	lua_pushcfunction(L, stderr_errorreporter);
	int errrp_f = lua_gettop(L);

	lua_getglobal(L, "ProcessConditionHooks");
	lua_newtable(L);
	for(int i = 0; i < 16; i++)
	{
		const TrigCond& cond = conds[i];
		if(cond.condtype == 0) break;

		lua_pushinteger(L, i + 1);

		lua_newtable(L);
		lua_pushinteger(L, 1); lua_pushinteger(L, cond.locid); lua_rawset(L, -3);
		lua_pushinteger(L, 2); lua_pushinteger(L, cond.player); lua_rawset(L, -3);
		lua_pushinteger(L, 3); lua_pushinteger(L, cond.res); lua_rawset(L, -3);
		lua_pushinteger(L, 4); lua_pushinteger(L, cond.uid); lua_rawset(L, -3);
		lua_pushinteger(L, 5); lua_pushinteger(L, cond.setting); lua_rawset(L, -3);
		lua_pushinteger(L, 6); lua_pushinteger(L, cond.condtype); lua_rawset(L, -3);
		lua_pushinteger(L, 7); lua_pushinteger(L, cond.res_setting); lua_rawset(L, -3);
		lua_pushinteger(L, 8); lua_pushinteger(L, cond.prop); lua_rawset(L, -3);
		lua_pushstring(L, "__trg_magic"); lua_pushstring(L, "condition"); lua_rawset(L, -3);

		lua_rawset(L, -3);
	}

	if(lua_pcall(L, 1, 1, errrp_f) != LUA_OK)
	{
		lua_pop(L, 2);
		return false;
	}
	else
	{
		for(int i = 0; i < 16; i++)
		{
			if(conds[i].condtype == 0) break;
			lua_pushinteger(L, i + 1);
			lua_rawget(L, -2);
			ret[i].assign(lua_tostring(L, -1));
		}
	}
	return false;
}



bool CallActionHook(lua_State* L, const TrigAct acts[16], std::string* ret)
{
	_currentHookType = HOOK_ACTION;
	_currentObject = (void*)&act;

	lua_getglobal(L, "ProcessActionHook");
	lua_pushcfunction(L, stderr_errorreporter);
	int errrp_f = lua_gettop(L);

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

	if(lua_pcall(L, 11, 1, errrp_f) != LUA_OK)
	{
		lua_pop(L, 1);
	}
	else if(lua_isstring(L, -1))
	{
		ret = lua_tostring(L, -1);
		lua_pop(L, 1);
		return true;
	}
	return false;
}
