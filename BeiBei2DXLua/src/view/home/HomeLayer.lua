require("cocos.init")
require("common.global")

local AlterI = require("view.alter.AlterI")
local ImproveInfo = require("view.home.ImproveInfo")
local MissionProgress = require("view.home.MissionProgressLayer")
local OfflineTipHome = require("view.offlinetip.OfflineTipForHome")
local OfflineTipFriend = require("view.offlinetip.OfflineTipForFriend")
local SmallAlter = require("view.alter.SmallAlter")
local SmallAlterWithOneButton = require("view.alter.SmallAlterWithOneButton")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)

local FRIEND_LOCKED = 0
local SHOP_LOCKED = 0
local REWARD_LOCKED = 0
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local list = {}
local TEXT_CHANGE_ACCOUNT = '切换账号' -- "登出游戏"

function HomeLayer.create(share)
    -- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterHome)
    --s_CURRENT_USER:addBeans(100)

    --Analytics.lua
    --打印bookKey

    --数据管理
    s_CURRENT_USER.dataDailyUsing:reset()


    AnalyticsSecondDayBook(s_CURRENT_USER.bookKey)
    local showDataShare = true
    if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
        showDataShare = false
        s_CURRENT_USER:setTutorialStep(s_tutorial_book_select+1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_book_select+1)
    end
    -- task
    local todayTotalBossNum     = s_LocalDatabaseManager:getTodayTotalBossNum()
    local todayRemainBossNum    = s_LocalDatabaseManager:getTodayRemainBossNum()
    local todayTotalTaskNum     = s_LocalDatabaseManager:getTodayTotalTaskNum()
    local todayRemainTaskNum    = s_LocalDatabaseManager:getTodayRemainTaskNum()

    -- print("todayTotalBossNum : "..todayTotalBossNum)
    -- print("todayRemainBossNum : "..todayRemainBossNum)
    -- print("todayTotalTaskNum : "..todayTotalTaskNum)
    -- print("todayRemainTaskNum : "..todayRemainTaskNum)

    local totalStudyWordNum     = s_LocalDatabaseManager.getStudyWordsNum(os.date('%x',os.time()))
    local totalGraspWordNum     = s_LocalDatabaseManager.getGraspWordsNum(os.date('%x',os.time()))
    local totalStudyDayNum      = s_LocalDatabaseManager.getStudyDayNum()

    -- add tutorial step
    AnalyticsTutorialHome()
    if s_CURRENT_USER.tutorialStep == s_tutorial_home then
        s_CURRENT_USER:setTutorialStep(s_tutorial_home+1)
        -- print('tutorial_step:'..s_CURRENT_USER.tutorial_step)
    end
    -- print("totalStudyWordNum : "..totalStudyWordNum)
    -- print("totalGraspWordNum : "..totalGraspWordNum)
    -- print("totalStudyDayNum : "..totalStudyDayNum)

    -- data begin
    local bookName          = s_DataManager.books[s_CURRENT_USER.bookKey].name
    local bookWordCount     = s_DataManager.books[s_CURRENT_USER.bookKey].words
    -- data end

    local username = "游客"

    local logo_name = {"head","book","information","logout"}
    local label_name = {username,"选择书籍","完善个人信息",TEXT_CHANGE_ACCOUNT}

    --数据管理结束

    s_SCENE.touchEventBlockLayer.unlockTouch()


    local layer = HomeLayer.new()

    local offset = 500
    local viewIndex = 1
    --设置页面标志位
    local isDataShow = false
    -- 信息页面标志位

    local backColor = cc.LayerColor:create(cc.c4b(211,239,254,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backColor,1)

    local top = cc.Sprite:create('image/homescene/home_page_bg_top.png')
    top:setAnchorPoint(0.5,1)
    top:setPosition(0.5 * backColor:getContentSize().width,s_DESIGN_HEIGHT)
    backColor:addChild(top)

    local dataShare = require('view.home.DataShare').create()
    backColor:addChild(dataShare,0,'dataShare')
    
    local background = cc.Sprite:create('image/homescene/home_back.png')
    background:setAnchorPoint(0.5,0)
    background:setPosition(0.5 * backColor:getContentSize().width,0)
    backColor:addChild(background,1)

    local been_number_back = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    been_number_back:setPosition(bigWidth-100, s_DESIGN_HEIGHT-70)
    backColor:addChild(been_number_back)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width * 0.65 , been_number_back:getContentSize().height/2)
    been_number_back:addChild(been_number)

    --更新贝贝豆数量
    local function updateBean(delta)
        been_number:setString(s_CURRENT_USER:getBeans())
    end

    been_number:scheduleUpdateWithPriorityLua(updateBean,0)

    -- setting ui
    local setting_back = cc.Sprite:create("image/homescene/setup_background.png")
    setting_back:setAnchorPoint(1,0.5)
    setting_back:setPosition(s_LEFT_X, s_DESIGN_HEIGHT/2)
    layer:addChild(setting_back,1)

    --add offline

    --判断是否是离线状态
    local online = s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()
    local offlineTipHome = OfflineTipHome.create()
    local offlineTipFriend = OfflineTipFriend.create()

    layer:addChild(offlineTipHome,2)
    layer:addChild(offlineTipFriend,2) 


    -- 打卡流程结束
    local createDataShareMark 

    local mission_progress
    local checkInDisplay = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) and not s_isCheckInAnimationDisplayed
    if checkInDisplay then
        if s_HUD_LAYER:getChildByName('missionComplete') ~= nil then
            s_HUD_LAYER:getChildByName('missionComplete'):setVisible(true)
        end
        s_isCheckInAnimationDisplayed = true
        mission_progress = MissionProgress.create(true,layer)
    else
        if showDataShare then
            createDataShareMark = true 
        end
        mission_progress = MissionProgress.create()
        mission_progress.animation()
    end
    backColor:addChild(mission_progress,1,'mission_progress')


    --音频下载
    local downloadSoundButton = require("view.home.DownloadSoundButton").create(top)

    local name = cc.Sprite:create('image/homescene/BBDC_word_title.png')
    name:setPosition(bigWidth/2, s_DESIGN_HEIGHT-85)
    backColor:addChild(name)

    --设置页面显示当前选书
    local book_name 

    local English_array = {'cet4','cet6','ncee','toefl','ielts','gre','gse','pro4','pro8','gmat','sat','middle','primary'}
    local simple_array = {'四级','六级','高考','托福','雅思','gre','考研','专四','专八','gmat','sat','中学','小学'}

    for i = 1, #English_array do
        if s_CURRENT_USER.bookKey == English_array[i] then
            book_name = simple_array[i]
        end
    end

    local currentBook = cc.Label:createWithSystemFont("正在学习："..book_name,"",22)
    currentBook:setPosition(bigWidth/2, s_DESIGN_HEIGHT-140)
    currentBook:setColor(cc.c4b(255,255,255,255))
    backColor:addChild(currentBook)

    -- 从主页面切到设置页面

    local function changeViewFromHomeToSetting()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        dataShare:setEnabled(false)
        mission_progress.stopListener = true
        viewIndex = 2
        local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
        backColor:runAction(action1)
        local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
        local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
        setting_back:runAction(cc.Sequence:create(action2, action3))
    end

    -- 从设置页面切到主页面

    local function changeViewFromSettingToHome()
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        dataShare:setEnabled(true)
        mission_progress.stopListener = false
        viewIndex = 1
        local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
        backColor:runAction(action1)
        local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
        local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
        setting_back:runAction(cc.Sequence:create(action2, action3))
    end

    --设置按钮事件

    local button_setting_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            if online == false then
                offlineTipHome.setFalse()
                offlineTipFriend.setFalse()
            end

            if viewIndex == 1 then
                changeViewFromHomeToSetting()
            else
                changeViewFromSettingToHome()
            end
        end
    end

    local button_main = ccui.Button:create("image/homescene/home_page_setting_button.png","image/homescene/home_page_setting_button_press.png","")
    button_main:setScale9Enabled(true)
    button_main:setPosition(bigWidth / 2 - 165, 200)
    button_main:addTouchEventListener(button_setting_clicked)
    backColor:addChild(button_main,1)

    --切换到好友或商店事件
    local changeView = "home"
    local function changeViewToFriendOrShop(destination)
        local DestinationLayer
        if destination == "ShopLayer" then
            changeView = "shop"
            DestinationLayer = require("view.shop."..destination)
        elseif destination == "FriendLayer" then
            changeView = "friend"
            DestinationLayer = require("view.friend."..destination)
        else
            return
        end
            
        local destinationLayer = DestinationLayer.create()
        layer:addChild(destinationLayer,1)
        destinationLayer:ignoreAnchorPointForPosition(false)
        destinationLayer:setAnchorPoint(0,0.5)
        destinationLayer:setPosition(s_RIGHT_X, s_DESIGN_HEIGHT/2)
        backColor:removeChildByName('redHint')
        if viewIndex == 2 then
            changeViewFromSettingToHome()
        end
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        
        local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2 - bigWidth,s_DESIGN_HEIGHT/2))
        backColor:runAction(action1)
        local action2 = cc.MoveTo:create(0.5, cc.p(bigWidth - bigWidth,s_DESIGN_HEIGHT/2))
        local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
        destinationLayer:runAction(cc.Sequence:create(action2, action3))

        destinationLayer.backToHome = function ()
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2 ,s_DESIGN_HEIGHT/2))
            backColor:runAction(action1)
            local action2 = cc.MoveTo:create(0.5, cc.p(bigWidth ,s_DESIGN_HEIGHT/2))
            local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            local action4 = cc.CallFunc:create(function ()
                destinationLayer:removeFromParent()
                changeView = "home"
            end)
            destinationLayer:runAction(cc.Sequence:create(action2, action3,action4))
        end  
    end


    local button_shop_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if s_CURRENT_USER.newTutorialStep < s_newtutorial_loginreward then
                local tipPopup =  SmallAlterWithOneButton.create("您现在不能进入商店。")
                s_SCENE:popup(tipPopup)
                tipPopup.affirm = function ()
                    s_SCENE:removeAllPopups()
                end
            else
                AnalyticsShopBtn()
                changeViewToFriendOrShop("ShopLayer")
            end
        end
    end

    local button_shop = ccui.Button:create("image/homescene/home_page_shop_button.png","image/homescene/home_page_shop_button_press.png","")
    if s_CURRENT_USER.newTutorialStep < s_newtutorial_loginreward then
        button_shop:loadTextureNormal("image/guide/shop_locked.png")
        button_shop:loadTexturePressed("image/guide/shop_locked.png")
    end
    button_shop:setPosition(bigWidth / 2 + 1, 200)
    button_shop:setScale9Enabled(true)
    button_shop:setAnchorPoint(0,0.5)
    button_shop:addTouchEventListener(button_shop_clicked)
    backColor:addChild(button_shop,1) 


        -- 签到领奖

    local function ClickRewardBtnFunction()
        if s_CURRENT_USER.newTutorialStep >= s_newtutorial_loginreward then
            -- 打卡之前，每日领奖功能锁定
            local Loginreward = require("view.loginreward.LoginRewardPopup")
            local loginreward = Loginreward.create()
            s_SCENE:popup(loginreward)
        else
            local tipPopup =  SmallAlterWithOneButton.create("您现在不能自动领取签到奖励。")
            s_SCENE:popup(tipPopup)
            tipPopup.affirm = function ()
                s_SCENE:removeAllPopups()
            end
        end
    end

    -- 新手引导

    if s_CURRENT_USER.newTutorialStep == s_newtutorial_shop then
        local darkColor = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        darkColor:setAnchorPoint(0.5,0.5)
        darkColor:ignoreAnchorPointForPosition(false)
        darkColor:setPosition(s_DESIGN_WIDTH/2 ,s_DESIGN_HEIGHT/2)
        layer:addChild(darkColor, 3)

        local back = cc.Sprite:create("image/newstudy/background_word_xinshouyindao_yellow.png")
        back:setPosition((s_RIGHT_X - s_LEFT_X)/2, s_DESIGN_HEIGHT*0.35)
        back:ignoreAnchorPointForPosition(false)
        back:setAnchorPoint(0.5,0.5)
        darkColor:addChild(back)

        local title = cc.Label:createWithSystemFont('商店可以使用贝贝豆哦！','',40)
        title:setPosition(back:getContentSize().width/2,back:getContentSize().height/2)
        title:setColor(cc.c3b(35,181,229))
        back:addChild(title)

        local body = cc.Sprite:create("image/newstudy/bb_big_yindao.png")
        body:setPosition(150, -150)
        back:addChild(body)

        local beibei_arm = cc.Sprite:create("image/newstudy/bb_arm_yindao.png")
        beibei_arm:setPosition(body:getContentSize().width/2 - 70,body:getContentSize().height/2 - 2)
        beibei_arm:ignoreAnchorPointForPosition(false)
        beibei_arm:setAnchorPoint(0,0)
        body:addChild(beibei_arm,-1)

        local button_shop_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                darkColor:removeFromParent()
                changeViewToFriendOrShop("ShopLayer")
            end
        end

        local button_shop = ccui.Button:create("image/homescene/home_page_shop_button.png","image/homescene/home_page_shop_button_press.png","")
        button_shop:setPosition(bigWidth / 2 + 1, 200)
        button_shop:setScale9Enabled(true)
        button_shop:setAnchorPoint(0,0.5)
        button_shop:addTouchEventListener(button_shop_clicked)
        darkColor:addChild(button_shop) 

        local onTouchBegan = function(touch, event)
            return true  
        end

        local onTouchEnded = function(touch, event)
            local location = darkColor:convertToNodeSpace(touch:getLocation())
            if not cc.rectContainsPoint(button_shop:getBoundingBox(),location) then
                darkColor:removeFromParent()
            end
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = darkColor:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, darkColor) 
    elseif s_CURRENT_USER.newTutorialStep == s_newtutorial_loginreward then
        ClickRewardBtnFunction()
    elseif s_CURRENT_USER.newTutorialStep == s_newtutorial_allover then
        if s_CURRENT_USER:getLockFunctionState(2) == 0 then
            s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_buyData)
        else
            s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_over)
        end
    end

    local button_reward_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then        
            ClickRewardBtnFunction()
        end
    end

    local button_reward = ccui.Button:create("image/homescene/home_page_medal_button.png","image/homescene/home_page_medal_button_press.png","")
    if s_CURRENT_USER.newTutorialStep < s_newtutorial_loginreward then
        button_reward:loadTextureNormal("image/guide/Rewardlocked.png")
        button_reward:loadTexturePressed("image/guide/Rewardlocked.png")
    end
    button_reward:setPosition(bigWidth / 2 + 166, 200)
    button_reward:setScale9Enabled(true)
    button_reward:addTouchEventListener(button_reward_clicked)
    backColor:addChild(button_reward,1)   

    -- 个人信息界面

    local button_data = cc.Sprite:create("image/homescene/main_bottom.png")
    button_data:setAnchorPoint(0.5,0)
    button_data:setPosition(bigWidth/2, 0)
    backColor:addChild(button_data,1)

    local data_back = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT - 260)  
    data_back:setAnchorPoint(0.5,1)
    data_back:ignoreAnchorPointForPosition(false)  
    data_back:setPosition(button_data:getContentSize().width/2, 0)
    button_data:addChild(data_back,2)

    local bottom = cc.LayerColor:create(cc.c4b(255,255,255,255), button_data:getContentSize().width, 100)
    bottom:setAnchorPoint(0.5,1)
    bottom:ignoreAnchorPointForPosition(false)  
    bottom:setPosition(button_data:getContentSize().width/2, 0)
    data_back:addChild(bottom)

    local data_name = cc.Label:createWithSystemFont("数据","",36)
    data_name:setColor(cc.c4b(0,150,210,255))
    --data_name:enableOutline(cc.c4b(0,150,210,255),1)
    data_name:setPosition(button_data:getContentSize().width/2+30, button_data:getContentSize().height/2-5)
    button_data:addChild(data_name,0)

    -- setting ui
    setting_back = cc.Sprite:create("image/homescene/setup_background.png")
    setting_back:setAnchorPoint(1,0.5)
    setting_back:setPosition(s_LEFT_X, s_DESIGN_HEIGHT/2)
    layer:addChild(setting_back,1)

    -- 更新设置页面选项
    local function updateSettingLayer()
        local button_back = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
        button_back:setOpacity(0)
        button_back:setAnchorPoint(0, 1)
        button_back:setPosition(0, s_DESIGN_HEIGHT-button_back:getContentSize().height * (1 - 1) - 80)
        setting_back:addChild(button_back)

        local logo = cc.Sprite:create("image/PersonalInfo/hj_personal_avatar.png")
        logo:setScale(0.9)
        logo:setPosition(button_back:getContentSize().width-offset+120, button_back:getContentSize().height/2 + 40)
        button_back:addChild(logo)
        local label = cc.Label:createWithSystemFont(s_CURRENT_USER.username,"",36)
        label:setColor(cc.c4b(0,0,0,255))
        label:setAnchorPoint(0, 0)
        label:setPosition(button_back:getContentSize().width-offset+210, button_back:getContentSize().height/2 + 30)
        button_back:addChild(label)

        local label2 = cc.Label:createWithSystemFont('正在学习'..bookName..'词汇',"",24)
        label2:setColor(cc.c4b(0,0,0,255))
        label2:setAnchorPoint(0, 1)
        label2:setPosition(button_back:getContentSize().width-offset+210, button_back:getContentSize().height/2 + 30)
        button_back:addChild(label2)

        local split = cc.LayerColor:create(cc.c4b(150,150,150,255),854,1)
        split:ignoreAnchorPointForPosition(false)
        split:setAnchorPoint(0.5,0)
        split:setPosition(button_back:getContentSize().width/2, 0)
        button_back:addChild(split)

        local sprite1 = setting_back:getChildByName("button1")                               
        if sprite1 ~= nil then sprite1:removeFromParent() end
        local sprite2 = setting_back:getChildByName("button4") 
        if sprite2 ~= nil then sprite2:setPosition(0, s_DESIGN_HEIGHT - sprite2:getContentSize().height * (4 - 2) - 90) end
        local sprite3 = setting_back:getChildByName("button3")                               
        if sprite3 ~= nil then sprite3:removeFromParent() end
    end

    local follow_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- popup layer
            AnalyticsFollowBeibei()
            local back = cc.Sprite:create("image/homescene/background_ciku_white.png")
            back:setPosition(cc.p(s_DESIGN_WIDTH/2, 550))
            local info = cc.Sprite:create('image/homescene/Phone-Hook1.png')
            info:setPosition(back:getContentSize().width/2, back:getContentSize().height/2)
            back:addChild(info)

            local close_button_clicked = function(sender, eventType)
                if eventType == ccui.TouchEventType.ended then
                    s_SCENE:removeAllPopups()
                end
            end
            local closeButton = ccui.Button:create("image/popupwindow/closeButtonRed.png","image/popupwindow/closeButtonRed.png","")
            closeButton:setPosition(back:getContentSize().width-30, back:getContentSize().height-30)
            closeButton:addTouchEventListener(close_button_clicked)
            back:addChild(closeButton)

            local label2 = cc.Label:createWithSystemFont("V2.0.6","",25)
            label2:setColor(cc.c4b(36,61,78,255))
            label2:setPosition(back:getContentSize().width/2+45, back:getContentSize().height/2+75)
            info:addChild(label2)

            local layer = cc.Layer:create()
            layer:addChild(back)

            s_SCENE:popup(layer)
        end
    end
    local followButton = ccui.Button:create("image/homescene/attention_button.png","image/homescene/attention_button_press.png","image/setting/attention_button_press.png")
    followButton:setAnchorPoint(0,1)
    followButton:setPosition(400,190)
    setting_back:addChild(followButton,10)
    local deco = cc.Sprite:create("image/homescene/attention_beibei1.png")
    deco:setPosition(750,100)
    setting_back:addChild(deco, 10)
    local text = cc.Label:createWithSystemFont("关注贝贝","",36)
    text:setColor(cc.c4b(255,255,255,255))
    -- text:setAnchorPoint(0, 0)
    text:setPosition(followButton:getContentSize().width/2, followButton:getContentSize().height/2)
    followButton:addChild(text)
    followButton:addTouchEventListener(follow_button_clicked)
    -- 设置页面内容

    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
        username = s_CURRENT_USER:getNameForDisplay()
        logo_name = {"head","book","logout"}
        label_name = {username,"选择书籍",TEXT_CHANGE_ACCOUNT}
    end

    local label = {}
    local logo = {}
    local button_back = {}
    for i = 1, #logo_name do
        local button_back_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                playSound(s_sound_buttonEffect)
                if label_name[i] == "选择书籍" then
                    AnalyticsChangeBookBtn()
                    s_CorePlayManager.enterBookLayer()
                elseif label_name[i] == "完善个人信息" then
                    if  online == false then
                        offlineTipHome.setTrue(OfflineTipForHome_ImproveInformation)
                    else
                        local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_HOME_LAYER)
                        s_SCENE:popup(improveInfo)

                        improveInfo.close = function()
                            s_SCENE:removeAllPopups()
                            if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                                updateSettingLayer()
                            end
                        end
                    end
                elseif label_name[i] == TEXT_CHANGE_ACCOUNT then
                    if not s_SERVER.isNetworkConnectedNow() then
                        offlineTipHome.setTrue(OfflineTipForHome_Logout)
                    else

                        -- logout
                        -- AnalyticsLogOut()
                        -- cx.CXAvos:getInstance():logOut()
                        -- s_LocalDatabaseManager.setLogOut(true)
                        -- s_LocalDatabaseManager.close()
                        -- s_START_FUNCTION()
                        local ChangeAccountPopup = require('view.login.ChangeAccountPopup')
                        local loginPopup = ChangeAccountPopup.create()
                        s_SCENE:popup(loginPopup)

                        loginPopup:setVisible(false)
                        loginPopup:setPosition(0,s_DESIGN_HEIGHT * 1.5) 

                        local action2 = cc.CallFunc:create(function()
                            loginPopup:setVisible(true)
                        end)
                        local action3 = cc.MoveTo:create(0.5,cc.p(0,0)) 
                        local action4 = cc.Sequence:create(action2, action3)
                        loginPopup:runAction(action4)

                    end
                else
                -- do nothing
                end
            end
        end
        ----

        ----
        button_back[i] = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
        button_back[i]:setOpacity(0)
        button_back[i]:setAnchorPoint(0, 1)
        button_back[i]:setPosition(0, s_DESIGN_HEIGHT-button_back[i]:getContentSize().height * (i - 1) - 80)
        button_back[i]:addTouchEventListener(button_back_clicked)
        button_back[i]:setName("button"..i)
        setting_back:addChild(button_back[i])

        if i > 1 then
            logo[i] = cc.Sprite:create("image/homescene/setup_"..logo_name[i]..".png")
            logo[i]:setPosition(button_back[i]:getContentSize().width-offset+120, button_back[i]:getContentSize().height/2)
            button_back[i]:addChild(logo[i])
            label[i] = cc.Label:createWithSystemFont(label_name[i],"",32)
            label[i]:setColor(cc.c4b(0,0,0,255))
            label[i]:setAnchorPoint(0, 0.5)
            label[i]:setPosition(button_back[i]:getContentSize().width-offset+200, button_back[i]:getContentSize().height/2)
            button_back[i]:addChild(label[i])
        else
            logo[i] = cc.Sprite:create("image/PersonalInfo/hj_personal_avatar.png")
            logo[i]:setScale(0.9)
            logo[i]:setPosition(button_back[i]:getContentSize().width-offset+120, button_back[i]:getContentSize().height/2 + 40)
            button_back[i]:addChild(logo[i])
            label[i] = cc.Label:createWithSystemFont(label_name[i],"",36)
            label[i]:setColor(cc.c4b(0,0,0,255))
            label[i]:setAnchorPoint(0, 0)
            label[i]:setPosition(button_back[i]:getContentSize().width-offset+210, button_back[i]:getContentSize().height/2 + 30)
            button_back[i]:addChild(label[i])

            local label2 = cc.Label:createWithSystemFont('正在学习'..bookName..'词汇',"",24)
            label2:setColor(cc.c4b(0,0,0,255))
            label2:setAnchorPoint(0, 1)
            label2:setPosition(button_back[i]:getContentSize().width-offset+210, button_back[i]:getContentSize().height/2 + 30)
            button_back[i]:addChild(label2)
        end

        local split = cc.LayerColor:create(cc.c4b(150,150,150,255),854,1)
        split:ignoreAnchorPointForPosition(false)
        split:setAnchorPoint(0.5,0)
        split:setPosition(button_back[i]:getContentSize().width/2, 0)
        button_back[i]:addChild(split)

        --add offline 
        if i == 1 or i == 2 then
        else
            if online == false then
                label[i]:setColor(cc.c4b(157,157,157,255))
            end
        end
    end
    -- 设置页面结束

    -- 好友按钮事件
    layer.friendButtonFunc = function ()
        if  online == false then
            offlineTipFriend.setTrue()
            return
        end

        if s_CURRENT_USER.newTutorialStep < s_newtutorial_loginreward then
            local tipPopup =  SmallAlterWithOneButton.create("您现在不能使用好友功能。")
            s_SCENE:popup(tipPopup)
            tipPopup.affirm = function ()
                s_SCENE:removeAllPopups()
            end
            return
        end

        if s_CURRENT_USER:getLockFunctionState(1) == 0 then -- check is friend function unlock
            local ShopAlter = require("view.shop.ShopAlter")
            local shopAlter = ShopAlter.create(1, 'out')
            s_SCENE:popup(shopAlter)
            return
        end

        if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
            changeViewToFriendOrShop("FriendLayer")
        else
            if s_CURRENT_USER.usertype == USER_TYPE_GUEST then
                local Item_popup = require("popup/PopupModel")
                local item_popup = Item_popup.create(Site_From_Friend_Guest)  
                s_SCENE:popup(item_popup)

                item_popup.update = function()
                    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                        updateSettingLayer()
                    end
                end
            end
        end   
    end

    local button_friend_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            AnalyticsFriendBtn()
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            layer.friendButtonFunc()
        end
    end

    local button_friend 
    if s_CURRENT_USER:getLockFunctionState(1) == 1 then
        button_friend = ccui.Button:create("image/homescene/home_page_friends_button.png","image/homescene/home_page_friends_button_press.png","")
        button_friend:setPosition(bigWidth / 2 - 1, 200)
    else
        button_friend = ccui.Button:create("image/homescene/home_page_friends_button_locked.png","image/homescene/home_page_friends_button_locked.png","")
        button_friend:setPosition(bigWidth / 2 - 0.5, 200)
    end
    button_friend:setScale9Enabled(true)
    button_friend:setAnchorPoint(1,0.5)
    button_friend:addTouchEventListener(button_friend_clicked)
    backColor:addChild(button_friend,1)   

    -- 好友解锁

    local function updateFriendButton(delta)
        if s_CURRENT_USER:getLockFunctionState(1) == 1 then
            button_friend:removeFromParent()
            button_friend = ccui.Button:create("image/homescene/home_page_friends_button.png","image/homescene/home_page_friends_button_press.png","")
            button_friend:setPosition(bigWidth / 2 - 1, 200)
            button_friend:setScale9Enabled(true)
            button_friend:setAnchorPoint(1,0.5)
            button_friend:addTouchEventListener(button_friend_clicked)
            backColor:addChild(button_friend,1)   

            layer.button_friend = button_friend
            button_friend:unscheduleUpdate()
        end
    end
    button_friend:scheduleUpdateWithPriorityLua(updateFriendButton,0)
    if math.floor(s_LocalDatabaseManager.isBuy() / math.pow(10,0)) == 0 then
        s_UserBaseServer.getFolloweesOfCurrentUser( 
            function (api,result)
                s_UserBaseServer.getFollowersOfCurrentUser( 
                    function (api, result)
                        --print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)
                        s_CURRENT_USER:getFriendsInfo()
                        --print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)

                        if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
                            local redHint = cc.Sprite:create('image/friend/fri_infor.png')
                            redHint:setPosition(bigWidth / 2 - 22, 233)
                            backColor:addChild(redHint,1,'redHint')

                            local num = cc.Label:createWithSystemFont(string.format('%d',s_CURRENT_USER.fansCount - s_CURRENT_USER.seenFansCount),'',28)
                            num:setPosition(redHint:getContentSize().width / 2,redHint:getContentSize().height / 2)
                            redHint:addChild(num)
                        end
                    end,
                    function (api, code, message, description)
                    end
                )
            end,
            function (api, code, message, description)
            end
        )
    end

    -- 个人信息界面弹入

    local function changeViewFromHomeToInfo()
        isDataShow = true
        layer:setButtonEnabled(false)
        button_data:setLocalZOrder(2)
        button_data:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(bigWidth/2, s_DESIGN_HEIGHT-260))))
        s_SCENE:callFuncWithDelay(0.3,function ()
            if online == false then
                offlineTipHome.setFalse()
                offlineTipFriend.setFalse()
            end
            local PersonalInfo = require("view.PersonalInfo")
            PersonalInfo.getNotContainedInLocalDatas(function ()
                local personalInfoLayer = PersonalInfo.create()
                personalInfoLayer:setPosition(-s_LEFT_X,0)
                data_back:addChild(personalInfoLayer,1,'PersonalInfo')
                end) 
            end) 
    end

    -- 个人信息界面弹出
    local function changeViewFromInfoToHome()
        isDataShow = false
        layer:setButtonEnabled(true)
        local action1 = cc.MoveTo:create(0.3,cc.p(bigWidth/2, 0))
        local action2 = cc.CallFunc:create(function()
            button_data:setLocalZOrder(1)
            data_back:removeChildByName('PersonalInfo')
        end)
        button_data:runAction(cc.Sequence:create(action1, action2))
    end


    -- 触摸事件
    local moveLength = 100
    local moved = false
    local start_x = nil
    local start_y = nil
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        start_x = location.x
        start_y = location.y
        moved = false
        return true
    end

    local onTouchMoved = function(touch, event)
        if moved then
            return
        end

        local location = layer:convertToNodeSpace(touch:getLocation())
        local now_x = location.x
        local now_y = location.y
        -- 个人信息界面弹出弹入
        if start_y < 0.1 * s_DESIGN_HEIGHT and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
            if now_y - moveLength > start_y and not isDataShow and viewIndex == 1 then         
                    changeViewFromHomeToInfo()
                return
            end
        end
        if start_y > s_DESIGN_HEIGHT - 260 and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
            if now_y + moveLength < start_y and isDataShow and viewIndex == 1 then
                    changeViewFromInfoToHome()
                return
            end

        end
        -- 设置页面切回主界面
        if now_x + moveLength < start_x and not isDataShow then
            if viewIndex == 2 then
                changeViewFromSettingToHome()
            end
        end

    end

    local onTouchEnded = function(touch,event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(setting_back:getBoundingBox(),location) and viewIndex == 2 then
            changeViewFromSettingToHome()
        end
        if not isDataShow then
            if math.abs(location.y - start_y) > 10 or math.abs(location.x - start_x) > 10 then
                return
            elseif viewIndex == 1 and location.y < 0.1 * s_DESIGN_HEIGHT then
                changeViewFromHomeToInfo()
            end
        elseif location.y >  s_DESIGN_HEIGHT-260 and (math.abs(location.y - start_y) < 10 and math.abs(location.x - start_x) < 10) and viewIndex == 1 then
                changeViewFromInfoToHome()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    playMusic(s_sound_First_Noel_pluto,true)
    
    layer.button_main = button_main
    layer.button_sound = downloadSoundButton
    layer.button_enter = mission_progress
    layer.button_reward = button_reward
    layer.button_shop = button_shop
    layer.button_friend = button_friend
    layer.dataBack = data_back
    layer.dataButton = button_data
    layer.dataShare = dataShare

    -- 打卡
    if checkInDisplay then
        layer:showDataLayer(true)
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    end

    -- 购买商品后进入相应功能
    for i=1,5 do
        if math.floor(s_LocalDatabaseManager.isBuy() / math.pow(2,i-1)) == 1 then
            if i == 1 then
                layer.friendButtonFunc()
                createDataShareMark = false
            elseif i >= 2 and i <= 5 then
                isDataShow = true 
                layer:showDataLayerByItem(5 - i)
                s_SCENE:removeAllPopups()
                createDataShareMark = false
            end
            s_LocalDatabaseManager.setBuy(0)
            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() 
        end
    end 

    -- get reward 
    local isPopup = s_SCENE.popupLayer:getChildren()
    local currentWeek = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
    local isGot = currentWeek:isGotReward(os.time())
    local wordInfo = s_LocalDatabaseManager.getAllBossInfo()
    local isGotAllWord = #wordInfo[1].wrongWordList
    --print('createDataShareMark',tostring(createDataShareMark),s_CURRENT_USER.dataDailyUsing.usingTime)
    

    -- 贝贝从上拉出的页面
    if  createDataShareMark == true and s_CURRENT_USER.dataDailyUsing.usingTime >= 60 then 
        --print('dataShareTime',s_CURRENT_USER.dataShareTime)
        if s_CURRENT_USER.dataShareTime >= 300 and share ~= nil and share then
            s_CURRENT_USER.dataShareTime = 0
            dataShare:moveDown()
        end 
    end

    --avoid bulletInBoard and reward popup exist at same time
    s_SCENE:callFuncWithDelay(0.5,function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if isGot == false and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) == false and #isPopup == 0 then
            ClickRewardBtnFunction()
        end
    end)

    -- 安卓返回键功能
    onAndroidKeyPressed(layer, function ()
        if changeView == "home" then
        --如果是主页面，调用返回键方法
            local isPopup = s_SCENE.popupLayer:getChildren()
            if viewIndex == 2 and #isPopup == 0 then
                changeViewFromSettingToHome()
            elseif isDataShow == true and #isPopup == 0 then
                changeViewFromInfoToHome()
            elseif isDataShow == false and  viewIndex == 1 and #isPopup == 0 then
                -- 弹出退出面板
                local shutDownPopup = SmallAlter.create("要和贝贝说再见了吗？")
                s_SCENE:popup(shutDownPopup)
                shutDownPopup.affirm = function ()
                    cx.CXUtils:getInstance():shutDownApp()
                end    
                shutDownPopup.close = function ()
                    s_SCENE:removeAllPopups()
                end        
            end
        else
            return
        end
    end, function ()

    end)
   
    return layer
