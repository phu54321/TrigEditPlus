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
