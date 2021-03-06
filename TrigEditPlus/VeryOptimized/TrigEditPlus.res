        ��  ��                  �      �� ��{     0           <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
<assemblyIdentity
    version="0.0.0.0"
    processorArchitecture="*"
    name="SaibiLab.Scmdraft2Plugin.TrigEditPlus"
    type="win32"
/>
<description>Your application description here.</description>
<dependency>
    <dependentAssembly>
        <assemblyIdentity
            type="win32"
            name="Microsoft.Windows.Common-Controls"
            version="6.0.0.0"
            processorArchitecture="*"
            publicKeyToken="6595b64144ccf1df"
            language="*"
        />
    </dependentAssembly>
</dependency>
</assembly>   8      ��
 ���    0         Copyright �� 1994?2014 Lua.org, PUC-Rio.
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.w      ��
 ���    0         License for Scintilla and SciTE

Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>

All Rights Reserved 

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that 
both that copyright notice and this permission notice appear in 
supporting documentation. 

NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY 
SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
OR PERFORMANCE OF THIS SOFTWARE.  �      ��
 ���    0         ---------------------------------------------------------------------------------
-- Copyright (c) 2014 trgk(phu54321@naver.com)
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
---------------------------------------------------------------------------------


-- Case-insensitive patch & Block accessing undefined variable

local global_metatable = getmetatable(_G) or {}
local keytable = {}

global_metatable.__newindex = function(table, key, value)
    if type(key) == "string" then
        local lkey = key:lower()
        if keytable[lkey] ~= nil then
            rawset(table, keytable[lkey], nil)
        end

        if value == nil then
            keytable[lkey] = nil
        else
            rawset(table, key, value)
            keytable[lkey] = key
        end
    else
        rawset(table, key, value)
    end
end

global_metatable.__index = function(table, key)
    if type(key) == "string" then
        local lkey = key:lower()
        local ckey = keytable[lkey]
        if ckey == nil then
            error("Attempt to access undefined variable (" .. key .. ")")
        end
        return rawget(table, ckey)
    else
        local value = rawget(table, key)
        if value == nil then
            error("Attempt to access undefined variable (" .. key .. ")")
        end
    end
end

setmetatable(_G, global_metatable)


-- Trigger / condition / action def

-- Constants used for trigger.
actexec = {__trg_magic="trgconst"}
preserved = {__trg_magic="trgconst"}
disabled = {__trg_magic="trgconst"}

function FlattenList(list)
    local output, tmp, outputidx

    if type(list) == 'table' then
        if list.__trg_magic ~= nil then
            return {list}
        end

        output = {}
        outputidx = 1
        for i = 1, #list do
            tmp = FlattenList(list[i])
            for j = 1, #tmp do
                output[outputidx] = tmp[j]
                outputidx = outputidx + 1
            end
        end

        return output
    else
        return {list}
    end
end


function Trigger(args)
    if args.players then
        args.players = FlattenList(args.players)
    end

    if args.conditions then
        args.conditions = FlattenList(args.conditions)
    end

    if args.actions then
        args.actions = FlattenList(args.actions)
    end

    if args.flag then
        args.flag = FlattenList(args.flag)
    end

    args.callerLine = debug.getinfo(2).currentline

    __internal__AddTrigger(args)
end


function Condition(locid, player, amount, unitid, comparison, condtype, restype, flags)
    return {locid, player, amount, unitid, comparison, condtype, restype, flags, __trg_magic="condition"}
end

function Action(locid1, strid, wavid, time, player1, player2, unitid, acttype, amount, flags)
    return {locid1, strid, wavid, time, player1, player2, unitid, acttype, amount, flags, __trg_magic="action"}
end


-- Condition/Action disabler
function Disabled(stmt)
    stmt["disabled"] = true
    return stmt
end



-- Function declaration inspector

local function getArgs(fun)
    local args = {}
    local hook = debug.gethook()

    local argHook = function( ... )
        local info = debug.getinfo(3)
        if 'pcall' ~= info.name then return end

        for i = 1, math.huge do
            local name, value = debug.getlocal(2, i)
            if '(*temporary)' == name then
                debug.sethook(hook)
                error('')
                return
            end
            table.insert(args,name)
        end
    end

    debug.sethook(argHook, "c")
    pcall(fun)

    return args
end

function GetFunctionDeclaration(fname)
    fname = keytable[fname:lower()]
    if fname == nil then return end

    local fun = _G[fname]
    if fun == nil or type(fun) ~= "function" then
        return
    end


    local farglist = getArgs(fun)
    return fname .. '(' .. table.concat(farglist, ", ") .. ')'
end
 z      ��
 ���    0         ---------------------------------------------------------------------------------
-- Copyright (c) 2014 trgk(phu54321@naver.com)
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
---------------------------------------------------------------------------------

-- Lock access to undefined variable.

-- Code snippet from http://stackoverflow.com/questions/9102931/can-lua-support-case-insensitive-method-calls

local conditionhooks = {}
local actionhooks = {}
local erroredf = {}

function RegisterConditionHook(f, condtypes, priority)
    if condtypes == nil then
        condtypes = {0}
    else
        condtypes = FlattenList(condtypes)
    end

	-- For old-days hooks, fallback
	if priority == nil then
		priority = -1000000
	else
		priority = -1000000
	end

    for i = 1, #condtypes do
        local condtype = condtypes[i]
        if conditionhooks[condtype] == nil then
            conditionhooks[condtype] = {}
        end
        table.insert(conditionhooks[condtype], {f, priority})
    end
end

function RegisterActionHook(f, acttypes, priority)
    if acttypes == nil then
        acttypes = {0}
    else
        acttypes = FlattenList(acttypes)
    end

	-- For old-days hooks, fallback
	if priority == nil then
		priority = -1000000
	else
		priority = -1000000
	end

    for i = 1, #acttypes do
        local acttype = acttypes[i]
        if actionhooks[acttype] == nil then
            actionhooks[acttype] = {}
        end
        table.insert(actionhooks[acttype], {f, priority})
    end
end


function prioritySorter(a, b)
    -- Sort by higher priority
    return a[2] > b[2]
end

function SortHooks()
	for k, v in pairs(conditionhooks) do
		table.sort(v, prioritySorter)
	end

	for k, v in pairs(actionhooks) do
		table.sort(v, prioritySorter)
	end
end


---- Hook processors

function ProcessHooks_Sub(hooklist, hookcaller, errhandler)
	local retstr = nil
    for i = 1, #hooklist do
        local hookf, hookpriority = hooklist[i][1], hooklist[i][2]
        if not erroredf[hookf] and not pcall(function()
            local retstr_local = hookcaller(hookf)
            if retstr_local then
				retstr = retstr_local
            end
        end, errhandler) then
            erroredf[hookf] = true
        end
		if retstr then
			return retstr, hookpriority
		end
    end
    return nil, nil
end


function ProcessConditionHook(errhandler, a1, a2, a3, a4, a5, a6, a7, a8)
    local beststr, bestpriority = nil, nil
    local beststr2, bestpriority2
    
    local function hookcaller(hookfunc)
        return hookfunc(a1, a2, a3, a4, a5, a6, a7, a8)
    end

    local condtype = a6
    
    -- Process condtype-specific functions
    local ctype_hooks = conditionhooks[condtype]
    if ctype_hooks ~= nil then
        beststr, bestpriority = ProcessHooks_Sub(ctype_hooks, hookcaller, errhandler)
    end

    -- Process non condtype-specific functions
    local general_hooks = conditionhooks[0]
    if general_hooks ~= nil then
        beststr2, bestpriority2 = ProcessHooks_Sub(general_hooks, hookcaller, errhandler)
        if not beststr then
            beststr = beststr2
        elseif bestpriority2 > bestpriority then
            beststr = beststr2
        end
    end
    
    return beststr  -- Nil if hook is not found, Else appropriate string
end


function ProcessActionHook(errhandler, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    local beststr, bestpriority = nil, nil
    local beststr2, bestpriority2
    
    local function hookcaller(hookfunc)
        return hookfunc(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    end

    local acttype = a8

    -- Process acttype-specific functions
    local atype_hooks = actionhooks[acttype]
    if atype_hooks ~= nil then
	    beststr, bestpriority = ProcessHooks_Sub(atype_hooks, hookcaller, errhandler)
	end

    -- Process non acttype-specific functions
    local general_hooks = actionhooks[0]
    if general_hooks ~= nil then
	    beststr, bestpriority = ProcessHooks_Sub(general_hooks, hookcaller, errhandler)
        if not beststr then
            beststr, bestpriority = beststr2, bestpriority2
        elseif bestpriority2 > bestpriority then
            beststr, bestpriority = beststr2, bestpriority2
        end
	end
    
    return beststr  -- Nil if hook is not found, Else appropriate string
end
  �      ��
 ���    0         function EPD(offset)
    return (offset - 0x58A364) / 4
end

function Memory(offset, comparison, number)
    assert(offset % 4 == 0, "[Memory] Offset should be divisible by 4")

    if 0x58A364 <= offset and offset <= 0x58A364 + 48 * 65536 then
        local eud_player, eud_unit
        eud_player = (offset - 0x58A364) / 4 % 12
        eud_unit = ((offset - 0x58A364) / 4 - eud_player) / 12
        return Deaths(eud_player, comparison, number, eud_unit)
    end
    
    return Deaths(EPD(offset), comparison, number, 0)
end

function SetMemory(offset, modtype, number)
    assert(offset % 4 == 0, "[SetMemory] Offset should be divisible by 4")

    -- If offset is in normal deaths / eud range, use it.
    if 0x58A364 <= offset and offset <= 0x58A364 + 48 * 65536 then
        local eud_player, eud_unit
        eud_player = (offset - 0x58A364) / 4 % 12
        eud_unit = ((offset - 0x58A364) / 4 - eud_player) / 12
        return SetDeaths(eud_player, modtype, number, eud_unit)
    else  -- Use EPD
	return SetDeaths(EPD(offset), modtype, number, 0)
    end
end

----------------------------------------------------------
  �      ��
 ���    0         function CountdownTimer(Comparison, Time)
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



  �*      ��
 ���    0         
function Victory()
    return Action(0, 0, 0, 0, 0, 0, 0, 1, 0, 4)
end


function Defeat()
    return Action(0, 0, 0, 0, 0, 0, 0, 2, 0, 4)
end


function PreserveTrigger()
    return Action(0, 0, 0, 0, 0, 0, 0, 3, 0, 4)
end


function Wait(Time)
    return Action(0, 0, 0, Time, 0, 0, 0, 4, 0, 4)
end


function PauseGame()
    return Action(0, 0, 0, 0, 0, 0, 0, 5, 0, 4)
end


function UnpauseGame()
    return Action(0, 0, 0, 0, 0, 0, 0, 6, 0, 4)
end


function Transmission(Unit, Where, WAVName, TimeModifier, Time, Text, AlwaysDisplay)
    if AlwaysDisplay == nil then
        AlwaysDisplay = 4
    end

    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    WAVName = ParseString(WAVName)
    TimeModifier = ParseModifier(TimeModifier)
    Text = ParseString(Text)
    return Action(Where, Text, WAVName, 0, 0, Time, Unit, 7, TimeModifier, AlwaysDisplay)
end

-- Location Text    Wav TotDuration 0   DurationMod UnitType    7   NumericMod  20

function PlayWAV(WAVName)
    WAVName = ParseString(WAVName)
    return Action(0, 0, WAVName, 0, 0, 0, 0, 8, 0, 4)
end


function DisplayText(Text, AlwaysDisplay)
    if AlwaysDisplay == nil then AlwaysDisplay = 4 end
    Text = ParseString(Text)
    return Action(0, Text, 0, 0, 0, 0, 0, 9, 0, AlwaysDisplay)
end


function CenterView(Where)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, 0, 0, 0, 10, 0, 4)
end


function CreateUnitWithProperties(Count, Unit, Where, Player, Properties)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    Player = ParsePlayer(Player)
    Properties = ParseUPRP(Properties)
    return Action(Where, 0, 0, 0, Player, Properties, Unit, 11, Count, 28)
end


function SetMissionObjectives(Text)
    Text = ParseString(Text)
    return Action(0, Text, 0, 0, 0, 0, 0, 12, 0, 4)
end


function SetSwitch(Switch, State)
    Switch = ParseSwitchName(Switch)
    State = ParseSwitchAction(State)
    return Action(0, 0, 0, 0, 0, Switch, 0, 13, State, 4)
end


function SetCountdownTimer(TimeModifier, Time)
    TimeModifier = ParseModifier(TimeModifier)
    return Action(0, 0, 0, Time, 0, 0, 0, 14, TimeModifier, 4)
end


function RunAIScript(Script)
    Script = ParseAIScript(Script)
    return Action(0, 0, 0, 0, 0, Script, 0, 15, 0, 4)
end


function RunAIScriptAt(Script, Where)
    Script = ParseAIScript(Script)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, 0, Script, 0, 16, 0, 4)
end


function LeaderBoardControl(Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, Unit, 17, 0, 20)
end


function LeaderBoardControlAt(Unit, Location, Label)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    Label = ParseString(Label)
    return Action(Location, Label, 0, 0, 0, 0, Unit, 18, 0, 20)
end


function LeaderBoardResources(ResourceType, Label)
    ResourceType = ParseResource(ResourceType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, ResourceType, 19, 0, 4)
end


function LeaderBoardKills(Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, Unit, 20, 0, 20)
end


function LeaderBoardScore(ScoreType, Label)
    ScoreType = ParseScore(ScoreType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, 0, ScoreType, 21, 0, 4)
end


function KillUnit(Unit, Player)
    Unit = ParseUnit(Unit)
    Player = ParsePlayer(Player)
    return Action(0, 0, 0, 0, Player, 0, Unit, 22, 0, 20)
end


function KillUnitAt(Count, Unit, Where, ForPlayer)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    ForPlayer = ParsePlayer(ForPlayer)
    return Action(Where, 0, 0, 0, ForPlayer, 0, Unit, 23, Count, 20)
end


function RemoveUnit(Unit, Player)
    Unit = ParseUnit(Unit)
    Player = ParsePlayer(Player)
    return Action(0, 0, 0, 0, Player, 0, Unit, 24, 0, 20)
end


function RemoveUnitAt(Count, Unit, Where, ForPlayer)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    ForPlayer = ParsePlayer(ForPlayer)
    return Action(Where, 0, 0, 0, ForPlayer, 0, Unit, 25, Count, 20)
end


function SetResources(Player, Modifier, Amount, ResourceType)
    Player = ParsePlayer(Player)
    Modifier = ParseModifier(Modifier)
    ResourceType = ParseResource(ResourceType)
    return Action(0, 0, 0, 0, Player, Amount, ResourceType, 26, Modifier, 4)
end


function SetScore(Player, Modifier, Amount, ScoreType)
    Player = ParsePlayer(Player)
    Modifier = ParseModifier(Modifier)
    ScoreType = ParseScore(ScoreType)
    return Action(0, 0, 0, 0, Player, Amount, ScoreType, 27, Modifier, 4)
end


function MinimapPing(Where)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, 0, 0, 0, 28, 0, 4)
end


