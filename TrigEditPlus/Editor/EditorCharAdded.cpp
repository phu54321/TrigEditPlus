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

extern "C" {
#include "Lua/lib/lctype.h"  // for lislalnum
}

void UpdateTip(TriggerEditor* te, const char* inputtedtext,
			   int calltip_pos, const char* funcname, int argindex);
void IssueGeneralAutocomplete(TriggerEditor* te);
void SetAutocompleteList(TriggerEditor* te, FieldType ft, const char* inputtedtext);
bool isAutocompletionSet();

void Editor_CharAdded(SCNotification* ne, TriggerEditor* te) {
	// Process keys
	if(ne->ch == '\n') { // Automatic indent
		int pos = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
		int line = te->SendSciMessage(SCI_LINEFROMPOSITION, pos, 0);
		int curlinelen = te->SendSciMessage(SCI_LINELENGTH, line, 0);
		if(line == 0 || curlinelen > 2) return;

		// Get previous line
		int prevlinelen = te->SendSciMessage(SCI_LINELENGTH, line - 1, 0);
		char *s = new char[prevlinelen + 1];
		char *p = s;
		te->SendSciMessage(SCI_GETLINE, line - 1, (LPARAM)s);
		s[prevlinelen] = '\0';

		// Count indentation
		int indentn = 0;
		while(*p == ' ' || *p == '\t') {
			/**/ if(*p == ' ') indentn += 1;
			else if(*p == '\t') indentn += 4;
			p++;
		}

		indentn = (indentn + 3) / 4;


		// Count number of braces.
		int braceopening = 0;
		while(*p) {
			/**/ if(*p == '{') braceopening++;
			else if(*p == '}') braceopening--;
			p++;
		}

		indentn += braceopening;
		if(indentn < 0) indentn = 0;

		// Apply indentation
		char* tabstring = (char*)alloca(indentn + 1);
		memset(tabstring, '\t', indentn);
		tabstring[indentn] = '\0';
		te->SendSciMessage(SCI_REPLACESEL, 0, (LPARAM)tabstring);

		// Clearup
		delete[] s;
	}

	else if(ne->ch == '(') { // Call tip
		int pos = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
		if(pos == 0) return;

		// Get a word before '(' (current position).
		int wstart = te->SendSciMessage(SCI_WORDSTARTPOSITION, pos - 1, 0);
		int wend = te->SendSciMessage(SCI_WORDENDPOSITION, wstart, 1);

		Sci_TextRange tr;
		tr.chrg.cpMin = wstart;
		tr.chrg.cpMax = wend;
		tr.lpstrText = new char[wend - wstart + 1];
		te->SendSciMessage(SCI_GETTEXTRANGE, 0, (LPARAM)&tr);

		// Match the name with documented functions.
		UpdateTip(te, "", wstart, tr.lpstrText, 0);
		delete[] tr.lpstrText;
	}

	else if(ne->ch == ')') { // Call tip end.
		if(te->SendSciMessage(SCI_CALLTIPACTIVE, 0, 0)) {
			int calltip_start = te->SendSciMessage(SCI_CALLTIPPOSSTART, 0, 0);
			int current_pos = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
			int textlen = calltip_start - current_pos;
			const char* strstart = (const char*)
				te->SendSciMessage(SCI_GETRANGEPOINTER, calltip_start, textlen);

			int parenthesisn = 0;
			for(int i = 0 ; i < textlen ; i++) {
				/**/ if(strstart[i] == '(') parenthesisn++;
				else if(strstart[i] == ')') parenthesisn--;
				if(parenthesisn < 0) break; //parenthesis overmatched. Something's got wrong.
			}

			if(parenthesisn == 0) { // ')' is indicator of the end of condition/action function call.
				// Deaths(EPD(a), b, c, d)
				//             |=========+===== This won't cancel the calltip
				//                       |===== This will.
				//
				te->SendSciMessage(SCI_CALLTIPCANCEL, 0, 0);
				UpdateTip(te, NULL, -1, NULL, -1);
			}
		}
	}

	else {
		int current_pos = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
		int find_length = 1024;
		if(find_length > current_pos) find_length = current_pos;

		const char* strstart = (const char*)
			te->SendSciMessage(SCI_GETRANGEPOINTER, current_pos - find_length, find_length);
		const char* p = strstart + find_length - 1;

		int parenthesis_depth = 1;
		int argindex = 0;
		int argstartpos = -1;
		while(p >= strstart) {
			if(p == strstart) break;
			else if(*p == ')') parenthesis_depth++;
			else if(*p == '(') {
				parenthesis_depth--;
				if(parenthesis_depth == 0) break;
			}
			else if(*p == ',') {
				if(argstartpos == -1) {
					argstartpos = (p - strstart) + (current_pos - find_length);
				}
				
				if(parenthesis_depth == 1) {
					argindex++;
				}
			}
			p--;
		}

		if(parenthesis_depth != 0)  // cannot find matching function call start
		{
			IssueGeneralAutocomplete(te);
			return;
		}

		// ok we found starting parenthesis.
		int p_opening_pos = (p - strstart) + (current_pos - find_length);
		if(p_opening_pos == 0)  // Line starts with ( : Not a function call, at least.
		{
			IssueGeneralAutocomplete(te);
			return;
		}
		if(argstartpos == -1) argstartpos = p_opening_pos;
		argstartpos++;

		// Get text of current argument.
		char* thisarg = new char[current_pos - argstartpos + 1];
		int thisarglen = current_pos - argstartpos;
		// argstartpos = (p - strstart) + (current_pos - find_length);
		// p = argstartpos + strstart - (current_pos - find_length)
		strncpy(thisarg, strstart + find_length - current_pos + argstartpos, thisarglen);
		thisarg[thisarglen] = 0;


		// Get a word before '(' (current position).
		int wstart = te->SendSciMessage(SCI_WORDSTARTPOSITION, p_opening_pos - 1, 0);
		int wend = te->SendSciMessage(SCI_WORDENDPOSITION, wstart, 1);

		Sci_TextRange tr;
		tr.chrg.cpMin = wstart;
		tr.chrg.cpMax = wend;
		tr.lpstrText = new char[wend - wstart + 1];
		te->SendSciMessage(SCI_GETTEXTRANGE, 0, (LPARAM)&tr);

		// Match the name with documented functions.
		UpdateTip(te, thisarg, wstart, tr.lpstrText, argindex);
		delete[] thisarg;
		delete[] tr.lpstrText;
	}
}


