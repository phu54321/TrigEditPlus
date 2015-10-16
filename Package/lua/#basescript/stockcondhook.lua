function RegisterCountdownTimerHook(f)
    RegisterConditionHook(function(a1, a2, Time, a3, Comparison, condtype, a5, a6)
        if condtype == 1 then
            return f(Comparison, Time)
        end
    end)
end

function RegisterCommandHook(f)
    RegisterConditionHook(function(a1, Player, Number, Unit, Comparison, condtype, a3, a4)
        if condtype == 2 then
            return f(Player, Comparison, Number, Unit)
        end
    end)
end

function RegisterBringHook(f)
    RegisterConditionHook(function(Location, Player, Number, Unit, Comparison, condtype, a2, a3)
        if condtype == 3 then
            return f(Player, Comparison, Number, Unit, Location)
        end
    end)
end

function RegisterAccumulateHook(f)
    RegisterConditionHook(function(a1, Player, Number, a2, Comparison, condtype, ResourceType, a4)
        if condtype == 4 then
            return f(Player, Comparison, Number, ResourceType)
        end
    end)
end

function RegisterKillsHook(f)
    RegisterConditionHook(function(a1, Player, Number, Unit, Comparison, condtype, a3, a4)
        if condtype == 5 then
            return f(Player, Comparison, Number, Unit)
        end
    end)
end

function RegisterCommandMostHook(f)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
        if condtype == 6 then
            return f(Unit)
        end
    end)
end

function RegisterCommandMostAtHook(f)
    RegisterConditionHook(function(Location, a1, a2, Unit, a3, condtype, a5, a6)
        if condtype == 7 then
            return f(Unit, Location)
        end
    end)
end

function RegisterMostKillsHook(f)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
        if condtype == 8 then
            return f(Unit)
        end
    end)
end

function RegisterHighestScoreHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ScoreType, a7)
        if condtype == 9 then
            return f(ScoreType)
        end
    end)
end

function RegisterMostResourcesHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ResourceType, a7)
        if condtype == 10 then
            return f(ResourceType)
        end
    end)
end

function RegisterSwitchHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, State, condtype, Switch, a6)
        if condtype == 11 then
            return f(Switch, State)
        end
    end)
end

function RegisterElapsedTimeHook(f)
    RegisterConditionHook(function(a1, a2, Time, a3, Comparison, condtype, a5, a6)
        if condtype == 12 then
            return f(Comparison, Time)
        end
    end)
end

function RegisterBriefingHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, a7, a8)
        if condtype == 13 then
            return f()
        end
    end)
end

function RegisterOpponentsHook(f)
    RegisterConditionHook(function(a1, Player, Number, a2, Comparison, condtype, a4, a5)
        if condtype == 14 then
            return f(Player, Comparison, Number)
        end
    end)
end

function RegisterDeathsHook(f)
    RegisterConditionHook(function(a1, Player, Number, Unit, Comparison, condtype, a3, a4)
        if condtype == 15 then
            return f(Player, Comparison, Number, Unit)
        end
    end)
end

function RegisterCommandLeastHook(f)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
        if condtype == 16 then
            return f(Unit)
        end
    end)
end

function RegisterCommandLeastAtHook(f)
    RegisterConditionHook(function(Location, a1, a2, Unit, a3, condtype, a5, a6)
        if condtype == 17 then
            return f(Unit, Location)
        end
    end)
end

function RegisterLeastKillsHook(f)
    RegisterConditionHook(function(a1, a2, a3, Unit, a4, condtype, a6, a7)
        if condtype == 18 then
            return f(Unit)
        end
    end)
end

function RegisterLowestScoreHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ScoreType, a7)
        if condtype == 19 then
            return f(ScoreType)
        end
    end)
end

function RegisterLeastResourcesHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, ResourceType, a7)
        if condtype == 20 then
            return f(ResourceType)
        end
    end)
end

function RegisterScoreHook(f)
    RegisterConditionHook(function(a1, Player, Number, a2, Comparison, condtype, ScoreType, a4)
        if condtype == 21 then
            return f(Player, ScoreType, Comparison, Number)
        end
    end)
end

function RegisterAlwaysHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, a7, a8)
        if condtype == 22 then
            return f()
        end
    end)
end

function RegisterNeverHook(f)
    RegisterConditionHook(function(a1, a2, a3, a4, a5, condtype, a7, a8)
        if condtype == 23 then
            return f()
        end
    end)
end
