require("cocos.init")

require("common.global")


local NewReviewBossNode = require("view.newreviewboss.NewReviewBossNode")
local ProgressBar       = require("view.newstudy.NewStudyProgressBar")


local  NewReviewBossMainLayer = class("NewReviewBossMainLayer", function ()
    return cc.Layer:create()
end)



function NewReviewBossMainLayer.create()

    --pause music
    cc.SimpleAudioEngine:getInstance():pauseMusic()    

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
      
    local rbCurrentWordIndex = 1
    local wordToBeTested = {}
    local sprite_array = {}

    local updateWord = function ()
        local currentWordName   = s_CorePlayManager.ReviewWordList[s_CorePlayManager.currentReviewIndex]
        local currentWord       = s_WordPool[currentWordName]
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
            
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local layer = NewReviewBossMainLayer.new()
    
    local pauseBtn = ccui.Button:create("image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png","image/button/pauseButtonBlue.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    layer:addChild(pauseBtn,100)
    local Pause = require('view.Pause')
    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local pauseLayer = Pause.create()
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer:addChild(pauseLayer)
            s_SCENE.popupLayer.listener:setSwallowTouches(true)
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)
    
    local fillColor1 = cc.LayerColor:create(cc.c4b(10,152,210,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 263)
    fillColor1:setAnchorPoint(0.5,0)
    fillColor1:ignoreAnchorPointForPosition(false)
    fillColor1:setPosition(s_DESIGN_WIDTH/2,0)
    layer:addChild(fillColor1)

    local fillColor2 = cc.LayerColor:create(cc.c4b(26,169,227,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 542-263)
    fillColor2:setAnchorPoint(0.5,0)
    fillColor2:ignoreAnchorPointForPosition(false)
    fillColor2:setPosition(s_DESIGN_WIDTH/2,263)
    layer:addChild(fillColor2)

    local fillColor3 = cc.LayerColor:create(cc.c4b(36,186,248,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 776-542)
    fillColor3:setAnchorPoint(0.5,0)
    fillColor3:ignoreAnchorPointForPosition(false)
    fillColor3:setPosition(s_DESIGN_WIDTH/2,542)
    layer:addChild(fillColor3)

    local fillColor4 = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-776)
    fillColor4:setAnchorPoint(0.5,0)
    fillColor4:ignoreAnchorPointForPosition(false)
    fillColor4:setPosition(s_DESIGN_WIDTH/2,776)
    layer:addChild(fillColor4)

    local back = sp.SkeletonAnimation:create("spine/fuxiboss_background.json", "spine/fuxiboss_background.atlas", 1)
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(back)      
    back:addAnimation(0, 'animation', true)

    for i=1,s_CorePlayManager.currentReward do
        local reward = cc.Sprite:create("image/newstudy/bean.png")
        reward:setPosition(s_RIGHT_X - reward:getContentSize().width * i,
            s_DESIGN_HEIGHT)
        reward:ignoreAnchorPointForPosition(false)
        reward:setAnchorPoint(0.5,1)
        reward:setTag(i)
        layer:addChild(reward)  
    end

    local rbProgressBar = ProgressBar.create(s_CorePlayManager.maxReviewWordCount,s_CorePlayManager.rightReviewWordNum,"red")
    rbProgressBar:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.9)
    layer:addChild(rbProgressBar)

    local huge_word = cc.Label:createWithSystemFont(wordname,"",48)
    huge_word:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT * 0.8)
    huge_word:setColor(cc.c4b(0,0,0,255))
    huge_word:ignoreAnchorPointForPosition(false)
    huge_word:setAnchorPoint(0.5,0.5)
    layer:addChild(huge_word)


    local getRandomWordForRightWord = function(wordName)

        local tmp =  {"quotation","drama","critical","observer","open",
            "progress","entitle","blank","honourable","single",
            "namely","perfume","matter","lump","thousand",
            "recorder","great","guest","spy","cousin"}

        local wordNumber
        table.foreachi(tmp, function(i, v) if v == wordName then  wordNumber = i end end)               

        local randomIndex = (wordNumber + 5)%20 + 1 
        local word1 = tmp[randomIndex]
        local randomIndex = (wordNumber + 10)%20 + 1 
        local word2 = tmp[randomIndex]

        local rightIndex = math.random(1,1024)%3 + 1
        local ans = {}
        ans[rightIndex] = wordName
        if rightIndex == 1 then  ans[2] = word1 ans[3] = word2
        elseif rightIndex == 2 then ans[3] = word1 ans[1] = word2
        else ans[1] = word1 ans[2] = word2        end
        return ans
    end
    
    local rightWordFuntion = function ()
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                    local action2 = cc.ScaleTo:create(0.4, 0)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                    local action2 = cc.ScaleTo:create(0.4, 0.8)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(false)
                elseif i == rbCurrentWordIndex + 1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,260))
                    local action2 = cc.ScaleTo:create(0.4, 1)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(true)
                else
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,260))
                    sprite:runAction(cc.Sequence:create(action0, action1))
                    sprite.visible(false)
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        s_CorePlayManager.updateCurrentReviewIndex()
        currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
        sentenceEn2,sentenceCn2 = updateWord()
        huge_word:setString(wordname)
    end
    
    local wrongWordFunction = function ()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        s_CorePlayManager.insertReviewList(wordToBeTested[rbCurrentWordIndex])
        table.insert(wordToBeTested, wordToBeTested[rbCurrentWordIndex])
        local words = getRandomWordForRightWord(wordToBeTested[rbCurrentWordIndex])
        local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), index_y - 260))
            sprite:setScale(0.8)
            layer:addChild(sprite)
            tmp[j] = sprite
        end
        table.insert(sprite_array, tmp)
        for i = 1, #wordToBeTested do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if i <= rbCurrentWordIndex-1 then

                elseif i == rbCurrentWordIndex then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,-260))
                    local action2 = cc.ScaleTo:create(0.4, 0)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                elseif i == rbCurrentWordIndex + 1 then
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,260))
                    local action2 = cc.ScaleTo:create(0.4, 1)
                    local action3 = cc.Spawn:create(action1, action2)
                    sprite:runAction(cc.Sequence:create(action0, action3))
                    sprite.visible(true)
                else
                    local action0 = cc.DelayTime:create(0.1)
                    local action1 = cc.MoveBy:create(0.4, cc.p(0,260))
                    sprite:runAction(cc.Sequence:create(action0, action1))
                    sprite.visible(false)
                end
            end
        end
        local action1 = cc.DelayTime:create(0.5)
        local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
        layer:runAction(cc.Sequence:create(action1, action2))

        rbCurrentWordIndex = rbCurrentWordIndex + 1                
        s_CorePlayManager.updateCurrentReviewIndex()
        currentWordName,currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,wordMeaning,sentenceEn,sentenceCn,
        sentenceEn2,sentenceCn2 = updateWord()
        huge_word:setString(wordname)
    end

    local hint_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local HintView = require("view.newreviewboss.NewReviewBossHintLayer")
            local hintView = HintView.create()
            layer:addChild(hintView)           
            hintView.close = function ()
                hintView:removeFromParent()
                wrongWordFunction()
            end
        end
    end

    local hint_button = ccui.Button:create("image/newreviewboss/buttontip.png","image/newreviewboss/buttontip.png","")
    hint_button:setPosition(s_RIGHT_X , s_DESIGN_HEIGHT * 0.8 )
    hint_button:ignoreAnchorPointForPosition(false)
    hint_button:setAnchorPoint(0.5,0.5)
    hint_button:addTouchEventListener(hint_click)
    layer:addChild(hint_button) 

    local hint_label = cc.Label:createWithSystemFont("提示","",36)
    hint_label:setPosition(hint_button:getContentSize().width * 0.3,hint_button:getContentSize().height * 0.5)
    hint_label:setColor(cc.c4b(255,255,255,255))
    hint_label:ignoreAnchorPointForPosition(false)
    hint_label:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_label)
    
    local hint_arrow = cc.Sprite:create("image/newreviewboss/buttonarrow.png")
    hint_arrow:setPosition(hint_button:getContentSize().width * 0.6,hint_button:getContentSize().height * 0.5)
    hint_arrow:ignoreAnchorPointForPosition(false)
    hint_arrow:setAnchorPoint(0.5,0.5)
    hint_button:addChild(hint_arrow)

    for i = 1,  s_CorePlayManager.maxReviewWordCount do
        table.insert(wordToBeTested,s_CorePlayManager.ReviewWordList[i])
        local words = getRandomWordForRightWord(s_CorePlayManager.ReviewWordList[i])
        local tmp = {}
        for j = 1, 3 do
            local sprite = NewReviewBossNode.create(words[j])
            if i == 1 then
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 200 + 200*(j-1), 850 - 260*i - 260))
                sprite.visible(true)
            else
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 260*i - 260))
                sprite:setScale(0.8)
                sprite.visible(false)
            end
            layer:addChild(sprite)
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

    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        local logic_location = checkTouchIndex(location)
        if logic_location.x == rbCurrentWordIndex then
            playSound(s_sound_buttonEffect)
            if wordToBeTested[logic_location.x] == sprite_array[logic_location.x][logic_location.y].character then
                sprite_array[logic_location.x][logic_location.y].right()
            else
                sprite_array[logic_location.x][logic_location.y].wrong()             
                for j = 1, 3 do
                    if wordToBeTested[logic_location.x] == sprite_array[logic_location.x][j].character then
                        sprite_array[logic_location.x][j].right()
                	end
                end
                layer:removeChildByTag(s_CorePlayManager.currentReward)
                s_CorePlayManager.currentReward = s_CorePlayManager.currentReward - 1             
                if s_CorePlayManager.currentReward <= 0 then
                    local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossFailPopup")
                    local newReviewBossLayerChange = NewReviewBossLayerChange.create()
                    s_SCENE:popup(newReviewBossLayerChange)
                end
                wrongWordFunction()
            end

            if rbCurrentWordIndex < #wordToBeTested then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                if wordToBeTested[logic_location.x] == sprite_array[logic_location.x][logic_location.y].character then
                   rightWordFuntion()
                end
            else
                rbCurrentWordIndex = rbCurrentWordIndex + 1
                s_CorePlayManager.enterReviewBossSummaryLayer()
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
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