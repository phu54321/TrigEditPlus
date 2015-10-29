function RegisterCountdownTimerHook(f, priority)
    RegisterConditionHook(1, function(condition)
        a1, a2, Time, a3, Comparison, condtype, a5, a6 = unpack(condition)
        return f(Comparison, Time)
    end, priority)
end

function RegisterCommandHook(f, priority)
    RegisterConditionHook(2, function(condition)
        a1, Player, Number, Unit, Comparison, condtype, a3, a4 = unpack(condition)
        return f(Player, Comparison, Number, Unit)
    end, priority)
end

function RegisterBringHook(f, priority)
    RegisterConditionHook(3, function(condition)
        Location, Player, Number, Unit, Comparison, condtype, a2, a3 = unpack(condition)
        return f(Player, Comparison, Number, Unit, Location)
    end, priority)
end

function RegisterAccumulateHook(f, priority)
    RegisterConditionHook(4, function(condition)
        a1, Player, Number, a2, Comparison, condtype, ResourceType, a4 = unpack(condition)
        return f(Player, Comparison, Number, ResourceType)
    end, priority)
end

function RegisterKillsHook(f, priority)
    RegisterConditionHook(5, function(condition)
        a1, Player, Number, Unit, Comparison, condtype, a3, a4 = unpack(condition)
        return f(Player, Comparison, Number, Unit)
    end, priority)
end

function RegisterCommandMostHook(f, priority)
    RegisterConditionHook(6, function(condition)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = unpack(condition)
        return f(Unit)
    end, priority)
end

function RegisterCommandMostAtHook(f, priority)
    RegisterConditionHook(7, function(condition)
        Location, a1, a2, Unit, a3, condtype, a5, a6 = unpack(condition)
        return f(Unit, Location)
    end, priority)
end

function RegisterMostKillsHook(f, priority)
    RegisterConditionHook(8, function(condition)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = unpack(condition)
        return f(Unit)
    end, priority)
end

function RegisterHighestScoreHook(f, priority)
    RegisterConditionHook(9, function(condition)
        a1, a2, a3, a4, a5, condtype, ScoreType, a7 = unpack(condition)
        return f(ScoreType)
    end, priority)
end

function RegisterMostResourcesHook(f, priority)
    RegisterConditionHook(10, function(condition)
        a1, a2, a3, a4, a5, condtype, ResourceType, a7 = unpack(condition)
        return f(ResourceType)
    end, priority)
end

function RegisterSwitchHook(f, priority)
    RegisterConditionHook(11, function(condition)
        a1, a2, a3, a4, State, condtype, Switch, a6 = unpack(condition)
        return f(Switch, State)
    end, priority)
end

function RegisterElapsedTimeHook(f, priority)
    RegisterConditionHook(12, function(condition)
        a1, a2, Time, a3, Comparison, condtype, a5, a6 = unpack(condition)
        return f(Comparison, Time)
    end, priority)
end

function RegisterBriefingHook(f, priority)
    RegisterConditionHook(13, function(condition)
        return f()
    end, priority)
end

function RegisterOpponentsHook(f, priority)
    RegisterConditionHook(14, function(condition)
        a1, Player, Number, a2, Comparison, condtype, a4, a5 = unpack(condition)
        return f(Player, Comparison, Number)
    end, priority)
end

function RegisterDeathsHook(f, priority)
    RegisterConditionHook(15, function(condition)
        a1, Player, Number, Unit, Comparison, condtype, a3, a4 = unpack(condition)
        return f(Player, Comparison, Number, Unit)
    end, priority)
end

function RegisterCommandLeastHook(f, priority)
    RegisterConditionHook(16, function(condition)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = unpack(condition)
        return f(Unit)
    end, priority)
end

function RegisterCommandLeastAtHook(f, priority)
    RegisterConditionHook(17, function(condition)
        Location, a1, a2, Unit, a3, condtype, a5, a6 = unpack(condition)
        return f(Unit, Location)
    end, priority)
end

function RegisterLeastKillsHook(f, priority)
    RegisterConditionHook(18, function(condition)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = unpack(condition)
        return f(Unit)
    end, priority)
end

function RegisterLowestScoreHook(f, priority)
    RegisterConditionHook(19, function(condition)
        a1, a2, a3, a4, a5, condtype, ScoreType, a7 = unpack(condition)
        return f(ScoreType)
    end, priority)
end

function RegisterLeastResourcesHook(f, priority)
    RegisterConditionHook(20, function(condition)
        a1, a2, a3, a4, a5, condtype, ResourceType, a7 = unpack(condition)
        return f(ResourceType)
    end, priority)
end

function RegisterScoreHook(f, priority)
    RegisterConditionHook(21, function(condition)
        a1, Player, Number, a2, Comparison, condtype, ScoreType, a4 = unpack(condition)
        return f(Player, ScoreType, Comparison, Number)
    end, priority)
end

function RegisterAlwaysHook(f, priority)
    RegisterConditionHook(22, function(condition)
        return f()
    end, priority)
end

function RegisterNeverHook(f, priority)
    RegisterConditionHook(23, function(condition)
        return f()
    end, priority)
end
