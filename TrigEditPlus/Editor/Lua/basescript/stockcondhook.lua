function RegisterCountdownTimerHook(f, priority)
    RegisterConditionHook(function(a1, a2, Time, a3, Comparison, condtype, a5, a6)
            return f(Comparison, Time)
    end, 1, priority)
end

function RegisterCommandHook(f, priority)
    RegisterConditionHook(function(a1, Player, Number, Unit, Comparison, condtype, a3, a4)
            return f(Player, Comparison, Number, Unit)
    end, 2, priority)
end

function RegisterBringHook(f, priority)
    RegisterConditionHook(function(Location, Player, Number, Unit, Comparison, condtype, a2, a3)
            return f(Player, Comparison, Number, Unit, Location)
    end, 3, priority)
end

function RegisterAccumulateHook(f, priority)
    RegisterConditionHook(function(a1, Player, Number, a2, Comparison, condtype, ResourceType, a4)
            return f(Player, Comparison, Number, ResourceType)
    end, 4, priority)
end

function RegisterKillsHook(f, priority)
    RegisterConditionHook(function(a1, Player, Number, Unit, Comparison, condtype, a3, a4)
            return f(Player, Comparison, Number, Unit)
    end, 5, priority)
end

function RegisterCommandMostHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
            return f(Unit)
    end, 6, priority)
end

function RegisterCommandMostAtHook(f, priority)
    RegisterConditionHook(function(Location, a1, a2, Unit, a3, condtype, a5, a6)
            return f(Unit, Location)
    end, 7, priority)
end

function RegisterMostKillsHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
            return f(Unit)
    end, 8, priority)
end

function RegisterHighestScoreHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ScoreType, a7)
            return f(ScoreType)
    end, 9, priority)
end

function RegisterMostResourcesHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ResourceType, a7)
            return f(ResourceType)
    end, 10, priority)
end

function RegisterSwitchHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, State, condtype, Switch, a6)
            return f(Switch, State)
    end, 11, priority)
end

function RegisterElapsedTimeHook(f, priority)
    RegisterConditionHook(function(a1, a2, Time, a3, Comparison, condtype, a5, a6)
            return f(Comparison, Time)
    end, 12, priority)
end

function RegisterBriefingHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, a7, a8)
            return f()
    end, 13, priority)
end

function RegisterOpponentsHook(f, priority)
    RegisterConditionHook(function(a1, Player, Number, a2, Comparison, condtype, a4, a5)
            return f(Player, Comparison, Number)
    end, 14, priority)
end

function RegisterDeathsHook(f, priority)
    RegisterConditionHook(function(a1, Player, Number, Unit, Comparison, condtype, a3, a4)
            return f(Player, Comparison, Number, Unit)
    end, 15, priority)
end

function RegisterCommandLeastHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
            return f(Unit)
    end, 16, priority)
end

function RegisterCommandLeastAtHook(f, priority)
    RegisterConditionHook(function(Location, a1, a2, Unit, a3, condtype, a5, a6)
            return f(Unit, Location)
    end, 17, priority)
end

function RegisterLeastKillsHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
            return f(Unit)
    end, 18, priority)
end

function RegisterLowestScoreHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ScoreType, a7)
            return f(ScoreType)
    end, 19, priority)
end

function RegisterLeastResourcesHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ResourceType, a7)
            return f(ResourceType)
    end, 20, priority)
end

function RegisterScoreHook(f, priority)
    RegisterConditionHook(function(a1, Player, Number, a2, Comparison, condtype, ScoreType, a4)
            return f(Player, ScoreType, Comparison, Number)
    end, 21, priority)
end

function RegisterAlwaysHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, a7, a8)
            return f()
    end, 22, priority)
end

function RegisterNeverHook(f, priority)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, a7, a8)
            return f()
    end, 23, priority)
end
