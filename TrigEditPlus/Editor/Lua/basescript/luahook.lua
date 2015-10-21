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

-- Lock access to undefined variable.

-- Code snippet from http://stackoverflow.com/questions/9102931/can-lua-support-case-insensitive-method-calls

local conditionhooks = {}
local actionhooks = {}
local erroredf = {}

function RegisterConditionHook(f, condtypes)
    if condtypes == nil then
        condtypes = {0}
    else
        condtypes = FlattenList(condtypes)
    end

    for i = 1, #condtypes do
        local condtype = condtypes[i]
        if conditionhooks[condtype] == nil then
            conditionhooks[condtype] = {}
        end
        table.insert(conditionhooks[condtype], f)
    end
end

function RegisterActionHook(f, acttypes)
    if acttypes == nil then
        acttypes = {0}
    else
        acttypes = FlattenList(acttypes)
    end

    for i = 1, #acttypes do
        local acttype = acttypes[i]
        if actionhooks[acttype] == nil then
            actionhooks[acttype] = {}
        end
        table.insert(actionhooks[acttype], f)
    end
end

---- Hook processors

function ProcessHooks_Sub(beststr, bestpriority, hooklist, hookcaller, errhandler)
    for i = 1, #hooklist do
        local hookf = hooklist[i]
        if not erroredf[hookf] and not pcall(function()
            local retstr, retpriority = hookcaller(hookf)
            if retstr and retpriority > bestpriority then
                beststr, bestpriority = retstr, retpriority
            end
        end, errhandler) then
            erroredf[hookf] = true
        end
    end
    return beststr, bestpriority
end

function ProcessConditionHook(errhandler, a1, a2, a3, a4, a5, a6, a7, a8)
    local beststr, bestpriority = nil, -10000000
    
    local function hookcaller(hookfunc)
        return hookfunc(a1, a2, a3, a4, a5, a6, a7, a8)
    end

    local condtype = a6
    
    -- Process condtype-specific functions
    local ctype_hooks = conditionhooks[condtype]
    if ctype_hooks ~= nil then
        beststr, bestpriority = ProcessHooks_Sub(beststr, bestpriority, ctype_hooks, hookcaller, errhandler)
    end

    -- Process non condtype-specific functions
    local general_hooks = conditionhooks[0]
    if general_hooks ~= nil then
        beststr, bestpriority = ProcessHooks_Sub(beststr, bestpriority, general_hooks, hookcaller, errhandler)
    end
    
    return beststr  -- Nil if hook is not found, Else appropriate string
end


function ProcessActionHook(errhandler, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    local beststr, bestpriority = nil, -10000000
    
    local function hookcaller(hookfunc)
        return hookfunc(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    end

    local acttype = a8
    
    -- Process acttype-specific functions
    local atype_hooks = actionhooks[acttype]
    if atype_hooks ~= nil then
        beststr, bestpriority = ProcessHooks_Sub(beststr, bestpriority, atype_hooks, hookcaller)
    end

    -- Process non acttype-specific functions
    local general_hooks = actionhooks[0]
    if general_hooks ~= nil then
        beststr, bestpriority = ProcessHooks_Sub(beststr, bestpriority, general_hooks, hookcaller)
    end
    
    return beststr  -- Nil if hook is not found, Else appropriate string
end
 