local LevelProgressPopup = class ("LevelProgressPopup",function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")
local ProgressBar           = require("view.islandPopup.ProgressBar")

function LevelProgressPopup.create(index)
    local layer = LevelProgressPopup.new(index)
    local islandIndex = tonumber(index) + 1
    layer.unit = s_LocalDatabaseManager.getBossInfo(islandIndex)
    layer.wrongWordList = {}
    for i = 1 ,#layer.unit.wrongWordList do
        table.insert(layer.wrongWordList,layer.unit.wrongWordList[i])
    end
    print_lua_table(layer.unit)
    layer.wordNumber = #layer.wrongWordList
    layer.current_index = layer.unit.unitState
    layer.coolingDay = layer.unit.coolingDay
    layer:createPape(islandIndex)
    return layer
end

local function addCloseButton(backPopup)
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
    button_close:setPosition(backPopup:getContentSize().width - 60 , backPopup:getContentSize().height - 60 )
    button_close:addTouchEventListener(button_close_clicked)
    return button_close
end 

local function addBackButton(backPopup,islandIndex)
    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local WordLibrary = require("view.islandPopup.WordLibraryPopup")
            local wordLibrary = WordLibrary.create(islandIndex)
            s_SCENE.popupLayer:addChild(wordLibrary)  
            wordLibrary:setVisible(false)
            
            local action0 = cc.OrbitCamera:create(0.5,1, 0, 0, 90, 0, 0) 
            backPopup:runAction(action0) 
            
            local action1 = cc.DelayTime:create(0.5)
            local action2 = cc.CallFunc:create(function()
                wordLibrary:setVisible(true)
            end)
            local action3 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0) 
            local action4 = cc.Sequence:create(action1, action2, action3)
            wordLibrary:runAction(action4)  
        end
    end

    local button_back = ccui.Button:create("image/islandPopup/button_change_to_ciku.png","","")
    button_back:setScale9Enabled(true)
    button_back:setPosition(backPopup:getContentSize().width *0.1 , backPopup:getContentSize().height *0.95 )
    button_back:addTouchEventListener(button_back_clicked)
    return button_back
end

function LevelProgressPopup:ctor(index)
    self.islandIndex = tonumber(index) + 1
    self.total_index = 7

    self.animation = function ()

    end
    
    self.backPopup = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    self.backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self:addChild(self.backPopup)

    self.closeButton = addCloseButton(self.backPopup)
    self.backPopup:addChild(self.closeButton,2)

    self.backBtn = addBackButton(self.backPopup,self.islandIndex)
    self.backPopup:addChild(self.backBtn,2)

    local popup_title = cc.Label:createWithSystemFont('夏威夷-'..self.islandIndex,'Verdana-Bold',38)
    popup_title:setPosition(self.backPopup:getContentSize().width/2,self.backPopup:getContentSize().height-50)
    popup_title:setColor(cc.c3b(255,255,255))
    self.backPopup:addChild(popup_title,20)

    local last_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            self.changeToPage(false) 
        end
    end

    local last_button = ccui.Button:create("image/islandPopup/subtask_previous_button.png","","")
    last_button:setPosition(self.backPopup:getContentSize().width * 0.1,self.backPopup:getContentSize().height * 0.5 + 80)
    last_button:setScale9Enabled(true)
    last_button:ignoreAnchorPointForPosition(false)
    last_button:setAnchorPoint(0.5,0.5)
    last_button:addTouchEventListener(last_button_clicked)
    self.backPopup:addChild(last_button,1)

    local next_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            self.changeToPage(true) 
        end
    end

    local next_button = ccui.Button:create("image/islandPopup/subtask_next_button.png","","")
    next_button:setScale9Enabled(true)
    next_button:setPosition(self.backPopup:getContentSize().width * 0.9,self.backPopup:getContentSize().height * 0.5 + 80)
    next_button:ignoreAnchorPointForPosition(false)
    next_button:setAnchorPoint(0.5,0.5)
    next_button:addTouchEventListener(next_button_clicked)
    self.backPopup:addChild(next_button,1)
    
    local onTouchBegan = function(touch, event)
        return true  
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(self.backPopup:getBoundingBox(),location) then
            local move = cc.MoveBy:create(0.3, cc.p(0, s_DESIGN_HEIGHT))
            local remove = cc.CallFunc:create(function() 
                s_SCENE:removeAllPopups()
            end)
            self.backPopup:runAction(cc.Sequence:create(move,remove))
        end
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

