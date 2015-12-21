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
#include <algorithm>

TriggerEditor* LuaGetEditor(lua_State* L);

#define HOOK_CONDITION 0
#define HOOK_ACTION 1

int _currentHookType;
const void* _currentObject;


int stderr_errorreporter(lua_State* L)
{
	std::stringstream ss;

	// Create error header
	char errheader[512] = "";
	if(_currentHookType == HOOK_CONDITION)
	{
		TrigCond& cond = *(TrigCond*)_currentObject;
		sprintf(errheader, "[CallConditionHook] Error on parsing condition (%d, %d, %d, %d, %d, %d, %d, %d)\n\n",
			cond.locid, cond.player, cond.res, cond.uid, cond.setting, cond.condtype, cond.res_setting, cond.prop);
	}
	else if(_currentHookType == HOOK_ACTION)
	{
		TrigAct& act = *(TrigAct*)_currentObject;
		sprintf(errheader, "[CallActionHook] Error on parsing condition (%d, %d, %d, %d, %d, %d, %d, %d, %d, %d)\n\n",
			act.locid, act.strid, act.wavid, act.time, act.player, act.target, act.setting, act.acttype, act.num, act.prop);
	}
	ss << errheader;

	// Create traceback
	lua_State *L1 = luaL_newstate();
	luaL_traceback(L1, L, nullptr, 1);
	ss << "error : " << lua_tostring(L, -1) << "\n" << lua_tostring(L1, -1);
	lua_close(L1);

	// Messagebox
	auto te = LuaGetEditor(L);
	MessageBox(te->hTrigDlg, ss.str().c_str(), "Error", MB_OK);
	return 0;
}


bool CallConditionHook(lua_State* L, const TrigCond& cond, std::string& ret)
{
	_currentHookType = HOOK_CONDITION;
	_currentObject = reinterpret_cast<const void*>(&cond);

	lua_getglobal(L, "ProcessConditionHook");
	lua_pushcfunction(L, stderr_errorreporter);
	int errrp_f = lua_gettop(L);
	lua_pushinteger(L, cond.locid);
	lua_pushinteger(L, cond.player);
	lua_pushinteger(L, cond.res);
	lua_pushinteger(L, cond.uid);
	lua_pushinteger(L, cond.setting);
	lua_pushinteger(L, cond.condtype);
	lua_pushinteger(L, cond.res_setting);
	lua_pushinteger(L, cond.prop);
	if(lua_pcall(L, 9, 1, errrp_f) != LUA_OK)
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



bool CallActionHook(lua_State* L, const TrigAct& act, std::string& ret)
{
	_currentHookType = HOOK_ACTION;
	_currentObject = reinterpret_cast<const void*>(&act);

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
		ret.erase(std::remove(ret.begin(), ret.end(), '\n'), ret.end());
		ret.erase(std::remove(ret.begin(), ret.end(), '\r'), ret.end());
		lua_pop(L, 1);
		return true;
	}
	return false;
}
