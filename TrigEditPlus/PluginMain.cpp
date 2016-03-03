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

// Basic interface I/O for plugin.
#include <Windows.h>
#include <CommCtrl.h>
#include <stdio.h>

#include "PluginBase/SCMDPlugin.h"
#include "Editor/TriggerEditor.h"
#include "version.h"


const char* PluginMenuName = "TrigEdit++\tCtrl + T";

static HMODULE hScintillaDLL;


// Visual style activator.
// Code from http://stackoverflow.com/questions/25267272/win32-enable-visual-styles-in-dll
// Thanks
HANDLE hActCtx;
ACTCTX actCtx;
ULONG_PTR cookie;

void EnableVisualStyle() {
	ZeroMemory(&actCtx, sizeof(actCtx));
	actCtx.cbSize = sizeof(actCtx);
	actCtx.hModule = hInstance;
	actCtx.lpResourceName = MAKEINTRESOURCE(123);
	actCtx.dwFlags = ACTCTX_FLAG_HMODULE_VALID | ACTCTX_FLAG_RESOURCE_NAME_VALID;

	hActCtx = CreateActCtx(&actCtx);
	if(hActCtx != INVALID_HANDLE_VALUE)	{
		ActivateActCtx(hActCtx, &cookie);
	}
}

void DisableVisualStyle() {
	if(hActCtx != INVALID_HANDLE_VALUE) {
		DeactivateActCtx(0, cookie);
		ReleaseActCtx(hActCtx);
	}
}

// Activator end

void Initialize() {
	// Initialize common controls.
	Scintilla_RegisterClasses(hInstance);
	Scintilla_LinkLexers();

	InitCommonControls();

	// Force using visual style

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

#ifdef VERSION_BETA		
	MessageBox(NULL, TEXT(
		"[베타] 버그가 많이 있을겁니다.\r\n"
	), "TrigEditPlus " VERSION, MB_OK);
#endif
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
		
		EnableVisualStyle();
		te.RunEditor(hSCMD2MainWindow, arg);
		DisableVisualStyle();
	}
	return TRUE;
}



