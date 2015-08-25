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

#include "TriggerEditor.h"
#include "MapNamespace.h"
#include "../resource.h"
#include "../version.h"
#include <CommCtrl.h>

struct SearchQuery
{
	std::string searchFor;
	std::string replaceTo;
	int mode; // 0:find, 1:findall 2:replace 3:replaceall
	unsigned int searchFlag;
};


void ApplyAutocomplete(TriggerEditor* te);
void ProcessSearchMessage(HWND hTrigDlg, TriggerEditor* te, SearchQuery* q);

TriggerEditor::TriggerEditor() : hTrigDlg(NULL), hScintilla(NULL),
	hFindDlg(NULL), _textedited(false) {}
TriggerEditor::~TriggerEditor() {}

int TriggerEditor::RunEditor(HWND hMain, TriggerEditor_Arg& arg) {
	_editordata = &arg;
	_namespace = new MapNamespace(arg);

	currentft = FIELDTYPE_NONE;

	HMENU hMenu = LoadMenu(hInstance, MAKEINTRESOURCE(IDR_MAINMENU));
	HACCEL hAccel = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDR_ACCELERATOR));

	TriggerEditor *this2 = this;
	hTrigDlg = CreateWindow(
		"TrigEditPlusDlg",
		"TrigEditPlus " VERSION,
		WS_OVERLAPPEDWINDOW | WS_MAXIMIZE,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		800,
		600,
		hMain,
		hMenu,
		hInstance,
		this2
		);

	SetEditorText(DecodeTriggers(arg.Triggers));
	SendSciMessage(SCI_SETSAVEPOINT, 0, 0);
	SendSciMessage(SCI_EMPTYUNDOBUFFER, 0, 0);
	SendSciMessage(SCI_FOLDALL, SC_FOLDACTION_CONTRACT, 0);
	_textedited = false;

	ShowWindow(hTrigDlg, SW_SHOW);

	MSG msg;
	while(hTrigDlg && GetMessage(&msg, NULL, NULL, NULL)) {
		if(!IsWindow(hFindDlg) || !IsDialogMessage(hFindDlg, &msg)) {
			if(!TranslateAccelerator(hTrigDlg, hAccel, &msg)) {
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}
		}
	}

	delete _namespace;
	DestroyMenu(hMenu);
	DestroyAcceleratorTable(hAccel);
	return 0;
}




void TriggerEditor::SetEditorText(const std::string& str) {
	SendMessage(hScintilla, SCI_SETTEXT, 0, (LPARAM)str.c_str());
}

std::string TriggerEditor::GetEditorText() const {
	int sLen = SendMessage(hScintilla, SCI_GETTEXTLENGTH, 0, 0);
	char* s = new char[sLen + 1];
	SendMessage(hScintilla, SCI_GETTEXT, sLen + 1, (LPARAM)s);
	std::string ret = std::string(s, s+sLen);
	delete[] s;
	return ret;
}


void TriggerEditor::ClearErrors() {
	_errlist.clear();
	_errlist << "Compile failed because of the following reason:\r\n";
}


void TriggerEditor::PrintErrorMessage(const std::string& msg) {
	_errlist << msg.c_str() << "\r\n";
}


int TriggerEditor::SendSciMessage(int msg, WPARAM wParam, LPARAM lParam) {
	return _pSciMsg(_pSciWndData, msg, wParam, lParam);
}




char szFindText[4096];
char szReplaceText[4096];
static FINDREPLACE fr;

void Editor_CharAdded(SCNotification* ne, TriggerEditor* te);
void ApplyEditorStyle(TriggerEditor* te);
void ApplyAutocomplete(TriggerEditor* te);

const int TreeViewID = 1000;
const int ScintillaID = 1001;
const int TabID = 1002;
const int ElmnTableID = 1003;
const int StatusBarID = 1004;

