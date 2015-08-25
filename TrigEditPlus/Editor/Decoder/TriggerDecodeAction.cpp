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

#include "../TriggerEditor.h"
#include "../TriggerEncDec.h"
#include "../UnitProp.h"

extern TriggerStatementDecl ActionFields[57];

std::string DecodeUPRPData(const UPRPData* data);

void TriggerEditor::DecodeAction(StringBuffer& buf, const TrigAct& content) const {
	buf << "\t\t";

	if(content.prop & 0x2) {
		buf << "Disabled(";
	}

	if(content.acttype == 0);
	else if(content.acttype > 57) {
		buf << "Action("
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
			<< ")";
	}

	else {
		int acttype = content.acttype;
		TriggerStatementDecl &decl = ActionFields[acttype - 1];

		if(acttype == SETDEATHS)
		{
			uint32_t player = content.player;
			uint32_t unitid = content.setting;
			if(player >= 12 || unitid >= 228)  // EUD/EPD action
			{
				uint32_t number = content.target;
				uint32_t offset = 0x58A364 + 4 * player + 48 * unitid;
				uint32_t modtype = content.num;
				
				char offsetstr[11]; sprintf(offsetstr, "0x%06X", offset);
				buf << "SetMemory(" << offsetstr << ", " << DecodeModifier(modtype) << ", " << number << ")";
				goto actdec_overridden;
			}
		}

		buf << decl.stmt_name << "(";

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
			case FIELDTYPE_UNITPROPERTY:
				{
					if(value == 0 || value > 64) str = DecodeNumber(value);
					else {
						UPRPData* uprp = &((UPRPData*)_editordata->UnitProperties->ChunkData)[value - 1];
						str = DecodeUPRPData(uprp); break;
					}
				}
				break;

			default: throw std::bad_exception("TT");
			}

			if(firstfield) firstfield = false;
			else buf << ", ";
			buf << str;
		}

		buf << ")";
actdec_overridden:;
	}

	if(content.prop & 0x2) {
		buf << ");\r\n";
	}

	else {
		buf << ";\r\n";
	}
}