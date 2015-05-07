require("cocos.init")
require('common.global')
s_0_base_height = 3014
s_islands_per_page = 10
local ChapterLayer = class('ChapterLayer', function() 
    return cc.Layer:create()
end)


local s_chapter_layer_width = 854
local oceanBlue = cc.c4b(61,191,244,255)
local bounceSectionSize = cc.size(854,512)
local scrollBottomLock = false
local scrollTopLock = false

function ChapterLayer.create()
    local layer = ChapterLayer.new()
    return layer
end

function ChapterLayer:ctor()
    AnalyticsTutorialLevelSelect()
    
    if s_CURRENT_USER.tutorialStep == s_tutorial_level_select then
        s_CURRENT_USER:setTutorialStep(s_tutorial_level_select+1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_level_select+1)
    end

    -- back tutorial 

    -- if true then
    if s_CURRENT_USER.newTutorialStep == s_newtutorial_island_back then
        s_CURRENT_USER.newTutorialStep = s_newtutorial_loginreward
        saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})  

        -- plot ui
        local back = cc.Layer:create()
        back:setContentSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT)

        local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
        tutorial_text:setPosition(back:getContentSize().width/2,back:getContentSize().height/2 + 300)
        back:addChild(tutorial_text,520)
        local text = cc.Label:createWithSystemFont('完成了今日任务\n回主页打卡吧','',28)
        text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
        text:setColor(cc.c3b(0,0,0))
        tutorial_text:addChild(text)
        s_SCENE:popup(back)
        s_SCENE:callFuncWithDelay(1, function()
            s_SCENE:removeAllPopups()
        end)
    end

    playMusic(s_sound_bgm1,true)

    -- show repeat chapter list
    self.activeChapterStartIndex = 0
    self.activeChapterEndIndex = 0
    self.biggestChapterIndex = 0
    self:initActiveChapterRange()

    self.chapterDic = {}
    -- add list view
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        end
    end


    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            -- test
            -- self:addChapterIntoListView("chapter0")
            if not scrollBottomLock then
                scrollBottomLock = true
                self:callFuncWithDelay(2.0, function()
                    scrollBottomLock = false
                end)
                print("SCROLL_TO_BOTTOM")
                if self.activeChapterEndIndex < self.biggestChapterIndex then
                    self.activeChapterEndIndex = self.activeChapterEndIndex + 1
                    self:addChapterIntoListView("chapter"..self.activeChapterEndIndex)
                    self:callFuncWithDelay(0.1, function()
                        self:scrollLevelLayer(self.activeChapterEndIndex * s_islands_per_page,0)
                    end)
                end
            end
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            if not scrollTopLock then
                scrollTopLock = true
                self:callFuncWithDelay(2.0, function()
                    scrollTopLock = false
                end)
                print("SCROLL_TO_TOP")
                if self.activeChapterStartIndex > 0 then
                    self.activeChapterStartIndex = self.activeChapterStartIndex - 1;
                    -- self.activeChapterStartIndex = 1   -- test
                    local chapterKey = 'chapter'..self.activeChapterStartIndex
                    local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
                    self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
                    self.chapterDic[chapterKey]:setAnchorPoint(0, 0)
                    self.chapterDic[chapterKey]:setPosition(0, 0)
                    --print('contentSize:'..self.chapterDic[chapterKey]:getContentSize().height)
                    local custom_item = ccui.Layout:create()
                    custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
                    custom_item:setName(chapterKey)  
                    custom_item:addChild(self.chapterDic[chapterKey])
                    custom_item:setAnchorPoint(0,0)
                    -- custom_item:setPosition(cc.p(0,0))
                    local fullWidth = s_chapter_layer_width
                    -- self.listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
                    custom_item:setPosition(cc.p((s_DESIGN_WIDTH - s_chapter_layer_width) / 2, 0))

            --        self.listView:addChild(self.chapterDic[chapterKey]) 
                    -- self.listView:pushBackCustomItem(self.chapterDic[chapterKey])
                    self.listView:insertCustomItem(custom_item, 0)
                    self:callFuncWithDelay(0.1, function()
                        self:scrollLevelLayer((self.activeChapterStartIndex * 10 + 9) * s_islands_per_page,0)
                    end)
                end
            end


            
        elseif evenType == ccui.ScrollviewEventType.scrolling then
            --print('SCROLLING:'..sender:getPosition())
        end

    end 
    self.listView = ccui.ListView:create()
    self.listView:setDirection(ccui.ScrollViewDir.vertical)
    self.listView:setBounceEnabled(true)
    self.listView:setBackGroundImageScale9Enabled(true)
    self.listView:addEventListener(listViewEvent)
    self.listView:addScrollViewEventListener(scrollViewEvent)
    self.listView:removeAllChildren()
    self:addChild(self.listView)
    
    local fullWidth = s_chapter_layer_width
    self.listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    self.listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    -- add bounce
    self:addTopBounce()
    -- add chapter node
    -- self:addChapterIntoListView('chapter0')
    -- local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey) + 0
    -- local currentChapterIndex = math.floor(levelInfo / s_islands_per_page)   
    -- for i = 1, currentChapterIndex do
    --     self:addChapterIntoListView('chapter'..i)
    -- end

    -- add active chapter range
    for i = self.activeChapterStartIndex, self.activeChapterEndIndex do
        self:addChapterIntoListView('chapter'..i)
    end
    -- add player