LRESULT CALLBACK TrigEditDlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	TriggerEditor* te = reinterpret_cast<TriggerEditor*>(GetWindowLong(hWnd, GWL_USERDATA));
	const static int FindReplaceMsg = RegisterWindowMessage(FINDMSGSTRING);


	switch(msg) {
	case WM_SETFOCUS:
		SetFocus(te->hScintilla);
		break;

	case WM_CREATE:
		{
			EnableWindow(hSCMD2MainWindow, FALSE);
			te = (TriggerEditor*)((CREATESTRUCT*)lParam)->lpCreateParams;
			SetWindowLong(hWnd, GWL_USERDATA, (LONG)te);

			// Init trigger list
			te->hTriggerList = CreateWindowEx(
				0,
				WC_TREEVIEW,
				TEXT("Tree View"),
				WS_VISIBLE | WS_CHILD | WS_BORDER | TVS_HASLINES,
				0,
				0,
				200,
				600,
				hWnd,
				(HMENU)TreeViewID,
				hInstance,
				NULL);

			// Init editor window
			te->hScintilla = CreateWindow(
				"Scintilla",
				"",
				WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_CLIPCHILDREN | WS_VSCROLL,
				200,
				0,
				400,
				600,
				hWnd,
				(HMENU)ScintillaID,
				hInstance,
				NULL
				);

			te->_pSciMsg = (SciFnDirect)SendMessage(te->hScintilla, SCI_GETDIRECTFUNCTION, 0, 0);
			te->_pSciWndData = (sptr_t)SendMessage(te->hScintilla, SCI_GETDIRECTPOINTER, 0, 0);
			CreateStatusWindow(SBARS_SIZEGRIP | WS_CHILD | WS_VISIBLE, 
				"TrigEditPlus loaded", hWnd, StatusBarID);

			ApplyEditorStyle(te);

			// Autocomplete list
			HWND hElmnTable = CreateWindow("listbox", NULL,
				WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN | WS_VSCROLL |
				LBS_NOTIFY | LBS_NOINTEGRALHEIGHT | LBS_SORT | LBS_WANTKEYBOARDINPUT,
				600, 0, 200, 600, hWnd, (HMENU)ElmnTableID, hInstance, NULL);

			SendMessage(hElmnTable, WM_SETFONT, (WPARAM)GetStockObject(ANSI_FIXED_FONT), TRUE);
			te->hElmnTable = hElmnTable;
		}
		return 0;

	case WM_SIZE:
		{
			HWND hStatusBar = GetDlgItem(hWnd, StatusBarID);
			SendMessage(hStatusBar, msg, wParam, lParam);

			RECT statusbarRect;
			SendMessage(hStatusBar, SB_GETRECT, 0, (LPARAM)&statusbarRect);
			int statusbar_height = statusbarRect.bottom - statusbarRect.top;


			HWND hElmnTable = te->hElmnTable;

			RECT rt;
			GetClientRect(hWnd, &rt);
			int scrW = rt.right - rt.left;
			int scrH = rt.bottom - rt.top - statusbar_height;

			HDWP hdwp = BeginDeferWindowPos(2);
			DeferWindowPos(hdwp, te->hTriggerList, NULL, 0, 0, 199, scrH, SWP_NOZORDER);
			DeferWindowPos(hdwp, te->hScintilla, NULL, 200, 0, scrW - 399, scrH, SWP_NOZORDER);
			DeferWindowPos(hdwp, hElmnTable, NULL, scrW - 200, 0, 200, scrH, SWP_NOZORDER);
			EndDeferWindowPos(hdwp);
		}
		return 0;

	case WM_VKEYTOITEM:
		{
			// when user pressed enter while selecting item
			if(LOWORD(lParam) == ElmnTableID && wParam == 13) {
				ApplyAutocomplete(te);
				SetFocus(te->hScintilla);
			}
		}
		return 0;

	case WM_COMMAND:
		{
			switch(LOWORD(wParam)) {
			case IDM_FILE_EXIT:
				PostMessage(hWnd, WM_CLOSE, 0, 0);
				return 0;

			case IDM_FILE_COMPILE:
			case IDM_FILE_COMPILENONAG:
				if(te->EncodeTriggerCode()) {
					// OK.
					HWND hStatusBar = GetDlgItem(hWnd, StatusBarID);
					SetWindowText(hStatusBar, "Trigger successfully updated");
					if(LOWORD(wParam) == IDM_FILE_COMPILE) MessageBox(hWnd, "Trigger successfully updated", "OK", MB_OK);
					te->SendSciMessage(SCI_SETSAVEPOINT, 0, 0);
					te->_textedited = false;
				}

				else {
					// Print error
					HWND hStatusBar = GetDlgItem(hWnd, StatusBarID);
					SetWindowText(hStatusBar, "Error on compiling");
					MessageBox(hWnd, te->_errlist.str().c_str(), NULL, MB_OK);
				}
				return 0;

			case IDM_VIEW_FOLDALL:
				te->SendSciMessage(SCI_FOLDALL, SC_FOLDACTION_CONTRACT, 0);
				te->SendSciMessage(SCI_SCROLLCARET, 0, 0);
				break;

			case IDM_VIEW_UNFOLDALL:
				te->SendSciMessage(SCI_FOLDALL, SC_FOLDACTION_EXPAND, 0);
				te->SendSciMessage(SCI_SCROLLCARET, 0, 0);
				break;

				// EDIT
			case IDM_EDIT_FIND:
			case IDM_EDIT_REPLACE:
			{
					if(te->hFindDlg)
					{
						DestroyWindow(te->hFindDlg);
						te->hFindDlg = NULL;
					}

					ZeroMemory(&fr, sizeof(fr));

					// Initialize FINDREPLACE
					fr.lStructSize = sizeof(fr);
					fr.hwndOwner = hWnd;
					//fr.hInstance = hInstance;
					fr.Flags = FR_DOWN;
					fr.lpstrFindWhat = szFindText;
					fr.lpstrReplaceWith = szReplaceText;
					ZeroMemory(szFindText, 4096);
					ZeroMemory(szReplaceText, 4096);

					// Get selected text and fill lpstrFindWhat with it.
					int selstart = te->SendSciMessage(SCI_GETSELECTIONSTART, 0, 0);
					int selend = te->SendSciMessage(SCI_GETSELECTIONEND, 0, 0);
					if(selend != selstart)
					{
						Sci_TextRange tr;
						tr.chrg.cpMin = selstart;
						tr.chrg.cpMax = selend;
						tr.lpstrText = new char[selend - selstart + 1];
						te->SendSciMessage(SCI_GETTEXTRANGE, 0, (LPARAM)&tr);
						strncpy(szFindText, tr.lpstrText, 4096);
						szFindText[4095] = '\0';
						delete[] tr.lpstrText;
					}

					fr.wFindWhatLen = 4096;
					fr.wReplaceWithLen = 4096;

					if(LOWORD(wParam) == IDM_EDIT_FIND) te->hFindDlg = FindText(&fr);
					else te->hFindDlg = ReplaceText(&fr);
				}
				return 0;

			case IDM_EDIT_AUTOCOMPLETE:
				ApplyAutocomplete(te);
				break;



			case IDM_HELP_ABOUTTRIGEDITPLUS:
				MessageBox(hWnd,
					"TrigEditPlus " VERSION ". Made by trgk(phu54321@naver.com)\r\n"
					"Simple & powerful trigger editor.\r\n"
					"This program uses Scintilla and Lua.",

					"Info", MB_OK);

				return 0;

			case IDM_HELP_LICENSES:
				MessageBox(hWnd,
					"TrigEditPlus is distributed in MIT License.\r\n"
					"Source code can be obtained at http://github.com/phu54321/TrigEditPlus/\r\n"
					"\r\n"
					"Copyright (c) 2014 trgk(phu54321@naver.com)\r\n"
					"\r\n"
					"Permission is hereby granted, free of charge, to any person obtaining a copy\r\n"
					"of this software and associated documentation files (the \"Software\"), to deal\r\n"
					"in the Software without restriction, including without limitation the rights\r\n"
					"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\r\n"
					"copies of the Software, and to permit persons to whom the Software is\r\n"
					"furnished to do so, subject to the following conditions:\r\n"
					"\r\n"
					"The above copyright notice and this permission notice shall be included in\r\n"
					"all copies or substantial portions of the Software.\r\n"
					"\r\n"
					"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\r\n"
					"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\r\n"
					"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\r\n"
					"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\r\n"
					"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\r\n"
					"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\r\n"
					"THE SOFTWARE.\r\n"
					, "TrigEditPlus License", MB_OK);

				MessageBox(hWnd,
					"Copyright 1994-2014 Lua.org, PUC-Rio.\r\n"
					"Permission is hereby granted, free of charge, to any person obtaining a copy of\r\n"
					"this software and associated documentation files (the \"Software\"), to deal in\r\n"
					"the Software without restriction, including without limitation the rights to\r\n"
					"use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies\r\n"
					"of the Software, and to permit persons to whom the Software is furnished to do\r\n"
					"so, subject to the following conditions:\r\n"
					"\r\n"
					"The above copyright notice and this permission notice shall be included in all\r\n"
					"copies or substantial portions of the Software.\r\n"
					"\r\n"
					"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\r\n"
					"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\r\n"
					"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\r\n"
					"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\r\n"
					"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\r\n"
					"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\r\n"
					"SOFTWARE.\r\n",
					"Lua License",
					MB_OK);

				MessageBox(hWnd,
					"License for Scintilla and SciTE\r\n"
					"\r\n"
					"Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>\r\n"
					"\r\n"
					"All Rights Reserved \r\n"
					"\r\n"
					"Permission to use, copy, modify, and distribute this software and its \r\n"
					"documentation for any purpose and without fee is hereby granted, \r\n"
					"provided that the above copyright notice appear in all copies and that \r\n"
					"both that copyright notice and this permission notice appear in \r\n"
					"supporting documentation. \r\n"
					"\r\n"
					"NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS \r\n"
					"SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY \r\n"
					"AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY \r\n"
					"SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES \r\n"
					"WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, \r\n"
					"WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER \r\n"
					"TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE \r\n"
					"OR PERFORMANCE OF THIS SOFTWARE. \r\n",
					"Scintilla License",
					MB_OK);

				return 0;




			case IDM_EDIT_NEWTRIGGER:
				{
					const char* newtriggertext = 
						"Trigger {\r\n"
						"	players = {},\r\n"
						"	conditions = {},\r\n"
						"	actions = {}\r\n"
						"}\r\n"
						;
					te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)newtriggertext);
				}
				return 0;

			case ElmnTableID:
				if(HIWORD(wParam) == LBN_DBLCLK) {
					ApplyAutocomplete(te);
					SetFocus(te->hScintilla);
				}
				return 0;
			}

		}
		break;

	case WM_NOTIFY:
		if(wParam == ScintillaID) {
			SCNotification *ne = reinterpret_cast<SCNotification*>(lParam);
			switch(ne->nmhdr.code) {
			case SCN_SAVEPOINTREACHED:
				SetWindowText(hWnd, "TrigEditPlus " VERSION);
				te->_textedited = false;
				return 0;

			case SCN_SAVEPOINTLEFT:
				SetWindowText(hWnd, "TrigEditPlus " VERSION " (Modified)");
				te->_textedited = true;
				return 0;

			case SCN_MARGINCLICK:
				{
					const int modifiers = ne->modifiers;
					const int position = ne->position;
					const int margin = ne->margin;
					const int line_number = te->SendSciMessage(SCI_LINEFROMPOSITION, position, 0);

					switch (margin) {
					case 2:
						{
							te->SendSciMessage(SCI_TOGGLEFOLD, line_number, 0);
						}
						break;
					}
				}
				return 0;

			case SCN_CHARADDED:
				Editor_CharAdded(ne, te);
				return 0;
			}
		}

		else if(wParam == TreeViewID)
		{
			LPNMHDR pnmh = (LPNMHDR)lParam;
			if(pnmh->code == TVN_SELCHANGED)
			{
				LPNMTREEVIEW pnmtv = (LPNMTREEVIEW)lParam;
				if(pnmtv->itemNew.mask | TVIF_PARAM)
				{
					int triggerLine = pnmtv->itemNew.lParam - 1;
					int linePos = te->SendSciMessage(SCI_POSITIONFROMLINE, triggerLine, 0);
					int lineEnd = te->SendSciMessage(SCI_GETLINEENDPOSITION, triggerLine, 0);
					te->SendSciMessage(SCI_SETSEL, linePos, lineEnd);
					SetFocus(te->hScintilla);
				}
			}
		}
		break;

	case WM_CLOSE:
		{
			if(te->_textedited) {
				int select = MessageBox(hWnd, "There are unsaved change in trigger text. Compile?", "Save warning", MB_YESNOCANCEL);
				/**/ if(select == IDCANCEL) return 0;
				else if(select == IDNO);
				else {
					if(te->EncodeTriggerCode());
					else {
						MessageBox(hWnd, te->_errlist.str().c_str(), NULL, MB_OK);
						return 0;
					}
				}
			}
		}
		break;

	case WM_DESTROY:
		{
			if(te->hFindDlg) DestroyWindow(te->hFindDlg);
			EnableWindow(hSCMD2MainWindow, TRUE);
			te->hTrigDlg = NULL;
			te->hScintilla = NULL;
			te->hFindDlg = NULL;
			te->_pSciMsg = NULL;
			te->_pSciWndData = NULL;
			SetFocus(hSCMD2MainWindow);
		}
		return 0;

	}


	if(msg == FindReplaceMsg) {
		ProcessSearchMessage(hWnd, te, (SearchQuery*)lParam);
		return 0;
	}

	return DefWindowProc(hWnd, msg, wParam, lParam);
}




