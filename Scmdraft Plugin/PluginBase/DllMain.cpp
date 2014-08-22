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

	// Change these to get your own sections.
	RequestedSections[0] = 'GIRT';
	
	Initialize();

	return true;
}


extern const char* PluginMenuName;

//	Change these names to whatever you wanna call it
BOOL WINAPI PluginGetMenuString(DWORD Section, CHAR* MenuStr, WORD StrLen)
{
	if(Section == 'GIRT')
	{
		if(StrLen < strlen(PluginMenuName))
			return FALSE;
		strcpy(MenuStr, PluginMenuName);
		return TRUE;
	}
	return FALSE;
}
