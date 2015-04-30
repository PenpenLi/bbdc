-- 选小关弹出面板 

local LevelProgressPopup = class ("LevelProgressPopup",function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")
local ProgressBar           = require("view.islandPopup.ProgressBar")

function LevelProgressPopup.create(index,playAnimation)
    local layer = LevelProgressPopup.new(index)
    local islandIndex = tonumber(index)
    layer.unit = s_LocalDatabaseManager.getBossInfo(islandIndex)
    layer.wrongWordList = {}
    for i = 1 ,#layer.unit.wrongWordList do
        table.insert(layer.wrongWordList,layer.unit.wrongWordList[i])
    end
-- ["proficiency"] 熟练度
-- ["bossID"] boss编号    
-- ["rightWordList"]    记录熟词
-- ["wrongWordList"]    记录生词
-- ["coolingDay"]   冷却时间
-- ["typeIndex"]    当前小岛的任务进度
    print_lua_table(layer.unit)
    layer.wordNumber = #layer.wrongWordList
    layer.current_index = layer.unit.typeIndex
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
            wordLibrary.backPopup:runAction(action4)  
        end
    end

    local button_back = ccui.Button:create("image/islandPopup/button_change_to_ciku.png","","")
    button_back:setScale9Enabled(true)
    button_back:setPosition(backPopup:getContentSize().width *0.1 , backPopup:getContentSize().height *0.95 )
    button_back:addTouchEventListener(button_back_clicked)
    return button_back
end

function LevelProgressPopup:ctor(index)
    if s_CURRENT_USER.tutorialStep < s_tutorial_study then
        s_CURRENT_USER:setTutorialStep(s_tutorial_study) -- 2 -> 3
    end
    self.islandIndex = tonumber(index)
    self.total_index = 8

    self.animation = function ()

    end
    
    self.backPopup = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    self.backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
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
    local pageViewSize = cc.size(545, 1000)
    local backgroundSize = cc.size(545, 1000)

    self.animationFlag = 0
    if self.current_index > 0 and self.current_index < 8 then
        self.animationFlag = self.current_index
        --动画位置在前一页
    end

    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(pageViewSize)

    local back_width = self.backPopup:getContentSize().width
    local back_height = self.backPopup:getContentSize().height

    pageView:setPosition(cc.p((back_width - backgroundSize.width) / 2 +
        (backgroundSize.width - pageView:getContentSize().width) / 2 - 7,
        (back_height - backgroundSize.height) / 2 +
        (backgroundSize.height - pageView:getContentSize().height) / 2 + 80 ))

    local progress_index = self.current_index

    if self.current_index >= 7 then
        progress_index = 7
    end

    local progressBar = ProgressBar.create(7,progress_index)
    progressBar:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.25)
    self.backPopup:addChild(progressBar)

    for i=1,8 do
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)
        if i == 1 then
            local collectLayer = self:createCollect()
            layout:addChild(collectLayer)
        elseif i == 2 then
            local StrikeLayer = self:createStrikeIron()
            layout:addChild(StrikeLayer)
        elseif i == 3 then
            local ReviewLayer = self:createReview()
            layout:addChild(ReviewLayer)
        elseif i == 4 then
            local SummaryLayer = self:createSummary()
            layout:addChild(SummaryLayer)
        elseif self.current_index < 4 then
            if i >= 5 and i <= 8 then
                local MysteriousLayer = self:createMysterious()
                layout:addChild(MysteriousLayer)
            end
        elseif self.current_index >= 4 and self.current_index <= 8 then
            if i <= self.current_index then
                local ReviewLayer = self:createReview("repeat")
                layout:addChild(ReviewLayer)
            elseif self.coolingDay == 0 and i == self.current_index  + 1 then
                local ReviewLayer = self:createReview("normal")
                layout:addChild(ReviewLayer)
            elseif self.coolingDay ~= 0 and i == self.current_index  + 1 then
                local MysteriousLayer = self:createMysterious("time")
                layout:addChild(MysteriousLayer)
            else
                local MysteriousLayer = self:createMysterious()
                layout:addChild(MysteriousLayer) 
            end
        end
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
        pageView:scrollToPage(progress_index)
    end


    self.changeToPage = function (bool) 
        if bool == true then
            local target = pageView:getCurPageIndex()
            if target ~= 7 then
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

local function createRewardSprite(num,parent)
    local reward_sprite = cc.Sprite:create("image/islandPopup/subtask_beibeibean.png")
    reward_sprite:setPosition(cc.p(parent:getContentSize().width * 0.8,parent:getContentSize().height * 0.3))
    parent:addChild(reward_sprite)

    local reward_num = cc.Label:createWithSystemFont(num,"",24)
    reward_num:setColor(cc.c4b(255,255,255,255))
    reward_num:setPosition(cc.p(reward_sprite:getContentSize().width * 0.75,reward_sprite:getContentSize().height * 0.5))
    reward_sprite:addChild(reward_num)
end