void ProcessSearchMessage(HWND hTrigDlg, TriggerEditor* te, SearchQuery* q) {
	LPFINDREPLACE lpfr = &fr;
	HWND hStatusBar = GetDlgItem(hTrigDlg, StatusBarID);

	if(lpfr->Flags & FR_DIALOGTERM)
	{
		te->hFindDlg = NULL;
	}

	else if(lpfr->Flags & FR_FINDNEXT || lpfr->Flags & FR_REPLACE)
	{ // Find/replace
		int searchflag =
			((lpfr->Flags & FR_MATCHCASE) ? SCFIND_MATCHCASE : 0) |
			((lpfr->Flags & FR_WHOLEWORD) ? SCFIND_WHOLEWORD : 0);

		int retv;

		// Init ttf
		Sci_TextToFind ttf;
		ttf.lpstrText = lpfr->lpstrFindWhat;

		if(lpfr->Flags & FR_DOWN)
		{
			ttf.chrg.cpMin = max(
				te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0),
				te->SendSciMessage(SCI_GETANCHOR, 0, 0)
				);
			ttf.chrg.cpMax = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
		}

		else
		{
			ttf.chrg.cpMin = min(
				te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0),
				te->SendSciMessage(SCI_GETANCHOR, 0, 0)
				);
			ttf.chrg.cpMax = 0;
		}

		retv = te->SendSciMessage(SCI_FINDTEXT, searchflag, (LPARAM)&ttf);
		if(retv == -1)  // Not found yet
		{
			// Search in global context
			if(lpfr->Flags & FR_DOWN)
			{
				ttf.chrg.cpMin = 0;
				ttf.chrg.cpMax = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
			}

			else
			{
				ttf.chrg.cpMin = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
				ttf.chrg.cpMax = 0;
			}

			retv = te->SendSciMessage(SCI_FINDTEXT, searchflag, (LPARAM)&ttf);

			if(retv != -1)
			{
				SetWindowText(hStatusBar, "Passed the end of the document");
			}
		}

		if(retv == -1) // No such text in global context
		{
			const char* outstr = "Cannot find specified string.";
			MessageBox(hTrigDlg, outstr, "Result", MB_OK);
			SetWindowText(hStatusBar, outstr);
			MessageBeep(MB_OK);
			return;
		}

		// Select the text
		te->SendSciMessage(SCI_SETSEL, ttf.chrgText.cpMin, ttf.chrgText.cpMax);

		// Replace if needed.
		if(lpfr->Flags & FR_REPLACE)
		{
			te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)lpfr->lpstrReplaceWith);
		}
	}

	else if(lpfr->Flags & FR_REPLACEALL)
	{
		const int docLen = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
		int replacedn = 0;

		const int searchflag =
			((lpfr->Flags & FR_MATCHCASE) ? SCFIND_MATCHCASE : 0) |
			((lpfr->Flags & FR_WHOLEWORD) ? SCFIND_WHOLEWORD : 0);

		const int searchlen = strlen(lpfr->lpstrFindWhat);
		const int replen = strlen(lpfr->lpstrReplaceWith);

		te->SendSciMessage(SCI_SETTARGETSTART, 0, 0);
		te->SendSciMessage(SCI_SETSEARCHFLAGS, searchflag, 0);

		te->SendSciMessage(SCI_BEGINUNDOACTION, 0, 0);

		while(1)
		{
			// find next text
			te->SendSciMessage(SCI_SETTARGETEND, docLen, 0);
			if(te->SendSciMessage(SCI_SEARCHINTARGET, searchlen, (LPARAM)lpfr->lpstrFindWhat) == -1) break;
			te->SendSciMessage(SCI_REPLACETARGET, replen, (LPARAM)lpfr->lpstrReplaceWith);

			// move target after the replaced text
			int newtargetend = te->SendSciMessage(SCI_GETTARGETEND, 0, 0);
			te->SendSciMessage(SCI_SETTARGETSTART, newtargetend, 0);
			replacedn++;
		}

		te->SendSciMessage(SCI_ENDUNDOACTION, 0, 0);

		if(replacedn == 0)
		{
			const char* outstr = "Cannot find specified string.";
			MessageBox(hTrigDlg, outstr, "Result", MB_OK);
			SetWindowText(hStatusBar, outstr);
			MessageBeep(MB_OK);
		}

		else
		{
			char outstr[512];
			sprintf(outstr, "Replaced %d strings.", replacedn);
			SetWindowText(hStatusBar, outstr);
			MessageBeep(MB_OK);
		}

		return;
	}
}



