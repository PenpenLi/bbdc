require("cocos.init")

local BackgroundLayer = require("layer.BackgroundLayer")
local GameLayer = require("layer.GameLayer")
local HudLayer = require("layer.HudLayer")
local PopupLayer = require("layer.PopupLayer")
local TipsLayer = require("layer.TipsLayer")
local TouchEventBlockLayer = require("layer.TouchEventBlockLayer")
local LoadingLayer = require("layer.LoadingLayer")
local DebugLayer = require("layer.DebugLayer")

-- define level layer state constant
s_normal_level_state = 'normalLevelState'
s_normal_next_state = 'normalNextState'
s_normal_retry_state = 'normalRetryState'
s_unlock_next_chapter_state = 'unlockNextChapterState'
s_unlock_normal_plotInfo_state = 'unlockNormalPlotInfoState'
s_unlock_normal_notPlotInfo_state = 'unlockNormalNotPlotInfoState'
s_review_boss_retry_state = 'reviewBossRetryState'
s_review_boss_appear_state = 'reviewBossAppearState'
s_review_boss_pass_state = 'reviewBossPassState'
-- define game layer state
s_normal_game_state = 'normalGameState'
s_test_game_state = 'testGameState'
s_review_boss_game_state = 'reviewBossGameState'
s_summary_boss_game_state = 'summaryBossGameState'

-- define tutorial state
s_tutorial_book_select = 0
s_tutorial_home = 1
s_tutorial_level_select = 2
s_tutorial_study = 3
s_tutorial_review_boss = 4
s_tutorial_summary_boss = 5
s_tutorial_complete = 6
-- define small tutorial state
s_smalltutorial_book_select = 0
s_smalltutorial_home = 1 -- 没有用到
s_smalltutorial_level_select = 2
s_smalltutorial_studyRepeat1_1 = 3 -- 收集生词
s_smalltutorial_studyRepeat1_2 = 4 -- 去划单词
s_smalltutorial_studyRepeat1_3 = 5 -- 划完
s_smalltutorial_studyRepeat2_1 = 6 -- 成功收集
s_smalltutorial_studyRepeat2_2 = 7 -- 开始打铁
s_smalltutorial_studyRepeat2_3 = 8 -- 完成打铁
s_smalltutorial_studyRepeat3_1 = 9 
s_smalltutorial_studyRepeat3_2 = 10
s_smalltutorial_studyRepeat3_3 = 11
s_smalltutorial_review_boss = 12
s_smalltutorial_summary_boss = 13
s_smalltutorial_complete = 14
s_smalltutorial_complete_win = 100
s_smalltutorial_complete_lose = 101
s_smalltutorial_complete_timeout = 102


-- define new tutorial state-- edit by ziaoang
s_newtutorial_story                 = 0
s_newtutorial_island_finger         = 1
s_newtutorial_island_alter_finger   = 2
s_newtutorial_collect_goal          = 3
s_newtutorial_train_goal            = 4
s_newtutorial_wordpool              = 5
s_newtutorial_sb_cn                 = 6
s_newtutorial_rb_show               = 7
s_newtutorial_island_back           = 8
s_newtutorial_over                  = 9
s_newtutorial_loginreward           = 10
s_newtutorial_shop                  = 11
s_newtutorial_allover               = 12

