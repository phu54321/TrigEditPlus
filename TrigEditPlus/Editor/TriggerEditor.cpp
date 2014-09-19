#include "TriggerEditor.h"
#include "MapNamespace.h"
#include "../resource.h"
#include "../version.h"
#include "Scintilla/Scintilla.h"
#include "Scintilla/SciLexer.h"
#include <CommCtrl.h>
#include <windowsx.h>
#include "SearchBox/SearchBox.h"

void ApplyAutocomplete(TriggerEditor* te);


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


void Editor_CharAdded(SCNotification* ne, TriggerEditor* te);
void ApplyEditorStyle(TriggerEditor* te);

void ApplyAutocomplete(TriggerEditor* te);


LRESULT CALLBACK TrigEditDlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	TriggerEditor* te = reinterpret_cast<TriggerEditor*>(GetWindowLong(hWnd, GWL_USERDATA));
	const int ScintillaID = 1000;
	const int TabID = 1001;
	const int ElmnTableID = 1002;
	const static int FindReplaceMsg = RegisterWindowMessage("TEP_Find");


	if(msg == FindReplaceMsg) {
		SearchQuery* q = (SearchQuery*)lParam;
		const int searchflag = (
			(q->searchFlag & SEARCHFLAG_USEREGEXP ? SCFIND_REGEXP : 0) |
			(q->searchFlag & SEARCHFLAG_CASESENSITIVE ? SCFIND_MATCHCASE : 0) |
			(q->searchFlag & SEARCHFLAG_WHOLEWORD ? SCFIND_WHOLEWORD : 0)
		);

		if(q->mode == SEARCHMODE_FIND || q->mode == SEARCHMODE_REPLACE) { // Find/replace
			strncpy(szFindText, q->searchFor.c_str(), 4096);
			strncpy(szReplaceText, q->replaceTo.c_str(), 4096);
			szFindText[4095] = szReplaceText[4095] = '\0';

			Sci_TextToFind ttf;
			ttf.lpstrText = szFindText;

			if(q->searchFlag & SEARCHFLAG_SEARCHUP) {
				ttf.chrg.cpMin = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
				ttf.chrg.cpMax = 0;
			}

			else {
				ttf.chrg.cpMin = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
				ttf.chrg.cpMax = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
			}

			// Find specified text.
			if(te->SendSciMessage(SCI_FINDTEXT, searchflag, (LPARAM)&ttf) == -1) {
				MessageBox(hWnd, "Cannot find specified string.", "Result", MB_OK);
				return 0;
			}

			// Select the text
			te->SendSciMessage(SCI_SETSEL, ttf.chrgText.cpMin, ttf.chrgText.cpMax);

			// Replace if needed.
			if(q->mode == 2) {
				te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)szReplaceText);
			}
		}

		else if(q->mode == 1 || q->mode == 3) {
			const int searchstart = (q->searchFlag & SEARCHFLAG_INSELECTION)
				? te->SendSciMessage(SCI_GETSELECTIONSTART, 0, 0)
				: 0;

			const int searchend = (q->searchFlag & SEARCHFLAG_INSELECTION)
				? te->SendSciMessage(SCI_GETSELECTIONEND, 0, 0)
				: te->SendSciMessage(SCI_GETLENGTH, 0, 0);

			int replacedn = 0;

			strncpy(szFindText, q->searchFor.c_str(), 4096);
			strncpy(szReplaceText, q->replaceTo.c_str(), 4096);
			szFindText[4095] = szReplaceText[4095] = '\0';

			const int searchlen = strlen(szFindText);
			const int replen = strlen(szReplaceText);

			te->SendSciMessage(SCI_SETTARGETSTART, searchstart, 0);
			te->SendSciMessage(SCI_SETSEARCHFLAGS, searchflag, 0);
			

			while(1) {
				// find next text
				te->SendSciMessage(SCI_SETTARGETEND, searchend, 0);
				if(te->SendSciMessage(SCI_SEARCHINTARGET, searchlen, (LPARAM)szFindText) == -1) break;
				if(q->mode == 3) { // Replace all
					te->SendSciMessage(SCI_REPLACETARGET, replen, (LPARAM)szReplaceText);
				}

				else if(q->mode == 1) {
					int selstart = te->SendSciMessage(SCI_GETTARGETSTART, 0, 0);
					int selend = te->SendSciMessage(SCI_GETTARGETEND, 0, 0);
					te->SendSciMessage(SCI_ADDSELECTION, selstart, selend);
				}

				// move target after the found
				int newtargetend = te->SendSciMessage(SCI_GETTARGETEND, 0, 0);
				te->SendSciMessage(SCI_SETTARGETSTART, newtargetend, 0);
				replacedn++;
			}

			if(replacedn == 0) {
				MessageBox(hWnd, "Cannot find specified string.", "Result", MB_OK);
			}

			else {
				char outstr[512];
				if(q->mode == 3) sprintf(outstr, "Replaced %d strings.", replacedn);
				else sprintf(outstr, "Found %d strings.", replacedn);
				MessageBox(hWnd, outstr, "Result", MB_OK);
			}

			return 0;
		}
		return 0;
	}


	switch(msg) {
	case WM_SETFOCUS:
		SetFocus(te->hScintilla);
		break;

	case WM_CREATE:
		{
			EnableWindow(hSCMD2MainWindow, FALSE);
			te = (TriggerEditor*)((CREATESTRUCT*)lParam)->lpCreateParams;
			SetWindowLong(hWnd, GWL_USERDATA, (LONG)te);

			// Init editor window
			te->hScintilla = CreateWindow(
				"Scintilla",
				"",
				WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_CLIPCHILDREN | WS_VSCROLL,
				0,
				0,
				600,
				600,
				hWnd,
				(HMENU)ScintillaID,
				hInstance,
				NULL
				);

			te->_pSciMsg = (SciFnDirect)SendMessage(te->hScintilla, SCI_GETDIRECTFUNCTION, 0, 0);
			te->_pSciWndData = (sptr_t)SendMessage(te->hScintilla, SCI_GETDIRECTPOINTER, 0, 0);

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
			HWND hElmnTable = te->hElmnTable;

			int scrW = LOWORD(lParam);
			int scrH = HIWORD(lParam);

			MoveWindow(te->hScintilla, 0, 0, scrW - 200, scrH, TRUE);
			MoveWindow(hElmnTable, scrW - 200, 0, 200, scrH, TRUE);
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

			case IDM_FILE_IMPORT:
				{
					OPENFILENAME ofn;
					ZeroMemory(&ofn, sizeof(ofn));
					char retfname[MAX_PATH + 1] = {};
					ofn.lStructSize = sizeof(OPENFILENAME);
					ofn.hwndOwner = hWnd;
					ofn.lpstrFilter = "TRG file (*.trg)\0*.trg\0All files (*.*)\0*.*\0";
					ofn.lpstrFile = retfname;
					ofn.nMaxFile = MAX_PATH;
					ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST;
					ofn.lpstrDefExt = "trg";
					ofn.lpstrInitialDir = NULL;

					if(!GetOpenFileName(&ofn)) return 0;

					FILE* fp = fopen(retfname, "rb");
					if(!fp) {
						MessageBox(hWnd, "Cannot open selected file.", NULL, MB_OK);
						return 0;
					}

					int trgsize = ftell(fp) - 8;

					if(trgsize < 0 || trgsize % 2400 != 0) {
						MessageBox(hWnd, "Invalid TRG file.", NULL, MB_OK);
						fclose(fp);
						return 0;
					}

					fseek(fp, 8, SEEK_SET);

					BYTE* data = new BYTE[trgsize];
					fread(data, 1, trgsize, fp);
					fclose(fp);

					CChunkData trg;
					trg.ChunkData = data;
					trg.ChunkSize = trgsize;

					std::string buf = te->DecodeTriggers(&trg);
					te->SendSciMessage(SCI_ADDTEXT, buf.size(), (LPARAM)buf.data());
					return 0;
				}

			case IDM_FILE_COMPILE:
			case IDM_FILE_COMPILENONAG:
				if(te->EncodeTriggerCode()) {
					// OK.
					if(LOWORD(wParam) == IDM_FILE_COMPILE) MessageBox(hWnd, "Trigger successfully updated", "OK", MB_OK);
					te->SendSciMessage(SCI_SETSAVEPOINT, 0, 0);
					te->_textedited = false;
				}

				else {
					// Print error
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
					QuitSearchBox();

					// Get selected text and fill lpstrFindWhat with it.
					int selstart = te->SendSciMessage(SCI_GETSELECTIONSTART, 0, 0);
					int selend   = te->SendSciMessage(SCI_GETSELECTIONEND, 0, 0);
					if(selend != selstart) {
						Sci_TextRange tr;
						tr.chrg.cpMin = selstart;
						tr.chrg.cpMax = selend;
						tr.lpstrText = new char[selend - selstart + 1];
						te->SendSciMessage(SCI_GETTEXTRANGE, 0, (LPARAM)&tr);
						strncpy(szFindText, tr.lpstrText, 4096);
						szFindText[4095] = '\0';
						delete[] tr.lpstrText;
					}

					RunSearchBox(hWnd, szFindText);
				}
				return 0;



			case IDM_HELP_ABOUTTRIGEDITPLUS:
				MessageBox(hWnd,
					"TrigEditPlus " VERSION ". Made by trgk(phu54321@naver.com)\r\n"
					"Simple & powerful trigger editor.\r\n"
					"This program uses scintilla and lua.",

					"Info", MB_OK);

				return 0;

			case IDM_HELP_LICENSES:
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
	return DefWindowProc(hWnd, msg, wParam, lParam);
}

