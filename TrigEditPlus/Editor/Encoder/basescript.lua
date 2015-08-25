---------------------------------------------------------------------------------
-- Copyright (c) 2014 trgk(phu54321@naver.com)
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
---------------------------------------------------------------------------------

-- Lock access to undefined variable.

-- Code snippet from http://stackoverflow.com/questions/9102931/can-lua-support-case-insensitive-method-calls

__trigeditplus_mt = getmetatable(_G) or {}

__trigeditplus_mt.__newindex = function(table, key, value)
    if type(key) == "string" then
        key = key:lower()
    end

    rawset(table, key, value)
end

__trigeditplus_mt.__index = function(table, key)
    local value

    if type(key) == "string" then
        key = key:lower()
    end

    value = rawget(table, key)
    if value == nil then
        error("Attempt to access undefined variable (" .. key .. ")")
    end
    return value
end

setmetatable(_G, __trigeditplus_mt)

function Trigger(args)
	if args.players then
        args.players = FlattenList(args.players)
    end

    if args.conditions then
        args.conditions = FlattenList(args.conditions)
    end

    if args.actions then
        args.actions = FlattenList(args.actions)
    end

    if args.flag then
        args.flag = FlattenList(args.flag)
    end

	args.callerLine = debug.getinfo(2).currentline

    __internal__AddTrigger(args)
end


function FlattenList(list)
    local output, tmp, outputidx

    if type(list) == 'table' then
        if list.__trg_magic ~= nil then
            return {list}
        end

        output = {}
        outputidx = 1
        for i = 1, #list do
            tmp = FlattenList(list[i])
            for j = 1, #tmp do
                output[outputidx] = tmp[j]
                outputidx = outputidx + 1
            end
        end

        return output
    else
        return {list}
    end
end

-- Constants used for trigger.
actexec = {__trg_magic="trgconst"}
preserved = {__trg_magic="trgconst"}
disabled = {__trg_magic="trgconst"}


-- Constants used inside triggers & actions
All = {__trg_magic="trgconst"}
Enemy = {__trg_magic="trgconst"}
Ally = {__trg_magic="trgconst"}
AlliedVictory = {__trg_magic="trgconst"}
AtLeast = {__trg_magic="trgconst"}
AtMost = {__trg_magic="trgconst"}
Exactly = {__trg_magic="trgconst"}
SetTo = {__trg_magic="trgconst"}
Add = {__trg_magic="trgconst"}
Subtract = {__trg_magic="trgconst"}
Move = {__trg_magic="trgconst"}
Patrol = {__trg_magic="trgconst"}
Attack = {__trg_magic="trgconst"}
P1 = {__trg_magic="trgconst"}
P2 = {__trg_magic="trgconst"}
P3 = {__trg_magic="trgconst"}
P4 = {__trg_magic="trgconst"}
P5 = {__trg_magic="trgconst"}
P6 = {__trg_magic="trgconst"}
P7 = {__trg_magic="trgconst"}
P8 = {__trg_magic="trgconst"}
P9 = {__trg_magic="trgconst"}
P10 = {__trg_magic="trgconst"}
P11 = {__trg_magic="trgconst"}
P12 = {__trg_magic="trgconst"}
CurrentPlayer = {__trg_magic="trgconst"}
Foes = {__trg_magic="trgconst"}
Allies = {__trg_magic="trgconst"}
NeutralPlayers = {__trg_magic="trgconst"}
AllPlayers = {__trg_magic="trgconst"}
Force1 = {__trg_magic="trgconst"}
Force2 = {__trg_magic="trgconst"}
Force3 = {__trg_magic="trgconst"}
Force4 = {__trg_magic="trgconst"}
NonAlliedVictoryPlayers = {__trg_magic="trgconst"}
Enable = {__trg_magic="trgconst"}
Disable = {__trg_magic="trgconst"}
Toggle = {__trg_magic="trgconst"}
Ore = {__trg_magic="trgconst"}
Gas = {__trg_magic="trgconst"}
OreAndGas = {__trg_magic="trgconst"}
Total = {__trg_magic="trgconst"}
Units = {__trg_magic="trgconst"}
Buildings = {__trg_magic="trgconst"}
UnitsAndBuildings = {__trg_magic="trgconst"}
Kills = {__trg_magic="trgconst"}
Razings = {__trg_magic="trgconst"}
KillsAndRazings = {__trg_magic="trgconst"}
Custom = {__trg_magic="trgconst"}
Set = {__trg_magic="trgconst"}
Clear = {__trg_magic="trgconst"}
Random = {__trg_magic="trgconst"}
Cleared = {__trg_magic="trgconst"}


-- Conditions list
function Condition(locid, player, amount, unitid, comparison, condtype, restype, flags)
    return {locid, player, amount, unitid, comparison, condtype, restype, flags, __trg_magic="condition"}
end


function NoCondition()
    return Condition(0, 0, 0, 0, 0, 0, 0, 0)
end


function CountdownTimer(Comparison, Time)
    Comparison = ParseComparison(Comparison)
    return Condition(0, 0, Time, 0, Comparison, 1, 0, 0)
end


function Command(Player, Comparison, Number, Unit)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    return Condition(0, Player, Number, Unit, Comparison, 2, 0, 0)
end


function Bring(Player, Comparison, Number, Unit, Location)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    return Condition(Location, Player, Number, Unit, Comparison, 3, 0, 0)
end


