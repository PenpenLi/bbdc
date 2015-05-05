require("common.global")

local SmallAlter = class("SmallAlter", function()
    return cc.Layer:create()
end)

function SmallAlter.create(info)
    local main = cc.Layer:create()
    main:setContentSize(s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    main:ignoreAnchorPointForPosition(false)

    main.affirm = function()
--        main:removeFromParent()
        
    end

    main.close = function()
    
    end

    local back = cc.Sprite:create("image/alter/tanchu_board_small_white.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local label_info = cc.Label:createWithSystemFont(info,"",28)
    label_info:setColor(cc.c4b(0,0,0,255))
    label_info:setDimensions(back:getContentSize().width*4/5,0)
    label_info:setPosition(back:getContentSize().width/2, back:getContentSize().height/2+50)
    back:addChild(label_info)
    
    

    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            main.affirm()
        end
    end

    local button_left = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
    button_left:setPosition(back:getContentSize().width/2-120, back:getContentSize().height/2-70)
    button_left:setTitleText("确定")
    button_left:setTitleFontSize(30)
    button_left:addTouchEventListener(button_left_clicked)
    back:addChild(button_left)
    
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            main.close()
            playSound(s_sound_buttonEffect)
        end
    end

    local button_right = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
    button_right:setPosition(back:getContentSize().width/2+120, back:getContentSize().height/2-70)
    button_right:setTitleText("取消")
    button_right:setTitleFontSize(30)
    button_right:addTouchEventListener(button_right_clicked)
    back:addChild(button_right)

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        back:runAction(cc.Sequence:create(action2,cc.CallFunc:create(function()main.close()end)))
    end

    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main) 

    onAndroidKeyPressed(main, function ()
        closeAnimation()
    end, function ()

    end)

    return main    
end


return SmallAlter