function TalkingPortrait(Unit, Time)
    Unit = ParseUnit(Unit)
    return Action(0, 0, 0, Time, 0, 0, Unit, 29, 0, 20)
end


function MuteUnitSpeech()
    return Action(0, 0, 0, 0, 0, 0, 0, 30, 0, 4)
end


function UnMuteUnitSpeech()
    return Action(0, 0, 0, 0, 0, 0, 0, 31, 0, 4)
end


function LeaderBoardComputerPlayers(State)
    State = ParsePropState(State)
    return Action(0, 0, 0, 0, 0, 0, 0, 32, State, 4)
end


function LeaderBoardGoalControl(Goal, Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, Unit, 33, 0, 20)
end


function LeaderBoardGoalControlAt(Goal, Unit, Location, Label)
    Unit = ParseUnit(Unit)
    Location = ParseLocation(Location)
    Label = ParseString(Label)
    return Action(Location, Label, 0, 0, 0, Goal, Unit, 34, 0, 20)
end


function LeaderBoardGoalResources(Goal, ResourceType, Label)
    ResourceType = ParseResource(ResourceType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, ResourceType, 35, 0, 4)
end


function LeaderBoardGoalKills(Goal, Unit, Label)
    Unit = ParseUnit(Unit)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, Unit, 36, 0, 20)
end


function LeaderBoardGoalScore(Goal, ScoreType, Label)
    ScoreType = ParseScore(ScoreType)
    Label = ParseString(Label)
    return Action(0, Label, 0, 0, 0, Goal, ScoreType, 37, 0, 4)
end


function MoveLocation(Location, OnUnit, Owner, DestLocation)
    Location = ParseLocation(Location)
    OnUnit = ParseUnit(OnUnit)
    Owner = ParsePlayer(Owner)
    DestLocation = ParseLocation(DestLocation)
    return Action(DestLocation, 0, 0, 0, Owner, Location, OnUnit, 38, 0, 20)
end


function MoveUnit(Count, UnitType, Owner, StartLocation, DestLocation)
    Count = ParseCount(Count)
    UnitType = ParseUnit(UnitType)
    Owner = ParsePlayer(Owner)
    StartLocation = ParseLocation(StartLocation)
    DestLocation = ParseLocation(DestLocation)
    return Action(StartLocation, 0, 0, 0, Owner, DestLocation,
                  UnitType, 39, Count, 20)
