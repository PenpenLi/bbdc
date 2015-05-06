require("cocos.init")
require("common.global")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.button.longButtonInStudy")
local TotalWrongWordTip = require("view.newstudy.TotalWrongWordTip")
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")

local  SlideCoconutLayer = class("SlideCoconutLayer", function ()
    return cc.Layer:create()
end)

function SlideCoconutLayer.create(word,wrongNum,wrongWordList)
    local layer = SlideCoconutLayer.new(word,wrongNum,wrongWordList)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function createRefreshButton()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_refresh_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            mat.forceFail()
        end
    end

    local refreshButton = ccui.Button:create("image/newstudy/refreshbegin.png","image/newstudy/refreshend.png","")
    refreshButton:setPosition(bigWidth * 0.9, 800)
    refreshButton:addTouchEventListener(click_refresh_button)
    return refreshButton  
end

local function createLastButton(word,wrongNum,wrongWordList)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_func = function()
        playSound(s_sound_buttonEffect)        
        local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
        local chooseWrongLayer 
        AnalyticsStudyLookBackWord()
        if wrongWordList == nil then
            chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum)
        else
            chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum,wrongWordList)
        end
        s_SCENE:replaceGameLayer(chooseWrongLayer)  
    end

    local choose_before_button = Button.create("long","blue","偷看一眼") 
    choose_before_button:setPosition(bigWidth/2, 100)
    choose_before_button.func = function ()
        button_func()
    end
    return choose_before_button  
end