--    self:addPlayer()
    -- self:plotDecoration()
    -- scroll to current chapter level
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
--    self:scrollLevelLayer(progress,0)
    self:addBottomBounce()
    self:addNotification()
    -- check unlock level
    self:checkUnlockLevel()
    self:addBackToHome()
    self:addBeansUI()

    if s_CURRENT_USER.newTutorialStep == s_newtutorial_island_finger then
        s_CURRENT_USER.newTutorialStep = s_newtutorial_island_alter_finger
        saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})
        local level0Position = self.chapterDic['chapter0']:getLevelPosition('level0')
        -- print finger animation
        local finger = sp.SkeletonAnimation:create('spine/tutorial/fingle.json', 'spine/tutorial/fingle.atlas',1)
        finger:addAnimation(0, 'animation', true)
    --    local boatPosition = cc.p(level0Position.x-100, level0Position.y+150)
        finger:setPosition(level0Position.x, level0Position.y-70)
        self.chapterDic['chapter0']:addChild(finger,130)
    end  
   

    if s_CURRENT_USER.newTutorialStep == s_newtutorial_island_finger then
        s_CURRENT_USER.newTutorialStep = s_newtutorial_island_alter_finger
        saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})
        local level0Position = self.chapterDic['chapter0']:getLevelPosition('level0')
        -- print finger animation
        local finger = sp.SkeletonAnimation:create('spine/tutorial/fingle.json', 'spine/tutorial/fingle.atlas',1)
        finger:addAnimation(0, 'animation', true)
    --    local boatPosition = cc.p(level0Position.x-100, level0Position.y+150)
        finger:setPosition(level0Position.x, level0Position.y-70)
        self.chapterDic['chapter0']:addChild(finger,130)
    end  
end

function ChapterLayer:initActiveChapterRange()   -- initialize the active range of repeatable chapter ui
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)

    local activeLevelIndex
    -- check whether exists task
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local taskIndex = -2
    local taskState = -2
    local progressIndex = progress
    local progressState = 0
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] - 0 == 0 and bossInfo["typeIndex"] - 4 >= 0 and taskIndex == -2 and bossInfo["typeIndex"] - 8 < 0 then
            taskIndex = bossID - 1
            taskState = bossInfo["typeIndex"] 
        end
        if (progressIndex + 1) == bossID then
            progressState = bossInfo["typeIndex"]
        end
    end    
    if taskIndex == -2 then
        activeLevelIndex = progress
    else
        activeLevelIndex = taskIndex
    end

    -- check active chapterindex range
    -- test 
    -- progress = 40
    -- activeLevelIndex = 30


    self.activeChapterIndex = math.floor(activeLevelIndex / s_islands_per_page)

    
     --print('###activeChapterRange:'..self.activeChapterStartIndex..','..self.activeChapterEndIndex..','..self.activeChapterIndex)
    self.biggestChapterIndex = math.floor(progress / s_islands_per_page)
    if self.biggestChapterIndex < 3 then
        self.activeChapterStartIndex = 0
        self.activeChapterEndIndex = self.biggestChapterIndex
    else 
        if self.activeChapterIndex == 0 then
            self.activeChapterStartIndex = 0
            self.activeChapterEndIndex = 2
        elseif self.activeChapterIndex == self.biggestChapterIndex then
            self.activeChapterStartIndex = self.activeChapterIndex - 2
            self.activeChapterEndIndex = self.biggestChapterIndex
        else 
            self.activeChapterStartIndex = self.activeChapterIndex - 1
            self.activeChapterEndIndex = self.activeChapterIndex + 1
        end
    end
    --print('###activeChapterRange:'..self.activeChapterStartIndex..','..self.activeChapterEndIndex..','..self.activeChapterIndex)
end

function ChapterLayer:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

