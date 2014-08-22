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

	std::ofstream os("output.lua", std::ios::binary);
	os << GetEditorText();
	os.close();

	MessageBox(hSCMD2MainWindow, "Press OK when you've modified your triggers.", "Waiting", MB_OK);

	std::ifstream is("output.lua", std::ios::binary);
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
		MessageBox(hSCMD2MainWindow, "Compile failed", "Error", MB_OK);
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
	;
}


void TriggerEditor::PrintErrorMessage(const std::string& msg) {
	std::cerr << msg.c_str() << "\n";
}