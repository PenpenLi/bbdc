require("cocos.init")
require('common.global')

s_chapter_resource_start_type = "start"
s_chapter_resource_middle_type = "middle" 
s_chapter_resource_end_type = "end"
s_chapter0_base_height = 3014
s_chapter_layer_width = 854

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

local ChapterLayerBase = class('ChapterLayerBase',function() 
    return ccui.Widget:create()
    --return cc.Layer:create()
end)

function ChapterLayerBase.create(chapterKey, startLevelKey)
    local layer = ChapterLayerBase.new(chapterKey, startLevelKey)
    return layer
end


function ChapterLayerBase:ctor(chapterKey, startLevelKey)
    self.chapterKey = chapterKey
    self.startLevelKey = startLevelKey
    self.levelPos = {}
end

function ChapterLayerBase:getLevelPosition(levelKey)
    for k, v in pairs(self.levelPos) do
        if string.sub(levelKey, 6) - k == 0 then
            return v
        end
    end
end

--t[1]: res
--t[2]: anchorPoint
--t[3]: position
function ChapterLayerBase:createObjectForResource(t)
    local object
    if t[1]~=nil then 
        if t[4] ~=nil and t[4]=='island' then
            -- define touchEvent
            local function touchEvent(sender,eventType)
                if eventType == ccui.TouchEventType.ended then
                    print('levelbutton '..sender.getName()..' touched...')
                end
            end
            print('create level button')
            object = ccui.Button:create(t[1],t[1],t[1])
            object:setScale9Enabled(true)
            object:setName(t[5])
            object:addTouchEventListener(touchEvent)
        else
            object = cc.Sprite:create(t[1])
        end
        
        if t[2]~=nil then 
            object:setAnchorPoint(t[2].x,t[2].y)
        end

        if t[3]~=nil then
            object:setPosition(t[3].x,t[3].y)
        end
--        if t[4]~=nil and t[4]== "island" then
--            object:setTag(islandTag)
--            islandTag=islandTag + 1
--        end
        if t[4] ~= nil then
            if t[4] == "back" then
                self:addChild(object,40)
            elseif t[4] == "add" then
                self:addChild(object,45)
            end
        else
            self:addChild(object,50)
        end
    end
    return object
end

function ChapterLayerBase:plotUnlockLevelAnimation(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local lockSprite = self:getChildByName('lock'..levelIndex)
    local lockLayer = self:getChildByName('lockLayer'..levelIndex)
    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),2)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0))  
    local action6 = cc.FadeOut:create(0.1)
    local action = cc.Sequence:create(action1, action4, action5, action6, nil)
    if lockSprite ~= nil then
        lockSprite:runAction(action)
    end

    local action7 = cc.DelayTime:create(0.6)
    local action8 = cc.FadeOut:create(0.1)
    if lockLayer ~= nil then
        lockLayer:runAction(cc.Sequence:create(action7, action8))
    end
    if lockSprite ~= nil or lockLayer ~= nil then
        s_SCENE:callFuncWithDelay(0.7,function()
            self:plotDecorationOfLevel(levelIndex-0)
        end)
    end
end

function ChapterLayerBase:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end


function ChapterLayerBase:plotDecorationOfLevel(levelIndex)
    local levelPosition = self.levelPos[levelIndex]
    
    -- define touchEvent
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print('BaseLayer:levelbutton '..sender:getName()..' touched...')                
            self:addPopup(sender:getName())
--              self:checkLevelStateBeforePopup(sender:getName())
            
        end
    end

    local levelButton = ccui.Button:create('image/chapter/chapter0/island.png','image/chapter/chapter0/island.png','image/chapter/chapter0/island.png')
    levelButton:setScale9Enabled(true)
    levelButton:setPosition(levelPosition)
    levelButton:setName(levelIndex)
    levelButton:addTouchEventListener(touchEvent)
    self:addChild(levelButton, 129)
    

    local currentIndex = levelIndex
    -- to do get level state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local levelState, coolingDay
    local currentTaskBossIndex = -1
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] + 0 == 0 and currentTaskBossIndex == -1 and bossInfo["typeIndex"] - 8 < 0 then
            currentTaskBossIndex = bossID - 1
        end
        if bossID - (levelIndex + 1) == 0 then
            levelState = bossInfo["typeIndex"] 
            coolingDay = bossInfo["coolingDay"] + 0
        end
    end
    
    -- check active