end


function LeaderBoardGreed(Goal)
    return Action(0, 0, 0, 0, 0, Goal, 0, 40, 0, 4)
end


function SetNextScenario(ScenarioName)
    ScenarioName = ParseString(ScenarioName)
    return Action(0, ScenarioName, 0, 0, 0, 0, 0, 41, 0, 4)
end


function SetDoodadState(State, Unit, Owner, Where)
    State = ParsePropState(State)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, 0, Unit, 42, State, 20)
end


function SetInvincibility(State, Unit, Owner, Where)
    State = ParsePropState(State)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, 0, Unit, 43, State, 20)
end


function CreateUnit(Number, Unit, Where, ForPlayer)
    Unit = ParseUnit(Unit)
    Where = ParseLocation(Where)
    ForPlayer = ParsePlayer(ForPlayer)
    return Action(Where, 0, 0, 0, ForPlayer, 0, Unit, 44, Number, 20)
end


function SetDeaths(Player, Modifier, Number, Unit)
    Player = ParsePlayer(Player)
    Modifier = ParseModifier(Modifier)
    Unit = ParseUnit(Unit)
    return Action(0, 0, 0, 0, Player, Number, Unit, 45, Modifier, 20)
end


function Order(Unit, Owner, StartLocation, OrderType, DestLocation)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    StartLocation = ParseLocation(StartLocation)
    OrderType = ParseOrder(OrderType)
    DestLocation = ParseLocation(DestLocation)
    return Action(StartLocation, 0, 0, 0, Owner, DestLocation,
                  Unit, 46, OrderType, 20)
end


function Comment(Text)
    Text = ParseString(Text)
    return Action(0, Text, 0, 0, 0, 0, 0, 47, 0, 4)
end


function GiveUnits(Count, Unit, Owner, Where, NewOwner)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    NewOwner = ParsePlayer(NewOwner)
    return Action(Where, 0, 0, 0, Owner, NewOwner, Unit, 48, Count, 20)
end


function ModifyUnitHitPoints(Count, Unit, Owner, Where, Percent)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Percent, Unit, 49, Count, 20)
end


function ModifyUnitEnergy(Count, Unit, Owner, Where, Percent)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Percent, Unit, 50, Count, 20)
end


function ModifyUnitShields(Count, Unit, Owner, Where, Percent)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Percent, Unit, 51, Count, 20)
end


function ModifyUnitResourceAmount(Count, Owner, Where, NewValue)
    Count = ParseCount(Count)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, NewValue, 0, 52, Count, 4)
end


function ModifyUnitHangarCount(Add, Count, Unit, Owner, Where)
    Count = ParseCount(Count)
    Unit = ParseUnit(Unit)
    Owner = ParsePlayer(Owner)
    Where = ParseLocation(Where)
    return Action(Where, 0, 0, 0, Owner, Add, Unit, 53, Count, 20)
end


function PauseTimer()
    return Action(0, 0, 0, 0, 0, 0, 0, 54, 0, 4)
end


function UnpauseTimer()
    return Action(0, 0, 0, 0, 0, 0, 0, 55, 0, 4)
end


function Draw()
    return Action(0, 0, 0, 0, 0, 0, 0, 56, 0, 4)
end


function SetAllianceStatus(Player, Status)
    Player = ParsePlayer(Player)
    Status = ParseAllyStatus(Status)
    return Action(0, 0, 0, 0, Player, 0, Status, 57, 0, 4)
end

�      ��
 ���    0         function RegisterCountdownTimerHook(f, priority)
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
�.      ��
 ���    0         function RegisterVictoryHook(f, priority)
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
 RL      ��
 ���    0         -- Constants used inside triggers & actions
-- Different tables are guranteed to be unique, so we use tables as constant definer

All = {__trg_magic="trgconst"}
Enemy = {__trg_magic="trgconst"}
Ally = {__trg_magic="trgconst"}
AlliedVictory = {__trg_magic="trgconst"}
AtLeast = {__trg_magic="trgconst"}
AtMost = {__trg_magic="trgconst"}
Exactly = {__trg_magic="trgconst"}
SetTo = {__trg_magic="trgconst"}
Add = {__trg_magic="trgconst"}
Subtract = {__trg_magic="trgconst"}
Move = {__trg_magic="trgconst"}
Patrol = {__trg_magic="trgconst"}
Attack = {__trg_magic="trgconst"}
P1 = {__trg_magic="trgconst"}
P2 = {__trg_magic="trgconst"}
P3 = {__trg_magic="trgconst"}
P4 = {__trg_magic="trgconst"}
P5 = {__trg_magic="trgconst"}
P6 = {__trg_magic="trgconst"}
P7 = {__trg_magic="trgconst"}
P8 = {__trg_magic="trgconst"}
P9 = {__trg_magic="trgconst"}
P10 = {__trg_magic="trgconst"}
P11 = {__trg_magic="trgconst"}
P12 = {__trg_magic="trgconst"}
CurrentPlayer = {__trg_magic="trgconst"}
Foes = {__trg_magic="trgconst"}
Allies = {__trg_magic="trgconst"}
NeutralPlayers = {__trg_magic="trgconst"}
AllPlayers = {__trg_magic="trgconst"}
Force1 = {__trg_magic="trgconst"}
Force2 = {__trg_magic="trgconst"}
Force3 = {__trg_magic="trgconst"}
Force4 = {__trg_magic="trgconst"}
NonAlliedVictoryPlayers = {__trg_magic="trgconst"}
Enable = {__trg_magic="trgconst"}
Disable = {__trg_magic="trgconst"}
Toggle = {__trg_magic="trgconst"}
Ore = {__trg_magic="trgconst"}
Gas = {__trg_magic="trgconst"}
OreAndGas = {__trg_magic="trgconst"}
Total = {__trg_magic="trgconst"}
Units = {__trg_magic="trgconst"}
Buildings = {__trg_magic="trgconst"}
UnitsAndBuildings = {__trg_magic="trgconst"}
Razings = {__trg_magic="trgconst"}
KillsAndRazings = {__trg_magic="trgconst"}
Custom = {__trg_magic="trgconst"}
Set = {__trg_magic="trgconst"}
Clear = {__trg_magic="trgconst"}
Random = {__trg_magic="trgconst"}
Cleared = {__trg_magic="trgconst"}

-- Kills = {__trg_magic="trgconst"}
-- Kills can be used both as constant and condition.
-- We reuse condition Kills for this.


local AllyStatusDict = {
    [Enemy] =  0,
    [Ally] =  1,
    [AlliedVictory] =  2,
}

local ComparisonDict = {
    [AtLeast] =  0,
    [AtMost] =  1,
    [Exactly] =  10,
}

local ModifierDict = {
    [SetTo] =  7,
    [Add] =  8,
    [Subtract] =  9,
}

local OrderDict = {
    [Move] =  0,
    [Patrol] =  1,
    [Attack] =  2,
}

local PlayerDict = {
    [P1] =  0,
    [P2] =  1,
    [P3] =  2,
    [P4] =  3,
    [P5] =  4,
    [P6] =  5,
    [P7] =  6,
    [P8] =  7,
    [P9] =  8,
    [P10] =  9,
    [P11] =  10,
    [P12] =  11,
    [CurrentPlayer] =  13,
    [Foes] =  14,
    [Allies] =  15,
    [NeutralPlayers] =  16,
    [AllPlayers] =  17,
    [Force1] =  18,
    [Force2] =  19,
    [Force3] =  20,
    [Force4] =  21,
    [NonAlliedVictoryPlayers] =  26,
}

local PropStateDict = {
    [Enable] =  4,
    [Disable] =  5,
    [Toggle] =  6,
}

local ResourceDict = {
    [Ore] =  0,
    [Gas] =  1,
    [OreAndGas] =  2,
}

local ScoreDict = {
    [Total] =  0,
    [Units] =  1,
    [Buildings] =  2,
    [UnitsAndBuildings] =  3,
    [Kills] =  4,
    [Razings] =  5,
    [KillsAndRazings] =  6,
    [Custom] =  7,
}

local SwitchActionDict = {
    [Set] =  4,
    [Clear] =  5,
    [Toggle] =  6,
    [Random] =  11,
}

local SwitchStateDict = {
    [Set] =  2,
    [Cleared] =  3,
}


