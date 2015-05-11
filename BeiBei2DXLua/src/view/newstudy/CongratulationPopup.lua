local CongratulationPopup = class ("CongratulationPopup",function ()
    return cc.Layer:create()
end)

function CongratulationPopup.create()

    local layer = CongratulationPopup.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/newstudy/background_word_xinshouyindao_yellow.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    layer:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT*0.25))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local function closeAnimation()
        print("overtutorial"..s_CURRENT_USER.newTutorialStep)
        if s_CURRENT_USER.newTutorialStep == s_newtutorial_over then
            s_CURRENT_USER.newTutorialStep = s_newtutorial_loginreward
            saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})
        end

        local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_CorePlayManager.enterHomeLayer()
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end

    local partical = cc.ParticleSystemQuad:create('image/studyscene/ribbon.plist')
    partical:setPosition(back:getContentSize().width *0.5, back:getContentSize().height *0.5)
    back:addChild(partical)

    local popup_title = cc.Label:createWithSystemFont("恭喜完成新手教程","",40)
    popup_title:setPosition(back:getContentSize().width *0.5,back:getContentSize().height *0.5)
    popup_title:setColor(cc.c4b(29,156,196,255))
    popup_title:ignoreAnchorPointForPosition(false)
    popup_title:setAnchorPoint(0.5,0.5)
    back:addChild(popup_title)

    local girl_body = cc.Sprite:create("image/newstudy/body_yindao_complete.png")
    girl_body:setPosition(back:getContentSize().width *0.7,back:getContentSize().height * 0.8)
    girl_body:ignoreAnchorPointForPosition(false)
    girl_body:setAnchorPoint(0.5,0)
    back:addChild(girl_body, -1)

    local girl_head= cc.Sprite:create("image/newstudy/head_yindao_complete.png")
    girl_head:setPosition(girl_body:getContentSize().width *0.55,girl_body:getContentSize().height * 0.68)
    girl_head:ignoreAnchorPointForPosition(false)
    girl_head:setAnchorPoint(0.5,0)
    girl_body:addChild(girl_head)

    local action1 = cc.RotateBy:create(0.3,5)
    local action2 = cc.RotateBy:create(0.6,-10)
    local action3 = cc.RotateBy:create(0.3,5)

    local action = cc.Sequence:create(action1,action2,action3)
    girl_head:runAction(cc.RepeatForever:create(action))

    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
           closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    onAndroidKeyPressed(layer, function ()
        closeAnimation()
    end, function ()

    end)


    return layer
end

return CongratulationPopup