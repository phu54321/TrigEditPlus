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

#include "TriggerEditor.h"
#include "TriggerEncDec.h"
#include "Lua/LuaKeywords.h"
#include <windowsx.h>
#include <algorithm>

const char* const_autocomplete_list[][40] = {
	{}, // None
	{}, // Number
	{ "Enemy", "Ally", "AlliedVictory" }, //AllyStatus
	{ "AtLeast", "AtMost", "Exactly" }, //Comparison
	{ "SetTo", "Add", "Subtract" }, //Modifier
	{ "Move", "Patrol", "Attack" }, //Order
	{ "P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9", "P10", "P11", "P12",
	"CurrentPlayer", "Foes", "Allies", "NeutralPlayers", "AllPlayers", "Force1",
	"Force2", "Force3", "Force4", "NonAlliedVictoryPlayers" }, //Player
	{ "Enable", "Disable", "Toggle" }, //PropState
	{ "Ore", "Gas", "OreAndGas" }, //Resource
	{ "Total", "Units", "Buildings", "UnitsAndBuildings", "Kills", "Razings", "KillsAndRazings", "Custom" }, //Score
	{ "Set", "Clear", "Toggle", "Random" }, //SwitchAction
	{ "Set", "Cleared" }, //SwitchState
};

struct AIScriptEntry
{
	DWORD aidw;
	const char* str;
};

extern AIScriptEntry AIScriptList[];

// DBCS-safe version. maybe.
inline wchar_t dbcs_tolower(wchar_t ch)
{
	if('A' <= ch && ch <= 'Z') return ch + ('a' - 'A');
	else return ch;
}

// Simple similarity ranker. Inspired from Sublime Text Fuzzy String Matching algorithm.
// Independently developed, though.

int CalculateStringAcceptance(const std::wstring& keyword, const std::wstring& matched_text)
{

	const int max_prioritized_char_dist = 3;
	const int max_prioritized_wordstart_dist = 4;

	int index = 0;
	int rank = 0;
	const int match_maxidx = matched_text.size();

	for(wchar_t ch : keyword)
	{
		int previndex = index;

		// Find matching index
		while(dbcs_tolower(matched_text[index]) != dbcs_tolower(ch))
		{
			index++;
			if(index >= match_maxidx) return -1;  // Match failed
		}

		// Value smaller distance between match characters
		int chdist = index - previndex, chd_mul;
		if(chdist >= max_prioritized_char_dist) chd_mul = 1;
		else chd_mul = max_prioritized_char_dist - chdist;

		// Value smaller distance between word start and matched character
		int wsindex = index;  // Word start position
		while(wsindex >= 0)
		{
			wchar_t wsi_ch = matched_text[wsindex];
			// Space can be seperator
			if(wsi_ch == ' ')
			{
				wsindex++;
				break;
			}
			else if(!('a' <= wsi_ch && wsi_ch <= 'z')) break;  // Capical character can be word start
			wsindex--;
		}
		int wsdist = index - wsindex, wsd_mul;
		if(wsdist >= max_prioritized_wordstart_dist) wsd_mul = 1;
		else wsd_mul = max_prioritized_wordstart_dist - wsdist;

		rank += 100 * chd_mul * wsd_mul;

		index++;
	}

	// If two string has same length (maybe rank was determined in common prefix)
	// shorter string should have more rank.
	int slen = matched_text.size();
	if(slen < 100) rank += 100 - slen;

	return rank;
}



// -----------------------------------


static std::wstring s2ws(const std::string& s)
{
	size_t buflen = MultiByteToWideChar(CP_OEMCP, 0, s.c_str(), -1, 0, 0);
	std::wstring ws(buflen, 0);
	MultiByteToWideChar(CP_OEMCP, 0, s.data(), s.size(), (wchar_t*)ws.data(), ws.size());
	ws.resize(ws.size() - 1);  // Kill '\0';
	return ws;
}

std::wstring unpack_hangeul(const std::wstring& in);


bool _isAutocompleteWorking = false;
bool isAutocompletionSet()
{
	return _isAutocompleteWorking;
}

