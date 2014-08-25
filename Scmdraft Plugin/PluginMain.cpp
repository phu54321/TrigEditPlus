// Basic interface I/O for plugin.
#include <stdio.h>

#include "PluginBase/SCMDPlugin.h"
#include "TrigEdit/TriggerEditor.h"


const char* PluginMenuName = "TrigEdit++";

static HMODULE hScintillaDLL;


void Initialize() {
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

	Scintilla_RegisterClasses(hInstance);
	Scintilla_LinkLexers();
}

// This function is called when the DLL is unloaded.
void Finalize() {
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



