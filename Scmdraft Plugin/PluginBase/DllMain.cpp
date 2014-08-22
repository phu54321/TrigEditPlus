#include "SCMDPlugin.h"

HWND hMainWindow;
HINSTANCE hMainInstance;

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
	hMainWindow = MainWindow;
	hMainInstance = MainInstance;

	//	Do Stuff
	scmd2_malloc = AllocMem;
	scmd2_free = DeleteMem;
	scmd2_realloc = ResizeMem;

	// Change these to get your own sections.
	RequestedSections[0] = 'GIRT';
	
	Initialize();

	return true;
}


//	Change these names to whatever you wanna call it
BOOL WINAPI PluginGetMenuString(DWORD Section, CHAR* MenuStr, WORD StrLen)
{
	if(Section == 'GIRT')
	{
		if(StrLen<strlen("Test plugin"))
			return FALSE;
		strcpy(MenuStr,"Test plugin");
		return TRUE;
	}
	return FALSE;
}
