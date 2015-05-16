require("cocos.init")
require("common.global")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")
local Button                = require("view.button.longButtonInStudy")
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")
local  MiddleLayer = class("MiddleLayer", function ()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

function MiddleLayer:ShakeFunction(k,times)
    local action1 = cc.MoveBy:create(0.05, cc.p(-5 * k,0))
    local action2 = cc.MoveBy:create(0.05, cc.p(10 * k,0))
    local action3 = cc.MoveBy:create(0.05, cc.p(-10 * k , 0))
    local action6 = cc.ScaleTo:create(0.05, 1.1)
    local action7 = cc.ScaleTo:create(0.05, 1)
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action6 ,action3, action7),times)
    local action5 = cc.MoveBy:create(0.05, cc.p(5 * k,0)) 
    local action = cc.Sequence:create(action1, action4, action5, nil)
    return action
end

function MiddleLayer.create()
    local layer = MiddleLayer.new()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function calculationAngle(point)
   return math.acos(point.x / math.sqrt(point.y * point.y + point.x * point.x) )
end

local function wordAnimation(endPoint,back1,back2)
    local wordList = {}
    local bossId = s_LocalDatabaseManager.getMaxBossID()
    local boss = s_LocalDatabaseManager.getBossInfo(bossId)
    for i=1, getMaxWrongNumEveryLevel() do
        table.insert(wordList,boss.wrongWordList[i])
    end
    back1:runAction(MiddleLayer:ShakeFunction(1,1))
    back2:runAction(MiddleLayer:ShakeFunction(1,1))
    local wordLabel = {}
    for i=1, getMaxWrongNumEveryLevel() do
        local rand = math.randomseed(os.time() * i)
        wordLabel[i] = cc.Label:createWithSystemFont(wordList[i],"",30)
        wordLabel[i]:setColor(cc.c4b(0,0,0,255))
        local beginPoint = cc.p(math.random(1,150) - 75,  math.random(1,25) + 200)
        wordLabel[i]:setPosition(endPoint.x + beginPoint.x, endPoint.y + beginPoint.y) 
        local angle = math.deg(calculationAngle(beginPoint))
        local randAngle = math.random(1,40) - 20 
        wordLabel[i]:setRotation(-angle + randAngle)
        wordLabel[i]:setVisible(false)
    end
    local time = 0
    local i = 1
    local function update(delta)
        time = time + delta
        if time * 10 > getMaxWrongNumEveryLevel() + 1 then
            back1:unscheduleUpdate()
            back1:runAction(MiddleLayer:ShakeFunction(2,2))
            back2:runAction(MiddleLayer:ShakeFunction(2,2))
        elseif time * 10 > i then
            wordLabel[i]:setVisible(true)  
            wordLabel[i]:runAction(cc.MoveTo:create(0.3,cc.p(endPoint.x,endPoint.y - 50)))
            wordLabel[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.FadeOut:create(0.1)))
            i = i + 1
        end
    end
    back1:scheduleUpdateWithPriorityLua(update, 0)


    return wordLabel
end

local function createBeanSprite(bean)
    local beens = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beens:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)

    local been_number = cc.Label:createWithSystemFont(bean,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beens:getContentSize().width * 0.65 , beens:getContentSize().height/2)
    beens:addChild(been_number)
    
    return beens
end

local function createNumberSprite(wrongNumber)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local figureback_main = cc.Sprite:create("image/newstudy/figurebackground.png")
    figureback_main:setPosition(bigWidth /2 + 100, 1000)
    figureback_main:setOpacity(0)

    local figureback_sub = cc.Sprite:create("image/newstudy/figurebackground.png")
    figureback_sub:setPosition(figureback_main:getContentSize().width / 2+40 ,figureback_main:getContentSize().height / 2)
    figureback_main:addChild(figureback_sub)

    local label_hint_part_one = cc.Label:createWithSystemFont("恭喜！收集到生词","",40)
    label_hint_part_one:setPosition(30, 50)
    label_hint_part_one:ignoreAnchorPointForPosition(false)
    label_hint_part_one:setAnchorPoint(1,0.5)
    label_hint_part_one:setColor(cc.c4b(42,120,158,255))
    figureback_main:addChild(label_hint_part_one)

    local label_hint_part_two = cc.Label:createWithSystemFont("个","",40)
    label_hint_part_two:setPosition(160, 50)
    label_hint_part_two:ignoreAnchorPointForPosition(false)
    label_hint_part_two:setAnchorPoint(0,0.5)
    label_hint_part_two:setColor(cc.c4b(42,120,158,255))
    figureback_main:addChild(label_hint_part_two)

    local labelWordNum = cc.Label:createWithSystemFont(0,"",60)
    labelWordNum:setPosition(90,50)
    labelWordNum:setColor(cc.c4b(242,121,0,255))
    figureback_main:addChild(labelWordNum)
    
    local time = 0
    local function update(delta)
       time = time + delta
       if time <= 1 then
       elseif time <= 2 then
            labelWordNum:setString(math.floor(wrongNumber * (time - 1)))
       else
            labelWordNum:setString(wrongNumber)
            figureback_main:unscheduleUpdate()
       end
    end
    figureback_main:scheduleUpdateWithPriorityLua(update, 0)
    
    return figureback_main
