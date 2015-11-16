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

// Code stripped from http://www.purebasic.fr/english/viewtopic.php?f=12&t=60983

#include "TriggerEditor.h"
#include "Scintilla/SciLexer.h"

#define MARGIN_SCRIPT_FOLD_INDEX 2

void ApplyMinimapStyle(TriggerEditor* te) {

	te->SendSciMessage(SCI_SETDOCPOINTER, 0, te->SendSciMessage(SCI_GETDOCPOINTER, 0, 0, SCI_TARGET_MAIN), SCI_TARGET_MINI);
	te->SendSciMessage(SCI_SETMARGINWIDTHN, 0, 0, SCI_TARGET_MINI);
	te->SendSciMessage(SCI_SETMARGINWIDTHN, 1, 0, SCI_TARGET_MINI);
	te->SendSciMessage(SCI_SETMARGINWIDTHN, 2, 0, SCI_TARGET_MINI);

	te->SendSciMessage(SCI_STYLESETSIZE, STYLE_DEFAULT, 2, SCI_TARGET_MINI);
	te->SendSciMessage(SCI_STYLESETBACK, STYLE_DEFAULT, RGB(70, 78, 85), SCI_TARGET_MINI);
	te->SendSciMessage(SCI_STYLESETFORE, STYLE_DEFAULT, RGB(195, 213, 255), SCI_TARGET_MINI);
	te->SendSciMessage(SCI_STYLECLEARALL, 0, 0, SCI_TARGET_MINI);
	te->SendSciMessage(SCI_SETVSCROLLBAR, 0, 0, SCI_TARGET_MINI);
	te->SendSciMessage(SCI_SETHSCROLLBAR, 0, 0, SCI_TARGET_MINI);
}
