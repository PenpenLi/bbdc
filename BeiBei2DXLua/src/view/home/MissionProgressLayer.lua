require("cocos.init")
require("common.global")

local MissionProgressLayer = class("MissionProgressLayer", function ()
    return cc.Layer:create()
end)

MissionProgressLayer.hasGotNotContainedInLocalDatas = false
-- function callback() end
function MissionProgressLayer.getNotContainedInLocalDatas(callback)
    if MissionProgressLayer.hasGotNotContainedInLocalDatas or (not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken()) then
        if callback then callback() end
        return
    end

    showProgressHUD('', true)
    getNotContainedInLocalBossWordFromServer(function (serverDatas, error)
        MissionProgressLayer.hasGotNotContainedInLocalDatas = (error == nil)
        if callback then callback() end
        hideProgressHUD(true)
    end)
end

function MissionProgressLayer.create(share,homelayer)
    local missionCount = s_LocalDatabaseManager:getTodayTotalTaskNum()
    local completeCount = missionCount - s_LocalDatabaseManager:getTodayRemainTaskNum()
    if share ~= nil and share then
        completeCount = missionCount
    end

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    
    local taskTotal = 120
    local taskCurrent = 120
    
    local bossNumber = 0

    
    taskTotal = (bossNumber + 2) * getMaxWrongNumEveryLevel()
    --taskCurrent = s_CorePlayManager:getProgress() + (bossNumber - s_LocalDatabaseManager:getTodayRemainBossNum()) * s_max_wrong_num_everyday
    
    
    local startTime = 0

    local rolling 
    local swelling 
    local rollingCircle
    local finishProgress
    local enterButton
    local anotherEnterButton
    local anotherSwelling
    local buttonSpin
    local circleSpin
    
    
    local layer = MissionProgressLayer.new()
    
    