int GetFuncType(const char* funcname) {
	if(strcmp(funcname, "CountdownTimer") == 0)                    return         0;
	else if(_stricmp(funcname, "Command") == 0)                      return         1;
	else if(_stricmp(funcname, "Bring") == 0)                        return         2;
	else if(_stricmp(funcname, "Accumulate") == 0)                   return         3;
	else if(_stricmp(funcname, "Kills") == 0)                        return         4;
	else if(_stricmp(funcname, "CommandMost") == 0)                  return         5;
	else if(_stricmp(funcname, "CommandMostAt") == 0)                return         6;
	else if(_stricmp(funcname, "MostKills") == 0)                    return         7;
	else if(_stricmp(funcname, "HighestScore") == 0)                 return         8;
	else if(_stricmp(funcname, "MostResources") == 0)                return         9;
	else if(_stricmp(funcname, "Switch") == 0)                       return        10;
	else if(_stricmp(funcname, "ElapsedTime") == 0)                  return        11;
	else if(_stricmp(funcname, "Briefing") == 0)                     return        12;
	else if(_stricmp(funcname, "Opponents") == 0)                    return        13;
	else if(_stricmp(funcname, "Deaths") == 0)                       return        14;
	else if(_stricmp(funcname, "CommandLeast") == 0)                 return        15;
	else if(_stricmp(funcname, "CommandLeastAt") == 0)               return        16;
	else if(_stricmp(funcname, "LeastKills") == 0)                   return        17;
	else if(_stricmp(funcname, "LowestScore") == 0)                  return        18;
	else if(_stricmp(funcname, "LeastResources") == 0)               return        19;
	else if(_stricmp(funcname, "Score") == 0)                        return        20;
	else if(_stricmp(funcname, "Always") == 0)                       return        21;
	else if(_stricmp(funcname, "Never") == 0)                        return        22;

	else if(_stricmp(funcname, "Victory") == 0)                      return 1000 +  0;
	else if(_stricmp(funcname, "Defeat") == 0)                       return 1000 +  1;
	else if(_stricmp(funcname, "PreserveTrigger") == 0)              return 1000 +  2;
	else if(_stricmp(funcname, "Wait") == 0)                         return 1000 +  3;
	else if(_stricmp(funcname, "PauseGame") == 0)                    return 1000 +  4;
	else if(_stricmp(funcname, "UnpauseGame") == 0)                  return 1000 +  5;
	else if(_stricmp(funcname, "Transmission") == 0)                 return 1000 +  6;
	else if(_stricmp(funcname, "PlayWAV") == 0)                      return 1000 +  7;
	else if(_stricmp(funcname, "DisplayText") == 0)                  return 1000 +  8;
	else if(_stricmp(funcname, "CenterView") == 0)                   return 1000 +  9;
	else if(_stricmp(funcname, "CreateUnitWithProperties") == 0)     return 1000 + 10;
	else if(_stricmp(funcname, "SetMissionObjectives") == 0)         return 1000 + 11;
	else if(_stricmp(funcname, "SetSwitch") == 0)                    return 1000 + 12;
	else if(_stricmp(funcname, "SetCountdownTimer") == 0)            return 1000 + 13;
	else if(_stricmp(funcname, "RunAIScript") == 0)                  return 1000 + 14;
	else if(_stricmp(funcname, "RunAIScriptAt") == 0)                return 1000 + 15;
	else if(_stricmp(funcname, "LeaderBoardControl") == 0)           return 1000 + 16;
	else if(_stricmp(funcname, "LeaderBoardControlAt") == 0)         return 1000 + 17;
	else if(_stricmp(funcname, "LeaderBoardResources") == 0)         return 1000 + 18;
	else if(_stricmp(funcname, "LeaderBoardKills") == 0)             return 1000 + 19;
	else if(_stricmp(funcname, "LeaderBoardScore") == 0)             return 1000 + 20;
	else if(_stricmp(funcname, "KillUnit") == 0)                     return 1000 + 21;
	else if(_stricmp(funcname, "KillUnitAt") == 0)                   return 1000 + 22;
	else if(_stricmp(funcname, "RemoveUnit") == 0)                   return 1000 + 23;
	else if(_stricmp(funcname, "RemoveUnitAt") == 0)                 return 1000 + 24;
	else if(_stricmp(funcname, "SetResources") == 0)                 return 1000 + 25;
	else if(_stricmp(funcname, "SetScore") == 0)                     return 1000 + 26;
	else if(_stricmp(funcname, "MinimapPing") == 0)                  return 1000 + 27;
	else if(_stricmp(funcname, "TalkingPortrait") == 0)              return 1000 + 28;
	else if(_stricmp(funcname, "MuteUnitSpeech") == 0)               return 1000 + 29;
	else if(_stricmp(funcname, "UnMuteUnitSpeech") == 0)             return 1000 + 30;
	else if(_stricmp(funcname, "LeaderBoardComputerPlayers") == 0)   return 1000 + 31;
	else if(_stricmp(funcname, "LeaderBoardGoalControl") == 0)       return 1000 + 32;
	else if(_stricmp(funcname, "LeaderBoardGoalControlAt") == 0)     return 1000 + 33;
	else if(_stricmp(funcname, "LeaderBoardGoalResources") == 0)     return 1000 + 34;
	else if(_stricmp(funcname, "LeaderBoardGoalKills") == 0)         return 1000 + 35;
	else if(_stricmp(funcname, "LeaderBoardGoalScore") == 0)         return 1000 + 36;
	else if(_stricmp(funcname, "MoveLocation") == 0)                 return 1000 + 37;
	else if(_stricmp(funcname, "MoveUnit") == 0)                     return 1000 + 38;
	else if(_stricmp(funcname, "LeaderBoardGreed") == 0)             return 1000 + 39;
	else if(_stricmp(funcname, "SetNextScenario") == 0)              return 1000 + 40;
	else if(_stricmp(funcname, "SetDoodadState") == 0)               return 1000 + 41;
	else if(_stricmp(funcname, "SetInvincibility") == 0)             return 1000 + 42;
	else if(_stricmp(funcname, "CreateUnit") == 0)                   return 1000 + 43;
	else if(_stricmp(funcname, "SetDeaths") == 0)                    return 1000 + 44;
	else if(_stricmp(funcname, "Order") == 0)                        return 1000 + 45;
	else if(_stricmp(funcname, "Comment") == 0)                      return 1000 + 46;
	else if(_stricmp(funcname, "GiveUnits") == 0)                    return 1000 + 47;
	else if(_stricmp(funcname, "ModifyUnitHitPoints") == 0)          return 1000 + 48;
	else if(_stricmp(funcname, "ModifyUnitEnergy") == 0)             return 1000 + 49;
	else if(_stricmp(funcname, "ModifyUnitShields") == 0)            return 1000 + 50;
	else if(_stricmp(funcname, "ModifyUnitResourceAmount") == 0)     return 1000 + 51;
	else if(_stricmp(funcname, "ModifyUnitHangarCount") == 0)        return 1000 + 52;
	else if(_stricmp(funcname, "PauseTimer") == 0)                   return 1000 + 53;
	else if(_stricmp(funcname, "UnpauseTimer") == 0)                 return 1000 + 54;
	else if(_stricmp(funcname, "Draw") == 0)                         return 1000 + 55;
	else if(_stricmp(funcname, "SetAllianceStatus") == 0)            return 1000 + 56;
	else return -1;
}


