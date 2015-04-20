--本地数据管理器
require("common.global")
local sqlite3 = require("lsqlite3")

local DataEverydayInfo          = require('model.user.DataEverydayInfo')    --
local DataLevelInfo             = require('model.user.DataLevelInfo')
local DataDailyStudyInfo        = require('model.user.DataDailyStudyInfo')
local DataBossWord              = require('model.user.DataBossWord')
local DataTask                  = require('model.user.DataTask')
local DataDailyUsing            = require('model.user.DataDailyUsing')

local databaseTables = {
        DataEverydayInfo,
        DataUser,
        DataLevelInfo,

        DataDailyStudyInfo,
        DataBossWord,
        DataTask,
        DataDailyUsing
    }

local localdatabase_utils           = nil
local localdatabase_user            = nil
local localdatabase_dailyStudyInfo  = nil
local localdatabase_bossWord        = nil
local localdatabase_task            = nil

-- define Manager
local Manager = {}

-- define Manager's variables
Manager.database = nil

-- connect local sqlite
function Manager.init()
    local databasePath = cc.FileUtils:getInstance():getWritablePath() .. 'bbdx.sqlite' --  version 1.7.x- "localDB.sqlite"
    Manager.database = sqlite3.open(databasePath)
    print ('databasePath:' .. databasePath)

    localdatabase_utils             = reloadModule('model.localDatabase.utils')
    localdatabase_user              = reloadModule('model.localDatabase.user')

    localdatabase_dailyStudyInfo    = reloadModule('model.localDatabase.dailyStudyInfo')
    localdatabase_bossWord          = reloadModule('model.localDatabase.bossWord')
    localdatabase_task              = reloadModule('model.localDatabase.task')
    
    Manager.initTables()
end

-- close local sqlite
function Manager.close() Manager.database:close() end

-- init data structure
function Manager.initTables()    
    
    -- CREATE table Download State
    -- just used in local
    Manager.database:exec[[
        create table if not exists DataDownloadState(
            bookKey TEXT,
            isDownloaded INTEGER,
            lastUpdate INTEGER
        );
    ]]
    
    for i = 1, #databaseTables do
        localdatabase_utils.createTable(databaseTables[i].create())
    end
end

function Manager.saveDataClassObject(objectOfDataClass, userId, username, conditions)
    localdatabase_utils.saveDataClassObject(objectOfDataClass, userId, username, conditions)
end
---------------------------------------------------------------------------------------------------------

function Manager.getLastLogInUser(objectOfDataClass, usertype)
    return localdatabase_user.getUserDataFromLocalDB(objectOfDataClass, usertype)
end

---------------------------------------------------------------------------------------------------------

function Manager.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
    localdatabase_utils.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
end

-- handleRecordRow : nil or function(row)
function Manager.getDatas(classNameOfDataClass, userId, username, handleRecordRow)
    return localdatabase_utils.getDatas(classNameOfDataClass, userId, username, handleRecordRow)
end

---------------------------------------------------------------------------------------------------------

function Manager.getWordInfoFromWordName(word)

    local DataWord = require('model.user.DataWord')
    local ret = DataWord.create()
    ret.wordName = word
    if s_WordDictionaryDatabase.allwords ~= nil then
        local raw = s_WordDictionaryDatabase.allwords[word]
        if not IS_DEVELOPMENT_MODE and raw == nil then
            s_WordDictionaryDatabase.allwords[word] = require('model.words.' .. word)
            raw = s_WordDictionaryDatabase.allwords[word]
        end
        if raw ~= nil then
            local indexOffset = 0
            if IS_DEVELOPMENT_MODE then indexOffset = 1 end
            ret.wordSoundMarkEn    =   raw[1 + indexOffset]
            ret.wordSoundMarkAm    =   raw[2 + indexOffset]
            ret.wordMeaningSmall   =   raw[3 + indexOffset]
            ret.wordMeaning        =   raw[4 + indexOffset]
            ret.sentenceEn         =   raw[5 + indexOffset]
            ret.sentenceCn         =   raw[6 + indexOffset]
            ret.sentenceEn2        =   raw[7 + indexOffset]
            ret.sentenceCn2        =   raw[8 + indexOffset]
        end
    end

    return ret
    
end

---- Daily Study Info -----------------------------------------------------------------------------------
function Manager.getRandomWord()
    return localdatabase_dailyStudyInfo.getRandomWord()
end

function Manager.addStudyWordsNum()
    local data = localdatabase_dailyStudyInfo.addStudyWordsNum()
    -- s_UserBaseServer.synTodayDailyStudyInfo(data, nil, false)
end

function Manager.addGraspWordsNum(addNum)
    local data = localdatabase_dailyStudyInfo.addGraspWordsNum(addNum)
    -- s_UserBaseServer.synTodayDailyStudyInfo(data, nil, false)
end


function Manager.getStudyDayNum()
    return localdatabase_dailyStudyInfo.getStudyDayNum()
end

function Manager.getStudyWordsNum(dayString)
    -- day must be a string like "11/16/14", as month + day + year
    return localdatabase_dailyStudyInfo.getStudyWordsNum(dayString)
end

function Manager.getGraspWordsNum(dayString)
    -- day must be a string like "11/16/14", as month + day + year
    return localdatabase_dailyStudyInfo.getGraspWordsNum(dayString)
end

function Manager.getDataDailyStudyInfo(dayString)
    return localdatabase_dailyStudyInfo.getDataDailyStudyInfo(dayString)
end

function Manager.saveDataDailyStudyInfo(data)
   localdatabase_dailyStudyInfo.saveDataDailyStudyInfo(data)
end

---- Task ------------------------------------------------------------------------------------------------

function Manager.getTodayTotalTaskNum()
    return localdatabase_task.getTodayTotalTaskNum()
