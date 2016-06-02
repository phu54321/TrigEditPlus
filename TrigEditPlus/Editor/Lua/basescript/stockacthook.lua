function RegisterVictoryHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 1, priority)
end

function RegisterDefeatHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 2, priority)
end

function RegisterPreserveTriggerHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 3, priority)
end

function RegisterWaitHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, a6, acttype, a8, a9)
            return f(Time)
    end, 4, priority)
end

function RegisterPauseGameHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 5, priority)
end

function RegisterUnpauseGameHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 6, priority)
end

function RegisterTransmissionHook(f, priority)
    RegisterActionHook(function(Where, Text, WAVName, a1, a2, Time, Unit, acttype, TimeModifier, AlwaysDisplay)
            return f(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
    end, 7, priority)
end

function RegisterPlayWAVHook(f, priority)
    RegisterActionHook(function(a1, a2, WAVName, a3, a4, a5, a6, acttype, a8, a9)
            return f(WAVName)
    end, 8, priority)
end

function RegisterDisplayTextHook(f, priority)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, AlwaysDisplay)
            return f(Text, AlwaysDisplay)
    end, 9, priority)
end

function RegisterCenterViewHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9)
            return f(Where)
    end, 10, priority)
end

function RegisterCreateUnitWithPropertiesHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Player, Properties, Unit, acttype, Count, a5)
            return f(Count, Unit, Where, Player, Properties)
    end, 11, priority)
end

function RegisterSetMissionObjectivesHook(f, priority)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9)
            return f(Text)
    end, 12, priority)
end

function RegisterSetSwitchHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Switch, a6, acttype, State, a8)
            return f(Switch, State)
    end, 13, priority)
end

function RegisterSetCountdownTimerHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, a6, acttype, TimeModifier, a8)
            return f(TimeModifier, Time)
    end, 14, priority)
end

function RegisterRunAIScriptHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Script, a6, acttype, a8, a9)
            return f(Script)
    end, 15, priority)
end

function RegisterRunAIScriptAtHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, a4, Script, a5, acttype, a7, a8)
            return f(Script, Where)
    end, 16, priority)
end

function RegisterLeaderBoardControlHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8)
            return f(Unit, Label)
    end, 17, priority)
end

function RegisterLeaderBoardControlAtHook(f, priority)
    RegisterActionHook(function(Location, Label, a1, a2, a3, a4, Unit, acttype, a6, a7)
            return f(Unit, Location, Label)
    end, 18, priority)
end

function RegisterLeaderBoardResourcesHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, ResourceType, acttype, a7, a8)
            return f(ResourceType, Label)
    end, 19, priority)
end

function RegisterLeaderBoardKillsHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8)
            return f(Unit, Label)
    end, 20, priority)
end

function RegisterLeaderBoardScoreHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, ScoreType, acttype, a7, a8)
            return f(ScoreType, Label)
    end, 21, priority)
end

function RegisterKillUnitHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8)
            return f(Unit, Player)
    end, 22, priority)
end

function RegisterKillUnitAtHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6)
            return f(Count, Unit, Where, ForPlayer)
    end, 23, priority)
end

function RegisterRemoveUnitHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8)
            return f(Unit, Player)
    end, 24, priority)
end

function RegisterRemoveUnitAtHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6)
            return f(Count, Unit, Where, ForPlayer)
    end, 25, priority)
end

function RegisterSetResourcesHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Amount, ResourceType, acttype, Modifier, a6)
            return f(Player, Modifier, Amount, ResourceType)
    end, 26, priority)
end

function RegisterSetScoreHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Amount, ScoreType, acttype, Modifier, a6)
            return f(Player, Modifier, Amount, ScoreType)
    end, 27, priority)
end

function RegisterMinimapPingHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9)
            return f(Where)
    end, 28, priority)
end

function RegisterTalkingPortraitHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, Unit, acttype, a7, a8)
            return f(Unit, Time)
    end, 29, priority)
end

function RegisterMuteUnitSpeechHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 30, priority)
end

function RegisterUnMuteUnitSpeechHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 31, priority)
end

function RegisterLeaderBoardComputerPlayersHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, State, a9)
            return f(State)
    end, 32, priority)
end

function RegisterLeaderBoardGoalControlHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7)
            return f(Goal, Unit, Label)
    end, 33, priority)
end

function RegisterLeaderBoardGoalControlAtHook(f, priority)
    RegisterActionHook(function(Location, Label, a1, a2, a3, Goal, Unit, acttype, a5, a6)
            return f(Goal, Unit, Location, Label)
    end, 34, priority)
end

function RegisterLeaderBoardGoalResourcesHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, ResourceType, acttype, a6, a7)
            return f(Goal, ResourceType, Label)
    end, 35, priority)
end

function RegisterLeaderBoardGoalKillsHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7)
            return f(Goal, Unit, Label)
    end, 36, priority)
end

function RegisterLeaderBoardGoalScoreHook(f, priority)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, ScoreType, acttype, a6, a7)
            return f(Goal, ScoreType, Label)
    end, 37, priority)
end

function RegisterMoveLocationHook(f, priority)
    RegisterActionHook(function(DestLocation, a1, a2, a3, Owner, Location, OnUnit, acttype, a5, a6)
            return f(Location, OnUnit, Owner, DestLocation)
    end, 38, priority)
end

function RegisterMoveUnitHook(f, priority)
    RegisterActionHook(function(StartLocation, a1, a2, a3, Owner, DestLocation, UnitType, acttype, Count, a4)
            return f(Count, UnitType, Owner, StartLocation, DestLocation)
    end, 39, priority)
end

function RegisterLeaderBoardGreedHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Goal, a6, acttype, a8, a9)
            return f(Goal)
    end, 40, priority)
end

function RegisterSetNextScenarioHook(f, priority)
    RegisterActionHook(function(a1, ScenarioName, a2, a3, a4, a5, a6, acttype, a8, a9)
            return f(ScenarioName)
    end, 41, priority)
end

function RegisterSetDoodadStateHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6)
            return f(State, Unit, Owner, Where)
    end, 42, priority)
end

function RegisterSetInvincibilityHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6)
            return f(State, Unit, Owner, Where)
    end, 43, priority)
end

function RegisterCreateUnitHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Number, a6)
            return f(Number, Unit, Where, ForPlayer)
    end, 44, priority)
end

function RegisterSetDeathsHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Number, Unit, acttype, Modifier, a6)
            return f(Player, Modifier, Number, Unit)
    end, 45, priority)
end

function RegisterOrderHook(f, priority)
    RegisterActionHook(function(StartLocation, a1, a2, a3, Owner, DestLocation, Unit, acttype, OrderType, a4)
            return f(Unit, Owner, StartLocation, OrderType, DestLocation)
    end, 46, priority)
end

function RegisterCommentHook(f, priority)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9)
            return f(Text)
    end, 47, priority)
end

function RegisterGiveUnitsHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, NewOwner, Unit, acttype, Count, a5)
            return f(Count, Unit, Owner, Where, NewOwner)
    end, 48, priority)
end

function RegisterModifyUnitHitPointsHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
            return f(Count, Unit, Owner, Where, Percent)
    end, 49, priority)
end

function RegisterModifyUnitEnergyHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
            return f(Count, Unit, Owner, Where, Percent)
    end, 50, priority)
end

function RegisterModifyUnitShieldsHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
            return f(Count, Unit, Owner, Where, Percent)
    end, 51, priority)
end

function RegisterModifyUnitResourceAmountHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, NewValue, a4, acttype, Count, a6)
            return f(Count, Owner, Where, NewValue)
    end, 52, priority)
end

function RegisterModifyUnitHangarCountHook(f, priority)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Add, Unit, acttype, Count, a5)
            return f(Add, Count, Unit, Owner, Where)
    end, 53, priority)
end

function RegisterPauseTimerHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 54, priority)
end

function RegisterUnpauseTimerHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 55, priority)
end

function RegisterDrawHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
            return f()
    end, 56, priority)
end

function RegisterSetAllianceStatusHook(f, priority)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Status, acttype, a7, a8)
            return f(Player, Status)
    end, 57, priority)
end
