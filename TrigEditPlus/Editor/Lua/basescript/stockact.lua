
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

-- Location Text    Wav TotDuration 0   DurationMod UnitType    7   NumericMod  20

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
    Properties = ParseUPRP(Properties)
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


-------

function GetVictoryActionFields(acts) end

function GetDefeatActionFields(acts) end

function GetPreserveTriggerActionFields(acts) end

function GetWaitActionFields(acts)
    local a1, a2, a3, Time, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Time
end

function GetPauseGameActionFields(acts) end

function GetUnpauseGameActionFields(acts) end

function GetTransmissionActionFields(acts)
    local Where, Text, WAVName, a1, a2, Time, Unit, acttype, TimeModifier, AlwaysDisplay =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay
end

function GetPlayWAVActionFields(acts)
    local a1, a2, WAVName, a3, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return WAVName
end

function GetDisplayTextActionFields(acts)
    local a1, Text, a2, a3, a4, a5, a6, acttype, a8, AlwaysDisplay =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Text, AlwaysDisplay
end

function GetCenterViewActionFields(acts)
    local Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Where
end

function GetCreateUnitWithPropertiesActionFields(acts)
    local Where, a1, a2, a3, Player, Properties, Unit, acttype, Count, a5 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Where, Player, Properties
end

function GetSetMissionObjectivesActionFields(acts)
    local a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Text
end

function GetSetSwitchActionFields(acts)
    local a1, a2, a3, a4, a5, Switch, a6, acttype, State, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Switch, State
end

function GetSetCountdownTimerActionFields(acts)
    local a1, a2, a3, Time, a4, a5, a6, acttype, TimeModifier, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return TimeModifier, Time
end

function GetRunAIScriptActionFields(acts)
    local a1, a2, a3, a4, a5, Script, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Script
end

function GetRunAIScriptAtActionFields(acts)
    local Where, a1, a2, a3, a4, Script, a5, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Script, Where
end

function GetLeaderBoardControlActionFields(acts)
    local a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Label
end

function GetLeaderBoardControlAtActionFields(acts)
    local Location, Label, a1, a2, a3, a4, Unit, acttype, a6, a7 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Location, Label
end

function GetLeaderBoardResourcesActionFields(acts)
    local a1, Label, a2, a3, a4, a5, ResourceType, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return ResourceType, Label
end

function GetLeaderBoardKillsActionFields(acts)
    local a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Label
end

function GetLeaderBoardScoreActionFields(acts)
    local a1, Label, a2, a3, a4, a5, ScoreType, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return ScoreType, Label
end

function GetKillUnitActionFields(acts)
    local a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Player
end

function GetKillUnitAtActionFields(acts)
    local Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Where, ForPlayer
end

function GetRemoveUnitActionFields(acts)
    local a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Player
end

function GetRemoveUnitAtActionFields(acts)
    local Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Where, ForPlayer
end

function GetSetResourcesActionFields(acts)
    local a1, a2, a3, a4, Player, Amount, ResourceType, acttype, Modifier, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Player, Modifier, Amount, ResourceType
end

function GetSetScoreActionFields(acts)
    local a1, a2, a3, a4, Player, Amount, ScoreType, acttype, Modifier, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Player, Modifier, Amount, ScoreType
end

function GetMinimapPingActionFields(acts)
    local Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Where
end

function GetTalkingPortraitActionFields(acts)
    local a1, a2, a3, Time, a4, a5, Unit, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Time
end

function GetMuteUnitSpeechActionFields(acts) end

function GetUnMuteUnitSpeechActionFields(acts) end

function GetLeaderBoardComputerPlayersActionFields(acts)
    local a1, a2, a3, a4, a5, a6, a7, acttype, State, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return State
end

function GetLeaderBoardGoalControlActionFields(acts)
    local a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Goal, Unit, Label
end

function GetLeaderBoardGoalControlAtActionFields(acts)
    local Location, Label, a1, a2, a3, Goal, Unit, acttype, a5, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Goal, Unit, Location, Label
end

function GetLeaderBoardGoalResourcesActionFields(acts)
    local a1, Label, a2, a3, a4, Goal, ResourceType, acttype, a6, a7 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Goal, ResourceType, Label
end

function GetLeaderBoardGoalKillsActionFields(acts)
    local a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Goal, Unit, Label
end

function GetLeaderBoardGoalScoreActionFields(acts)
    local a1, Label, a2, a3, a4, Goal, ScoreType, acttype, a6, a7 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Goal, ScoreType, Label
end

function GetMoveLocationActionFields(acts)
    local DestLocation, a1, a2, a3, Owner, Location, OnUnit, acttype, a5, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Location, OnUnit, Owner, DestLocation
end

function GetMoveUnitActionFields(acts)
    local StartLocation, a1, a2, a3, Owner, DestLocation, UnitType, acttype, Count, a4 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, UnitType, Owner, StartLocation, DestLocation
end

function GetLeaderBoardGreedActionFields(acts)
    local a1, a2, a3, a4, a5, Goal, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Goal
end

function GetSetNextScenarioActionFields(acts)
    local a1, ScenarioName, a2, a3, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return ScenarioName
end

function GetSetDoodadStateActionFields(acts)
    local Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return State, Unit, Owner, Where
end

function GetSetInvincibilityActionFields(acts)
    local Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return State, Unit, Owner, Where
end

function GetCreateUnitActionFields(acts)
    local Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Number, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Number, Unit, Where, ForPlayer
end

function GetSetDeathsActionFields(acts)
    local a1, a2, a3, a4, Player, Number, Unit, acttype, Modifier, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Player, Modifier, Number, Unit
end

function GetOrderActionFields(acts)
    local StartLocation, a1, a2, a3, Owner, DestLocation, Unit, acttype, OrderType, a4 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Unit, Owner, StartLocation, OrderType, DestLocation
end

function GetCommentActionFields(acts)
    local a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Text
end

function GetGiveUnitsActionFields(acts)
    local Where, a1, a2, a3, Owner, NewOwner, Unit, acttype, Count, a5 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Owner, Where, NewOwner
end

function GetModifyUnitHitPointsActionFields(acts)
    local Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Owner, Where, Percent
end

function GetModifyUnitEnergyActionFields(acts)
    local Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Owner, Where, Percent
end

function GetModifyUnitShieldsActionFields(acts)
    local Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Unit, Owner, Where, Percent
end

function GetModifyUnitResourceAmountActionFields(acts)
    local Where, a1, a2, a3, Owner, NewValue, a4, acttype, Count, a6 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Count, Owner, Where, NewValue
end

function GetModifyUnitHangarCountActionFields(acts)
    local Where, a1, a2, a3, Owner, Add, Unit, acttype, Count, a5 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Add, Count, Unit, Owner, Where
end

function GetPauseTimerActionFields(acts) end

function GetUnpauseTimerActionFields(acts) end

function GetDrawActionFields(acts) end

function GetSetAllianceStatusActionFields(acts)
    local a1, a2, a3, a4, Player, a5, Status, acttype, a7, a8 =
        acts[0], acts[1], acts[2], acts[3], acts[4], acts[5], acts[6], acts[7], acts[8], acts[9]
    return Player, Status
end
