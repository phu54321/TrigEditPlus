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

#include "SCMDPlugin.h"

HWND hSCMD2MainWindow;
HINSTANCE hSCMD2Instance;
HINSTANCE hInstance;

AllocRam scmd2_malloc;
DeAllocRam scmd2_free; 
ReAllocRam scmd2_realloc;

// User-supplied code.
void Initialize();
void Finalize();

extern const char* PluginMenuName;


BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
	hInstance = (HINSTANCE)hModule;

	switch(ul_reason_for_call) {
	case DLL_PROCESS_DETACH:
		Finalize();
		break;
	}

	return true;
}




//	DO NOT EDIT THIS !
DWORD WINAPI GetPluginVersion(void)
{
	return PLUGINVERSION;
}




BOOL WINAPI InitPlugin(	HWND MainWindow, 
						HINSTANCE MainInstance, 
						AllocRam AllocMem, 
						DeAllocRam DeleteMem, 
						ReAllocRam ResizeMem, 
						DWORD* RequestedSections	)	//	DWORD[8]
{
	hSCMD2MainWindow = MainWindow;
	hSCMD2Instance = MainInstance;

	//	Do Stuff
	scmd2_malloc = AllocMem;
	scmd2_free = DeleteMem;
	scmd2_realloc = ResizeMem;

	Initialize();

	// Change these to get your own sections.
	if(PluginMenuName != NULL) {
		RequestedSections[0] = 'GIRT';	
	}

	return true;
}


//	Change these names to whatever you wanna call it
BOOL WINAPI PluginGetMenuString(DWORD Section, CHAR* MenuStr, WORD sLen)
{
	if(Section == 'GIRT')
	{
		if(PluginMenuName != NULL) {
			if(sLen < strlen(PluginMenuName))
				return FALSE;
			strcpy(MenuStr, PluginMenuName);
			return TRUE;
		}
		else return FALSE;
	}
	return FALSE;
}
