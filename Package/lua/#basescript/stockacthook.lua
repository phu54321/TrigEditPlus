function RegisterVictoryHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 1 then
            return f()
        end
    end)
end

function RegisterDefeatHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 2 then
            return f()
        end
    end)
end

function RegisterPreserveTriggerHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 3 then
            return f()
        end
    end)
end

function RegisterWaitHook(f)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, a6, acttype, a8, a9)
        if acttype == 4 then
            return f(Time)
        end
    end)
end

function RegisterPauseGameHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 5 then
            return f()
        end
    end)
end

function RegisterUnpauseGameHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 6 then
            return f()
        end
    end)
end

function RegisterTransmissionHook(f)
    RegisterActionHook(function(Where, Text, WAVName, a1, a2, Time, Unit, acttype, TimeModifier, AlwaysDisplay)
        if acttype == 7 then
            return f(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
        end
    end)
end

function RegisterPlayWAVHook(f)
    RegisterActionHook(function(a1, a2, WAVName, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 8 then
            return f(WAVName)
        end
    end)
end

function RegisterDisplayTextHook(f)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, AlwaysDisplay)
        if acttype == 9 then
            return f(Text, AlwaysDisplay)
        end
    end)
end

function RegisterCenterViewHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 10 then
            return f(Where)
        end
    end)
end

function RegisterCreateUnitWithPropertiesHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Player, Properties, Unit, acttype, Count, a5)
        if acttype == 11 then
            return f(Count, Unit, Where, Player, Properties)
        end
    end)
end

function RegisterSetMissionObjectivesHook(f)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 12 then
            return f(Text)
        end
    end)
end

function RegisterSetSwitchHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Switch, a6, acttype, State, a8)
        if acttype == 13 then
            return f(Switch, State)
        end
    end)
end

function RegisterSetCountdownTimerHook(f)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, a6, acttype, TimeModifier, a8)
        if acttype == 14 then
            return f(TimeModifier, Time)
        end
    end)
end

function RegisterRunAIScriptHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Script, a6, acttype, a8, a9)
        if acttype == 15 then
            return f(Script)
        end
    end)
end

function RegisterRunAIScriptAtHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, a4, Script, a5, acttype, a7, a8)
        if acttype == 16 then
            return f(Script, Where)
        end
    end)
end

function RegisterLeaderBoardControlHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8)
        if acttype == 17 then
            return f(Unit, Label)
        end
    end)
end

function RegisterLeaderBoardControlAtHook(f)
    RegisterActionHook(function(Location, Label, a1, a2, a3, a4, Unit, acttype, a6, a7)
        if acttype == 18 then
            return f(Unit, Location, Label)
        end
    end)
end

function RegisterLeaderBoardResourcesHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, ResourceType, acttype, a7, a8)
        if acttype == 19 then
            return f(ResourceType, Label)
        end
    end)
end

function RegisterLeaderBoardKillsHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8)
        if acttype == 20 then
            return f(Unit, Label)
        end
    end)
end

function RegisterLeaderBoardScoreHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, ScoreType, acttype, a7, a8)
        if acttype == 21 then
            return f(ScoreType, Label)
        end
    end)
end

function RegisterKillUnitHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8)
        if acttype == 22 then
            return f(Unit, Player)
        end
    end)
end

function RegisterKillUnitAtHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6)
        if acttype == 23 then
            return f(Count, Unit, Where, ForPlayer)
        end
    end)
end

function RegisterRemoveUnitHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8)
        if acttype == 24 then
            return f(Unit, Player)
        end
    end)
end

function RegisterRemoveUnitAtHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6)
        if acttype == 25 then
            return f(Count, Unit, Where, ForPlayer)
        end
    end)
end

function RegisterSetResourcesHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Amount, ResourceType, acttype, Modifier, a6)
        if acttype == 26 then
            return f(Player, Modifier, Amount, ResourceType)
        end
    end)
end

function RegisterSetScoreHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Amount, ScoreType, acttype, Modifier, a6)
        if acttype == 27 then
            return f(Player, Modifier, Amount, ScoreType)
        end
    end)
end

function RegisterMinimapPingHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 28 then
            return f(Where)
        end
    end)
end

function RegisterTalkingPortraitHook(f)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, Unit, acttype, a7, a8)
        if acttype == 29 then
            return f(Unit, Time)
        end
    end)
end

function RegisterMuteUnitSpeechHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 30 then
            return f()
        end
    end)
end

function RegisterUnMuteUnitSpeechHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 31 then
            return f()
        end
    end)
