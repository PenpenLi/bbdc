local DataBossWord = require('model.user.DataBossWord')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex, savedToServer)
    local data = DataBossWord.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.lastUpdate = lastUpdate

    data.bossID = bossID
    data.typeIndex = typeIndex
    data.wordList = wordList
    data.lastWordIndex = lastWordIndex
    data.savedToServer = savedToServer

    return data
end

local function saveDataToServer(skip_wordList, lastUpdate, bossID, typeIndex, wordList, lastWordIndex, savedToServer)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"
    local data = createData(bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex, savedToServer)
    saveWordBossToServer(data, skip_wordList, function (serverDatas, error)
        if serverDatas == nil then return end
        
        for i, v in ipairs(serverDatas) do

            local query = "UPDATE DataBossWord SET objectId = '"..v.objectId.."', savedToServer = " .. v.savedToServer .. " WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)

            break
        end
    end)
end

function M.getPrevWordState()
    local preIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex() - 1
    local preWord  = s_BookWord[s_CURRENT_USER.bookKey][preIndex]

    if preWord == nil then
        return true
    else
        local maxBossID = M.getMaxBossID()
        local boss = M.getBossInfo(maxBossID)
        if #boss.wrongWordList == 0 then
            if maxBossID == 1 then
                return true
            else
                local preBoss = M.getBossInfo(maxBossID - 1)
                local lastWrongWord = preBoss.wrongWordList[#preBoss.wrongWordList]
                if preWord == lastWrongWord then
                    return false
                else
                    return true
                end
            end
        else
            local lastWrongWord = boss.wrongWordList[#boss.wrongWordList]
            if preWord == lastWrongWord then
                return false
            else
                return true
            end
        end
    end
end

function M.getTodayReviewBoss()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local time      = os.time()
    local today     = os.date("%x", time)

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local bossList  = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID ;") do
        if row.typeIndex >= 4 and row.typeIndex <= 7 then
            local boss  = {}
            boss.bossID = row.bossID
            boss.typeIndex  = row.typeIndex
            boss.lastUpdate = row.lastUpdate
            table.insert(bossList, boss)
        end
    end

    local getGapDay = function(day1, day2)
        local t1 = split(day1, "/")
        local t2 = split(day2, "/")
        local d1 = {}
        local d2 = {}
        d1.year  = tonumber("20"..t1[3])
        d1.month = tonumber(t1[1])
        d1.day   = tonumber(t1[2])
        d2.year  = tonumber("20"..t2[3])
        d2.month = tonumber(t2[1])
        d2.day   = tonumber(t2[2])

        local y = tonumber(os.date('%Y', os.time()))
        if d1.year > y then d1.year = y end
        if d2.year > y then d2.year = y end

        local numDay1 = os.time(d1)
        local numDay2 = os.time(d2)
        local gap = (numDay2-numDay1)/(3600*24)
        return gap
    end


    local todayReviewBoss = {}
    for i = 1, #bossList do
        local boss = bossList[i]
        
        local gap
        if     boss.typeIndex == 4 then
            gap = 1
        elseif boss.typeIndex == 5 then
            gap = 2
        elseif boss.typeIndex == 6 then
            gap = 3
        elseif boss.typeIndex == 7 then
            gap = 8
        end

        local lastUpdateDay = os.date("%x", boss.lastUpdate)
        if boss.lastUpdate == nil or boss.lastUpdate == 0 then
            lastUpdateDay = os.date("%x", boss.updatedAt)
        end
        local gapDayNum = getGapDay(lastUpdateDay, today)
        if gapDayNum >= gap then
            table.insert(todayReviewBoss, boss.bossID)
        end
    end

    return todayReviewBoss
end

function M.getMaxBoss()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local maxBoss = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        maxBoss = row
    end

    return maxBoss
end

function M.getMaxBossByBookKey(bookKey)
    local userId    = s_CURRENT_USER.objectId
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local maxBoss = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        maxBoss = row
    end

    return maxBoss
end

function M.getMaxBossID()
    local boss = M.getMaxBoss()
    if boss ~= nil then return boss.bossID end
    return 1
end

function M.getBossInfo(bossID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()
    
    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local boss      = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." and bossID = "..bossID.." ;") do
        boss.bossID         = row.bossID
        boss.typeIndex      = row.typeIndex
        boss.wrongWordList  = row.wordList
        boss.lastWordIndex  = row.lastWordIndex
        boss.lastUpdate     = row.lastUpdate
    end

    if boss.bossID == nil then
        boss.bossID         = bossID
        boss.typeIndex      = 0
        boss.wrongWordList  = {}
        boss.rightWordList  = {}
        boss.coolingDay     = 0
    else
        local startIndex
        if boss.bossID == 1 then
            startIndex = 1
        else
            for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." and bossID = "..(bossID-1).." ;") do
                startIndex  = row.lastWordIndex + 1
            end
        end

        local hash = {}
        if  boss.wrongWordList == '' then
            boss.wrongWordList = {}
        else
            boss.wrongWordList = split(boss.wrongWordList, "|")
            for i = 1, #boss.wrongWordList do
                local wordname = boss.wrongWordList[i]
                hash[wordname] = 1
            end
        end

        boss.rightWordList = {}
        for i = startIndex, boss.lastWordIndex do
            local wordname = s_BookWord[s_CURRENT_USER.bookKey][i]
            if hash[wordname] ~= 1 then
                table.insert(boss.rightWordList, wordname)
            end
        end

        -- get cooling day
        local getGapDay = function(day1, day2)
            print('local getGapDay = function(day1, day2)', day1, day2)
            local t1 = split(day1, "/")
            local t2 = split(day2, "/")
            local d1 = {}
            local d2 = {}
            d1.year  = tonumber("20"..t1[3])
            d1.month = tonumber(t1[1])
            d1.day   = tonumber(t1[2])
            d2.year  = tonumber("20"..t2[3])
            d2.month = tonumber(t2[1])
            d2.day   = tonumber(t2[2])

            local y = tonumber(os.date('%Y', os.time()))
            if d1.year > y then d1.year = y end
            if d2.year > y then d2.year = y end

            local numDay1 = os.time(d1)
            local numDay2 = os.time(d2)
            local gap = (numDay2-numDay1)/(3600*24)
            return gap
        end

        if boss.typeIndex < 4 or boss.typeIndex > 7 then
            -- other model
            boss.coolingDay = 0
        else
            -- review boss model
            local gap
            if     boss.typeIndex == 4 then
                gap = 1
            elseif boss.typeIndex == 5 then
                gap = 2
            elseif boss.typeIndex == 6 then
                gap = 3
            elseif boss.typeIndex == 7 then
                gap = 8
            end

            local today = os.date("%x", time)
            local lastUpdateDay = os.date("%x", boss.lastUpdate)
            if boss.lastUpdate == nil or boss.lastUpdate == 0 then
                lastUpdateDay = os.date("%x", boss.updatedAt)
            end
            local gapDayNum = getGapDay(lastUpdateDay, today)
            if gapDayNum >= gap then
                boss.coolingDay = 0
            else
                boss.coolingDay = gap - gapDayNum
            end
        end
    end

    if     boss.typeIndex == 0 then
        boss.proficiency = 0
    elseif boss.typeIndex >= 1 and boss.typeIndex <= 4 then
        boss.proficiency = 1
    elseif boss.typeIndex == 5 then
        boss.proficiency = 2
    elseif boss.typeIndex == 6 then
        boss.proficiency = 3
    elseif boss.typeIndex == 7 then
        boss.proficiency = 4
    elseif boss.typeIndex == 8 then
        boss.proficiency = 5
    else
        boss.proficiency = 0
    end

    return boss
end

function M.getAllBossInfo()
    local bossList = {}

    local maxBossID = M.getMaxBossID()
    for i = 1, maxBossID do
        local boss = M.getBossInfo(i)
        table.insert(bossList, boss)
    end

    return bossList
end


function M.addRightWord(wordindex)
    local wordname = s_BookWord[s_CURRENT_USER.bookKey][wordindex]

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local bossID    = nil
    local record = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        bossID      = row.bossID
        record      = row
    end

    if bossID == nil then
        local query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', 1, 0, '', "..wordindex..", 0) ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, 1, 0, '', wordindex, 0)
    else
        local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, record.bossID, record.typeIndex, record.wordList, wordindex, record.savedToServer)
    end