end

-- 购买商品后自动进入信息界面
function HomeLayer:showDataLayerByItem(index)
    self:setButtonEnabled(false)
    self.dataButton:setLocalZOrder(2)
    self.dataButton:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-260)))))
    s_SCENE:callFuncWithDelay(0.3,function ()
        local PersonalInfo = require("view.PersonalInfo")
        PersonalInfo.getNotContainedInLocalDatas(function ()
            local personalInfoLayer = PersonalInfo.create(false,self,index)
            personalInfoLayer:setPosition(-s_LEFT_X,0)
            self.dataBack:addChild(personalInfoLayer,1,'PersonalInfo') 
        end)
    end)
end

-- 日常打卡后进入信息界面
function HomeLayer:showDataLayer(checkIn)
    self.dataButton:setLocalZOrder(2)
    self.dataButton:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-260)))))
    s_SCENE:callFuncWithDelay(0.3,function ()
        local PersonalInfo = require("view.PersonalInfo")
        PersonalInfo.getNotContainedInLocalDatas(function ()
            local personalInfoLayer = PersonalInfo.create(checkIn,self)
            personalInfoLayer:setPosition(-s_LEFT_X,0)
            self.dataBack:addChild(personalInfoLayer,1,'PersonalInfo') 
        end)
    end)
