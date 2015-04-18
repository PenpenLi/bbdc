require "common.global"

local ReviewBossLayer        = require("view.reviewboss.reviewbossI.ReviewBossLayer")
local ReviewBossLayerII      = require("view.reviewboss.reviewbossII.ReviewBossLayerII")
local ReviewBossLayerIII     = require("view.reviewboss.reviewbossIII.ReviewBossLayerIII")
local IntroLayer             = require("view.login.IntroLayer")
local HomeLayer              = require("view.home.HomeLayer")
local LevelLayer             = require("view.LevelLayer")
local BookLayer              = require("view.book.BookLayer")
local DownloadLayer          = require("view.book.DownloadLayer")
local WordListLayer          = require("view.wordlist.WordList")
local FriendLayer            = require("view.friend.FriendLayer") 


local CorePlayManager = {}


function CorePlayManager.initTotalPlay()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()

    CorePlayManager.currentBossID = nil
    for i = 1, #bossList do
        local boss = bossList[i]
        print("boss info")
        print(boss.bossID)
        print(boss.coolingDay)
        if boss.typeIndex >= 4 and boss.typeIndex <= 7 then
            if boss.coolingDay == 0 then
                CorePlayManager.currentBossID = boss.bossID
                break
            else
                -- pass
            end
        elseif boss.typeIndex == 8 then
            -- pass
        else
            CorePlayManager.currentBossID = boss.bossID
            break
        end
    end

    if CorePlayManager.currentBossID == nil then
        -- pass all
    else
        -- exist boss
    end

    CorePlayManager.currentBoss            = s_LocalDatabaseManager.getBossInfo(CorePlayManager.currentBossID)
    CorePlayManager.currentTypeIndex       = CorePlayManager.currentBoss.typeIndex
    CorePlayManager.currentRightWordList   = CorePlayManager.currentBoss.rightWordList
    CorePlayManager.currentWrongWordList   = CorePlayManager.currentBoss.wrongWordList 
    
    CorePlayManager.BookWordList          = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex          = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum          = #CorePlayManager.currentWrongWordList

    if     CorePlayManager.currentTypeIndex == 0 then
        -- study   model
        CorePlayManager.initStudyModel()
    elseif CorePlayManager.currentTypeIndex == 1 then
        -- test    model
        CorePlayManager.initTestModel()
    elseif CorePlayManager.currentTypeIndex == 2 then
        -- review  model
        CorePlayManager.initReviewModel()
    elseif CorePlayManager.currentTypeIndex == 3 then
        -- summary model
        CorePlayManager.initSummaryModel()
    elseif CorePlayManager.currentTypeIndex >= 4 and CorePlayManager.currentTypeIndex <= 7 then
        -- review model
        CorePlayManager.initReviewModel()
    else
        -- over model
        CorePlayManager.initOverModel()
    end
end

function CorePlayManager.initStudyModel()
    CorePlayManager.BookWordList          = s_BookWord[s_CURRENT_USER.bookKey]
    CorePlayManager.currentIndex          = s_CURRENT_USER.levelInfo:getCurrentWordIndex()
    CorePlayManager.wrongWordNum          = #CorePlayManager.currentWrongWordList

    CorePlayManager.preWordName           = CorePlayManager.BookWordList[CorePlayManager.currentIndex-1]
    CorePlayManager.preWordNameState      = s_LocalDatabaseManager.getPrevWordState()

    local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
    CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum, CorePlayManager.preWordName, CorePlayManager.preWordNameState)
end

function CorePlayManager.enterStudyModel(wordName, wrongWordNum, preWordName, preWordNameState)
    if wordName == nil then
        -- book over
        -- TODO
    else
        if preWordName ~= nil then
            print("preWordName: "..preWordName)
            if preWordNameState then
                print("preWordNameState: true")
            else
                print("preWordNameState: false")
            end
        end
        
        local ChooseCollectWordLayer = require("view.newstudy.ChooseCollectWordLayer")
        local chooseCollectWordLayer = ChooseCollectWordLayer.create(wordName, wrongWordNum, preWordName, preWordNameState)
        s_SCENE:replaceGameLayer(chooseCollectWordLayer)
    end
end

function CorePlayManager.leaveStudyModel(state)
    if state == true then
        print('answer right')
        s_LocalDatabaseManager.addRightWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
        s_LocalDatabaseManager.addStudyWordsNum()
        s_LocalDatabaseManager.addGraspWordsNum(1)

        CorePlayManager.preWordName           = CorePlayManager.BookWordList[CorePlayManager.currentIndex-1]
        CorePlayManager.preWordNameState      = true

        local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
        CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum, CorePlayManager.preWordName, CorePlayManager.preWordNameState)
    else
        print('answer wrong' .. tostring(CorePlayManager.currentIndex))
        local isNewBossBirth = s_LocalDatabaseManager.addWrongWord(CorePlayManager.currentIndex)
        s_LocalDatabaseManager.printBossWord()
        CorePlayManager.currentIndex = CorePlayManager.currentIndex + 1
        s_LocalDatabaseManager.addStudyWordsNum()

        CorePlayManager.wrongWordNum = CorePlayManager.wrongWordNum + 1

        CorePlayManager.preWordName           = CorePlayManager.BookWordList[CorePlayManager.currentIndex-1]
        CorePlayManager.preWordNameState      = false

        if isNewBossBirth then
            -- do collect enough words
            CorePlayManager.enterStudyOverModel()
        else
            -- do not collect enough words
            local wordName = CorePlayManager.BookWordList[CorePlayManager.currentIndex]
            CorePlayManager.enterStudyModel(wordName, CorePlayManager.wrongWordNum, CorePlayManager.preWordName, CorePlayManager.preWordNameState)
        end
    end
