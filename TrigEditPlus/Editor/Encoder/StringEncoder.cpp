#include "../MapNamespace.h"
#include "../TriggerEditor.h"


int TriggerEditor::EncodeUnit(const std::string &str) const {
	return _namespace->GetUnitID(str);
}

int TriggerEditor::EncodeLocation(const std::string &str) const {
	return _namespace->GetLocationID(str);
}

int TriggerEditor::EncodeSwitchName(const std::string &str) const {
	return _namespace->GetSwitchID(str);

}

int TriggerEditor::EncodeString(const std::string &str) const {
	SI_VirtSCStringList* stb = _editordata->EngineData->MapStrings;
	return StringTable_AddString(stb, str.c_str(), 'GIRT', 0);
}
