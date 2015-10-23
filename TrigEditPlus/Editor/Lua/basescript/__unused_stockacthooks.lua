
RegisterVictoryHook(1, function()
    return "Victory();"
end, -9999999999)


RegisterDefeatHook(2, function()
    return "Defeat();"
end, -9999999999)


RegisterPreserveTriggerHook(3, function()
    return "PreserveTrigger();"
end, -9999999999)


RegisterWaitHook(4, function(Time)
    return "Wait(" .. Time.. ");"
end, -9999999999)


RegisterPauseGameHook(5, function()
    return "PauseGame();"
end, -9999999999)


RegisterUnpauseGameHook(6, function()
    return "UnpauseGame();"
end, -9999999999)


RegisterTransmissionHook(7, function(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
    Unit = EncodeUnit(Unit)
    Where = EncodeLocation(Where)
    WAVName = EncodeString(WAVName)
    TimeModifier = EncodeModifier(TimeModifier)
    Text = EncodeString(Text)
    return "Transmission(" .. Unit .. ", " .. Where .. ", " .. WAVName .. ", " .. TimeModifier .. ", " .. Time .. ", " .. Text .. ", " .. AlwaysDisplay.. ");"
end, -9999999999)

RegisterPlayWAVHook(8, function(WAVName)
    WAVName = EncodeString(WAVName)
    return "PlayWAV(" .. WAVName.. ");"
end, -9999999999)


RegisterDisplayTextHook(9, function(Text, AlwaysDisplay)
    Text = EncodeString(Text)
    return "DisplayText(" .. Text .. ", " .. AlwaysDisplay.. ");"
end, -9999999999)


RegisterCenterViewHook(10, function(Where)
    Where = EncodeLocation(Where)
    return "CenterView(" .. Where.. ");"
end, -9999999999)


RegisterCreateUnitWithPropertiesHook(11, function(Count, Unit, Where, Player, Properties)
    Unit = EncodeUnit(Unit)
    Where = EncodeLocation(Where)
    Player = EncodePlayer(Player)
    Properties = EncodeUPRP(Properties)
    return "CreateUnitWithProperties(" .. Count .. ", " .. Unit .. ", " .. Where .. ", " .. Player .. ", " .. Properties.. ");"
end, -9999999999)


RegisterSetMissionObjectivesHook(12, function(Text)
    Text = EncodeString(Text)
    return "SetMissionObjectives(" .. Text.. ");"
end, -9999999999)


RegisterSetSwitchHook(13, function(Switch, State)
    Switch = EncodeSwitchName(Switch)
    State = EncodeSwitchAction(State)
    return "SetSwitch(" .. Switch .. ", " .. State.. ");"
end, -9999999999)


RegisterSetCountdownTimerHook(14, function(TimeModifier, Time)
    TimeModifier = EncodeModifier(TimeModifier)
    return "SetCountdownTimer(" .. TimeModifier .. ", " .. Time.. ");"
end, -9999999999)


RegisterRunAIScriptHook(15, function(Script)
    Script = EncodeAIScript(Script)
    return "RunAIScript(" .. Script.. ");"
end, -9999999999)


RegisterRunAIScriptAtHook(16, function(Script, Where)
    Script = EncodeAIScript(Script)
    Where = EncodeLocation(Where)
    return "RunAIScriptAt(" .. Script .. ", " .. Where.. ");"
end, -9999999999)


RegisterLeaderBoardControlHook(17, function(Unit, Label)
    Unit = EncodeUnit(Unit)
    Label = EncodeString(Label)
    return "LeaderBoardControl(" .. Unit .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardControlAtHook(18, function(Unit, Location, Label)
    Unit = EncodeUnit(Unit)
    Location = EncodeLocation(Location)
    Label = EncodeString(Label)
    return "LeaderBoardControlAt(" .. Unit .. ", " .. Location .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardResourcesHook(19, function(ResourceType, Label)
    ResourceType = EncodeResource(ResourceType)
    Label = EncodeString(Label)
    return "LeaderBoardResources(" .. ResourceType .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardKillsHook(20, function(Unit, Label)
    Unit = EncodeUnit(Unit)
    Label = EncodeString(Label)
    return "LeaderBoardKills(" .. Unit .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardScoreHook(21, function(ScoreType, Label)
    ScoreType = EncodeScore(ScoreType)
    Label = EncodeString(Label)
    return "LeaderBoardScore(" .. ScoreType .. ", " .. Label.. ");"
end, -9999999999)


RegisterKillUnitHook(22, function(Unit, Player)
    Unit = EncodeUnit(Unit)
    Player = EncodePlayer(Player)
    return "KillUnit(" .. Unit .. ", " .. Player.. ");"
end, -9999999999)


RegisterKillUnitAtHook(23, function(Count, Unit, Where, ForPlayer)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Where = EncodeLocation(Where)
    ForPlayer = EncodePlayer(ForPlayer)
    return "KillUnitAt(" .. Count .. ", " .. Unit .. ", " .. Where .. ", " .. ForPlayer.. ");"
end, -9999999999)


RegisterRemoveUnitHook(24, function(Unit, Player)
    Unit = EncodeUnit(Unit)
    Player = EncodePlayer(Player)
    return "RemoveUnit(" .. Unit .. ", " .. Player.. ");"
end, -9999999999)


RegisterRemoveUnitAtHook(25, function(Count, Unit, Where, ForPlayer)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Where = EncodeLocation(Where)
    ForPlayer = EncodePlayer(ForPlayer)
    return "RemoveUnitAt(" .. Count .. ", " .. Unit .. ", " .. Where .. ", " .. ForPlayer.. ");"
end, -9999999999)


RegisterSetResourcesHook(26, function(Player, Modifier, Amount, ResourceType)
    Player = EncodePlayer(Player)
    Modifier = EncodeModifier(Modifier)
    ResourceType = EncodeResource(ResourceType)
    return "SetResources(" .. Player .. ", " .. Modifier .. ", " .. Amount .. ", " .. ResourceType.. ");"
end, -9999999999)


RegisterSetScoreHook(27, function(Player, Modifier, Amount, ScoreType)
    Player = EncodePlayer(Player)
    Modifier = EncodeModifier(Modifier)
    ScoreType = EncodeScore(ScoreType)
    return "SetScore(" .. Player .. ", " .. Modifier .. ", " .. Amount .. ", " .. ScoreType.. ");"
end, -9999999999)


RegisterMinimapPingHook(28, function(Where)
    Where = EncodeLocation(Where)
    return "MinimapPing(" .. Where.. ");"
end, -9999999999)


RegisterTalkingPortraitHook(29, function(Unit, Time)
    Unit = EncodeUnit(Unit)
    return "TalkingPortrait(" .. Unit .. ", " .. Time.. ");"
end, -9999999999)


RegisterMuteUnitSpeechHook(30, function()
    return "MuteUnitSpeech();"
end, -9999999999)


RegisterUnMuteUnitSpeechHook(31, function()
    return "UnMuteUnitSpeech();"
end, -9999999999)


RegisterLeaderBoardComputerPlayersHook(32, function(State)
    State = EncodePropState(State)
    return "LeaderBoardComputerPlayers(" .. State.. ");"
end, -9999999999)


RegisterLeaderBoardGoalControlHook(33, function(Goal, Unit, Label)
    Unit = EncodeUnit(Unit)
    Label = EncodeString(Label)
    return "LeaderBoardGoalControl(" .. Goal .. ", " .. Unit .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardGoalControlAtHook(34, function(Goal, Unit, Location, Label)
    Unit = EncodeUnit(Unit)
    Location = EncodeLocation(Location)
    Label = EncodeString(Label)
    return "LeaderBoardGoalControlAt(" .. Goal .. ", " .. Unit .. ", " .. Location .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardGoalResourcesHook(35, function(Goal, ResourceType, Label)
    ResourceType = EncodeResource(ResourceType)
    Label = EncodeString(Label)
    return "LeaderBoardGoalResources(" .. Goal .. ", " .. ResourceType .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardGoalKillsHook(36, function(Goal, Unit, Label)
    Unit = EncodeUnit(Unit)
    Label = EncodeString(Label)
    return "LeaderBoardGoalKills(" .. Goal .. ", " .. Unit .. ", " .. Label.. ");"
end, -9999999999)


RegisterLeaderBoardGoalScoreHook(37, function(Goal, ScoreType, Label)
    ScoreType = EncodeScore(ScoreType)
    Label = EncodeString(Label)
    return "LeaderBoardGoalScore(" .. Goal .. ", " .. ScoreType .. ", " .. Label.. ");"
end, -9999999999)


RegisterMoveLocationHook(38, function(Location, OnUnit, Owner, DestLocation)
    Location = EncodeLocation(Location)
    OnUnit = EncodeUnit(OnUnit)
    Owner = EncodePlayer(Owner)
    DestLocation = EncodeLocation(DestLocation)
    return "MoveLocation(" .. Location .. ", " .. OnUnit .. ", " .. Owner .. ", " .. DestLocation.. ");"
end, -9999999999)


RegisterMoveUnitHook(39, function(Count, UnitType, Owner, StartLocation, DestLocation)
    Count = EncodeCount(Count)
    UnitType = EncodeUnit(UnitType)
    Owner = EncodePlayer(Owner)
    StartLocation = EncodeLocation(StartLocation)
    DestLocation = EncodeLocation(DestLocation)
    return "MoveUnit(" .. Count .. ", " .. UnitType .. ", " .. Owner .. ", " .. StartLocation .. ", " .. DestLocation.. ");"
                  UnitType, 39, Count, 20)
end, -9999999999)


RegisterLeaderBoardGreedHook(40, function(Goal)
    return "LeaderBoardGreed(" .. Goal.. ");"
end, -9999999999)


RegisterSetNextScenarioHook(41, function(ScenarioName)
    ScenarioName = EncodeString(ScenarioName)
    return "SetNextScenario(" .. ScenarioName.. ");"
end, -9999999999)


RegisterSetDoodadStateHook(42, function(State, Unit, Owner, Where)
    State = EncodePropState(State)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "SetDoodadState(" .. State .. ", " .. Unit .. ", " .. Owner .. ", " .. Where.. ");"
end, -9999999999)


RegisterSetInvincibilityHook(43, function(State, Unit, Owner, Where)
    State = EncodePropState(State)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "SetInvincibility(" .. State .. ", " .. Unit .. ", " .. Owner .. ", " .. Where.. ");"
end, -9999999999)


RegisterCreateUnitHook(44, function(Number, Unit, Where, ForPlayer)
    Unit = EncodeUnit(Unit)
    Where = EncodeLocation(Where)
    ForPlayer = EncodePlayer(ForPlayer)
    return "CreateUnit(" .. Number .. ", " .. Unit .. ", " .. Where .. ", " .. ForPlayer.. ");"
end, -9999999999)


RegisterSetDeathsHook(45, function(Player, Modifier, Number, Unit)
    Player = EncodePlayer(Player)
    Modifier = EncodeModifier(Modifier)
    Unit = EncodeUnit(Unit)
    return "SetDeaths(" .. Player .. ", " .. Modifier .. ", " .. Number .. ", " .. Unit.. ");"
end, -9999999999)


RegisterOrderHook(46, function(Unit, Owner, StartLocation, OrderType, DestLocation)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    StartLocation = EncodeLocation(StartLocation)
    OrderType = EncodeOrder(OrderType)
    DestLocation = EncodeLocation(DestLocation)
    return "Order(" .. Unit .. ", " .. Owner .. ", " .. StartLocation .. ", " .. OrderType .. ", " .. DestLocation.. ");"
                  Unit, 46, OrderType, 20)
end, -9999999999)


RegisterCommentHook(47, function(Text)
    Text = EncodeString(Text)
    return "Comment(" .. Text.. ");"
end, -9999999999)


RegisterGiveUnitsHook(48, function(Count, Unit, Owner, Where, NewOwner)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    NewOwner = EncodePlayer(NewOwner)
    return "GiveUnits(" .. Count .. ", " .. Unit .. ", " .. Owner .. ", " .. Where .. ", " .. NewOwner.. ");"
end, -9999999999)


RegisterModifyUnitHitPointsHook(49, function(Count, Unit, Owner, Where, Percent)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "ModifyUnitHitPoints(" .. Count .. ", " .. Unit .. ", " .. Owner .. ", " .. Where .. ", " .. Percent.. ");"
end, -9999999999)


RegisterModifyUnitEnergyHook(50, function(Count, Unit, Owner, Where, Percent)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "ModifyUnitEnergy(" .. Count .. ", " .. Unit .. ", " .. Owner .. ", " .. Where .. ", " .. Percent.. ");"
end, -9999999999)


RegisterModifyUnitShieldsHook(51, function(Count, Unit, Owner, Where, Percent)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "ModifyUnitShields(" .. Count .. ", " .. Unit .. ", " .. Owner .. ", " .. Where .. ", " .. Percent.. ");"
end, -9999999999)


RegisterModifyUnitResourceAmountHook(52, function(Count, Owner, Where, NewValue)
    Count = EncodeCount(Count)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "ModifyUnitResourceAmount(" .. Count .. ", " .. Owner .. ", " .. Where .. ", " .. NewValue.. ");"
end, -9999999999)


RegisterModifyUnitHangarCountHook(53, function(Add, Count, Unit, Owner, Where)
    Count = EncodeCount(Count)
    Unit = EncodeUnit(Unit)
    Owner = EncodePlayer(Owner)
    Where = EncodeLocation(Where)
    return "ModifyUnitHangarCount(" .. Add .. ", " .. Count .. ", " .. Unit .. ", " .. Owner .. ", " .. Where.. ");"
end, -9999999999)


RegisterPauseTimerHook(54, function()
    return "PauseTimer();"
end, -9999999999)


RegisterUnpauseTimerHook(55, function()
    return "UnpauseTimer();"
end, -9999999999)


RegisterDrawHook(56, function()
    return "Draw();"
end, -9999999999)


RegisterSetAllianceStatusHook(57, function(Player, Status)
    Player = EncodePlayer(Player)
    Status = EncodeAllyStatus(Status)
    return "SetAllianceStatus(" .. Player .. ", " .. Status.. ");"
end, -9999999999)