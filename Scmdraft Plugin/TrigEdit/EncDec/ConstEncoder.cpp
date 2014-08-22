#include "../TriggerEditor.h"
#include "../StringUtils/StringCast.h"

int TriggerEditor::EncodeNumber(const std::string& str) const {
	return String2Int(str);
}

int TriggerEditor::EncodeAllyStatus(const std::string& str) const {
	if(str == "Enemy") return 0;
	if(str == "Ally") return 1;
	if(str == "AlliedVictory") return 2;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeComparison(const std::string& str) const {
	if(str == "AtLeast") return 0;
	if(str == "AtMost") return 1;
	if(str == "Exactly") return 10;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeModifier(const std::string& str) const {
	if(str == "SetTo") return 7;
	if(str == "Add") return 8;
	if(str == "Subtract") return 9;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeOrder(const std::string& str) const {
	if(str == "Move") return 0;
	if(str == "Patrol") return 1;
	if(str == "Attack") return 2;
	return EncodeNumber(str);
}

int TriggerEditor::EncodePlayer(const std::string& str) const {
	if(str == "P1") return 0;
	if(str == "P2") return 1;
	if(str == "P3") return 2;
	if(str == "P4") return 3;
	if(str == "P5") return 4;
	if(str == "P6") return 5;
	if(str == "P7") return 6;
	if(str == "P8") return 7;
	if(str == "P9") return 8;
	if(str == "P10") return 9;
	if(str == "P11") return 10;
	if(str == "P12") return 11;
	if(str == "CurrentPlayer") return 13;
	if(str == "Foes") return 14;
	if(str == "Allies") return 15;
	if(str == "NeutralPlayers") return 16;
	if(str == "AllPlayers") return 17;
	if(str == "Force1") return 18;
	if(str == "Force2") return 19;
	if(str == "Force3") return 20;
	if(str == "Force4") return 21;
	if(str == "NonAlliedVictoryPlayers") return 26;
	return EncodeNumber(str);
}

int TriggerEditor::EncodePropState(const std::string& str) const {
	if(str == "Enable") return 4;
	if(str == "Disable") return 5;
	if(str == "Toggle") return 6;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeResource(const std::string& str) const {
	if(str == "Ore") return 0;
	if(str == "Gas") return 1;
	if(str == "OreAndGas") return 2;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeScore(const std::string& str) const {
	if(str == "Total") return 0;
	if(str == "Units") return 1;
	if(str == "Buildings") return 2;
	if(str == "UnitsAndBuildings") return 3;
	if(str == "Kills") return 4;
	if(str == "Razings") return 5;
	if(str == "KillsAndRazings") return 6;
	if(str == "Custom") return 7;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeSwitchAction(const std::string& str) const {
	if(str == "Set") return 4;
	if(str == "Clear") return 5;
	if(str == "Toggle") return 6;
	if(str == "Random") return 11;
	return EncodeNumber(str);
}

int TriggerEditor::EncodeSwitchState(const std::string& str) const {
	if(str == "Set") return 2;
	if(str == "Cleared") return 3;
	return EncodeNumber(str);
}