--    local todayReviewBoss = s_LocalDatabaseManager.getTodayReviewBoss()
--    local active
--    if #todayReviewBoss == 0 or todayReviewBoss[0] - (levelIndex + 1) ~= 0 then
--        active = 0
--    else
--        active = 1
--    end
--    print('####active'..active..','..levelState)
--    if levelConfig['type'] == 1 then
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 0
    local currentChapterKey = 'chapter'..math.floor(currentProgress/10)
    
    
    -- TODO add review boss position
    -- TODO check level state
----    local levelState = math.random(0, 3)
--    levelState = 5

    -- levelState = 3
    -- s_level_popup_state = 1

    if levelState == 0 then
        local deco = sp.SkeletonAnimation:create("spine/chapterlevel/beibeidaizi.json","spine/chapterlevel/beibeidaizi.atlas",1)
        deco:setPosition(levelPosition.x-60,levelPosition.y-10)
        deco:setAnchorPoint(1,1)
        deco:addAnimation(0, 'animation', true)
        self:addChild(deco, 130)
        -- local deco = cc.Sprite:create('image/chapter/elements/tubiao_daizi_tanchu_xiaoguan.png')
        -- deco:setPosition(levelPosition.x,levelPosition.y+20)
        -- self:addChild(deco, 130)
    elseif levelState == 1 then
        -- local deco = cc.Sprite:create('image/chapter/elements/tubiao_chuizi_tanchu_xiaoguan.png')
        -- deco:setPosition(levelPosition.x,levelPosition.y+20)
        -- self:addChild(deco, 130)
        if s_level_popup_state ~= 0 then
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/beibeidaizi.json","spine/chapterlevel/beibeidaizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
            deco:runAction(cc.FadeOut:create(1.0));
            self:callFuncWithDelay(0.5, function()
                local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
                deco:setPosition(levelPosition.x-60,levelPosition.y-10)
                deco:setAnchorPoint(1,1)
                deco:addAnimation(0, 'animation', true)
                self:addChild(deco, 130)
            end)
        else
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
        end


    elseif levelState == 2 or (levelState >= 4 and levelIndex == currentTaskBossIndex) then
        if s_level_popup_state ~= 0 then
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
            deco:runAction(cc.FadeOut:create(1.0))
            self:callFuncWithDelay(0.5, function()
                local reviewBoss = sp.SkeletonAnimation:create('spine/3 fxzlsxuanxiaoguandiaoluo1.json', 'spine/3 fxzlsxuanxiaoguandiaoluo1.atlas', 1)
                reviewBoss:addAnimation(1, '2', true)   
                reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
                self:addChild(reviewBoss, 140)
            end)
        else
            local reviewBoss = sp.SkeletonAnimation:create('spine/3 fxzlsxuanxiaoguandiaoluo1.json', 'spine/3 fxzlsxuanxiaoguandiaoluo1.atlas', 1)
            reviewBoss:addAnimation(1, '2', true)   
            reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
            self:addChild(reviewBoss, 140)
        end
        -- only one review boss
    elseif levelState == 3 then 
        if s_level_popup_state ~= 0 then
            local reviewBoss = sp.SkeletonAnimation:create('spine/3 fxzlsxuanxiaoguandiaoluo1.json', 'spine/3 fxzlsxuanxiaoguandiaoluo1.atlas', 1)
            reviewBoss:addAnimation(1, '2', true)   
            reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
            self:addChild(reviewBoss, 140)
            reviewBoss:setAnchorPoint(0.5,0.5)
            -- reviewBoss:runAction(cc.FadeOut:create(1.0))
            local action1 = cc.RotateBy:create(0.5, 360)
            local action2 = cc.MoveBy:create(0.5, cc.p(250, 800))
            local action3 = cc.ScaleTo:create(0.5, 0.75)
            local action4 = cc.Spawn:create(action1, action2, action3)
            reviewBoss:runAction(action4)
            self:callFuncWithDelay(0.4, function() 
                reviewBoss:runAction(cc.FadeOut:create(0.2))
            end)
            self:callFuncWithDelay(0.5, function()
                local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
                summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
                summaryboss:setAnchorPoint(1,1)
                summaryboss:addAnimation(0, 'jianxiao', true)
                summaryboss:setScale(0.7)
                self:addChild(summaryboss, 140)
            end)
        else
            local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
            summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
            summaryboss:setAnchorPoint(1,1)
            summaryboss:addAnimation(0, 'jianxiao', true)
            summaryboss:setScale(0.7)
            self:addChild(summaryboss, 140)
        end
    else
        -- plot level number
        self:plotLevelNumber('level'..levelIndex)
    end
