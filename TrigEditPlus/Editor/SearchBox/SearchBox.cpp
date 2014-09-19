/*
#define SCFIND_WHOLEWORD 0x2
#define SCFIND_MATCHCASE 0x4
#define SCFIND_WORDSTART 0x00100000
#define SCFIND_REGEXP 0x00200000
#define SCFIND_POSIX 0x00400000
*/

#include <string>
#include <Windows.h>

#include "../../PluginBase/SCMDPlugin.h"
#include "../Scintilla/Scintilla.h"
#include "../../resource.h"

#include "SearchBox.h"

BOOL CALLBACK SearchBoxProc(HWND hDlg, UINT iMessage, WPARAM wParam, LPARAM lParam);

HWND findDlg;

int RunSearchBox(HWND parent, const char* query) {
	findDlg = CreateDialogParam(hInstance, MAKEINTRESOURCE(IDD_FINDREPLACEDLG),
		parent, SearchBoxProc, (LPARAM)query);
	return 0;
}

int QuitSearchBox() {
	if(findDlg) SendMessage(findDlg, WM_CLOSE, 0, 0);
	return 0;
}

BOOL CALLBACK SearchBoxProc(HWND hDlg, UINT iMessage, WPARAM wParam, LPARAM lParam) {
	HWND hParent = GetParent(hDlg);
	const static int FindReplaceMsg = RegisterWindowMessage("TEP_Find");

	switch(iMessage) {
	
	case WM_GETMINMAXINFO:
	{
		MINMAXINFO* mmi = (MINMAXINFO*)lParam;
		RECT rt_dlg2Scr = {0, 0, 291, 112};
		MapDialogRect(hDlg, &rt_dlg2Scr);
		AdjustWindowRect(&rt_dlg2Scr, WS_OVERLAPPEDWINDOW, FALSE);

		mmi->ptMinTrackSize.x = rt_dlg2Scr.right - rt_dlg2Scr.left;
		mmi->ptMinTrackSize.y = rt_dlg2Scr.bottom - rt_dlg2Scr.top;
		return TRUE;
	}
	

	case WM_INITDIALOG:
		if(lParam) {
			const char* query = (const char*)lParam;
			SetWindowText(GetDlgItem(hDlg, IDC_FINDTEXT), query);
		}

		return TRUE;

	case WM_SIZE: // Resize proc
	{
		int winW, winH;
		RECT rt;
		GetClientRect(hDlg, &rt);
		winW = rt.right - rt.left;
		winH = rt.bottom - rt.top;

		RECT rt_dlg2Scr = {0, 0, 1000, 1000};
		MapDialogRect(hDlg, &rt_dlg2Scr);
		double dlgBaseUnitX = (rt_dlg2Scr.right - rt_dlg2Scr.left) / 1000.0;
		double dlgBaseUnitY = (rt_dlg2Scr.bottom - rt_dlg2Scr.top) / 1000.0;

		// Move checkboxes
		DWORD chkboxYOffset = winH - (DWORD)(10 * dlgBaseUnitY);
		DWORD chkboxHeight = (DWORD)(8 * dlgBaseUnitY);

		HWND chkRegex = GetDlgItem(hDlg, IDC_USEREGEX);
		HWND chkCase  = GetDlgItem(hDlg, IDC_CASESENSITIVE);
		HWND chkWord  = GetDlgItem(hDlg, IDC_WHOLEWORD);
		HWND chkUp    = GetDlgItem(hDlg, IDC_SEARCHUP);
		HWND chkInSel = GetDlgItem(hDlg, IDC_INSEL);

		MoveWindow(chkRegex, (DWORD)(dlgBaseUnitX *   1), chkboxYOffset, (DWORD)(51 * dlgBaseUnitX), chkboxHeight, TRUE);
		MoveWindow(chkCase,  (DWORD)(dlgBaseUnitX *  56), chkboxYOffset, (DWORD)(61 * dlgBaseUnitX), chkboxHeight, TRUE);
		MoveWindow(chkWord,  (DWORD)(dlgBaseUnitX * 121), chkboxYOffset, (DWORD)(51 * dlgBaseUnitX), chkboxHeight, TRUE);
		MoveWindow(chkUp,    (DWORD)(dlgBaseUnitX * 181), chkboxYOffset, (DWORD)(49 * dlgBaseUnitX), chkboxHeight, TRUE);
		MoveWindow(chkInSel, (DWORD)(dlgBaseUnitX * 235), chkboxYOffset, (DWORD)(53 * dlgBaseUnitX), chkboxHeight, TRUE);

		// Move textbox
		HWND stF = GetDlgItem(hDlg, IDC_STATIC_FINDWHAT);
		HWND stR = GetDlgItem(hDlg, IDC_STATIC_REPLACETO);
		HWND txF = GetDlgItem(hDlg, IDC_FINDTEXT);
		HWND txR = GetDlgItem(hDlg, IDC_REPLACETEXT);

		DWORD textboxWidth = winW - (DWORD)(20 * dlgBaseUnitX);
		DWORD textboxYSpacing = chkboxYOffset / 2;
		DWORD captionHSpace = (DWORD)(10 * dlgBaseUnitX);
		DWORD captionHeight = (DWORD)(8 * dlgBaseUnitX);
		DWORD captionXOffset = (DWORD)(5 * dlgBaseUnitX);

		MoveWindow(stF, captionXOffset, 0, (DWORD)(34 * dlgBaseUnitX), captionHeight, TRUE);
		MoveWindow(stR, captionXOffset, textboxYSpacing, (DWORD)(36 * dlgBaseUnitX), captionHeight, TRUE);
		MoveWindow(txF, 0, captionHSpace, textboxWidth, textboxYSpacing - captionHSpace, TRUE);
		MoveWindow(txR, 0, textboxYSpacing + captionHSpace, textboxWidth, textboxYSpacing - captionHSpace, TRUE);

		// Move buttons
		HWND butFind = GetDlgItem(hDlg, IDC_FIND);
		HWND butFindAll = GetDlgItem(hDlg, IDC_FINDALL);
		HWND butRep = GetDlgItem(hDlg, IDC_REPLACE);
		HWND butRepAll = GetDlgItem(hDlg, IDC_REPLACEALL);

		DWORD buttonWidth = (DWORD)(20 * dlgBaseUnitX);
		DWORD buttonHeight = (textboxYSpacing - captionHSpace) / 2;

		MoveWindow(butFind, textboxWidth, captionHSpace, buttonWidth, buttonHeight, TRUE);
		MoveWindow(butFindAll, textboxWidth, buttonHeight + captionHSpace, buttonWidth, buttonHeight, TRUE);
		MoveWindow(butRep, textboxWidth, textboxYSpacing + captionHSpace, buttonWidth, buttonHeight, TRUE);
		MoveWindow(butRepAll, textboxWidth, textboxYSpacing + buttonHeight + captionHSpace, buttonWidth, buttonHeight, TRUE);

		return TRUE;
	}

	case WM_COMMAND:
		switch(LOWORD(wParam)) {
		case IDC_FIND:
		case IDC_FINDALL:
		case IDC_REPLACE:
		case IDC_REPLACEALL:
			if(1) {
				SearchQuery q;
				HWND txF = GetDlgItem(hDlg, IDC_FINDTEXT);
				HWND txR = GetDlgItem(hDlg, IDC_REPLACETEXT);
				HWND chkRegex = GetDlgItem(hDlg, IDC_USEREGEX);
				HWND chkCase = GetDlgItem(hDlg, IDC_CASESENSITIVE);
				HWND chkWord = GetDlgItem(hDlg, IDC_WHOLEWORD);
				HWND chkUp = GetDlgItem(hDlg, IDC_SEARCHUP);
				HWND chkInSel = GetDlgItem(hDlg, IDC_INSEL);
				
				DWORD findtextlen = GetWindowTextLength(txF);
				char* findtext = new char[findtextlen + 1];
				GetWindowText(txF, findtext, findtextlen + 1);
				q.searchFor = findtext;
				delete[] findtext;

				DWORD replacetextlen = GetWindowTextLength(txR);
				char* replacetext = new char[replacetextlen + 1];
				GetWindowText(txR, replacetext, replacetextlen + 1);
				q.replaceTo = replacetext;
				delete[] replacetext;

				/**/ if(LOWORD(wParam) == IDC_FIND)       q.mode = SEARCHMODE_FIND;
				else if(LOWORD(wParam) == IDC_FINDALL)    q.mode = SEARCHMODE_FINDALL;
				else if(LOWORD(wParam) == IDC_REPLACE)   q.mode = SEARCHMODE_REPLACE;
				else if(LOWORD(wParam) == IDC_REPLACEALL) q.mode = SEARCHMODE_REPLACEALL;

				q.searchFlag = 0;				
				if(SendMessage(chkRegex, BM_GETCHECK, 0, 0) == BST_CHECKED) q.searchFlag |= SEARCHFLAG_USEREGEXP;
				if(SendMessage(chkCase, BM_GETCHECK, 0, 0) == BST_CHECKED) q.searchFlag |= SEARCHFLAG_CASESENSITIVE;
				if(SendMessage(chkWord, BM_GETCHECK, 0, 0) == BST_CHECKED) q.searchFlag |= SEARCHFLAG_WHOLEWORD;
				if(SendMessage(chkUp, BM_GETCHECK, 0, 0) == BST_CHECKED) q.searchFlag |= SEARCHFLAG_SEARCHUP;
				if(SendMessage(chkInSel, BM_GETCHECK, 0, 0) == BST_CHECKED) q.searchFlag |= SEARCHFLAG_INSELECTION;
				
				SendMessage(hParent, FindReplaceMsg, 0, (LPARAM)&q);
			}
			return TRUE;

		}
		break;

	case WM_CLOSE:
		EndDialog(hDlg, 0);
		return TRUE;
	}

	return FALSE;
}