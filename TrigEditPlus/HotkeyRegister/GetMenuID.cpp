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
#include <WindowsX.h>

extern const char* PluginMenuName;


// ------------------------

static WNDPROC parentWindowProc;
static LONG checkerTimerID;
static const int timerDuration = 100;

VOID CALLBACK menuChecker(HWND hWnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime);

void BindMenuCheckerTimer(HWND hSCMDraft2Wnd)
{
	SetTimer(hSCMDraft2Wnd, 0, timerDuration, menuChecker);
}






VOID CALLBACK menuChecker(HWND hWnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime)
{
	HMENU menu = GetMenu(hWnd);

	KillTimer(hWnd, idEvent);
}