function LevelProgressPopup:createPape(islandIndex)
    local pageViewSize = cc.size(545, 900)
    local backgroundSize = cc.size(545, 900)

    self.animationFlag = 0
    if self.current_index > 0 then
        self.animationFlag = self.current_index
        --动画位置在前一页
    end

    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(pageViewSize)

    local back_width = self.backPopup:getContentSize().width
    local back_height = self.backPopup:getContentSize().height

    pageView:setPosition(cc.p((back_width - backgroundSize.width) / 2 +
        (backgroundSize.width - pageView:getContentSize().width) / 2,
        (back_height - backgroundSize.height) / 2 +
        (backgroundSize.height - pageView:getContentSize().height) / 2 + 80 ))

    local progressBar = ProgressBar.create(6,self.current_index)
    progressBar:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.25)
    self.backPopup:addChild(progressBar)

    local layout = ccui.Layout:create()
    layout:setContentSize(pageViewSize)
    local StrikeLayer = self:createStrikeIron()
    layout:addChild(StrikeLayer)
    pageView:addPage(layout)

    local layout = ccui.Layout:create()
    layout:setContentSize(pageViewSize)
    local ReviewLayer = self:createReview()
    layout:addChild(ReviewLayer)
    pageView:addPage(layout)

    local layout = ccui.Layout:create()
    layout:setContentSize(pageViewSize)
    local SummaryLayer = self:createSummary()
    layout:addChild(SummaryLayer)
    pageView:addPage(layout)

    for i = 4,self.current_index do
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)
        local ReviewLayer = self:createReview("repeat")
        layout:addChild(ReviewLayer)
        pageView:addPage(layout)
    end

    if self.coolingDay == 0 and self.current_index >= 3 and self.current_index < self.total_index then
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)
        local ReviewLayer = self:createReview("normal")
        layout:addChild(ReviewLayer)
        pageView:addPage(layout)
    elseif self.coolingDay ~= 0 and self.current_index >= 3 and self.current_index < self.total_index then
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)
        local MysteriousLayer = self:createMysterious("time")
        layout:addChild(MysteriousLayer)
        pageView:addPage(layout)
    else
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)
        local MysteriousLayer = self:createMysterious()
        layout:addChild(MysteriousLayer)
        pageView:addPage(layout)
    end


    local MysteriousLayer_begin_index = 5
    if self.current_index < 2 then
        MysteriousLayer_begin_index = 5
    else
        MysteriousLayer_begin_index = self.current_index + 2
    end  

    for i = MysteriousLayer_begin_index,self.total_index do
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)
        local MysteriousLayer = self:createMysterious()
        layout:addChild(MysteriousLayer) 
        pageView:addPage(layout)
    end

    -- change to current index
    if self.current_index > 0 and self.current_index < 3 then
        pageView:scrollToPage(self.current_index - 1)
        --如果进入的不是第一页，跳转到上一页，播放动画
        local backColor = cc.LayerColor:create(cc.c4b(0,0,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        backColor:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
        self:addChild(backColor,10)

        local action0 = cc.DelayTime:create(1)
        local action1 = cc.CallFunc:create(function ()
            if backColor ~= nil then
                pageView:scrollToPage(self.current_index)
                backColor:removeFromParent()
                backColor = nil
            end
        end)
        local action2 = cc.Sequence:create(action0,action1)
        self:runAction(action2)

        local onTouchBegan = function(touch, event)
            return true  
        end

        local onTouchEnded = function(touch, event)
            if backColor ~= nil then
                pageView:scrollToPage(self.current_index)
                backColor:removeFromParent()
                backColor = nil
            end
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, backColor)
    else
        pageView:scrollToPage(self.current_index)
    end


    self.changeToPage = function (bool) 
        if bool == true then
            local target = pageView:getCurPageIndex()
            if target ~= 6 then
                pageView:scrollToPage(target + 1)
            end
        elseif bool == false then
            local target = pageView:getCurPageIndex()
            if target ~= 0 then
                pageView:scrollToPage(target - 1)
            end
        end
    end

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
           progressBar.moveLightCircle(pageView:getCurPageIndex())
        end
    end 
    pageView:addEventListener(pageViewEvent)
    self.backPopup:addChild(pageView)
end

local function createTitle(Text,parent)
    local title = cc.Label:createWithSystemFont(Text,"",36)
    title:setColor(cc.c4b(50,60,64,255))
    title:setPosition(cc.p(parent:getContentSize().width * 0.5,parent:getContentSize().height * 0.75))
    parent:addChild(title)
end

local function createSubtitle(Text,parent)
    local subtitle = cc.Label:createWithSystemFont(Text,"",18)
    subtitle:setColor(cc.c4b(108,108,108,255))
    subtitle:setPosition(cc.p(parent:getContentSize().width * 0.5,parent:getContentSize().height * 0.7))
    parent:addChild(subtitle)
end

local function createReviewLabel(parent)
    local review_label = cc.Label:createWithSystemFont("复习生词","",25)
    review_label:setColor(cc.c4b(98,98,98,255))
    review_label:setPosition(cc.p(parent:getContentSize().width * 0.2,parent:getContentSize().height * 0.3))
    parent:addChild(review_label)
end

local function createReviewSprite(current,total,parent)
    local review_sprite = cc.Sprite:create("image/islandPopup/subtask_number_bg.png")
    review_sprite:setPosition(cc.p(parent:getContentSize().width * 0.4,parent:getContentSize().height * 0.3))
    parent:addChild(review_sprite)

    local review_num = cc.Label:createWithSystemFont(current.." / "..total,"",24)
    review_num:setColor(cc.c4b(255,255,255,255))
    review_num:setPosition(cc.p(review_sprite:getContentSize().width * 0.5,review_sprite:getContentSize().height * 0.5))
    review_sprite:addChild(review_num)
end

local function createRewardLabel(parent)
    local reward_label = cc.Label:createWithSystemFont("奖励","",25)
    reward_label:setColor(cc.c4b(98,98,98,255))
    reward_label:setPosition(cc.p(parent:getContentSize().width * 0.6,parent:getContentSize().height * 0.3))
    parent:addChild(reward_label)
end

local function createRewardSprite(num,parent,isShowAnimation)
    local reward_sprite = cc.Sprite:create("image/islandPopup/subtask_beibeibean.png")
    reward_sprite:setPosition(cc.p(parent:getContentSize().width * 0.8,parent:getContentSize().height * 0.3))
    parent:addChild(reward_sprite)

    local reward_num = cc.Label:createWithSystemFont(num,"",24)
    reward_num:setColor(cc.c4b(255,255,255,255))
    reward_num:setPosition(cc.p(reward_sprite:getContentSize().width * 0.75,reward_sprite:getContentSize().height * 0.5))
    reward_sprite:addChild(reward_num)

    if isShowAnimation == true then
        local rightSign_sprite = cc.Sprite:create("image/islandPopup/duigo_green_xiaoguan_tanchu.png")
        rightSign_sprite:setPosition(cc.p(reward_sprite:getContentSize().width * 0.3 - 150,reward_sprite:getContentSize().height * 0.5 + 180)) 
        rightSign_sprite:setScale(0)
        reward_sprite:addChild(rightSign_sprite)
                        
        local action1 = cc.ScaleTo:create(0.3,2)
        local action2 = cc.DelayTime:create(0.3)
        local action3 = cc.MoveBy:create(0.3,cc.p(150,-180)) 
        local action4 = cc.Sequence:create(action1,action2,action3)
        rightSign_sprite:runAction(action4)

    end
end

function LevelProgressPopup:createNormalPlay(playModel,wordList,parent,isShowAnimation)
    local button_func = function()
        playSound(s_sound_buttonEffect) 

        local bossList = s_LocalDatabaseManager.getAllUnitInfo()
        local taskIndex = -2

        for bossID, bossInfo in pairs(bossList) do
            if bossInfo["coolingDay"] == 0 and bossInfo["unitState"] - 3 >= 0 and taskIndex == -2 and bossInfo["unitState"] - 7 < 0 then
                taskIndex = bossID
            end
        end    

        if taskIndex == -2 then         
            s_CorePlayManager.initTotalUnitPlay() -- 之前没有boss
            s_SCENE:removeAllPopups()  
        elseif taskIndex == self.islandIndex then
            s_CorePlayManager.initTotalUnitPlay() -- 按顺序打第一个boss
            s_SCENE:removeAllPopups()  
        else
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch() 
            local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
            tutorial_text:setPosition((s_chapter_layer_width-s_LEFT_X)/2, levelPosition.y)
            self:addChild(tutorial_text,520)
            local text = cc.Label:createWithSystemFont('请先打败前面的boss','',28)
            text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
            text:setColor(cc.c3b(0,0,0))
            tutorial_text:addChild(text)
            local action1 = cc.FadeOut:create(1.5)
            local action1_1 = cc.MoveBy:create(1.5, cc.p(0, 100))
            local action1_2 = cc.Spawn:create(action1,action1_1)
            tutorial_text:runAction(action1_2)
            local action2 = cc.FadeOut:create(1.5)
            local action3 = cc.CallFunc:create(function ()
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() 
            end)
            text:runAction(cc.Sequence:create(action2,action3))
        end  
    end

    local go_button = Button.create("long","blue","GO") 
    go_button:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.05)
    go_button.func = function ()
        button_func()
    end

    if isShowAnimation == "normal" then
        go_button:setScale(0)
        local action2 = cc.ScaleTo:create(0.3,1)
        local action3 = cc.Sequence:create(action2)
        go_button:runAction(action3)   
    end

    if isShowAnimation == true then
        --gobutton 缩小
        local action1 = cc.DelayTime:create(1)
        local action2 = cc.ScaleTo:create(0.3,0)
        local action3 = cc.CallFunc:create(function ()
            go_button:removeFromParent()
        end)
        local action4 = cc.Sequence:create(action1,action2,action3)
        go_button:runAction(action4)   

        self:createRepeatlPlay(playModel,wordList,parent,isShowAnimation)
    end

    parent:addChild(go_button)
