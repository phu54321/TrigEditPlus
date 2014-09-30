#include "../TriggerEditor.h"
#include "Lua/lua.hpp"

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

