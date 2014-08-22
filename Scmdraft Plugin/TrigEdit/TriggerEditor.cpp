#include "TriggerEditor.h"
#include "EncDec/MapNamespace.h"
#include <iostream>

TriggerEditor::TriggerEditor() : hTrigDlg(NULL), hScintilla(NULL),
	_currenttrigger(0), _current_condition(0), _current_action(0) {}

TriggerEditor::~TriggerEditor() {}

int TriggerEditor::RunEditor(HWND hMain, TriggerEditor_Arg& arg) {
	_editordata = &arg;

	// Decode TRIG chunk into trigger array
	_namespace = new MapNamespace(arg);

	// Queue deletion of _namespace
	class _remover{
	public:
		_remover(TriggerEditor* t) : _t(t) {}
		~_remover() { delete _t->_namespace; }
	private:
		TriggerEditor* _t;
	} A(this);



	std::vector<Trig> trigv;
	{
		size_t trign = arg.Triggers->ChunkSize / 2400;
		BYTE* trigdata = arg.Triggers->ChunkData;
		for(size_t i = 0 ; i < trign ; i++) {
			trigv.push_back(*(Trig*)trigdata);
			trigdata += 2400;
		}
	}


	BeginDecode();
	
	for(auto trig : trigv) {
		DecodeTrigger(trig);
	}

	std::cout << EndDecode();
	return 0;
}