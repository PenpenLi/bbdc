require("Cocos2d")
require("Cocos2dConstants")

local BackgroundLayer = require("layer.BackgroundLayer")
local GameLayer = require("layer.GameLayer")
local HudLayer = require("layer.HudLayer")
local PopupLayer = require("layer.PopupLayer")
local TipsLayer = require("layer.TipsLayer")
local TouchEventBlockLayer = require("layer.TouchEventBlockLayer")
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
s_smalltutorial_home = 1
s_smalltutorial_level_select = 2
s_smalltutorial_studyRepeat1_1 = 3 -- touch cloud
s_smalltutorial_studyRepeat1_2 = 4 -- 去划单词
s_smalltutorial_studyRepeat1_3 = 5 -- 划完
s_smalltutorial_studyRepeat2_1 = 6
s_smalltutorial_studyRepeat2_2 = 7
s_smalltutorial_studyRepeat2_3 = 8
s_smalltutorial_studyRepeat3_1 = 9
s_smalltutorial_studyRepeat3_2 = 10
s_smalltutorial_studyRepeat3_3 = 11
s_smalltutorial_review_boss = 12
s_smalltutorial_summary_boss = 13
s_smalltutorial_complete = 14
s_smalltutorial_complete_win = 100
s_smalltutorial_complete_lose = 101
s_smalltutorial_complete_timeout = 102

-- define review boss tutorial

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

    scene.debugLayer = DebugLayer.create()
    if RELEASE_APP then scene.debugLayer:setVisible(false) end
    scene.rootLayer:addChild(scene.debugLayer)
    
    -- scene global variables
    scene.levelLayerState = s_normal_level_state
    scene.gameLayerState = s_normal_game_state
    return scene
end

-- delta time : seconds
local function update(dt)
    if s_CURRENT_USER.sessionToken ~= '' and  s_CURRENT_USER.serverTime >= 0 then
        s_CURRENT_USER.serverTime = s_CURRENT_USER.serverTime + dt
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

    if newLayer.class ~= nil and newLayer.class.__cname ~= nil then 
        self.currentGameLayerName = newLayer.class.__cname
    else
        self.currentGameLayerName = 'unknown'
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
    self.popupLayer:removeAllChildren()
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

---- sign up & log in

function AppScene:startLoadingData(hasAccount, username, password)
    local getAccount
    if hasAccount then 
        getAccount = s_UserBaseServer.logIn
    else
        getAccount = s_UserBaseServer.signUp
    end

    local function onResponse(u, e, code)

        if not hasAccount then 
            AnalyticsTutorial(0)
            AnalyticsSmallTutorial(0)
        end

        if e ~= nil then                  
            local function onError()
                s_DATABASE_MGR.close()
                s_START_FUNCTION()
            end
            s_TIPS_LAYER:showSmall(e, onError, onError)
            hideProgressHUD()
        elseif s_CURRENT_USER.bookKey == '' then
            s_SCENE:getConfigs(true)
        else
            -- s_SCENE:getDailyCheckIn()
            s_SCENE:getConfigs(false)
        end
        
    end

    cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
    showProgressHUD(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_USER_DATA))
    getAccount(username, password, onResponse)
end

function AppScene:signUp(username, password)
    self:startLoadingData(false, username, password)
end

function AppScene:logIn(username, password)
    self:startLoadingData(true, username, password)
end

-- function AppScene:getDailyCheckIn()
--     showProgressHUD(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_DAILY_LOGIN_DATA))
--     local co
--     co = coroutine.create(function(results)
--         if (results ~= nil) and (#results > 0) then
--             print ('getDailyCheckInOfCurrentUser: 02')
--             s_CURRENT_USER:parseServerDailyCheckInData(results)
--             s_SCENE:getConfigs(false)
--         else
--             print ('getDailyCheckInOfCurrentUser: 03')
--             s_CURRENT_USER.dailyCheckInData.userId = s_CURRENT_USER.objectId
--             s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.dailyCheckInData, 
--                 function (api, result)
--                     print_lua_table (s_CURRENT_USER.dailyCheckInData)
--                     coroutine.resume(co, {})
--                 end,
--                 function (api, code, message, description)
--                     coroutine.resume(co, {})
--                 end)
--             coroutine.yield()
--             s_SCENE:getConfigs(false)
--         end    
--     end)
--     s_UserBaseServer.getDailyCheckInOfCurrentUser( 
--         function (api, result)
--             print ('getDailyCheckInOfCurrentUser: 00')
--             coroutine.resume(co, result.results)
--         end,
--         function (api, code, message, description) 
--             print ('getDailyCheckInOfCurrentUser: 01')
--             coroutine.resume(co, {}) -- can not pass nil value
--         end
--     )
-- end

function AppScene:getConfigs(noBookKey)
    showProgressHUD(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_CONFIG_DATA))
    s_HttpRequestClient.getConfigs(function ()
        if noBookKey then
            s_SCENE:gotoChooseBook()
        else
            s_SCENE:getFollowees()
        end
    end)
end

function AppScene:getFollowees()
    showProgressHUD(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_FRIEND_DATA))
    s_UserBaseServer.getFolloweesOfCurrentUser( 
        function (api, result)
            s_CURRENT_USER:parseServerFolloweesData(result.results)
            s_SCENE:getFollowers()
        end,
        function (api, code, message, description)
            s_SCENE:getFollowers()
        end
    )
end

function AppScene:getFollowers()
    showProgressHUD(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_UPDATE_FRIEND_DATA))
    s_UserBaseServer.getFollowersOfCurrentUser( 
        function (api, result)
            s_CURRENT_USER:parseServerFollowersData(result.results)
            s_SCENE:getLevels()
        end,
        function (api, code, message, description)
            s_SCENE:getLevels()
        end
    )
