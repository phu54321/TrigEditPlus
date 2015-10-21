function RegisterVictoryHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 1 then
            return f()
        end
    end, 1)
end

function RegisterDefeatHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 2 then
            return f()
        end
    end, 2)
end

function RegisterPreserveTriggerHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 3 then
            return f()
        end
    end, 3)
end

function RegisterWaitHook(f)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, a6, acttype, a8, a9)
        if acttype == 4 then
            return f(Time)
        end
    end, 4)
end

function RegisterPauseGameHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 5 then
            return f()
        end
    end, 5)
end

function RegisterUnpauseGameHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 6 then
            return f()
        end
    end, 6)
end

function RegisterTransmissionHook(f)
    RegisterActionHook(function(Where, Text, WAVName, a1, a2, Time, Unit, acttype, TimeModifier, AlwaysDisplay)
        if acttype == 7 then
            return f(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
        end
    end, 7)
end

function RegisterPlayWAVHook(f)
    RegisterActionHook(function(a1, a2, WAVName, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 8 then
            return f(WAVName)
        end
    end, 8)
end

function RegisterDisplayTextHook(f)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, AlwaysDisplay)
        if acttype == 9 then
            return f(Text, AlwaysDisplay)
        end
    end, 9)
end

function RegisterCenterViewHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 10 then
            return f(Where)
        end
    end, 10)
end

function RegisterCreateUnitWithPropertiesHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Player, Properties, Unit, acttype, Count, a5)
        if acttype == 11 then
            return f(Count, Unit, Where, Player, Properties)
        end
    end, 11)
end

function RegisterSetMissionObjectivesHook(f)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 12 then
            return f(Text)
        end
    end, 12)
end

function RegisterSetSwitchHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Switch, a6, acttype, State, a8)
        if acttype == 13 then
            return f(Switch, State)
        end
    end, 13)
end

function RegisterSetCountdownTimerHook(f)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, a6, acttype, TimeModifier, a8)
        if acttype == 14 then
            return f(TimeModifier, Time)
        end
    end, 14)
end

function RegisterRunAIScriptHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Script, a6, acttype, a8, a9)
        if acttype == 15 then
            return f(Script)
        end
    end, 15)
end

function RegisterRunAIScriptAtHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, a4, Script, a5, acttype, a7, a8)
        if acttype == 16 then
            return f(Script, Where)
        end
    end, 16)
end

function RegisterLeaderBoardControlHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8)
        if acttype == 17 then
            return f(Unit, Label)
        end
    end, 17)
end

function RegisterLeaderBoardControlAtHook(f)
    RegisterActionHook(function(Location, Label, a1, a2, a3, a4, Unit, acttype, a6, a7)
        if acttype == 18 then
            return f(Unit, Location, Label)
        end
    end, 18)
end

function RegisterLeaderBoardResourcesHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, ResourceType, acttype, a7, a8)
        if acttype == 19 then
            return f(ResourceType, Label)
        end
    end, 19)
end

function RegisterLeaderBoardKillsHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, Unit, acttype, a7, a8)
        if acttype == 20 then
            return f(Unit, Label)
        end
    end, 20)
end

function RegisterLeaderBoardScoreHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, a5, ScoreType, acttype, a7, a8)
        if acttype == 21 then
            return f(ScoreType, Label)
        end
    end, 21)
end

function RegisterKillUnitHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8)
        if acttype == 22 then
            return f(Unit, Player)
        end
    end, 22)
end

function RegisterKillUnitAtHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6)
        if acttype == 23 then
            return f(Count, Unit, Where, ForPlayer)
        end
    end, 23)
end

function RegisterRemoveUnitHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Unit, acttype, a7, a8)
        if acttype == 24 then
            return f(Unit, Player)
        end
    end, 24)
end

function RegisterRemoveUnitAtHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Count, a6)
        if acttype == 25 then
            return f(Count, Unit, Where, ForPlayer)
        end
    end, 25)
end

function RegisterSetResourcesHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Amount, ResourceType, acttype, Modifier, a6)
        if acttype == 26 then
            return f(Player, Modifier, Amount, ResourceType)
        end
    end, 26)
end

function RegisterSetScoreHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Amount, ScoreType, acttype, Modifier, a6)
        if acttype == 27 then
            return f(Player, Modifier, Amount, ScoreType)
        end
    end, 27)
end

function RegisterMinimapPingHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 28 then
            return f(Where)
        end
    end, 28)
end

function RegisterTalkingPortraitHook(f)
    RegisterActionHook(function(a1, a2, a3, Time, a4, a5, Unit, acttype, a7, a8)
        if acttype == 29 then
            return f(Unit, Time)
        end
    end, 29)
end

function RegisterMuteUnitSpeechHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 30 then
            return f()
        end
    end, 30)
end

function RegisterUnMuteUnitSpeechHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 31 then
            return f()
        end
    end, 31)
end

function RegisterLeaderBoardComputerPlayersHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, State, a9)
        if acttype == 32 then
            return f(State)
        end
    end, 32)
end

function RegisterLeaderBoardGoalControlHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7)
        if acttype == 33 then
            return f(Goal, Unit, Label)
        end
    end, 33)
end

function RegisterLeaderBoardGoalControlAtHook(f)
    RegisterActionHook(function(Location, Label, a1, a2, a3, Goal, Unit, acttype, a5, a6)
        if acttype == 34 then
            return f(Goal, Unit, Location, Label)
        end
    end, 34)
end

function RegisterLeaderBoardGoalResourcesHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, ResourceType, acttype, a6, a7)
        if acttype == 35 then
            return f(Goal, ResourceType, Label)
        end
    end, 35)
end

function RegisterLeaderBoardGoalKillsHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, Unit, acttype, a6, a7)
        if acttype == 36 then
            return f(Goal, Unit, Label)
        end
    end, 36)
end

function RegisterLeaderBoardGoalScoreHook(f)
    RegisterActionHook(function(a1, Label, a2, a3, a4, Goal, ScoreType, acttype, a6, a7)
        if acttype == 37 then
            return f(Goal, ScoreType, Label)
        end
    end, 37)
end

function RegisterMoveLocationHook(f)
    RegisterActionHook(function(DestLocation, a1, a2, a3, Owner, Location, OnUnit, acttype, a5, a6)
        if acttype == 38 then
            return f(Location, OnUnit, Owner, DestLocation)
        end
    end, 38)
end

function RegisterMoveUnitHook(f)
    RegisterActionHook(function(StartLocation, a1, a2, a3, Owner, DestLocation, UnitType, acttype, Count, a4)
        if acttype == 39 then
            return f(Count, UnitType, Owner, StartLocation, DestLocation)
        end
    end, 39)
end

function RegisterLeaderBoardGreedHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, Goal, a6, acttype, a8, a9)
        if acttype == 40 then
            return f(Goal)
        end
    end, 40)
end

function RegisterSetNextScenarioHook(f)
    RegisterActionHook(function(a1, ScenarioName, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 41 then
            return f(ScenarioName)
        end
    end, 41)
end

function RegisterSetDoodadStateHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6)
        if acttype == 42 then
            return f(State, Unit, Owner, Where)
        end
    end, 42)
end

function RegisterSetInvincibilityHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, a4, Unit, acttype, State, a6)
        if acttype == 43 then
            return f(State, Unit, Owner, Where)
        end
    end, 43)
end

function RegisterCreateUnitHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, ForPlayer, a4, Unit, acttype, Number, a6)
        if acttype == 44 then
            return f(Number, Unit, Where, ForPlayer)
        end
    end, 44)
end

function RegisterSetDeathsHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, Number, Unit, acttype, Modifier, a6)
        if acttype == 45 then
            return f(Player, Modifier, Number, Unit)
        end
    end, 45)
end

function RegisterOrderHook(f)
    RegisterActionHook(function(StartLocation, a1, a2, a3, Owner, DestLocation, Unit, acttype, OrderType, a4)
        if acttype == 46 then
            return f(Unit, Owner, StartLocation, OrderType, DestLocation)
        end
    end, 46)
end

function RegisterCommentHook(f)
    RegisterActionHook(function(a1, Text, a2, a3, a4, a5, a6, acttype, a8, a9)
        if acttype == 47 then
            return f(Text)
        end
    end, 47)
end

function RegisterGiveUnitsHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, NewOwner, Unit, acttype, Count, a5)
        if acttype == 48 then
            return f(Count, Unit, Owner, Where, NewOwner)
        end
    end, 48)
end

function RegisterModifyUnitHitPointsHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
        if acttype == 49 then
            return f(Count, Unit, Owner, Where, Percent)
        end
    end, 49)
end

function RegisterModifyUnitEnergyHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
        if acttype == 50 then
            return f(Count, Unit, Owner, Where, Percent)
        end
    end, 50)
end

function RegisterModifyUnitShieldsHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Percent, Unit, acttype, Count, a5)
        if acttype == 51 then
            return f(Count, Unit, Owner, Where, Percent)
        end
    end, 51)
end

function RegisterModifyUnitResourceAmountHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, NewValue, a4, acttype, Count, a6)
        if acttype == 52 then
            return f(Count, Owner, Where, NewValue)
        end
    end, 52)
end

function RegisterModifyUnitHangarCountHook(f)
    RegisterActionHook(function(Where, a1, a2, a3, Owner, Add, Unit, acttype, Count, a5)
        if acttype == 53 then
            return f(Add, Count, Unit, Owner, Where)
        end
    end, 53)
end

function RegisterPauseTimerHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 54 then
            return f()
        end
    end, 54)
end

function RegisterUnpauseTimerHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 55 then
            return f()
        end
    end, 55)
end

function RegisterDrawHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, a5, a6, a7, acttype, a9, a10)
        if acttype == 56 then
            return f()
        end
    end, 56)
end

function RegisterSetAllianceStatusHook(f)
    RegisterActionHook(function(a1, a2, a3, a4, Player, a5, Status, acttype, a7, a8)
        if acttype == 57 then
            return f(Player, Status)
        end
    end, 57)
end
