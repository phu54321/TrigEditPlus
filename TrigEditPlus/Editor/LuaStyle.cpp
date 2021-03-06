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
#include "Scintilla/SciLexer.h"

#define MARGIN_SCRIPT_FOLD_INDEX 2

void ApplyEditorStyle(TriggerEditor* te) {
	// Lua syntax highlighting
	const char* luaKeywords =
		"and break do else elseif end false for function if"
		"in local nil not or repeat return then true until while";

	te->SendSciMessage(SCI_SETLEXER, SCLEX_LUA, 0);
	te->SendSciMessage(SCI_SETKEYWORDS, 0, (LPARAM)luaKeywords);

	// Korean thing
	te->SendSciMessage(SCI_SETCODEPAGE, 949, 0);

	// Multiple selection
	te->SendSciMessage(SCI_SETMULTIPLESELECTION, 1, 0);
	te->SendSciMessage(SCI_SETADDITIONALSELECTIONTYPING, 1, 0);
	te->SendSciMessage(SCI_SETMULTIPASTE, 1, 0);

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
	te->SendSciMessage(SCI_STYLESETFORE, 12, RGB(0xC0, 0xA0, 0xC0));
	te->SendSciMessage(SCI_STYLESETFORE, 13, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 14, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 15, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 16, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 17, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 18, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 19, RGB(0x00, 0x00, 0x7F));
	te->SendSciMessage(SCI_STYLESETFORE, 20, RGB(0x7F, 0x7F, 0x00));
	te->SendSciMessage(SCI_STYLESETFORE, 32, RGB(0xA8, 0xA8, 0xA8)); // Fold line

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

	// Folder
	te->SendSciMessage(SCI_SETPROPERTY, (WPARAM)"fold", (LPARAM)"1");
	te->SendSciMessage(SCI_SETPROPERTY, (WPARAM)"fold.compact", (LPARAM)"1");
	te->SendSciMessage(SCI_SETMARGINWIDTHN, 2, 16);  // Fold

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

	// Font & ab
	te->SendSciMessage(SCI_STYLESETFONT, STYLE_DEFAULT, (LPARAM)"Courier New");
	te->SendSciMessage(SCI_STYLESETFONT, STYLE_DEFAULT, (LPARAM)"Consolas");
	te->SendSciMessage(SCI_SETTABWIDTH, 4, 0);

	// Scrolling
	te->SendSciMessage(SCI_SETYCARETPOLICY, CARET_SLOP | CARET_STRICT | CARET_EVEN, 5);

	// EOL
	te->SendSciMessage(SCI_SETEOLMODE, SC_EOL_CRLF, 0);
}