end


function M.addWrongWord(wordindex)
    local wordname = s_BookWord[s_CURRENT_USER.bookKey][wordindex]

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local bossID    = nil
    local typeIndex = nil
    local wordList  = nil
    local record = nil
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID DESC LIMIT 1 ;") do
        bossID      = row.bossID
        typeIndex   = row.typeIndex
        wordList    = row.wordList
        record = row
    end
    
    if bossID == nil then
        local query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', 1, 0, '"..wordname.."', "..wordindex..", 0) ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, 1, 0, '', wordindex, 0)
        return false
    elseif wordList == '' then
        local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , wordList = '"..wordname.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, record.bossID, record.typeIndex, wordname, wordindex, record.savedToServer)
        return false
    else
        local newWordList = wordList.."|"..wordname
        local wordCount = #split(wordList, "|")

        local current_total_number = getMaxWrongNumEveryLevel()

        if wordCount == current_total_number - 1 then
            s_LocalDatabaseManager.minusTodayRemainTaskNum()

            local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , typeIndex = 1 , wordList = '"..newWordList.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)

            print('saveDataToServer(false, time, bossID, 1, newWordList, wordindex, 1)')
            saveDataToServer(false, time, bossID, 1, newWordList, wordindex, 0)
            return true
        else
            local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , wordList = '"..newWordList.."' , lastWordIndex = "..wordindex.." WHERE "..condition.." and bossID = "..bossID.." ;"
            Manager.database:exec(query)
            saveDataToServer(true, time, record.bossID, record.typeIndex, newWordList, wordindex, record.savedToServer)
            return false
        end
    end
