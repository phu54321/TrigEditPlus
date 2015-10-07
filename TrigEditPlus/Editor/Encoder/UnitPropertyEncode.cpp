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

#include <map>
#include <vector>

#include "../Lua/lib/lua.hpp"
#include "../UnitProp.h"

int LuaErrorf(lua_State* L, const char* format, ...);

// operator< for std::map key
bool operator<(const UPRPData& l, const UPRPData& r) {
	return memcmp(&l, &r, sizeof(UPRPData)) < 0;
}

std::map<UPRPData, int> _uprpmap;
std::vector<UPRPData> _uprpvec;


void ClearPropertyMap() {
	_uprpmap.clear();
	_uprpvec.clear();
}

char* GetUPRPChunkData() {
	static char uprpdata[1280];
	memset(uprpdata, 0, 1280);

	for(size_t i = 0 ; i < _uprpvec.size() ; i++) {
		memcpy(uprpdata + 20 * i, &_uprpvec[i], 20);
	}

	return uprpdata;
}


int LuaParseProperty(lua_State* L) {
	if(lua_isnumber(L, -1)) return 1; // return as-is;

	if(!lua_istable(L, -1)) {
		lua_pushstring(L, "Invalid value given to property");
		lua_error(L);
	}

	UPRPData uprpd;
	memset(&uprpd, 0, sizeof(uprpd));

	// Encode special properties
	struct SPRPEntry {
		const char* name;
		int flagvalue;
	} sprpentry[5] = {
		{"clocked"      , 1<<0},
		{"burrowed"     , 1<<1},
		{"intransit"    , 1<<2},
		{"hallucinated" , 1<<3},
		{"invincible"   , 1<<4},
	};

	for(int i = 0 ; i < 5 ; i++) {
		lua_pushstring(L, sprpentry[i].name);
		lua_gettable(L, -2);
		
		if(lua_isboolean(L, -1)) {
			int flag = lua_toboolean(L, -1);
			uprpd.sprpvalid |= sprpentry[i].flagvalue;
			if(flag) uprpd.sprpflag |= sprpentry[i].flagvalue;
		}

		lua_pop(L, 1);
	}


	// Encode properties
#define CreatePrpParser(NAME, FLAGVALUE) \
	for(int i = 0 ; i < 5 ; i++) {\
		lua_pushstring(L, #NAME );\
		lua_gettable(L, -2);\
		\
		if(lua_isnumber(L, -1)) {\
		int num = luaL_checkinteger(L, -1);\
		uprpd.prpvalid |= FLAGVALUE;\
		uprpd.NAME = num;\
		}\
		lua_pop(L, 1);\
	}

	CreatePrpParser(hitpoint,   1<<1);
	CreatePrpParser(shield,     1<<2);
	CreatePrpParser(energy,     1<<3);
	CreatePrpParser(resource,   1<<4);
	CreatePrpParser(hanger,     1<<5);


	// Check for duplicates
	auto it = _uprpmap.find(uprpd);
	if(it != _uprpmap.end()) {
		lua_pushnumber(L, it->second);
		return 1;
	}


	// create new entry
	if(_uprpmap.size() == 64) {
		lua_pushstring(L, "Too many properties (>64) used inside triggers.");
		lua_error(L);
	}

	int prpindex = _uprpmap.size() + 1;
	_uprpmap.insert(std::make_pair(uprpd, prpindex));
	_uprpvec.push_back(uprpd);
	lua_pushnumber(L, prpindex);
	return 1;
}