end

function CorePlayManager.enterStudyOverModel()
    local MiddleLayer = require("view.newstudy.MiddleLayer")
    local middleLayer = MiddleLayer.create()
    s_SCENE:replaceGameLayer(middleLayer)
end

function CorePlayManager.leaveStudyOverModel()
    CorePlayManager.enterLevelLayer()
end

function CorePlayManager.initTestModel()
    CorePlayManager.enterTestModel(CorePlayManager.currentWrongWordList)
end

function CorePlayManager.enterTestModel(wordlist)
    local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
    local blacksmithLayer = BlacksmithLayer.create(wordlist)
    s_SCENE:replaceGameLayer(blacksmithLayer)
end

function CorePlayManager.leaveTestModel()
    s_LocalDatabaseManager.updateTypeIndex(CorePlayManager.currentBossID)
    local MiddleLayer = require("view.newstudy.EndLayer")
    local middleLayer = MiddleLayer.create()
    s_SCENE:replaceGameLayer(middleLayer)
end

function CorePlayManager.initReviewModel()
    -- if currentWrongWordList == nil,boss cant be exist,but boss is over there,so add boss word
    if CorePlayManager.currentWrongWordList == nil or #CorePlayManager.currentWrongWordList == 0 then
        CorePlayManager.enterReviewModel(CorePlayManager.currentRightWordList)
    else
        CorePlayManager.enterReviewModel(CorePlayManager.currentWrongWordList)
    end
end

function CorePlayManager.enterReviewModel(wordlist)
    local NewReviewBossMainLayer = require("view.newreviewboss.NewReviewBossMainLayer")
    local newReviewBossMainLayer = NewReviewBossMainLayer.create(wordlist)
    s_SCENE:replaceGameLayer(newReviewBossMainLayer)
end

function CorePlayManager.leaveReviewModel(state)
    if state then
        s_LocalDatabaseManager.updateTypeIndex(CorePlayManager.currentBossID)
        local SuccessLayer = require("view.newreviewboss.SuccessLayer")
        local successLayer = SuccessLayer.create()
        s_SCENE:replaceGameLayer(successLayer)
    else
        -- do nothing
        CorePlayManager.enterLevelLayer()
    end
    
end

function CorePlayManager.initSummaryModel()
    CorePlayManager.enterSummaryModel(CorePlayManager.currentWrongWordList)
end

function CorePlayManager.enterSummaryModel(wordlist)
    local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
    local summaryBossLayer = SummaryBossLayer.create(wordlist,1,true)
    s_SCENE:replaceGameLayer(summaryBossLayer) 
end

function CorePlayManager.leaveSummaryModel(state)
    if state then
        s_LocalDatabaseManager.updateTypeIndex(CorePlayManager.currentBossID)
    else
        -- do nothing
    end
    -- CorePlayManager.enterLevelLayer()
end


-- function CorePlayManager.enterIntroLayer()
--     local IntroLayer = IntroLayer.create(false)
--     s_SCENE:replaceGameLayer(IntroLayer)
-- end

function CorePlayManager.enterHomeLayer(share)
    local homeLayer
    if share ~= nil and share then
        homeLayer = HomeLayer.create(share)
    else
        homeLayer = HomeLayer.create()
    end
    s_SCENE:replaceGameLayer(homeLayer)
end

function CorePlayManager.enterLevelLayer()
    local ChapterLayer = require('view.ChapterLayer')
    local chapterLayer = ChapterLayer.create()
    s_SCENE:replaceGameLayer(chapterLayer)
end

function CorePlayManager.enterBookLayer()
    local bookLayer = BookLayer.create()
    s_SCENE:replaceGameLayer(bookLayer)
end

function CorePlayManager.enterDownloadLayer(bookKey)
    local downloadLayer = DownloadLayer.create(bookKey)
    s_SCENE:replaceGameLayer(downloadLayer)
end

function CorePlayManager.enterWordListLayer()
    local wordListlayer = WordListLayer.create()
    s_SCENE:replaceGameLayer(wordListlayer)
end

function CorePlayManager.enterFriendLayer()
    local friendLayer = FriendLayer.create()
    s_SCENE:replaceGameLayer(friendLayer)
end

return CorePlayManager
