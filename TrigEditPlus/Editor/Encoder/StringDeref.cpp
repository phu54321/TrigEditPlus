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
#include <assert.h>

extern TriggerStatementDecl ConditionFields[23];
extern TriggerStatementDecl ActionFields[57];

// Dereference every strings previously referenced by trigger.
void TriggerEditor::DerefStrings() {
	Trig* trg = (Trig*)_editordata->Triggers->ChunkData;
	size_t trgn = _editordata->Triggers->ChunkSize / 2400;
	SI_VirtSCStringList* strtb = _editordata->EngineData->MapStrings;

	int stringn = StringTable_GetTotalStringNum(strtb);

	// For every trigger
	for(size_t t = 0 ; t < trgn ; t++) {

		// For every conditions
		for(int c = 0 ; c < 16 ; c++) {
			uint8_t condtype = trg[t].cond[c].condtype;
			if(condtype == 0 || condtype > 23) break;
			TriggerStatementDecl &decl = ConditionFields[condtype - 1];

			// Dereference all fields
			for(int i = 0 ; decl.fields[i].Type != 0 ; i++) {
				if(decl.fields[i].Type == FIELDTYPE_STRING) {
					int stringid;
					switch(decl.fields[i].Field) {
					case CONDFIELD_LOCID:        stringid = trg[t].cond[c].locid; break;
					case CONDFIELD_PLAYER:       stringid = trg[t].cond[c].player; break;
					case CONDFIELD_RES:          stringid = trg[t].cond[c].res; break;
					case CONDFIELD_UID:          stringid = trg[t].cond[c].uid; break;
					case CONDFIELD_SETTING:      stringid = trg[t].cond[c].setting; break;
					case CONDFIELD_CONDTYPE:     stringid = trg[t].cond[c].condtype; break;
					case CONDFIELD_RES_SETTING:  stringid = trg[t].cond[c].res_setting; break;
					case CONDFIELD_PROP:         stringid = trg[t].cond[c].prop; break;
					default: throw -1; //couldn't happen
					}

					if(stringid > stringn || stringid < 0) continue; // Invalid string id
					StringTable_Dereference(strtb, stringid, 'GIRT', 0);
				}
			}
		}

		// For every actions
		for(int a = 0 ; a < 64 ; a++) {
			uint8_t acttype = trg[t].act[a].acttype;
			if(acttype == 0 || acttype > 57) break;
			TriggerStatementDecl &decl = ActionFields[acttype - 1];

			// Dereference all fields
			for(int i = 0 ; decl.fields[i].Type != 0 ; i++) {
				if(decl.fields[i].Type == FIELDTYPE_STRING) {
					int stringid;
					switch(decl.fields[i].Field) {
					case ACTFIELD_LOCID:   stringid = trg[t].act[a].locid; break;
					case ACTFIELD_STRID:   stringid = trg[t].act[a].strid; break;
					case ACTFIELD_WAVID:   stringid = trg[t].act[a].wavid; break;
					case ACTFIELD_TIME:    stringid = trg[t].act[a].time; break;
					case ACTFIELD_PLAYER:  stringid = trg[t].act[a].player; break;
					case ACTFIELD_TARGET:  stringid = trg[t].act[a].target; break;
					case ACTFIELD_SETTING: stringid = trg[t].act[a].setting; break;
					case ACTFIELD_ACTTYPE: stringid = trg[t].act[a].acttype; break;
					case ACTFIELD_NUM:     stringid = trg[t].act[a].num; break;
					case ACTFIELD_PROP:    stringid = trg[t].act[a].prop; break;
					default: throw -1; //couldn't happen
					}

					if(stringid > stringn || stringid < 0) continue; // Invalid string id
					StringTable_Dereference(strtb, stringid, 'GIRT', 0);
				}
			}
		}
	}
}