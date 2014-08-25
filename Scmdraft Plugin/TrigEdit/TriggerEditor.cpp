#include "TriggerEditor.h"
#include "MapNamespace.h"
#include "../resource.h"
#include "../version.h"
#include "Scintilla/Scintilla.h"
#include "Scintilla/SciLexer.h"


#define MARGIN_SCRIPT_FOLD_INDEX 2


TriggerEditor::TriggerEditor() : hTrigDlg(NULL), hScintilla(NULL), hFindDlg(NULL), _textedited(false) {}
TriggerEditor::~TriggerEditor() {}

int TriggerEditor::RunEditor(HWND hMain, TriggerEditor_Arg& arg) {
	_editordata = &arg;
	_namespace = new MapNamespace(arg);

	HMENU hMenu = LoadMenu(hInstance, MAKEINTRESOURCE(IDR_MAINMENU));
	HACCEL hAccel = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDR_ACCELERATOR));

	TriggerEditor *this2 = this;
	hTrigDlg = CreateWindow(
		"TrigEditPlusDlg",
		"TrigEditPlus " VERSION,
		WS_OVERLAPPEDWINDOW,
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
	//SendSciMessage(SCI_FOLDALL, SC_FOLDACTION_CONTRACT, 0);
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

LRESULT CALLBACK TrigEditDlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	TriggerEditor* te = reinterpret_cast<TriggerEditor*>(GetWindowLong(hWnd, GWL_USERDATA));
	const int ScintillaID = 1000;
	const static int FindReplaceMsg = RegisterWindowMessage(FINDMSGSTRING);

	
	if(msg == FindReplaceMsg) {
		FINDREPLACE* fr = (FINDREPLACE*)lParam;

		if(fr->Flags & FR_DIALOGTERM) {
			MessageBox(hWnd, "dsjhfadkjs", "asdjhb", MB_OK);
			te->hFindDlg = NULL;
		}

		else if(fr->Flags & FR_FINDNEXT || fr->Flags & FR_REPLACE) { // Find/replace
			int searchflag = 
				((fr->Flags & FR_MATCHCASE) ? SCFIND_MATCHCASE : 0) |
				((fr->Flags & FR_WHOLEWORD) ? SCFIND_WHOLEWORD : 0);

			int retv;

			// Init ttf
			Sci_TextToFind ttf;
			ttf.lpstrText = fr->lpstrFindWhat;
			
			if(fr->Flags & FR_DOWN) {
				ttf.chrg.cpMin = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
				ttf.chrg.cpMax = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
			}

			else {
				ttf.chrg.cpMin = 0;
				ttf.chrg.cpMax = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
			}

			// Find specified text.
			retv = te->SendSciMessage(SCI_FINDTEXT, searchflag, (LPARAM)&ttf);
			if(retv == -1) {
				MessageBox(hWnd, "Cannot find specified string.", "Result", MB_OK);
				return 0;
			}

			// Select the text
			te->SendSciMessage(SCI_SETSEL, ttf.chrgText.cpMin, ttf.chrgText.cpMax);

			// Replace if needed.
			if(fr->Flags & FR_REPLACE) {
				te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)fr->lpstrReplaceWith);
			}
		}

		else if(fr->Flags & FR_REPLACEALL) {
			int textLen = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
			int replacedn = 0;

			int searchflag = 
				((fr->Flags & FR_MATCHCASE) ? SCFIND_MATCHCASE : 0) |
				((fr->Flags & FR_WHOLEWORD) ? SCFIND_WHOLEWORD : 0);


			te->SendSciMessage(SCI_SETTARGETSTART, 0, 0);
			te->SendSciMessage(SCI_SETSEARCHFLAGS, searchflag, 0);

			while(1) {
				// find next text
				te->SendSciMessage(SCI_SETTARGETEND, textLen, 0);
				if(te->SendSciMessage(SCI_SEARCHINTARGET, -1, (LPARAM)fr->lpstrFindWhat) == -1) break;
				te->SendSciMessage(SCI_REPLACETARGETRE, -1, (LPARAM)fr->lpstrReplaceWith);

				// move target after the replaced text
				int targetend = te->SendSciMessage(SCI_GETTARGETEND, 0, 0);
				te->SendSciMessage(SCI_SETTARGETEND, targetend, 0);
				replacedn++;
			}

			if(replacedn == 0) {
				MessageBox(hWnd, "Cannot find specified string.", "Result", MB_OK);
			}

			else {
				char outstr[512];
				sprintf(outstr, "Replaced %d strings.", replacedn);
				MessageBox(hWnd, outstr, "Result", MB_OK);
			}

			return 0;
		}
		return 0;
	}
	

	switch(msg) {
	case WM_CREATE:
		{
			EnableWindow(hSCMD2MainWindow, FALSE);
			te = (TriggerEditor*)((CREATESTRUCT*)lParam)->lpCreateParams;
			SetWindowLong(hWnd, GWL_USERDATA, (LONG)te);

			// Init editor window
			te->hScintilla = CreateWindow(
				"Scintilla",
				"",
				WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_CLIPCHILDREN,
				0,
				0,
				800,
				600,
				hWnd,
				(HMENU)ScintillaID,
				hInstance,
				NULL
				);

			te->_pSciMsg = (SciFnDirect)SendMessage(te->hScintilla, SCI_GETDIRECTFUNCTION, 0, 0);
			te->_pSciWndData = (sptr_t)SendMessage(te->hScintilla, SCI_GETDIRECTPOINTER, 0, 0);

			// Lua syntax highlighting
			
			te->SendSciMessage(SCI_SETLEXER, SCLEX_LUA, 0);

			// Color scheme from scintilla
			te->SendSciMessage(SCI_STYLESETFORE,  0, RGB(0xFF, 0x00, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE,  1, RGB(0x00, 0x7F, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE,  2, RGB(0x00, 0x7F, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE,  3, RGB(0xFF, 0x00, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE,  4, RGB(0x00, 0x7F, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE,  5, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE,  6, RGB(0x7F, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE,  7, RGB(0x7F, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE,  8, RGB(0x7F, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE,  9, RGB(0x7F, 0x7F, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE, 10, RGB(0x00, 0x00, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE, 12, RGB(0xE0, 0xC0, 0xE0));
			te->SendSciMessage(SCI_STYLESETFORE, 13, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 14, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 15, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 16, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 17, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 18, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 19, RGB(0x00, 0x00, 0x7F));
			te->SendSciMessage(SCI_STYLESETFORE, 20, RGB(0x7F, 0x7F, 0x00));
			te->SendSciMessage(SCI_STYLESETFORE, 32, RGB(0x00, 0x00, 0x00));

			te->SendSciMessage(SCI_STYLESETBACK,  1, RGB(0xD0, 0xF0, 0xF0));
			te->SendSciMessage(SCI_STYLESETBACK,  8, RGB(0xE0, 0xFF, 0xFF));
			te->SendSciMessage(SCI_STYLESETBACK, 13, RGB(0xF5, 0xFF, 0xF5));
			te->SendSciMessage(SCI_STYLESETBACK, 14, RGB(0xF5, 0xF5, 0xFF));
			te->SendSciMessage(SCI_STYLESETBACK, 15, RGB(0xFF, 0xF5, 0xF5));
			te->SendSciMessage(SCI_STYLESETBACK, 16, RGB(0xFF, 0xF5, 0xFF));
			te->SendSciMessage(SCI_STYLESETBACK, 17, RGB(0xFF, 0xFF, 0xF5));
			te->SendSciMessage(SCI_STYLESETBACK, 18, RGB(0xFF, 0xA0, 0xA0));
			te->SendSciMessage(SCI_STYLESETBACK, 19, RGB(0xFF, 0xF5, 0xF5));

			te->SendSciMessage(SCI_STYLESETEOLFILLED, 12, TRUE);
			te->SendSciMessage(SCI_STYLESETEOLFILLED,  1, TRUE);
			
			// Margins 
			te->SendSciMessage(SCI_SETMARGINWIDTHN, 0, 50);  // Line number
			te->SendSciMessage(SCI_SETMARGINWIDTHN, 1, 0);
			te->SendSciMessage(SCI_SETMARGINWIDTHN, 2, 16);  // Fold

			// Folder
			{
				te->SendSciMessage(SCI_SETPROPERTY, (WPARAM)"fold", (LPARAM)"1");
				te->SendSciMessage(SCI_SETPROPERTY, (WPARAM)"fold.compact", (LPARAM)"0");

				te->SendSciMessage(SCI_SETMARGINWIDTHN, MARGIN_SCRIPT_FOLD_INDEX, 0);
				te->SendSciMessage(SCI_SETMARGINTYPEN, MARGIN_SCRIPT_FOLD_INDEX, SC_MARGIN_SYMBOL);
				te->SendSciMessage(SCI_SETMARGINMASKN, MARGIN_SCRIPT_FOLD_INDEX, SC_MASK_FOLDERS);
				te->SendSciMessage(SCI_SETMARGINWIDTHN, MARGIN_SCRIPT_FOLD_INDEX, 20);

				// Fold style
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDER, SC_MARK_BOXPLUS);
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS);
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDERSUB, SC_MARK_VLINE);
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDERTAIL, SC_MARK_LCORNER);
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDEREND, SC_MARK_BOXPLUSCONNECTED);
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDERMIDTAIL, SC_MARK_TCORNER);
				te->SendSciMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPENMID, SC_MARK_BOXMINUSCONNECTED);

				te->SendSciMessage(SCI_SETFOLDFLAGS, 16, 0); // 16  	Draw line below if not expanded

				// Folder color
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDER, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDER, 0xFFFFFF);
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDEROPEN, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDEROPEN, 0xFFFFFF);
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDERSUB, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDERSUB, 0xFFFFFF);
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDERTAIL, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDERTAIL, 0xFFFFFF);
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDEREND, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDEREND, 0xFFFFFF);
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDERMIDTAIL, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDERMIDTAIL, 0xFFFFFF);
				te->SendSciMessage(SCI_MARKERSETBACK, SC_MARKNUM_FOLDEROPENMID, 0x808080);
				te->SendSciMessage(SCI_MARKERSETFORE, SC_MARKNUM_FOLDEROPENMID, 0xFFFFFF);

				// Sensitive to click
				te->SendSciMessage(SCI_SETMARGINSENSITIVEN, MARGIN_SCRIPT_FOLD_INDEX, 1);
			}
		}
		return 0;

	case WM_SIZE:
		{
			int scrW = LOWORD(lParam);
			int scrH = HIWORD(lParam);
			MoveWindow(te->hScintilla, 0, 0, scrW, scrH, TRUE);
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
				if(te->EncodeTriggerCode()) {
					// OK.
					MessageBox(hWnd, "Trigger successfully updated", "OK", MB_OK);
					te->SendSciMessage(SCI_SETSAVEPOINT, 0, 0);
					te->_textedited = false;
				}

				else {
					// Print error
					MessageBox(hWnd, te->_errlist.str().c_str(), NULL, MB_OK);
				}
				return 0;


			// EDIT
			
			case IDM_EDIT_FIND:
			case IDM_EDIT_REPLACE:
				return 0; //Bug still present

				{
					if(te->hFindDlg) {
						DestroyWindow(te->hFindDlg);
						te->hFindDlg = NULL;
					}
					FINDREPLACE fr;
					ZeroMemory(&fr, sizeof(fr));

					// Initialize FINDREPLACE
					fr.lStructSize = sizeof(fr);
					fr.hwndOwner = hWnd;
					fr.hInstance = hInstance;
					fr.Flags = 0;
					fr.lpstrFindWhat = szFindText;
					fr.lpstrReplaceWith = szReplaceText;
					ZeroMemory(szFindText, 4096);
					ZeroMemory(szReplaceText, 4096);
					fr.wFindWhatLen = 4096;
					fr.wReplaceWithLen = 4096;

					if(LOWORD(wParam) == IDM_EDIT_FIND) te->hFindDlg = FindText(&fr);
					else te->hFindDlg = ReplaceText(&fr);
				}
				return 0;

			case IDM_HELP_ABOUTTRIGEDITPLUS:
				MessageBox(hWnd,
					"TrigEditPlus " VERSION ". Made by trgk(phu54321@naver.com)\r\n"
					"Simple & powerful trigger editor.\r\n",
					"This program uses scintilla.\r\n"
					"Info", MB_OK);

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
					case MARGIN_SCRIPT_FOLD_INDEX:
						{
							te->SendSciMessage(SCI_TOGGLEFOLD, line_number, 0);
						}
						break;
					}
				}
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