function Accumulate(Player, Comparison, Number, ResourceType)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    ResourceType = ParseResource(ResourceType)
    return Condition(0, Player, Number, 0, Comparison, 4, ResourceType, 0)
end


function Kills(Player, Comparison, Number, Unit)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    return Condition(0, Player, Number, Unit, Comparison, 5, 0, 0)
end


function CommandMost(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 6, 0, 0)
end


function CommandMostAt(Unit, Location)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    return Condition(Location, 0, 0, Unit, 0, 7, 0, 0)
end


function MostKills(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 8, 0, 0)
end


function HighestScore(ScoreType)
    ScoreType = ParseScore(ScoreType)
    return Condition(0, 0, 0, 0, 0, 9, ScoreType, 0)
end


function MostResources(ResourceType)
    ResourceType = ParseResource(ResourceType)
    return Condition(0, 0, 0, 0, 0, 10, ResourceType, 0)
end


function Switch(Switch, State)
    Switch = ParseSwitchName(Switch)
    State = ParseSwitchState(State)
    return Condition(0, 0, 0, 0, State, 11, Switch, 0)
end


function ElapsedTime(Comparison, Time)
    Comparison = ParseComparison(Comparison)
    return Condition(0, 0, Time, 0, Comparison, 12, 0, 0)
end


function Briefing()
    return Condition(0, 0, 0, 0, 0, 13, 0, 0)
end


function Opponents(Player, Comparison, Number)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    return Condition(0, Player, Number, 0, Comparison, 14, 0, 0)
end


function Deaths(Player, Comparison, Number, Unit)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    return Condition(0, Player, Number, Unit, Comparison, 15, 0, 0)
end


function CommandLeast(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 16, 0, 0)
end


function CommandLeastAt(Unit, Location)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    return Condition(Location, 0, 0, Unit, 0, 17, 0, 0)
end


function LeastKills(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 18, 0, 0)
end


function LowestScore(ScoreType)
    ScoreType = ParseScore(ScoreType)
    return Condition(0, 0, 0, 0, 0, 19, ScoreType, 0)
end


function LeastResources(ResourceType)
    ResourceType = ParseResource(ResourceType)
    return Condition(0, 0, 0, 0, 0, 20, ResourceType, 0)
end


function Score(Player, ScoreType, Comparison, Number)
    Player = ParsePlayer(Player)
    ScoreType = ParseScore(ScoreType)
    Comparison = ParseComparison(Comparison)
    return Condition(0, Player, Number, 0, Comparison, 21, ScoreType, 0)
end


function Always()
    return Condition(0, 0, 0, 0, 0, 22, 0, 0)
end


function Never()
    return Condition(0, 0, 0, 0, 0, 23, 0, 0)
end




-- Actions list
function Action(locid1, strid, wavid, time, player1, player2, unitid, acttype, amount, flags)
    return {locid1, strid, wavid, time, player1, player2, unitid, acttype, amount, flags, __trg_magic="action"}
end


function Victory()
    return Action(0, 0, 0, 0, 0, 0, 0, 1, 0, 4)
end


function Defeat()
    return Action(0, 0, 0, 0, 0, 0, 0, 2, 0, 4)
end


function PreserveTrigger()
    return Action(0, 0, 0, 0, 0, 0, 0, 3, 0, 4)
end


function Wait(Time)
    return Action(0, 0, 0, Time, 0, 0, 0, 4, 0, 4)
end


function PauseGame()
    return Action(0, 0, 0, 0, 0, 0, 0, 5, 0, 4)
end


function UnpauseGame()
    return Action(0, 0, 0, 0, 0, 0, 0, 6, 0, 4)
end


function Transmission(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
    if AlwaysDisplay == nil then
		AlwaysDisplay = 4
	end

    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    WAVName = ParseString(WAVName)
    TimeModifier = ParseModifier(TimeModifier)
    Text = ParseString(Text)
    return Action(Where, Text, WAVName, 0, 0, Time, Unit, 7, TimeModifier, AlwaysDisplay)
end

-- Location	Text	Wav	TotDuration	0	DurationMod	UnitType	7	NumericMod	20

function PlayWAV(WAVName)
    WAVName = ParseString(WAVName)
    return Action(0, 0, WAVName, 0, 0, 0, 0, 8, 0, 4)
end


function DisplayText(Text, AlwaysDisplay)
    if AlwaysDisplay == nil then AlwaysDisplay = 4 end
    Text = ParseString(Text)
    return Action(0, Text, 0, 0, 0, 0, 0, 9, 0, AlwaysDisplay)
end


function CenterView(Where)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, 0, 0, 0, 10, 0, 4)
end


function CreateUnitWithProperties(Count, Unit, Where, Player, Properties)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    Player = ParsePlayer(Player)
    Properties = ParseProperty(Properties)
    return Action(Where, 0, 0, 0, Player, Properties, Unit, 11, Count, 28)
end


function SetMissionObjectives(Text)
    Text = ParseString(Text)
    return Action(0, Text, 0, 0, 0, 0, 0, 12, 0, 4)
end


function SetSwitch(Switch, State)
    Switch = ParseSwitchName(Switch)
    State = ParseSwitchAction(State)
    return Action(0, 0, 0, 0, 0, Switch, 0, 13, State, 4)
end