void SetAutocompleteList(TriggerEditor* te, FieldType ft, const char* inputtext)
{
	// trim inputtext
	int slen = strlen(inputtext);
	int trimstart = -1, trimend = slen;
	while(trimstart < slen && isspace((unsigned char)inputtext[++trimstart]));
	while(trimend >= 0 && isspace((unsigned char)inputtext[--trimend]));
	trimend++;

	std::string _keyword; // default initialized to empty string
	if(trimstart == slen); // empty string
	else _keyword.assign(inputtext + trimstart, inputtext + trimend);
	std::wstring keyword = s2ws(_keyword);


	// Get list of available arguments for field type
	std::vector<std::string> stringlist;

	if(ft == FIELDTYPE_NONE)
	{
		if(keyword.size() == 0)
		{
			if(_isAutocompleteWorking)
			{
				te->SendSciMessage(SCI_AUTOCCANCEL, 0, 0);
			}
			_isAutocompleteWorking = false;
			return;
		}
		stringlist = GetLuaKeywords();
	}
	else if(ft == FIELDTYPE_NUMBER);
	else if(ft < FIELDTYPE_SWITCHSTATE)
	{
		const char** autocompletionlist = const_autocomplete_list[ft];
		for(const char** p = autocompletionlist; *p != NULL; p++)
		{
			stringlist.push_back(*p);
		}
	}

	else if(ft == FIELDTYPE_AISCRIPT)
	{
		for(AIScriptEntry* p = AIScriptList; p->str != NULL; p++)
		{
			stringlist.push_back(p->str);
		}
	}

	else if(ft == FIELDTYPE_UNIT)
	{
		for(int i = 0; i < 233; i++)
		{
			stringlist.push_back(te->DecodeUnit(i).c_str());
		}
	}

	else if(ft == FIELDTYPE_LOCATION)
	{
		for(int i = 1; i <= 255; i++)
		{
			stringlist.push_back(te->DecodeLocation(i).c_str());
		}
	}

	else if(ft == FIELDTYPE_SWITCHNAME)
	{
		for(int i = 0; i < 256; i++)
		{
			stringlist.push_back(te->DecodeSwitchName(i).c_str());
		}
	}

	// Sort them with ranks
	std::vector<std::pair<
		int, 
		std::shared_ptr<std::string>>
	> autocomplete_list;
	std::wstring unpacked_keyword = unpack_hangeul(keyword);
	for(const std::string& s : stringlist)
	{
		int rank = CalculateStringAcceptance(unpacked_keyword, unpack_hangeul(s2ws(s)));
		if(rank > 0)
		{
			autocomplete_list.push_back(std::make_pair(
				rank,
				std::shared_ptr<std::string>(new std::string(s))
			));
		}
	}
	
	// Some trick
	// _isAutocompleteWorking was true -> it becomes false
	// _isAutocompleteWorking wav false -> it becomes true
	// if autocomplete happens, it is set to true
	// -- goto (*)
	_isAutocompleteWorking = !_isAutocompleteWorking;
	if(!autocomplete_list.empty() && autocomplete_list.size() < 300)
	{
		// Update listbox
		std::stable_sort(autocomplete_list.begin(), autocomplete_list.end());
		std::reverse(autocomplete_list.begin(), autocomplete_list.end());
		
		// Create string for scintilla autocompletion.
		int scsize = 0;
		for(const auto& it : autocomplete_list)
		{
			scsize += 1 + it.second->size();
		}
		if(scsize <= 65536)  // Too long
		{
			// Join function names to string.
			char *aclists = new char[scsize], *p = aclists;
			for(const auto& it : autocomplete_list)
			{
				strcpy(p, it.second->c_str());
				p += it.second->size();
				*p++ = -1;
			}
			*(--p) = '\0';
			te->SendSciMessage(SCI_AUTOCSHOW, _keyword.size(), (LPARAM)aclists);
			te->SendSciMessage(SCI_AUTOCSELECT_NUMERIC, 0, 0);  // Force select first element
			delete[] aclists;
			_isAutocompleteWorking = true;
		}
	}

	// (*) So, if _isAutocompleteWorking happens to be false here, it means that
	//   - _isAutocompleteWorking was true
	//   - Autocompletion list failed to build
	// So, it shoud disappear!
	if(!_isAutocompleteWorking)
	{
		te->SendSciMessage(SCI_AUTOCCANCEL, 0, 0);
	}

	//
	te->currentft = ft;
}


void ApplyAutocomplete(TriggerEditor* te)
{
	te->SendSciMessage(SCI_AUTOCCOMPLETE, 0, 0);
}
