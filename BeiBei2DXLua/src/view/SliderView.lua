require("cocos.init")
require("common.global")
CC_USE_DEPRECATED_API = true

local SliderView = class("SliderView", function()
    return cc.Layer:create()
end)

function SliderView.create(width,screen_height,content_height)
    local layer = SliderView.new()
    local scrollView = ccui.ScrollView:create()
    scrollView:setTouchEnabled(true)
    scrollView:setContentSize(cc.size(width,screen_height)) 
    scrollView:setInnerContainerSize(cc.size(width,content_height)) 
    scrollView:setBounceEnabled(true)       
    --scrollView:setPosition()
    layer:addChild(scrollView)
    layer.scrollView = scrollView

    local length = 836 * screen_height / s_DESIGN_HEIGHT

    local backBar = ccui.Scale9Sprite:create('image/book/process_button_light_color.png',cc.rect(0,0,15,856),cc.rect(0, 10, 15, 836))
    backBar:setContentSize(cc.size(15,20 + length))
    backBar:setPosition(0.97 * width,0.5 * screen_height)
    layer:addChild(backBar)  
    
    local progressBar = ccui.Scale9Sprite:create('image/book/process_button_dark_color.png',cc.rect(0,0,15,856),cc.rect(0, 10, 15, 836))
    --backBar:setContentSize(cc.size(15,1000))
    local percent = screen_height / content_height
    if percent > 1 then
        percent = 1
    end
    progressBar:setContentSize(cc.size(15,20 + length * percent))
    progressBar:ignoreAnchorPointForPosition(false)
    progressBar:setAnchorPoint(0.5,1)
    progressBar:setPosition(0.5 * backBar:getContentSize().width,backBar:getContentSize().height)
    backBar:addChild(progressBar)  

    local function update(delta)
        local h = scrollView:getInnerContainer():getPositionY()
        local y = - h / content_height - (content_height - screen_height) / content_height
        if h > 0 then
            s_logd('h > 0')
            local p = percent * (screen_height - h) / (screen_height)
            progressBar:setContentSize(cc.size(15,20 + length * p))
            progressBar:setAnchorPoint(0.5,0)
            progressBar:setPositionY(0)
        elseif y < 0 then
            progressBar:setContentSize(cc.size(15,20 + length * percent))
            progressBar:setAnchorPoint(0.5,1 - 10 / progressBar:getContentSize().height)
            progressBar:setPositionY((1 + y) * (backBar:getContentSize().height - 20) + 10)
        else
            local p = percent * (1 - y)
            progressBar:setContentSize(cc.size(15,20 + length * p))
            progressBar:setAnchorPoint(0.5,1)
            progressBar:setPositionY(backBar:getContentSize().height)
        end
        
    end

    layer:scheduleUpdateWithPriorityLua(update, 0) 
    return layer
end

function SliderView:ctor()

end

return SliderView