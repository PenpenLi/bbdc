--词库界面
local WordLibraryPopup = class ("WordLibraryPopup",function ()
    return cc.Layer:create()
end)

local Listview         = require("view.islandPopup.WordLibraryListview")
local Button                = require("view.button.longButtonInStudy")
local EnlargeTouchAreaReturnButton = require("view.islandPopup.EnlargeTouchAreaReturnButton")

function WordLibraryPopup.create(index)
    local layer = WordLibraryPopup.new(index)
    return layer
end
-- 关闭功能
local function addCloseButton(top_sprite,backPopup)
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
            local remove = cc.CallFunc:create(function() 
                  s_SCENE:removeAllPopups()
            end)
            backPopup:runAction(cc.Sequence:create(move,remove))
        end
    end

    local button_close = ccui.Button:create("image/friend/close.png","","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(top_sprite:getContentSize().width - 60 , top_sprite:getContentSize().height - 60 )
    button_close:addTouchEventListener(button_close_clicked)
    return button_close
end 
-- 切换到小岛弹出面板
local function addBackButton(top_sprite,backPopup,index)
    local click = 0 
    local button_back_clicked = function()
        if click == 0 then
            --更新引导tag
            if s_CURRENT_USER.newTutorialStep == s_newtutorial_wordpool then
                s_CURRENT_USER.newTutorialStep = s_newtutorial_sb_cn
                saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})  
            end
            click = 1
            playSound(s_sound_buttonEffect)
            local action0 = cc.CallFunc:create(function()
                backPopup:runAction(cc.OrbitCamera:create(0.4,1, 0, 0, 90, 0, 0))
            end)
            local action2 = cc.DelayTime:create(0.4)
            local action3 = cc.CallFunc:create(function()
                local LevelProgressPopup = require("view.islandPopup.LevelProgressPopup")
                local levelProgressPopup = LevelProgressPopup.create(index)
                s_SCENE:popup(levelProgressPopup) 
                levelProgressPopup.backPopup:runAction(cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0))   
            end)
            local action4 = cc.Sequence:create(action0,action2,action3)
            s_SCENE:runAction(action4)
        end
    end

    local button_back = EnlargeTouchAreaReturnButton.create("image/islandPopup/backtopocess.png","image/islandPopup/backtopocessback.png")
    button_back:setPosition(backPopup:getContentSize().width *0.1 , backPopup:getContentSize().height *0.95 )
    backPopup:addChild(button_back,5)

    button_back.func = function ()
       button_back_clicked()
    end

    local backColor = cc.LayerColor:create(cc.c4b(0,0,0,100), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    -- 引导内容
    backColor:setPosition(backPopup:getContentSize().width *0.5 - (s_RIGHT_X - s_LEFT_X)/2, backPopup:getContentSize().height * 0.5 - s_DESIGN_HEIGHT/2)
    if s_CURRENT_USER.newTutorialStep == s_newtutorial_wordpool then
        backPopup:addChild(backColor,3)
    end

    local beibei = cc.Sprite:create("image/newstudy/background_yindao.png")
    beibei:setPosition(backColor:getContentSize().width *0.5, backColor:getContentSize().height *0.7)
    backColor:addChild(beibei)

    local head = cc.Sprite:create("image/guide/beibei_xinshouyindao_newwords.png")
    head:setPosition(beibei:getContentSize().width *0.5, 200)
    beibei:addChild(head)

    local finger = cc.Sprite:create("image/guide/beibei_hand2_xinshouyindao_newwords.png")
    finger:setPosition(beibei:getContentSize().width *0.3, beibei:getContentSize().height + 10)
    beibei:addChild(finger)

    local beibei_tip_label = cc.Label:createWithSystemFont("点击这里返回任务面板","",32)
    beibei_tip_label:setPosition(beibei:getContentSize().width *0.5, beibei:getContentSize().height *0.5)
    beibei_tip_label:setColor(cc.c4b(36,63,79,255))
    beibei:addChild(beibei_tip_label)

    local onTouchBegan = function(touch, event)
        return true  
    end

    local onTouchEnded = function(touch, event)
        local location = backPopup:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(button_back:getBoundingBox(),location) then
           button_back_clicked()    
        end 
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = backColor:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backColor) 
end
-- 切换到生词
local function addUnfamiliarButton(top_sprite)
    local unfamiliar_button = cc.Sprite:create("image/islandPopup/unfamiliarwordend.png")
    unfamiliar_button:setPosition(top_sprite:getContentSize().width * 0.5 - unfamiliar_button:getContentSize().width * 0.6 + 8,top_sprite:getContentSize().height * 0.5)
    unfamiliar_button:ignoreAnchorPointForPosition(false)
    unfamiliar_button:setAnchorPoint(0.5,0.5)

    local unfamiliar_label = cc.Label:createWithSystemFont("生词","",35)
    unfamiliar_label:setPosition(unfamiliar_button:getContentSize().width / 2,unfamiliar_button:getContentSize().height / 2)
    unfamiliar_button:addChild(unfamiliar_label)
    
    return unfamiliar_button
