require("common.global")

local SmallAlterWithOneButton = class("SmallAlterWithOneButton", function()
    return cc.Layer:create()
end)

function SmallAlterWithOneButton.create(info, btnMsg)
    local main = cc.Layer:create()
    main:setContentSize(s_DESIGN_WIDTH,s_DESIGN_HEIGHT)
    main:setPosition(cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.affirm = function()

    end

    main.close = function()
        main:removeFromParent()
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

    local function closeAnimation()
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        back:runAction(cc.Sequence:create(action2,cc.CallFunc:create(function()main.affirm()end)))
    end


    local button_ok_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            closeAnimation()
        end
    end

    local button_ok = ccui.Button:create("image/newstudy/button_onebutton_size.png","image/newstudy/button_onebutton_size_pressed.png","")
    button_ok:setPosition(back:getContentSize().width/2, back:getContentSize().height/2-70)
    if btnMsg == nil then
        button_ok:setTitleText("确定")
    else
        button_ok:setTitleText(tostring(btnMsg))
    end
    button_ok:setTitleFontSize(30)
    button_ok:addTouchEventListener(button_ok_clicked)
    back:addChild(button_ok)   
    
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


return SmallAlterWithOneButton