local AIScriptDict = {
    ["Terran Custom Level"] = 1967344980,
    ["Zerg Custom Level"] = 1967344986,
    ["Protoss Custom Level"] = 1967344976,
    ["Terran Expansion Custom Level"] = 2017676628,
    ["Zerg Expansion Custom Level"] = 2017676634,
    ["Protoss Expansion Custom Level"] = 2017676624,
    ["Terran Campaign Easy"] = 1716472916,
    ["Terran Campaign Medium"] = 1145392468,
    ["Terran Campaign Difficult"] = 1716078676,
    ["Terran Campaign Insane"] = 1347769172,
    ["Terran Campaign Area Town"] = 1163018580,
    ["Zerg Campaign Easy"] = 1716472922,
    ["Zerg Campaign Medium"] = 1145392474,
    ["Zerg Campaign Difficult"] = 1716078682,
    ["Zerg Campaign Insane"] = 1347769178,
    ["Zerg Campaign Area Town"] = 1163018586,
    ["Protoss Campaign Easy"] = 1716472912,
    ["Protoss Campaign Medium"] = 1145392464,
    ["Protoss Campaign Difficult"] = 1716078672,
    ["Protoss Campaign Insane"] = 1347769168,
    ["Protoss Campaign Area Town"] = 1163018576,
    ["Expansion Terran Campaign Easy"] = 2018462804,
    ["Expansion Terran Campaign Medium"] = 2017807700,
    ["Expansion Terran Campaign Difficult"] = 2018068564,
    ["Expansion Terran Campaign Insane"] = 2018857812,
    ["Expansion Terran Campaign Area Town"] = 2018656596,
    ["Expansion Zerg Campaign Easy"] = 2018462810,
    ["Expansion Zerg Campaign Medium"] = 2017807706,
    ["Expansion Zerg Campaign Difficult"] = 2018068570,
    ["Expansion Zerg Campaign Insane"] = 2018857818,
    ["Expansion Zerg Campaign Area Town"] = 2018656602,
    ["Expansion Protoss Campaign Easy"] = 2018462800,
    ["Expansion Protoss Campaign Medium"] = 2017807696,
    ["Expansion Protoss Campaign Difficult"] = 2018068560,
    ["Expansion Protoss Campaign Insane"] = 2018857808,
    ["Expansion Protoss Campaign Area Town"] = 2018656592,
    ["Send All Units on Strategic Suicide Missions"] = 1667855699,
    ["Send All Units on Random Suicide Missions"] = 1382643027,
    ["Switch Computer Player to Rescue Passive"] = 1969451858,
    ["Turn ON Shared Vision for Player 1"] = 812209707,
    ["Turn ON Shared Vision for Player 2"] = 828986923,
    ["Turn ON Shared Vision for Player 3"] = 845764139,
    ["Turn ON Shared Vision for Player 4"] = 862541355,
    ["Turn ON Shared Vision for Player 5"] = 879318571,
    ["Turn ON Shared Vision for Player 6"] = 896095787,
    ["Turn ON Shared Vision for Player 7"] = 912873003,
    ["Turn ON Shared Vision for Player 8"] = 929650219,
    ["Turn OFF Shared Vision for Player 1"] = 812209709,
    ["Turn OFF Shared Vision for Player 2"] = 828986925,
    ["Turn OFF Shared Vision for Player 3"] = 845764141,
    ["Turn OFF Shared Vision for Player 4"] = 862541357,
    ["Turn OFF Shared Vision for Player 5"] = 879318573,
    ["Turn OFF Shared Vision for Player 6"] = 896095789,
    ["Turn OFF Shared Vision for Player 7"] = 912873005,
    ["Turn OFF Shared Vision for Player 8"] = 929650221,
    ["Move Dark Templars to Region"] = 1700034125,
    ["Clear Previous Combat Data"] = 1131572291,
    ["Set Player to Enemy"] = 2037214789,
    ["Set Player to Ally  "] = 2037148737,
    ["Value This Area Higher"] = 1098214486,
    ["Enter Closest Bunker"] = 1799515717,
    ["Set Generic Command Target"] = 1733588051,
    ["Make These Units Patrol"] = 1951429715,
    ["Enter Transport"] = 1918135877,
    ["Exit Transport"] = 1918138437,
    ["AI Nuke Here"] = 1699247438,
    ["AI Harass Here"] = 1699242312,
    ["Set Unit Order To: Junk Yard Dog"] = 1732532554,
    ["Disruption Web Here"] = 1699239748,
    ["Recall Here"] = 1699243346,
    ["Terran 3 - Zerg Town"] = 863135060,
    ["Terran 5 - Terran Main Town"] = 896689492,
    ["Terran 5 - Terran Harvest Town"] = 1211458900,
    ["Terran 6 - Air Attack Zerg"] = 913466708,
    ["Terran 6 - Ground Attack Zerg"] = 1647732052,
    ["Terran 6 - Zerg Support Town"] = 1664509268,
    ["Terran 7 - Bottom Zerg Town"] = 930243924,
    ["Terran 7 - Right Zerg Town"] = 1933010260,
    ["Terran 7 - Middle Zerg Town"] = 1832346964,
    ["Terran 8 - Confederate Town"] = 947021140,
    ["Terran 9 - Light Attack"] = 1278833236,
    ["Terran 9 - Heavy Attack"] = 1211724372,
    ["Terran 10 - Confederate Towns"] = 808543572,
    ["Terran 11 - Zerg Town"] = 2050044244,
    ["Terran 11 - Lower Protoss Town"] = 1630613844,
    ["Terran 11 - Upper Protoss Town"] = 1647391060,
    ["Terran 12 - Nuke Town"] = 1311912276,
    ["Terran 12 - Phoenix Town"] = 1345466708,
    ["Terran 12 - Tank Town"] = 1412575572,
    ["Terran 1 - Electronic Distribution"] = 826557780,
    ["Terran 2 - Electronic Distribution"] = 843334996,
    ["Terran 3 - Electronic Distribution"] = 860112212,
    ["Terran 1 - Shareware"] = 827806548,
    ["Terran 2 - Shareware"] = 844583764,
    ["Terran 3 - Shareware"] = 861360980,
    ["Terran 4 - Shareware"] = 878138196,
    ["Terran 5 - Shareware"] = 894915412,
    ["Zerg 1 - Terran Town"] = 829580634,
    ["Zerg 2 - Protoss Town"] = 846357850,
    ["Zerg 3 - Terran Town"] = 863135066,
    ["Zerg 4 - Right Terran Town"] = 879912282,
    ["Zerg 4 - Lower Terran Town"] = 1395942746,
    ["Zerg 6 - Protoss Town"] = 913466714,
    ["Zerg 7 - Air Town"] = 1631023706,
    ["Zerg 7 - Ground Town"] = 1731687002,
    ["Zerg 7 - Support Town"] = 1933013594,
    ["Zerg 8 - Scout Town"] = 947021146,
    ["Zerg 8 - Templar Town"] = 1412982106,
    ["Zerg 9 - Teal Protoss"] = 963798362,
    ["Zerg 9 - Left Yellow Protoss"] = 2037135706,
    ["Zerg 9 - Right Yellow Protoss"] = 2037528922,
    ["Zerg 9 - Left Orange Protoss"] = 1869363546,
    ["Zerg 9 - Right Orange Protoss"] = 1869756762,
    ["Zerg 10 - Left Teal (Attack"] = 1630548314,
    ["Zerg 10 - Right Teal (Support"] = 1647325530,
    ["Zerg 10 - Left Yellow (Support"] = 1664102746,
    ["Zerg 10 - Right Yellow (Attack"] = 1680879962,
    ["Zerg 10 - Red Protoss"] = 1697657178,
    ["Protoss 1 - Zerg Town"] = 829387344,
    ["Protoss 2 - Zerg Town"] = 846164560,
    ["Protoss 3 - Air Zerg Town"] = 1379103312,
    ["Protoss 3 - Ground Zerg Town"] = 1194553936,
    ["Protoss 4 - Zerg Town"] = 879718992,
    ["Protoss 5 - Zerg Town Island"] = 1228239440,
    ["Protoss 5 - Zerg Town Base"] = 1110798928,
    ["Protoss 7 - Left Protoss Town"] = 930050640,
    ["Protoss 7 - Right Protoss Town"] = 1110930000,
    ["Protoss 7 - Shrine Protoss"] = 1396142672,
    ["Protoss 8 - Left Protoss Town"] = 946827856,
    ["Protoss 8 - Right Protoss Town"] = 1110995536,
    ["Protoss 8 - Protoss Defenders"] = 1144549968,
    ["Protoss 9 - Ground Zerg"] = 963605072,
    ["Protoss 9 - Air Zerg"] = 1463382608,
    ["Protoss 9 - Spell Zerg"] = 1496937040,
    ["Protoss 10 - Mini-Towns"] = 808546896,
    ["Protoss 10 - Mini-Town Master"] = 1127231824,
    ["Protoss 10 - Overmind Defenders"] = 1865429328,
    ["Brood Wars Protoss 1 - Town A"] = 1093747280,
    ["Brood Wars Protoss 1 - Town B"] = 1110524496,
    ["Brood Wars Protoss 1 - Town C"] = 1127301712,
    ["Brood Wars Protoss 1 - Town D"] = 1144078928,
    ["Brood Wars Protoss 1 - Town E"] = 1160856144,
    ["Brood Wars Protoss 1 - Town F"] = 1177633360,
    ["Brood Wars Protoss 2 - Town A"] = 1093812816,
    ["Brood Wars Protoss 2 - Town B"] = 1110590032,
    ["Brood Wars Protoss 2 - Town C"] = 1127367248,
    ["Brood Wars Protoss 2 - Town D"] = 1144144464,
    ["Brood Wars Protoss 2 - Town E"] = 1160921680,
    ["Brood Wars Protoss 2 - Town F"] = 1177698896,
    ["Brood Wars Protoss 3 - Town A"] = 1093878352,
    ["Brood Wars Protoss 3 - Town B"] = 1110655568,
    ["Brood Wars Protoss 3 - Town C"] = 1127432784,
    ["Brood Wars Protoss 3 - Town D"] = 1144210000,
    ["Brood Wars Protoss 3 - Town E"] = 1160987216,
    ["Brood Wars Protoss 3 - Town F"] = 1177764432,
    ["Brood Wars Protoss 4 - Town A"] = 1093943888,
    ["Brood Wars Protoss 4 - Town B"] = 1110721104,
    ["Brood Wars Protoss 4 - Town C"] = 1127498320,
    ["Brood Wars Protoss 4 - Town D"] = 1144275536,
    ["Brood Wars Protoss 4 - Town E"] = 1161052752,
    ["Brood Wars Protoss 4 - Town F"] = 1177829968,
    ["Brood Wars Protoss 5 - Town A"] = 1094009424,
    ["Brood Wars Protoss 5 - Town B"] = 1110786640,
    ["Brood Wars Protoss 5 - Town C"] = 1127563856,
    ["Brood Wars Protoss 5 - Town D"] = 1144341072,
    ["Brood Wars Protoss 5 - Town E"] = 1161118288,
    ["Brood Wars Protoss 5 - Town F"] = 1177895504,
    ["Brood Wars Protoss 6 - Town A"] = 1094074960,
    ["Brood Wars Protoss 6 - Town B"] = 1110852176,
    ["Brood Wars Protoss 6 - Town C"] = 1127629392,
    ["Brood Wars Protoss 6 - Town D"] = 1144406608,
    ["Brood Wars Protoss 6 - Town E"] = 1161183824,
    ["Brood Wars Protoss 6 - Town F"] = 1177961040,
    ["Brood Wars Protoss 7 - Town A"] = 1094140496,
    ["Brood Wars Protoss 7 - Town B"] = 1110917712,
    ["Brood Wars Protoss 7 - Town C"] = 1127694928,
    ["Brood Wars Protoss 7 - Town D"] = 1144472144,
    ["Brood Wars Protoss 7 - Town E"] = 1161249360,
    ["Brood Wars Protoss 7 - Town F"] = 1178026576,
    ["Brood Wars Protoss 8 - Town A"] = 1094206032,
    ["Brood Wars Protoss 8 - Town B"] = 1110983248,
    ["Brood Wars Protoss 8 - Town C"] = 1127760464,
    ["Brood Wars Protoss 8 - Town D"] = 1144537680,
    ["Brood Wars Protoss 8 - Town E"] = 1161314896,
    ["Brood Wars Protoss 8 - Town F"] = 1178092112,
    ["Brood Wars Terran 1 - Town A"] = 1093747284,
    ["Brood Wars Terran 1 - Town B"] = 1110524500,
    ["Brood Wars Terran 1 - Town C"] = 1127301716,
    ["Brood Wars Terran 1 - Town D"] = 1144078932,
    ["Brood Wars Terran 1 - Town E"] = 1160856148,
    ["Brood Wars Terran 1 - Town F"] = 1177633364,
    ["Brood Wars Terran 2 - Town A"] = 1093812820,
    ["Brood Wars Terran 2 - Town B"] = 1110590036,
    ["Brood Wars Terran 2 - Town C"] = 1127367252,
    ["Brood Wars Terran 2 - Town D"] = 1144144468,
    ["Brood Wars Terran 2 - Town E"] = 1160921684,
    ["Brood Wars Terran 2 - Town F"] = 1177698900,
    ["Brood Wars Terran 3 - Town A"] = 1093878356,
    ["Brood Wars Terran 3 - Town B"] = 1110655572,
    ["Brood Wars Terran 3 - Town C"] = 1127432788,
    ["Brood Wars Terran 3 - Town D"] = 1144210004,
    ["Brood Wars Terran 3 - Town E"] = 1160987220,
    ["Brood Wars Terran 3 - Town F"] = 1177764436,
    ["Brood Wars Terran 4 - Town A"] = 1093943892,
    ["Brood Wars Terran 4 - Town B"] = 1110721108,
    ["Brood Wars Terran 4 - Town C"] = 1127498324,
    ["Brood Wars Terran 4 - Town D"] = 1144275540,
    ["Brood Wars Terran 4 - Town E"] = 1161052756,
    ["Brood Wars Terran 4 - Town F"] = 1177829972,
    ["Brood Wars Terran 5 - Town A"] = 1094009428,
    ["Brood Wars Terran 5 - Town B"] = 1110786644,
    ["Brood Wars Terran 5 - Town C"] = 1127563860,
    ["Brood Wars Terran 5 - Town D"] = 1144341076,
    ["Brood Wars Terran 5 - Town E"] = 1161118292,
    ["Brood Wars Terran 5 - Town F"] = 1177895508,
    ["Brood Wars Terran 6 - Town A"] = 1094074964,
    ["Brood Wars Terran 6 - Town B"] = 1110852180,
    ["Brood Wars Terran 6 - Town C"] = 1127629396,
    ["Brood Wars Terran 6 - Town D"] = 1144406612,
    ["Brood Wars Terran 6 - Town E"] = 1161183828,
    ["Brood Wars Terran 6 - Town F"] = 1177961044,
    ["Brood Wars Terran 7 - Town A"] = 1094140500,
    ["Brood Wars Terran 7 - Town B"] = 1110917716,
    ["Brood Wars Terran 7 - Town C"] = 1127694932,
    ["Brood Wars Terran 7 - Town D"] = 1144472148,
    ["Brood Wars Terran 7 - Town E"] = 1161249364,
    ["Brood Wars Terran 7 - Town F"] = 1178026580,
    ["Brood Wars Terran 8 - Town A"] = 1094206036,
    ["Brood Wars Terran 8 - Town B"] = 1110983252,
    ["Brood Wars Terran 8 - Town C"] = 1127760468,
    ["Brood Wars Terran 8 - Town D"] = 1144537684,
    ["Brood Wars Terran 8 - Town E"] = 1161314900,
    ["Brood Wars Terran 8 - Town F"] = 1178092116,
    ["Brood Wars Zerg 1 - Town A"] = 1093747290,
    ["Brood Wars Zerg 1 - Town B"] = 1110524506,
    ["Brood Wars Zerg 1 - Town C"] = 1127301722,
    ["Brood Wars Zerg 1 - Town D"] = 1144078938,
    ["Brood Wars Zerg 1 - Town E"] = 1160856154,
    ["Brood Wars Zerg 1 - Town F"] = 1177633370,
    ["Brood Wars Zerg 2 - Town A"] = 1093812826,
    ["Brood Wars Zerg 2 - Town B"] = 1110590042,
    ["Brood Wars Zerg 2 - Town C"] = 1127367258,
    ["Brood Wars Zerg 2 - Town D"] = 1144144474,
    ["Brood Wars Zerg 2 - Town E"] = 1160921690,
    ["Brood Wars Zerg 2 - Town F"] = 1177698906,
    ["Brood Wars Zerg 3 - Town A"] = 1093878362,
    ["Brood Wars Zerg 3 - Town B"] = 1110655578,
    ["Brood Wars Zerg 3 - Town C"] = 1127432794,
    ["Brood Wars Zerg 3 - Town D"] = 1144210010,
    ["Brood Wars Zerg 3 - Town E"] = 1160987226,
    ["Brood Wars Zerg 3 - Town F"] = 1177764442,
    ["Brood Wars Zerg 4 - Town A"] = 1093943898,
    ["Brood Wars Zerg 4 - Town B"] = 1110721114,
    ["Brood Wars Zerg 4 - Town C"] = 1127498330,
    ["Brood Wars Zerg 4 - Town D"] = 1144275546,
    ["Brood Wars Zerg 4 - Town E"] = 1161052762,
    ["Brood Wars Zerg 4 - Town F"] = 1177829978,
    ["Brood Wars Zerg 5 - Town A"] = 1094009434,
    ["Brood Wars Zerg 5 - Town B"] = 1110786650,
    ["Brood Wars Zerg 5 - Town C"] = 1127563866,
    ["Brood Wars Zerg 5 - Town D"] = 1144341082,
    ["Brood Wars Zerg 5 - Town E"] = 1161118298,
    ["Brood Wars Zerg 5 - Town F"] = 1177895514,
    ["Brood Wars Zerg 6 - Town A"] = 1094074970,
    ["Brood Wars Zerg 6 - Town B"] = 1110852186,
    ["Brood Wars Zerg 6 - Town C"] = 1127629402,
    ["Brood Wars Zerg 6 - Town D"] = 1144406618,
    ["Brood Wars Zerg 6 - Town E"] = 1161183834,
    ["Brood Wars Zerg 6 - Town F"] = 1177961050,
    ["Brood Wars Zerg 7 - Town A"] = 1094140506,
    ["Brood Wars Zerg 7 - Town B"] = 1110917722,
    ["Brood Wars Zerg 7 - Town C"] = 1127694938,
    ["Brood Wars Zerg 7 - Town D"] = 1144472154,
    ["Brood Wars Zerg 7 - Town E"] = 1161249370,
    ["Brood Wars Zerg 7 - Town F"] = 1178026586,
    ["Brood Wars Zerg 8 - Town A"] = 1094206042,
    ["Brood Wars Zerg 8 - Town B"] = 1110983258,
    ["Brood Wars Zerg 8 - Town C"] = 1127760474,
    ["Brood Wars Zerg 8 - Town D"] = 1144537690,
    ["Brood Wars Zerg 8 - Town E"] = 1161314906,
    ["Brood Wars Zerg 8 - Town F"] = 1178092122,
    ["Brood Wars Zerg 9 - Town A"] = 1094271578,
    ["Brood Wars Zerg 9 - Town B"] = 1111048794,
    ["Brood Wars Zerg 9 - Town C"] = 1127826010,
    ["Brood Wars Zerg 9 - Town D"] = 1144603226,
    ["Brood Wars Zerg 9 - Town E"] = 1161380442,
    ["Brood Wars Zerg 9 - Town F"] = 1178157658,
    ["Brood Wars Zerg 10 - Town A"] = 1093681754,
    ["Brood Wars Zerg 10 - Town B"] = 1110458970,
    ["Brood Wars Zerg 10 - Town C"] = 1127236186,
    ["Brood Wars Zerg 10 - Town D"] = 1144013402,
    ["Brood Wars Zerg 10 - Town E"] = 1160790618,
    ["Brood Wars Zerg 10 - Town F"] = 1177567834,
}




