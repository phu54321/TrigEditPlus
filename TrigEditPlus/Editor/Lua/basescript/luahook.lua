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

local conditionhooks = {}
local actionhooks = {}

-- Array -> Table key converter.

local function CreateArrayKey(typelist)
    return table.concat(typelist, '\0')
end

function RegisterConditionHook(condtype, f, priority)
    if conditionhooks[condtype] == nil then
        conditionhooks[condtype] = {}
    end
    table.insert(conditionhooks[condtype], {f, priority})
end

function RegisterActionHook(acttype, f, priority)
    if actionhooks[acttype] == nil then
        actionhooks[acttype] = {}
    end
    table.insert(actionhooks[acttype], {f, priority})
end


---- Hook processors

function SortHooks()
    -- Sort hooks by priority / length
    --  Longer typelist -> Has more priority
    --  Same typelist length -> Sort by priority
    local function HookSorter(lhs, rhs)
        return #(lhs[1]) > #(rhs[1]) or (#(lhs[1]) == #(rhs[1]) and lhs[3] < rhs[3])
    end

    for k, v in pairs(conditionhooks) do
        table.sort(v, HookSorter)
    end

    for k, v in pairs(actionhooks) do
        table.sort(v, HookSorter)
    end
end


local function CondActVerity(orig, ret)
    -- We only need to check whether members in orig are the same in members in ret
    for k, v in pairs(orig) do
        if ret[k] ~= v then
            return false
        end
    end
    return true
end


function ProcessConditionHooks(condition)
    return ProcessHook(conditionhooks, condition, condition[6])
end


function ProcessActionHooks(action)
    return ProcessHooks(actionhooks, action, action[8])
end


local function ProcessHooks(hooklist, entry, entrytype)
    local appliable_hooks = hooklist[entrytype]
    for j = 1, #appliable_hooks do
        local hookentry = appliable_hooks[j]
        local hook_f = hookentry[1]
        if hookentry[3] == nil then
            local retstr = hook_f(entry)
            if retstr then
                local ret_eval = load("return " .. retstr)()
                if not CondActVerity(entry, ret_eval) then
                    hookentry[3] = true;  -- Invalidate hook
                    error('Invalid Hook!')
                end
                return retstr
            end
        end
    end
    return nil
end