--    print("taskCurrent "..taskCurrent)
    layer.stopListener = false
    
    
    
    local missionToday = cc.Label:createWithSystemFont("今日任务","",50)
    missionToday:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 + 260)
    missionToday:setColor(cc.c4b(82,196,241,255))
    layer:addChild(missionToday)
    
    if missionCount == completeCount then
        missionToday:setString("任务完成")
        missionToday:setColor(cc.c4b(233,147,72,255))
    end
    
    local backProgress = cc.Sprite:create("image/homescene/missionprogress/white_circle.png")
    backProgress:setColor(cc.c4b(170,217,230,0))
    backProgress:setOpacity(0)
    backProgress:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 20)
    layer:addChild(backProgress)

    local back = {}
    for i = 1,missionCount do
        back[i] = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
        back[i]:setColor(cc.c4b(170,217,231,255 * 0.2 * (i % 3 + 1)))
        --back[i]:setOpacity(255 * 0.2 * ((i - 1) % 3 + 1))
        back[i]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        back[i]:setPercentage(100 / missionCount)
        back[i]:setRotation(360 * (i - 1) / missionCount)
        back[i]:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
        backProgress:addChild(back[i])
        
    end

    local circle_color = {cc.c3b(76,223,204),cc.c3b(36,168,217),cc.c3b(18,128,213)}

    layer.animation = function()
        if share ~= nil and share then
            if completeCount < missionCount then
                for i = 1, missionCount do 
                    local split_line = cc.Sprite:create('image/homescene/home_page_task_circle_interval.png')
                    split_line:setAnchorPoint(0.5,- 161 / 80)
                    split_line:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2)
                    backProgress:addChild(split_line,1)
                    split_line:setRotation(360 * (i - 1) / missionCount)
                    split_line:setVisible(false)
                    split_line:runAction(cc.Sequence:create(cc.DelayTime:create((i - 1) / missionCount),cc.Show:create()))
                end
            end
            local shareDelayTime = 0
            if share ~= nil and share then
                shareDelayTime = 0
            end
            for i = 1, completeCount do 
                local taskProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
                taskProgress:setColor(circle_color[(i - 1) % 3 + 1])
                taskProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
                taskProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
                taskProgress:setReverseDirection(false)
                taskProgress:setPercentage(0)
                local runProgress = cc.ProgressTo:create(1 / missionCount ,100 / missionCount)
                taskProgress:runAction(cc.Sequence:create(cc.DelayTime:create((i - 1) / missionCount + shareDelayTime),runProgress,cc.CallFunc:create(function()
                    if i < missionCount then
                        return
                    else--if taskTotal == taskCurrent then
                        local action1 = cc.FadeOut:create(1)
                        local action2 = cc.FadeOut:create(2)
                        local swell = cc.CallFunc:create(anotherSwelling)
                        if share ~= nil and share then
                            local a1 = cc.DelayTime:create(0.1)
                            local a2 = cc.CallFunc:create(function ()
                                homelayer:showShareCheckIn()
                            end,{})
                            swell = cc.Spawn:create(cc.Sequence:create(a1,a2),cc.CallFunc:create(anotherSwelling))
                        end
                        finishProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(1 , 100),swell))
                        finishProgress:setVisible(true) 
                        anotherEnterButton:setVisible(true)    

                        enterButton:runAction(action1)
                        taskProgress:runAction(action2)     

                        
                    -- else
                    --     swelling()
                    end
                end)))
                back[i]:addChild(taskProgress)
            end
        else
            if completeCount < missionCount then
                for i = 1, missionCount do 
                    local split_line = cc.Sprite:create('image/homescene/home_page_task_circle_interval.png')
                    split_line:setAnchorPoint(0.5,- 161 / 80)
                    split_line:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2)
                    backProgress:addChild(split_line,1)
                    split_line:setRotation(360 * (i - 1) / missionCount)
                end
                for i = 1,completeCount do
                    local taskProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle.png'))
                    taskProgress:setColor(circle_color[(i - 1) % 3 + 1])
                    taskProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
                    taskProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
                    taskProgress:setReverseDirection(false)
                    taskProgress:setPercentage(100 / missionCount)
                    back[i]:addChild(taskProgress)
                end
            elseif completeCount == missionCount then
                local swell = cc.CallFunc:create(anotherSwelling)
                finishProgress:setPercentage(100)
                finishProgress:runAction(cc.Sequence:create(swell))
                finishProgress:setVisible(true) 
                anotherEnterButton:setVisible(true) 
                enterButton:setVisible(false)

            end
        end

    end
    
    
    
    local enterGame = function ()
        MissionProgressLayer.getNotContainedInLocalDatas(function ()
            s_CURRENT_USER:generateSummaryBossList()
            s_CURRENT_USER:generateChestList()
            s_CURRENT_USER:updateDataToServer()

            -- TODO change analytics
            AnalyticsEnterLevelLayerBtn()
            AnalyticsFirst(ANALYTICS_FIRST_LEVEL, 'TOUCH')

            playSound(s_sound_buttonEffect)
            if layer:getChildByTag(8888) ~=nil then
                local schedule = layer:getChildByTag(8888):getScheduler()
                schedule:unscheduleScriptEntry(schedule.schedulerEntry)
            end
            -- todo check enter story layer
            if s_CURRENT_USER.newTutorialStep == s_newtutorial_story then
                s_CorePlayManager.enterStoryLayer()
            else
                --s_CorePlayManager.enterLevelLayer()
                s_CorePlayManager.enterStoryLayer()

            end
        end)
    end

    local enterButtonClick = function(sender, eventType)
        if layer.stopListener == false then
            if eventType == ccui.TouchEventType.began then
                playSound(s_sound_buttonEffect)   
            elseif eventType == ccui.TouchEventType.ended then
                local action1 = cc.MoveTo:create(0.5,cc.p(60  , s_DESIGN_HEIGHT - 60))
                local action2 = cc.ScaleTo:create(0.5,0.15)
                local action3 = cc.EaseSineIn:create(cc.Spawn:create(action1,action2))
                backProgress:runAction(cc.Sequence:create(action3,cc.DelayTime:create(0.1), cc.CallFunc:create(enterGame)))
            end
        else
            return
        end
    end
    
    enterButton = ccui.Button:create("image/homescene/missionprogress/taskstartbutton.png","image/homescene/missionprogress/taskstartbuttonclick.png","")
    enterButton:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    enterButton:addTouchEventListener(enterButtonClick)
    backProgress:addChild(enterButton)
    layer.button = enterButton
    
    local line = cc.LayerColor:create(cc.c4b(0,0,0,0),1,150)
    line:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2 - 20)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0,0)
    line:setScale(0)
    layer:addChild(line)   
    
    rolling = function ()
        line:setScale(1)
        local action1 = cc.RotateBy:create(1,360)
        line:runAction(cc.Sequence:create(action1,cc.CallFunc:create(swelling)))
    end

    swelling = function ()
        line:setScale(0)
        local action1 = cc.ScaleTo:create(0.25,1.05)
        local action2 = cc.ScaleTo:create(0.15,1)
        local action3 = cc.ScaleTo:create(0.25,1.05)
        local action4 = cc.ScaleTo:create(0.15,1)
        enterButton:runAction(cc.Sequence:create(action1, action2,action3,action4,cc.CallFunc:create(rolling)))
    end
     
    rollingCircle = cc.Sprite:create("image/homescene/missionprogress/rolling.png")
    rollingCircle:setPosition(0,150)
    line:addChild(rollingCircle)
    
    local tail = cc.Sprite:create("image/homescene/missionprogress/tail.png")
    tail:setPosition(10,20)
    tail:ignoreAnchorPointForPosition(false)
    tail:setAnchorPoint(1,1)
    tail:setRotation(-10)
    rollingCircle:addChild(tail)
    
    finishProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/home_page_task_finished_circle.png'))
    finishProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    finishProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    finishProgress:setReverseDirection(false)
    finishProgress:setPercentage(0)
    backProgress:addChild(finishProgress)
    finishProgress:setVisible(false)

    anotherEnterButton = ccui.Button:create("image/homescene/missionprogress/taskfinishedstartbutton.png","image/homescene/missionprogress/taskfinishedstartbuttonclick.png","")
    anotherEnterButton:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
    anotherEnterButton:addTouchEventListener(enterButtonClick)
    backProgress:addChild(anotherEnterButton) 
    anotherEnterButton:setVisible(false)
    
    anotherSwelling = function ()
        local action1 = cc.ScaleTo:create(0.25,1.05)
        local action2 = cc.ScaleTo:create(0.15,1)
        local action3 = cc.ScaleTo:create(0.25,1.05)
        local action4 = cc.ScaleTo:create(0.15,1)
        local action5 = cc.DelayTime:create(2)
        --anotherEnterButton:runAction(cc.Sequence:create(action1,action2,action3,action4,cc.CallFunc:create(buttonSpin)))
        anotherEnterButton:runAction(cc.RepeatForever:create(cc.Sequence:create(action1,action2,action3,action4,action5)))
    end
    
    buttonSpin = function ()
    	local action1 = cc.RotateBy:create(1,360)
    	anotherEnterButton:runAction(cc.Sequence:create(action1,cc.CallFunc:create(circleSpin)))
    end

    circleSpin = function ()
        local action1 = cc.RotateBy:create(1,360)
        finishProgress:runAction(cc.Sequence:create(action1,cc.CallFunc:create(anotherSwelling)))
    end


    
    -- local finishLabel = cc.Label:createWithSystemFont("已完成","",24)
    -- finishLabel:setPosition(bigWidth/2 - 80, s_DESIGN_HEIGHT/2 - 300)
    -- finishLabel:setColor(cc.c4b(134,150,159,255))
    -- layer:addChild(finishLabel)
    
    -- local blueLump = cc.LayerColor:create(cc.c4b(31,165,234,255),20,20)
    -- blueLump:setPosition(bigWidth/2 - 140, s_DESIGN_HEIGHT/2 - 310)
    -- layer:addChild(blueLump)
    
    -- local unfinishLabel = cc.Label:createWithSystemFont("未完成","",24)
    -- unfinishLabel:setPosition(bigWidth/2 + 120, s_DESIGN_HEIGHT/2 - 300)
    -- unfinishLabel:setColor(cc.c4b(134,150,159,255))
    -- layer:addChild(unfinishLabel)
    
    -- local grayLump = cc.LayerColor:create(cc.c4b(184,223,240,255),20,20)
    -- grayLump:setPosition(bigWidth/2 + 60, s_DESIGN_HEIGHT/2 - 310)
    -- layer:addChild(grayLump)
    



   -- local function enterSummaryBoss(sender, eventType)
   --     if eventType == ccui.TouchEventType.ended then
   -- local MiddleLayer = require("view.newstudy.MiddleLayer")
   -- local middleLayer = MiddleLayer.create()
   -- s_SCENE:replaceGameLayer(middleLayer)
   --     end
   -- end

   -- local Button_boss = ccui.Button:create("image/homescene/missionprogress/taskwordcollectionbutton.png","image/homescene/missionprogress/taskwordcollectionclickbutton.png.png","")
   -- Button_boss:setPosition(bigWidth/2 - 300 , s_DESIGN_HEIGHT/2 - 400)
   -- Button_boss:setTitleText("test")
   -- Button_boss:setTitleColor(cc.c4b(255,255,255,255))
   -- Button_boss:setTitleFontSize(40)
   -- Button_boss:addTouchEventListener(enterSummaryBoss)
   -- layer:addChild(Button_boss)

   -- Button_boss:setScale(0.5)
    
    
    
    return layer
end

function  MissionProgressLayer:setEnabled(enabled)
    self.button:setEnabled(enabled)
end

return MissionProgressLayer