function ChapterLayer:checkUnlockLevel()
    -- get state --
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    -- 小岛进度

    -- check state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    print('---BOSS list')
    print_lua_table(bossList)
    local taskIndex = -2
    local taskState = -2
    local progressIndex = progress
    local progressState = 0
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] - 0 == 0 and bossInfo["typeIndex"] - 4 >= 0 and taskIndex == -2 and bossInfo["typeIndex"] - 8 < 0 then
            taskIndex = bossID - 1
            taskState = bossInfo["typeIndex"]
            -- 寻找以前打过的复习 boss
        end
        if (progressIndex + 1) == bossID then
            progressState = bossInfo["typeIndex"]
            -- 当前小岛的进度
        end
    end
    -- get state --

    local oldProgress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)+0
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() +0
--    currentProgress = 10
    s_CURRENT_USER.levelInfo:updateDataToServer()  -- update book progress
 if currentProgress % s_islands_per_page == 0 and currentProgress > 0 and currentProgress - oldProgress > 0 then       
--   if true then
    -- unlock chapter
        self:plotUnlockCloudAnimation()
        local currentChapterKey = 'chapter'..math.floor(currentProgress / s_islands_per_page)
--        
--        local delay = 0.5
--        local func = function()
--            self:addChapterIntoListView(currentChapterKey)
--        end
--
--        local delayAction = cc.DelayTime:create(delay)
--        local callAction = cc.CallFunc:create(func)
--        local sequence = cc.Sequence:create(delayAction, callAction)
--        self:runAction(sequence)
        self:callFuncWithDelay(0.1, function() 
            self:addChapterIntoListView(currentChapterKey)
            self.activeChapterEndIndex = self.activeChapterEndIndex + 1
            self.biggestChapterIndex = self.biggestChapterIndex + 1
            -- if self.activeChapterEndIndex < self.biggestChapterIndex then
            --     self.activeChapterEndIndex = self.activeChapterEndIndex + 1               
            -- end
        end)
        self:callFuncWithDelay(1.0, function() 
            self.chapterDic[currentChapterKey]:plotUnlockLevelAnimation('level'..currentProgress)
        end)
        self:callFuncWithDelay(0.5, function() 
            --self:addPlayerOnLevel(currentChapterKey,'level'..currentProgress)     
            self:scrollLevelLayer(currentProgress,0.3)

        end)
--        if taskIndex == -2 then
--            self:callFuncWithDelay(1.5, function() 
--            self.chapterDic[currentChapterKey]:addPopup(currentProgress)
--            end)
--        end
        self:callFuncWithDelay(2.0, function() 
            self:addBottomBounce()
        end)


    elseif currentProgress - oldProgress > 0 then   -- unlock level
        local chapterKey = 'chapter'..math.floor(oldProgress / s_islands_per_page)
        local delayTime = 0
--        self:callFuncWithDelay(delayTime, 
--            function()
--                -- add notification
--                self:addPlayerNotification(false) 
--            end
--        )  
        self.chapterDic[chapterKey]:plotUnlockLevelAnimation('level'..currentProgress)

        self:callFuncWithDelay(1, function()
            self:scrollLevelLayer(currentProgress, 1)
        end)
--        if taskIndex == -2 then
--            self:callFuncWithDelay(1.3, function() 
--                self.chapterDic[chapterKey]:addPopup(currentProgress)
--            end)
--        end
    else
        local chapterKey = 'chapter'..math.floor(oldProgress / s_islands_per_page)
        if taskIndex == -2 and s_level_popup_state == 1 then
            s_level_popup_state = 2
                s_SCENE.touchEventBlockLayer.lockTouch()
                self:callFuncWithDelay(1.1, function()
                    s_SCENE.touchEventBlockLayer.unlockTouch()
                end)
            self:callFuncWithDelay(1.0, function()
                local isAnimation = true
                self.chapterDic[chapterKey]:addPopup(currentProgress,isAnimation)
            end)
        end
        -- add notification
--        self:addPlayerNotification(true) 
    end
end

function ChapterLayer:addNotification()
    local notification = cc.Sprite:create('image/chapter/chapter0/notifi.png') 
    notification:setAnchorPoint(cc.p(0.5,0))
    local progress = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    -- check state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local taskIndex = -2
    local taskState = -2
    local progressIndex = progress
    local progressState = 0
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] - 0 == 0 and bossInfo["typeIndex"] - 4 >= 0 and taskIndex == -2 and bossInfo["typeIndex"] - 8 < 0 then
            taskIndex = bossID - 1
            taskState = bossInfo["typeIndex"] 
        end
        if (progressIndex + 1) == bossID then
            progressState = bossInfo["typeIndex"]
        end
    end
    
    if taskIndex == -2 then
--        self:scrollLevelLayer(progress,0)
        --test
        self:scrollLevelLayer(progress,0)
        
        return
    else
        self:scrollLevelLayer(taskIndex,0)
        return
    end
    
    local text = cc.Label:createWithSystemFont('当前任务','',23)
    text:setPosition(notification:getContentSize().width/2,notification:getContentSize().height/2+10)
    text:setColor(cc.c3b(95,112,116))
    notification:addChild(text,10)
    
    local taskChapterKey = 'chapter'..math.floor(taskIndex/s_islands_per_page)
    local taskKey = 'level'..taskIndex
