// Basic interface I/O for plugin.
#include <Windows.h>
#include <CommCtrl.h>
#include <stdio.h>

#include "PluginBase/SCMDPlugin.h"
#include "Editor/TriggerEditor.h"


const char* PluginMenuName = "TrigEdit++";

static HMODULE hScintillaDLL;


void Initialize() {
	// Initialize common controls.
	hScintillaDLL = LoadLibrary("SciLexer.dll");
	if(!hScintillaDLL) {
		PluginMenuName = NULL;
		return;
	}

	InitCommonControls();

	WNDCLASSEX wc;
	memset(&wc, 0, sizeof(wc));
	wc.cbSize = sizeof(wc);
	wc.lpszClassName = "TrigEditPlusDlg";
	wc.hInstance = hInstance;
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)GetStockObject(GRAY_BRUSH);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc = TrigEditDlgProc;
	RegisterClassEx(&wc);

	RegisterWindowMessage(FINDMSGSTRING);
}

// This function is called when the DLL is unloaded.
void Finalize() {
	if(hScintillaDLL) FreeLibrary(hScintillaDLL);
}



BOOL WINAPI RunPlugin(	TEngineData*	EngineData,		//	Struct containing engine data
						DWORD CurSection,				//	Section plugin is being run for (Currently either triggers or mission briefing)
						CChunkData*	Triggers,			//	Pointer to trigger datachunk
						CChunkData*	MissionBriefing,	//	Pointer to mission briefing datachunk
						CChunkData*	SwitchRenaming,		//	Pointer to switch renaming datachunk
						CChunkData*	UnitProperties,		//	Pointer to unit properties datachunk
						CChunkData*	UnitPropUsage	)	//	Pointer to unit property usage datachunk
{
	if ((Triggers == NULL)||(MissionBriefing == NULL)||(SwitchRenaming == NULL)||(UnitProperties == NULL)||(UnitPropUsage == NULL))
		return FALSE;

	if (CurSection == 'GIRT') {
		TriggerEditor_Arg arg = {
			EngineData,
			Triggers,
			SwitchRenaming,
			UnitProperties,
			UnitPropUsage
		};

		TriggerEditor te;
		te.RunEditor(hSCMD2MainWindow, arg);
	}
	return TRUE;
}