-- newTutorialStepRecord 
-- 1.进入选书界面
s_newTutorialStepRecord_selectBook = 1
-- 2.进入主界面
s_newTutorialStepRecord_enterHome = 2
-- 3.剧情1
s_newTutorialStepRecord_enterStory1 = 3
-- 4.剧情2
s_newTutorialStepRecord_enterStory2 = 4
-- 5.剧情3
s_newTutorialStepRecord_enterStory3 = 5
-- 6.剧情4
s_newTutorialStepRecord_enterStory4 = 6
-- 7.剧情5
s_newTutorialStepRecord_enterStory5 = 7
-- 8.剧情6
s_newTutorialStepRecord_enterStory6 = 8
-- 9.进入试玩的总结boss
s_newTutorialStepRecord_enterStoryBoss = 9
-- 10.剧情7
s_newTutorialStepRecord_enterStory7 = 10
-- 11.进入选小关界面
s_newTutorialStepRecord_enterLevel = 11
-- 12.进入收集生词
s_newTutorialStepRecord_collectWord = 12
-- 13.进入详细释义
s_newTutorialStepRecord_detailInfo = 13
-- 14.进入划词界面
s_newTutorialStepRecord_slideCoco = 14
-- 15.成功完成划词
s_newTutorialStepRecord_slideSuccess = 15
-- 16.进入第二个划词界面
s_newTutorialStepRecord_slideCoco2 = 16
-- 17.成功完成第二个划词
s_newTutorialStepRecord_slideSuccess2 = 17
-- 18.进入第三个划词界面
s_newTutorialStepRecord_slideCoco3 = 18
-- 19.成功完成收集生词
s_newTutorialStepRecord_slideSuccess3 = 19
-- 20.进入趁热打铁
s_newTutorialStepRecord_iron = 20
-- 21.完成乘热打铁
s_newTutorialStepRecord_ironSuccess = 21
-- 22.进入词库
s_newTutorialStepRecord_library = 22
-- 23.词库结束
s_newTutorialStepRecord_libraryOver = 23
-- 24.进入总结boss
s_newTutorialStepRecord_summaryBoss = 24
-- 25.完成总结boss胜利
s_newTutorialStepRecord_summaryBossSuccess = 25
-- 26.完成总结boss失败
s_newTutorialStepRecord_summaryBossFail = 26
-- 27.弹出打卡完成后的分享界面
s_newTutorialStepRecord_share = 27
-- 28.弹出贝贝拉出来的学霸指数界面
s_newTutorialStepRecord_king = 28
-- 29.完成新手引导
s_newTutorialStepRecord_end = 29
-- 30.弹出登陆奖励
s_newTutorialStepRecord_reward = 30
-- 31.进入商店
s_newTutorialStepRecord_shop = 31
-- 32.打开购买面板
s_newTutorialStepRecord_shopPopup = 32
-- 33.完成数据1购买
s_newTutorialStepRecord_buyData = 33
-- 34.结束
s_newTutorialStepRecord_over = 34

local AppScene = class("AppScene", function()
    return cc.Scene:create()
end)

function AppScene.create()
    local scene = AppScene.new()

    scene.currentGameLayerName = 'unknown'

    scene.rootLayer = cc.Layer:create()
    scene.rootLayer:setPosition(s_DESIGN_OFFSET_WIDTH, 0)
    scene:addChild(scene.rootLayer)
    
    scene.bgLayer = BackgroundLayer.create()
    scene.rootLayer:addChild(scene.bgLayer)

    scene.gameLayer = GameLayer.create()
    scene.rootLayer:addChild(scene.gameLayer)

    scene.hudLayer = HudLayer.create()
    scene.rootLayer:addChild(scene.hudLayer)

    scene.popupLayer = PopupLayer.create()
    scene.rootLayer:addChild(scene.popupLayer)
    
    scene.tipsLayer = TipsLayer.create()
    scene.rootLayer:addChild(scene.tipsLayer)

    scene.touchEventBlockLayer = TouchEventBlockLayer.create()
    scene.rootLayer:addChild(scene.touchEventBlockLayer)
    
    scene.loadingLayer = LoadingLayer.create()
    scene.rootLayer:addChild(scene.loadingLayer)

    if BUILD_TARGET == BUILD_TARGET_RELEASE then 
        scene.debugLayer = cc.Layer:create()
        scene.debugLayer:setVisible(false) 
    else
        scene.debugLayer = DebugLayer.create()
    end
    scene.rootLayer:addChild(scene.debugLayer)
    
    -- scene global variables
    scene.levelLayerState = s_normal_level_state
    scene.gameLayerState = s_normal_game_state
    return scene
end