end

function AppScene:getLevels()
    local co
    co = coroutine.create(function(results)
        if (results ~= nil) and (#results > 0) then
            s_CURRENT_USER:parseServerLevelData(results)
            s_SCENE:onUserServerDatasCompleted() 
            return
        else
            -- when got no level datas from server
            s_CURRENT_USER:setUserLevelDataOfUnlocked('chapter0', 'level0', 1, 
                function (api, result)
                    s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER, 
                        function (api, result)
                            coroutine.resume(co, {})
                        end,
                        function (api, code, message, description)
                            coroutine.resume(co, {})
                        end)
                end,
                function (api, code, message, description)
                    coroutine.resume(co, {})
                end)
            coroutine.yield()
            s_SCENE:onUserServerDatasCompleted() 
        end
    end)

    showProgressHUD(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_LOADING_LEVEL_DATA))
    s_UserBaseServer.getLevelsOfCurrentUser(
        function (api, result)
            coroutine.resume(co, result.results)
        end,
        function (api, code, message, description)
            coroutine.resume(co, {}) -- can not pass nil value
        end
    )
end

function AppScene:loadConfigs()
    s_DATA_MANAGER.loadBooks()
    s_DATA_MANAGER.loadChapters()
    s_DATA_MANAGER.loadDailyCheckIns()
    s_DATA_MANAGER.loadEnergy()
    s_DATA_MANAGER.loadItems()
    s_DATA_MANAGER.loadReviewBoss()
    s_DATA_MANAGER.loadStarRules()

    s_WordPool = s_DATA_MANAGER.loadAllWords()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()
end

function AppScene:saveSignUpAndLogInData(onSaved)
    self:loadConfigs()

    local friendsObjId = {}
    local friends = {}
    --    print_lua_table (s_CURRENT_USER.followers)
    --    print_lua_table (s_CURRENT_USER.followees)
    for key, follower in pairs(s_CURRENT_USER.followers) do
        friendsObjId[follower.objectId] = 1
        friends[follower.objectId] = follower
    end

    for key, followee in pairs(s_CURRENT_USER.followees) do
        if friendsObjId[followee.objectId] == 1 then
            friendsObjId[followee.objectId] = 2
            friends[followee.objectId] = followee
        end
    end
    for key, var in pairs(friends) do
        if friendsObjId[key] == 2 then
            s_CURRENT_USER.friends[#s_CURRENT_USER.friends + 1] = var
        elseif friendsObjId[key] == 1 then
            s_CURRENT_USER.fans[#s_CURRENT_USER.fans + 1] = var
        end
    end
    
    s_CURRENT_USER.friendsCount = #s_CURRENT_USER.friends
    s_CURRENT_USER.fansCount = #s_CURRENT_USER.fans
    s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER,
        function(api,result)
        end,
        function(api, code, message, description)
        end)
    
    local DataLogIn = require('model/user/DataLogIn')
    local function updateWeek(data, week)
        if data == nil then 
            data = DataLogIn.create()
            s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas + 1] = data
        end
        data.week = week
        data:setWeekDay(os.time())
        s_UserBaseServer.saveDataObjectOfCurrentUser(data, 
            function (api, result)
                onSaved()
                s_DATABASE_MGR.saveDataClassObject(data)
                hideProgressHUD()
            end,
            function (api, code, message, description)
                onSaved()
                s_DATABASE_MGR.saveDataClassObject(data)
                hideProgressHUD()
            end)
    end

    if s_CURRENT_USER.localTime == 0 then
        s_CURRENT_USER.localTime = os.time()
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
        updateWeek(nil, 1)
    else
        print ('os time, local time:', os.time(), s_CURRENT_USER.localTime)
        local currentWeeks = getCurrentLogInWeek(os.time() - s_CURRENT_USER.localTime)
        s_UserBaseServer.getDataLogIn(s_CURRENT_USER.objectId, currentWeeks,
            function (api, result)
                s_CURRENT_USER:parseServerDataLogIn(result.results)
                if #(result.results) <= 0 then
                    updateWeek(nil, currentWeeks)
                else
                    local data = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
                    updateWeek(data, data.week)
                end
            end,
            function (api, code, message, description)
                onSaved()
                hideProgressHUD()
            end)
    end
end

-- no book key
function AppScene:gotoChooseBook()
    self:saveSignUpAndLogInData(function ()
        s_CorePlayManager.enterBookLayer()
    end)
end

-- with book key
function AppScene:onUserServerDatasCompleted()    
    self:saveSignUpAndLogInData(function ()
        s_DATA_MANAGER.loadLevels(s_CURRENT_USER.bookKey)
        s_CURRENT_USER:initChapterLevelAfterLogin() -- update user data
        s_CorePlayManager.enterHomeLayer()

        showProgressHUD()
        s_HttpRequestClient.getBulletinBoard(function (index, title, content)
            local showBB = (s_CURRENT_USER.bulletinBoardMask <= 0 and index >= 0)
                       or (s_CURRENT_USER.bulletinBoardMask > 0 and math["and"](s_CURRENT_USER.bulletinBoardMask, (2 ^ index)) == 0)
            if showBB then
                local BulletinBoard = require('view.BulletinBoard')
                local bb = BulletinBoard.create() 
                bb:updateValue(index, title, content)
                s_SCENE:popup(bb)

                s_CURRENT_USER.bulletinBoardTime = s_CURRENT_USER.serverTime
            end

            hideProgressHUD()
        end)

    end)
end

function applicationDidEnterBackgroundLua()
    Analytics_applicationDidEnterBackground( s_SCENE.currentGameLayerName )
end

return AppScene