function SetCountdownTimer(TimeModifier, Time)
    TimeModifier = ParseModifier(TimeModifier)
    return Action(0, 0, 0, Time, 0, 0, 0, 14, TimeModifier, 4)
end


function RunAIScript(Script)
    Script = ParseAIScript(Script)
    return Action(0, 0, 0, 0, 0, Script, 0, 15, 0, 4)
end


function RunAIScriptAt(Script, Where)
    Script = ParseAIScript(Script)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, 0, Script, 0, 16, 0, 4)
end


function LeaderBoardControl(Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, Unit, 17, 0, 20)
end


function LeaderBoardControlAt(Unit, Location, Label)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    Label = ParseString(Label)
    return Action(Location, Label, 0, 0, 0, 0, Unit, 18, 0, 20)
end


function LeaderBoardResources(ResourceType, Label)
    ResourceType = ParseResource(ResourceType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, ResourceType, 19, 0, 4)
end


function LeaderBoardKills(Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, Unit, 20, 0, 20)
end


function LeaderBoardScore(ScoreType, Label)
    ScoreType = ParseScore(ScoreType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, ScoreType, 21, 0, 4)
end


function KillUnit(Unit, Player)
    Unit = ParseUnit(Unit)
    Player = ParsePlayer(Player)
    return Action(0, 0, 0, 0, Player, 0, Unit, 22, 0, 20)
end


function KillUnitAt(Count, Unit, Where, ForPlayer)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    ForPlayer = ParsePlayer(ForPlayer)
    return Action(Where, 0, 0, 0, ForPlayer, 0, Unit, 23, Count, 20)
end


function RemoveUnit(Unit, Player)
    Unit = ParseUnit(Unit)
    Player = ParsePlayer(Player)
    return Action(0, 0, 0, 0, Player, 0, Unit, 24, 0, 20)
end


function RemoveUnitAt(Count, Unit, Where, ForPlayer)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    ForPlayer = ParsePlayer(ForPlayer)
    return Action(Where, 0, 0, 0, ForPlayer, 0, Unit, 25, Count, 20)
end


function SetResources(Player, Modifier, Amount, ResourceType)
    Player = ParsePlayer(Player)
    Modifier = ParseModifier(Modifier)
    ResourceType = ParseResource(ResourceType)
    return Action(0, 0, 0, 0, Player, Amount, ResourceType, 26, Modifier, 4)
end


function SetScore(Player, Modifier, Amount, ScoreType)
    Player = ParsePlayer(Player)
    Modifier = ParseModifier(Modifier)
    ScoreType = ParseScore(ScoreType)
    return Action(0, 0, 0, 0, Player, Amount, ScoreType, 27, Modifier, 4)
end


function MinimapPing(Where)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, 0, 0, 0, 28, 0, 4)
end


function TalkingPortrait(Unit, Time)
    Unit = ParseUnit(Unit)
    return Action(0, 0, 0, Time, 0, 0, Unit, 29, 0, 20)
end


function MuteUnitSpeech()
    return Action(0, 0, 0, 0, 0, 0, 0, 30, 0, 4)
end


function UnMuteUnitSpeech()
    return Action(0, 0, 0, 0, 0, 0, 0, 31, 0, 4)
end


function LeaderBoardComputerPlayers(State)
    State = ParsePropState(State)
    return Action(0, 0, 0, 0, 0, 0, 0, 32, State, 4)
end


function LeaderBoardGoalControl(Goal, Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, Unit, 33, 0, 20)
end


function LeaderBoardGoalControlAt(Goal, Unit, Location, Label)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    Label = ParseString(Label)
    return Action(Location, Label, 0, 0, 0, Goal, Unit, 34, 0, 20)
end


function LeaderBoardGoalResources(Goal, ResourceType, Label)
    ResourceType = ParseResource(ResourceType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, ResourceType, 35, 0, 4)
end


function LeaderBoardGoalKills(Goal, Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, Unit, 36, 0, 20)
end


function LeaderBoardGoalScore(Goal, ScoreType, Label)
    ScoreType = ParseScore(ScoreType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, ScoreType, 37, 0, 4)
end


function MoveLocation(Location, OnUnit, Owner, DestLocation)
    Location = ParseLocation(Location)
    OnUnit = ParseUnit(OnUnit)
    Owner = ParsePlayer(Owner)
    DestLocation = ParseLocation(DestLocation)
    return Action(DestLocation, 0, 0, 0, Owner, Location, OnUnit, 38, 0, 20)
end


function MoveUnit(Count, UnitType, Owner, StartLocation, DestLocation)
    Count = ParseCount(Count)
    UnitType = ParseUnit(UnitType)
    Owner = ParsePlayer(Owner)
    StartLocation = ParseLocation(StartLocation)
    DestLocation = ParseLocation(DestLocation)
    return Action(StartLocation, 0, 0, 0, Owner, DestLocation,
                  UnitType, 39, Count, 20)
end


function LeaderBoardGreed(Goal)
    return Action(0, 0, 0, 0, 0, Goal, 0, 40, 0, 4)
end


function SetNextScenario(ScenarioName)
    ScenarioName = ParseString(ScenarioName)
    return Action(0, ScenarioName, 0, 0, 0, 0, 0, 41, 0, 4)
end


function SetDoodadState(State, Unit, Owner, Where)
    State = ParsePropState(State)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, 0, Unit, 42, State, 20)
end


function SetInvincibility(State, Unit, Owner, Where)
    State = ParsePropState(State)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, 0, Unit, 43, State, 20)
