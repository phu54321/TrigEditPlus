function RegisterVictoryHook(f, priority)
    RegisterActionHook(1, function(acts)
        return f()
    end, priority)
end

function RegisterDefeatHook(f, priority)
    RegisterActionHook(2, function(acts)
        return f()
    end, priority)
end

function RegisterPreserveTriggerHook(f, priority)
    RegisterActionHook(3, function(acts)
        return f()
    end, priority)
end

function RegisterWaitHook(f, priority)
    RegisterActionHook(4, function(acts)
        a1, a2, a3, Time, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(Time)
    end, priority)
end

function RegisterPauseGameHook(f, priority)
    RegisterActionHook(5, function(acts)
        return f()
    end, priority)
end

function RegisterUnpauseGameHook(f, priority)
    RegisterActionHook(6, function(acts)
        return f()
    end, priority)
end

function RegisterTransmissionHook(f, priority)
    RegisterActionHook(7, function(acts)
        Where, Text, WAVName, a1, a2, Time, Unit, acttype, TimeModifier, AlwaysDisplay = acts[1]
        return f(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
    end, priority)
end

function RegisterPlayWAVHook(f, priority)
    RegisterActionHook(8, function(acts)
        a1, a2, WAVName, a3, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(WAVName)
    end, priority)
end

function RegisterDisplayTextHook(f, priority)
    RegisterActionHook(9, function(acts)
        a1, Text, a2, a3, a4, a5, a6, acttype, a8, AlwaysDisplay = acts[1]
        return f(Text, AlwaysDisplay)
    end, priority)
end

function RegisterCenterViewHook(f, priority)
    RegisterActionHook(10, function(acts)
        Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(Where)
    end, priority)
end

function RegisterCreateUnitWithPropertiesHook(f, priority)
    RegisterActionHook(11, function(acts)
        Where, a1, a2, a3, Player, Properties, Unit, acttype, Count, a5 = acts[1]
        return f(Count, Unit, Where, Player, Properties)
    end, priority)
end

function RegisterSetMissionObjectivesHook(f, priority)
    RegisterActionHook(12, function(acts)
        a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(Text)
    end, priority)
end

function RegisterSetSwitchHook(f, priority)
    RegisterActionHook(13, function(acts)
        a1, a2, a3, a4, a5, Switch, a6, acttype, State, a8 = acts[1]
        return f(Switch, State)
    end, priority)
end

function RegisterSetCountdownTimerHook(f, priority)
    RegisterActionHook(14, function(acts)
        a1, a2, a3, Time, a4, a5, a6, acttype, TimeModifier, a8 = acts[1]
        return f(TimeModifier, Time)
    end, priority)
end

function RegisterRunAIScriptHook(f, priority)
    RegisterActionHook(15, function(acts)
        a1, a2, a3, a4, a5, Script, a6, acttype, a8, a9 = acts[1]
        return f(Script)
    end, priority)
end

function RegisterRunAIScriptAtHook(f, priority)
    RegisterActionHook(16, function(acts)
        Where, a1, a2, a3, a4, Script, a5, acttype, a7, a8 = acts[1]
        return f(Script, Where)
    end, priority)
end

function RegisterLeaderBoardControlHook(f, priority)
    RegisterActionHook(17, function(acts)
        a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8 = acts[1]
        return f(Unit, Label)
    end, priority)
end

function RegisterLeaderBoardControlAtHook(f, priority)
    RegisterActionHook(18, function(acts)
        Location, Label, a1, a2, a3, a4, Unit, acttype, a6, a7 = acts[1]
        return f(Unit, Location, Label)
    end, priority)
end

function RegisterLeaderBoardResourcesHook(f, priority)
    RegisterActionHook(19, function(acts)
        a1, Label, a2, a3, a4, a5, ResourceType, acttype, a7, a8 = acts[1]
        return f(ResourceType, Label)
    end, priority)
end

function RegisterLeaderBoardKillsHook(f, priority)
    RegisterActionHook(20, function(acts)
        a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8 = acts[1]
        return f(Unit, Label)
    end, priority)
end

function RegisterLeaderBoardScoreHook(f, priority)
    RegisterActionHook(21, function(acts)
        a1, Label, a2, a3, a4, a5, ScoreType, acttype, a7, a8 = acts[1]
        return f(ScoreType, Label)
    end, priority)
end

function RegisterKillUnitHook(f, priority)
    RegisterActionHook(22, function(acts)
        a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8 = acts[1]
        return f(Unit, Player)
    end, priority)
end

function RegisterKillUnitAtHook(f, priority)
    RegisterActionHook(23, function(acts)
        Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6 = acts[1]
        return f(Count, Unit, Where, ForPlayer)
    end, priority)
end

function RegisterRemoveUnitHook(f, priority)
    RegisterActionHook(24, function(acts)
        a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8 = acts[1]
        return f(Unit, Player)
    end, priority)
end

function RegisterRemoveUnitAtHook(f, priority)
    RegisterActionHook(25, function(acts)
        Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6 = acts[1]
        return f(Count, Unit, Where, ForPlayer)
    end, priority)
end

function RegisterSetResourcesHook(f, priority)
    RegisterActionHook(26, function(acts)
        a1, a2, a3, a4, Player, Amount, ResourceType, acttype, Modifier, a6 = acts[1]
        return f(Player, Modifier, Amount, ResourceType)
    end, priority)
end

function RegisterSetScoreHook(f, priority)
    RegisterActionHook(27, function(acts)
        a1, a2, a3, a4, Player, Amount, ScoreType, acttype, Modifier, a6 = acts[1]
        return f(Player, Modifier, Amount, ScoreType)
    end, priority)
end

function RegisterMinimapPingHook(f, priority)
    RegisterActionHook(28, function(acts)
        Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(Where)
    end, priority)
end

function RegisterTalkingPortraitHook(f, priority)
    RegisterActionHook(29, function(acts)
        a1, a2, a3, Time, a4, a5, Unit, acttype, a7, a8 = acts[1]
        return f(Unit, Time)
    end, priority)
end

function RegisterMuteUnitSpeechHook(f, priority)
    RegisterActionHook(30, function(acts)
        return f()
    end, priority)
end

function RegisterUnMuteUnitSpeechHook(f, priority)
    RegisterActionHook(31, function(acts)
        return f()
    end, priority)
end

function RegisterLeaderBoardComputerPlayersHook(f, priority)
    RegisterActionHook(32, function(acts)
        a1, a2, a3, a4, a5, a6, a7, acttype, State, a9 = acts[1]
        return f(State)
    end, priority)
end

function RegisterLeaderBoardGoalControlHook(f, priority)
    RegisterActionHook(33, function(acts)
        a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7 = acts[1]
        return f(Goal, Unit, Label)
    end, priority)
end

function RegisterLeaderBoardGoalControlAtHook(f, priority)
    RegisterActionHook(34, function(acts)
        Location, Label, a1, a2, a3, Goal, Unit, acttype, a5, a6 = acts[1]
        return f(Goal, Unit, Location, Label)
    end, priority)
end

function RegisterLeaderBoardGoalResourcesHook(f, priority)
    RegisterActionHook(35, function(acts)
        a1, Label, a2, a3, a4, Goal, ResourceType, acttype, a6, a7 = acts[1]
        return f(Goal, ResourceType, Label)
    end, priority)
end

function RegisterLeaderBoardGoalKillsHook(f, priority)
    RegisterActionHook(36, function(acts)
        a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7 = acts[1]
        return f(Goal, Unit, Label)
    end, priority)
end

function RegisterLeaderBoardGoalScoreHook(f, priority)
    RegisterActionHook(37, function(acts)
        a1, Label, a2, a3, a4, Goal, ScoreType, acttype, a6, a7 = acts[1]
        return f(Goal, ScoreType, Label)
    end, priority)
end

function RegisterMoveLocationHook(f, priority)
    RegisterActionHook(38, function(acts)
        DestLocation, a1, a2, a3, Owner, Location, OnUnit, acttype, a5, a6 = acts[1]
        return f(Location, OnUnit, Owner, DestLocation)
    end, priority)
end

function RegisterMoveUnitHook(f, priority)
    RegisterActionHook(39, function(acts)
        StartLocation, a1, a2, a3, Owner, DestLocation, UnitType, acttype, Count, a4 = acts[1]
        return f(Count, UnitType, Owner, StartLocation, DestLocation)
    end, priority)
end

function RegisterLeaderBoardGreedHook(f, priority)
    RegisterActionHook(40, function(acts)
        a1, a2, a3, a4, a5, Goal, a6, acttype, a8, a9 = acts[1]
        return f(Goal)
    end, priority)
end

function RegisterSetNextScenarioHook(f, priority)
    RegisterActionHook(41, function(acts)
        a1, ScenarioName, a2, a3, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(ScenarioName)
    end, priority)
end

function RegisterSetDoodadStateHook(f, priority)
    RegisterActionHook(42, function(acts)
        Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6 = acts[1]
        return f(State, Unit, Owner, Where)
    end, priority)
end

function RegisterSetInvincibilityHook(f, priority)
    RegisterActionHook(43, function(acts)
        Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6 = acts[1]
        return f(State, Unit, Owner, Where)
    end, priority)
end

function RegisterCreateUnitHook(f, priority)
    RegisterActionHook(44, function(acts)
        Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Number, a6 = acts[1]
        return f(Number, Unit, Where, ForPlayer)
    end, priority)
end

function RegisterSetDeathsHook(f, priority)
    RegisterActionHook(45, function(acts)
        a1, a2, a3, a4, Player, Number, Unit, acttype, Modifier, a6 = acts[1]
        return f(Player, Modifier, Number, Unit)
    end, priority)
end

function RegisterOrderHook(f, priority)
    RegisterActionHook(46, function(acts)
        StartLocation, a1, a2, a3, Owner, DestLocation, Unit, acttype, OrderType, a4 = acts[1]
        return f(Unit, Owner, StartLocation, OrderType, DestLocation)
    end, priority)
end

function RegisterCommentHook(f, priority)
    RegisterActionHook(47, function(acts)
        a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9 = acts[1]
        return f(Text)
    end, priority)
end

function RegisterGiveUnitsHook(f, priority)
    RegisterActionHook(48, function(acts)
        Where, a1, a2, a3, Owner, NewOwner, Unit, acttype, Count, a5 = acts[1]
        return f(Count, Unit, Owner, Where, NewOwner)
    end, priority)
end

function RegisterModifyUnitHitPointsHook(f, priority)
    RegisterActionHook(49, function(acts)
        Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 = acts[1]
        return f(Count, Unit, Owner, Where, Percent)
    end, priority)
end

function RegisterModifyUnitEnergyHook(f, priority)
    RegisterActionHook(50, function(acts)
        Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 = acts[1]
        return f(Count, Unit, Owner, Where, Percent)
    end, priority)
end

function RegisterModifyUnitShieldsHook(f, priority)
    RegisterActionHook(51, function(acts)
        Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 = acts[1]
        return f(Count, Unit, Owner, Where, Percent)
    end, priority)
end

function RegisterModifyUnitResourceAmountHook(f, priority)
    RegisterActionHook(52, function(acts)
        Where, a1, a2, a3, Owner, NewValue, a4, acttype, Count, a6 = acts[1]
        return f(Count, Owner, Where, NewValue)
    end, priority)
end

function RegisterModifyUnitHangarCountHook(f, priority)
    RegisterActionHook(53, function(acts)
        Where, a1, a2, a3, Owner, Add, Unit, acttype, Count, a5 = acts[1]
        return f(Add, Count, Unit, Owner, Where)
    end, priority)
end

function RegisterPauseTimerHook(f, priority)
    RegisterActionHook(54, function(acts)
        return f()
    end, priority)
end

function RegisterUnpauseTimerHook(f, priority)
    RegisterActionHook(55, function(acts)
        return f()
    end, priority)
end

function RegisterDrawHook(f, priority)
    RegisterActionHook(56, function(acts)
        return f()
    end, priority)
end

function RegisterSetAllianceStatusHook(f, priority)
    RegisterActionHook(57, function(acts)
        a1, a2, a3, a4, Player, a5, Status, acttype, a7, a8 = acts[1]
        return f(Player, Status)
    end, priority)
end