end

function LevelProgressPopup:createRepeatlPlay(playModel,wordList,parent,isShowAnimation)--重复玩，参数 玩法／要玩的词／父亲节点/是否有动画
    local button_func = function()
        playSound(s_sound_buttonEffect)           
        if playModel == "summary" then
            local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(wordList,1,false)
            s_SCENE:replaceGameLayer(summaryBossLayer) 
        elseif playModel == "review" then
            local NewReviewBossMainLayer = require("view.newreviewboss.NewReviewBossMainLayer")
            local newReviewBossMainLayer = NewReviewBossMainLayer.create(wordList,Review_From_Word_Bank)
            s_SCENE:replaceGameLayer(newReviewBossMainLayer)
        elseif playModel == "iron" then
            local BlacksmithLayer = require("view.newstudy.BlacksmithLayer")
            local blacksmithLayer = BlacksmithLayer.create(wordList,self.islandIndex)
            s_SCENE:replaceGameLayer(blacksmithLayer)
        end 
        s_SCENE:removeAllPopups()    
    end

    local go_button = Button.create("long","blue","重玩") 
    go_button:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.05)
    go_button.func = function ()
        button_func()
    end

    if isShowAnimation == true then
        --重玩button 放大
        go_button:setScale(0)
        local action1 = cc.DelayTime:create(1)
        local action2 = cc.ScaleTo:create(0.3,1)
        local action3 = cc.CallFunc:create(function ()

        end)
        local action4 = cc.Sequence:create(action1,action2,action3)
        go_button:runAction(action4) 

    end

    parent:addChild(go_button)