function LevelProgressPopup:createNormalPlay(playModel,wordList,parent)
    local button_func = function()
        playSound(s_sound_buttonEffect) 

        local bossList = s_LocalDatabaseManager.getAllBossInfo()
        local taskIndex = -2

        for bossID, bossInfo in pairs(bossList) do
            if bossInfo["coolingDay"] == 0 and bossInfo["typeIndex"] - 4 >= 0 and taskIndex == -2 and bossInfo["typeIndex"] - 8 < 0 then
                taskIndex = bossID
            end
        end    

        if taskIndex == -2 then         
            s_CorePlayManager.initTotalPlay() -- 之前没有boss
            s_SCENE:removeAllPopups()  
            print("之前没有boss")
        elseif taskIndex == self.islandIndex then
            s_CorePlayManager.initTotalPlay() -- 按顺序打第一个boss
            s_SCENE:removeAllPopups() 
            print("按顺序打第一个boss") 
        else
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch() 
            local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
            tutorial_text:setPosition(parent:getContentSize().width * 0.5 + 45,300)
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
    go_button:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.1)
    go_button.func = function ()
        button_func()
    end

    local buttonPosition = cc.p(go_button:getPosition())

    if s_CURRENT_USER.newTutorialStep == s_newtutorial_island_alter_finger then
        s_CURRENT_USER.newTutorialStep = s_newtutorial_collect_goal
        saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})    
        local finger = sp.SkeletonAnimation:create('spine/tutorial/fingle.json', 'spine/tutorial/fingle.atlas',1)
        finger:addAnimation(0, 'animation', true)
        finger:setPosition(buttonPosition.x + 50, buttonPosition.y -100)
        go_button:addChild(finger,130)
    end

    parent:addChild(go_button)
end

function LevelProgressPopup:createRepeatlPlay(playModel,wordList,parent)--重复玩，参数 玩法／要玩的词／父亲节点/是否有动画
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
    go_button:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.1)
    go_button.func = function ()
        button_func()
    end
    parent:addChild(go_button)
end

function LevelProgressPopup:createCantPlay(text,parent)--现在不能玩，参数 文字／父亲节点/是否有动画/动画之后玩什么
    local cantPlay_Sprite = cc.Sprite:create("image/button/longbluefront.png")
    cantPlay_Sprite:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.1)
    cantPlay_Sprite:setColor(cc.c4b(199,199,193,255))
    parent:addChild(cantPlay_Sprite)
    
    local cantPlay_Label = cc.Label:createWithSystemFont(text,"",30)
    cantPlay_Label:setPosition(cc.p(cantPlay_Sprite:getContentSize().width / 2 ,cantPlay_Sprite:getContentSize().height / 2))
    cantPlay_Sprite:addChild(cantPlay_Label)
    
    -- if text == "" then
    --     local time = s_LocalDatabaseManager.getUnitCoolingSeconds(self.islandIndex)
    --     if time > 24 * 60 * 60 then
    --         cantPlay_Label:setString("剩余时间"..math.ceil(time/(24*60*60)).."天")
    --     else
    --         cantPlay_Label:setString("剩余时间"..math.ceil(time/(60*60)).."小时")
    --     end
    -- end

end

function LevelProgressPopup:createCollect()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 1000)

    local hammer_sprite = cc.Sprite:create("image/islandPopup/subtask_collect_word.png")
    hammer_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(hammer_sprite)
    
    createTitle("收集生词",back)
    createSubtitle("选择出你不会的词语",back)
    createReviewLabel(back)
    createRewardLabel(back)
    createRewardSprite(3,back)
    createReviewSprite(0,self.wordNumber,back)

    if self.current_index == 0 then
        self:createNormalPlay("iron",self.wrongWordList,back)
    end
    
    return back
end

function LevelProgressPopup:createStrikeIron()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 1000)

    local hammer_sprite = cc.Sprite:create("image/islandPopup/subtask_hammer.png")
    hammer_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(hammer_sprite)
    
    createTitle("趁热打铁",back)
    createSubtitle("复习上课学过的单词",back)
    createReviewLabel(back)
    createRewardLabel(back)
    createRewardSprite(3,back) 
    createReviewSprite(0,self.wordNumber,back)

    if self.current_index == 1 then
        self:createNormalPlay("iron",self.wrongWordList,back)
    elseif self.current_index > 1 then
        self:createRepeatlPlay("iron",self.wrongWordList,back)
    else
        self:createCantPlay("请先完成前边的任务",back)
    end
    
    return back
end

function LevelProgressPopup:createReview(playModel)
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 1000)

    local review_sprite = cc.Sprite:create("image/islandPopup/subtask_review_boss.png")
    review_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(review_sprite)

    createTitle("复习怪兽",back)
    createSubtitle("挑出和给出意思对应的章鱼",back)
    createReviewLabel(back)
    createRewardLabel(back)
    createRewardSprite(3,back)

    if playModel == "normal" then
        self:createNormalPlay("review",self.wrongWordList,back)
    elseif playModel == "repeat" then
        self:createRepeatlPlay("review",self.wrongWordList,back)
    elseif self.current_index < 2 then
        self:createCantPlay("请先完成前边的任务",back)
    elseif self.current_index == 2 then
        self:createNormalPlay("review",self.wrongWordList,back)
    elseif self.current_index > 2 then
        self:createCantPlay("请先完成前边的任务",back)
    end
    
    return back
end

function LevelProgressPopup:createSummary()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 1000)

    local summary_sprite = cc.Sprite:create("image/islandPopup/subtask_summary_boss.png")
    summary_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(summary_sprite)

    createTitle("总结怪兽",back)
    createSubtitle("划出给出中文对应的单词来击败boss",back)
    createReviewLabel(back)
    createRewardLabel(back)
    createRewardSprite(3,back)
    createReviewSprite(0,self.wordNumber,back)

    if self.current_index == 3 then
        self:createNormalPlay("summary",self.wrongWordList,back)
    elseif self.current_index > 2 then
        self:createRepeatlPlay("summary",self.wrongWordList,back)
    elseif self.current_index < 3 then
        self:createCantPlay("请先完成前边的任务",back)
    end
    
    return back
end

function LevelProgressPopup:createMysterious(text)
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 1000)

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