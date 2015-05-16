local Button                = require("view.button.longButtonInStudy")

local GuessWrongPunishPopup = class ("GuessWrongPunishPopup",function ()
    return cc.Layer:create()
end)

function GuessWrongPunishPopup.create(currentReward,totalReward)
    local layer = GuessWrongPunishPopup.new(currentReward,totalReward)
    return layer
end

function GuessWrongPunishPopup:ctor(currentReward,totalReward)

    if currentReward == nil then
        currentReward = 3
    end
    
    if totalReward == nil then
        totalReward = 3
    end
    
--    s_CorePlayManager.reward = s_CorePlayManager.reward - 1

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local back = cc.Sprite:create("image/newstudy/guesswrong.png")
    back:setPosition(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2*3)
    self:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth / 2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)
    
    local text = cc.Label:createWithSystemFont("瞎猜是会损失贝贝豆的哦！","",30)
    text:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.8)
    text:setColor(cc.c4b(84,107,140,255))
    back:addChild(text)
    
    for i = 1,totalReward do
        local bean = cc.Sprite:create("image/chapter/chapter0/bean.png")
        bean:setPosition(back:getContentSize().width * (0.3 +  ( 3 - totalReward) * 0.1 + (i - 1) * 0.2),back:getContentSize().height * 0.5)
        bean:setName("bean"..i)
        back:addChild(bean)
    end
    
    for i = currentReward,totalReward do
        local bean = back:getChildByName("bean"..i)
        bean:setTexture("image/newstudy/badbean.png")
    end

    local sprite = back:getChildByName("bean"..currentReward)
    local animation = sp.SkeletonAnimation:create("spine/fuxiboss_bea_dispare.json", "spine/fuxiboss_bea_dispare.atlas", 1)
    animation:setPosition(sprite:getContentSize().width / 2, 0)
    sprite:addChild(animation)     
    animation:setVisible(false)
    sprite:setTexture("image/chapter/chapter0/bean.png")
    local action3 = cc.DelayTime:create(0.8) 
    self:runAction(cc.Sequence:create(action3,cc.CallFunc:create(function() 
        if animation ~= nil then
            animation:setVisible(true)
            animation:addAnimation(0, 'oudupus2', false)
            sprite:setTexture("image/newstudy/badbean.png")
        end
    end)))


    local button_func = function()
        playSound(s_sound_buttonEffect)
        local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
        local action2 = cc.EaseBackIn:create(action1)
        local action3 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(action2,action3))
    end  

    local button_goon =  Button.create("small","blue","明白啦")
    button_goon:setPosition(back:getContentSize().width * 0.5,back:getContentSize().height * 0.2)
    button_goon.func = function ()
        button_func()
    end
    back:addChild(button_goon)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.5,cc.p(s_LEFT_X + bigWidth/2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                s_SCENE:removeAllPopups()
            end)
            back:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return GuessWrongPunishPopup