require "common.global"

local ZiaoangTest = class("ZiaoangTest", function()
    return cc.Layer:create()
end)

function ZiaoangTest.create()
    -- system variate
    local main = ZiaoangTest.new()
    --main:setContentSize(640,640)
    --main:setAnchorPoint(0,0)
    
    local colorBlock = cc.LayerColor:create(cc.c4b(255,0,0,255),400,400)
    main:addChild(colorBlock)
    
    local sub_colorBlock = cc.LayerColor:create(cc.c4b(255,255,0,255),100,100)
    sub_colorBlock:setPosition(100,100)
    sub_colorBlock:ignoreAnchorPointForPosition(false)
    colorBlock:addChild(sub_colorBlock)
    
    onTouchBegan1 = function(touch, event)
        s_logd("touch 1")

        -- CCTOUCHBEGAN event must return true
        return true
    end
    
    local hasTouched = false
    onTouchBegan2 = function(touch, event)
    
        if hasTouched then
            return false
        else
            hasTouched = true
            s_logd("touch 2")
            return true
        end
    end
    
    onTouchEnded2 = function(touch, event)
        s_logd("ended 2")
        hasTouched = false
    end
    
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:registerScriptHandler(onTouchBegan1, cc.Handler.EVENT_TOUCH_BEGAN )
    listener1:setSwallowTouches(true)
    local eventDispatcher1 = colorBlock:getEventDispatcher()
    eventDispatcher1:addEventListenerWithSceneGraphPriority(listener1, colorBlock)
    
    
    local listener2 = cc.EventListenerTouchOneByOne:create()
    listener2:registerScriptHandler(onTouchBegan2, cc.Handler.EVENT_TOUCH_BEGAN )
    listener2:registerScriptHandler(onTouchEnded2, cc.Handler.EVENT_TOUCH_ENDED )
    listener2:setSwallowTouches(true)
    local eventDispatcher2 = sub_colorBlock:getEventDispatcher()
    eventDispatcher2:addEventListenerWithSceneGraphPriority(listener2, sub_colorBlock)
    
    
    local button_donotknow_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local b = cc.Sprite:create("image/testscene/testscene_donotkonw.png")
            b:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
            main:addChild(b)
        end
    end

    --local button_donotknow = nil
    local button_donotknow = ccui.Button:create("image/testscene/testscene_donotkonw.png","","")
    button_donotknow:setAnchorPoint(1,0.5)
    --button_donotknow:setPosition(s_DESIGN_WIDTH+button_donotknow:getContentSize().width,896)
    button_donotknow:setPosition(s_DESIGN_WIDTH,896)
    button_donotknow:addTouchEventListener(button_donotknow_clicked)
    main:addChild(button_donotknow)
    
    return main
end


return ZiaoangTest







