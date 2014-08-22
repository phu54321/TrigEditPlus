// Basic interface I/O for plugin.
#include <stdio.h>

#include "PluginBase/SCMDPlugin.h"
#include "TrigEdit/TriggerEditor.h"



// This function is called when the DLL is loaded.
void Initialize() {
	/* Your code here */

	// Example code. Delete this.
	freopen("output.txt", "wb", stdout);
	setvbuf(stdout, NULL, _IONBF, 0);
	// Example code. Delete this.
}

// This function is called when the DLL is unloaded.
void Finalize() {
	/* Your code here */

	// Example code. Delete this.
	fclose(stdout);
	// Example code. Delete this.
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
		// Dump triggers into vector.
		int trign = Triggers->ChunkSize / 2400;
		BYTE* p = Triggers->ChunkData;

		// Trigger I/O
		/*
		// Argument supplied fro trigger editor
		struct TriggerEditor_Arg {
			TEngineData*    EngineData;
			CChunkData* Triggers;
			CChunkData* SwitchRenaming;
			CChunkData* UnitProperties;
			CChunkData* UnitPropUsage;
		};
		*/

		TriggerEditor_Arg arg = {
			EngineData,
			Triggers,
			SwitchRenaming,
			UnitProperties,
			UnitPropUsage
		};

		TriggerEditor te;
		te.RunEditor(hMainWindow, arg);
	}
	return TRUE;
}