end

function M.updateTypeIndex(bossID)
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username
    local time      = os.time()

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." and bossID = "..bossID.." ;") do
        local newTypeIndex = row.typeIndex + 1
        if newTypeIndex == 2 then
            newTypeIndex = newTypeIndex + 1
        end 
        local lastWordIndex = row.lastWordIndex

        local query = "UPDATE DataBossWord SET lastUpdate = '"..time.."' , typeIndex = "..newTypeIndex.." WHERE "..condition.." and bossID = "..bossID.." ;"
        Manager.database:exec(query)
        saveDataToServer(true, time, row.bossID, newTypeIndex, row.wordList, lastWordIndex, row.savedToServer)

        if newTypeIndex == 4 then
            query = "INSERT INTO DataBossWord (userId, username, bookKey, lastUpdate, bossID, typeIndex, wordList, lastWordIndex, savedToServer) VALUES ('"..userId.."', '"..username.."', '"..bookKey.."', '"..time.."', "..(bossID+1)..", 0, '', "..lastWordIndex..", 0) ;"
            Manager.database:exec(query)
            saveDataToServer(true, time, bossID + 1, 0, '', lastWordIndex, 0)
        elseif newTypeIndex == 8 then
            s_LocalDatabaseManager.addGraspWordsNum(getMaxWrongNumEveryLevel())
        end
    end    

    M.printBossWord()
end

function M.printBossWord()
    if BUILD_TARGET ~= BUILD_TARGET_DEBUG then return end

    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local query = "SELECT * FROM DataBossWord WHERE "..condition.." ;"
    print(query)
    print("<bossWord>")
    for row in Manager.database:nrows(query) do
        print("<item>")
        print("bossID: "..row.bossID)
        print("typeIndex: "..row.typeIndex)
        print("wordList: "..row.wordList)
        print("lastWordIndex: "..row.lastWordIndex)
        print("</item>")
    end
    print("</bossWord>")
end


function M.getAllWrongWordList()
    local userId    = s_CURRENT_USER.objectId
    local bookKey   = s_CURRENT_USER.bookKey
    local username  = s_CURRENT_USER.username

    local condition = "(userId = '"..userId.."' or username = '"..username.."') and bookKey = '"..bookKey.."'"

    local wordPool = {}
    for row in Manager.database:nrows("SELECT * FROM DataBossWord WHERE "..condition.." ORDER BY bossID ;") do
        if row.wordList ~= '' then
            local t = split(row.wordList, "|")
            for i = 1, #t do
                table.insert(wordPool, t[i])
            end
        end
    end
    return wordPool
end


return M