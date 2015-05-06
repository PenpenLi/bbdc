local BeibeiLayer = require("view.newstudy.BeibeiLayer")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip")

local  GuideLayer = class("GuideLayer", function ()
    return cc.Layer:create()
end)

GUIDE_ENTER_COLLECT_WORD_LAYER  = 'COLLECT_WORD'
GUIDE_CLICK_I_KNOW_BUTTON       = 'CLICK_I_KNOW_BUTTON'
GUIDE_ENTER_FORGE_IRON_LAYER    = 'ENTER_FORGE_IRON'

function GuideLayer.create(GUIDE_TYPE,word)
    local layer = GuideLayer.new(GUIDE_TYPE)
    if word ~= nil then
        layer.word = word
    end
    return layer
end

function GuideLayer:createFromCollectWord(GUIDE_TYPE)
    local back_exist = true
    local back = cc.Sprite:create("image/newstudy/background_yindao_big.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self:addChild(back)

    local title = cc.Label:createWithSystemFont('新手任务','',28)
    title:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.8)
    title:setColor(cc.c3b(35,181,229))
    back:addChild(title)

    if GUIDE_TYPE == GUIDE_ENTER_COLLECT_WORD_LAYER then

        local richtext1 = ccui.RichText:create()
         
        local richElement = {
        ccui.RichElementText:create(1,cc.c3b(0  , 0  , 0  ),255,"找到","Helvetica",26),
        ccui.RichElementText:create(2,cc.c3b(35 , 181, 229),255,"3","Helvetica",26),  
        ccui.RichElementText:create(3,cc.c3b(0  , 0  , 0  ),255,"个","Helvetica",26),  
        ccui.RichElementText:create(4,cc.c3b(35 , 181, 229),255,"不认识","Helvetica",26),  
        ccui.RichElementText:create(5,cc.c3b(0  , 0  , 0  ),255,"的生词","Helvetica",26)   }
        
        for i=1,#richElement do
            richtext1:pushBackElement(richElement[i]) 
        end

        richtext1:setContentSize(cc.size(300,50)) 
        richtext1:ignoreContentAdaptWithSize(false)
        richtext1:ignoreAnchorPointForPosition(false)
        richtext1:setAnchorPoint(cc.p(0.5,0.5))
        richtext1:setPosition(back:getContentSize().width/2 + 10,back:getContentSize().height*0.5)     
        back:addChild(richtext1)

    else
        local text1 = cc.Label:createWithSystemFont('请选择正确的意思','',28)
        text1:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.65)
        text1:setColor(cc.c3b(0,0,0))
        back:addChild(text1)

        local text2 = cc.Label:createWithSystemFont('（忘记了请选择不认识）','',28)
        text2:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.45)
        text2:setColor(cc.c3b(35,181,229))
        back:addChild(text2)
    end




    local beibei

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.40))
    local action2 = cc.EaseBackOut:create(action1)
    local action3 = cc.CallFunc:create(function()
            beibei = BeibeiLayer.create(BEIBEI_ENTER_COLLECT_WORD_LAYER)
            self:addChild(beibei)
        end)
    back:runAction(cc.Sequence:create(action2,action3))

    local function closeAnimation() 
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        if back_exist ~= true then
            return
        end
        local action1 = cc.CallFunc:create(function()
            if beibei ~= nil then
                beibei.remove()
            end           
        end)
        local action2 = cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3))
        local action3 = cc.EaseBackIn:create(action2)
        local action4 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        local action5 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
        back:runAction(cc.Sequence:create(action1,action3,action4,action5))
        back_exist = false
    end

    s_SCENE:callFuncWithDelay(6, function ()
        if closeAnimation() ~= nil then closeAnimation() end
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        if closeAnimation() ~= nil then closeAnimation() end
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)


    onAndroidKeyPressed(self, function ()
        closeAnimation()
    end, function ()

    end)
end