--    print('task:'..taskKey..taskChapterKey)
    local taskPosition = self.chapterDic[taskChapterKey]:getLevelPosition(taskKey)
    notification:setPosition(cc.p(taskPosition.x, taskPosition.y + 150))
    local action1 = cc.MoveTo:create(1, cc.p(taskPosition.x, taskPosition.y + 170))
    local action2 = cc.MoveTo:create(1, cc.p(taskPosition.x, taskPosition.y + 150))
    local action3 = cc.Sequence:create(action1, action2)
    local action4 = cc.RepeatForever:create(action3)
    notification:runAction(action4)
    self.chapterDic[taskChapterKey]:addChild(notification, 150)
end

function ChapterLayer:addPlayerNotification(isRunScale)  -- notification
    self.player:removeAllChildren()
    -- TODO get state
--    local state

--    if state == 0 then
--        local title = cc.Label:createWithSystemFont('当前任务','',28)
--        title:setColor(cc.c3b(56,26,23))
--        title:ignoreAnchorPointForPosition(false)
--        title:setAnchorPoint(0,0)
--        title:setPosition(55,115)
--        notification:addChild(title)
--        local task_name = cc.Label:createWithSystemFont('积累生词: ','',22)
--        task_name:setColor(cc.c3b(98,195,223))
--        task_name:ignoreAnchorPointForPosition(false)
--        task_name:setAnchorPoint(0,0)
--        task_name:setPosition(30,85)
--        notification:addChild(task_name)
--        local number = cc.Label:createWithSystemFont('0 / '..s_max_wrong_num_everyday,'',25)
--        number:setColor(cc.c3b(165,55,80))
--        number:ignoreAnchorPointForPosition(false)
--        number:setAnchorPoint(0,0)
--        number:setPosition(130,85)
--        notification:addChild(number)
--    elseif state == 1 then
--        local title = cc.Label:createWithSystemFont('当前任务','',28)
--        title:setColor(cc.c3b(56,26,23))
--        title:ignoreAnchorPointForPosition(false)
--        title:setAnchorPoint(0,0)
--        title:setPosition(55,115)
--        notification:addChild(title)
--        local task_name = cc.Label:createWithSystemFont('趁热打铁: ','',22)
--        task_name:setColor(cc.c3b(98,195,223))
--        task_name:ignoreAnchorPointForPosition(false)
--        task_name:setAnchorPoint(0,0)
--        task_name:setPosition(30,85)
--        notification:addChild(task_name)
--        local number = cc.Label:createWithSystemFont('0 / '..s_max_wrong_num_everyday,'',25)
--        number:setColor(cc.c3b(165,55,80))
--        number:ignoreAnchorPointForPosition(false)
--        number:setAnchorPoint(0,0)
--        number:setPosition(130,85)
--        notification:addChild(number)
--    end
    local type
    -- TODO get status list

    type = 'study'
    local notification = cc.Sprite:create('image/chapter/chapter0/notification.png')
    notification:setPosition(self.player:getContentSize().width/2,self.player:getContentSize().height)
    notification:setAnchorPoint(cc.p(0.5,0))
    notification:setScale(0)
    if isRunScale == true then
        notification:runAction(cc.ScaleTo:create(0.4,1))
    end
    notification:setTag(100)
    self.player:addChild(notification, 100)
    if type == 'study' then
        local title = cc.Label:createWithSystemFont('当前任务','',28)
        title:setColor(cc.c3b(56,26,23))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(55,115)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('积累生词: ','',22)
        task_name:setColor(cc.c3b(98,195,223))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(30,85)
        notification:addChild(task_name)
        local number = cc.Label:createWithSystemFont('0 / '..getMaxWrongNumEveryLevel(),'',25)
        number:setColor(cc.c3b(165,55,80))
        number:ignoreAnchorPointForPosition(false)
        number:setAnchorPoint(0,0)
        number:setPosition(130,85)
        notification:addChild(number)
        
        
        -- if s_CURRENT_USER.tutorialStep == s_tutorial_level_select then
        --     local finger = sp.SkeletonAnimation:create('spine/yindaoye_shoudonghua_dianji.json', 'spine/yindaoye_shoudonghua_dianji.atlas',1)
        --     finger:addAnimation(0, 'animation', true)
        --     finger:setPosition(notification:getContentSize().width/2+20,-30)
        --     notification:addChild(finger,10)
        --     s_CURRENT_USER:setTutorialStep(s_tutorial_level_select+1)
        --     s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_level_select+1)
        -- end
        
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                AnalyticsTasksBtn()
                AnalyticsFirst(ANALYTICS_FIRST_STUDY, 'TOUCH')
                
                -- TODO go to study
                s_CorePlayManager.initTotalPlay()
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)
        
        -- add button title
        local button_title = cc.Label:createWithSystemFont('继续积累','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
    elseif type == 'review' then
        local title = cc.Label:createWithSystemFont('当前任务','',28)
        title:setColor(cc.c3b(56,26,23))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(55,115)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('趁热打铁: ','',22)
        task_name:setColor(cc.c3b(98,195,223))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(30,85)
        notification:addChild(task_name)
        local number = cc.Label:createWithSystemFont('0 / '..getMaxWrongNumEveryLevel(),'',25)
        number:setColor(cc.c3b(165,55,80))
        number:ignoreAnchorPointForPosition(false)
        number:setAnchorPoint(0,0)
        number:setPosition(130,85)
        notification:addChild(number)
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                -- TODO go to study
                s_CorePlayManager.initTotalPlay()
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)
        
        -- add button title
        local button_title = cc.Label:createWithSystemFont('继续学习','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
    elseif type == 'reviewboss' then
        local title = cc.Label:createWithSystemFont('今日目标','',28)
        title:setColor(cc.c3b(56,26,23))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(55,115)
        notification:addChild(title)
        local task_name = cc.Label:createWithSystemFont('打败章鱼如花','',25)
        task_name:setColor(cc.c3b(98,195,223))
        task_name:ignoreAnchorPointForPosition(false)
        task_name:setAnchorPoint(0,0)
        task_name:setPosition(40,85)
        notification:addChild(task_name)
        -- define touchEvent
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                -- TODO go to study
                print('on review boss')
                s_CorePlayManager.initTotalPlay()
            end
        end
        local start = ccui.Button:create('image/chapter/chapter0/button.png','image/chapter/chapter0/button.png','image/chapter/chapter0/button.png')
        start:setScale9Enabled(true)
        start:setPosition(50,40)
        start:setAnchorPoint(0,0)
        notification:addChild(start)
        start:addTouchEventListener(touchEvent)

        -- add button title
        local button_title = cc.Label:createWithSystemFont('开始挑战','',20)
        --button_title:setColor(cc.c3b(0,0,0))
        button_title:ignoreAnchorPointForPosition(false)
        button_title:setAnchorPoint(0.5,0.5)
        button_title:setPosition(start:getContentSize().width/2,start:getContentSize().height/2)
        start:addChild(button_title)
    elseif type == 'complete' then
        local title = cc.Label:createWithSystemFont(' 今日目标已达成\n明天要再接再厉哦','',22)
        title:setColor(cc.c3b(74,136,184))
        title:ignoreAnchorPointForPosition(false)
        title:setAnchorPoint(0,0)
        title:setPosition(20,60)
        notification:addChild(title)
    end
end

function ChapterLayer:addPlayer()
--    self.player:removeFromParent()
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentChapterKey = 'chapter'..math.floor(levelInfo/s_islands_per_page)
    local levelKey = 'level'..levelInfo
    --self.player = cc.Sprite:create('image/chapter_level/gril_head.png')

    self.player = cc.Sprite:create('image/chapter/chapter0/player.png')
    local position = self.chapterDic[currentChapterKey]:getLevelPosition(levelKey)
    self.player:setPosition(position.x+100,position.y)
    --self.player:setScale(0.4)
    self.chapterDic[currentChapterKey]:addChild(self.player, 150)

--    print('ChapterLayer:addPlayer >>>')
--    print_lua_table(levelInfo)
--    print('ChapterLayer:addPlayer <<<')


end

function ChapterLayer:addPlayerOnLevel(chapterKey, levelKey)
    self.player:removeFromParent()
--    local levelInfo = s_CURRENT_USER.levelInfo:computeCu
    --self.player = cc.Sprite:create('image/chapter_level/gril_head.png')
    self.player = cc.Sprite:create('image/chapter/chapter0/player.png')
    local position = self.chapterDic[chapterKey]:getLevelPosition(levelKey)
--    print('!!!!!!!!!!player position!!!!!!')
--    print(position)
    self.player:setPosition(position.x+100,position.y)
    --self.player:setScale(0.4)
    self.chapterDic[chapterKey]:addChild(self.player, 150)
--
--    print('ChapterLayer:addPlayerOnLevel >>>')
--    print_lua_table(levelInfo)
--    print('ChapterLayer:addPlayerOnLevel <<<')

    
end

function ChapterLayer:addChapterIntoListView(chapterKey)
    print('add chapter list view:'..chapterKey)
    if chapterKey == 'chapter0' then    
        local ChapterLayer0 = require('view.level.ChapterLayer0')
        self.chapterDic['chapter0'] = ChapterLayer0.create("start")
        self.chapterDic['chapter0']:setPosition(cc.p(0,0))
        self.chapterDic['chapter0']:loadLevelPosition("level0")
        self.chapterDic['chapter0']:plotDecoration()
        -- local custom_item = ccui.Layout:create()
        -- custom_item:setContentSize(self.chapterDic['chapter0']:getContentSize())  
        -- custom_item:setName('chapter0')  
        -- custom_item:addChild(self.chapterDic['chapter0'])
        -- custom_item:setPosition(cc.p(0,0))
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
        -- self.listView:insertCustomItem(custom_item,1)
        self.listView:addChild(self.chapterDic['chapter0'])
   else    
        local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
        self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
        self.chapterDic[chapterKey]:setPosition(cc.p(0,0))
        --print('contentSize:'..self.chapterDic[chapterKey]:getContentSize().height)
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
        custom_item:setName(chapterKey)  
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
--        self.listView:addChild(self.chapterDic[chapterKey]) 
        self.listView:pushBackCustomItem(self.chapterDic[chapterKey])
    end    

end

-- scroll self.listView to show the specific chapter and level
function ChapterLayer:scrollLevelLayer(levelIndex, scrollTime)
    -- self:callFuncWithDelay(0.1, function()
        print('enter scrollLevelLayer...levelIndex:'..levelIndex)
        s_SCENE.touchEventBlockLayer.lockTouch()
        self:callFuncWithDelay(0.3, function()
            s_SCENE.touchEventBlockLayer.unlockTouch()
        end)
        if levelIndex == 0 then
            return
        end
        local currentLevelCount = levelIndex + 1
        -- local totalLevelCount = (math.floor((currentLevelCount-1) / s_islands_per_page) + 1) * s_islands_per_page
        -- local innerHeight = s_chapter0_base_height * (math.floor((currentLevelCount-1) / s_islands_per_page) + 1)
        -- self.listView:setInnerContainerSize(cc.size(s_chapter_layer_width, innerHeight))

        -- local currentVerticalPercent = currentLevelCount / totalLevelCount * 100

        -- active chapter range
        local activeLevelCount = levelIndex + 1 - self.activeChapterStartIndex * s_islands_per_page
        local activeTotalLevelCount = (self.activeChapterEndIndex - self.activeChapterStartIndex + 1) * s_islands_per_page
        local innerHeight = s_chapter0_base_height * (self.activeChapterEndIndex - self.activeChapterStartIndex + 1)
        print('innerCount:'..(self.activeChapterEndIndex - self.activeChapterStartIndex + 1))
        self.listView:setInnerContainerSize(cc.size(s_chapter_layer_width, innerHeight))
        -- self.listView:updateInnerContainerSize()
        -- compute vertical percent
        local chapterCount = math.floor((currentLevelCount-1) / 10)
        local levelCount = math.floor((currentLevelCount-1) % 10) + 1

        local currentVerticalPercent = (chapterCount / (chapterCount + 1) + levelCount / (s_islands_per_page * (chapterCount + 1)) ) * 100
        -- local currentVerticalPercent = (currentLevelCount / activeTotalLevelCount) * 100
        -- print('#######currentPercent:'..currentVerticalPercent,','..currentLevelCount..','..activeTotalLevelCount)
        print('#######currentPercent:'..currentVerticalPercent,','..chapterCount..','..levelCount)
        -- self:callFuncWithDelay(0.2, function()
            if scrollTime - 0 == 0 then
                self.listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,false)
            else
                self.listView:scrollToPercentVertical(currentVerticalPercent,scrollTime,true)
            end
            self.listView:setInertiaScrollEnabled(true)
        -- end)

    -- end)
    