end

function LevelProgressPopup:createCantPlay(text,parent,goToPlay)--现在不能玩，参数 文字／父亲节点/是否有动画/动画之后玩什么
    local cantPlay_Sprite = cc.Sprite:create("image/button/longbluefront.png")
    cantPlay_Sprite:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.05)
    cantPlay_Sprite:setColor(cc.c4b(199,199,193,255))
    parent:addChild(cantPlay_Sprite)

    
    local cantPlay_Label = cc.Label:createWithSystemFont(text,"",30)
    cantPlay_Label:setPosition(cc.p(cantPlay_Sprite:getContentSize().width / 2 ,cantPlay_Sprite:getContentSize().height / 2))
    cantPlay_Sprite:addChild(cantPlay_Label)
    
    if text == "" then
        local time = s_LocalDatabaseManager.getUnitCoolingSeconds(self.islandIndex)
        if time > 24 * 60 * 60 then
            cantPlay_Label:setString("剩余时间"..math.ceil(time/(24*60*60)).."天")
        else
            cantPlay_Label:setString("剩余时间"..math.ceil(time/(60*60)).."小时")
        end
        -- local function update(delta)
        --     cantPlay_Label:setString("剩余时间"..s_LocalDatabaseManager.getUnitCoolingSeconds(self.islandIndex))
        -- end
        -- parent:scheduleUpdateWithPriorityLua(update, 0)
    end

    if goToPlay == "normal" then
        local action0 = cc.DelayTime:create(2.5)
        local action1 = cc.ScaleTo:create(0.3,0)
        local action2 = cc.CallFunc:create(function ()
            self:createNormalPlay("","",parent,"normal")
        end)
        local action3 = cc.Sequence:create(action0,action1,action2)
        cantPlay_Sprite:runAction(action3)
    elseif goToPlay == "mysterious" then


    end