end

function ChapterLayerBase:checkLevelStateBeforePopup(levelIndex)
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local state, coolingDay
    for bossID, bossInfo in pairs(bossList) do
        if bossID - (levelIndex + 1) == 0 then
            state = bossInfo["typeIndex"] + 0
            coolingDay = bossInfo["coolingDay"] + 0
        end
    end
    
    if state >= 4 and active ~= 0 then
        local WordLibrary = require("view.islandPopup.WordLibraryPopup")
        local wordLibrary = WordLibrary.create(levelIndex)
        s_SCENE.popupLayer:addChild(wordLibrary)   
        back:runAction(cc.MoveBy:create(0.2,cc.p(800,0)))
        wordLibrary.close = function ()
            back:runAction(cc.MoveBy:create(0.2,cc.p(-800,0)))
        end
    else
        self:addPopup(levelIndex)
    end
end

function ChapterLayerBase:addPopup(levelIndex)
--    print('addPopup:'..levelIndex)
    -- TODO check level state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local state, coolingDay
    local currentTaskBossIndex = -1
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] + 0 == 0 and currentTaskBossIndex == -1 and bossInfo["typeIndex"] - 8 < 0 then
            currentTaskBossIndex = bossID - 1
        end
        if bossID - (levelIndex + 1) == 0 then
            state = bossInfo["typeIndex"] 
            coolingDay = bossInfo["coolingDay"]
        end
    end
    
    local levelPosition = self:getLevelPosition('level'..levelIndex)
    local function taskEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            -- TODO add response
            local info = split(sender:getName(), '|')
            local bossID = info[1] + 1
            local state = info[2] + 0
            local active = info[3] + 0
            local currentTaskID = info[4] + 1
            local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 0
            s_SCENE:removeAllPopups()
            
            if state >= 4 and bossID ~= currentTaskID then
--                if true then

                    local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
                    tutorial_text:setPosition((s_chapter_layer_width-s_LEFT_X)/2, levelPosition.y)
                    self:addChild(tutorial_text,520)
                    print(tutorial_text:getPosition())
                    local text = cc.Label:createWithSystemFont('尚未接到神秘任务','',28)
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
 
            elseif currentTaskID ~= 0 and currentTaskID ~= (currentProgress + 1) and bossID == currentProgress + 1 then
            	local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
                    tutorial_text:setPosition((s_chapter_layer_width-s_LEFT_X)/2, levelPosition.y)
                    self:addChild(tutorial_text,520)
                    print(tutorial_text:getPosition())
                    local text = cc.Label:createWithSystemFont('需完成前面的复习boss才能继续','',28)
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
            else
                s_SCENE:callFuncWithDelay(0.1, function()
                    s_CorePlayManager.initTotalPlay()
                end)
            end
        end
    end
