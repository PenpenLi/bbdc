require("cocos.init")
require("common.global")

local Button                = require("view.button.longButtonInStudy")

local  SuccessLayer = class("SuccessLayer", function ()
    return cc.Layer:create()
end)

function SuccessLayer.create(number)
    local layer = SuccessLayer.new(number)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function createBeanSprite(bean)
    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)

    local been_number = cc.Label:createWithSystemFont(bean,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)

    return beans
end

local function createNextButton(getBean)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_func = function()
        playSound(s_sound_buttonEffect)
        s_HUD_LAYER:removeChildByName('missionCompleteCircle')
        s_CorePlayManager.enterLevelLayer()
    end

    local button_go = Button.create("long","blue","迎战总结怪兽！")
    button_go.func = function ()
        button_func()
    end
    button_go:setPosition(bigWidth/2, 100)

    local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean:setPosition(button_go.button_front:getContentSize().width * 0.75,button_go.button_front:getContentSize().height * 0.5)
    button_go.button_front:addChild(bean)

    local rewardNumber = cc.Label:createWithSystemFont("+"..tostring(getBean),"",36)
    rewardNumber:setPosition(button_go.button_front:getContentSize().width * 0.85,button_go.button_front:getContentSize().height * 0.5)
    button_go.button_front:addChild(rewardNumber)

    local action0 = cc.DelayTime:create(1)
    local action1 = cc.MoveBy:create(1,cc.p(-button_go:getContentSize().width * 0.25 + bigWidth/2 - 100 ,-button_go:getContentSize().height * 0.5 - 100 +s_DESIGN_HEIGHT-40)) 
    local action2 = cc.ScaleTo:create(0.1,0)
    bean:runAction(cc.Sequence:create(action0,action1,action2))  

    return button_go
end

function SuccessLayer:ctor(number)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(127,239,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setAnchorPoint(0.5,0.5)
    self:addChild(backColor)

    self.bean = s_CURRENT_USER:getBeans()
    self.beanSprite = createBeanSprite(self.bean)
    self:addChild(self.beanSprite)
    
    local label_hint = cc.Label:createWithSystemFont("打败复习怪物！","",50)
    label_hint:setPosition(backColor:getContentSize().width / 2, 900)
    label_hint:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(label_hint)
    
    local waveSprite = cc.Sprite:create("image/newreviewboss/wave.png")
    waveSprite:setPosition(backColor:getContentSize().width / 2,0)
    waveSprite:ignoreAnchorPointForPosition(false)
    waveSprite:setAnchorPoint(0.5,0)
    backColor:addChild(waveSprite)
    
    local bossDieSpine = sp.SkeletonAnimation:create('spine/reviewboss/beidafeide_zhanglaoshi.json', 'spine/reviewboss/beidafeide_zhanglaoshi.atlas',1)
    bossDieSpine:addAnimation(0, 'animation', true)
    bossDieSpine:setPosition(waveSprite:getContentSize().width * 0.25,200)
    waveSprite:addChild(bossDieSpine,1)

    self.getBean = 3
    if number ~= nil then
    self.getBean = number
    end
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
    s_CURRENT_USER.beanRewardForCollect             = 3
    s_CURRENT_USER.beanRewardForIron                = 3

    onAndroidKeyPressed(self, function ()
        s_HUD_LAYER:removeChildByName('missionCompleteCircle')
        s_CorePlayManager.enterLevelLayer()
    end, function ()

    end)

end

return SuccessLayer