end

function ChapterLayer:plotUnlockCloudAnimation()
    local action1 = cc.MoveBy:create(1.5, cc.p(-s_DESIGN_WIDTH*2,0))
    local action2 = cc.MoveBy:create(1.5, cc.p(s_DESIGN_WIDTH*2,0))
    self.chapterDic['leftCloud']:runAction(action1)
    self.chapterDic['rightCloud']:runAction(action2)
    self:callFuncWithDelay(1.6,function()
        self.chapterDic['leftCloud']:removeFromParent() 
        self.chapterDic['rightCloud']:removeFromParent()
    end)  
end

function ChapterLayer:addTopBounce()
    --if s_CURRENT_USER.currentChapterKey == 'chapter0' then
        --local blueLayerColor = cc.LayerColor:create(oceanBlue,bounceSectionSize.width,bounceSectionSize.height)
        local blueLayerColor = cc.LayerColor:create(oceanBlue,s_chapter_layer_width,s_DESIGN_HEIGHT)
        blueLayerColor:ignoreAnchorPointForPosition(false)
        blueLayerColor:setAnchorPoint(0,1)
        blueLayerColor:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,s_DESIGN_HEIGHT)
        self:addChild(blueLayerColor,-1)
    --end
end

function ChapterLayer:plotDecoration()
    -- plot user and boat
    local level0Position = self.chapterDic['chapter0']:getLevelPosition('level0')