--    state = math.random(0, 7)
--    print('state is '..state)
    local back, taskButton, tick
--    state = 5
--    coolingDay = 1
    if state == 0 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_1.png')       
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_1.png','image/chapter/popup/button_pressed_xiaoguantancu_1.png','image/chapter/popup/button_unpressed_xiaoguantancu_1.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-200)
    elseif state == 1 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_2.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_2.png','image/chapter/popup/button_pressed_xiaoguantancu_2.png','')

        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-280)
--        taskButton:setAnchorPoint(0,0)
    elseif state == 2 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_3.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_3.png','image/chapter/popup/button_pressed_xiaoguantancu_3.png','image/chapter/popup/button_unpressed_xiaoguantancu_3.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-360)
    elseif state == 3 then    
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_4.png')     
        taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_4.png','image/chapter/popup/button_pressed_xiaoguantancu_4.png','image/chapter/popup/button_unpressed_xiaoguantancu_4.png')
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-450)
    elseif state == 4 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_5.png')     
        if coolingDay == 0 and levelIndex - currentTaskBossIndex == 0 then  
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_5.png','image/chapter/popup/button_pressed_xiaoguantancu_5.png','image/chapter/popup/button_unpressed_xiaoguantancu_5.png')
        else
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_?_1.png','image/chapter/popup/button_pressed_xiaoguantancu_?_1.png','')
        end
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-540)
    elseif state == 5 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_6.png')   
        if coolingDay == 0 and levelIndex - currentTaskBossIndex == 0 then  
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_6.png','image/chapter/popup/button_pressed_xiaoguantancu_6.png','image/chapter/popup/button_unpressed_xiaoguantancu_6.png')
        else
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_?_2.png','image/chapter/popup/button_pressed_xiaoguantancu_?_2.png','')
        end
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-630)
    elseif state == 6 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_7.png')     
        if coolingDay == 0 and levelIndex - currentTaskBossIndex == 0 then  
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_7.png','image/chapter/popup/button_pressed_xiaoguantancu_7.png','image/chapter/popup/button_unpressed_xiaoguantancu_7.png')
        else
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_?_3.png','image/chapter/popup/button_pressed_xiaoguantancu_?_3.png','')
        end
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-720)
    elseif state == 7 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_8.png')     
        if coolingDay == 0 and levelIndex - currentTaskBossIndex == 0 then  
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_8.png','image/chapter/popup/button_pressed_xiaoguantancu_8.png','image/chapter/popup/button_unpressed_xiaoguantancu_8.png')
        else
            taskButton = ccui.Button:create('image/chapter/popup/button_unpressed_xiaoguantancu_?_4.png','image/chapter/popup/button_pressed_xiaoguantancu_?_4.png','')
        end
        taskButton:setPosition(back:getContentSize().width/2, back:getContentSize().height-810) 
    elseif state == 8 then
        back = cc.Sprite:create('image/chapter/popup/background_xiaoguan_tanchu_9.png')
    end

    -- add popup title
    local popup_title = cc.Label:createWithSystemFont('夏威夷-'..(levelIndex+1),'Verdana-Bold',38)
    popup_title:setPosition(back:getContentSize().width/2,back:getContentSize().height-50)
    popup_title:setColor(cc.c3b(255,255,255))
    back:addChild(popup_title,20)
    -- add new hammer resource
    if state == 0 then
        local hammer = cc.Sprite:create('image/chapter/popup/chuizi_inactive.png')
        hammer:setPosition(222, back:getContentSize().height-316)
        back:addChild(hammer,10)
    elseif state >= 2 and state <= 8 then
        local hammer = cc.Sprite:create('image/chapter/popup/chuizi_active.png')
        hammer:setPosition(222, back:getContentSize().height-246)
        back:addChild(hammer,10)
    end

    if state <= 7 and state >= 4 then
        if coolingDay > 0 then
            local collingText = cc.Label:createWithSystemFont(coolingDay..'天后','',24)
            collingText:setPosition(taskButton:getContentSize().width-100,taskButton:getContentSize().height/2-50)
            collingText:setColor(cc.c3b(146,179,54))
            taskButton:addChild(collingText)
        end
    end

    
    if state ~= 8 then
        taskButton:setScale9Enabled(true)
        taskButton:setName(levelIndex..'|'..state..'|'..coolingDay..'|'..currentTaskBossIndex)
        taskButton:addTouchEventListener(taskEvent)
        back:addChild(taskButton)
        if s_level_popup_state == 2 then
            -- s_SCENE:callFuncWithDelay(0.5, function()
                if state ~= 0 then
                    tick = cc.Sprite:create('image/chapter/popup/duigo_green_xiaoguan_tanchu.png')
                    tick:setPosition(taskButton:getPositionX()+165, taskButton:getPositionY() + 115)
                    s_level_popup_state = 0
                    tick:setScale(2.0)
                    local action1 = cc.ScaleTo:create(0.5, 2.0)
                    local action2 = cc.ScaleTo:create(0.5, 1.0)
                    local action3 = cc.Sequence:create(action1, action2)
                    tick:runAction(action2)
                    back:addChild(tick, 10) 
                end
            -- end)
        else 
                if state ~= 0 then
                    tick = cc.Sprite:create('image/chapter/popup/duigo_green_xiaoguan_tanchu.png')
                    tick:setPosition(taskButton:getPositionX()+165, taskButton:getPositionY() + 115)
                    back:addChild(tick, 10) 
                end
        end
    end
    
    local function closeAnimation()
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 1.5)))
        local remove = cc.CallFunc:create(function() 
              s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(move,remove))
    end

    -- add close button
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
           closeAnimation()
        end
    end
    
    local function wordEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local WordLibrary = require("view.islandPopup.WordLibraryPopup")
            local wordLibrary = WordLibrary.create(levelIndex)

            s_SCENE.popupLayer:addChild(wordLibrary)
            wordLibrary:setVisible(false)
            local action0 = cc.OrbitCamera:create(0.5,1, 0, 0, 90, 0, 0) 
            local action1 = cc.CallFunc:create(function()
                wordLibrary:setVisible(true)
                local action2 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0)
                wordLibrary.backPopup:runAction(action2)
             end)
            back:runAction(cc.Sequence:create(action0,action1))
            
            wordLibrary.close = function ( )
                 local action0 = cc.DelayTime:create(0.5)
                 local action1 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0) 
                 back:runAction(cc.Sequence:create(action0,action1))
            end
        end
    end
    
    local closeButton = ccui.Button:create('image/button/button_close.png','image/button/button_close.png','image/button/button_close.png')
    closeButton:setScale9Enabled(true)
    closeButton:setPosition(back:getContentSize().width-60, back:getContentSize().height-60)
    closeButton:addTouchEventListener(touchEvent)
    
    local wordButton = ccui.Button:create('image/chapter/popup/button_change_to_ciku.png','','')
    wordButton:setScale9Enabled(true)
    wordButton:setPosition(60, back:getContentSize().height-50)
    wordButton:addTouchEventListener(wordEvent)
    
    back:addChild(closeButton)
    back:addChild(wordButton)
    
    local layer = cc.Layer:create()
    layer:addChild(back)

    s_SCENE:popup(layer)
    if state >= 4 and levelIndex - currentTaskBossIndex ~= 0 then
        local WordLibrary = require("view.islandPopup.WordLibraryPopup")
        local wordLibrary = WordLibrary.create(levelIndex)
        s_SCENE.popupLayer:addChild(wordLibrary)   
        back:setPosition(cc.p(s_DESIGN_WIDTH/2, 550))
        back:setVisible(false)
        
        wordLibrary:setPosition(0,550 * 3)
        local action2 = cc.MoveTo:create(0.5,cc.p(0, 0))
        wordLibrary:runAction(action2)
     
        wordLibrary.close = function ()
            local action0 = cc.DelayTime:create(0.5)
            local action1 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0) 
            back:runAction(cc.Sequence:create(action0,cc.CallFunc:create(function()back:setVisible(true)end),action1))
        end
    else
        back:setPosition(cc.p(s_DESIGN_WIDTH/2, 550 * 3))   
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, 550))
        local action2 = cc.EaseBackOut:create(action1)
        back:runAction(action2)
    end
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
           closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    onAndroidKeyPressed(layer, function ()
        closeAnimation()
    end, function ()

    end)