local usingTimeSaveToLocalDB = 0
-- delta time : seconds
local function update(dt)
    -- s_O2OController.update(dt)

    -- if s_CURRENT_USER.sessionToken ~= '' and s_CURRENT_USER.serverTime >= 0 then
        -- s_CURRENT_USER.serverTime = s_CURRENT_USER.serverTime + dt
        --print('serverTime:'..s_CURRENT_USER.serverTime..',energyCount:'..s_CURRENT_USER.energyCount..',lastCool:'..s_CURRENT_USER.energyLastCoolDownTime)
        -- if s_CURRENT_USER.energyCount <= s_energyMaxCount then
        --     if s_CURRENT_USER.energyLastCoolDownTime < 0 then
        --         s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.serverTime;
        --     end
        --     local cnt = math.floor((s_CURRENT_USER.serverTime - s_CURRENT_USER.energyLastCoolDownTime) / s_energyCoolDownSecs)
        --     if cnt > 0 then
        --         s_CURRENT_USER.energyCount = s_CURRENT_USER.energyCount + cnt
        --         if s_CURRENT_USER.energyCount >= s_energyMaxCount then
        --             s_CURRENT_USER.energyCount = s_energyMaxCount
        --             s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.serverTime
        --         else 
        --             s_CURRENT_USER.energyLastCoolDownTime = s_CURRENT_USER.energyLastCoolDownTime + cnt * s_energyCoolDownSecs
        --         end
        --         s_CURRENT_USER:updateDataToServer()
        --     end
        -- end
    -- end 

    s_CURRENT_USER.dataShareTime = s_CURRENT_USER.dataShareTime + dt

    if IS_DEVELOPMENT_MODE and s_WordDictionaryDatabase and not s_WordDictionaryDatabase.allwords and s_SCENE.currentGameLayerName == 'HomeLayer' then
        print(s_WordDictionaryDatabase.nextframe, 's_WordDictionaryDatabase.nextframe')
        if s_WordDictionaryDatabase.nextframe == WDD_NEXTFRAME_STATE__RM_LOAD then
            showProgressHUD('', true)
            s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__STARTLOADING
        elseif s_WordDictionaryDatabase.nextframe == WDD_NEXTFRAME_STATE__STARTLOADING then
            s_WordDictionaryDatabase.init()
            hideProgressHUD(true)
        end
    end

    if s_CURRENT_USER ~= nil and s_CURRENT_USER.dataDailyUsing ~= nil and s_CURRENT_USER.dataDailyUsing:isInited() then
        if s_CURRENT_USER.dataDailyUsing:isToday() then
            s_CURRENT_USER.dataDailyUsing:update(dt)
            usingTimeSaveToLocalDB = usingTimeSaveToLocalDB + dt
            if usingTimeSaveToLocalDB > 10 then -- 10 s
                usingTimeSaveToLocalDB = 0
                s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER.dataDailyUsing, s_CURRENT_USER.objectId, s_CURRENT_USER.username)
                cx.CXAnalytics:logUsingTime(tostring(s_CURRENT_USER.objectId), tostring(s_CURRENT_USER.bookKey), s_CURRENT_USER.dataDailyUsing.startTime, s_CURRENT_USER.dataDailyUsing.usingTime)
            end
        else
            s_CURRENT_USER.dataDailyUsing:reset()
        end
    end
end

function AppScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
    
    self:scheduleUpdateWithPriorityLua(update, 0)
    -- self:registerCustomEvent()
end

function AppScene:replaceGameLayer(newLayer)   
    self.gameLayer:removeAllChildren()     
    self.gameLayer:addChild(newLayer)

    updateCurrentEverydayInfo()

    if newLayer.class ~= nil and newLayer.class.__cname ~= nil then 
        self.currentGameLayerName = newLayer.class.__cname
        if IS_DEVELOPMENT_MODE and newLayer.class.__cname == 'HomeLayer' then
            s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__INIT
            print(s_WordDictionaryDatabase.nextframe, 's_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__INIT')
        end
    else
        self.currentGameLayerName = 'unknown'
    end
    -- Analytics_replaceGameLayer(self.currentGameLayerName)
end

function AppScene:addLoadingView(needUpdate)
    self.loadingLayer.lockTouch()
    local k = self.loadingLayer:getChildrenCount()
    if k <= 0 then
        self.loadingLayer:removeAllChildren()
        local LoadingLayer = require("view.LoadingView")
        local loadingExtra = LoadingLayer.create(needUpdate)
        self.loadingLayer:addChild(loadingExtra)  
    end 