end

function HomeLayer:hideDataLayer()
    self.button_enter.animation()
    local action1 = cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, 0))
    local action2 = cc.CallFunc:create(function()
        self.dataButton:setLocalZOrder(1)
        self.dataBack:removeChildByName('PersonalInfo')
    end)
    self.dataButton:runAction(cc.Sequence:create(action1, action2))
end

function HomeLayer:setButtonEnabled(enabled)
    self.button_friend:setEnabled(enabled)
    self.button_shop:setEnabled(enabled)
    self.button_main:setEnabled(enabled)
    self.button_sound:setEnabled(enabled)
    self.button_enter:setEnabled(enabled)
    self.button_reward:setEnabled(enabled)
    self.dataShare:setEnabled(enabled)
end

function HomeLayer:showShareCheckIn()
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_share)
    local Share = require('view.share.ShareCheckIn')
    local shareLayer = Share.create(self)
    shareLayer:setPosition(0,-s_DESIGN_HEIGHT)
    local move = cc.MoveTo:create(0.3,cc.p(0,0))
    shareLayer:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),move,cc.CallFunc:create(function ()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end,{})))
    self:addChild(shareLayer,2)
end

function HomeLayer:showDataShare()
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_king)
    self.dataShare.moveUp = function ()
        if s_CURRENT_USER.newTutorialStep == s_newtutorial_over then
            local CongratulationPopup = require("view.newstudy.CongratulationPopup").create()
            s_SCENE:popup(CongratulationPopup)
        end
    end
    if s_CURRENT_USER.dataShareTime >= 300 then
        s_CURRENT_USER.dataShareTime = 0
        self.dataShare:moveDown()
    end
end

return HomeLayer