end
-- 切换到熟词
local function addfamiliarButton(top_sprite)
    local familiar_button = cc.Sprite:create("image/islandPopup/familiarwordbegin.png")
    familiar_button:setPosition(top_sprite:getContentSize().width * 0.5 + familiar_button:getContentSize().width * 0.6 - 9,top_sprite:getContentSize().height * 0.5)
    familiar_button:ignoreAnchorPointForPosition(false)
    familiar_button:setAnchorPoint(0.5,0.5)

    local familiar_label = cc.Label:createWithSystemFont("熟词","",35)
    familiar_label:setPosition(familiar_button:getContentSize().width / 2,familiar_button:getContentSize().height / 2)
    familiar_button:addChild(familiar_label)

    return familiar_button
end
-- 词库进入复习怪兽
local function addReviewButton(bottom_sprite,boss)

    local button_func = function()
        playSound(s_sound_buttonEffect)
        local ReviewBoss = require("view.newreviewboss.NewReviewBossMainLayer")
        if boss.wrongWordList == nil then
            return 
        else
            local reviewBoss = ReviewBoss.create(boss.wrongWordList,Review_From_Word_Bank)
            s_SCENE:replaceGameLayer(reviewBoss)
            s_SCENE:removeAllPopups()
        end
    end

    local review_button = Button.create("small","blue","复习怪兽")
    review_button:setPosition(bottom_sprite:getContentSize().width * 0.7,bottom_sprite:getContentSize().height * 0.5)
    review_button.func = function ()
        button_func()
    end
    
    return review_button
