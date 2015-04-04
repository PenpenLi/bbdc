require("cocos.init")
require("common.global")

local Button            = require("view.button.longButtonInStudy")
local NewReviewBossNode = require("view.newreviewboss.NewReviewBossNode")
local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")
local Pause             = require("view.newreviewboss.NewReviewBossPause")
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  NewReviewBossMainLayer = class("NewReviewBossMainLayer", function ()
    return cc.Layer:create()
end)

Review_From_Word_Bank = 1
Review_From_Normal    = 2

function NewReviewBossMainLayer.create(ReviewWordList,number)
    AnalyticsReviewBoss_EnterLayer()

    AnalyticsFirst(ANALYTICS_FIRST_REVIEW_BOSS, 'SHOW')

    --pause music
    cc.SimpleAudioEngine:getInstance():stopMusic()    

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local layer = NewReviewBossMainLayer.new()

    -- word info
    local currentWordName   
    local currentWord      
    local wordname         
    local wordSoundMarkEn   
    local wordSoundMarkAm   
    local wordMeaningSmall 
    local wordMeaning      
    local sentenceEn        
    local sentenceCn        
    local sentenceEn2       
    local sentenceCn2    
    
    local type = 1
    local answer
    
    local seed = math.randomseed(os.time())
    local randomType = math.random(1,10)
    type = randomType

   
    local wordList = {}
    table.foreachi(ReviewWordList, function(i, v)
        if  ReviewWordList ~= "" then
            table.insert(wordList,ReviewWordList[i] )
        end
    end) 
    local wordListLen = table.getn(wordList)
      
    local rbCurrentWordIndex = 1
    local wordToBeTested = {}
    local sprite_array = {}
    
    local getRandomWordForRightWord = function (wordname)
        local RandomWord = CollectUnfamiliar:createRandWord(wordname,3)
        local rightIndex = math.random(1,1024)%3 + 1

        if type%2 == 0 then    
            local ans = {}
            ans[rightIndex] = wordname
            if rightIndex == 1 then  ans[2] = RandomWord[2] ans[3] = RandomWord[3]
            elseif rightIndex == 2 then ans[3] = RandomWord[2] ans[1] = RandomWord[3]
            else ans[1] = RandomWord[2] ans[2] = RandomWord[3]        end
            return ans
        else
            local ans = {}
            ans[rightIndex]  = s_LocalDatabaseManager.getWordInfoFromWordName(wordname).wordMeaningSmall
            if rightIndex == 1 then
                ans[2] = s_LocalDatabaseManager.getWordInfoFromWordName(RandomWord[2]).wordMeaningSmall ans[3] = s_LocalDatabaseManager.getWordInfoFromWordName(RandomWord[3]).wordMeaningSmall
            elseif rightIndex == 2 then
                ans[3] = s_LocalDatabaseManager.getWordInfoFromWordName(RandomWord[2]).wordMeaningSmall  ans[1] = s_LocalDatabaseManager.getWordInfoFromWordName(RandomWord[3]).wordMeaningSmall
            else
                ans[1] = s_LocalDatabaseManager.getWordInfoFromWordName(RandomWord[2]).wordMeaningSmall ans[2] = s_LocalDatabaseManager.getWordInfoFromWordName(RandomWord[3]).wordMeaningSmall
            end
            return ans

        end
    end


    for i = 1,  wordListLen do
        table.insert(wordToBeTested,wordList[i])
        local words = getRandomWordForRightWord(wordList[i])
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            if i == 1 then
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 210 + 210*(j-1), 850 - 200*i - 150))
                sprite.opacity(0,255)
            elseif i == 2 then 
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 200*i - 150))
                sprite:setScale(0.8)
                sprite.opacity(0,102)
            else
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 200*i - 150))
                sprite:setScale(0)
                sprite.opacity(0,102)
            end
            layer:addChild(sprite,1)
            tmp[j] = sprite
        end
        sprite_array[i] = tmp
    end
    
    local checkTouchIndex = function(location)
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if cc.rectContainsPoint(sprite:getBoundingBox(), location) then
                    return {x=i, y=j}
                end
            end
        end
        return {x=-1, y=-1}
    end

    local updateWord = function ()
        local currentWordName   = wordToBeTested[rbCurrentWordIndex]
        local currentWord       = s_LocalDatabaseManager.getWordInfoFromWordName(currentWordName)
        local wordname          = currentWord.wordName
        local wordSoundMarkEn   = currentWord.wordSoundMarkEn
        local wordSoundMarkAm   = currentWord.wordSoundMarkAm
        local wordMeaningSmall  = currentWord.wordMeaningSmall
        local wordMeaning       = currentWord.wordMeaning
        local sentenceEn        = currentWord.sentenceEn
        local sentenceCn        = currentWord.sentenceCn
        local sentenceEn2       = currentWord.sentenceEn2
        local sentenceCn2       = currentWord.sentenceCn2
        return currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
            sentenceEn2,sentenceCn2
    end
    
    currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
            sentenceEn2,sentenceCn2 =  updateWord()

    local pauseButton = Pause.create(CreatePauseFromReview)
    pauseButton:setPosition(30 , s_DESIGN_HEIGHT -50)
    layer:addChild(pauseButton,100)
    
    local fillColor1 = cc.LayerColor:create(cc.c4b(10,152,210,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 393)
    fillColor1:setAnchorPoint(0.5,0)
    fillColor1:ignoreAnchorPointForPosition(false)
    fillColor1:setPosition(s_DESIGN_WIDTH/2,0)
    layer:addChild(fillColor1)

    local fillColor2 = cc.LayerColor:create(cc.c4b(26,169,227,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 604-373)
    fillColor2:setAnchorPoint(0.5,0)
    fillColor2:ignoreAnchorPointForPosition(false)
    fillColor2:setPosition(s_DESIGN_WIDTH/2,373)
    layer:addChild(fillColor2)

    local fillColor3 = cc.LayerColor:create(cc.c4b(36,186,248,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 811-604)
    fillColor3:setAnchorPoint(0.5,0)
    fillColor3:ignoreAnchorPointForPosition(false)
    fillColor3:setPosition(s_DESIGN_WIDTH/2,604)
    layer:addChild(fillColor3)

    local fillColor4 = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-811)
    fillColor4:setAnchorPoint(0.5,0)
    fillColor4:ignoreAnchorPointForPosition(false)
    fillColor4:setPosition(s_DESIGN_WIDTH/2,811)
    layer:addChild(fillColor4)
    
    local backGround = sp.SkeletonAnimation:create("spine/fuxiboss_background.json", "spine/fuxiboss_background.atlas", 1)
    backGround:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backGround)      
    backGround:addAnimation(0, 'animation', true)

    local rbProgressBar = ProgressBar.create(wordListLen,0,"orange")
    rbProgressBar:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.9)
    layer:addChild(rbProgressBar)
    
    local huge_word = cc.Label:createWithSystemFont(wordname,"",48)
    huge_word:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT * 0.8)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    layer:addChild(huge_word)
    
    if type % 2 == 0 then
        huge_word:setString(wordMeaningSmall)
    else
        huge_word:setString(wordname)
    end
    
    local rightWordFuntion = function ()
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then
                    sprite.two_to_one(j)
                elseif i == rbCurrentWordIndex then
                    sprite.three_to_two(j)
                elseif i == rbCurrentWordIndex + 1 then
                    sprite.four_to_three(j)
                elseif i == rbCurrentWordIndex + 2 then
                    sprite.five_to_four()
                else
                    sprite.more_to_five()
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))
        
        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
        sentenceEn2,sentenceCn2 = updateWord()
        if type % 2 == 0 then
            huge_word:setString(wordMeaningSmall)
        else
            huge_word:setString(wordname)
        end
    end
    
    local wrongWordFunction = function ()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        local action3 = cc.CallFunc:create(function()
            if number == Review_From_Word_Bank then
                local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossFailPopup")
                local newReviewBossLayerChange = NewReviewBossLayerChange.create(currentWordName,ReviewWordList,Review_From_Word_Bank)
                s_SCENE:popup(newReviewBossLayerChange)
            else
                local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossFailPopup")
                local newReviewBossLayerChange = NewReviewBossLayerChange.create(currentWordName,ReviewWordList,Review_From_Normal)
                s_SCENE:popup(newReviewBossLayerChange)
            end
            end)
        layer:runAction(cc.Sequence:create(action1, action2,action3))

    end
    
    local hintWordFunction = function ()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        table.insert(wordToBeTested, wordname)
        local words = getRandomWordForRightWord(wordname)
        local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), index_y - 200))
            sprite:setScale(0)
            layer:addChild(sprite)
            tmp[j] = sprite
        end
        table.insert(sprite_array, tmp)
        if type % 2 == 0 then
            answer = wordToBeTested[rbCurrentWordIndex]
        else
            answer = s_LocalDatabaseManager.getWordInfoFromWordName(wordToBeTested[rbCurrentWordIndex]).wordMeaningSmall
        end
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then
                elseif i == rbCurrentWordIndex then
                    sprite.two_to_three(j)
                elseif i == rbCurrentWordIndex + 1 then
                    sprite.four_to_three(j)
                elseif i == rbCurrentWordIndex + 2 then
                    sprite.five_to_four()
                else
                    sprite.more_to_five()           
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
        sentenceEn2,sentenceCn2 = updateWord()
        if type % 2 == 0 then
            huge_word:setString(wordMeaningSmall)
        else
            huge_word:setString(wordname)
        end
    end

    local button_func = function()
        playSound(s_sound_buttonEffect)
        local HintView = require("view.newreviewboss.NewReviewBossHintLayer")
        local hintView = HintView.create(currentWordName)
        s_SCENE:popup(hintView)                 
        hintWordFunction()          
    end
    local hint_button = Button.create("long","blue","提示我")
    hint_button:setPosition(s_DESIGN_WIDTH / 2, 100)
    hint_button.func = function ()
        button_func()
    end
    layer:addChild(hint_button,2) 
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        local logic_location = checkTouchIndex(location)
        if logic_location.x == rbCurrentWordIndex then
            if type % 2 == 0 then
                answer = wordToBeTested[logic_location.x]
            else
                answer = s_LocalDatabaseManager.getWordInfoFromWordName(wordToBeTested[logic_location.x]).wordMeaningSmall
            end
            if answer == sprite_array[logic_location.x][logic_location.y].character then
                sprite_array[logic_location.x][logic_location.y].right()
                playSound(s_sound_learn_true)
                playWordSound(wordname)
                local x = rbProgressBar:getPos()
                
                local position_X,position_Y = sprite_array[logic_location.x][logic_location.y]:getPosition()
                local true_mark = cc.Sprite:create("image/testscene/testscene_right_v.png")
                true_mark:setPosition(position_X,position_Y)
                layer:addChild(true_mark) 
                
                local action1 = cc.MoveTo:create(0.2,cc.p(x ,990))
                local action2 = cc.ScaleTo:create(0.2,0)
                true_mark:runAction(cc.Sequence:create(action1, action2,cc.CallFunc:create(function()rbProgressBar.addOne()end)))
                
            else
                sprite_array[logic_location.x][logic_location.y].wrong()    
                playSound(s_sound_learn_false)                    
                wrongWordFunction()  
                return true              
            end

            if rbCurrentWordIndex < #wordToBeTested then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                if answer == sprite_array[logic_location.x][logic_location.y].character then
                    rightWordFuntion()
                end
            else   
                AnalyticsReviewBoss_LeaveLayer()
                if s_CURRENT_USER.tutorialStep == s_tutorial_review_boss then
                   s_CURRENT_USER:setTutorialStep(s_tutorial_review_boss + 1)
                   s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_review_boss + 1)
                end         
                
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            
                s_SCENE:callFuncWithDelay(0.5,function()
                    local action1 = cc.MoveBy:create(0.5,cc.p(0,200))
                    rbProgressBar:runAction(action1)   
                    for i = 1, #wordToBeTested do
                        for j = 1, 3 do
                            local sprite = sprite_array[i][j]
                            local action1 = cc.ScaleTo:create(0.5, 0)
                            sprite:runAction(action1)
                        end
                    end
                end)
                
                local action1 = cc.DelayTime:create(1)
                local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action1, action2))

                s_SCENE:callFuncWithDelay(1,function()
                rbCurrentWordIndex = rbCurrentWordIndex + 1

                if number == Review_From_Word_Bank then
                	local SuccessLayer = require("view.newreviewboss.SuccessLayer")
                    local successLayer = SuccessLayer.create(0)
                    s_SCENE:replaceGameLayer(successLayer)
                else
                    s_CURRENT_USER:addBeans(3)
                    saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]}) 
                    if s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) then
                        s_level_popup_state = 1
                        s_CorePlayManager.leaveReviewModel(true)  
                    else
                        local missionCompleteCircle = require('view.MissionCompleteCircle').create()
                            s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
                            layer:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
                                if s_LocalDatabaseManager:getTodayRemainBossNum() <= 0 then
                                    s_level_popup_state = 1
                                end
                                s_CorePlayManager.leaveReviewModel(true)  
                            end,{})))
                    end
                end
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                end)
            end            
        end

        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end

return NewReviewBossMainLayer