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

#include "TriggerEncDec.h"


TriggerStatementDecl ConditionFields[23] = {
	{ 1, "CountdownTimer", {
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER }
	}
	},

	{ 2, "Command", {
		{ 2, FIELDTYPE_PLAYER },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
		{ 4, FIELDTYPE_UNIT },
	}
	},

	{ 3, "Bring", {
		{ 2, FIELDTYPE_PLAYER },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
		{ 4, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION }
	}
	},

	{ 4, "Accumulate", {
		{ 2, FIELDTYPE_PLAYER },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_RESOURCE }
	}
	},

	{ 5, "Kills", {
		{ 2, FIELDTYPE_PLAYER },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
		{ 4, FIELDTYPE_UNIT }
	}
	},

	{ 6, "CommandMost", {
		{ 4, FIELDTYPE_UNIT }
	}
	},

	{ 7, "CommandMostAt", {
		{ 4, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION }
	}
	},

	{ 8, "MostKills", {
		{ 4, FIELDTYPE_UNIT },
	}
	},

	{ 9, "HighestScore", {
		{ 7, FIELDTYPE_SCORE },
	}
	},

	{ 10, "MostResources", {
		{ 7, FIELDTYPE_RESOURCE }
	}
	},

	{ 11, "Switch", {
		{ 7, FIELDTYPE_SWITCHNAME },
		{ 5, FIELDTYPE_SWITCHSTATE }
	}
	},

	{ 12, "ElapsedTime", {
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
	}
	},

	{ 13, "Briefing", {
	}
	},

	{ 14, "Opponents", {
		{ 2, FIELDTYPE_PLAYER },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
	}
	},

	{ 15, "Deaths", {
		{ 2, FIELDTYPE_PLAYER },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER },
		{ 4, FIELDTYPE_UNIT },
	}
	},

	{ 16, "CommandLeast", {
		{ 4, FIELDTYPE_UNIT },
	}
	},

	{ 17, "CommandLeastAt", {
		{ 4, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION }
	}
	},

	{ 18, "LeastKills", {
		{ 4, FIELDTYPE_UNIT },
	}
	},

	{ 19, "LowestScore", {
		{ 7, FIELDTYPE_SCORE },
	}
	},

	{ 20, "LeastResources", {
		{ 7, FIELDTYPE_RESOURCE }
	}
	},

	{ 21, "Score", {
		{ 2, FIELDTYPE_PLAYER },
		{ 7, FIELDTYPE_SCORE },
		{ 5, FIELDTYPE_COMPARISON },
		{ 3, FIELDTYPE_NUMBER }
	}
	},

	{ 22, "Always", {
	}
	},

	{ 23, "Never", {
	}
	},
};



