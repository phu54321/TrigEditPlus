#pragma once

#include <vector>
#include <string>
#include <exception>
#include <functional>
#include <memory>

#include <Windows.h>
#include <stdint.h>

#include "../PluginBase/SCMDPlugin.h"

#include "StringUtils/stringbuffer.h"
#include "EncodeError.h"

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

class MapNamespace;

// Trigger editor def
class TriggerEditor {
public:
	TriggerEditor();
	~TriggerEditor();

	int RunEditor(HWND hMain, TriggerEditor_Arg& data);

private:
	TriggerEditor_Arg* _editordata;
	MapNamespace* _namespace;

private:
	// Encode part : Text -> Binary Data
	int EncodeTrigger(const std::string& string);

	int BeginEncode();
	std::vector<Trig> EndEncode();
	void RevertDecode();
	
	CChunkData* _oldTrig;
	std::vector<Trig> _trigbuffer;
	int _currenttrigger, _current_condition, _current_action;

	int EncodeTrigger();
	int EncodeAction(int index, const std::string& str);
	int EncodeCondition(int index, const std::string& str);

	int EncodeNumber(const std::string& str) const;
	int EncodeAllyStatus(const std::string& str) const;
	int EncodeComparison(const std::string& str) const;
	int EncodeModifier(const std::string& str) const;
	int EncodeOrder(const std::string& str) const;
	int EncodePlayer(const std::string& str) const;
	int EncodePropState(const std::string& str) const;
	int EncodeResource(const std::string& str) const;
	int EncodeScore(const std::string& str) const;
	int EncodeSwitchAction(const std::string& str) const;
	int EncodeSwitchState(const std::string& str) const;
	int EncodeAIScript(const std::string& str) const;
	int EncodeCount(const std::string& str) const;
	int EncodeUnit(const std::string& str) const;
	int EncodeLocation(const std::string& str) const;
	int EncodeString(const std::string& str) const;
	int EncodeSwitchName(const std::string& str) const;


private:
	// Decode part : Binary Data -> Text
	int BeginDecode();
	std::string EndDecode();
	
	StringBuffer _decode_out;

	void DecodeTrigger(const Trig& content);
	void DecodeCondition(const TrigCond& content);
	void DecodeAction(const TrigAct& content);

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


private:
	// Window part
	HWND hTrigDlg;
	HWND hScintilla;

private:
	// Private members.
};



