function CountdownTimer(Comparison, Time)
    Comparison = ParseComparison(Comparison)
    return Condition(0, 0, Time, 0, Comparison, 1, 0, 0)
end


function Command(Player, Comparison, Number, Unit)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    return Condition(0, Player, Number, Unit, Comparison, 2, 0, 0)
end


function Bring(Player, Comparison, Number, Unit, Location)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    return Condition(Location, Player, Number, Unit, Comparison, 3, 0, 0)
end


function Accumulate(Player, Comparison, Number, ResourceType)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    ResourceType = ParseResource(ResourceType)
    return Condition(0, Player, Number, 0, Comparison, 4, ResourceType, 0)
end


function Kills(Player, Comparison, Number, Unit)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    return Condition(0, Player, Number, Unit, Comparison, 5, 0, 0)
end


function CommandMost(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 6, 0, 0)
end


function CommandMostAt(Unit, Location)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    return Condition(Location, 0, 0, Unit, 0, 7, 0, 0)
end


function MostKills(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 8, 0, 0)
end


function HighestScore(ScoreType)
    ScoreType = ParseScore(ScoreType)
    return Condition(0, 0, 0, 0, 0, 9, ScoreType, 0)
end


function MostResources(ResourceType)
    ResourceType = ParseResource(ResourceType)
    return Condition(0, 0, 0, 0, 0, 10, ResourceType, 0)
end


function Switch(Switch, State)
    Switch = ParseSwitchName(Switch)
    State = ParseSwitchState(State)
    return Condition(0, 0, 0, 0, State, 11, Switch, 0)
end


function ElapsedTime(Comparison, Time)
    Comparison = ParseComparison(Comparison)
    return Condition(0, 0, Time, 0, Comparison, 12, 0, 0)
end


function Briefing()
    return Condition(0, 0, 0, 0, 0, 13, 0, 0)
end


function Opponents(Player, Comparison, Number)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    return Condition(0, Player, Number, 0, Comparison, 14, 0, 0)
end


function Deaths(Player, Comparison, Number, Unit)
    Player = ParsePlayer(Player)
    Comparison = ParseComparison(Comparison)
    Unit = ParseUnit(Unit)
    return Condition(0, Player, Number, Unit, Comparison, 15, 0, 0)
end


function CommandLeast(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 16, 0, 0)
end


function CommandLeastAt(Unit, Location)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    return Condition(Location, 0, 0, Unit, 0, 17, 0, 0)
end


function LeastKills(Unit)
    Unit = ParseUnit(Unit)
    return Condition(0, 0, 0, Unit, 0, 18, 0, 0)
end


function LowestScore(ScoreType)
    ScoreType = ParseScore(ScoreType)
    return Condition(0, 0, 0, 0, 0, 19, ScoreType, 0)
end


function LeastResources(ResourceType)
    ResourceType = ParseResource(ResourceType)
    return Condition(0, 0, 0, 0, 0, 20, ResourceType, 0)
end


function Score(Player, ScoreType, Comparison, Number)
    Player = ParsePlayer(Player)
    ScoreType = ParseScore(ScoreType)
    Comparison = ParseComparison(Comparison)
    return Condition(0, Player, Number, 0, Comparison, 21, ScoreType, 0)
end


function Always()
    return Condition(0, 0, 0, 0, 0, 22, 0, 0)
end


function Never()
    return Condition(0, 0, 0, 0, 0, 23, 0, 0)
end



