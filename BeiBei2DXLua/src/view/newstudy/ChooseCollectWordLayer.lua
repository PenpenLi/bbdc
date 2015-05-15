require("cocos.init")
require("common.global")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip")
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")
local Button                = require("view.button.longButtonInStudy")
local GuideLayer = require("view.newstudy.GuideLayer")

local  ChooseCollectWordLayer = class("ChooseCollectWordLayer", function ()
    return cc.Layer:create()
end)

local function createKnow(word)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local rubbish_bag
    local progressLabel
    local knowLabel
    local wordLabel
    local choose_know_button

    local function labelAnimation()
        wordLabel:setVisible(true)
        local action3 = cc.JumpTo:create(0.4,cc.p(choose_know_button:getContentSize().width*0.125,choose_know_button:getContentSize().height * 0.8),
            choose_know_button:getContentSize().height /2 + 150,1)
        local action4 = cc.ScaleTo:create(0.5,0)      
        wordLabel:runAction(cc.Sequence:create(action3))
        wordLabel:runAction(cc.Sequence:create(action4))
    end

    local function bagAnimation()
        local action5 = cc.ScaleTo:create(0.1, 1.4,0.8)
        local action6 = cc.ScaleTo:create(0.1, 1,1.3)
        local action7 = cc.ScaleTo:create(0.1, 1.4,0.8)
        local action8 = cc.ScaleTo:create(0.1, 1,1.3)
        local action9 = cc.ScaleTo:create(0.1, 1,1)
        local action = cc.Sequence:create(action5,action6,action7,action8,action9)
        rubbish_bag:runAction(action)
    end

    choose_know_button = cc.Sprite:create("image/newstudy/button_study_know.png")
    choose_know_button:ignoreAnchorPointForPosition(false)
    choose_know_button:setAnchorPoint(0.5,0.5)
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    layer:setContentSize(choose_know_button:getContentSize().width,choose_know_button:getContentSize().height)
    layer:setPosition(bigWidth/2, 245)
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(0.5,0.5)
    layer:addChild(choose_know_button)
    
    choose_know_button:setPosition(layer:getContentSize().width/2,layer:getContentSize().height/2)
    
    rubbish_bag = cc.Sprite:create("image/newstudy/button_study_know_rubbish.png")
    rubbish_bag:setPosition(choose_know_button:getContentSize().width*0.125,choose_know_button:getContentSize().height*0.5)
    choose_know_button:addChild(rubbish_bag)

    knowLabel = cc.Label:createWithSystemFont("太熟悉了","",30)
    knowLabel:setPosition(choose_know_button:getContentSize().width / 2, choose_know_button:getContentSize().height / 2)
    knowLabel:ignoreAnchorPointForPosition(false)
    knowLabel:setAnchorPoint(0.5,0.5)
    knowLabel:setColor(cc.c4b(58,185,224,255))
    choose_know_button:addChild(knowLabel)

    local todayNumber = LastWordAndTotalNumber:getCurrentLevelRightNum()
    progressLabel = cc.Label:createWithSystemFont(todayNumber,"",38)
    progressLabel:setPosition(choose_know_button:getContentSize().width *0.8, choose_know_button:getContentSize().height / 2)
    progressLabel:ignoreAnchorPointForPosition(false)
    progressLabel:setAnchorPoint(0.5,0.5)
    progressLabel:setColor(cc.c4b(58,185,224,255))
    choose_know_button:addChild(progressLabel)

    wordLabel = cc.Label:createWithTTF(word,'font/CenturyGothic.ttf',64)
    wordLabel:setColor(cc.c4b(31,68,102,255))
    wordLabel:setPosition(choose_know_button:getContentSize().width /2 ,choose_know_button:getContentSize().height /2 + 630)
    choose_know_button:addChild(wordLabel)
    wordLabel:setVisible(false)
    
    local function onTouchBegan(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(choose_know_button:getBoundingBox(),location) then
            playSound(s_sound_buttonEffect)  
            rubbish_bag:setTexture("image/newstudy/button_study_know_rubbish_pressed.png")  
            choose_know_button:setTexture("image/newstudy/button_study_know_pressed.png")   
            knowLabel:setColor(cc.c4b(127,239,255,255))
            progressLabel:setColor(cc.c4b(127,239,255,255))
        end
        return true
    end

    local function onTouchEnded(touch, event)            
        choose_know_button:setTexture("image/newstudy/button_study_know.png")  
        rubbish_bag:setTexture("image/newstudy/button_study_know_rubbish.png")
        knowLabel:setColor(cc.c4b(58,185,224,255))
        progressLabel:setColor(cc.c4b(58,185,224,255))
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(choose_know_button:getBoundingBox(),location) then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            ChooseCollectWordLayer.forceToEnd()
            local action1 = cc.DelayTime:create(0.35) 
            local action2 = cc.DelayTime:create(1)
            choose_know_button:runAction(cc.Sequence:create(cc.CallFunc:create(function ()
                labelAnimation()
            end),
            action1,
            cc.CallFunc:create(function ()
                bagAnimation()
            end),
            action2,
            cc.CallFunc:create(function ()
                s_CorePlayManager.leaveStudyModel(true)
                -- old tutorial
                -- if todayNumber == 0 and s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat1_2 then
                --     local guideLayer = GuideLayer.create(GUIDE_CLICK_I_KNOW_BUTTON,word)
                --     s_SCENE:popup(guideLayer)             
                -- end
                -- new tutorial
                
            end)))  
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer
end

local function createDontknow(word,wrongNum)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local beibei_bag
    local wordLabel
    local progressLabel
    local choose_dontknow_button
    local lightSprite
    local total_number = getMaxWrongNumEveryLevel()

    local function labelAnimation()
        wordLabel:setVisible(true)
        local action3 = cc.JumpTo:create(0.4,cc.p(choose_dontknow_button:getContentSize().width*0.125,choose_dontknow_button:getContentSize().height * 0.8),
            choose_dontknow_button:getContentSize().height /2 + 150,1)
        local action4 = cc.ScaleTo:create(0.5,0)      
        wordLabel:runAction(cc.Sequence:create(action3))
        wordLabel:runAction(cc.Sequence:create(action4))
    end

    local function bagAnimation()
        local action10 = cc.MoveBy:create(0.05, cc.p(0,-5))
        local action5 = cc.ScaleTo:create(0.1, 1.6,0.8)
        local action6 = cc.ScaleTo:create(0.1, 1,1.4)
        local action7 = cc.ScaleTo:create(0.1, 1.1,0.8)
        local action8 = cc.ScaleTo:create(0.1, 1,1.1)
        local action11 = cc.MoveBy:create(0.05, cc.p(0,5))
        local action9 = cc.ScaleTo:create(0.1, 1,1)
        local action = cc.Sequence:create(action10,action5,action6,action7,action8,action11,action9)
        beibei_bag:runAction(action)
    end

    local function progressAnimation()
        local action5 = cc.ScaleTo:create(0.2, 1.5)
        local action6 = cc.ScaleTo:create(0.2, 1)
        local action7 = cc.Sequence:create(action5, action6)
        progressLabel:runAction(action7)
        progressLabel:setString((wrongNum+1).." / "..total_number)  
        
        local action8 = cc.ScaleTo:create(0.2,3)
        local action9 = cc.ScaleTo:create(0.2,0)
        local action10 = cc.FadeOut:create(0.4)
        local action  = cc.Sequence:create(action8,action9)
        lightSprite:runAction(action)   
        lightSprite:runAction(action10)   
    end
    
    local button_func = function()
        playSound(s_sound_buttonEffect)        
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        ChooseCollectWordLayer.forceToEnd()
        local action1 = cc.DelayTime:create(0.25) 
        local action2 = cc.DelayTime:create(1)
        local action3 = cc.DelayTime:create(1) 
        choose_dontknow_button:runAction(cc.Sequence:create(cc.CallFunc:create(function ()
            labelAnimation()
        end),
        action1,
        cc.CallFunc:create(function ()
            bagAnimation()
            progressAnimation()
        end),
        action3,
        cc.CallFunc:create(function ()
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum)
            s_SCENE:replaceGameLayer(chooseWrongLayer) 
        end)))         
    end

    choose_dontknow_button = Button.create("special","blue","不认识") 
    choose_dontknow_button:setPosition(bigWidth/2, 400)
    choose_dontknow_button.func = function ()
        button_func()
    end
    
    lightSprite = cc.Sprite:create("image/newstudy/liangguang_study.png")
    lightSprite:setPosition(choose_dontknow_button.button_front:getContentSize().width *0.8, choose_dontknow_button.button_front:getContentSize().height / 2)
    lightSprite:ignoreAnchorPointForPosition(false)
    lightSprite:setAnchorPoint(0.5,0.5)
    lightSprite:setScale(0)
    choose_dontknow_button.button_front:addChild(lightSprite)
    
    progressLabel = cc.Label:createWithSystemFont(wrongNum.." / "..total_number,"",38)
    progressLabel:setPosition(choose_dontknow_button.button_front:getContentSize().width *0.8, choose_dontknow_button.button_front:getContentSize().height / 2)
    progressLabel:ignoreAnchorPointForPosition(false)
    progressLabel:setAnchorPoint(0.5,0.5)
    progressLabel:setColor(cc.c4b(255,255,255,255))
    choose_dontknow_button.button_front:addChild(progressLabel)

    beibei_bag = cc.Sprite:create("image/newstudy/daizi_study_unknow.png")
    beibei_bag:setPosition(choose_dontknow_button.button_front:getContentSize().width*0.125,choose_dontknow_button.button_front:getContentSize().height*0.5)
    choose_dontknow_button.button_front:addChild(beibei_bag)

    wordLabel = cc.Label:createWithTTF(word,'font/CenturyGothic.ttf',64)
    wordLabel:setColor(cc.c4b(31,68,102,255))
    wordLabel:setPosition(choose_dontknow_button.button_front:getContentSize().width /2 ,choose_dontknow_button.button_front:getContentSize().height /2 + 475)
    choose_dontknow_button.button_front:addChild(wordLabel)
    wordLabel:setVisible(false)
 
    return choose_dontknow_button
