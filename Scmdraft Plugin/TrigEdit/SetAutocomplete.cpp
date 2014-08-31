#include "TriggerEditor.h"
#include "TriggerEncDec.h"
#include <WindowsX.h>
/*
FIELDTYPE_NONE,
FIELDTYPE_NUMBER,
FIELDTYPE_ALLYSTATUS,
FIELDTYPE_COMPARISON,
FIELDTYPE_MODIFIER,
FIELDTYPE_ORDER,
FIELDTYPE_PLAYER,
FIELDTYPE_PROPSTATE,
FIELDTYPE_RESOURCE,
FIELDTYPE_SCORE,
FIELDTYPE_SWITCHACTION,
FIELDTYPE_SWITCHSTATE,
FIELDTYPE_AISCRIPT,
FIELDTYPE_COUNT,
FIELDTYPE_UNIT,
FIELDTYPE_LOCATION,
FIELDTYPE_STRING,
FIELDTYPE_SWITCHNAME,
*/

const char* const_autocomplete_list[][40] = {
	{}, // None
	{}, // Number
	{"Enemy", "Ally", "AlliedVictory"}, //AllyStatus
	{"AtLeast", "AtMost", "Exactly"}, //Comparison
	{"SetTo", "Add", "Subtract"}, //Modifier
	{"Move", "Patrol", "Attack"}, //Order
	{"P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9", "P10", "P11", "P12",
	"CurrentPlayer", "Foes", "Allies", "NeutralPlayers", "AllPlayers", "Force1",
	"Force2", "Force3", "Force4", "NonAlliedVictoryPlayers"}, //Player
	{"Enable", "Disable", "Toggle"}, //PropState
	{"Ore", "Gas", "OreAndGas"}, //Resource
	{"Total", "Units", "Buildings", "UnitsAndBuildings", "Kills", "Razings","KillsAndRazings", "Custom"}, //Score
	{"Set", "Clear", "Toggle", "Random"}, //SwitchAction
	{"Set", "Cleared"}, //SwitchState
};

struct AIScriptEntry{
	DWORD aidw;
	const char* str;
};

extern AIScriptEntry AIScriptList[];

void SetAutocompleteList(TriggerEditor* te, FieldType ft, const char* inputtext) {
	HWND hElmnTable = te->hElmnTable;

	if(ft == FIELDTYPE_NONE) {
		if(te->currentft == ft);
		else {
			te->currentft = ft;
			ListBox_ResetContent(hElmnTable);
		}
		return;
	}

	int slen = strlen(inputtext);

	// trim string
	int trimstart = 0, trimend = slen;
	while(trimstart < slen && isspace((unsigned char)inputtext[++trimstart]));
	while(trimend >= 0      && isspace((unsigned char)inputtext[--trimend]));

	std::string s; // default initialized to empty string
	if(trimstart == slen); //empty string
	else s.assign(inputtext + trimstart, inputtext + trimend + 1);


	// update autocompletelist
	
	if(te->currentft == ft);
	else {
		te->currentft = ft;
		ListBox_ResetContent(hElmnTable);

		// get autocompletion list for field type.
		if(ft == FIELDTYPE_NONE || ft == FIELDTYPE_NUMBER);
		else if(ft < FIELDTYPE_SWITCHSTATE) {
			const char** autocompletionlist = const_autocomplete_list[ft];
			for(const char** p = autocompletionlist ; *p != NULL ; p++) {
				ListBox_AddString(hElmnTable, *p);
			}
		}

		else if(ft == FIELDTYPE_AISCRIPT) {
			for(AIScriptEntry* p = AIScriptList ; p->str != NULL ; p++) {
				ListBox_AddString(hElmnTable, p->str);
			}
		}

		else if(ft == FIELDTYPE_UNIT) {
			for(int i = 0 ; i < 232 ; i++) {
				ListBox_AddString(hElmnTable, te->DecodeUnit(i).c_str());
			}
		}

		else if(ft == FIELDTYPE_LOCATION) {
			for(int i = 0 ; i < 255 ; i++) {
				//if(te->_editordata->EngineData->MapLocations[i].Exists) {
					ListBox_AddString(hElmnTable, te->DecodeLocation(i).c_str());
				//}
			}
		}

		else if(ft == FIELDTYPE_SWITCHNAME) {
			for(int i = 0 ; i < 256 ; i++) {
				ListBox_AddString(hElmnTable, te->DecodeSwitchName(i).c_str());
			}
		}
	}

	int findindex = ListBox_FindString(hElmnTable, 0, s.c_str());
	if(findindex != LB_ERR) ListBox_SetCurSel(hElmnTable, findindex);
}


void ApplyAutocomplete(TriggerEditor* te) {
	HWND hElmnTable = te->hElmnTable;
	int current_item = ListBox_GetCurSel(hElmnTable);
	if(current_item == LB_ERR) return; // No selected item.

	// Get autocompletion text.
	char sLen = ListBox_GetTextLen(hElmnTable, current_item);
	char *replace_text = new char[sLen + 1];
	ListBox_GetText(hElmnTable, current_item, replace_text);

	// Select range to replace.
	int current_pos = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
	int doclen = te->SendSciMessage(SCI_GETLENGTH, 0, 0);
	const char* doc_text = (const char*)te->SendSciMessage(SCI_GETCHARACTERPOINTER, 0, 0);

	
	// Select current argument.
	int p_depth;

	// find the last comma before current position.
	int last_comma = current_pos - 1;
	p_depth = 0;
	while(last_comma >= 0) {
		if(doc_text[last_comma] == '(') {
			p_depth--;
			if(p_depth == -1) break;
		}
		else if(doc_text[last_comma] == ')') {
			p_depth++;
		}

		else if(doc_text[last_comma] == ',') {
			if(p_depth == 0) break;
		}
		last_comma--;
	}
	if(p_depth > 0) return; // Invalid;
	last_comma++;

	// find the fist comma/newline after current position.
	int first_comma = current_pos;
	p_depth = 0;
	while(first_comma < doclen) {
		if(doc_text[first_comma] == ')') {
			p_depth--;
			if(p_depth == -1) break;
		}
		else if(doc_text[first_comma] == '(') {
			p_depth++;
		}

		else if(doc_text[first_comma] == ',' || doc_text[first_comma] == '\n') {
			if(p_depth == 0) break;
		}
		first_comma++;
	}
	if(p_depth > 0) return; // Invalid;

	te->SendSciMessage(SCI_SETSELECTION, last_comma, first_comma);
	te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)" ");
	te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)replace_text);

	delete[] replace_text;
}