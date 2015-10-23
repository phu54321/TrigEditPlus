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

function RegisterConditionHook(condtypelist, f, priority)
    condtypelist = FlattenList(condtypelist)
    local condkey = condtypelist[1]
    if conditionhooks[condkey] == nil then
        conditionhooks[condkey] = {}
    end
    table.insert(conditionhooks[condkey], {condtypelist, f, priority})
end

function RegisterActionHook(acttypelist, f, priority)
    acttypelist = FlattenList(acttypelist)
    local actkey = acttypelist[1]
    if actionhooks[actkey] == nil then
        actionhooks[actkey] = {}
    end
    table.insert(actionhooks[actkey], {acttypelist, f, priority})
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


function DecodeConditions(condlist)
    local condtypelist = {}
    for i = 1, #condlist do
        condtypelist[i] = condlist[i][6]
    end
    return ProcessHooks(conditionhooks, condlist, condtypelist)
end


function DecodeActions(actlist)
    local acttypelist = {}
    for i = 1, #actlist do
        acttypelist[i] = actlist[i][8]
    end
    return ProcessHooks(actionhooks, actlist, acttypelist)
end


local function ProcessHooks(hooklist, entrylist, typelist)
    local i, typelistlen = 1, #typelist
    local retlist = {}

    while i <= typelistlen
        local keytype = typelist[i]
        local appliable_hooks = hooklist[keytype]
        local hook_applied = false
        if appliable_hooks ~= nil then
            for j = 1, #appliable_hooks do
                local hook_typelist, hook_f = appliable_hooks[j]
                local hook_typelistlen = hook_typelistlen

                -- Optimize for 1-length typelisted hook
                if hook_typelistlen == 1 then
                    local retstr = hook_f({entrylist[i]})
                    if retstr then
                        retlist[i] = retstr[1]
                        i = i + 1
                        hook_applied = true
                        break
                    end

                -- Hook is short enough to be appliable
                else if hook_typelistlen + i < typelistlen then
                    -- Check types
                    local accepted = true
                    for k = 2, hook_typelistlen do
                        if typelist[i + k - 1] ~= hook_typelist[k] then
                            accepted = false
                            break
                        end
                    end

                    if accepted then
                        local subentrylist = {}
                        for k = 1, hook_typelistlen do
                            subentrylist[k] = entrylist[i + k - 1]
                        end

                        local retstr = hook_f(subentrylist)
                        if retstr then
                            for k = 1, hook_typelistlen do
                                retlist[i + k - 1] = retstr[k]
                            end
                            i = i + hook_typelistlen
                            hook_applied = true
                            break
                        end
                    end
                end
            end
        end
        if not hook_applied then
            i = i + 1
        end
    end
end