void UpdateTip(TriggerEditor* te, const char* inputtedtext, 
				   int calltip_pos, const char* funcname, int argindex) {
	if(funcname == NULL) {
		te->SendSciMessage(SCI_CALLTIPSETHLT, 0, 0);
		IssueGeneralAutocomplete(te);
		return;
	}

	int functype = GetFuncType(funcname);
	if(functype == -1)  //unknown function.
	{
		IssueGeneralAutocomplete(te);
		return;
	}

	// Make calltip
	const char* cond_calltiplist[] = {
		"CountdownTimer(Comparison, Time);",
		"Command(Player, Comparison, Number, Unit);",
		"Bring(Player, Comparison, Number, Unit, Location);",
		"Accumulate(Player, Comparison, Number, ResourceType);",
		"Kills(Player, Comparison, Number, Unit);",
		"CommandMost(Unit);",
		"CommandMostAt(Unit, Location);",
		"MostKills(Unit);",
		"HighestScore(ScoreType);",
		"MostResources(ResourceType);",
		"Switch(Switch, State);",
		"ElapsedTime(Comparison, Time);",
		"Briefing();",
		"Opponents(Player, Comparison, Number);",
		"Deaths(Player, Comparison, Number, Unit);",
		"CommandLeast(Unit);",
		"CommandLeastAt(Unit, Location);",
		"LeastKills(Unit);",
		"LowestScore(ScoreType);",
		"LeastResources(ResourceType);",
		"Score(Player, ScoreType, Comparison, Number);",
		"Always();",
		"Never();",
	};

	const char* act_calltiplist[] = {
		"Victory();",
		"Defeat();",
		"PreserveTrigger();",
		"Wait(Time);",
		"PauseGame();",
		"UnpauseGame();",
		"Transmission(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay);",
		"PlayWAV(WAVName);",
		"DisplayText(Text, AlwaysDisplay);",
		"CenterView(Where);",
		"CreateUnitWithProperties(Count, Unit, Where, Player, Properties);",
		"SetMissionObjectives(Text);",
		"SetSwitch(Switch, State);",
		"SetCountdownTimer(TimeModifier, Time);",
		"RunAIScript(Script);",
		"RunAIScriptAt(Script, Where);",
		"LeaderBoardControl(Unit, Label);",
		"LeaderBoardControlAt(Unit, Location, Label);",
		"LeaderBoardResources(ResourceType, Label);",
		"LeaderBoardKills(Unit, Label);",
		"LeaderBoardScore(ScoreType, Label);",
		"KillUnit(Unit, Player);",
		"KillUnitAt(Count, Unit, Where, ForPlayer);",
		"RemoveUnit(Unit, Player);",
		"RemoveUnitAt(Count, Unit, Where, ForPlayer);",
		"SetResources(Player, Modifier, Amount, ResourceType);",
		"SetScore(Player, Modifier, Amount, ScoreType);",
		"MinimapPing(Where);",
		"TalkingPortrait(Unit, Time);",
		"MuteUnitSpeech();",
		"UnMuteUnitSpeech();",
		"LeaderBoardComputerPlayers(State);",
		"LeaderBoardGoalControl(Goal, Unit, Label);",
		"LeaderBoardGoalControlAt(Goal, Unit, Location, Label);",
		"LeaderBoardGoalResources(Goal, ResourceType, Label);",
		"LeaderBoardGoalKills(Goal, Unit, Label);",
		"LeaderBoardGoalScore(Goal, ScoreType, Label);",
		"MoveLocation(Location, OnUnit, Owner, DestLocation);",
		"MoveUnit(Count, UnitType, Owner, StartLocation, DestLocation);",
		"LeaderBoardGreed(Goal);",
		"SetNextScenario(ScenarioName);",
		"SetDoodadState(State, Unit, Owner, Where);",
		"SetInvincibility(State, Unit, Owner, Where);",
		"CreateUnit(Number, Unit, Where, ForPlayer);",
		"SetDeaths(Player, Modifier, Number, Unit);",
		"Order(Unit, Owner, StartLocation, OrderType, DestLocation);",
		"Comment(Text);",
		"GiveUnits(Count, Unit, Owner, Where, NewOwner);",
		"ModifyUnitHitPoints(Count, Unit, Owner, Where, Percent);",
		"ModifyUnitEnergy(Count, Unit, Owner, Where, Percent);",
		"ModifyUnitShields(Count, Unit, Owner, Where, Percent);",
		"ModifyUnitResourceAmount(Count, Owner, Where, NewValue);",
		"ModifyUnitHangarCount(Add, Count, Unit, Owner, Where);",
		"PauseTimer();",
		"UnpauseTimer();",
		"Draw();",
		"SetAllianceStatus(Player, Status);"
	};

	FieldType ft;
	const char* calltip;

	if(functype < 1000) { //condition
		calltip = cond_calltiplist[functype];

		if(argindex < 0 || argindex >= MAX_FIELD_NUM) ft = FIELDTYPE_NONE;
		else ft = ConditionFields[functype].fields[argindex].Type;
	}

	else {
		functype -= 1000;
		calltip = act_calltiplist[functype];

		if(argindex < 0 || argindex >= MAX_FIELD_NUM) ft = FIELDTYPE_NONE;
		else ft = ActionFields[functype].fields[argindex].Type;
	}

	// Show calltip
	if(!te->SendSciMessage(SCI_CALLTIPACTIVE, 0, 0)) {
		te->SendSciMessage(SCI_CALLTIPCANCEL, 0, 0);
		te->SendSciMessage(SCI_CALLTIPSHOW, calltip_pos, (LPARAM)calltip);
	}

	// Highlight arguments & Autocomplete
	if(ft != FIELDTYPE_NONE) { // argindex is valid argument index.
		int argindex2 = argindex;
		const char *hlstart, *hlend;
		const char *p = calltip;

		while(*p) {
			if(*p == '(' && argindex2 == 0) break;
			if(*p == ',') {
				argindex2--;
				if(argindex2 == 0) break;
			}
			p++;
		}
		hlstart = p + 1;
		p++;

		while(*p) {
			if(*p == ')' || *p == ',') break;
			p++;
		}

		hlend = p;

		te->SendSciMessage(SCI_CALLTIPSETHLT, hlstart - calltip, hlend - calltip);

		// Set autocomplete list
		SetAutocompleteList(te, ft, inputtedtext);
	}

	else {
		te->SendSciMessage(SCI_CALLTIPSETHLT, 0, 0);
		IssueGeneralAutocomplete(te);
	}
}


// ------

void IssueGeneralAutocomplete(TriggerEditor* te)
{
	// Get 128 chars before/after cursor.
	int current_pos = te->SendSciMessage(SCI_GETCURRENTPOS, 0, 0);
	int text_length = te->SendSciMessage(SCI_GETTEXTLENGTH, 0, 0);
	int fw_find_length = 128;
	if(fw_find_length > current_pos) fw_find_length = current_pos;

	const char* strstart = (const char*)
		te->SendSciMessage(SCI_GETRANGEPOINTER, current_pos - fw_find_length, fw_find_length);
	const char* p = strstart + fw_find_length;

	const char *pstart = p - 1, *pend = p;
	while(pstart > strstart && lislalnum(*pstart)) pstart--;
	pstart++;

	const std::string str(pstart, pend);
	SetAutocompleteList(te, FIELDTYPE_NONE, str.c_str());
}