--    local boat = cc.Sprite:create('image/chapter/chapter0/boat.png')
--    local fan = cc.Sprite:create('image/chapter/chapter0/fan.png')
--    local beibei = cc.Sprite:create('image/chapter/chapter0/startPlayer.png')
--    local boatPosition = cc.p(level0Position.x-100, level0Position.y+150)
--    local fanPosition = cc.p(boatPosition.x+40, boatPosition.y+80)
--    boat:setPosition(boatPosition)
--    fan:setPosition(fanPosition)
--    beibei:setPosition(cc.p(fanPosition.x-40,fanPosition.y-50))
--    self.chapterDic['chapter0']:addChild(boat, 130)
--    self.chapterDic['chapter0']:addChild(fan,130)
--    self.chapterDic['chapter0']:addChild(beibei,130)
    
    
    local boat = sp.SkeletonAnimation:create('spine/chuan.json', 'spine/chuan.atlas',1)
    boat:addAnimation(0, 'animation', true)
--    local boatPosition = cc.p(level0Position.x-100, level0Position.y+150)
    boat:setPosition(level0Position.x-200, level0Position.y+120)
    self.chapterDic['chapter0']:addChild(boat,130)
    
    -- add wave
    local wave = cc.Sprite:create('image/chapter/chapter0/shuibolang.png')
    wave:setPosition(level0Position.x-130, level0Position.y+80)
    self.chapterDic['chapter0']:addChild(wave,130)
    local action1 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(-50, 0)))
    local action2 = cc.EaseSineInOut:create(cc.MoveBy:create(5, cc.p(50, 0)))
    local action3 = cc.RepeatForever:create(cc.Sequence:create(action1, action2))
    wave:runAction(action3)

