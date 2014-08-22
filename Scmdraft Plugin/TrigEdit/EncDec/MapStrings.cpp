#include "../TriggerEditor.h"
#include "../StringUtils/StringCast.h"

std::string TriggerEditor::DecodeString(int value) const {
	SI_VirtSCStringList* stb = _editordata->EngineData->MapStrings;
	const char* rawstr = StringTable_GetString(stb, value);
	if(rawstr == NULL) return Int2String(value);
	else {
		return Raw2CString(rawstr);

		/*
		// I tried to pretty-print newlines in string, but it ruined output readability.
		const char* nl_pos = strstr(rawstr, "\r\n");

		if(nl_pos == NULL) {
			return Raw2CString(rawstr);
		}

		else {
			StringBuffer sb;
			do {
				sb << "\r\n\t\t" << Raw2CString(std::string(rawstr, nl_pos + 2));
				rawstr = nl_pos + 2;
				nl_pos = strstr(rawstr, "\r\n");
			} while(nl_pos != NULL);
			sb << "\r\n\t\t" << Raw2CString(rawstr);
			return sb.str();
		}
		*/
	}
}

int TriggerEditor::EncodeString(const std::string& str) const {
	return 0;
}
