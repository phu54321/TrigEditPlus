-- Constants used inside triggers & actions
-- Different tables are guranteed to be unique, so we use tables as constant definer

local AllyStatusDict = {
    [0] = "Enemy",
    [1] = "Ally",
    [2] = "AlliedVictory",
}

local ComparisonDict = {
    [0] = "AtLeast",
    [1] = "AtMost",
    [10] = "Exactly",
}

local ModifierDict = {
    [7] = "SetTo",
    [8] = "Add",
    [9] = "Subtract",
}

local OrderDict = {
    [0] = "Move",
    [1] = "Patrol",
    [2] = "Attack",
}

local PlayerDict = {
    [0] = "P1",
    [1] = "P2",
    [2] = "P3",
    [3] = "P4",
    [4] = "P5",
    [5] = "P6",
    [6] = "P7",
    [7] = "P8",
    [8] = "P9",
    [9] = "P10",
    [10] = "P11",
    [11] = "P12",
    [13] = "CurrentPlayer",
    [14] = "Foes",
    [15] = "Allies",
    [16] = "NeutralPlayers",
    [17] = "AllPlayers",
    [18] = "Force1",
    [19] = "Force2",
    [20] = "Force3",
    [21] = "Force4",
    [26] = "NonAlliedVictoryPlayers",
}

local PropStateDict = {
    [4] = "Enable",
    [5] = "Disable",
    [6] = "Toggle",
}

local ResourceDict = {
    [0] = "Ore",
    [1] = "Gas",
    [2] = "OreAndGas",
}

local ScoreDict = {
    [0] = "Total",
    [1] = "Units",
    [2] = "Buildings",
    [3] = "UnitsAndBuildings",
    [4] = "Kills",
    [5] = "Razings",
    [6] = "KillsAndRazings",
    [7] = "Custom",
}

local SwitchActionDict = {
    [4] = "Set",
    [5] = "Clear",
    [6] = "Toggle",
    [11] = "Random",
}

local SwitchStateDict = {
    [2] = "Set",
    [3] = "Cleared",
}


