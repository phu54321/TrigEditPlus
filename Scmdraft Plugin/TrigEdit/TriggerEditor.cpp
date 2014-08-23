#include "TriggerEditor.h"
#include "MapNamespace.h"
#include <fstream>

#include <iostream>

TriggerEditor::TriggerEditor() : hTrigDlg(NULL), hScintilla(NULL) {}

TriggerEditor::~TriggerEditor() {}

int TriggerEditor::RunEditor(HWND hMain, TriggerEditor_Arg& arg) {
	_editordata = &arg;
	_namespace = new MapNamespace(arg);

	DecodeTriggers();

	std::ofstream os("trigeditplus.lua", std::ios::binary);
	os << GetEditorText();
	os.close();

	if((int)ShellExecute(hMain, "edit", "trigeditplus.lua", NULL, NULL, SW_SHOW) == SE_ERR_ASSOCINCOMPLETE) {
		ShellExecute(hMain, "open", "trigeditplus.lua", NULL, NULL, SW_SHOW);
	}
	MessageBox(hSCMD2MainWindow, "Press OK when you completed modifying your triggers.", "Waiting", MB_OK);

compile_retry:

	std::ifstream is("trigeditplus.lua2", std::ios::binary);
	is.seekg(0, std::ios::end);
	size_t fsize = (size_t)is.tellg();
	is.seekg(0);
	char* data = new char[fsize + 1];
	is.read(data, fsize);
	is.close();
	data[fsize] = '\0';
	SetEditorText(data);
	delete[] data;

	if(EncodeTriggerCode()) {
		MessageBox(hSCMD2MainWindow, "Trigger successfully updated", "OK", MB_OK);
	}

	else {
		_errlist << "Retry compile?";
		int retry = MessageBox(hSCMD2MainWindow, _errlist.str().c_str(), NULL, MB_YESNO);
		if(retry == IDYES) goto compile_retry;
	}

	delete _namespace;
	return 0;
}


void TriggerEditor::SetEditorText(const std::string& str) {
	_tmp_content = str;
}

std::string TriggerEditor::GetEditorText() const {
	return _tmp_content;
}


void TriggerEditor::ClearErrors() {
	_errlist.clear();
	_errlist << "Compile failed because of the following reason:\r\n";
}


void TriggerEditor::PrintErrorMessage(const std::string& msg) {
	_errlist << msg.c_str() << "\r\n";
}