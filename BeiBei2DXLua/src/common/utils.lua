------------------------------------------------------------------------------------------------------------

-- split(szFullString, szSeparator)

-- randomMat(m, n)

-- print_lua_table (lua_table, indent)

-- is2TimeInSameDay(secondsA, secondsB)

-- math["not"](y,z)
-- math["and"](x,y,z)
-- math["or"](x,y,z)
-- math["xor"](x,y,z)

-- showProgressHUD(info, native)
-- hideProgressHUD(native)

-- getDayStringForDailyStudyInfo(time)

-- onAndroidKeyPressed(node, back_func, menu_func)

------------------------------------------------------------------------------------------------------------

function randomMinN(M, N) -- random M numbers from 1 to N, N must >= M
    if N < M then
        return {}
    end
    
    math.randomseed(os.time())
    
    local randomPool = {}
    local randomPoolSize = N
    for i = 1, N do
        table.insert(randomPool, i)
    end
    
    local indexPool = {} 
    for i = 1, M do
        local randomIndex = math.random(1, randomPoolSize)
        table.insert(indexPool, randomPool[randomIndex])
        table.remove(randomPool, randomIndex)
        randomPoolSize = randomPoolSize - 1
    end
    
    return indexPool
end

function changeTableToString(wordTable)
    if #wordTable == 0 then
        return ""
    else
        local ans = wordTable[1]
        for i = 2, #wordTable do
            ans = ans .. '|' .. wordTable[i]
        end
        return ans
    end
end

function split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function randomMat(m, n)
    -- local variate
    local main_mat
    local isFindPath
    local dir
    
    -- local function
    local init
    local printMat
    local randomPoint
    local disoriginizeDirction
    local randomPath
    
    -- function detail
    init = function()
        isFindPath = false
        dir = {1,2,3,4}
        
        main_mat = {}
        for i = 1, m do
            main_mat[i] = {}
            for j = 1, n do
                main_mat[i][j] = 0
            end
        end

        randomPath(0,0,0)
        --printMat()
    end

    printMat = function()
        for i = 1, m do
            tmp = ""
            for j = 1, n do
                tmp = tmp .. main_mat[i][j] .." "
            end
            s_logd(tmp)
        end
    end

    randomPoint = function()
        if (m%2 == 1 and n%2 == 1) then
            while 1 do
                math.randomseed(os.time())
                randomX = math.random(1, m)
                randomY = math.random(1, n)
                if ((randomX + randomY)%2 == 0) then
                    return {x=randomX, y=randomY}
                end            
            end
        end
        math.randomseed(os.time())
        return {x=math.random(1, m), y=math.random(1, n)}
    end

    disoriginizeDirction = function()
        for i =1, 4 do
            math.randomseed(os.time())
            randomIndex = math.random(1,4)
            tmp = dir[i]
            dir[i] = dir[randomIndex]
            dir[randomIndex] = tmp
        end
    end

    randomPath = function(currentIndex, currentX, currentY)
        if isFindPath then
            return
        end
    
        if currentIndex == 0 then
            local randomPoint = randomPoint()
            randomPath(currentIndex+1, randomPoint.x, randomPoint.y)
            return
        end
    
        main_mat[currentX][currentY] = currentIndex
    
        if (currentIndex == m * n) then
            isFindPath = true
            return
        end
    
        disoriginizeDirction()
        
        for d = 1, #dir do
            if dir[d] == 1 and currentY+1 <= n and main_mat[currentX][currentY+1] == 0 then
                randomPath(currentIndex+1,currentX,currentY+1)
            elseif dir[d] ==2 and currentY-1 >= 1 and main_mat[currentX][currentY-1] == 0 then
                randomPath(currentIndex+1,currentX,currentY-1)
            elseif dir[d] == 3 and currentX+1 <= m and main_mat[currentX+1][currentY] == 0 then
                randomPath(currentIndex+1,currentX+1,currentY)
            elseif dir[d] == 4 and currentX-1 >= 1 and main_mat[currentX-1][currentY] == 0 then
                randomPath(currentIndex+1,currentX-1,currentY)
            end
        end
        
        if not isFindPath then
            main_mat[currentX][currentY] = 0
        end
    end

    init()

    return main_mat
end

DEBUG_PRINT_LUA_TABLE = false
function print_lua_table (lua_table, indent)
    if DEBUG_PRINT_LUA_TABLE == false then return end
    
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end

function is2TimeInSameDay(secondsA, secondsB)
    local a = os.date("*t", secondsA)
    local b = os.date("*t", secondsB)
    -- print(string.format('is2TimeInSameDay:%d,%d,%d', a.year, a.month, a.day))
    -- print(string.format('is2TimeInSameDay:%d,%d,%d', b.year, b.month, b.day))
    -- {year = 1998, month = 9, day = 16, yday = 259, wday = 4, hour = 23, min = 48, sec = 10, isdst = false}
    return a.year == b.year and a.month == b.month and a.day == b.day
end

local function nand(x,y,z)
    z=z or 2^16
    if z<2 then
        return 1-x*y
    else
        return nand((x-x%z)/z,(y-y%z)/z,math.sqrt(z))*z+nand(x%z,y%z,math.sqrt(z))
    end
end
math["not"]=function(y,z)
    return nand(nand(0,0,z),y,z)
end
math["and"]=function(x,y,z)
    return nand(math["not"](0,z),nand(x,y,z),z)
end
math["or"]=function(x,y,z)
    return nand(math["not"](x,z),math["not"](y,z),z)
end
math["xor"]=function(x,y,z)
    return math["and"](nand(x,y,z),math["or"](x,y,z),z)
end

function showProgressHUD(info, native)
    if native then
        info = info or ''
        cx.CXProgressHUD:show(info)
    else
        s_SCENE:addLoadingView()
    end
end

function hideProgressHUD(native)
    if native then
        cx.CXProgressHUD:hide()
    else
        s_SCENE:removeLoadingView()
    end
end

function checkIfDownloadSoundsExist(bookkey)
    local storagePath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..bookkey.."/"..bookkey

    print("The path of: "..storagePath.."is ",cc.FileUtils:getInstance():isFileExist(storagePath) )

    return  cc.FileUtils:getInstance():isFileExist(storagePath)
end

function getDayStringForDailyStudyInfo(time)
    local str = string.format('%s/%s/%s', os.date('%m', time), os.date('%d', time), os.date('%y', time))
    return str
end

function getRandomBossPath( )
    local map_path = require('view.summaryboss.MapPath')
    
    return map_path[math.random(1,5)]
end

function onAndroidKeyPressed(node, back_func, menu_func)
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            print("Android: BACK clicked!")
            if back_func ~= nil then back_func() end
        elseif keyCode == cc.KeyCode.KEY_MENU  then
            print("Android: MENU clicked!")
            if menu_func ~= nil then menu_func() end
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end