end

function LevelProgressPopup:createStrikeIron()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local hammer_sprite = cc.Sprite:create("image/islandPopup/subtask_hammer.png")
    hammer_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(hammer_sprite)
    
    createTitle("趁热打铁",back)
    createSubtitle("复习上课学过的单词",back)
    createReviewLabel(back)
    createRewardLabel(back)

    if self.animationFlag >= 1 then
        createRewardSprite(3,back,true)
    else
        createRewardSprite(3,back)
    end

    if self.current_index == 0 then
        self:createNormalPlay("iron",self.wrongWordList,back,false)
        createReviewSprite(0,self.wordNumber,back)
    elseif self.current_index > 0 then
        self:createNormalPlay("iron",self.wrongWordList,back,true)
        createReviewSprite(self.wordNumber,self.wordNumber,back)
    end
    
    return back
end

function LevelProgressPopup:createReview(playModel)
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local review_sprite = cc.Sprite:create("image/islandPopup/subtask_review_boss.png")
    review_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(review_sprite)

    createTitle("复习怪兽",back)
    createSubtitle("挑出和给出意思对应的章鱼",back)
    createReviewLabel(back)
    createRewardLabel(back)

    if self.animationFlag >= 2 and playModel == nil then -- 普通复习boss
        createRewardSprite(3,back,true)
    else
        createRewardSprite(3,back)
    end

    if playModel == "normal" then
        self:createNormalPlay("review",self.wrongWordList,back,false)
        createReviewSprite(0,self.wordNumber,back)
    elseif playModel == "repeat" then
        self:createRepeatlPlay("review",self.wrongWordList,back)
        createReviewSprite(self.wordNumber,self.wordNumber,back)
    elseif self.current_index == 1 then
        self:createCantPlay("请先完成前边的任务",back,"normal")
        createReviewSprite(0,self.wordNumber,back)
    elseif self.current_index > 1 then
        self:createNormalPlay("review",self.wrongWordList,back,true)
        createReviewSprite(self.wordNumber,self.wordNumber,back)
    elseif self.current_index < 1 then
        self:createCantPlay("请先完成前边的任务",back)
        createReviewSprite(0,self.wordNumber,back)
    else
        self:createCantPlay("time",back)
        createReviewSprite(0,self.wordNumber,back)
    end
    
    return back
end

function LevelProgressPopup:createSummary()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local summary_sprite = cc.Sprite:create("image/islandPopup/subtask_summary_boss.png")
    summary_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(summary_sprite)

    createTitle("总结怪兽",back)
    createSubtitle("划出给出中文对应的单词来击败boss",back)
    createReviewLabel(back)
    createRewardLabel(back)

    if self.animationFlag >= 3 then
        createRewardSprite(3,back,true)
    else
        createRewardSprite(3,back)
    end
    
    if self.current_index == 2 then
        self:createCantPlay("请先完成前边的任务",back,"normal")
        createReviewSprite(0,self.wordNumber,back)
    elseif self.current_index > 2 then
        self:createNormalPlay("summary",self.wrongWordList,back,true)
        createReviewSprite(self.wordNumber,self.wordNumber,back)
    elseif self.current_index < 2 then
        self:createCantPlay("请先完成前边的任务",back)
        createReviewSprite(0,self.wordNumber,back)
    end
    
    return back
end

function LevelProgressPopup:createMysterious(text)
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local mysterious_sprite = cc.Sprite:create("image/islandPopup/subtask_mysterious_task.png")
    mysterious_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(mysterious_sprite)

    createTitle("神秘任务",back)
    createSubtitle("一个即将到来的神秘玩法",back)
    createReviewLabel(back)
    createReviewSprite("?","?",back)
    createRewardLabel(back)
    createRewardSprite("?",back)

    if text ~= "time" then
        self:createCantPlay("请先完成前边的任务",back)
    else
        self:createCantPlay("",back)
    end
    
    return back
end

return LevelProgressPopup