local function ParseConst(d, s)
    local val = d[s]
    if val == nil then
        return s
    else
        return val
    end
end


function ParseAllyStatus(s)
    return ParseConst(AllyStatusDict, s)
end


function ParseComparison(s)
    return ParseConst(ComparisonDict, s)
end


function ParseModifier(s)
    return ParseConst(ModifierDict, s)
end


function ParseOrder(s)
    return ParseConst(OrderDict, s)
end


function ParsePlayer(s)
    return ParseConst(PlayerDict, s)
end


function ParsePropState(s)
    return ParseConst(PropStateDict, s)
end


function ParseResource(s)
    return ParseConst(ResourceDict, s)
end


function ParseScore(s)
    return ParseConst(ScoreDict, s)
end


function ParseSwitchAction(s)
    return ParseConst(SwitchActionDict, s)
end


function ParseSwitchState(s)
    return ParseConst(SwitchStateDict, s)
end


function ParseAIScript(s)
    return ParseConst(AIScriptDict, s)
end


function ParseCount(s)
    if s == All then
        return 0
    else
        return s
    end
end
  �D      ��
 ���    0         local AllyStatusDict = {
    [0] = "Enemy",
    [1] = "Ally",
    [2] = "AlliedVictory",
}

local ComparisonDict = {
    [0] = "AtLeast",
    [1] = "AtMost",
    [10] = "Exactly",
}