end

function ChapterLayer:addBottomBounce()
    self.chapterDic['leftCloud'] = cc.Sprite:create('image/chapter/leftCloud.png')
    self.chapterDic['rightCloud'] = cc.Sprite:create('image/chapter/rightCloud.png')
    self.chapterDic['leftCloud']:setAnchorPoint(0, 1)
    self.chapterDic['rightCloud']:setAnchorPoint(0, 1)
    self.chapterDic['leftCloud']:setPosition((s_chapter_layer_width-bounceSectionSize.width)/2,50)
    self.chapterDic['rightCloud']:setPosition((s_chapter_layer_width-bounceSectionSize.width)/2,50)
    self.listView:addChild(self.chapterDic['leftCloud'],200)
    self.listView:addChild(self.chapterDic['rightCloud'],200)
end

function ChapterLayer:addBackToHome()
    local click_home = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local IntroLayer = require("view.home.HomeLayer")
            local introLayer = IntroLayer.create(true)  
            s_SCENE:replaceGameLayer(introLayer)
        end
    end


    -- return to homepage button
    local homeButton = ccui.Button:create("image/homescene/missionprogress/white_circle.png","image/homescene/missionprogress/white_circle.png","")
    homeButton:addTouchEventListener(click_home)
    homeButton:ignoreAnchorPointForPosition(false)
    homeButton:setScale(0.15)
    --homeButton:setAnchorPoint(0,1)
    homeButton:setPosition(s_LEFT_X + 60  , s_DESIGN_HEIGHT - 60 )
    homeButton:setLocalZOrder(1)
    homeButton:setOpacity(0)
    self:addChild(homeButton,200)

    local missionCount = s_LocalDatabaseManager:getTodayTotalTaskNum()
    local completeCount = missionCount - s_LocalDatabaseManager:getTodayRemainTaskNum()

    local back = {}
    for i = 1,missionCount do
        back[i] = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
        back[i]:setColor(cc.c4b(170,217,231,255 * 0.2 * (i % 3 + 1)))
        --back[i]:setOpacity(255 * 0.2 * ((i - 1) % 3 + 1))
        back[i]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        back[i]:setPercentage(100 / missionCount)
        back[i]:setRotation(360 * (i - 1) / missionCount)
        back[i]:setPosition(homeButton:getContentSize().width / 2 ,homeButton:getContentSize().height / 2 )
        homeButton:addChild(back[i])
        
    end
    local circle_color = {cc.c3b(76,223,204),cc.c3b(36,168,217),cc.c3b(18,128,213)}
    if completeCount < missionCount then
        for i = 1, missionCount do 
            local split_line = cc.Sprite:create('image/homescene/home_page_task_circle_interval.png')
            split_line:setAnchorPoint(0.5,- 161 / 80)
            split_line:setPosition(homeButton:getContentSize().width / 2 ,homeButton:getContentSize().height / 2)
            homeButton:addChild(split_line,1)
            split_line:setRotation(360 * (i - 1) / missionCount)
        end
        for i = 1,completeCount do
            local taskProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
            taskProgress:setColor(circle_color[(i - 1) % 3 + 1])
            taskProgress:setPosition(homeButton:getContentSize().width / 2 ,homeButton:getContentSize().height / 2 )
            taskProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
            taskProgress:setReverseDirection(false)
            taskProgress:setPercentage(100 / missionCount)
            back[i]:addChild(taskProgress)
        end
    elseif completeCount == missionCount then
        local finishProgress = cc.Sprite:create('image/homescene/missionprogress/home_page_task_finished_circle.png')
        finishProgress:setPosition(homeButton:getContentSize().width / 2 ,homeButton:getContentSize().height / 2 )
        homeButton:addChild(finishProgress)
    end
    
    local str = "image/homescene/missionprogress/taskstartbutton.png"
    if missionCount == completeCount then
        str = "image/homescene/missionprogress/taskfinishedstartbutton.png"
    end
    local btnSprite = cc.Sprite:create(str)
    btnSprite:setPosition(homeButton:getContentSize().width / 2 ,homeButton:getContentSize().height / 2 )
    homeButton:addChild(btnSprite)
    
    onAndroidKeyPressed(self, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup == 0 then
            s_CorePlayManager.enterHomeLayer()
        end
    end, function ()

    end)
    