end

local function createLoading(interpretation)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local tofinish = cc.ProgressTo:create(5,100)
    
    local button_back = cc.Sprite:create("image/newstudy/progressbegin.png")
    
    local button_progress = cc.ProgressTimer:create(cc.Sprite:create('image/newstudy/progressend.png'))
    button_progress:setPosition(0.5 * button_back:getContentSize().width,0.5 * button_back:getContentSize().height)
    button_progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    button_progress:setPercentage(0)
    button_progress:runAction(tofinish)
    button_back:addChild(button_progress)
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,0))
    layer:setContentSize(button_back:getContentSize().width,button_back:getContentSize().height)
    layer:setPosition(bigWidth/2, 660)
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(0.5,0.5)
    layer:addChild(button_back)
    
    button_back:setPosition(layer:getContentSize().width / 2, layer:getContentSize().height / 2)
    
    local meaningLabel = cc.Label:createWithSystemFont(interpretation,"",40)
    meaningLabel:setPosition(button_back:getContentSize().width / 2, button_back:getContentSize().height / 2)
    meaningLabel:ignoreAnchorPointForPosition(false)
    meaningLabel:setAnchorPoint(0.5,0.5)
    meaningLabel:setVisible(false)
    meaningLabel:setColor(cc.c4b(0,0,0,255))
    button_back:addChild(meaningLabel)
    
    local action1 = cc.DelayTime:create(5)
    local action2 = cc.CallFunc:create(function()ChooseCollectWordLayer.forceToEnd()end)
    layer:runAction(cc.Sequence:create(action1,action2))
    
    ChooseCollectWordLayer.forceToEnd = function ()
        button_back:setTexture('image/newstudy/progressend.png')
        meaningLabel:setVisible(true)
    end
    
    local function onTouchBegan(touch, event)
        return true
    end
    
    local function onTouchEnded(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(button_back:getBoundingBox(),location) then
            ChooseCollectWordLayer.forceToEnd()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

function ChooseCollectWordLayer.create(wordName, wrongWordNum, preWordName, preWordNameState)
    local layer = ChooseCollectWordLayer.new(wordName, wrongWordNum, preWordName, preWordNameState)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    return layer
end

function ChooseCollectWordLayer:ctor(wordName, wrongWordNum, preWordName, preWordNameState)
    -- old tutorial
    -- if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat1_1 then
    --     s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat1_1 + 1)
    --     s_SCENE:callFuncWithDelay(0.5, function()
    --         local guideLayer = GuideLayer.create(GUIDE_ENTER_COLLECT_WORD_LAYER)
    --             s_SCENE:popup(guideLayer)
    --         end)
    -- end

        -- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_collectWord)
    
    if s_CURRENT_USER.newTutorialStep == s_newtutorial_collect_goal then
        s_CURRENT_USER.newTutorialStep = s_newtutorial_train_goal
        saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})
        s_SCENE:callFuncWithDelay(0.5, function()
            local guideLayer = GuideLayer.create(GUIDE_ENTER_COLLECT_WORD_LAYER)
            s_SCENE:popup(guideLayer)
        end)
    end

    AnalyticsFirstDayEnterSecondIsland()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT) 

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT + 45)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)
    
    local pauseBtn = PauseButton.create(CreatePauseFromStudy)
    pauseBtn:setPosition(30 , s_DESIGN_HEIGHT -50)
    backColor:addChild(pauseBtn,100)    

    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)

    self.currentWord = wordName
    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)

    local progressBar_total_number = getMaxWrongNumEveryLevel()
    
    local lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(lastWordAndTotalNumber,1)

    if preWordName ~= nil then
        lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end

    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 920)  
    backColor:addChild(soundMark)
    
    self.forceToEnd = function ()
    	
    end
    
    self.circle = createLoading(self.wordInfo[5])
    backColor:addChild(self.circle) 
    
    self.iknow = createKnow(wordName)
    backColor:addChild(self.iknow)

    self.dontknow = createDontknow(wordName,wrongWordNum)
    backColor:addChild(self.dontknow)

    s_HttpRequestClient.downloadSoundsFromURL(s_CorePlayManager.currentIndex)
end

return ChooseCollectWordLayer