end

function Manager.getTodayRemainTaskNum()
    return localdatabase_task.getTodayRemainTaskNum()
end

function Manager.getTodayTotalBossNum()
    return localdatabase_task.getTodayTotalBossNum()
end

function Manager.getTodayRemainBossNum()
    return #localdatabase_bossWord.getTodayReviewBoss()
end

function Manager.minusTodayRemainTaskNum()
    local todayRemainTaskNum = localdatabase_task.getTodayRemainTaskNum()

    if todayRemainTaskNum > 0 then
        localdatabase_task.setTodayRemainTaskNum(todayRemainTaskNum-1)
    end
end

---- Boss Word -------------------------------------------------------------------------------------------

function Manager.getPrevWordState()
    return localdatabase_bossWord.getPrevWordState()
end

function Manager.getTodayReviewBoss()
    return localdatabase_bossWord.getTodayReviewBoss()
end

function Manager.getMaxBoss()
    return localdatabase_bossWord.getMaxBoss()
end

function Manager.getMaxBossByBookKey(bookKey)
    return localdatabase_bossWord.getMaxBossByBookKey(bookKey)
end

function Manager.getMaxBossID()
    return localdatabase_bossWord.getMaxBossID()
end

function Manager.getBossInfo(bossID)
    return localdatabase_bossWord.getBossInfo(bossID)
end

function Manager.getAllBossInfo()
    return localdatabase_bossWord.getAllBossInfo()
end

function Manager.addRightWord(wordindex)
    localdatabase_bossWord.addRightWord(wordindex)
end

function Manager.addWrongWord(wordindex)
    return localdatabase_bossWord.addWrongWord(wordindex)
end

function Manager.updateTypeIndex(bossID)
    Manager.minusTodayRemainTaskNum()
    localdatabase_bossWord.updateTypeIndex(bossID)
end

function Manager.printBossWord()
    localdatabase_bossWord.printBossWord()
end

---- Statistics -----------------------------------------------------------------------------------------

function Manager.getTotalStudyWordsNum()
    return s_CURRENT_USER.levelInfo:getCurrentWordIndex() - 1
end

function Manager.getTotalStudyWordsNumByBookKey(bookKey)
    return s_CURRENT_USER.levelInfo:getWordIndex(bookKey) - 1
end

function Manager.getTotalGraspWordsNum()
    return #localdatabase_bossWord.getAllWrongWordList()
end

function Manager.getStudyWords()
    local bookKey = s_CURRENT_USER.bookKey
    local wordList = s_BookWord[bookKey]
    local currentIndex = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    
    local wordPool = {}
    for i = 1, currentIndex-1 do
        table.insert(wordPool, wordList[i])
    end
    return wordPool
end

function Manager.getWrongWords()
    return localdatabase_bossWord.getAllWrongWordList()
end

function Manager.getGraspWords()
    local studyWordPool = Manager.getStudyWords()
    local wrongWordPool = Manager.getWrongWords()
    
    local dict = {}
    for i = 1, #wrongWordPool do
        local wordname = wrongWordPool[i]
        dict[wordname] = 1
    end
    
    local wordPool = {}
    for i = 1, #studyWordPool do
        local wordname = studyWordPool[i]
        if dict[wordname] == nil then
            table.insert(wordPool, wordname)
        end
    end

    return wordPool
end


---- Download --------------------------------------------------------------------------------------------

function Manager.getDownloadState(bookKey)
    local isDownloaded = 0
    for row in Manager.database:nrows("SELECT * FROM DataDownloadState WHERE bookKey = '"..bookKey.."' ;") do
        isDownloaded = row.isDownloaded
    end
    return isDownloaded
end

function Manager.updateDownloadState(bookKey, isDownloaded)
    local time = os.time()

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataDownloadState WHERE bookKey = '"..bookKey.."' ;") do
        num = num + 1
    end
    
    if num == 0 then
        local query = "INSERT INTO DataDownloadState VALUES ('"..bookKey.."', "..isDownloaded..", "..time..");"
        Manager.database:exec(query)
    else
        local query = "UPDATE DataDownloadState SET isDownloaded = "..isDownloaded..", lastUpdate = "..time.." WHERE bookKey = '"..bookKey.."' ;"    
        Manager.database:exec(query)
    end
end

---- UserDefault -----------------------------------------------------------------------------------------

local is_log_out_key = 'log_out'
function Manager.isLogOut() return false end -- TODO return cc.UserDefault:getInstance():getBoolForKey(is_log_out_key, false) end
function Manager.setLogOut(b) cc.UserDefault:getInstance():setBoolForKey(is_log_out_key, b) end

local is_sound_on_key = 'sound'
function Manager.isSoundOn() return cc.UserDefault:getInstance():getBoolForKey(is_sound_on_key, true) end
function Manager.setSoundOn(b) cc.UserDefault:getInstance():setBoolForKey(is_sound_on_key, b) end

local is_music_on_key = 'music'
function Manager.isMusicOn() return cc.UserDefault:getInstance():getBoolForKey(is_music_on_key, true) end
function Manager.setMusicOn(b) cc.UserDefault:getInstance():setBoolForKey(is_music_on_key, b) end

local is_buy_key = 'buy'
function Manager.isBuy() return cc.UserDefault:getInstance():getIntegerForKey(is_buy_key) end
function Manager.setBuy(b) cc.UserDefault:getInstance():setIntegerForKey(is_buy_key, b) end

local DA_DEVICE_ID = 'DA_DEVICE_ID'
function Manager.get_DA_DEVICE_ID() 
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        return cx.CXNetworkStatus:getInstance():getDeviceUDID()
    else
        return cc.UserDefault:getInstance():getStringForKey(DA_DEVICE_ID) 
    end
end

return Manager