end


function CreateUnit(Number, Unit, Where, ForPlayer)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    ForPlayer = ParsePlayer(ForPlayer)
    return Action(Where, 0, 0, 0, ForPlayer, 0, Unit, 44, Number, 20)
end


function SetDeaths(Player, Modifier, Number, Unit)
    Player = ParsePlayer(Player)
    Modifier = ParseModifier(Modifier)
    Unit = ParseUnit(Unit)
    return Action(0, 0, 0, 0, Player, Number, Unit, 45, Modifier, 20)
end


function Order(Unit, Owner, StartLocation, OrderType, DestLocation)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    StartLocation = ParseLocation(StartLocation)
    OrderType = ParseOrder(OrderType)
    DestLocation = ParseLocation(DestLocation)
    return Action(StartLocation, 0, 0, 0, Owner, DestLocation,
                  Unit, 46, OrderType, 20)
end


function Comment(Text)
    Text = ParseString(Text)
    return Action(0, Text, 0, 0, 0, 0, 0, 47, 0, 4)
end


function GiveUnits(Count, Unit, Owner, Where, NewOwner)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    NewOwner = ParsePlayer(NewOwner)
    return Action(Where, 0, 0, 0, Owner, NewOwner, Unit, 48, Count, 20)
end


function ModifyUnitHitPoints(Count, Unit, Owner, Where, Percent)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Percent, Unit, 49, Count, 20)
end


function ModifyUnitEnergy(Count, Unit, Owner, Where, Percent)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Percent, Unit, 50, Count, 20)
end


function ModifyUnitShields(Count, Unit, Owner, Where, Percent)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Percent, Unit, 51, Count, 20)
end


function ModifyUnitResourceAmount(Count, Owner, Where, NewValue)
    Count = ParseCount(Count)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, NewValue, 0, 52, Count, 4)
end


function ModifyUnitHangarCount(Add, Count, Unit, Owner, Where)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Add, Unit, 53, Count, 20)
end


function PauseTimer()
    return Action(0, 0, 0, 0, 0, 0, 0, 54, 0, 4)
end


function UnpauseTimer()
    return Action(0, 0, 0, 0, 0, 0, 0, 55, 0, 4)
end


function Draw()
    return Action(0, 0, 0, 0, 0, 0, 0, 56, 0, 4)
end


function SetAllianceStatus(Player, Status)
    Player = ParsePlayer(Player)
    Status = ParseAllyStatus(Status)
    return Action(0, 0, 0, 0, Player, 0, Status, 57, 0, 4)
end


-- Condition/Action disabler
function Disabled(stmt)
    stmt["disabled"] = true
    return stmt
end

AllyStatusDict = {
    [Enemy] =  0,
    [Ally] =  1,
    [AlliedVictory] =  2,
}

ComparisonDict = {
    [AtLeast] =  0,
    [AtMost] =  1,
    [Exactly] =  10,
}

ModifierDict = {
    [SetTo] =  7,
    [Add] =  8,
    [Subtract] =  9,
}

OrderDict = {
    [Move] =  0,
    [Patrol] =  1,
    [Attack] =  2,
}

PlayerDict = {
    [P1] =  0,
    [P2] =  1,
    [P3] =  2,
    [P4] =  3,
    [P5] =  4,
    [P6] =  5,
    [P7] =  6,
    [P8] =  7,
    [P9] =  8,
    [P10] =  9,
    [P11] =  10,
    [P12] =  11,
    [CurrentPlayer] =  13,
    [Foes] =  14,
    [Allies] =  15,
    [NeutralPlayers] =  16,
    [AllPlayers] =  17,
    [Force1] =  18,
    [Force2] =  19,
    [Force3] =  20,
    [Force4] =  21,
    [NonAlliedVictoryPlayers] =  26,
}

PropStateDict = {
    [Enable] =  4,
    [Disable] =  5,
    [Toggle] =  6,
}

ResourceDict = {
    [Ore] =  0,
    [Gas] =  1,
    [OreAndGas] =  2,
}

ScoreDict = {
    [Total] =  0,
    [Units] =  1,
    [Buildings] =  2,
    [UnitsAndBuildings] =  3,
    [Kills] =  4,
    [Razings] =  5,
    [KillsAndRazings] =  6,
    [Custom] =  7,
}

SwitchActionDict = {
    [Set] =  4,
    [Clear] =  5,
    [Toggle] =  6,
    [Random] =  11,
}

SwitchStateDict = {
    [Set] =  2,
    [Cleared] =  3,
}


