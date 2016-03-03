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


// Uses techniques described int http://stackoverflow.com/questions/3547945/how-to-use-an-accelerator-table-in-a-modal-dialog-box
// to create custom accelerator table.

#include <Windows.h>
#include "../PluginBase/SCMDPlugin.h"

extern const char* PluginMenuName;


// ------------------------

static WNDPROC parentWindowProc;
static LONG checkerTimerID;
static const int timerDuration = 100;

VOID CALLBACK menuChecker(HWND hWnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime);




VOID CALLBACK menuChecker(HWND hWnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime)
{
	HMENU menu = GetMenu(hWnd);

	KillTimer(hWnd, idEvent);
}

HACCEL GenerateCustonAccelerator(UINT menuID)
{
	return NULL;
}



static HWND g_hDialog = NULL;
static HHOOK g_hHook = NULL;
static HACCEL g_hAccel;
static LRESULT CALLBACK HookProc(int nCode, WPARAM wParam, LPARAM lParam)
{
	LRESULT nResult = 1;
	if (nCode == HC_ACTION && wParam == PM_REMOVE)
	{
		MSG *p = (MSG*)lParam;
		if (p->message >= WM_KEYFIRST && p->message <= WM_KEYLAST)
			if (g_hDialog == GetForegroundWindow())
			{
				HWND gf = GetFocus(); // ignore if edit-able control
				if (DLGC_HASSETSEL & ~SendMessage(gf, WM_GETDLGCODE, 0, 0)
					|| ES_READONLY & GetWindowLong(gf, GWL_STYLE))
				{
					if(g_hAccel) {
						if (TranslateAcceleratorW(g_hDialog, g_hAccel, p))
						{
							p->message = WM_NULL;
							nResult = 0;
						}
					}
				}
			}
	}
	if (nCode < 0 || nResult)
		return CallNextHookEx(g_hHook, nCode, wParam, lParam);
	return nResult;
}

static INT_PTR CALLBACK DialogProc(HWND hWnd, UINT Msg,
	WPARAM wParam, LPARAM lParam)
{
	switch (Msg)
	{
	case WM_INITDIALOG:
		g_hHook = SetWindowsHookEx(WH_GETMESSAGE, HookProc, hSCMD2Instance, GetCurrentThreadId());
		g_hDialog = hWnd;
		return 1;
	case WM_NCDESTROY:
		UnhookWindowsHookEx(g_hHook);
		break;
	}
	return 0;
}