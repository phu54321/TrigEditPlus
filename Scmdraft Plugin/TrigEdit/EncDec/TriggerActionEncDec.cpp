#include "../TriggerEditor.h"
#include "TriggerEncDec.h"

extern TriggerStatementDecl ActionFields[57];

void TriggerEditor::DecodeAction(const TrigAct& content) {
    if(content.acttype == 0) return;
	if(content.acttype > 57) {
        _decode_out << "\t\tCustom("
            << content.locid << ", "
            << content.strid << ", "
            << content.wavid << ", "
            << content.time << ", "
            << content.player << ", "
            << content.target << ", "
            << content.setting << ", "
            << content.acttype << ", "
            << content.num << ", "
            << content.prop
            << ")\r\n";
		return;
    }

	int acttype = content.acttype;
	TriggerStatementDecl &decl = ActionFields[acttype - 1];

	_decode_out << "\t\t" << decl.stmt_name << "(";
	
	bool firstfield = true;

	for(int i = 0 ; decl.fields[i].Type != 0 ; i++) {
		// Get value
		int value;
		switch(decl.fields[i].Field) {
		case ACTFIELD_LOCID: value = content.locid; break;
		case ACTFIELD_STRID: value = content.strid; break;
		case ACTFIELD_WAVID: value = content.wavid; break;
		case ACTFIELD_TIME: value = content.time; break;
		case ACTFIELD_PLAYER: value = content.player; break;
		case ACTFIELD_TARGET: value = content.target; break;
		case ACTFIELD_SETTING: value = content.setting; break;
		case ACTFIELD_ACTTYPE: value = content.acttype; break;
		case ACTFIELD_NUM: value = content.num; break;
		case ACTFIELD_PROP: value = content.prop; break;
		default: throw std::bad_exception("TT");
		}

		// Decode value according to field type.
		std::string str;
		switch(decl.fields[i].Type) {
		    case FIELDTYPE_NUMBER:       str = DecodeNumber(value); break;
			case FIELDTYPE_ALLYSTATUS:   str = DecodeAllyStatus(value); break;
			case FIELDTYPE_COMPARISON:   str = DecodeComparison(value); break;
			case FIELDTYPE_MODIFIER:     str = DecodeModifier(value); break;
			case FIELDTYPE_ORDER:        str = DecodeOrder(value); break;
			case FIELDTYPE_PLAYER:       str = DecodePlayer(value); break;
			case FIELDTYPE_PROPSTATE:    str = DecodePropState(value); break;
			case FIELDTYPE_RESOURCE:     str = DecodeResource(value); break;
			case FIELDTYPE_SCORE:        str = DecodeScore(value); break;
			case FIELDTYPE_SWITCHACTION: str = DecodeSwitchAction(value); break;
			case FIELDTYPE_SWITCHSTATE:  str = DecodeSwitchState(value); break;
			case FIELDTYPE_AISCRIPT:     str = DecodeAIScript(value); break;
			case FIELDTYPE_COUNT:        str = DecodeCount(value); break;
			case FIELDTYPE_UNIT:         str = DecodeUnit(value); break;
			case FIELDTYPE_LOCATION:     str = DecodeLocation(value); break;
			case FIELDTYPE_STRING:       str = DecodeString(value); break;
			case FIELDTYPE_SWITCHNAME:   str = DecodeSwitchName(value); break;
			default: throw std::bad_exception("TT");
		}

		if(firstfield) firstfield = false;
		else _decode_out << ", ";
		_decode_out << str;
	}

	_decode_out << ")\r\n";
}