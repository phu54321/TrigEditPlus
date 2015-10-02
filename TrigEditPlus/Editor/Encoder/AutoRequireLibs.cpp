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

#include "Lua/lua.hpp"
#include <Windows.h>
#include <vector>

static void LuaRequire(lua_State* L, const char* modulePath, const char* moduleName)
{
	FILE* fp = fopen(modulePath, "rb");
	if(fp == NULL) return;
	fseek(fp, 0, SEEK_END);
	size_t fsize = ftell(fp);
	std::vector<char> fcontent(fsize);
	rewind(fp);
	fread(fcontent.data(), 1, fsize, fp);
	fclose(fp);

	luaL_loadbuffer(L, fcontent.data(), fsize, moduleName);
	lua_pcall(L, 0, LUA_MULTRET, 0);
}

void LoadUserLuaLibs(lua_State* L)
{
	char path[MAX_PATH];
	GetModuleFileName(NULL, path, MAX_PATH);
	char *lastslash = strrchr(path, '\\');
	if(!lastslash) lastslash = path;
	else lastslash++;
	strcpy(lastslash, "lua\\*.lua");
	lastslash += 4;

	WIN32_FIND_DATA ffd;
	HANDLE hFind = FindFirstFile(path, &ffd);
	if(INVALID_HANDLE_VALUE == hFind) return;
	do
	{
		if(ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
		else
		{
			strcpy(lastslash, ffd.cFileName);
			LuaRequire(L, path, ffd.cFileName);
		}
	} while(FindNextFile(hFind, &ffd) != 0);

	FindClose(hFind);
}