AIScriptDict = {
    ["Terran Custom Level"] = 1967344980,
    ["Zerg Custom Level"] = 1967344986,
    ["Protoss Custom Level"] = 1967344976,
    ["Terran Expansion Custom Level"] = 2017676628,
    ["Zerg Expansion Custom Level"] = 2017676634,
    ["Protoss Expansion Custom Level"] = 2017676624,
    ["Terran Campaign Easy"] = 1716472916,
    ["Terran Campaign Medium"] = 1145392468,
    ["Terran Campaign Difficult"] = 1716078676,
    ["Terran Campaign Insane"] = 1347769172,
    ["Terran Campaign Area Town"] = 1163018580,
    ["Zerg Campaign Easy"] = 1716472922,
    ["Zerg Campaign Medium"] = 1145392474,
    ["Zerg Campaign Difficult"] = 1716078682,
    ["Zerg Campaign Insane"] = 1347769178,
    ["Zerg Campaign Area Town"] = 1163018586,
    ["Protoss Campaign Easy"] = 1716472912,
    ["Protoss Campaign Medium"] = 1145392464,
    ["Protoss Campaign Difficult"] = 1716078672,
    ["Protoss Campaign Insane"] = 1347769168,
    ["Protoss Campaign Area Town"] = 1163018576,
    ["Expansion Terran Campaign Easy"] = 2018462804,
    ["Expansion Terran Campaign Medium"] = 2017807700,
    ["Expansion Terran Campaign Difficult"] = 2018068564,
    ["Expansion Terran Campaign Insane"] = 2018857812,
    ["Expansion Terran Campaign Area Town"] = 2018656596,
    ["Expansion Zerg Campaign Easy"] = 2018462810,
    ["Expansion Zerg Campaign Medium"] = 2017807706,
    ["Expansion Zerg Campaign Difficult"] = 2018068570,
    ["Expansion Zerg Campaign Insane"] = 2018857818,
    ["Expansion Zerg Campaign Area Town"] = 2018656602,
    ["Expansion Protoss Campaign Easy"] = 2018462800,
    ["Expansion Protoss Campaign Medium"] = 2017807696,
    ["Expansion Protoss Campaign Difficult"] = 2018068560,
    ["Expansion Protoss Campaign Insane"] = 2018857808,
    ["Expansion Protoss Campaign Area Town"] = 2018656592,
    ["Send All Units on Strategic Suicide Missions"] = 1667855699,
    ["Send All Units on Random Suicide Missions"] = 1382643027,
    ["Switch Computer Player to Rescue Passive"] = 1969451858,
    ["Turn ON Shared Vision for Player 1"] = 812209707,
    ["Turn ON Shared Vision for Player 2"] = 828986923,
    ["Turn ON Shared Vision for Player 3"] = 845764139,
    ["Turn ON Shared Vision for Player 4"] = 862541355,
    ["Turn ON Shared Vision for Player 5"] = 879318571,
    ["Turn ON Shared Vision for Player 6"] = 896095787,
    ["Turn ON Shared Vision for Player 7"] = 912873003,
    ["Turn ON Shared Vision for Player 8"] = 929650219,
    ["Turn OFF Shared Vision for Player 1"] = 812209709,
    ["Turn OFF Shared Vision for Player 2"] = 828986925,
    ["Turn OFF Shared Vision for Player 3"] = 845764141,
    ["Turn OFF Shared Vision for Player 4"] = 862541357,
    ["Turn OFF Shared Vision for Player 5"] = 879318573,
    ["Turn OFF Shared Vision for Player 6"] = 896095789,
    ["Turn OFF Shared Vision for Player 7"] = 912873005,
    ["Turn OFF Shared Vision for Player 8"] = 929650221,
    ["Move Dark Templars to Region"] = 1700034125,
    ["Clear Previous Combat Data"] = 1131572291,
    ["Set Player to Enemy"] = 2037214789,
    ["Set Player to Ally  "] = 2037148737,
    ["Value This Area Higher"] = 1098214486,
    ["Enter Closest Bunker"] = 1799515717,
    ["Set Generic Command Target"] = 1733588051,
    ["Make These Units Patrol"] = 1951429715,
    ["Enter Transport"] = 1918135877,
    ["Exit Transport"] = 1918138437,
    ["AI Nuke Here"] = 1699247438,
    ["AI Harass Here"] = 1699242312,
    ["Set Unit Order To: Junk Yard Dog"] = 1732532554,
    ["Disruption Web Here"] = 1699239748,
    ["Recall Here"] = 1699243346,
    ["Terran 3 - Zerg Town"] = 863135060,
    ["Terran 5 - Terran Main Town"] = 896689492,
    ["Terran 5 - Terran Harvest Town"] = 1211458900,
    ["Terran 6 - Air Attack Zerg"] = 913466708,
    ["Terran 6 - Ground Attack Zerg"] = 1647732052,
    ["Terran 6 - Zerg Support Town"] = 1664509268,
    ["Terran 7 - Bottom Zerg Town"] = 930243924,
    ["Terran 7 - Right Zerg Town"] = 1933010260,
    ["Terran 7 - Middle Zerg Town"] = 1832346964,
    ["Terran 8 - Confederate Town"] = 947021140,
    ["Terran 9 - Light Attack"] = 1278833236,
    ["Terran 9 - Heavy Attack"] = 1211724372,
    ["Terran 10 - Confederate Towns"] = 808543572,
    ["Terran 11 - Zerg Town"] = 2050044244,
    ["Terran 11 - Lower Protoss Town"] = 1630613844,
    ["Terran 11 - Upper Protoss Town"] = 1647391060,
    ["Terran 12 - Nuke Town"] = 1311912276,
    ["Terran 12 - Phoenix Town"] = 1345466708,
    ["Terran 12 - Tank Town"] = 1412575572,
    ["Terran 1 - Electronic Distribution"] = 826557780,
    ["Terran 2 - Electronic Distribution"] = 843334996,
    ["Terran 3 - Electronic Distribution"] = 860112212,
    ["Terran 1 - Shareware"] = 827806548,
    ["Terran 2 - Shareware"] = 844583764,
    ["Terran 3 - Shareware"] = 861360980,
    ["Terran 4 - Shareware"] = 878138196,
    ["Terran 5 - Shareware"] = 894915412,
    ["Zerg 1 - Terran Town"] = 829580634,
    ["Zerg 2 - Protoss Town"] = 846357850,
    ["Zerg 3 - Terran Town"] = 863135066,
    ["Zerg 4 - Right Terran Town"] = 879912282,
    ["Zerg 4 - Lower Terran Town"] = 1395942746,
    ["Zerg 6 - Protoss Town"] = 913466714,
    ["Zerg 7 - Air Town"] = 1631023706,
    ["Zerg 7 - Ground Town"] = 1731687002,
    ["Zerg 7 - Support Town"] = 1933013594,
    ["Zerg 8 - Scout Town"] = 947021146,
    ["Zerg 8 - Templar Town"] = 1412982106,
    ["Zerg 9 - Teal Protoss"] = 963798362,
    ["Zerg 9 - Left Yellow Protoss"] = 2037135706,
    ["Zerg 9 - Right Yellow Protoss"] = 2037528922,
    ["Zerg 9 - Left Orange Protoss"] = 1869363546,
    ["Zerg 9 - Right Orange Protoss"] = 1869756762,
    ["Zerg 10 - Left Teal (Attack"] = 1630548314,
    ["Zerg 10 - Right Teal (Support"] = 1647325530,
    ["Zerg 10 - Left Yellow (Support"] = 1664102746,
    ["Zerg 10 - Right Yellow (Attack"] = 1680879962,
    ["Zerg 10 - Red Protoss"] = 1697657178,
    ["Protoss 1 - Zerg Town"] = 829387344,
    ["Protoss 2 - Zerg Town"] = 846164560,
    ["Protoss 3 - Air Zerg Town"] = 1379103312,
    ["Protoss 3 - Ground Zerg Town"] = 1194553936,
    ["Protoss 4 - Zerg Town"] = 879718992,
    ["Protoss 5 - Zerg Town Island"] = 1228239440,
    ["Protoss 5 - Zerg Town Base"] = 1110798928,
    ["Protoss 7 - Left Protoss Town"] = 930050640,
    ["Protoss 7 - Right Protoss Town"] = 1110930000,
    ["Protoss 7 - Shrine Protoss"] = 1396142672,
    ["Protoss 8 - Left Protoss Town"] = 946827856,
    ["Protoss 8 - Right Protoss Town"] = 1110995536,
    ["Protoss 8 - Protoss Defenders"] = 1144549968,
    ["Protoss 9 - Ground Zerg"] = 963605072,
    ["Protoss 9 - Air Zerg"] = 1463382608,
    ["Protoss 9 - Spell Zerg"] = 1496937040,
    ["Protoss 10 - Mini-Towns"] = 808546896,
    ["Protoss 10 - Mini-Town Master"] = 1127231824,
    ["Protoss 10 - Overmind Defenders"] = 1865429328,
    ["Brood Wars Protoss 1 - Town A"] = 1093747280,
    ["Brood Wars Protoss 1 - Town B"] = 1110524496,
    ["Brood Wars Protoss 1 - Town C"] = 1127301712,
    ["Brood Wars Protoss 1 - Town D"] = 1144078928,
    ["Brood Wars Protoss 1 - Town E"] = 1160856144,
    ["Brood Wars Protoss 1 - Town F"] = 1177633360,
    ["Brood Wars Protoss 2 - Town A"] = 1093812816,
    ["Brood Wars Protoss 2 - Town B"] = 1110590032,
    ["Brood Wars Protoss 2 - Town C"] = 1127367248,
    ["Brood Wars Protoss 2 - Town D"] = 1144144464,
    ["Brood Wars Protoss 2 - Town E"] = 1160921680,
    ["Brood Wars Protoss 2 - Town F"] = 1177698896,
    ["Brood Wars Protoss 3 - Town A"] = 1093878352,
    ["Brood Wars Protoss 3 - Town B"] = 1110655568,
    ["Brood Wars Protoss 3 - Town C"] = 1127432784,
    ["Brood Wars Protoss 3 - Town D"] = 1144210000,
    ["Brood Wars Protoss 3 - Town E"] = 1160987216,
    ["Brood Wars Protoss 3 - Town F"] = 1177764432,
    ["Brood Wars Protoss 4 - Town A"] = 1093943888,
    ["Brood Wars Protoss 4 - Town B"] = 1110721104,
    ["Brood Wars Protoss 4 - Town C"] = 1127498320,
    ["Brood Wars Protoss 4 - Town D"] = 1144275536,
    ["Brood Wars Protoss 4 - Town E"] = 1161052752,
    ["Brood Wars Protoss 4 - Town F"] = 1177829968,
    ["Brood Wars Protoss 5 - Town A"] = 1094009424,
    ["Brood Wars Protoss 5 - Town B"] = 1110786640,
    ["Brood Wars Protoss 5 - Town C"] = 1127563856,
    ["Brood Wars Protoss 5 - Town D"] = 1144341072,
    ["Brood Wars Protoss 5 - Town E"] = 1161118288,
    ["Brood Wars Protoss 5 - Town F"] = 1177895504,
    ["Brood Wars Protoss 6 - Town A"] = 1094074960,
    ["Brood Wars Protoss 6 - Town B"] = 1110852176,
    ["Brood Wars Protoss 6 - Town C"] = 1127629392,
    ["Brood Wars Protoss 6 - Town D"] = 1144406608,
    ["Brood Wars Protoss 6 - Town E"] = 1161183824,
    ["Brood Wars Protoss 6 - Town F"] = 1177961040,
    ["Brood Wars Protoss 7 - Town A"] = 1094140496,
    ["Brood Wars Protoss 7 - Town B"] = 1110917712,
    ["Brood Wars Protoss 7 - Town C"] = 1127694928,
    ["Brood Wars Protoss 7 - Town D"] = 1144472144,
    ["Brood Wars Protoss 7 - Town E"] = 1161249360,
    ["Brood Wars Protoss 7 - Town F"] = 1178026576,
    ["Brood Wars Protoss 8 - Town A"] = 1094206032,
    ["Brood Wars Protoss 8 - Town B"] = 1110983248,
    ["Brood Wars Protoss 8 - Town C"] = 1127760464,
    ["Brood Wars Protoss 8 - Town D"] = 1144537680,
    ["Brood Wars Protoss 8 - Town E"] = 1161314896,
    ["Brood Wars Protoss 8 - Town F"] = 1178092112,
    ["Brood Wars Terran 1 - Town A"] = 1093747284,
    ["Brood Wars Terran 1 - Town B"] = 1110524500,
    ["Brood Wars Terran 1 - Town C"] = 1127301716,
    ["Brood Wars Terran 1 - Town D"] = 1144078932,
    ["Brood Wars Terran 1 - Town E"] = 1160856148,
    ["Brood Wars Terran 1 - Town F"] = 1177633364,
    ["Brood Wars Terran 2 - Town A"] = 1093812820,
    ["Brood Wars Terran 2 - Town B"] = 1110590036,
    ["Brood Wars Terran 2 - Town C"] = 1127367252,
    ["Brood Wars Terran 2 - Town D"] = 1144144468,
    ["Brood Wars Terran 2 - Town E"] = 1160921684,
    ["Brood Wars Terran 2 - Town F"] = 1177698900,
    ["Brood Wars Terran 3 - Town A"] = 1093878356,
    ["Brood Wars Terran 3 - Town B"] = 1110655572,
    ["Brood Wars Terran 3 - Town C"] = 1127432788,
    ["Brood Wars Terran 3 - Town D"] = 1144210004,
    ["Brood Wars Terran 3 - Town E"] = 1160987220,
    ["Brood Wars Terran 3 - Town F"] = 1177764436,
    ["Brood Wars Terran 4 - Town A"] = 1093943892,
    ["Brood Wars Terran 4 - Town B"] = 1110721108,
    ["Brood Wars Terran 4 - Town C"] = 1127498324,
    ["Brood Wars Terran 4 - Town D"] = 1144275540,
    ["Brood Wars Terran 4 - Town E"] = 1161052756,
    ["Brood Wars Terran 4 - Town F"] = 1177829972,
    ["Brood Wars Terran 5 - Town A"] = 1094009428,
    ["Brood Wars Terran 5 - Town B"] = 1110786644,
    ["Brood Wars Terran 5 - Town C"] = 1127563860,
    ["Brood Wars Terran 5 - Town D"] = 1144341076,
    ["Brood Wars Terran 5 - Town E"] = 1161118292,
    ["Brood Wars Terran 5 - Town F"] = 1177895508,
    ["Brood Wars Terran 6 - Town A"] = 1094074964,
    ["Brood Wars Terran 6 - Town B"] = 1110852180,
    ["Brood Wars Terran 6 - Town C"] = 1127629396,
    ["Brood Wars Terran 6 - Town D"] = 1144406612,
    ["Brood Wars Terran 6 - Town E"] = 1161183828,
    ["Brood Wars Terran 6 - Town F"] = 1177961044,
    ["Brood Wars Terran 7 - Town A"] = 1094140500,
    ["Brood Wars Terran 7 - Town B"] = 1110917716,
    ["Brood Wars Terran 7 - Town C"] = 1127694932,
    ["Brood Wars Terran 7 - Town D"] = 1144472148,
    ["Brood Wars Terran 7 - Town E"] = 1161249364,
    ["Brood Wars Terran 7 - Town F"] = 1178026580,
    ["Brood Wars Terran 8 - Town A"] = 1094206036,
    ["Brood Wars Terran 8 - Town B"] = 1110983252,
    ["Brood Wars Terran 8 - Town C"] = 1127760468,
    ["Brood Wars Terran 8 - Town D"] = 1144537684,
    ["Brood Wars Terran 8 - Town E"] = 1161314900,
    ["Brood Wars Terran 8 - Town F"] = 1178092116,
    ["Brood Wars Zerg 1 - Town A"] = 1093747290,
    ["Brood Wars Zerg 1 - Town B"] = 1110524506,
    ["Brood Wars Zerg 1 - Town C"] = 1127301722,
    ["Brood Wars Zerg 1 - Town D"] = 1144078938,
    ["Brood Wars Zerg 1 - Town E"] = 1160856154,
    ["Brood Wars Zerg 1 - Town F"] = 1177633370,
    ["Brood Wars Zerg 2 - Town A"] = 1093812826,
    ["Brood Wars Zerg 2 - Town B"] = 1110590042,
    ["Brood Wars Zerg 2 - Town C"] = 1127367258,
    ["Brood Wars Zerg 2 - Town D"] = 1144144474,
    ["Brood Wars Zerg 2 - Town E"] = 1160921690,
    ["Brood Wars Zerg 2 - Town F"] = 1177698906,
    ["Brood Wars Zerg 3 - Town A"] = 1093878362,
    ["Brood Wars Zerg 3 - Town B"] = 1110655578,
    ["Brood Wars Zerg 3 - Town C"] = 1127432794,
    ["Brood Wars Zerg 3 - Town D"] = 1144210010,
    ["Brood Wars Zerg 3 - Town E"] = 1160987226,
    ["Brood Wars Zerg 3 - Town F"] = 1177764442,
    ["Brood Wars Zerg 4 - Town A"] = 1093943898,
    ["Brood Wars Zerg 4 - Town B"] = 1110721114,
    ["Brood Wars Zerg 4 - Town C"] = 1127498330,
    ["Brood Wars Zerg 4 - Town D"] = 1144275546,
    ["Brood Wars Zerg 4 - Town E"] = 1161052762,
    ["Brood Wars Zerg 4 - Town F"] = 1177829978,
    ["Brood Wars Zerg 5 - Town A"] = 1094009434,
    ["Brood Wars Zerg 5 - Town B"] = 1110786650,
    ["Brood Wars Zerg 5 - Town C"] = 1127563866,
    ["Brood Wars Zerg 5 - Town D"] = 1144341082,
    ["Brood Wars Zerg 5 - Town E"] = 1161118298,
    ["Brood Wars Zerg 5 - Town F"] = 1177895514,
    ["Brood Wars Zerg 6 - Town A"] = 1094074970,
    ["Brood Wars Zerg 6 - Town B"] = 1110852186,
    ["Brood Wars Zerg 6 - Town C"] = 1127629402,
    ["Brood Wars Zerg 6 - Town D"] = 1144406618,
    ["Brood Wars Zerg 6 - Town E"] = 1161183834,
    ["Brood Wars Zerg 6 - Town F"] = 1177961050,
    ["Brood Wars Zerg 7 - Town A"] = 1094140506,
    ["Brood Wars Zerg 7 - Town B"] = 1110917722,
    ["Brood Wars Zerg 7 - Town C"] = 1127694938,
    ["Brood Wars Zerg 7 - Town D"] = 1144472154,
    ["Brood Wars Zerg 7 - Town E"] = 1161249370,
    ["Brood Wars Zerg 7 - Town F"] = 1178026586,
    ["Brood Wars Zerg 8 - Town A"] = 1094206042,
    ["Brood Wars Zerg 8 - Town B"] = 1110983258,
    ["Brood Wars Zerg 8 - Town C"] = 1127760474,
    ["Brood Wars Zerg 8 - Town D"] = 1144537690,
    ["Brood Wars Zerg 8 - Town E"] = 1161314906,
    ["Brood Wars Zerg 8 - Town F"] = 1178092122,
    ["Brood Wars Zerg 9 - Town A"] = 1094271578,
    ["Brood Wars Zerg 9 - Town B"] = 1111048794,
    ["Brood Wars Zerg 9 - Town C"] = 1127826010,
    ["Brood Wars Zerg 9 - Town D"] = 1144603226,
    ["Brood Wars Zerg 9 - Town E"] = 1161380442,
    ["Brood Wars Zerg 9 - Town F"] = 1178157658,
    ["Brood Wars Zerg 10 - Town A"] = 1093681754,
    ["Brood Wars Zerg 10 - Town B"] = 1110458970,
    ["Brood Wars Zerg 10 - Town C"] = 1127236186,
    ["Brood Wars Zerg 10 - Town D"] = 1144013402,
    ["Brood Wars Zerg 10 - Town E"] = 1160790618,
    ["Brood Wars Zerg 10 - Town F"] = 1177567834,
}




