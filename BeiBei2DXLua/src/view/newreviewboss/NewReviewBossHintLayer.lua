local ProgressBar       = require("view.newreviewboss.NewReviewBossProgressBar")
local Pause             = require("view.newreviewboss.NewReviewBossPause")

local  NewReviewBossHintLayer = class("NewReviewBossHintLayer", function ()
    return cc.Layer:create()
end)


function NewReviewBossHintLayer.create(currentWordName)

    -- word info
--    local currentWordName   = s_CorePlayManager.ReviewWordList[s_CorePlayManager.currentReviewIndex]
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
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local type = s_CorePlayManager.typeIndex

    local layer = NewReviewBossHintLayer.new()
    
    local hint_button
    local white_back
    local line_y
    
    local wordList = {}
    table.foreachi(s_CorePlayManager.ReviewWordList, function(i, v)
        if  s_CorePlayManager.ReviewWordList[i] ~= "" then
            table.insert(wordList,s_CorePlayManager.ReviewWordList[i] )
        end
    end) 
    local wordListLen = table.getn(wordList)

    layer.close  = function ()
    	
    end
    
    local onTouchBegan = function(touch, event)
        playSound(s_sound_buttonEffect)            
        local action1 = cc.MoveTo:create(0.2, cc.p(s_RIGHT_X ,s_DESIGN_HEIGHT * 0.81 ))
        hint_button:runAction(action1)
        local action2 = cc.MoveTo:create(0.2, cc.p(s_DESIGN_WIDTH/2*3, s_DESIGN_HEIGHT * 0.4))
        white_back:runAction(action2)
        return true
    end

    local onTouchEnded = function(touch, event)
           layer.close()
    end
    
    local rbProgressBar = ProgressBar.create(wordListLen,s_CorePlayManager.rightReviewWordNum,"yellow")
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
    
    local hint_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            local action1 = cc.MoveTo:create(0.2, cc.p(s_RIGHT_X ,s_DESIGN_HEIGHT * 0.81 ))
            hint_button:runAction(action1)
            local action2 = cc.MoveTo:create(0.2, cc.p(s_DESIGN_WIDTH/2*3, s_DESIGN_HEIGHT * 0.55))
            white_back:runAction(action2)
        elseif eventType == ccui.TouchEventType.ended then
            layer.close()                          
        end
    end
    
    hint_button = ccui.Button:create("image/newreviewboss/buttontip.png","image/newreviewboss/buttontip.png","")
    hint_button:setPosition(s_RIGHT_X , s_DESIGN_HEIGHT * 0.81 )
    hint_button:ignoreAnchorPointForPosition(false)
    hint_button:setAnchorPoint(0.5,0.5)
    hint_button:addTouchEventListener(hint_click)
    layer:addChild(hint_button) 

    local action1 = cc.MoveTo:create(0.2, cc.p(s_RIGHT_X - 50,s_DESIGN_HEIGHT * 0.81 ))
    hint_button:runAction(action1)

    local hint_label = cc.Label:createWithSystemFont("偷看","",36)
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
    
    white_back = cc.Sprite:create("image/newreviewboss/backgroundreviewboss1tishi.png")
    white_back:setPosition(s_DESIGN_WIDTH/2*2, s_DESIGN_HEIGHT * 0.55)
    white_back:ignoreAnchorPointForPosition(false)
    white_back:setAnchorPoint(0.5,0.5)
    layer:addChild(white_back)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55))
    local action2 = cc.EaseBackOut:create(action1)
    white_back:runAction(action2)
    
    local  word_label = cc.Label:createWithSystemFont(wordname,"",32)  
    word_label:setPosition(white_back:getContentSize().width *0.1,white_back:getContentSize().height * (0.9  ))
    word_label:setColor(cc.c4b(0,0,0,255))
    word_label:ignoreAnchorPointForPosition(false)
    word_label:setAnchorPoint(0,0.5)
    white_back:addChild(word_label)
    
    local richtext1 = ccui.RichText:create()
    local opt_meaning = string.gsub(wordMeaning,"|||","\n")
    local current_word_wordMeaning = cc.LabelTTF:create (opt_meaning,
        "Helvetica",26, cc.size(white_back:getContentSize().width *0.9, 200), cc.TEXT_ALIGNMENT_LEFT)
    current_word_wordMeaning:setColor(cc.c4b(0,0,0,255))
    local richElement = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_wordMeaning)                           
    richtext1:pushBackElement(richElement) 
    richtext1:setContentSize(cc.size(white_back:getContentSize().width *0.9, 
        white_back:getContentSize().height *0.3)) 
    richtext1:ignoreContentAdaptWithSize(false)
    richtext1:ignoreAnchorPointForPosition(false)
    richtext1:setAnchorPoint(cc.p(0.5,0.5))
    richtext1:setPosition(white_back:getContentSize().width *0.5,white_back:getContentSize().height *0.7)
    richtext1:setLocalZOrder(10)       
    white_back:addChild(richtext1)
    
    line_y =  richtext1:getPositionY() - 50
       
        
    local gray_line = cc.LayerColor:create(cc.c4b(202,212,219,255),white_back:getContentSize().width *0.8,2)
    gray_line:ignoreAnchorPointForPosition(false)
    gray_line:setAnchorPoint(0.5,0.5)
    gray_line:setPosition(white_back:getContentSize().width *0.5,line_y - 50 )
    white_back:addChild(gray_line)

    local richtext2 = ccui.RichText:create()                        

    local current_word_sentence_En = cc.LabelTTF:create (sentenceEn,
        "Helvetica",30, cc.size(white_back:getContentSize().width *0.8, 150), cc.TEXT_ALIGNMENT_LEFT)
    current_word_sentence_En:setColor(cc.c4b(0,0,0,255))
    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_En)  
    
    local current_word_sentence_CN = cc.LabelTTF:create (sentenceCn,
        "Helvetica",30, cc.size(white_back:getContentSize().width *0.8, 150), cc.TEXT_ALIGNMENT_LEFT)
    current_word_sentence_CN:setColor(cc.c4b(0,0,0,255))
    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,current_word_sentence_CN)       
    
    richtext2:pushBackElement(richElement1) 
    richtext2:pushBackElement(richElement2)
    richtext2:setContentSize(cc.size(white_back:getContentSize().width *0.8, 
        white_back:getContentSize().height *0.2)) 
    richtext2:ignoreContentAdaptWithSize(false)
    richtext2:ignoreAnchorPointForPosition(false)
    richtext2:setAnchorPoint(cc.p(0.5,1))
    richtext2:setPosition(white_back:getContentSize().width *0.5, 
        line_y - 25 )
    richtext2:setLocalZOrder(10)                    

    white_back:addChild(richtext2) 
    
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer
end

return NewReviewBossHintLayer