local AIScriptDict = {
    [1967344980] = "Terran Custom Level",
    [1967344986] = "Zerg Custom Level",
    [1967344976] = "Protoss Custom Level",
    [2017676628] = "Terran Expansion Custom Level",
    [2017676634] = "Zerg Expansion Custom Level",
    [2017676624] = "Protoss Expansion Custom Level",
    [1716472916] = "Terran Campaign Easy",
    [1145392468] = "Terran Campaign Medium",
    [1716078676] = "Terran Campaign Difficult",
    [1347769172] = "Terran Campaign Insane",
    [1163018580] = "Terran Campaign Area Town",
    [1716472922] = "Zerg Campaign Easy",
    [1145392474] = "Zerg Campaign Medium",
    [1716078682] = "Zerg Campaign Difficult",
    [1347769178] = "Zerg Campaign Insane",
    [1163018586] = "Zerg Campaign Area Town",
    [1716472912] = "Protoss Campaign Easy",
    [1145392464] = "Protoss Campaign Medium",
    [1716078672] = "Protoss Campaign Difficult",
    [1347769168] = "Protoss Campaign Insane",
    [1163018576] = "Protoss Campaign Area Town",
    [2018462804] = "Expansion Terran Campaign Easy",
    [2017807700] = "Expansion Terran Campaign Medium",
    [2018068564] = "Expansion Terran Campaign Difficult",
    [2018857812] = "Expansion Terran Campaign Insane",
    [2018656596] = "Expansion Terran Campaign Area Town",
    [2018462810] = "Expansion Zerg Campaign Easy",
    [2017807706] = "Expansion Zerg Campaign Medium",
    [2018068570] = "Expansion Zerg Campaign Difficult",
    [2018857818] = "Expansion Zerg Campaign Insane",
    [2018656602] = "Expansion Zerg Campaign Area Town",
    [2018462800] = "Expansion Protoss Campaign Easy",
    [2017807696] = "Expansion Protoss Campaign Medium",
    [2018068560] = "Expansion Protoss Campaign Difficult",
    [2018857808] = "Expansion Protoss Campaign Insane",
    [2018656592] = "Expansion Protoss Campaign Area Town",
    [1667855699] = "Send All Units on Strategic Suicide Missions",
    [1382643027] = "Send All Units on Random Suicide Missions",
    [1969451858] = "Switch Computer Player to Rescue Passive",
    [812209707] = "Turn ON Shared Vision for Player 1",
    [828986923] = "Turn ON Shared Vision for Player 2",
    [845764139] = "Turn ON Shared Vision for Player 3",
    [862541355] = "Turn ON Shared Vision for Player 4",
    [879318571] = "Turn ON Shared Vision for Player 5",
    [896095787] = "Turn ON Shared Vision for Player 6",
    [912873003] = "Turn ON Shared Vision for Player 7",
    [929650219] = "Turn ON Shared Vision for Player 8",
    [812209709] = "Turn OFF Shared Vision for Player 1",
    [828986925] = "Turn OFF Shared Vision for Player 2",
    [845764141] = "Turn OFF Shared Vision for Player 3",
    [862541357] = "Turn OFF Shared Vision for Player 4",
    [879318573] = "Turn OFF Shared Vision for Player 5",
    [896095789] = "Turn OFF Shared Vision for Player 6",
    [912873005] = "Turn OFF Shared Vision for Player 7",
    [929650221] = "Turn OFF Shared Vision for Player 8",
    [1700034125] = "Move Dark Templars to Region",
    [1131572291] = "Clear Previous Combat Data",
    [2037214789] = "Set Player to Enemy",
    [2037148737] = "Set Player to Ally  ",
    [1098214486] = "Value This Area Higher",
    [1799515717] = "Enter Closest Bunker",
    [1733588051] = "Set Generic Command Target",
    [1951429715] = "Make These Units Patrol",
    [1918135877] = "Enter Transport",
    [1918138437] = "Exit Transport",
    [1699247438] = "AI Nuke Here",
    [1699242312] = "AI Harass Here",
    [1732532554] = "Set Unit Order To: Junk Yard Dog",
    [1699239748] = "Disruption Web Here",
    [1699243346] = "Recall Here",
    [863135060] = "Terran 3 - Zerg Town",
    [896689492] = "Terran 5 - Terran Main Town",
    [1211458900] = "Terran 5 - Terran Harvest Town",
    [913466708] = "Terran 6 - Air Attack Zerg",
    [1647732052] = "Terran 6 - Ground Attack Zerg",
    [1664509268] = "Terran 6 - Zerg Support Town",
    [930243924] = "Terran 7 - Bottom Zerg Town",
    [1933010260] = "Terran 7 - Right Zerg Town",
    [1832346964] = "Terran 7 - Middle Zerg Town",
    [947021140] = "Terran 8 - Confederate Town",
    [1278833236] = "Terran 9 - Light Attack",
    [1211724372] = "Terran 9 - Heavy Attack",
    [808543572] = "Terran 10 - Confederate Towns",
    [2050044244] = "Terran 11 - Zerg Town",
    [1630613844] = "Terran 11 - Lower Protoss Town",
    [1647391060] = "Terran 11 - Upper Protoss Town",
    [1311912276] = "Terran 12 - Nuke Town",
    [1345466708] = "Terran 12 - Phoenix Town",
    [1412575572] = "Terran 12 - Tank Town",
    [826557780] = "Terran 1 - Electronic Distribution",
    [843334996] = "Terran 2 - Electronic Distribution",
    [860112212] = "Terran 3 - Electronic Distribution",
    [827806548] = "Terran 1 - Shareware",
    [844583764] = "Terran 2 - Shareware",
    [861360980] = "Terran 3 - Shareware",
    [878138196] = "Terran 4 - Shareware",
    [894915412] = "Terran 5 - Shareware",
    [829580634] = "Zerg 1 - Terran Town",
    [846357850] = "Zerg 2 - Protoss Town",
    [863135066] = "Zerg 3 - Terran Town",
    [879912282] = "Zerg 4 - Right Terran Town",
    [1395942746] = "Zerg 4 - Lower Terran Town",
    [913466714] = "Zerg 6 - Protoss Town",
    [1631023706] = "Zerg 7 - Air Town",
    [1731687002] = "Zerg 7 - Ground Town",
    [1933013594] = "Zerg 7 - Support Town",
    [947021146] = "Zerg 8 - Scout Town",
    [1412982106] = "Zerg 8 - Templar Town",
    [963798362] = "Zerg 9 - Teal Protoss",
    [2037135706] = "Zerg 9 - Left Yellow Protoss",
    [2037528922] = "Zerg 9 - Right Yellow Protoss",
    [1869363546] = "Zerg 9 - Left Orange Protoss",
    [1869756762] = "Zerg 9 - Right Orange Protoss",
    [1630548314] = "Zerg 10 - Left Teal (Attack",
    [1647325530] = "Zerg 10 - Right Teal (Support",
    [1664102746] = "Zerg 10 - Left Yellow (Support",
    [1680879962] = "Zerg 10 - Right Yellow (Attack",
    [1697657178] = "Zerg 10 - Red Protoss",
    [829387344] = "Protoss 1 - Zerg Town",
    [846164560] = "Protoss 2 - Zerg Town",
    [1379103312] = "Protoss 3 - Air Zerg Town",
    [1194553936] = "Protoss 3 - Ground Zerg Town",
    [879718992] = "Protoss 4 - Zerg Town",
    [1228239440] = "Protoss 5 - Zerg Town Island",
    [1110798928] = "Protoss 5 - Zerg Town Base",
    [930050640] = "Protoss 7 - Left Protoss Town",
    [1110930000] = "Protoss 7 - Right Protoss Town",
    [1396142672] = "Protoss 7 - Shrine Protoss",
    [946827856] = "Protoss 8 - Left Protoss Town",
    [1110995536] = "Protoss 8 - Right Protoss Town",
    [1144549968] = "Protoss 8 - Protoss Defenders",
    [963605072] = "Protoss 9 - Ground Zerg",
    [1463382608] = "Protoss 9 - Air Zerg",
    [1496937040] = "Protoss 9 - Spell Zerg",
    [808546896] = "Protoss 10 - Mini-Towns",
    [1127231824] = "Protoss 10 - Mini-Town Master",
    [1865429328] = "Protoss 10 - Overmind Defenders",
    [1093747280] = "Brood Wars Protoss 1 - Town A",
    [1110524496] = "Brood Wars Protoss 1 - Town B",
    [1127301712] = "Brood Wars Protoss 1 - Town C",
    [1144078928] = "Brood Wars Protoss 1 - Town D",
    [1160856144] = "Brood Wars Protoss 1 - Town E",
    [1177633360] = "Brood Wars Protoss 1 - Town F",
    [1093812816] = "Brood Wars Protoss 2 - Town A",
    [1110590032] = "Brood Wars Protoss 2 - Town B",
    [1127367248] = "Brood Wars Protoss 2 - Town C",
    [1144144464] = "Brood Wars Protoss 2 - Town D",
    [1160921680] = "Brood Wars Protoss 2 - Town E",
    [1177698896] = "Brood Wars Protoss 2 - Town F",
    [1093878352] = "Brood Wars Protoss 3 - Town A",
    [1110655568] = "Brood Wars Protoss 3 - Town B",
    [1127432784] = "Brood Wars Protoss 3 - Town C",
    [1144210000] = "Brood Wars Protoss 3 - Town D",
    [1160987216] = "Brood Wars Protoss 3 - Town E",
    [1177764432] = "Brood Wars Protoss 3 - Town F",
    [1093943888] = "Brood Wars Protoss 4 - Town A",
    [1110721104] = "Brood Wars Protoss 4 - Town B",
    [1127498320] = "Brood Wars Protoss 4 - Town C",
    [1144275536] = "Brood Wars Protoss 4 - Town D",
    [1161052752] = "Brood Wars Protoss 4 - Town E",
    [1177829968] = "Brood Wars Protoss 4 - Town F",
    [1094009424] = "Brood Wars Protoss 5 - Town A",
    [1110786640] = "Brood Wars Protoss 5 - Town B",
    [1127563856] = "Brood Wars Protoss 5 - Town C",
    [1144341072] = "Brood Wars Protoss 5 - Town D",
    [1161118288] = "Brood Wars Protoss 5 - Town E",
    [1177895504] = "Brood Wars Protoss 5 - Town F",
    [1094074960] = "Brood Wars Protoss 6 - Town A",
    [1110852176] = "Brood Wars Protoss 6 - Town B",
    [1127629392] = "Brood Wars Protoss 6 - Town C",
    [1144406608] = "Brood Wars Protoss 6 - Town D",
    [1161183824] = "Brood Wars Protoss 6 - Town E",
    [1177961040] = "Brood Wars Protoss 6 - Town F",
    [1094140496] = "Brood Wars Protoss 7 - Town A",
    [1110917712] = "Brood Wars Protoss 7 - Town B",
    [1127694928] = "Brood Wars Protoss 7 - Town C",
    [1144472144] = "Brood Wars Protoss 7 - Town D",
    [1161249360] = "Brood Wars Protoss 7 - Town E",
    [1178026576] = "Brood Wars Protoss 7 - Town F",
    [1094206032] = "Brood Wars Protoss 8 - Town A",
    [1110983248] = "Brood Wars Protoss 8 - Town B",
    [1127760464] = "Brood Wars Protoss 8 - Town C",
    [1144537680] = "Brood Wars Protoss 8 - Town D",
    [1161314896] = "Brood Wars Protoss 8 - Town E",
    [1178092112] = "Brood Wars Protoss 8 - Town F",
    [1093747284] = "Brood Wars Terran 1 - Town A",
    [1110524500] = "Brood Wars Terran 1 - Town B",
    [1127301716] = "Brood Wars Terran 1 - Town C",
    [1144078932] = "Brood Wars Terran 1 - Town D",
    [1160856148] = "Brood Wars Terran 1 - Town E",
    [1177633364] = "Brood Wars Terran 1 - Town F",
    [1093812820] = "Brood Wars Terran 2 - Town A",
    [1110590036] = "Brood Wars Terran 2 - Town B",
    [1127367252] = "Brood Wars Terran 2 - Town C",
    [1144144468] = "Brood Wars Terran 2 - Town D",
    [1160921684] = "Brood Wars Terran 2 - Town E",
    [1177698900] = "Brood Wars Terran 2 - Town F",
    [1093878356] = "Brood Wars Terran 3 - Town A",
    [1110655572] = "Brood Wars Terran 3 - Town B",
    [1127432788] = "Brood Wars Terran 3 - Town C",
    [1144210004] = "Brood Wars Terran 3 - Town D",
    [1160987220] = "Brood Wars Terran 3 - Town E",
    [1177764436] = "Brood Wars Terran 3 - Town F",
    [1093943892] = "Brood Wars Terran 4 - Town A",
    [1110721108] = "Brood Wars Terran 4 - Town B",
    [1127498324] = "Brood Wars Terran 4 - Town C",
    [1144275540] = "Brood Wars Terran 4 - Town D",
    [1161052756] = "Brood Wars Terran 4 - Town E",
    [1177829972] = "Brood Wars Terran 4 - Town F",
    [1094009428] = "Brood Wars Terran 5 - Town A",
    [1110786644] = "Brood Wars Terran 5 - Town B",
    [1127563860] = "Brood Wars Terran 5 - Town C",
    [1144341076] = "Brood Wars Terran 5 - Town D",
    [1161118292] = "Brood Wars Terran 5 - Town E",
    [1177895508] = "Brood Wars Terran 5 - Town F",
    [1094074964] = "Brood Wars Terran 6 - Town A",
    [1110852180] = "Brood Wars Terran 6 - Town B",
    [1127629396] = "Brood Wars Terran 6 - Town C",
    [1144406612] = "Brood Wars Terran 6 - Town D",
    [1161183828] = "Brood Wars Terran 6 - Town E",
    [1177961044] = "Brood Wars Terran 6 - Town F",
    [1094140500] = "Brood Wars Terran 7 - Town A",
    [1110917716] = "Brood Wars Terran 7 - Town B",
    [1127694932] = "Brood Wars Terran 7 - Town C",
    [1144472148] = "Brood Wars Terran 7 - Town D",
    [1161249364] = "Brood Wars Terran 7 - Town E",
    [1178026580] = "Brood Wars Terran 7 - Town F",
    [1094206036] = "Brood Wars Terran 8 - Town A",
    [1110983252] = "Brood Wars Terran 8 - Town B",
    [1127760468] = "Brood Wars Terran 8 - Town C",
    [1144537684] = "Brood Wars Terran 8 - Town D",
    [1161314900] = "Brood Wars Terran 8 - Town E",
    [1178092116] = "Brood Wars Terran 8 - Town F",
    [1093747290] = "Brood Wars Zerg 1 - Town A",
    [1110524506] = "Brood Wars Zerg 1 - Town B",
    [1127301722] = "Brood Wars Zerg 1 - Town C",
    [1144078938] = "Brood Wars Zerg 1 - Town D",
    [1160856154] = "Brood Wars Zerg 1 - Town E",
    [1177633370] = "Brood Wars Zerg 1 - Town F",
    [1093812826] = "Brood Wars Zerg 2 - Town A",
    [1110590042] = "Brood Wars Zerg 2 - Town B",
    [1127367258] = "Brood Wars Zerg 2 - Town C",
    [1144144474] = "Brood Wars Zerg 2 - Town D",
    [1160921690] = "Brood Wars Zerg 2 - Town E",
    [1177698906] = "Brood Wars Zerg 2 - Town F",
    [1093878362] = "Brood Wars Zerg 3 - Town A",
    [1110655578] = "Brood Wars Zerg 3 - Town B",
    [1127432794] = "Brood Wars Zerg 3 - Town C",
    [1144210010] = "Brood Wars Zerg 3 - Town D",
    [1160987226] = "Brood Wars Zerg 3 - Town E",
    [1177764442] = "Brood Wars Zerg 3 - Town F",
    [1093943898] = "Brood Wars Zerg 4 - Town A",
    [1110721114] = "Brood Wars Zerg 4 - Town B",
    [1127498330] = "Brood Wars Zerg 4 - Town C",
    [1144275546] = "Brood Wars Zerg 4 - Town D",
    [1161052762] = "Brood Wars Zerg 4 - Town E",
    [1177829978] = "Brood Wars Zerg 4 - Town F",
    [1094009434] = "Brood Wars Zerg 5 - Town A",
    [1110786650] = "Brood Wars Zerg 5 - Town B",
    [1127563866] = "Brood Wars Zerg 5 - Town C",
    [1144341082] = "Brood Wars Zerg 5 - Town D",
    [1161118298] = "Brood Wars Zerg 5 - Town E",
    [1177895514] = "Brood Wars Zerg 5 - Town F",
    [1094074970] = "Brood Wars Zerg 6 - Town A",
    [1110852186] = "Brood Wars Zerg 6 - Town B",
    [1127629402] = "Brood Wars Zerg 6 - Town C",
    [1144406618] = "Brood Wars Zerg 6 - Town D",
    [1161183834] = "Brood Wars Zerg 6 - Town E",
    [1177961050] = "Brood Wars Zerg 6 - Town F",
    [1094140506] = "Brood Wars Zerg 7 - Town A",
    [1110917722] = "Brood Wars Zerg 7 - Town B",
    [1127694938] = "Brood Wars Zerg 7 - Town C",
    [1144472154] = "Brood Wars Zerg 7 - Town D",
    [1161249370] = "Brood Wars Zerg 7 - Town E",
    [1178026586] = "Brood Wars Zerg 7 - Town F",
    [1094206042] = "Brood Wars Zerg 8 - Town A",
    [1110983258] = "Brood Wars Zerg 8 - Town B",
    [1127760474] = "Brood Wars Zerg 8 - Town C",
    [1144537690] = "Brood Wars Zerg 8 - Town D",
    [1161314906] = "Brood Wars Zerg 8 - Town E",
    [1178092122] = "Brood Wars Zerg 8 - Town F",
    [1094271578] = "Brood Wars Zerg 9 - Town A",
    [1111048794] = "Brood Wars Zerg 9 - Town B",
    [1127826010] = "Brood Wars Zerg 9 - Town C",
    [1144603226] = "Brood Wars Zerg 9 - Town D",
    [1161380442] = "Brood Wars Zerg 9 - Town E",
    [1178157658] = "Brood Wars Zerg 9 - Town F",
    [1093681754] = "Brood Wars Zerg 10 - Town A",
    [1110458970] = "Brood Wars Zerg 10 - Town B",
    [1127236186] = "Brood Wars Zerg 10 - Town C",
    [1144013402] = "Brood Wars Zerg 10 - Town D",
    [1160790618] = "Brood Wars Zerg 10 - Town E",
    [1177567834] = "Brood Wars Zerg 10 - Town F",
}




local function DecodeConst(d, i)
    local val = d[i]
    if val == nil then
        return tostring(i)
    else
        return val
    end
end


function DecodeAllyStatus(d)
    return DecodeConst(AllyStatusDict, d)
end


function DecodeComparison(d)
    return DecodeConst(ComparisonDict, d)
end


function DecodeModifier(d)
    return DecodeConst(ModifierDict, d)
end


function DecodeOrder(d)
    return DecodeConst(OrderDict, d)
end


function DecodePlayer(d)
    return DecodeConst(PlayerDict, d)
end


function DecodePropState(d)
    return DecodeConst(PropStateDict, d)
end


function DecodeResource(d)
    return DecodeConst(ResourceDict, d)
end


function DecodeScore(d)
    return DecodeConst(ScoreDict, d)
end


function DecodeSwitchAction(d)
    return DecodeConst(SwitchActionDict, d)
end


function DecodeSwitchState(d)
    return DecodeConst(SwitchStateDict, d)
end


function DecodeAIScript(d)
    return DecodeConst(AIScriptDict, d)
end


function DecodeCount(d)
    if d == 0 then
        return "All"
    else
        return "0"
    end
end
