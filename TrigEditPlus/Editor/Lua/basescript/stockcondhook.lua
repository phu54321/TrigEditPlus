function RegisterCountdownTimerHook(f, priority)
    RegisterConditionHook(1, function(conds)
        a1, a2, Time, a3, Comparison, condtype, a5, a6 = conds[1]
        return f(Comparison, Time)
    end, priority)
end

function RegisterCommandHook(f, priority)
    RegisterConditionHook(2, function(conds)
        a1, Player, Number, Unit, Comparison, condtype, a3, a4 = conds[1]
        return f(Player, Comparison, Number, Unit)
    end, priority)
end

function RegisterBringHook(f, priority)
    RegisterConditionHook(3, function(conds)
        Location, Player, Number, Unit, Comparison, condtype, a2, a3 = conds[1]
        return f(Player, Comparison, Number, Unit, Location)
    end, priority)
end

function RegisterAccumulateHook(f, priority)
    RegisterConditionHook(4, function(conds)
        a1, Player, Number, a2, Comparison, condtype, ResourceType, a4 = conds[1]
        return f(Player, Comparison, Number, ResourceType)
    end, priority)
end

function RegisterKillsHook(f, priority)
    RegisterConditionHook(5, function(conds)
        a1, Player, Number, Unit, Comparison, condtype, a3, a4 = conds[1]
        return f(Player, Comparison, Number, Unit)
    end, priority)
end

function RegisterCommandMostHook(f, priority)
    RegisterConditionHook(6, function(conds)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = conds[1]
        return f(Unit)
    end, priority)
end

function RegisterCommandMostAtHook(f, priority)
    RegisterConditionHook(7, function(conds)
        Location, a1, a2, Unit, a3, condtype, a5, a6 = conds[1]
        return f(Unit, Location)
    end, priority)
end

function RegisterMostKillsHook(f, priority)
    RegisterConditionHook(8, function(conds)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = conds[1]
        return f(Unit)
    end, priority)
end

function RegisterHighestScoreHook(f, priority)
    RegisterConditionHook(9, function(conds)
        a1, a2, a3, a4, a5, condtype, ScoreType, a7 = conds[1]
        return f(ScoreType)
    end, priority)
end

function RegisterMostResourcesHook(f, priority)
    RegisterConditionHook(10, function(conds)
        a1, a2, a3, a4, a5, condtype, ResourceType, a7 = conds[1]
        return f(ResourceType)
    end, priority)
end

function RegisterSwitchHook(f, priority)
    RegisterConditionHook(11, function(conds)
        a1, a2, a3, a4, State, condtype, Switch, a6 = conds[1]
        return f(Switch, State)
    end, priority)
end

function RegisterElapsedTimeHook(f, priority)
    RegisterConditionHook(12, function(conds)
        a1, a2, Time, a3, Comparison, condtype, a5, a6 = conds[1]
        return f(Comparison, Time)
    end, priority)
end

function RegisterBriefingHook(f, priority)
    RegisterConditionHook(13, function(conds)
        return f()
    end, priority)
end

function RegisterOpponentsHook(f, priority)
    RegisterConditionHook(14, function(conds)
        a1, Player, Number, a2, Comparison, condtype, a4, a5 = conds[1]
        return f(Player, Comparison, Number)
    end, priority)
end

function RegisterDeathsHook(f, priority)
    RegisterConditionHook(15, function(conds)
        a1, Player, Number, Unit, Comparison, condtype, a3, a4 = conds[1]
        return f(Player, Comparison, Number, Unit)
    end, priority)
end

function RegisterCommandLeastHook(f, priority)
    RegisterConditionHook(16, function(conds)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = conds[1]
        return f(Unit)
    end, priority)
end

function RegisterCommandLeastAtHook(f, priority)
    RegisterConditionHook(17, function(conds)
        Location, a1, a2, Unit, a3, condtype, a5, a6 = conds[1]
        return f(Unit, Location)
    end, priority)
end

function RegisterLeastKillsHook(f, priority)
    RegisterConditionHook(18, function(conds)
        a1, a2, a3, Unit, a4, condtype, a6, a7 = conds[1]
        return f(Unit)
    end, priority)
end

function RegisterLowestScoreHook(f, priority)
    RegisterConditionHook(19, function(conds)
        a1, a2, a3, a4, a5, condtype, ScoreType, a7 = conds[1]
        return f(ScoreType)
    end, priority)
end

function RegisterLeastResourcesHook(f, priority)
    RegisterConditionHook(20, function(conds)
        a1, a2, a3, a4, a5, condtype, ResourceType, a7 = conds[1]
        return f(ResourceType)
    end, priority)
end

function RegisterScoreHook(f, priority)
    RegisterConditionHook(21, function(conds)
        a1, Player, Number, a2, Comparison, condtype, ScoreType, a4 = conds[1]
        return f(Player, ScoreType, Comparison, Number)
    end, priority)
end

function RegisterAlwaysHook(f, priority)
    RegisterConditionHook(22, function(conds)
        return f()
    end, priority)
end

function RegisterNeverHook(f, priority)
    RegisterConditionHook(23, function(conds)
        return f()
    end, priority)
end