char PlayerName[28][12] = {
	"Player 1",
	"Player 2",
	"Player 3",
	"Player 4",
	"Player 5",
	"Player 6",
	"Player 7",
	"Player 8",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"All players",
	"Force 1",
	"Force 2",
	"Force 3",
	"Force 4",
	"",
	"",
	"",
	"",
	"",
	"",
};

// TODO : Erase this
void TriggerEditor::UpdateTriggerList(const std::vector<TrigBufferEntry>& trigbuffer)
{
	auto& strtb = _editordata->EngineData->MapStrings;
	const int totstrn = StringTable_GetTotalStringNum(strtb);

	HWND hTreeView = this->hTriggerList;
	TreeView_DeleteAllItems(hTreeView);

	// Add 28 parent nodes
	HTREEITEM parentNode[28];


	for(int i = 0; i < 28; i++)
	{
		if(PlayerName[i][0] == '\0')
		{
			parentNode[i] = nullptr;
			continue;
		}

		TVINSERTSTRUCT is;
		memset(&is, 0, sizeof(is));
		is.hParent = TVI_ROOT;
		is.hInsertAfter = TVI_LAST;
		
		TVITEM& tvi = is.item;
		tvi.mask = TVIF_TEXT;
		tvi.pszText = PlayerName[i];
		tvi.cchTextMax = strlen(PlayerName[i]);

		parentNode[i] = TreeView_InsertItem(hTreeView, &is);
	}

	for(const auto& entry : trigbuffer)
	{
		const Trig& trg = entry.trigData;
		std::string trigCaption = "No comment";

		// Get trigger comment
		for(int i = 0; i < 64; i++)
		{
			if(trg.act[i].acttype == 0) break;
			else if(trg.act[i].acttype == COMMENT)
			{
				int strid = trg.act[i].strid;
				if(strid < 0 || strid > totstrn) break;
				const char* rawcomment0 = StringTable_GetString(strtb, strid);
				if(rawcomment0 == NULL) break;

				// Decode string to lua comments
				std::string rawcomment = rawcomment0;

				char *comment = (char*)alloca(rawcomment.size() + 1);
				char *p = comment;

				for(char ch : rawcomment)
				{
					/**/ if(ch == '\t') *p++ = ' ';
					else if(ch == '\r');
					else if(ch == '\n');

					else if(1 <= ch && ch <= 31) continue;
					else *p++ = ch;
				}

				*p = '\0';
				trigCaption.assign(comment);
			}
		}

		for(int i = 0; i < 27; i++)
		{
			if(trg.effplayer[i] && parentNode[i])
			{
				TVINSERTSTRUCT is;
				memset(&is, 0, sizeof(is));
				is.hParent = parentNode[i];
				is.hInsertAfter = TVI_LAST;

				TVITEM& tvi = is.item;
				tvi.mask = TVIF_TEXT | TVIF_PARAM;
				tvi.pszText = (char*)trigCaption.c_str();
				tvi.cchTextMax = trigCaption.size();
				tvi.lParam = entry.callerLine;

				TreeView_InsertItem(hTreeView, &is);
			}
		}
	}
}