end

function RegisterLeaderBoardComputerPlayersHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, State, a9)
        if acttype == 32 then
            return f(State)
        end
    end)
end

function RegisterLeaderBoardGoalControlHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7)
        if acttype == 33 then
            return f(Goal, Unit, Label)
        end
    end)
end

function RegisterLeaderBoardGoalControlAtHook(f)
    RegisterActionHook(function(Location, Label, a1, a2, a3, Goal, Unit, acttype, a5, a6)
        if acttype == 34 then
            return f(Goal, Unit, Location, Label)
        end
    end)
end

function RegisterLeaderBoardGoalResourcesHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, ResourceType, acttype, a6, a7)
        if acttype == 35 then
            return f(Goal, ResourceType, Label)
        end
    end)
end

function RegisterLeaderBoardGoalKillsHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7)
        if acttype == 36 then
            return f(Goal, Unit, Label)
        end
    end)
end

function RegisterLeaderBoardGoalScoreHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, ScoreType, acttype, a6, a7)
        if acttype == 37 then
            return f(Goal, ScoreType, Label)
        end
    end)
end

function RegisterMoveLocationHook(f)
    RegisterActionHook(function(DestLocation, a1, a2, a3, Owner, Location, OnUnit, acttype, a5, a6)
        if acttype == 38 then
            return f(Location, OnUnit, Owner, DestLocation)
        end
    end)
end

function RegisterMoveUnitHook(f)
    RegisterActionHook(function(StartLocation, a1, a2, a3, Owner, DestLocation, UnitType, acttype, Count, a4)
        if acttype == 39 then
            return f(Count, UnitType, Owner, StartLocation, DestLocation)
        end
    end)
end

function RegisterLeaderBoardGreedHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Goal, a6, acttype, a8, a9)
        if acttype == 40 then
            return f(Goal)
        end
    end)
end

function RegisterSetNextScenarioHook(f)
    RegisterActionHook(function(a1, ScenarioName, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 41 then
            return f(ScenarioName)
        end
    end)
end

function RegisterSetDoodadStateHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6)
        if acttype == 42 then
            return f(State, Unit, Owner, Where)
        end
    end)
end

function RegisterSetInvincibilityHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6)
        if acttype == 43 then
            return f(State, Unit, Owner, Where)
        end
    end)
end

function RegisterCreateUnitHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Number, a6)
        if acttype == 44 then
            return f(Number, Unit, Where, ForPlayer)
        end
    end)
end

function RegisterSetDeathsHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Number, Unit, acttype, Modifier, a6)
        if acttype == 45 then
            return f(Player, Modifier, Number, Unit)
        end
    end)
end

function RegisterOrderHook(f)
    RegisterActionHook(function(StartLocation, a1, a2, a3, Owner, DestLocation, Unit, acttype, OrderType, a4)
        if acttype == 46 then
            return f(Unit, Owner, StartLocation, OrderType, DestLocation)
        end
    end)
end

function RegisterCommentHook(f)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 47 then
            return f(Text)
        end
    end)
end

function RegisterGiveUnitsHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, NewOwner, Unit, acttype, Count, a5)
        if acttype == 48 then
            return f(Count, Unit, Owner, Where, NewOwner)
        end
    end)
end

function RegisterModifyUnitHitPointsHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
        if acttype == 49 then
            return f(Count, Unit, Owner, Where, Percent)
        end
    end)
end

function RegisterModifyUnitEnergyHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
        if acttype == 50 then
            return f(Count, Unit, Owner, Where, Percent)
        end
    end)
end

function RegisterModifyUnitShieldsHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
        if acttype == 51 then
            return f(Count, Unit, Owner, Where, Percent)
        end
    end)
end

function RegisterModifyUnitResourceAmountHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, NewValue, a4, acttype, Count, a6)
        if acttype == 52 then
            return f(Count, Owner, Where, NewValue)
        end
    end)
end

function RegisterModifyUnitHangarCountHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Add, Unit, acttype, Count, a5)
        if acttype == 53 then
            return f(Add, Count, Unit, Owner, Where)
        end
    end)
end

function RegisterPauseTimerHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 54 then
            return f()
        end
    end)
end

function RegisterUnpauseTimerHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 55 then
            return f()
        end
    end)
end

function RegisterDrawHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 56 then
            return f()
        end
    end)
end

function RegisterSetAllianceStatusHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Status, acttype, a7, a8)
        if acttype == 57 then
            return f(Player, Status)
        end
    end)
end