end

local function createNextButton(getBean)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local button_func = function()
        playSound(s_sound_buttonEffect)        
        s_level_popup_state = 1
        s_HUD_LAYER:removeChildByName('missionCompleteCircle')
        s_CURRENT_USER.beanRewardForIron = 3
        s_CorePlayManager.leaveStudyOverModel()
    end

    local button_go = Button.create("long","blue","趁热打铁") 
    button_go:setPosition(bigWidth/2, 100)
    button_go.func = function ()
        button_func()
    end

    local bean = cc.Sprite:create("image/newreviewboss/beibeidou2.png")
    bean:setPosition(button_go.button_front:getContentSize().width * 0.75,button_go.button_front:getContentSize().height * 0.5)
    button_go.button_front:addChild(bean)

    local rewardNumber = cc.Label:createWithSystemFont("+"..tostring(getBean),"",36)
    rewardNumber:setPosition(button_go.button_front:getContentSize().width * 0.85,button_go.button_front:getContentSize().height * 0.5)
    button_go.button_front:addChild(rewardNumber)

    local action0 = cc.DelayTime:create(1)
    local action1 = cc.MoveBy:create(1,cc.p(-button_go:getContentSize().width * 0.25 + bigWidth/2 - 100 ,-button_go:getContentSize().height * 0.5 - 100 +s_DESIGN_HEIGHT-50)) 
    local action2 = cc.ScaleTo:create(0.1,0)
    bean:runAction(cc.Sequence:create(action0,action1,action2))  

    return button_go
end

function MiddleLayer:ctor()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(168,239,255,255), bigWidth, s_DESIGN_HEIGHT)  

    local back_head = cc.Sprite:create("image/newstudy/back_head.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT)
    backColor:addChild(back_head)

    local back_tail = cc.Sprite:create("image/newstudy/back_tail.png")
    back_tail:setAnchorPoint(0.5, 0)
    back_tail:setPosition(bigWidth/2, 0)
    backColor:addChild(back_tail)

    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.bean = s_CURRENT_USER:getBeans()
    self.beanSprite = createBeanSprite(self.bean)
    self:addChild(self.beanSprite)

    local progressBar_total_number = getMaxWrongNumEveryLevel()

    self.wrongNumber = progressBar_total_number
    self.showNumber = createNumberSprite(self.wrongNumber)
    backColor:addChild(self.showNumber)

    
    local backBagSprite = cc.Sprite:create("image/newstudy/bagback.png")
    backBagSprite:setPosition(bigWidth * 0.63, 495)
    backColor:addChild(backBagSprite)
    
    local frontBagSprite = cc.Sprite:create("image/newstudy/bagfront.png")
    frontBagSprite:setPosition(bigWidth * 0.63 + 4, 505)
    frontBagSprite:ignoreAnchorPointForPosition(false)
    frontBagSprite:setAnchorPoint(0.5,1)
    backColor:addChild(frontBagSprite,2)
    
    local point = cc.p(backBagSprite:getPositionX(),backBagSprite:getPositionY())
    
    local jumpWord = wordAnimation(point,backBagSprite,frontBagSprite)
    for i = 1 ,#jumpWord do
        backColor:addChild(jumpWord[i])	
    end

    local beibeiAnimation = sp.SkeletonAnimation:create("spine/collectword.json", "spine/collectword.atlas",1)
    beibeiAnimation:addAnimation(0, 'animation', true)
    beibeiAnimation:setPosition(bigWidth * 0.18, 305)
    backColor:addChild(beibeiAnimation)

    self.getBean = s_CURRENT_USER.beanRewardForCollect
    s_CURRENT_USER.beanRewardForCollect = 3
    self.nextButton = createNextButton(self.getBean)
    backColor:addChild(self.nextButton)
   
    onAndroidKeyPressed(self, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup == 0 then
            s_level_popup_state = 1
            s_HUD_LAYER:removeChildByName('missionCompleteCircle')
            s_CURRENT_USER.beanRewardForIron = 3
            s_CorePlayManager.leaveStudyOverModel()
        end
    end, function ()

    end)
    
end

return MiddleLayer