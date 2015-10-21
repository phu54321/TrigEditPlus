---------------------------------------------------------------------------------
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
    local fun = _G[fname]
    if fun == nil or type(fun) ~= "function" then
        return
    end

    fname = debug.getinfo(fun, "n").name

    local farglist = getArgs(fun)
    return fname .. '(' .. table.concat(farglist, ", ") .. ')'
end