function ParseConst(d, s)
    local val = d[s]
    if val == nil then
        val = s
    end
    return val
end


function ParseAllyStatus(s)
    return ParseConst(AllyStatusDict, s)
end


function ParseComparison(s)
    return ParseConst(ComparisonDict, s)
end


function ParseModifier(s)
    return ParseConst(ModifierDict, s)
end


function ParseOrder(s)
    return ParseConst(OrderDict, s)
end


function ParsePlayer(s)
    return ParseConst(PlayerDict, s)
end


function ParsePropState(s)
    return ParseConst(PropStateDict, s)
end


function ParseResource(s)
    return ParseConst(ResourceDict, s)
end


function ParseScore(s)
    return ParseConst(ScoreDict, s)
end


function ParseSwitchAction(s)
    return ParseConst(SwitchActionDict, s)
end


function ParseSwitchState(s)
    return ParseConst(SwitchStateDict, s)
end


function ParseAIScript(s)
    return ParseConst(AIScriptDict, s)
end


function ParseCount(s)
    if s == All then
        return 0
    else
        return s
    end
end


-- Auxillary functions.

function EPD(offset)
    return (offset - 0x58A364) / 4
end

function Memory(offset, comparison, number)
	assert(offset % 4 == 0, "[Memory] Offset should be divisible by 4")
    return Deaths(EPD(offset), comparison, number, 0)
end

function SetMemory(offset, modtype, number)
	assert(offset % 4 == 0, "[SetMemory] Offset should be divisible by 4")
    return SetDeaths(EPD(offset), modtype, number, 0)
end