function SlideCoconutLayer:ctor(word,wrongNum,wrongWordList)
    AnalyticsStudySlideCoconut_EnterLayer()

    if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat1_3 then
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat1_3 + 1)
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local isCollectLayer = true

    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT) 

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT + 97)
    backColor:addChild(back_head,1)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)
    
    local pauseBtn = PauseButton.create(CreatePauseFromStudy)
    pauseBtn:setPosition(30 , s_DESIGN_HEIGHT -50)
    backColor:addChild(pauseBtn,1)    

    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)    
    
    self.currentWord = word

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    
    local color 
    if wrongWordList == nil then
        color = "blue"
    else
        color = "yellow"
    end
    
    local progressBar_total_number = getMaxWrongNumEveryLevel()

    self.progressBar = ProgressBar.create(progressBar_total_number, wrongNum, color)
    self.progressBar:setPosition(bigWidth/2+44, 1054)

    if wrongWordList ~= nil then
       backColor:addChild(self.progressBar)
    end
    
    self.totalWrongWordTip = TotalWrongWordTip.create()
    backColor:addChild(self.totalWrongWordTip,1)
    local todayNumber = TotalWrongWordTip:getCurrentLevelWrongNum()

    if wrongWordList == nil then
        self.totalWrongWordTip.setNumber(todayNumber + 1)
    end
    
    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber)
    
    local word_meaning_label = cc.Label:createWithSystemFont(self.wordInfo[5],"",50)
    word_meaning_label:setPosition(bigWidth/2, 950)
    word_meaning_label:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(word_meaning_label,1)
    
    local size_big = backColor:getContentSize()
    local isNewPlayer = true
    if s_CURRENT_USER.slideNum == 0 then
        isNewPlayer = true
    else
        isNewPlayer = false
    end
    
    lastButton = createLastButton(word,wrongNum,wrongWordList)
    backColor:addChild(lastButton)

    mat = FlipMat.create(self.wordInfo[2],4,4,isNewPlayer,"coconut_light")
    mat:setPosition(size_big.width/2, 200)
    backColor:addChild(mat,2)
    
    local success = function()
        playWordSound(self.currentWord) 
        local normal = function()  
            AnalyticsStudySlideCoconut_LeaveLayer()
            if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat2_1 then
               s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat2_1 + 1)
            end

            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
            showAnswerStateBack:setPosition(backColor:getContentSize().width *1.5, 768)
            showAnswerStateBack:ignoreAnchorPointForPosition(false)
            showAnswerStateBack:setAnchorPoint(0.5,0.5)
            backColor:addChild(showAnswerStateBack,3)

            local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
            sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
            showAnswerStateBack:addChild(sign)

            local right_wordname = cc.Label:createWithSystemFont(self.currentWord,"",60)
            right_wordname:setColor(cc.c4b(130,186,47,255))
            right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
            right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
            showAnswerStateBack:addChild(right_wordname)

            local action1 = cc.MoveTo:create(0.2,cc.p(backColor:getContentSize().width /2, 768))
            showAnswerStateBack:runAction(action1)

            self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()  
                if wrongWordList == nil then
                    if wrongNum == progressBar_total_number - 1 then
                        s_CURRENT_USER:addBeans(s_CURRENT_USER.beanRewardForCollect)
                        saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                        print('logInDatas')
                        print_lua_table(s_CURRENT_USER.logInDatas)
                        print('isCheckIn')
                        -- print(s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey))

                        AnalyticsStudyCollectAllWord()
                        if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat2_2 then
                           s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_studyRepeat2_2 + 1)
                        end


                        if #s_CURRENT_USER.logInDatas > 0 and s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) then
                            s_CorePlayManager.leaveStudyModel(false)
                        else
                            local missionCompleteCircle = require('view.MissionCompleteCircle').create()
                            s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),cc.CallFunc:create(function ()
                                s_CorePlayManager.leaveStudyModel(false)    
                            end,{})))
                        end
                    else
                        s_CorePlayManager.leaveStudyModel(false)
                    end
                    
                           
                else
                    if wrongWordList[1] ~= nil then
                        local temp = wrongWordList[1]
                        table.insert(wrongWordList,temp)
                        table.remove(wrongWordList,1)
                    end                                   

                    local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
                    local blacksmithLayer = BlacksmithLayer.create(wrongWordList)
                    s_SCENE:replaceGameLayer(blacksmithLayer)
                end
            end)))
        end


        -- if s_CURRENT_USER.slideNum == 1 then
        --     -- local CongratulationPopup = require("view.newstudy.CongratulationPopup").create()
        --     -- s_SCENE:popup(CongratulationPopup)
        --     s_CURRENT_USER.slideNum = 0
        --     saveUserToServer({['slideNum'] = s_CURRENT_USER.slideNum})
        --     normal()
        -- else
        --     normal()
        -- end

        if s_CURRENT_USER.slideNum < 3 then
            s_CURRENT_USER.slideNum = s_CURRENT_USER.slideNum + 1
            saveUserToServer({['slideNum'] = s_CURRENT_USER.slideNum})
        end

        normal()

    end
    
    mat.success = success
    mat.rightLock = true
    mat.wrongLock = false



    -- local darkColor = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    -- darkColor:setAnchorPoint(0.5,0)
    -- darkColor:ignoreAnchorPointForPosition(false)
    -- darkColor:setPosition(backColor:getContentSize().width / 2, 0)

    -- local listener = cc.EventListenerTouchOneByOne:create()
    -- listener:setSwallowTouches(true)
    -- listener:registerScriptHandler(function(touch, event) return true end,cc.Handler.EVENT_TOUCH_BEGAN )
    -- darkColor:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, darkColor)

    -- local beibei = cc.Sprite:create("image/newstudy/background_yindao.png")
    -- beibei:setPosition(cc.p(darkColor:getContentSize().width / 2 , 170))
    -- darkColor:addChild(beibei)

    -- local beibei_hand = cc.Sprite:create("image/newstudy/yindao_huaci_gril_arm_background.png")
    -- beibei_hand:setPosition(cc.p(beibei:getContentSize().width * 0.4 , beibei:getContentSize().height * 0.4))
    -- beibei_hand:ignoreAnchorPointForPosition(false)
    -- beibei_hand:setAnchorPoint(0.5,0.1)
    -- beibei:addChild(beibei_hand,-1)

    -- local action1 = cc.RotateTo:create(0.1,45)
    -- local action2 = cc.RotateTo:create(1,-45)
    -- local action3 = cc.RepeatForever:create(cc.Sequence:create(action1,action2))

    -- beibei_hand:runAction(action3)
    
    -- local beibei_tip_label = cc.Label:createWithSystemFont("划一划 !","",48)
    -- beibei_tip_label:setPosition(beibei:getContentSize().width /2, beibei:getContentSize().height * 0.5)
    -- beibei_tip_label:setColor(cc.c4b(36,63,79,255))
    -- beibei:addChild(beibei_tip_label)


    if s_CURRENT_USER.slideNum == 0 then
        local darkColor = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        darkColor:setAnchorPoint(0.5,0)
        darkColor:ignoreAnchorPointForPosition(false)
        darkColor:setPosition(backColor:getContentSize().width / 2, 0)
        backColor:addChild(darkColor)

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(function(touch, event) return true end,cc.Handler.EVENT_TOUCH_BEGAN )
        darkColor:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, darkColor)

        local beibei = cc.Sprite:create("image/newstudy/background_yindao.png")
        beibei:setPosition(cc.p(darkColor:getContentSize().width / 2 , 170))
        darkColor:addChild(beibei)

        local beibei_tip_label = cc.Label:createWithSystemFont("划一划 !","",48)
        beibei_tip_label:setPosition(beibei:getContentSize().width /2, beibei:getContentSize().height * 0.5)
        beibei_tip_label:setColor(cc.c4b(36,63,79,255))
        beibei:addChild(beibei_tip_label)
    elseif s_CURRENT_USER.slideNum == 1 then
        local lastTouchTime = 4
        mat.updateLastTouchTime = function()
            lastTouchTime = 4
        end
        local action1 = cc.DelayTime:create(1.0)
        local action2 = cc.CallFunc:create(function()
            lastTouchTime = lastTouchTime - 1
            if lastTouchTime <= 0 then
                mat.toNewPlayModel()
                backColor:stopAllActions()

                local darkColor = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
                darkColor:setAnchorPoint(0.5,0)
                darkColor:ignoreAnchorPointForPosition(false)
                darkColor:setPosition(backColor:getContentSize().width / 2, 0)
                backColor:addChild(darkColor)

                local listener = cc.EventListenerTouchOneByOne:create()
                listener:setSwallowTouches(true)
                listener:registerScriptHandler(function(touch, event) return true end,cc.Handler.EVENT_TOUCH_BEGAN )
                darkColor:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, darkColor)

                local beibei = cc.Sprite:create("image/newstudy/background_yindao.png")
                beibei:setPosition(cc.p(darkColor:getContentSize().width / 2 , 170))
                darkColor:addChild(beibei)

                local beibei_tip_label = cc.Label:createWithSystemFont("划一划 !","",48)
                beibei_tip_label:setPosition(beibei:getContentSize().width /2, beibei:getContentSize().height * 0.5)
                beibei_tip_label:setColor(cc.c4b(36,63,79,255))
                beibei:addChild(beibei_tip_label)
            end
        end)
        local action3 = cc.RepeatForever:create(cc.Sequence:create(action1,action2))
        backColor:runAction(action3)
    elseif s_CURRENT_USER.slideNum == 2 then
        local lastTouchTime = 4
        mat.updateLastTouchTime = function()
            lastTouchTime = 4
        end
        local action1 = cc.DelayTime:create(1.0)
        local action2 = cc.CallFunc:create(function()
            lastTouchTime = lastTouchTime - 1
            if lastTouchTime <= 0 then
                backColor:stopAllActions()

                local lastButton = createLastButton(word,wrongNum,wrongWordList)
                backColor:addChild(lastButton, 3)

                local darkColor = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
                darkColor:setAnchorPoint(0.5,0)
                darkColor:ignoreAnchorPointForPosition(false)
                darkColor:setPosition(backColor:getContentSize().width / 2, 0)
                backColor:addChild(darkColor, 2)

                local listener = cc.EventListenerTouchOneByOne:create()
                listener:setSwallowTouches(true)
                listener:registerScriptHandler(function(touch, event) return true end,cc.Handler.EVENT_TOUCH_BEGAN )
                darkColor:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, darkColor)

                local beibei = cc.Sprite:create("image/newstudy/background_yindao.png")
                beibei:setPosition(cc.p(darkColor:getContentSize().width / 2 , 250))
                darkColor:addChild(beibei)

                local beibei_tip_label = cc.Label:createWithSystemFont("不记得就再看一遍","",48)
                beibei_tip_label:setPosition(beibei:getContentSize().width /2, beibei:getContentSize().height /2)
                beibei_tip_label:setColor(cc.c4b(36,63,79,255))
                beibei:addChild(beibei_tip_label)
            end
        end)
        local action3 = cc.RepeatForever:create(cc.Sequence:create(action1,action2))
        backColor:runAction(action3)
    end
end

return SlideCoconutLayer