TriggerStatementDecl ActionFields[57] = {
	{ 1, "Victory", {
	}
	},


	{ 2, "Defeat", {
	}
	},


	{ 3, "PreserveTrigger", {
	}
	},


	{ 4, "Wait", {
		{ 4, FIELDTYPE_NUMBER },
	}
	},


	{ 5, "PauseGame", {
	}
	},


	{ 6, "UnpauseGame", {
	}
	},


	{ 7, "Transmission", {
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 3, FIELDTYPE_STRING },
		{ 9, FIELDTYPE_MODIFIER },
		{ 6, FIELDTYPE_NUMBER },
		{ 2, FIELDTYPE_STRING },
		{ 10, FIELDTYPE_NUMBER },
	}
	},


	{ 8, "PlayWAV", {
		{ 3, FIELDTYPE_STRING },
	}
	},


	{ 9, "DisplayText", {
		{ 2, FIELDTYPE_STRING },
		{ 10, FIELDTYPE_NUMBER },
	}
	},


	{ 10, "CenterView", {
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 11, "CreateUnitWithProperties", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 5, FIELDTYPE_PLAYER },
		{ 6, FIELDTYPE_UNITPROPERTY },
	}
	},


	{ 12, "SetMissionObjectives", {
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 13, "SetSwitch", {
		{ 6, FIELDTYPE_SWITCHNAME },
		{ 9, FIELDTYPE_SWITCHACTION },
	}
	},


	{ 14, "SetCountdownTimer", {
		{ 9, FIELDTYPE_MODIFIER },
		{ 4, FIELDTYPE_NUMBER },
	}
	},


	{ 15, "RunAIScript", {
		{ 6, FIELDTYPE_AISCRIPT },
	}
	},


	{ 16, "RunAIScriptAt", {
		{ 6, FIELDTYPE_AISCRIPT },
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 17, "LeaderBoardControl", {
		{ 7, FIELDTYPE_UNIT },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 18, "LeaderBoardControlAt", {
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 19, "LeaderBoardResources", {
		{ 7, FIELDTYPE_RESOURCE },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 20, "LeaderBoardKills", {
		{ 7, FIELDTYPE_UNIT },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 21, "LeaderBoardScore", {
		{ 7, FIELDTYPE_SCORE },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 22, "KillUnit", {
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
	}
	},


	{ 23, "KillUnitAt", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 5, FIELDTYPE_PLAYER },
	}
	},


	{ 24, "RemoveUnit", {
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
	}
	},


	{ 25, "RemoveUnitAt", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 5, FIELDTYPE_PLAYER },
	}
	},


	{ 26, "SetResources", {
		{ 5, FIELDTYPE_PLAYER },
		{ 9, FIELDTYPE_MODIFIER },
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_RESOURCE },
	}
	},


	{ 27, "SetScore", {
		{ 5, FIELDTYPE_PLAYER },
		{ 9, FIELDTYPE_MODIFIER },
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_SCORE },
	}
	},


	{ 28, "MinimapPing", {
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 29, "TalkingPortrait", {
		{ 7, FIELDTYPE_UNIT },
		{ 4, FIELDTYPE_NUMBER },
	}
	},


	{ 30, "MuteUnitSpeech", {
	}
	},


	{ 31, "UnMuteUnitSpeech", {
	}
	},


	{ 32, "LeaderBoardComputerPlayers", {
		{ 9, FIELDTYPE_PROPSTATE },
	}
	},


	{ 33, "LeaderBoardGoalControl", {
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_UNIT },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 34, "LeaderBoardGoalControlAt", {
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 35, "LeaderBoardGoalResources", {
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_RESOURCE },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 36, "LeaderBoardGoalKills", {
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_UNIT },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 37, "LeaderBoardGoalScore", {
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_SCORE },
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 38, "MoveLocation", {
		{ 6, FIELDTYPE_LOCATION },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 39, "MoveUnit", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 6, FIELDTYPE_LOCATION },
	}
	},


	{ 40, "LeaderBoardGreed", {
		{ 6, FIELDTYPE_NUMBER },
	}
	},


	{ 41, "SetNextScenario", {
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 42, "SetDoodadState", {
		{ 9, FIELDTYPE_PROPSTATE },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 43, "SetInvincibility", {
		{ 9, FIELDTYPE_PROPSTATE },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 44, "CreateUnit", {
		{ 9, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_UNIT },
		{ 1, FIELDTYPE_LOCATION },
		{ 5, FIELDTYPE_PLAYER },
	}
	},


	{ 45, "SetDeaths", {
		{ 5, FIELDTYPE_PLAYER },
		{ 9, FIELDTYPE_MODIFIER },
		{ 6, FIELDTYPE_NUMBER },
		{ 7, FIELDTYPE_UNIT },
	}
	},


	{ 46, "Order", {
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 9, FIELDTYPE_ORDER },
		{ 6, FIELDTYPE_LOCATION },
	}
	},


	{ 47, "Comment", {
		{ 2, FIELDTYPE_STRING },
	}
	},


	{ 48, "GiveUnits", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 6, FIELDTYPE_PLAYER },
	}
	},


	{ 49, "ModifyUnitHitPoints", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 6, FIELDTYPE_NUMBER },
	}
	},


	{ 50, "ModifyUnitEnergy", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 6, FIELDTYPE_NUMBER },
	}
	},


	{ 51, "ModifyUnitShields", {
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 6, FIELDTYPE_NUMBER },
	}
	},


	{ 52, "ModifyUnitResourceAmount", {
		{ 9, FIELDTYPE_COUNT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
		{ 6, FIELDTYPE_NUMBER },
	}
	},


	{ 53, "ModifyUnitHangarCount", {
		{ 6, FIELDTYPE_NUMBER },
		{ 9, FIELDTYPE_COUNT },
		{ 7, FIELDTYPE_UNIT },
		{ 5, FIELDTYPE_PLAYER },
		{ 1, FIELDTYPE_LOCATION },
	}
	},


	{ 54, "PauseTimer", {
	}
	},


	{ 55, "UnpauseTimer", {
	}
	},


	{ 56, "Draw", {
	}
	},


	{ 57, "SetAllianceStatus", {
		{ 5, FIELDTYPE_PLAYER },
		{ 7, FIELDTYPE_ALLYSTATUS },
	}
	},
};
