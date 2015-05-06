-- debugger
-- lua报错显示，日志打印
local mEnableLog = true
local mEnableLogDebug = false

local debugger = {}

local debuggerGroup = {}

function debugger.enableGroup(groupName)
    debuggerGroup[groupName] = true
end

function debugger.disableGroup(groupName)
    debuggerGroup[groupName] = false
end

function debugger.glog(group, ...)
    if debuggerGroup[group] then
        debugger.log(...)
    end
end

function debugger.glogd(group, ...)
    if debuggerGroup[group] then
        debugger.logd(...)
    end
end

--配置log打印规则
--isEnableLog       允许debugger.log输出
--isEnalbeLogDebug  允许debugger.logd debugger.logdStr打印
function debugger.configLog(isEnableLog, isEnalbeLogDebug)
    mEnableLog = isEnableLog
    mEnableLogDebug = isEnalbeLogDebug
end

function debugger.log(...)
    if mEnableLog then
        print(string.format(...))
    end
end

function debugger.logd(...)
    if mEnableLogDebug then
        print(string.format(...))
    end
end

function debugger.logdStr(str)
    if mEnableLogDebug then
        print(str)
    end
end

function debugger.traceStack(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

function debugger.dumpTextures()
    CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end

function debugger.dumpTable(tb, level)
    if not mEnableLogDebug then return end

    level = level or 0
    for k,v in pairs(tb) do
        local strlv = ''
        for i = 0,level do
            strlv = strlv .. '-'
        end
        if type(v)=='table' then
            debugger.logd(strlv .. k)
            debugger.dumpTable(v, level+1)
        elseif type(v)=='function' then
            return
        else
            debugger.logd(strlv .. k .. ' = ' ..v)
        end
    end
end

function debugger.showFPS(isShow)
    CCDirector:sharedDirector():setDisplayStats(isShow)
end

return debugger