local ModifierDict = {
    [7] = "SetTo",
    [8] = "Add",
    [9] = "Subtract",
}

local OrderDict = {
    [0] = "Move",
    [1] = "Patrol",
    [2] = "Attack",
}

local PlayerDict = {
    [0] = "P1",
    [1] = "P2",
    [2] = "P3",
    [3] = "P4",
    [4] = "P5",
    [5] = "P6",
    [6] = "P7",
    [7] = "P8",
    [8] = "P9",
    [9] = "P10",
    [10] = "P11",
    [11] = "P12",
    [13] = "CurrentPlayer",
    [14] = "Foes",
    [15] = "Allies",
    [16] = "NeutralPlayers",
    [17] = "AllPlayers",
    [18] = "Force1",
    [19] = "Force2",
    [20] = "Force3",
    [21] = "Force4",
    [26] = "NonAlliedVictoryPlayers",
}

local PropStateDict = {
    [4] = "Enable",
    [5] = "Disable",
    [6] = "Toggle",
}

local ResourceDict = {
    [0] = "Ore",
    [1] = "Gas",
    [2] = "OreAndGas",
}

local ScoreDict = {
    [0] = "Total",
    [1] = "Units",
    [2] = "Buildings",
    [3] = "UnitsAndBuildings",
    [4] = "Kills",
    [5] = "Razings",
    [6] = "KillsAndRazings",
    [7] = "Custom",
}

local SwitchActionDict = {
    [4] = "Set",
    [5] = "Clear",
    [6] = "Toggle",
    [11] = "Random",
}

local SwitchStateDict = {
    [2] = "Set",
    [3] = "Cleared",
}