end

function AppScene:removeLoadingView()
    if self.loadingLayer:getChildrenCount() > 0 then
        local action = cc.DelayTime:create(0.5)
        self.loadingLayer:runAction(cc.Sequence:create(action,cc.CallFunc:create(function()
            self.loadingLayer.unlockTouch()
            self.loadingLayer:removeAllChildren()

            if IS_DEVELOPMENT_MODE and self.currentGameLayerName == 'HomeLayer' then
                s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD
                print(s_WordDictionaryDatabase.nextframe, 's_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD')
            end

        end)))
    end
end

function AppScene:popup(popupNode)
    self.popupLayer.listener:setSwallowTouches(true)
    self.popupLayer:removeAllChildren()
    self.popupLayer:addBackground()
    self.popupLayer:addChild(popupNode) 
end

function AppScene:removeAllPopups()
    self.popupLayer.listener:setSwallowTouches(false)
    local action1 = cc.FadeOut:create(0.2)
    if self.popupLayer.backColor ~= nil then
        self.popupLayer.backColor:runAction(action1)
    end
    s_SCENE:callFuncWithDelay(0.2,function ()
    self.popupLayer:removeAllChildren()
    end)
end

function AppScene:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

---- custom event

-- function AppScene:dispatchCustomEvent(eventName)
--     local event = cc.EventCustom:new(eventName)
--     self:getEventDispatcher():dispatchEvent(event)
-- end

-- function AppScene:registerCustomEvent()
--     local customEventHandle = function (event)
--         if event:getEventName() == CUSTOM_EVENT_SIGNUP then 
--             s_SCENE:gotoChooseBook()
--             hideProgressHUD()
--         elseif event:getEventName() == CUSTOM_EVENT_LOGIN then 
--             if s_CURRENT_USER.bookKey == '' then
--                 s_SCENE:gotoChooseBook()
--                 hideProgressHUD()
--             else
--                 s_SCENE:getDailyCheckIn()
--             end
--         end
--     end

--     local eventDispatcher = self:getEventDispatcher()
--     self.listenerSignUp = cc.EventListenerCustom:create(CUSTOM_EVENT_SIGNUP, customEventHandle)
--     eventDispatcher:addEventListenerWithFixedPriority(self.listenerSignUp, 1)

--     self.listenerLogIn = cc.EventListenerCustom:create(CUSTOM_EVENT_LOGIN, customEventHandle)
--     eventDispatcher:addEventListenerWithFixedPriority(self.listenerLogIn, 1)
-- end

function applicationWillEnterForeground()
    -- s_O2OController.showRestartTipWhenOfflineToOnline()
end

function applicationDidEnterBackgroundLua()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER.dataDailyUsing:isInited() and s_CURRENT_USER.dataDailyUsing:isToday() then
        s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER.dataDailyUsing, s_CURRENT_USER.objectId, s_CURRENT_USER.username)
        cx.CXAnalytics:logUsingTime(tostring(s_CURRENT_USER.objectId), tostring(s_CURRENT_USER.bookKey), s_CURRENT_USER.dataDailyUsing.startTime, s_CURRENT_USER.dataDailyUsing.usingTime)
    end
    Analytics_applicationDidEnterBackground( s_SCENE.currentGameLayerName )
end

function AppScene:checkInAnimation()
    local HomeLayer = require("view.home.HomeLayer")
    local homeLayer = HomeLayer.create(true)
    homeLayer:setName('homeLayer')
    self:replaceGameLayer(homeLayer)
    homeLayer:showDataLayer(true)
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    -- local delay = cc.DelayTime:create(3)
    -- local hide = cc.CallFunc:create(function()
        
    -- end,{})
    -- self:runAction(cc.Sequence:create(delay,hide))

end

function AppScene:checkInOver(homeLayer)
    s_HUD_LAYER:removeChildByName('missionComplete')
    homeLayer:hideDataLayer()
    --s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
end

return AppScene
