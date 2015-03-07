require("cocos.init")
require("common.global")

local BackLayer             = require("view.newstudy.NewStudyBackLayer")
local SoundMark             = require("view.newstudy.NewStudySoundMark")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar     = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  ChooseCollectWordLayer = class("ChooseCollectWordLayer", function ()
    return cc.Layer:create()
end)

local function createKnow(word,wrongNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local choose_know_button
    
    local click_know_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
            choose_know_button:runAction(cc.MoveBy:create(0.1,cc.p(0,-3)))
        elseif eventType == ccui.TouchEventType.ended then
            -- local CollectUnfamiliarLayer = require("view.newstudy.CollectUnfamiliarLayer")
            -- local collectUnfamiliarLayer = CollectUnfamiliarLayer.create(word, wrongNum, preWordName, preWordNameState)
            -- s_SCENE:replaceGameLayer(collectUnfamiliarLayer)
            choose_know_button:runAction(cc.MoveBy:create(0.1,cc.p(0,3)))
            s_CorePlayManager.leaveStudyModel(true)
        end
    end

    local choose_know_button_back = cc.Sprite:create("image/button/chooseBack.png")
    choose_know_button_back:setPosition(bigWidth/2, 500)
    
    choose_know_button = ccui.Button:create("image/button/collect.png","","")
    choose_know_button:setPosition(choose_know_button_back:getContentSize().width / 2,choose_know_button_back:getContentSize().height / 2 + 3)
    choose_know_button:ignoreAnchorPointForPosition(false)
    choose_know_button:setAnchorPoint(0.5,0)
    choose_know_button:addTouchEventListener(click_know_button)
    
    local label = cc.Label:createWithSystemFont("太熟悉了","",32)
    label:setColor(cc.c4b(255,255,255,255))
    label:setPosition(choose_know_button:getContentSize().width * 0.5 ,choose_know_button:getContentSize().height * 0.5 + 4)
    label:enableOutline(cc.c4b(255,255,255,255),1)
    choose_know_button:addChild(label)

    return choose_know_button_back
end

local function createDontknow(word,wrongNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local choose_dontknow_button
    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
            choose_dontknow_button:runAction(cc.MoveBy:create(0.1,cc.p(0,-3)))
        elseif eventType == ccui.TouchEventType.ended then
            choose_dontknow_button:runAction(cc.MoveBy:create(0.1,cc.p(0,3)))
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum,preWordName,preWordNameState,CreateWrongLayer_From_CollectWord,nil)
            s_SCENE:replaceGameLayer(chooseWrongLayer)          
        end
    end

    local choose_dontknow_button_back = cc.Sprite:create("image/button/chooseBack.png")
    choose_dontknow_button_back:setPosition(bigWidth/2, 500)

    choose_dontknow_button = ccui.Button:create("image/button/throw.png","","")
    choose_dontknow_button:setPosition(choose_dontknow_button_back:getContentSize().width / 2,choose_dontknow_button_back:getContentSize().height / 2 + 3)
    choose_dontknow_button:ignoreAnchorPointForPosition(false)
    choose_dontknow_button:setAnchorPoint(0.5,0)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)

    local label = cc.Label:createWithSystemFont("不认识","",32)
    label:setColor(cc.c4b(255,255,255,255))
    label:setPosition(choose_dontknow_button:getContentSize().width * 0.5 ,choose_dontknow_button:getContentSize().height * 0.5 + 4)
    label:enableOutline(cc.c4b(255,255,255,255),1)
    choose_dontknow_button:addChild(label)

    return choose_dontknow_button_back
end

function ChooseCollectWordLayer.create(wordName, wrongWordNum, preWordName, preWordNameState)
    local layer = ChooseCollectWordLayer.new(wordName, wrongWordNum, preWordName, preWordNameState)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    return layer
end

function ChooseCollectWordLayer:ctor(wordName, wrongWordNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)

    self.currentWord = wordName
    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)

    local progressBar_total_number 

    if s_CURRENT_USER.islandIndex == 0 then
        progressBar_total_number = s_max_wrong_num_first_island
    else
        progressBar_total_number = s_max_wrong_num_everyday
    end

    local progressBar = ProgressBar.create(progressBar_total_number, wrongWordNum, "blue")
    progressBar:setPosition(bigWidth/2+44, 1054)
    backColor:addChild(progressBar,2)

    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    local todayNumber = LastWordAndTotalNumber:getCurrentLevelNum()
    self.lastWordAndTotalNumber.setNumber(todayNumber)
    if preWordName ~= nil then
        self.lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 930)
    backColor:addChild(soundMark)
    
    self.iknow = createKnow(wordName,wrongWordNum, preWordName, preWordNameState)
    backColor:addChild(self.iknow)

    self.dontknow = createDontknow(wordName,wrongWordNum, preWordName, preWordNameState)
    backColor:addChild(self.dontknow)


    
end

return ChooseCollectWordLayer