local AIScriptDict = {
    [1967344980] = "Terran Custom Level",
    [1967344986] = "Zerg Custom Level",
    [1967344976] = "Protoss Custom Level",
    [2017676628] = "Terran Expansion Custom Level",
    [2017676634] = "Zerg Expansion Custom Level",
    [2017676624] = "Protoss Expansion Custom Level",
    [1716472916] = "Terran Campaign Easy",
    [1145392468] = "Terran Campaign Medium",
    [1716078676] = "Terran Campaign Difficult",
    [1347769172] = "Terran Campaign Insane",
    [1163018580] = "Terran Campaign Area Town",
    [1716472922] = "Zerg Campaign Easy",
    [1145392474] = "Zerg Campaign Medium",
    [1716078682] = "Zerg Campaign Difficult",
    [1347769178] = "Zerg Campaign Insane",
    [1163018586] = "Zerg Campaign Area Town",
    [1716472912] = "Protoss Campaign Easy",
    [1145392464] = "Protoss Campaign Medium",
    [1716078672] = "Protoss Campaign Difficult",
    [1347769168] = "Protoss Campaign Insane",
    [1163018576] = "Protoss Campaign Area Town",
    [2018462804] = "Expansion Terran Campaign Easy",
    [2017807700] = "Expansion Terran Campaign Medium",
    [2018068564] = "Expansion Terran Campaign Difficult",
    [2018857812] = "Expansion Terran Campaign Insane",
    [2018656596] = "Expansion Terran Campaign Area Town",
    [2018462810] = "Expansion Zerg Campaign Easy",
    [2017807706] = "Expansion Zerg Campaign Medium",
    [2018068570] = "Expansion Zerg Campaign Difficult",
    [2018857818] = "Expansion Zerg Campaign Insane",
    [2018656602] = "Expansion Zerg Campaign Area Town",
    [2018462800] = "Expansion Protoss Campaign Easy",
    [2017807696] = "Expansion Protoss Campaign Medium",
    [2018068560] = "Expansion Protoss Campaign Difficult",
    [2018857808] = "Expansion Protoss Campaign Insane",
    [2018656592] = "Expansion Protoss Campaign Area Town",
    [1667855699] = "Send All Units on Strategic Suicide Missions",
    [1382643027] = "Send All Units on Random Suicide Missions",
    [1969451858] = "Switch Computer Player to Rescue Passive",
    [812209707] = "Turn ON Shared Vision for Player 1",
    [828986923] = "Turn ON Shared Vision for Player 2",
    [845764139] = "Turn ON Shared Vision for Player 3",
    [862541355] = "Turn ON Shared Vision for Player 4",
    [879318571] = "Turn ON Shared Vision for Player 5",
    [896095787] = "Turn ON Shared Vision for Player 6",
    [912873003] = "Turn ON Shared Vision for Player 7",
    [929650219] = "Turn ON Shared Vision for Player 8",
    [812209709] = "Turn OFF Shared Vision for Player 1",
    [828986925] = "Turn OFF Shared Vision for Player 2",
    [845764141] = "Turn OFF Shared Vision for Player 3",
    [862541357] = "Turn OFF Shared Vision for Player 4",
    [879318573] = "Turn OFF Shared Vision for Player 5",
    [896095789] = "Turn OFF Shared Vision for Player 6",
    [912873005] = "Turn OFF Shared Vision for Player 7",
    [929650221] = "Turn OFF Shared Vision for Player 8",
    [1700034125] = "Move Dark Templars to Region",
    [1131572291] = "Clear Previous Combat Data",
    [2037214789] = "Set Player to Enemy",
    [2037148737] = "Set Player to Ally  ",
    [1098214486] = "Value This Area Higher",
    [1799515717] = "Enter Closest Bunker",
    [1733588051] = "Set Generic Command Target",
    [1951429715] = "Make These Units Patrol",
    [1918135877] = "Enter Transport",
    [1918138437] = "Exit Transport",
    [1699247438] = "AI Nuke Here",
    [1699242312] = "AI Harass Here",
    [1732532554] = "Set Unit Order To: Junk Yard Dog",
    [1699239748] = "Disruption Web Here",
    [1699243346] = "Recall Here",
    [863135060] = "Terran 3 - Zerg Town",
    [896689492] = "Terran 5 - Terran Main Town",
    [1211458900] = "Terran 5 - Terran Harvest Town",
    [913466708] = "Terran 6 - Air Attack Zerg",
    [1647732052] = "Terran 6 - Ground Attack Zerg",
    [1664509268] = "Terran 6 - Zerg Support Town",
    [930243924] = "Terran 7 - Bottom Zerg Town",
    [1933010260] = "Terran 7 - Right Zerg Town",
    [1832346964] = "Terran 7 - Middle Zerg Town",
    [947021140] = "Terran 8 - Confederate Town",
    [1278833236] = "Terran 9 - Light Attack",
    [1211724372] = "Terran 9 - Heavy Attack",
    [808543572] = "Terran 10 - Confederate Towns",
    [2050044244] = "Terran 11 - Zerg Town",
    [1630613844] = "Terran 11 - Lower Protoss Town",
    [1647391060] = "Terran 11 - Upper Protoss Town",
    [1311912276] = "Terran 12 - Nuke Town",
    [1345466708] = "Terran 12 - Phoenix Town",
    [1412575572] = "Terran 12 - Tank Town",
    [826557780] = "Terran 1 - Electronic Distribution",
    [843334996] = "Terran 2 - Electronic Distribution",
    [860112212] = "Terran 3 - Electronic Distribution",
    [827806548] = "Terran 1 - Shareware",
    [844583764] = "Terran 2 - Shareware",
    [861360980] = "Terran 3 - Shareware",
    [878138196] = "Terran 4 - Shareware",
    [894915412] = "Terran 5 - Shareware",
    [829580634] = "Zerg 1 - Terran Town",
    [846357850] = "Zerg 2 - Protoss Town",
    [863135066] = "Zerg 3 - Terran Town",
    [879912282] = "Zerg 4 - Right Terran Town",
    [1395942746] = "Zerg 4 - Lower Terran Town",
    [913466714] = "Zerg 6 - Protoss Town",
    [1631023706] = "Zerg 7 - Air Town",
    [1731687002] = "Zerg 7 - Ground Town",
    [1933013594] = "Zerg 7 - Support Town",
    [947021146] = "Zerg 8 - Scout Town",
    [1412982106] = "Zerg 8 - Templar Town",
    [963798362] = "Zerg 9 - Teal Protoss",
    [2037135706] = "Zerg 9 - Left Yellow Protoss",
    [2037528922] = "Zerg 9 - Right Yellow Protoss",
    [1869363546] = "Zerg 9 - Left Orange Protoss",
    [1869756762] = "Zerg 9 - Right Orange Protoss",
    [1630548314] = "Zerg 10 - Left Teal (Attack",
    [1647325530] = "Zerg 10 - Right Teal (Support",
    [1664102746] = "Zerg 10 - Left Yellow (Support",
    [1680879962] = "Zerg 10 - Right Yellow (Attack",
    [1697657178] = "Zerg 10 - Red Protoss",
    [829387344] = "Protoss 1 - Zerg Town",
    [846164560] = "Protoss 2 - Zerg Town",
    [1379103312] = "Protoss 3 - Air Zerg Town",
    [1194553936] = "Protoss 3 - Ground Zerg Town",
    [879718992] = "Protoss 4 - Zerg Town",
    [1228239440] = "Protoss 5 - Zerg Town Island",
    [1110798928] = "Protoss 5 - Zerg Town Base",
    [930050640] = "Protoss 7 - Left Protoss Town",
    [1110930000] = "Protoss 7 - Right Protoss Town",
    [1396142672] = "Protoss 7 - Shrine Protoss",
    [946827856] = "Protoss 8 - Left Protoss Town",
    [1110995536] = "Protoss 8 - Right Protoss Town",
    [1144549968] = "Protoss 8 - Protoss Defenders",
    [963605072] = "Protoss 9 - Ground Zerg",
    [1463382608] = "Protoss 9 - Air Zerg",
    [1496937040] = "Protoss 9 - Spell Zerg",
    [808546896] = "Protoss 10 - Mini-Towns",
    [1127231824] = "Protoss 10 - Mini-Town Master",
    [1865429328] = "Protoss 10 - Overmind Defenders",
    [1093747280] = "Brood Wars Protoss 1 - Town A",
    [1110524496] = "Brood Wars Protoss 1 - Town B",
    [1127301712] = "Brood Wars Protoss 1 - Town C",
    [1144078928] = "Brood Wars Protoss 1 - Town D",
    [1160856144] = "Brood Wars Protoss 1 - Town E",
    [1177633360] = "Brood Wars Protoss 1 - Town F",
    [1093812816] = "Brood Wars Protoss 2 - Town A",
    [1110590032] = "Brood Wars Protoss 2 - Town B",
    [1127367248] = "Brood Wars Protoss 2 - Town C",
    [1144144464] = "Brood Wars Protoss 2 - Town D",
    [1160921680] = "Brood Wars Protoss 2 - Town E",
    [1177698896] = "Brood Wars Protoss 2 - Town F",
    [1093878352] = "Brood Wars Protoss 3 - Town A",
    [1110655568] = "Brood Wars Protoss 3 - Town B",
    [1127432784] = "Brood Wars Protoss 3 - Town C",
    [1144210000] = "Brood Wars Protoss 3 - Town D",
    [1160987216] = "Brood Wars Protoss 3 - Town E",
    [1177764432] = "Brood Wars Protoss 3 - Town F",
    [1093943888] = "Brood Wars Protoss 4 - Town A",
    [1110721104] = "Brood Wars Protoss 4 - Town B",
    [1127498320] = "Brood Wars Protoss 4 - Town C",
    [1144275536] = "Brood Wars Protoss 4 - Town D",
    [1161052752] = "Brood Wars Protoss 4 - Town E",
    [1177829968] = "Brood Wars Protoss 4 - Town F",
    [1094009424] = "Brood Wars Protoss 5 - Town A",
    [1110786640] = "Brood Wars Protoss 5 - Town B",
    [1127563856] = "Brood Wars Protoss 5 - Town C",
    [1144341072] = "Brood Wars Protoss 5 - Town D",
    [1161118288] = "Brood Wars Protoss 5 - Town E",
    [1177895504] = "Brood Wars Protoss 5 - Town F",
    [1094074960] = "Brood Wars Protoss 6 - Town A",
    [1110852176] = "Brood Wars Protoss 6 - Town B",
    [1127629392] = "Brood Wars Protoss 6 - Town C",
    [1144406608] = "Brood Wars Protoss 6 - Town D",
    [1161183824] = "Brood Wars Protoss 6 - Town E",
    [1177961040] = "Brood Wars Protoss 6 - Town F",
    [1094140496] = "Brood Wars Protoss 7 - Town A",
    [1110917712] = "Brood Wars Protoss 7 - Town B",
    [1127694928] = "Brood Wars Protoss 7 - Town C",
    [1144472144] = "Brood Wars Protoss 7 - Town D",
    [1161249360] = "Brood Wars Protoss 7 - Town E",
    [1178026576] = "Brood Wars Protoss 7 - Town F",
    [1094206032] = "Brood Wars Protoss 8 - Town A",
    [1110983248] = "Brood Wars Protoss 8 - Town B",
    [1127760464] = "Brood Wars Protoss 8 - Town C",
    [1144537680] = "Brood Wars Protoss 8 - Town D",
    [1161314896] = "Brood Wars Protoss 8 - Town E",
    [1178092112] = "Brood Wars Protoss 8 - Town F",
    [1093747284] = "Brood Wars Terran 1 - Town A",
    [1110524500] = "Brood Wars Terran 1 - Town B",
    [1127301716] = "Brood Wars Terran 1 - Town C",
    [1144078932] = "Brood Wars Terran 1 - Town D",
    [1160856148] = "Brood Wars Terran 1 - Town E",
    [1177633364] = "Brood Wars Terran 1 - Town F",
    [1093812820] = "Brood Wars Terran 2 - Town A",
    [1110590036] = "Brood Wars Terran 2 - Town B",
    [1127367252] = "Brood Wars Terran 2 - Town C",
    [1144144468] = "Brood Wars Terran 2 - Town D",
    [1160921684] = "Brood Wars Terran 2 - Town E",
    [1177698900] = "Brood Wars Terran 2 - Town F",
    [1093878356] = "Brood Wars Terran 3 - Town A",
    [1110655572] = "Brood Wars Terran 3 - Town B",
    [1127432788] = "Brood Wars Terran 3 - Town C",
    [1144210004] = "Brood Wars Terran 3 - Town D",
    [1160987220] = "Brood Wars Terran 3 - Town E",
    [1177764436] = "Brood Wars Terran 3 - Town F",
    [1093943892] = "Brood Wars Terran 4 - Town A",
    [1110721108] = "Brood Wars Terran 4 - Town B",
    [1127498324] = "Brood Wars Terran 4 - Town C",
    [1144275540] = "Brood Wars Terran 4 - Town D",
    [1161052756] = "Brood Wars Terran 4 - Town E",
    [1177829972] = "Brood Wars Terran 4 - Town F",
    [1094009428] = "Brood Wars Terran 5 - Town A",
    [1110786644] = "Brood Wars Terran 5 - Town B",
    [1127563860] = "Brood Wars Terran 5 - Town C",
    [1144341076] = "Brood Wars Terran 5 - Town D",
    [1161118292] = "Brood Wars Terran 5 - Town E",
    [1177895508] = "Brood Wars Terran 5 - Town F",
    [1094074964] = "Brood Wars Terran 6 - Town A",
    [1110852180] = "Brood Wars Terran 6 - Town B",
    [1127629396] = "Brood Wars Terran 6 - Town C",
    [1144406612] = "Brood Wars Terran 6 - Town D",
    [1161183828] = "Brood Wars Terran 6 - Town E",
    [1177961044] = "Brood Wars Terran 6 - Town F",
    [1094140500] = "Brood Wars Terran 7 - Town A",
    [1110917716] = "Brood Wars Terran 7 - Town B",
    [1127694932] = "Brood Wars Terran 7 - Town C",
    [1144472148] = "Brood Wars Terran 7 - Town D",
    [1161249364] = "Brood Wars Terran 7 - Town E",
    [1178026580] = "Brood Wars Terran 7 - Town F",
    [1094206036] = "Brood Wars Terran 8 - Town A",
    [1110983252] = "Brood Wars Terran 8 - Town B",
    [1127760468] = "Brood Wars Terran 8 - Town C",
    [1144537684] = "Brood Wars Terran 8 - Town D",
    [1161314900] = "Brood Wars Terran 8 - Town E",
    [1178092116] = "Brood Wars Terran 8 - Town F",
    [1093747290] = "Brood Wars Zerg 1 - Town A",
    [1110524506] = "Brood Wars Zerg 1 - Town B",
    [1127301722] = "Brood Wars Zerg 1 - Town C",
    [1144078938] = "Brood Wars Zerg 1 - Town D",
    [1160856154] = "Brood Wars Zerg 1 - Town E",
    [1177633370] = "Brood Wars Zerg 1 - Town F",
    [1093812826] = "Brood Wars Zerg 2 - Town A",
    [1110590042] = "Brood Wars Zerg 2 - Town B",
    [1127367258] = "Brood Wars Zerg 2 - Town C",
    [1144144474] = "Brood Wars Zerg 2 - Town D",
    [1160921690] = "Brood Wars Zerg 2 - Town E",
    [1177698906] = "Brood Wars Zerg 2 - Town F",
    [1093878362] = "Brood Wars Zerg 3 - Town A",
    [1110655578] = "Brood Wars Zerg 3 - Town B",
    [1127432794] = "Brood Wars Zerg 3 - Town C",
    [1144210010] = "Brood Wars Zerg 3 - Town D",
    [1160987226] = "Brood Wars Zerg 3 - Town E",
    [1177764442] = "Brood Wars Zerg 3 - Town F",
    [1093943898] = "Brood Wars Zerg 4 - Town A",
    [1110721114] = "Brood Wars Zerg 4 - Town B",
    [1127498330] = "Brood Wars Zerg 4 - Town C",
    [1144275546] = "Brood Wars Zerg 4 - Town D",
    [1161052762] = "Brood Wars Zerg 4 - Town E",
    [1177829978] = "Brood Wars Zerg 4 - Town F",
    [1094009434] = "Brood Wars Zerg 5 - Town A",
    [1110786650] = "Brood Wars Zerg 5 - Town B",
    [1127563866] = "Brood Wars Zerg 5 - Town C",
    [1144341082] = "Brood Wars Zerg 5 - Town D",
    [1161118298] = "Brood Wars Zerg 5 - Town E",
    [1177895514] = "Brood Wars Zerg 5 - Town F",
    [1094074970] = "Brood Wars Zerg 6 - Town A",
    [1110852186] = "Brood Wars Zerg 6 - Town B",
    [1127629402] = "Brood Wars Zerg 6 - Town C",
    [1144406618] = "Brood Wars Zerg 6 - Town D",
    [1161183834] = "Brood Wars Zerg 6 - Town E",
    [1177961050] = "Brood Wars Zerg 6 - Town F",
    [1094140506] = "Brood Wars Zerg 7 - Town A",
    [1110917722] = "Brood Wars Zerg 7 - Town B",
    [1127694938] = "Brood Wars Zerg 7 - Town C",
    [1144472154] = "Brood Wars Zerg 7 - Town D",
    [1161249370] = "Brood Wars Zerg 7 - Town E",
    [1178026586] = "Brood Wars Zerg 7 - Town F",
    [1094206042] = "Brood Wars Zerg 8 - Town A",
    [1110983258] = "Brood Wars Zerg 8 - Town B",
    [1127760474] = "Brood Wars Zerg 8 - Town C",
    [1144537690] = "Brood Wars Zerg 8 - Town D",
    [1161314906] = "Brood Wars Zerg 8 - Town E",
    [1178092122] = "Brood Wars Zerg 8 - Town F",
    [1094271578] = "Brood Wars Zerg 9 - Town A",
    [1111048794] = "Brood Wars Zerg 9 - Town B",
    [1127826010] = "Brood Wars Zerg 9 - Town C",
    [1144603226] = "Brood Wars Zerg 9 - Town D",
    [1161380442] = "Brood Wars Zerg 9 - Town E",
    [1178157658] = "Brood Wars Zerg 9 - Town F",
    [1093681754] = "Brood Wars Zerg 10 - Town A",
    [1110458970] = "Brood Wars Zerg 10 - Town B",
    [1127236186] = "Brood Wars Zerg 10 - Town C",
    [1144013402] = "Brood Wars Zerg 10 - Town D",
    [1160790618] = "Brood Wars Zerg 10 - Town E",
    [1177567834] = "Brood Wars Zerg 10 - Town F",
}




