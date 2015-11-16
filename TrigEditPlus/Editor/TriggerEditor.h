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

#pragma once

#include <vector>
#include <string>
#include <exception>
#include <functional>
#include <memory>
#include <Windows.h>
#include <stdint.h>

#include "Scintilla/Scintilla.h"

#include "../PluginBase/SCMDPlugin.h"
#include "StringUtils/stringbuffer.h"
#include "TriggerEncDec.h"

#include "Lua/lib/lua.hpp"

//Trigger structure
#include <packon.h>
typedef struct {
	uint32_t locid;
	uint32_t player;
	uint32_t res;
	uint16_t uid;
	uint8_t setting;
	uint8_t condtype;
	uint8_t res_setting;
	uint8_t prop;
	uint16_t dummy;
}TrigCond;


typedef struct {
	uint32_t locid;
	uint32_t strid;
	uint32_t wavid;
	uint32_t time;
	uint32_t player;
	uint32_t target;
	uint16_t setting;
	uint8_t acttype;
	uint8_t num;
	uint8_t prop;
	uint8_t dummy[3];
}TrigAct;


typedef struct {
	TrigCond cond[16];
	TrigAct act[64];
	uint32_t flag;
	uint8_t effplayer[27];
	uint8_t current_action;
}Trig;

static_assert(sizeof(Trig) == 2400, "Size mismatch.");

#include <packoff.h>





// Argument supplied fro trigger editor
struct TriggerEditor_Arg {
	TEngineData* EngineData;
	CChunkData* Triggers;
	CChunkData* SwitchRenaming;
	CChunkData* UnitProperties;
	CChunkData* UnitPropUsage;
};


struct TrigBufferEntry
{
	Trig trigData;
	int callerLine;
};

class MapNamespace;
LRESULT CALLBACK TrigEditDlgProc(HWND, UINT, WPARAM, LPARAM);


// SendSciMessage target
enum
{
	SCI_TARGET_MAIN = 1,
	SCI_TARGET_MINI = 2,
	SCI_TARGET_BOTH = 3,
};

// Trigger editor def
class TriggerEditor {
	friend LRESULT CALLBACK TrigEditDlgProc(HWND, UINT, WPARAM, LPARAM);

public:
	TriggerEditor();
	~TriggerEditor();

	int RunEditor(HWND hMain, TriggerEditor_Arg& data);

	TriggerEditor_Arg* _editordata;
	MapNamespace* _namespace;

	// Decode part : Binary Data -> Text
	std::string DecodeTriggers(CChunkData* input) const;

	void DecodeTrigger(lua_State* L, StringBuffer& buf, const Trig& content) const;
	void DecodeCondition(lua_State* L, StringBuffer& buf, const TrigCond& content) const;
	void DecodeAction(lua_State* L, StringBuffer& buf, const TrigAct& content) const;

	std::string DecodeNumber(int value) const;
	std::string DecodeAllyStatus(int value) const;
	std::string DecodeComparison(int value) const;
	std::string DecodeModifier(int value) const;
	std::string DecodeOrder(int value) const;
	std::string DecodePlayer(int value) const;
	std::string DecodePropState(int value) const;
	std::string DecodeResource(int value) const;
	std::string DecodeScore(int value) const;
	std::string DecodeSwitchAction(int value) const;
	std::string DecodeSwitchState(int value) const;
	std::string DecodeAIScript(int value) const;
	std::string DecodeCount(int value) const;
	std::string DecodeUnit(int value) const;
	std::string DecodeLocation(int value) const;
	std::string DecodeString(int value) const;
	std::string DecodeSwitchName(int value) const;

	// Encode part : Text -> Binary Data
	bool EncodeTriggerCode();
	std::vector<TrigBufferEntry> _trigbuffer;

	// Aux functions
	void UpdateTriggerList(const std::vector<TrigBufferEntry>& trigbuffer);
	void DerefStrings();

	// These functions are used by lua
	int EncodeUnit(const std::string& str) const;
	int EncodeLocation(const std::string& str) const;
	int EncodeString(const std::string& str) const;
	int EncodeSwitchName(const std::string& str) const;
	
	void ClearErrors();
	void PrintErrorMessage(const std::string& str);
	int SendSciMessage(int msg, WPARAM, LPARAM, int target = SCI_TARGET_BOTH);

	std::string GetEditorText() const;
	void SetEditorText(const std::string& str);

	// Lua part
	lua_State* _nsLua;

	// Window part
	HWND hTrigDlg;
	HWND hTriggerList;
	HWND hScintilla;
	HWND hMinimap;
	HWND hFindDlg;
	FINDREPLACE fr;
	FieldType currentft;
	bool _textedited;

	SciFnDirect _pSciMsg;
	sptr_t _pSciWndData;

	SciFnDirect _pMinimapMsg;
	sptr_t _pMinimapWndData;

	StringBuffer _errlist;

private:
	// Private members.
};