end

function ChapterLayer:addBeansUI()
    -- self.beans = cc.Sprite:create('image/chapter/chapter0/background_been_white.png')
    self.beans = cc.Sprite:create('image/chapter/chapter0/background_been_white.png')
    self.beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(self.beans,150)
    -- self.beanLabel = cc.Sprite:create('image/chapter/chapter0/bean.png')
    -- self.beanLabel:setPosition(-self.beans:getContentSize().width/2+70, self.beans:getContentSize().height/2+5)
    -- self.beans:addChild(self.beanLabel)    
    self.beanCount = s_CURRENT_USER:getBeans()
    self.beanCountLabel = cc.Label:createWithSystemFont(self.beanCount,'',24)
    self.beanCountLabel:setColor(cc.c4b(0,0,0,255))
    self.beanCountLabel:ignoreAnchorPointForPosition(false)
    -- self.beanCountLabel:setAnchorPoint(1,0)
    -- self.beanCountLabel:setPosition(105,2)
    self.beanCountLabel:setPosition(self.beans:getContentSize().width * 0.65 , self.beans:getContentSize().height/2)
    self.beans:addChild(self.beanCountLabel,10)

    -- local been_number_back = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    -- been_number_back:setPosition(bigWidth-100, s_DESIGN_HEIGHT-50)
    -- backColor:addChild(been_number_back)

    -- local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    -- been_number:setColor(cc.c4b(0,0,0,255))
    -- been_number:setPosition(been_number_back:getContentSize().width * 0.65 , been_number_back:getContentSize().height/2)
    -- been_number_back:addChild(been_number)

    -- local function updateBean(delta)
    --     been_number:setString(s_CURRENT_USER:getBeans())
    -- end
end

function ChapterLayer:shakeBeansUI(beansIncrement)

    if self.beanLabel ~= nil and self.beanCountLabel~=nil and self.beanCount ~=nil then
        local beanLabelPostionX = self.beanLabel:getPositionX()
        local beanLabelPostionY = self.beanLabel:getPositionY()
        local beanLabelAct1 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY+10))
        local beanLabelAct2 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY-10))
        local beanLabelAct3 = cc.MoveTo:create(0.05,cc.p(beanLabelPostionX,beanLabelPostionY))
        self.beanLabel:runAction(cc.Sequence:create(beanLabelAct1,beanLabelAct2,beanLabelAct3))

        self.beanCount = self.beanCount + beansIncrement
        self.beanCountLabel:setString(self.beanCount)
        
        local addBeanLabel = cc.Label:createWithSystemFont("+豆豆",'',20)
        addBeanLabel:setPosition(self.beanCountLabel:getPositionX()-20,self.beanCountLabel:getPositionY()+50)
        addBeanLabel:setColor(cc.c3b(0,0,0))
        self.beans:addChild(addBeanLabel)
        
        local addBeanLabelAct1 = cc.MoveTo:create(0.2,cc.p(addBeanLabel:getPositionX(),addBeanLabel:getPositionY()+10))
        local addBeanLabelAct2 = cc.FadeOut:create(0.3)
        addBeanLabel:runAction(cc.Spawn:create(addBeanLabelAct1,addBeanLabelAct2))
    end
end

return ChapterLayer