end

function ChapterLayerBase:plotDecoration()
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentLevelIndex = levelInfo
    local currentChapterIndex = math.floor(levelInfo / s_islands_per_page)
    local chapterIndex = string.sub(self.chapterKey, 8)
    -- add state information
    
    for levelIndex, levelPosition in pairs(self.levelPos) do
        -- add level button
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                local levelIndex = string.sub(sender:getName(), 10)
                local lockSprite = self:getChildByName('lock'..levelIndex)
                local lockLayer = self:getChildByName('lockLayer'..levelIndex)
                local action1 = cc.ScaleTo:create(0.12, 1.15, 0.85)
                local action2 = cc.ScaleTo:create(0.12, 0.85, 1.15)
                local action3 = cc.ScaleTo:create(0.12, 1.08, 0.92)
                local action4 = cc.ScaleTo:create(0.12, 0.92, 1.08)
                local action5 = cc.ScaleTo:create(0.12, 1.0, 1.0)
                local action6 = cc.Sequence:create(action1, action2, action3, action4, action5, nil)

                local l1 = cc.MoveBy:create(0.1, cc.p(10,0))
                local l2 = cc.MoveBy:create(0.1, cc.p(-20,0))
                local l3 = cc.MoveBy:create(0.1, cc.p(20,0))

                local l4 = cc.Repeat:create(cc.Sequence:create(l2, l3),3)
                local l5 = cc.MoveBy:create(0.1, cc.p(-10, 0))
                lockSprite:runAction(cc.Sequence:create(l1,l4, l5,nil))
                lockLayer:runAction(action6)
            end
        end
        if (levelIndex - currentLevelIndex) > 0 then
            -- local lockIsland = cc.Sprite:create('image/chapter/chapter0/lockisland2.png')
            -- lockIsland:setName('lockLayer'..levelIndex)
            -- lockIsland:addTouchEventListener(touchEvent)

            local lockIsland = ccui.Button:create('image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png')
            lockIsland:setScale9Enabled(true)
            lockIsland:setName('lockLayer'..levelIndex)
            lockIsland:addTouchEventListener(touchEvent)

            local lock = cc.Sprite:create('image/chapter/chapter0/lock.png')
            lock:setName('lock'..levelIndex)
            lockIsland:setPosition(levelPosition)
            -- lock:setPosition(lockIsland:getContentSize().width/2, lockIsland:getContentSize().height/2)
            lock:setPosition(levelPosition)
            self:addChild(lock,130)
            self:addChild(lockIsland,120)
        else
            self:plotDecorationOfLevel(levelIndex)
        end  
    end
end

function ChapterLayerBase:plotLevelNumber(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelPosition = self:getLevelPosition(levelKey)
    local chapterIndex = string.sub(self.chapterKey, 8)
--    if levelIndex - 0 == 0 and chapterIndex - 0 == 0 then  -- start 
--        local start = cc.Sprite:create('image/chapter/chapter0/start.png')
--        start:setPosition(levelPosition.x, levelPosition.y)
--        self:addChild(start, 130)
--    else
        local number = ccui.TextBMFont:create()
        number:setFntFile('font/number_inclined.fnt')
        --number:setColor(cc.c3b(56,26,23))
        number:setString(levelIndex+1)
        number:setPosition(levelPosition.x-5, levelPosition.y+10)
        self:addChild(number,130)
--    end

 
end

function ChapterLayerBase:loadResource()
end

return ChapterLayerBase
