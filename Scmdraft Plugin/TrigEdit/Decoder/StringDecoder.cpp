#include "../MapNamespace.h"
#include "../TriggerEditor.h"
#include "../StringUtils/StringCast.h"


// Decoder part
std::string TriggerEditor::DecodeUnit(int value) const {
	return _namespace->GetUnitName(value);
}

std::string TriggerEditor::DecodeLocation(int value) const {
	return _namespace->GetLocationName(value);
}

std::string TriggerEditor::DecodeSwitchName(int value) const {
	return _namespace->GetSwitchName(value);
}

std::string TriggerEditor::DecodeString(int value) const {
	SI_VirtSCStringList* stb = _editordata->EngineData->MapStrings;
	const char* rawstr = StringTable_GetString(stb, value);
	if(rawstr == NULL) return Int2String(value);
	else return Raw2CString(rawstr);
}
