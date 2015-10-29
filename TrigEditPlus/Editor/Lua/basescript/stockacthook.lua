function RegisterVictoryHook(f, priority)
    RegisterActionHook(1, function(action)
        return f()
    end, priority)
end

function RegisterDefeatHook(f, priority)
    RegisterActionHook(2, function(action)
        return f()
    end, priority)
end

function RegisterPreserveTriggerHook(f, priority)
    RegisterActionHook(3, function(action)
        return f()
    end, priority)
end

function RegisterWaitHook(f, priority)
    RegisterActionHook(4, function(action)
        a1, a2, a3, Time, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(Time)
    end, priority)
end

function RegisterPauseGameHook(f, priority)
    RegisterActionHook(5, function(action)
        return f()
    end, priority)
end

function RegisterUnpauseGameHook(f, priority)
    RegisterActionHook(6, function(action)
        return f()
    end, priority)
end

function RegisterTransmissionHook(f, priority)
    RegisterActionHook(7, function(action)
        Where, Text, WAVName, a1, a2, Time, Unit, acttype, TimeModifier, AlwaysDisplay = unpack(action)
        return f(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
    end, priority)
end

function RegisterPlayWAVHook(f, priority)
    RegisterActionHook(8, function(action)
        a1, a2, WAVName, a3, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(WAVName)
    end, priority)
end

function RegisterDisplayTextHook(f, priority)
    RegisterActionHook(9, function(action)
        a1, Text, a2, a3, a4, a5, a6, acttype, a8, AlwaysDisplay = unpack(action)
        return f(Text, AlwaysDisplay)
    end, priority)
end

function RegisterCenterViewHook(f, priority)
    RegisterActionHook(10, function(action)
        Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(Where)
    end, priority)
end

function RegisterCreateUnitWithPropertiesHook(f, priority)
    RegisterActionHook(11, function(action)
        Where, a1, a2, a3, Player, Properties, Unit, acttype, Count, a5 = unpack(action)
        return f(Count, Unit, Where, Player, Properties)
    end, priority)
end

function RegisterSetMissionObjectivesHook(f, priority)
    RegisterActionHook(12, function(action)
        a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(Text)
    end, priority)
end

function RegisterSetSwitchHook(f, priority)
    RegisterActionHook(13, function(action)
        a1, a2, a3, a4, a5, Switch, a6, acttype, State, a8 = unpack(action)
        return f(Switch, State)
    end, priority)
end

function RegisterSetCountdownTimerHook(f, priority)
    RegisterActionHook(14, function(action)
        a1, a2, a3, Time, a4, a5, a6, acttype, TimeModifier, a8 = unpack(action)
        return f(TimeModifier, Time)
    end, priority)
end

function RegisterRunAIScriptHook(f, priority)
    RegisterActionHook(15, function(action)
        a1, a2, a3, a4, a5, Script, a6, acttype, a8, a9 = unpack(action)
        return f(Script)
    end, priority)
end

function RegisterRunAIScriptAtHook(f, priority)
    RegisterActionHook(16, function(action)
        Where, a1, a2, a3, a4, Script, a5, acttype, a7, a8 = unpack(action)
        return f(Script, Where)
    end, priority)
end

function RegisterLeaderBoardControlHook(f, priority)
    RegisterActionHook(17, function(action)
        a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8 = unpack(action)
        return f(Unit, Label)
    end, priority)
end

function RegisterLeaderBoardControlAtHook(f, priority)
    RegisterActionHook(18, function(action)
        Location, Label, a1, a2, a3, a4, Unit, acttype, a6, a7 = unpack(action)
        return f(Unit, Location, Label)
    end, priority)
end

function RegisterLeaderBoardResourcesHook(f, priority)
    RegisterActionHook(19, function(action)
        a1, Label, a2, a3, a4, a5, ResourceType, acttype, a7, a8 = unpack(action)
        return f(ResourceType, Label)
    end, priority)
end

function RegisterLeaderBoardKillsHook(f, priority)
    RegisterActionHook(20, function(action)
        a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8 = unpack(action)
        return f(Unit, Label)
    end, priority)
end

function RegisterLeaderBoardScoreHook(f, priority)
    RegisterActionHook(21, function(action)
        a1, Label, a2, a3, a4, a5, ScoreType, acttype, a7, a8 = unpack(action)
        return f(ScoreType, Label)
    end, priority)
end

function RegisterKillUnitHook(f, priority)
    RegisterActionHook(22, function(action)
        a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8 = unpack(action)
        return f(Unit, Player)
    end, priority)
end

function RegisterKillUnitAtHook(f, priority)
    RegisterActionHook(23, function(action)
        Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6 = unpack(action)
        return f(Count, Unit, Where, ForPlayer)
    end, priority)
end

function RegisterRemoveUnitHook(f, priority)
    RegisterActionHook(24, function(action)
        a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8 = unpack(action)
        return f(Unit, Player)
    end, priority)
end

function RegisterRemoveUnitAtHook(f, priority)
    RegisterActionHook(25, function(action)
        Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6 = unpack(action)
        return f(Count, Unit, Where, ForPlayer)
    end, priority)
end

function RegisterSetResourcesHook(f, priority)
    RegisterActionHook(26, function(action)
        a1, a2, a3, a4, Player, Amount, ResourceType, acttype, Modifier, a6 = unpack(action)
        return f(Player, Modifier, Amount, ResourceType)
    end, priority)
end

function RegisterSetScoreHook(f, priority)
    RegisterActionHook(27, function(action)
        a1, a2, a3, a4, Player, Amount, ScoreType, acttype, Modifier, a6 = unpack(action)
        return f(Player, Modifier, Amount, ScoreType)
    end, priority)
end

function RegisterMinimapPingHook(f, priority)
    RegisterActionHook(28, function(action)
        Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(Where)
    end, priority)
end

function RegisterTalkingPortraitHook(f, priority)
    RegisterActionHook(29, function(action)
        a1, a2, a3, Time, a4, a5, Unit, acttype, a7, a8 = unpack(action)
        return f(Unit, Time)
    end, priority)
end

function RegisterMuteUnitSpeechHook(f, priority)
    RegisterActionHook(30, function(action)
        return f()
    end, priority)
end

function RegisterUnMuteUnitSpeechHook(f, priority)
    RegisterActionHook(31, function(action)
        return f()
    end, priority)
end

function RegisterLeaderBoardComputerPlayersHook(f, priority)
    RegisterActionHook(32, function(action)
        a1, a2, a3, a4, a5, a6, a7, acttype, State, a9 = unpack(action)
        return f(State)
    end, priority)
end

function RegisterLeaderBoardGoalControlHook(f, priority)
    RegisterActionHook(33, function(action)
        a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7 = unpack(action)
        return f(Goal, Unit, Label)
    end, priority)
end

function RegisterLeaderBoardGoalControlAtHook(f, priority)
    RegisterActionHook(34, function(action)
        Location, Label, a1, a2, a3, Goal, Unit, acttype, a5, a6 = unpack(action)
        return f(Goal, Unit, Location, Label)
    end, priority)
end

function RegisterLeaderBoardGoalResourcesHook(f, priority)
    RegisterActionHook(35, function(action)
        a1, Label, a2, a3, a4, Goal, ResourceType, acttype, a6, a7 = unpack(action)
        return f(Goal, ResourceType, Label)
    end, priority)
end

function RegisterLeaderBoardGoalKillsHook(f, priority)
    RegisterActionHook(36, function(action)
        a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7 = unpack(action)
        return f(Goal, Unit, Label)
    end, priority)
end

function RegisterLeaderBoardGoalScoreHook(f, priority)
    RegisterActionHook(37, function(action)
        a1, Label, a2, a3, a4, Goal, ScoreType, acttype, a6, a7 = unpack(action)
        return f(Goal, ScoreType, Label)
    end, priority)
end

function RegisterMoveLocationHook(f, priority)
    RegisterActionHook(38, function(action)
        DestLocation, a1, a2, a3, Owner, Location, OnUnit, acttype, a5, a6 = unpack(action)
        return f(Location, OnUnit, Owner, DestLocation)
    end, priority)
end

function RegisterMoveUnitHook(f, priority)
    RegisterActionHook(39, function(action)
        StartLocation, a1, a2, a3, Owner, DestLocation, UnitType, acttype, Count, a4 = unpack(action)
        return f(Count, UnitType, Owner, StartLocation, DestLocation)
    end, priority)
end

function RegisterLeaderBoardGreedHook(f, priority)
    RegisterActionHook(40, function(action)
        a1, a2, a3, a4, a5, Goal, a6, acttype, a8, a9 = unpack(action)
        return f(Goal)
    end, priority)
end

function RegisterSetNextScenarioHook(f, priority)
    RegisterActionHook(41, function(action)
        a1, ScenarioName, a2, a3, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(ScenarioName)
    end, priority)
end

function RegisterSetDoodadStateHook(f, priority)
    RegisterActionHook(42, function(action)
        Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6 = unpack(action)
        return f(State, Unit, Owner, Where)
    end, priority)
end

function RegisterSetInvincibilityHook(f, priority)
    RegisterActionHook(43, function(action)
        Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6 = unpack(action)
        return f(State, Unit, Owner, Where)
    end, priority)
end

function RegisterCreateUnitHook(f, priority)
    RegisterActionHook(44, function(action)
        Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Number, a6 = unpack(action)
        return f(Number, Unit, Where, ForPlayer)
    end, priority)
end

function RegisterSetDeathsHook(f, priority)
    RegisterActionHook(45, function(action)
        a1, a2, a3, a4, Player, Number, Unit, acttype, Modifier, a6 = unpack(action)
        return f(Player, Modifier, Number, Unit)
    end, priority)
end

function RegisterOrderHook(f, priority)
    RegisterActionHook(46, function(action)
        StartLocation, a1, a2, a3, Owner, DestLocation, Unit, acttype, OrderType, a4 = unpack(action)
        return f(Unit, Owner, StartLocation, OrderType, DestLocation)
    end, priority)
end

function RegisterCommentHook(f, priority)
    RegisterActionHook(47, function(action)
        a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9 = unpack(action)
        return f(Text)
    end, priority)
end

function RegisterGiveUnitsHook(f, priority)
    RegisterActionHook(48, function(action)
        Where, a1, a2, a3, Owner, NewOwner, Unit, acttype, Count, a5 = unpack(action)
        return f(Count, Unit, Owner, Where, NewOwner)
    end, priority)
end

function RegisterModifyUnitHitPointsHook(f, priority)
    RegisterActionHook(49, function(action)
        Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 = unpack(action)
        return f(Count, Unit, Owner, Where, Percent)
    end, priority)
end

function RegisterModifyUnitEnergyHook(f, priority)
    RegisterActionHook(50, function(action)
        Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 = unpack(action)
        return f(Count, Unit, Owner, Where, Percent)
    end, priority)
end

function RegisterModifyUnitShieldsHook(f, priority)
    RegisterActionHook(51, function(action)
        Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5 = unpack(action)
        return f(Count, Unit, Owner, Where, Percent)
    end, priority)
end

function RegisterModifyUnitResourceAmountHook(f, priority)
    RegisterActionHook(52, function(action)
        Where, a1, a2, a3, Owner, NewValue, a4, acttype, Count, a6 = unpack(action)
        return f(Count, Owner, Where, NewValue)
    end, priority)
end

function RegisterModifyUnitHangarCountHook(f, priority)
    RegisterActionHook(53, function(action)
        Where, a1, a2, a3, Owner, Add, Unit, acttype, Count, a5 = unpack(action)
        return f(Add, Count, Unit, Owner, Where)
    end, priority)
end

function RegisterPauseTimerHook(f, priority)
    RegisterActionHook(54, function(action)
        return f()
    end, priority)
end

function RegisterUnpauseTimerHook(f, priority)
    RegisterActionHook(55, function(action)
        return f()
    end, priority)
end

function RegisterDrawHook(f, priority)
    RegisterActionHook(56, function(action)
        return f()
    end, priority)
end

function RegisterSetAllianceStatusHook(f, priority)
    RegisterActionHook(57, function(action)
        a1, a2, a3, a4, Player, a5, Status, acttype, a7, a8 = unpack(action)
        return f(Player, Status)
    end, priority)
end
