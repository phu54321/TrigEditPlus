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

-- Code based from snippet at http://stackoverflow.com/questions/9102931/can-lua-support-case-insensitive-method-calls

__trigeditplus_mt = getmetatable(_G) or {}

__trigeditplus_mt.__newindex = function(table, key, value)
    if type(key) == "string" then
        key = key:lower()
    end
    rawset(table, key, value)
end

__trigeditplus_mt.__index = function(table, key)
    local value

    if type(key) == "string" then
        key = key:lower()
    end

    value = rawget(table, key)
    if value == nil then
        error("Attempt to access undefined variable (" .. key .. ")")
    end
    return value
end

setmetatable(_G, __trigeditplus_mt)


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
