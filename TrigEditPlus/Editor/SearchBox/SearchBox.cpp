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
	ShowWindow(findDlg, SW_SHOW);
	return 0;
}

int QuitSearchBox() {
	if(findDlg)
	{
		SendMessage(findDlg, WM_CLOSE, 0, 0);
		findDlg = NULL;
	}
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


		// Begin moving
		HDWP hdwp = BeginDeferWindowPos(12);

		// Move checkboxes
		DWORD chkboxYOffset = winH - (DWORD)(10 * dlgBaseUnitY);
		DWORD chkboxHeight = (DWORD)(8 * dlgBaseUnitY);

		HWND chkRegex = GetDlgItem(hDlg, IDC_USEREGEX);
		HWND chkCase  = GetDlgItem(hDlg, IDC_CASESENSITIVE);
		HWND chkWord  = GetDlgItem(hDlg, IDC_WHOLEWORD);
		HWND chkInSel = GetDlgItem(hDlg, IDC_INSEL);

		DeferWindowPos(hdwp, chkRegex, NULL, (DWORD)(dlgBaseUnitX *   1), chkboxYOffset, (DWORD)(51 * dlgBaseUnitX), chkboxHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, chkCase,  NULL, (DWORD)(dlgBaseUnitX *  56), chkboxYOffset, (DWORD)(61 * dlgBaseUnitX), chkboxHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, chkWord,  NULL, (DWORD)(dlgBaseUnitX * 121), chkboxYOffset, (DWORD)(51 * dlgBaseUnitX), chkboxHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, chkInSel, NULL, (DWORD)(dlgBaseUnitX * 177), chkboxYOffset, (DWORD)(53 * dlgBaseUnitX), chkboxHeight, SWP_NOZORDER);

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

		DeferWindowPos(hdwp, stF, NULL, captionXOffset, 0, (DWORD)(34 * dlgBaseUnitX), captionHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, stR, NULL, captionXOffset, textboxYSpacing, (DWORD)(36 * dlgBaseUnitX), captionHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, txF, NULL, 0, captionHSpace, textboxWidth, textboxYSpacing - captionHSpace, SWP_NOZORDER);
		DeferWindowPos(hdwp, txR, NULL, 0, textboxYSpacing + captionHSpace, textboxWidth, textboxYSpacing - captionHSpace, SWP_NOZORDER);

		// Move buttons
		HWND butFind = GetDlgItem(hDlg, IDC_FIND);
		HWND butFindAll = GetDlgItem(hDlg, IDC_FINDALL);
		HWND butRep = GetDlgItem(hDlg, IDC_REPLACE);
		HWND butRepAll = GetDlgItem(hDlg, IDC_REPLACEALL);

		DWORD buttonWidth = (DWORD)(20 * dlgBaseUnitX);
		DWORD buttonHeight = (textboxYSpacing - captionHSpace) / 2;

		DeferWindowPos(hdwp, butFind, NULL, textboxWidth, captionHSpace, buttonWidth, buttonHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, butFindAll, NULL, textboxWidth, buttonHeight + captionHSpace, buttonWidth, buttonHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, butRep, NULL, textboxWidth, textboxYSpacing + captionHSpace, buttonWidth, buttonHeight, SWP_NOZORDER);
		DeferWindowPos(hdwp, butRepAll, NULL, textboxWidth, textboxYSpacing + buttonHeight + captionHSpace, buttonWidth, buttonHeight, SWP_NOZORDER);

		EndDeferWindowPos(hdwp);

		return TRUE;
	}

	case WM_COMMAND:
		switch(LOWORD(wParam))
		{
		case IDC_FIND:
		case IDC_FINDALL:
		case IDC_REPLACE:
		case IDC_REPLACEALL:
		{
			SearchQuery q;
			HWND txF = GetDlgItem(hDlg, IDC_FINDTEXT);
			HWND txR = GetDlgItem(hDlg, IDC_REPLACETEXT);
			HWND chkRegex = GetDlgItem(hDlg, IDC_USEREGEX);
			HWND chkCase = GetDlgItem(hDlg, IDC_CASESENSITIVE);
			HWND chkWord = GetDlgItem(hDlg, IDC_WHOLEWORD);
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
			if(SendMessage(chkInSel, BM_GETCHECK, 0, 0) == BST_CHECKED) q.searchFlag |= SEARCHFLAG_INSELECTION;

			SendMessage(hParent, FindReplaceMsg, 0, (LPARAM)&q);
			return TRUE;
		}
		}

	case WM_CLOSE:
		EndDialog(hDlg, 0);
		return TRUE;
	}

	return FALSE;
}