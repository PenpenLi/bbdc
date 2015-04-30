local ProgressBar = class("ProgressBar", function()
    return cc.Layer:create()
end)

function ProgressBar.create(totalIndex, currentIndex, color)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local pngColor          = color
    local backImageName     = "image/progress/rb_progressBack_"..pngColor..".png"
    local frontImageName    = "image/progress/rb_progressFront_"..pngColor..".png"
    local indexImageName    = "image/progress/rb_progressIndex_"..pngColor..".png"

    local main = ProgressBar.new()
    main:setContentSize(s_DESIGN_WIDTH, 10)
    main:ignoreAnchorPointForPosition(false)
    main:setAnchorPoint(0.5,0.5)
    
    main.hint = function()
    end

    local local_size = main:getContentSize()

    -- init framework
    local progress_back = cc.Sprite:create(backImageName)
    progress_back:setPosition(local_size.width/2, local_size.height/2)
    main:addChild(progress_back)

    local progress = cc.ProgressTimer:create(cc.Sprite:create(frontImageName))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(100*currentIndex/totalIndex)
    main:addChild(progress)

    local left = (local_size.width - progress_back:getContentSize().width) / 2
    local gap = progress_back:getContentSize().width / totalIndex

    local index = cc.Sprite:create(indexImageName)
    index:setAnchorPoint(0.5,1)
    index:setPosition(left + gap*currentIndex, 0)
    main:addChild(index)

    local label_number = cc.Label:createWithSystemFont(currentIndex,"",24)
    label_number:setColor(cc.c4b(255,255,255,255))
    label_number:setPosition(index:getContentSize().width/2, index:getContentSize().height*0.4)
    index:addChild(label_number)

    main.indexPosition = function ()
        return index:getPosition()
    end
    
    main.swell = function ()
    	local action1 = cc.ScaleTo:create(0.5,1.2)
    	local action2 = cc.ScaleTo:create(0.5,1)
    	index:runAction(cc.Sequence:create(action1,action2))
    end

    main.addOne = function()
        currentIndex = currentIndex + 1
        label_number:setString(currentIndex)
        local action1 = cc.MoveTo:create(0.2,cc.p(left + gap* (currentIndex), 0))
        index:runAction(action1)
        local action2 = cc.ProgressTo:create(0.2, 100*(currentIndex)/totalIndex)
        progress:runAction(action2)
    end


    
    -- touch lock
    local onTouchBegan = function(touch, event)    
        local location = progress_back:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint({x=0,y=0,width=progress_back:getBoundingBox().width,height=progress_back:getBoundingBox().height}, location) then
            main.hint()
            return true
        end
        
        local location = index:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint({x=0,y=0,width=index:getBoundingBox().width,height=index:getBoundingBox().height}, location) then
            main.hint()
            return true
        end

        return false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end

return ProgressBar