function GuideLayer:createFromFamiliarWord()

    local back_exist = "tip1"

    local back = cc.Sprite:create("image/newstudy/background_yindao.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self:addChild(back)

    local title = cc.Label:createWithSystemFont('词汇量不错！遇到一个熟词','',28)
    title:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.5)
    title:setColor(cc.c3b(0,0,0))
    back:addChild(title)

    local beibei = cc.Sprite:create("image/newstudy/bb_body_yindao.png")
    beibei:setPosition(back:getContentSize().width/2,back:getContentSize().height + 8)
    beibei:ignoreAnchorPointForPosition(false)
    beibei:setAnchorPoint(0.5,0.5)
    back:addChild(beibei)

    local beibei_head = cc.Sprite:create("image/newstudy/bb_head_yindao.png")
    beibei_head:setPosition(beibei:getContentSize().width/2 - 15,beibei:getContentSize().height + 60)
    beibei_head:ignoreAnchorPointForPosition(false)
    beibei_head:setAnchorPoint(0.5,0.5)
    beibei:addChild(beibei_head)

    local beibei_arm = cc.Sprite:create("image/newstudy/bb_arm_yindao.png")
    beibei_arm:setPosition(back:getContentSize().width/2 +30,back:getContentSize().height +16)
    beibei_arm:setRotation(45)
    beibei_arm:ignoreAnchorPointForPosition(false)
    beibei_arm:setAnchorPoint(0,0.5)
    back:addChild(beibei_arm,-1)

    local action1 = cc.RotateBy:create(0.5,3)
    local action2 = cc.RotateBy:create(0.5,-3)
    local action3 = cc.DelayTime:create(0.5)
    local action4 = cc.RepeatForever:create(cc.Sequence:create(action1,action2,action3))
    beibei_head:runAction(action4) 

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55))
    local action2 = cc.EaseBackOut:create(action1)
    local action3 = cc.CallFunc:create(function()

        end)
    back:runAction(cc.Sequence:create(action2))

    

    local function closeAnimation() 
        if back_exist == "tip1" then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local action1 = cc.CallFunc:create(function()
                beibei_head:stopAllActions()
            end)
            local action2 = cc.RotateBy:create(0.2,-45)
            local action3 = cc.MoveBy:create(1,cc.p(3,3))
            local action4 = cc.MoveBy:create(1,cc.p(-3,-3))
            local action5 = cc.MoveBy:create(1,cc.p(5,5))
            local action6 = cc.MoveBy:create(1,cc.p(-5,-5))
            local action7 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            beibei_arm:runAction(cc.Sequence:create(action1,action2,action3,action4,action5,action6,action7))
            title:setString("这个熟词在这里喔！")
            back_exist = "tip2"
            local action5 = cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.75))
            local action6 = cc.EaseBackIn:create(action5)
            back:runAction(cc.Sequence:create(action6))
            
            local lastWordAndTotalNumberTip = LastWordAndTotalNumber:create()
            s_SCENE.popupLayer:addChild(lastWordAndTotalNumberTip)
            
            if self.word ~= nil then
                lastWordAndTotalNumberTip.setWord(self.word,nil)
            end
        elseif back_exist == "tip2" then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            back_exist = "null"
            local action2 = cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3))
            local action3 = cc.EaseBackIn:create(action2)
            local action4 = cc.CallFunc:create(function()
                local LastWordInfo = require("view.newstudy.LastWordInfoPopup")
                local lastWordInfo = LastWordInfo.create(self.word)
                s_SCENE:popup(lastWordInfo)
            end)
            local action5 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            back:runAction(cc.Sequence:create(action3,action4,action5))
        end
    end

    s_SCENE:callFuncWithDelay(2.5,function ()
        if closeAnimation() ~= nil then closeAnimation() end
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)

    s_SCENE:callFuncWithDelay(5.5,function ()
        if closeAnimation() ~= nil then closeAnimation() end
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        closeAnimation()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() 
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)


    onAndroidKeyPressed(self, function ()
        closeAnimation()
    end, function ()

    end)
end

function GuideLayer:ctor(GUIDE_TYPE)
    if GUIDE_TYPE == GUIDE_ENTER_COLLECT_WORD_LAYER or GUIDE_TYPE == GUIDE_ENTER_FORGE_IRON_LAYER then
        self:createFromCollectWord(GUIDE_TYPE)
    elseif GUIDE_TYPE == GUIDE_CLICK_I_KNOW_BUTTON then
        self:createFromFamiliarWord()
    end

end

return GuideLayer