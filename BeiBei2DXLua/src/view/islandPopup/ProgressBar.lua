local ProgressBar = class("ProgressBar", function()
    return cc.Layer:create()
end)

function ProgressBar.create(totalIndex, currentIndex)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backImageName     = "image/islandPopup/subtask_progress_bar_bg.png"
    local frontImageName    = "image/islandPopup/subtask_progress_bar_rectangle.png"

    local main = ProgressBar.new()
    main:setContentSize(s_DESIGN_WIDTH, 10)
    main:ignoreAnchorPointForPosition(false)
    main:setAnchorPoint(0.5,0.5)

    local local_size = main:getContentSize()

    if currentIndex > 3 then
        currentIndex = currentIndex - 1
    end

    -- init framework
    local progress_back = cc.Sprite:create(backImageName)
    progress_back:setPosition(local_size.width/2, local_size.height/2)
    main:addChild(progress_back)

    local progress = cc.ProgressTimer:create(cc.Sprite:create(frontImageName))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(100 * currentIndex / totalIndex)
    main:addChild(progress,1)

    local width = progress_back:getContentSize().width - 20
    local left = (local_size.width - width) / 2 
    local gap = width / totalIndex



    local index = cc.Sprite:create("image/islandPopup/subtask_progress_bar_circle.png")
    index:setAnchorPoint(0.5,0.5)
    index:setPosition(left + gap*currentIndex, 5)
    main:addChild(index,1)

    local index_beibei = cc.Sprite:create("image/islandPopup/subtask_progress_bar_beibei_present.png")
    index_beibei:setAnchorPoint(0.5,0.5)
    index_beibei:setPosition(index:getContentSize().width / 2, 75)
    index:addChild(index_beibei) 

    local lightPositionX = left + gap*currentIndex
    if currentIndex > 0 and currentIndex< 3 then 
        lightPositionX = left + gap* (currentIndex - 1)
    end
    local light = cc.Sprite:create("image/islandPopup/subtask_progress_bar_circle_at_present.png")
    light:setAnchorPoint(0.5,0.5)
    light:setPosition(lightPositionX, 5)
    main:addChild(light,1)

    for i=0,totalIndex do
        local point_sprite 
        if i == 2 then
            point_sprite = cc.Sprite:create("image/islandPopup/subtask_progress_bar_milestone.png")
        else
            point_sprite = cc.Sprite:create("image/islandPopup/subtask_progress_bar_unfinished_circle.png")
        end
        point_sprite:setAnchorPoint(0.5,0.5)
        point_sprite:setPosition(left + gap*i , 5)
        main:addChild(point_sprite)
    end

    local flag = cc.Sprite:create("image/islandPopup/subtask_progress_bar_flag.png")
    flag:setAnchorPoint(0.5,0)
    flag:setPosition(progress_back:getContentSize().width, 20)
    progress_back:addChild(flag)

    main.addOne = function()
        currentIndex = currentIndex + 1
        local action1 = cc.MoveTo:create(0.2,cc.p(left + gap* (currentIndex), 4))
        index:runAction(action1)
        local action2 = cc.ProgressTo:create(0.2, 100*(currentIndex)/totalIndex)
        progress:runAction(action2)
    end

    main.moveLightCircle = function (Papeindex)
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        local widthMax =  local_size.width
        local action1 = cc.MoveTo:create(0.2,cc.p(left + gap* Papeindex, 4))
        light:runAction(action1)
        s_SCENE:callFuncWithDelay(0.2, function()
                 s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
              end)
    end

    return main
end

return ProgressBar