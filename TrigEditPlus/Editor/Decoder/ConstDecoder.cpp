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
#include "../StringUtils/StringCast.h"

std::string TriggerEditor::DecodeNumber(int value) const {
	return Int2String(value);
}


std::string TriggerEditor::DecodeAllyStatus(int value) const {
	switch(value) {
	case 0: return "Enemy";
	case 1: return "Ally";
	case 2: return "AlliedVictory";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeComparison(int value) const {
	switch(value) {
	case 0: return "AtLeast";
	case 1: return "AtMost";
	case 10: return "Exactly";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeModifier(int value) const {
	switch(value) {
	case 7: return "SetTo";
	case 8: return "Add";
	case 9: return "Subtract";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeOrder(int value) const {
	switch(value) {
	case 0: return "Move";
	case 1: return "Patrol";
	case 2: return "Attack";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodePlayer(int value) const {
	switch(value) {
	case 0: return "P1";
	case 1: return "P2";
	case 2: return "P3";
	case 3: return "P4";
	case 4: return "P5";
	case 5: return "P6";
	case 6: return "P7";
	case 7: return "P8";
	case 8: return "P9";
	case 9: return "P10";
	case 10: return "P11";
	case 11: return "P12";
	case 13: return "CurrentPlayer";
	case 14: return "Foes";
	case 15: return "Allies";
	case 16: return "NeutralPlayers";
	case 17: return "AllPlayers";
	case 18: return "Force1";
	case 19: return "Force2";
	case 20: return "Force3";
	case 21: return "Force4";
	case 26: return "NonAlliedVictoryPlayers";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodePropState(int value) const {
	switch(value) {
	case 4: return "Enable";
	case 5: return "Disable";
	case 6: return "Toggle";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeResource(int value) const {
	switch(value) {
	case 0: return "Ore";
	case 1: return "Gas";
	case 2: return "OreAndGas";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeScore(int value) const {
	switch(value) {
	case 0: return "Total";
	case 1: return "Units";
	case 2: return "Buildings";
	case 3: return "UnitsAndBuildings";
	case 4: return "Kills";
	case 5: return "Razings";
	case 6: return "KillsAndRazings";
	case 7: return "Custom";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeSwitchAction(int value) const {
	switch(value) {
	case 4: return "Set";
	case 5: return "Clear";
	case 6: return "Toggle";
	case 11: return "Random";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeSwitchState(int value) const {
	switch(value) {
	case 2: return "Set";
	case 3: return "Cleared";
	default: return DecodeNumber(value);
	}
}

std::string TriggerEditor::DecodeCount(int value) const {
	switch(value) {
	case 0: return "All";
	default: return DecodeNumber(value);
	}
}