local function DecodeConst(d, i)
    local val = d[i]
    if val == nil then
        return tostring(i)
    else
        return val
    end
end


function DecodeAllyStatus(d)
    return DecodeConst(AllyStatusDict, d)
end


function DecodeComparison(d)
    return DecodeConst(ComparisonDict, d)
end


function DecodeModifier(d)
    return DecodeConst(ModifierDict, d)
end


function DecodeOrder(d)
    return DecodeConst(OrderDict, d)
end


function DecodePlayer(d)
    return DecodeConst(PlayerDict, d)
end


function DecodePropState(d)
    return DecodeConst(PropStateDict, d)
end


function DecodeResource(d)
    return DecodeConst(ResourceDict, d)
end


function DecodeScore(d)
    return DecodeConst(ScoreDict, d)
end


function DecodeSwitchAction(d)
    return DecodeConst(SwitchActionDict, d)
end


function DecodeSwitchState(d)
    return DecodeConst(SwitchStateDict, d)
end


function DecodeAIScript(d)
    return DecodeConst(AIScriptDict, d)
end


function DecodeCount(d)
    if d == 0 then
        return "All"
    else
        return "0"
    end
end
�       ��
 ���    0         function TEPComment(str)
	local callerLine = debug.getinfo(2).currentline
	__internal__AddSpecialData(callerLine, 0x9b0a58d8, str)
end
 �      �� ���    0             F i l e     tC o m p i l e 	 F 5     }C o m p i l e   N o n a g 	 C t r l + S   � uE x i t 	 A l t + F 4    E d i t     qF i n d 	 C t r l + F     rR e p l a c e 	 C t r l + H         � xN e w   t r i g g e r 	 C t r l + T    V i e w     zF o l d   A l l 	 C t r l + S h i f t + F   � {U n f o l d   A l l 	 C t r l + S h i f t + D   � H e l p     vT r i g g e r   s y n t a x 	 F 1     wA b o u t   T r i g E d i t P l u s         � yL i c e n s e s   H       ��	 ���    0          & �   ( �   F q   H r   T x   t t   S }   F z  � D {  