end
-- 词库进入总结怪兽
local function addSummaryButton(bottom_sprite,boss)
    local wordList = function (initWordList)
        local temp = {}
        local endList = {}
        for i = 1 , # initWordList do
            table.insert(temp,initWordList[i])
        end
        local length
        if #initWordList > 6 then
            length = 6
        else
            length = #initWordList
        end   
        for i = 1 , length do
            local randSeed = math.randomseed(os.time())
            local randNum  = math.random(1,#initWordList)
            local tempNum  = temp[randNum]
            temp[randNum] = temp[i]
            temp[i] = tempNum  
        end
        for i = 1 , length do
            table.insert(endList,temp[i])
        end
        return  endList
    end
    local button_func = function()
        playSound(s_sound_buttonEffect)
        local endList = wordList(boss.wrongWordList)
        local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
        local summaryBossLayer = SummaryBossLayer.create(endList,1,false)
        s_SCENE:replaceGameLayer(summaryBossLayer) 
        s_SCENE:removeAllPopups()
    end
    local summary_button = Button.create("small","blue","总结怪兽")
    summary_button:setPosition(bottom_sprite:getContentSize().width * 0.3,bottom_sprite:getContentSize().height * 0.5)
    summary_button.func = function ()
        button_func()
    end
    
    return summary_button
end
-- 词库引导

local function addGuideLayer(parent,func)
    local backColor = cc.LayerColor:create(cc.c4b(0,0,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    backColor:setPosition(parent:getContentSize().width *0.5 - (s_RIGHT_X - s_LEFT_X)/2, parent:getContentSize().height * 0.5 - s_DESIGN_HEIGHT/2)
    parent:addChild(backColor,3)

    local transparent_sprite = cc.Sprite:create("image/islandPopup/transparent.png")
    transparent_sprite:setPosition(backColor:getContentSize().width *0.45, backColor:getContentSize().height *0.6)
    backColor:addChild(transparent_sprite)

    for i = -10,parent:getContentSize().width / 25 + 10 do
        for j = -10,parent:getContentSize().height / 25 + 10 do
            if not cc.rectContainsPoint(transparent_sprite:getBoundingBox(),cc.p(i*25 - parent:getContentSize().width *0.5 + (s_RIGHT_X - s_LEFT_X)/2,j*25 - parent:getContentSize().height * 0.5 + s_DESIGN_HEIGHT/2)) then
               local pointColor = cc.LayerColor:create(cc.c4b(0,0,0,50), 25, 25)
               pointColor:ignoreAnchorPointForPosition(false)
               pointColor:setAnchorPoint(1,1) 
               pointColor:setPosition(i*25 - parent:getContentSize().width *0.5 + (s_RIGHT_X - s_LEFT_X)/2,j*25 - parent:getContentSize().height * 0.5 + s_DESIGN_HEIGHT/2)
               backColor:addChild(pointColor,4)
           end
        end
    end

    local beibei = cc.Sprite:create("image/newstudy/background_yindao.png")
    beibei:setPosition(backColor:getContentSize().width *0.5, backColor:getContentSize().height *0.3)
    backColor:addChild(beibei,5)

    local body = cc.Sprite:create("image/newstudy/bb_big_yindao.png")
    body:setPosition(50, 0)
    beibei:addChild(body)

    local beibei_arm = cc.Sprite:create("image/newstudy/bb_arm_yindao.png")
    beibei_arm:setPosition(body:getContentSize().width/2 - 70,body:getContentSize().height/2 - 2)
    beibei_arm:ignoreAnchorPointForPosition(false)
    beibei_arm:setAnchorPoint(0,0)
    body:addChild(beibei_arm,-1)

    local beibei_tip_label = cc.Label:createWithSystemFont("看，刚收集的生词","",32)
    beibei_tip_label:setPosition(beibei:getContentSize().width *0.6, beibei:getContentSize().height *0.5)
    beibei_tip_label:setColor(cc.c4b(36,63,79,255))
    beibei:addChild(beibei_tip_label)

    local action0 = cc.DelayTime:create(6)
    local action1 = cc.CallFunc:create(function ()
        if backColor ~= nil then 
            backColor:removeFromParent()
            backColor = nil
            if func ~= nil then func() end
        end
    end)
    local action2 = cc.Sequence:create(action0,action1)
    backColor:runAction(action2)

    local onTouchBegan = function(touch, event)
        return true  
    end

    local onTouchEnded = function(touch, event)
        if backColor ~= nil then
            backColor:removeFromParent()
            backColor = nil
            if func ~= nil then func() end
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = backColor:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backColor) 
end

function WordLibraryPopup:ctor(index)
    self.index = index
    local boss = s_LocalDatabaseManager.getBossInfo(index)
    
    self.backPopup = cc.Sprite:create("image/islandPopup/backforlibrary.png")
    self.backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(self.backPopup)

    local top_sprite = cc.Sprite:create("image/islandPopup/top.png")
    top_sprite:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.95)
    top_sprite:ignoreAnchorPointForPosition(false)
    top_sprite:setAnchorPoint(0.5,0.5)
    self.backPopup:addChild(top_sprite)
    
    self.closeButton = addCloseButton(top_sprite,self.backPopup)
    top_sprite:addChild(self.closeButton)
    
    self.unfamiliarButton = addUnfamiliarButton(top_sprite)
    top_sprite:addChild(self.unfamiliarButton)

    local borderSprite = cc.Sprite:create("image/islandPopup/border.png")
    borderSprite:setPosition(top_sprite:getContentSize().width * 0.5,top_sprite:getContentSize().height * 0.5)
    borderSprite:ignoreAnchorPointForPosition(false)
    borderSprite:setAnchorPoint(0.5,0.5)
    top_sprite:addChild(borderSprite)
    
    self.familiarButton = addfamiliarButton(top_sprite)
    top_sprite:addChild(self.familiarButton)
    
   local line_sprite = cc.Sprite:create("image/islandPopup/line.png")
   line_sprite:setPosition(top_sprite:getContentSize().width * 0.5 -1,0)
   line_sprite:ignoreAnchorPointForPosition(false)
   line_sprite:setAnchorPoint(0.5,0.5)
   top_sprite:addChild(line_sprite,-1)
    
    local bottom_sprite = cc.Sprite:create("image/islandPopup/bottom.png")
    bottom_sprite:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.03)
    bottom_sprite:ignoreAnchorPointForPosition(false)
    bottom_sprite:setAnchorPoint(0.5,0.5)
    self.backPopup:addChild(bottom_sprite,2)
    
    self.reviewButton = addReviewButton(bottom_sprite,boss)
    bottom_sprite:addChild(self.reviewButton)
    
    self.summaryButton = addSummaryButton(bottom_sprite,boss)
    bottom_sprite:addChild(self.summaryButton)

    self.reviewButton:setVisible(false)
    self.summaryButton:setVisible(false)

    self.close = function ()
    	
    end
    
    local onTouchBegan = function(touch, event)
        return true  
    end

    local function getMaxNumEveryLevel(int)
        if int <= 1 then
            return s_max_wrong_num[1]
        elseif int % 3 == 2 then 
            return s_max_wrong_num[2]
        elseif int % 3 == 0 then 
            return s_max_wrong_num[3]
        else
            return s_max_wrong_num[4]
        end
    end
    

    if s_CURRENT_USER.familiarOrUnfamiliar == 0 then -- 0 for choose familiar ,1 for choose unfamiliar
        self.listview = Listview.create(boss.rightWordList)
        self.reviewButton:setVisible(false)
        self.summaryButton:setVisible(false)
        self.familiarButton:setTexture("image/islandPopup/familiarwordend.png")
        self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordbegin.png")
    else
        self.listview = Listview.create(boss.wrongWordList)  
        self.familiarButton:setTexture("image/islandPopup/familiarwordbegin.png")
        self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordend.png") 
        local number = getMaxNumEveryLevel(tonumber(index))
        if #boss.wrongWordList >= number then
            self.reviewButton:setVisible(true)
            self.summaryButton:setVisible(true)
        else
            self.reviewButton:setVisible(false)
            self.summaryButton:setVisible(false)
        end
    end
    
    self.listview:setPosition(2,70)
    self.backPopup:addChild(self.listview)
    
    local onTouchEnded = function(touch, event)
        local location = top_sprite:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(self.familiarButton:getBoundingBox(), location)  then
            s_CURRENT_USER.familiarOrUnfamiliar = 0
            self.familiarButton:setTexture("image/islandPopup/familiarwordend.png")
            self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordbegin.png")
            self.listview:removeFromParent()
            self.listview = Listview.create(boss.rightWordList) 
            self.listview:setPosition(2,70)
            self.backPopup:addChild(self.listview)
            self.reviewButton:setVisible(false)
            self.summaryButton:setVisible(false)
        elseif cc.rectContainsPoint(self.unfamiliarButton:getBoundingBox(), location) then
            s_CURRENT_USER.familiarOrUnfamiliar = 1
            self.familiarButton:setTexture("image/islandPopup/familiarwordbegin.png")
            self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordend.png")
            self.listview:removeFromParent()
            self.listview = Listview.create(boss.wrongWordList) 
            self.listview:setPosition(2,70)
            self.backPopup:addChild(self.listview)
            local number = getMaxNumEveryLevel(tonumber(index))
            if #boss.wrongWordList >= number then
                self.reviewButton:setVisible(true)
                self.summaryButton:setVisible(true)
            else
                self.reviewButton:setVisible(false)
                self.summaryButton:setVisible(false)
            end
        end
        local location1 = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(self.backPopup:getBoundingBox(),location1) then
            local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
            local remove = cc.CallFunc:create(function() 
                s_SCENE:removeAllPopups()
            end)
            self.backPopup:runAction(cc.Sequence:create(move,remove))
        end
    end

    if s_CURRENT_USER.newTutorialStep == s_newtutorial_wordpool then
        addGuideLayer(self.backPopup,function ()
            addBackButton(top_sprite,self.backPopup,index)
        end)
    else
        addBackButton(top_sprite,self.backPopup,index)
    end
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)   

    onAndroidKeyPressed(self, function ()
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
        local remove = cc.CallFunc:create(function() 
            s_SCENE:removeAllPopups()
        end)
        self.backPopup:runAction(cc.Sequence:create(move,remove))
    end, function ()

    end)

end

return WordLibraryPopup