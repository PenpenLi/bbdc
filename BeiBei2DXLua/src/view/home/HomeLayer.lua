require("cocos.init")
require("common.global")

local AlterI = require("view.alter.AlterI")
local ImproveInfo = require("view.home.ImproveInfo")
local MissionProgress = require("view.home.MissionProgressLayer")
local OfflineTipHome = require("view.offlinetip.OfflineTipForHome")
local OfflineTipFriend = require("view.offlinetip.OfflineTipForFriend")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)

local FRIEND_LOCKED = 0
local SHOP_LOCKED = 0
local REWARD_LOCKED = 0
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local list = {}

function HomeLayer.create(share) 
    -- s_CURRENT_USER:addBeans(10000)
    -- if s_CURRENT_USER:getBeans() < 1 then
    --     s_CURRENT_USER:addBeans(10000)
    --     saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
    -- end

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

    -- print("totalStudyWordNum : "..totalStudyWordNum)
    -- print("totalGraspWordNum : "..totalGraspWordNum)
    -- print("totalStudyDayNum : "..totalStudyDayNum)

    -- data begin
    local bookName          = s_DataManager.books[s_CURRENT_USER.bookKey].name
    local bookWordCount     = s_DataManager.books[s_CURRENT_USER.bookKey].words
    -- data end

    local username = "游客"
    local logo_name = {"head","book","feedback","information","logout"}
    local label_name = {username,"选择书籍","用户反馈","完善个人信息","登出游戏"}

    s_SCENE.touchEventBlockLayer.unlockTouch()
    local layer = HomeLayer.new()
    
    local offset = 500
    local viewIndex = 1

    local backColor = cc.LayerColor:create(cc.c4b(211,239,254,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    local top = cc.Sprite:create('image/homescene/home_page_bg_top.png')
    top:setAnchorPoint(0.5,1)
    top:setPosition(0.5 * backColor:getContentSize().width,s_DESIGN_HEIGHT)
    backColor:addChild(top)
    
    local been_number_back = cc.Sprite:create("image/bean/beanNumber.png")
    been_number_back:setPosition(bigWidth-100, s_DESIGN_HEIGHT-50)
    backColor:addChild(been_number_back)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width * 0.65 , been_number_back:getContentSize().height/2)
    been_number_back:addChild(been_number)

    local function updateBean(delta)
        been_number:setString(s_CURRENT_USER:getBeans())
    end

    been_number:scheduleUpdateWithPriorityLua(updateBean,0)
    
    local setting_back
    
    --add offline


    local online = s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()
--    online = false
    local offlineTipHome = OfflineTipHome.create()
    local offlineTipFriend = OfflineTipFriend.create()

    layer:addChild(offlineTipHome,2)
    layer:addChild(offlineTipFriend,2) 

    local mission_progress
    if share ~= nil and share then
        mission_progress = MissionProgress.create(true)
    else
        mission_progress = MissionProgress.create()
        mission_progress.animation()
    end
    backColor:addChild(mission_progress,1,'mission_progress')
    local downloadSoundButton = require("view.home.DownloadSoundButton").create(top)

    local name = cc.Label:createWithSystemFont('贝贝单词','',50)
    name:setPosition(bigWidth/2, s_DESIGN_HEIGHT-85)
    backColor:addChild(name)

    
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
    
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            
        elseif eventType == ccui.TouchEventType.ended then
        
            if online == false then
                offlineTipHome.setFalse()
                offlineTipFriend.setFalse()
            end
            
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
       
                mission_progress.stopListener = true
            
                viewIndex = 2
            
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
                
                --offline tip
                
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                
                mission_progress.stopListener = false
                
                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
            --s_SCENE:checkInAnimation()
        end
    end

    local button_main = ccui.Button:create("image/homescene/home_page_function_bg1.png",'',"")
    button_main:setScale9Enabled(true)
    button_main:setPosition(bigWidth / 2 - 166, 200)
    button_main:setRotation(180)
    button_main:addTouchEventListener(button_left_clicked)
    backColor:addChild(button_main)

    local icon_main = cc.Sprite:create('image/homescene/home_page_setting.png')
    icon_main:setPosition(button_main:getContentSize().width / 2,button_main:getContentSize().height / 2)
    button_main:addChild(icon_main)
    
    layer:addShopButton(backColor)
--    layer:addFriendButton(backColor)  
    
    local button_reward_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
            
        elseif eventType == ccui.TouchEventType.ended then

            local Loginreward = require("view.loginreward.LoginRewardPopup")
            local loginreward = Loginreward:create()
            s_SCENE:popup(loginreward)         
            
        end
    end

    

    local button_reward
    local icon_reward

    if REWARD_LOCKED == 0 then
        button_reward = ccui.Button:create("image/homescene/home_page_function_bg1.png","","")
        button_reward:setPosition(bigWidth / 2 + 166, 200)
        icon_reward = cc.Sprite:create('image/homescene/home_page_medal.png')
    else
        button_reward = ccui.Button:create("image/homescene/home_page_function_locked_bg2.png","","")
        button_reward:setPosition(bigWidth / 2 + 166, 200)
        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover2.png')
        cover:setPosition(button_reward:getContentSize().width / 2,button_reward:getContentSize().height / 2)
        button_reward:addChild(cover)
        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
        lock:setAnchorPoint(1,0)
        lock:setPosition(button_reward:getContentSize().width,button_reward:getContentSize().height * 0)
        button_reward:addChild(lock)
        icon_reward = cc.Sprite:create('image/homescene/home_page_medal_locked.png')
    end
    
    --button_reward = ccui.Button:create("image/homescene/home_page_function_bg1.png","","")
    button_reward:setScale9Enabled(true)
    --button_reward:setPosition(bigWidth / 2 + 166, 200)
    button_reward:addTouchEventListener(button_reward_clicked)
    backColor:addChild(button_reward)   
    

    --icon_reward = cc.Sprite:create('image/homescene/home_page_medal.png')
    icon_reward:setPosition(button_reward:getContentSize().width / 2,button_reward:getContentSize().height / 2)
    button_reward:addChild(icon_reward)


    local button_data
    local data_back
    local isDataShow = false

    button_data = cc.Sprite:create("image/homescene/main_bottom.png")
    button_data:setAnchorPoint(0.5,0)
    button_data:setPosition(bigWidth/2, 0)
    --button_data:addTouchEventListener(button_data_clicked)
    backColor:addChild(button_data)
    layer.dataButton = button_data
    
    data_back = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT - 280)  
    data_back:setAnchorPoint(0.5,1)
    data_back:ignoreAnchorPointForPosition(false)  
    data_back:setPosition(button_data:getContentSize().width/2, 0)
    button_data:addChild(data_back,2)
    layer.dataBack = data_back
    
    local data_name = cc.Label:createWithSystemFont("数据","",28)
    data_name:setColor(cc.c4b(0,150,210,255))
    data_name:setPosition(button_data:getContentSize().width/2+30, button_data:getContentSize().height/2-5)
    button_data:addChild(data_name,0)

    -- setting ui
    setting_back = cc.Sprite:create("image/homescene/setup_background.png")
    -- setting_back:setOpacity(0)
    setting_back:setAnchorPoint(1,0.5)
    setting_back:setPosition(s_LEFT_X, s_DESIGN_HEIGHT/2)
    layer:addChild(setting_back)
    
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
        username = s_CURRENT_USER:getNameForDisplay()
        logo_name = {"head","book","feedback","logout"}
        label_name = {username,"选择书籍","用户反馈","登出游戏"}
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
                elseif label_name[i] == "用户反馈" then
                    if  online == false then
                        offlineTipHome.setTrue(OfflineTipForHome_Feedback)
                    else
                        local alter = AlterI.create("用户反馈")
                        alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                        layer:addChild(alter)
                    end
                elseif label_name[i] == "完善个人信息" then
                    if  online == false then
                        offlineTipHome.setTrue(OfflineTipForHome_ImproveInformation)
                    else
                        local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_HOME_LAYER)
                        improveInfo:setTag(1)
                        improveInfo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                        layer:addChild(improveInfo)

                        improveInfo.close = function()
                            layer:removeChildByTag(1)
                            if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
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
                                local sprite2 = setting_back:getChildByName("button5")  
                                if sprite2 ~= nil then sprite2:setPosition(0, s_DESIGN_HEIGHT - sprite2:getContentSize().height * (4 - 1) - 90) end
                                local sprite3 = setting_back:getChildByName("button4")                               
                                if sprite3 ~= nil then sprite3:removeFromParent() end
                            end
                        end
                    end
                elseif label_name[i] == "登出游戏" then
                    if not s_SERVER.isNetworkConnectedNow() then
                           offlineTipHome.setTrue(OfflineTipForHome_Logout)
                    else
                        -- logout
                        AnalyticsLogOut()
                        cx.CXAvos:getInstance():logOut()
                        s_LocalDatabaseManager.setLogOut(true)
                        s_LocalDatabaseManager.close()
                        s_START_FUNCTION()
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

    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            AnalyticsFriendBtn()
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            if s_CURRENT_USER:getLockFunctionState(1) == 0 then -- check is friend function unlock
                local ShopAlter = require("view.shop.ShopAlter")
                local shopAlter = ShopAlter.create(1, 'out')
                shopAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
            layer:addChild(shopAlter)
            else
                if  online == false then
                    offlineTipFriend.setTrue()
                else
                    --backColor:removeChildByName('redHint')
                    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                        --s_CorePlayManager.enterFriendLayer()
                        local FriendLayer = require("view.friend.FriendLayer") 
                        local friendLayer = FriendLayer.create()
                        layer:addChild(friendLayer)
                        friendLayer:ignoreAnchorPointForPosition(false)
                        friendLayer:setAnchorPoint(0,0.5)
                        friendLayer:setPosition(s_RIGHT_X, s_DESIGN_HEIGHT/2)
                        backColor:removeChildByName('redHint')
                        --print('remove redhint')
                        if viewIndex == 2 then
                           s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                           mission_progress.stopListener = false

                           viewIndex = 1

                           local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                           local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                           setting_back:runAction(cc.Sequence:create(action2, action3))
                        end


                        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                        local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2 - bigWidth,s_DESIGN_HEIGHT/2))
                        backColor:runAction(action1)

                        local action2 = cc.MoveTo:create(0.5, cc.p(bigWidth - bigWidth,s_DESIGN_HEIGHT/2))
                        local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                        friendLayer:runAction(cc.Sequence:create(action2, action3))

                        friendLayer.backToHome = function ()
                              s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                              local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2 ,s_DESIGN_HEIGHT/2))
                              backColor:runAction(action1)

                              local action2 = cc.MoveTo:create(0.5, cc.p(bigWidth ,s_DESIGN_HEIGHT/2))
                              local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                              friendLayer:runAction(cc.Sequence:create(action2, action3))
                        end
                    else

                        if s_CURRENT_USER.usertype == USER_TYPE_GUEST then
                            local Item_popup = require("popup/PopupModel")
                            local item_popup = Item_popup.create(Site_From_Friend_Guest)  

                            item_popup.update = function()
                                if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
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
                                    local sprite2 = setting_back:getChildByName("button5")  
                                    if sprite2 ~= nil then sprite2:setPosition(0, s_DESIGN_HEIGHT - sprite2:getContentSize().height * (4 - 1) - 90) end
                                    local sprite3 = setting_back:getChildByName("button4")                               
                                    if sprite3 ~= nil then sprite3:removeFromParent() end
                                end
                            end

                            s_SCENE:popup(item_popup)
                        else
                            local Item_popup = require("popup/PopupModel")
                            local item_popup = Item_popup.create(Site_From_Friend_Not_Enough_Level)  

                            s_SCENE:popup(item_popup)
                        end
                    end   
                end
            end
        end
    end

    local button_friend 
    local icon_friend
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST and FRIEND_LOCKED == 0 then
        button_friend = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
        button_friend:setPosition(bigWidth / 2 - 1, 200)
        icon_friend = cc.Sprite:create('image/homescene/home_page_friends.png')
    else
        button_friend = ccui.Button:create("image/homescene/home_page_function_locked_bg1.png","","")
        button_friend:setPosition(bigWidth / 2 - 0.5, 200)
        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover1.png')
        cover:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
        button_friend:addChild(cover)
        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
        lock:setAnchorPoint(1,0)
        lock:setPosition(button_friend:getContentSize().width,button_friend:getContentSize().height * 0)
        button_friend:addChild(lock)
        icon_friend = cc.Sprite:create('image/homescene/home_page_friends_locked.png')
    end
    button_friend:setScale9Enabled(true)
    button_friend:setAnchorPoint(1,0.5)
    --button_friend:setPosition(bigWidth / 2 - 1, 200)
    button_friend:addTouchEventListener(button_right_clicked)
    backColor:addChild(button_friend)   

    icon_friend:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
    button_friend:addChild(icon_friend)

    layer.button_friend = button_friend

    local function updateFriendButton(delta)
        if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST and FRIEND_LOCKED == 0 then
            -- local unlocked_button_friend = cc.Sprite:create("image/homescene/home_page_function_bg2.png")
            -- unlocked_button_friend:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
            -- local unlocked_icon_friend = cc.Sprite:create('image/homescene/home_page_friends.png')
            -- unlocked_icon_friend:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
            
            -- button_friend:addChild(unlocked_button_friend)
            -- button_friend:addChild(unlocked_icon_friend)
            -- button_friend:setPosition(bigWidth / 2 - 0.5, 200)
            -- button_friend:unscheduleUpdate()
            button_friend:removeFromParent()
            button_friend = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
            button_friend:setPosition(bigWidth / 2 - 1, 200)
            icon_friend = cc.Sprite:create('image/homescene/home_page_friends.png')
            button_friend:setScale9Enabled(true)
            button_friend:setAnchorPoint(1,0.5)
            --button_friend:setPosition(bigWidth / 2 - 1, 200)
            button_friend:addTouchEventListener(button_right_clicked)
            backColor:addChild(button_friend)   

            icon_friend:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
            button_friend:addChild(icon_friend)
            layer.button_friend = button_friend
            button_friend:unscheduleUpdate()
        end
    end
    button_friend:scheduleUpdateWithPriorityLua(updateFriendButton,0)
    s_UserBaseServer.getFolloweesOfCurrentUser( 
        function (api,result)
            s_UserBaseServer.getFollowersOfCurrentUser( 
            function (api, result)
                --print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)
                s_CURRENT_USER:getFriendsInfo()
                --print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)

                if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
                    local redHint = cc.Sprite:create('image/friend/fri_infor.png')
                    redHint:setPosition(button_friend:getPositionX() - button_friend:getContentSize().width * 0.2,button_friend:getPositionY() + button_friend:getContentSize().height * 0.4)
                    backColor:addChild(redHint)
                    redHint:setLocalZOrder(1)
                    redHint:setName('redHint')
                    --backColor:removeChildByName('redHint')
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
        
        if start_y < 0.1 * s_DESIGN_HEIGHT and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
            if now_y - moveLength > start_y and not isDataShow and viewIndex == 1 then         
                   isDataShow = true
                   layer:setButtonEnabled(false)
                   button_data:setLocalZOrder(2)
                   button_data:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280))))
                   if true then
                       local PersonalInfo = require("view.PersonalInfo")
                       PersonalInfo.getNotContainedInLocalDatas(function ()
                           local personalInfoLayer = PersonalInfo.create()
                           personalInfoLayer:setPosition(-s_LEFT_X,0)
                           data_back:addChild(personalInfoLayer,1,'PersonalInfo') 
                       end)
                   else
                       local Item_popup = require("popup/PopupModel")
                       local item_popup = Item_popup.create(Site_From_Information)  
                       s_SCENE:popup(item_popup)
                   end 
                   return
            end
            
        end
        if start_y > s_DESIGN_HEIGHT - 280 and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
            if now_y + moveLength < start_y and isDataShow and viewIndex == 1 then
                isDataShow = false
                layer:setButtonEnabled(true)
                local action1 = cc.MoveTo:create(0.3,cc.p(bigWidth/2, 0))
                local action2 = cc.CallFunc:create(function()
                   button_data:setLocalZOrder(0)
                   data_back:removeChildByName('PersonalInfo')
                end)
                button_data:runAction(cc.Sequence:create(action1, action2))
                return
            end
            
        end

        if now_x + moveLength < start_x and not isDataShow then
            if viewIndex == 2 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                mission_progress.stopListener = false
                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end

    end

    local onTouchEnded = function(touch,event)

        local location = layer:convertToNodeSpace(touch:getLocation())
        if not isDataShow then
            if math.abs(location.y - start_y) > 10 or math.abs(location.x - start_x) > 10 then
                return
            elseif viewIndex == 1 and location.y < 0.1 * s_DESIGN_HEIGHT then
                isDataShow = true
                   layer:setButtonEnabled(false)
                   button_data:setLocalZOrder(2)
                   button_data:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280))))
                   if true then

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
                   else
                       local Item_popup = require("popup/PopupModel")
                       local item_popup = Item_popup.create(Site_From_Information)  
                       s_SCENE:popup(item_popup)
                   end 
            end

        elseif location.y >  s_DESIGN_HEIGHT-280 and (math.abs(location.y - start_y) < 10 and math.abs(location.x - start_x) < 10) and viewIndex == 1 then
            --print('isDataShow')
            isDataShow = false
            layer:setButtonEnabled(true)
            local action1 = cc.MoveTo:create(0.3,cc.p(bigWidth/2, 0))
            local action2 = cc.CallFunc:create(function()
               button_data:setLocalZOrder(0)
               data_back:removeChildByName('PersonalInfo')
            end)
            button_data:runAction(cc.Sequence:create(action1, action2))

        end
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    -- main pape  "First_Noel_pluto" 
    playMusic(s_sound_First_Noel_pluto,true)
    layer.button_main = button_main
    layer.button_sound = downloadSoundButton
    layer.button_enter = mission_progress
    layer.button_reward = button_reward

    return layer
end

function HomeLayer:addShopButton(backColor)
    local button_shop_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local ShopLayer = require("view.shop.ShopLayer")
            local shopLayer = ShopLayer.create()
            s_SCENE:replaceGameLayer(shopLayer)
        end
    end

    local button_shop
    local icon_shop

    if SHOP_LOCKED == 0 then
        button_shop = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
        button_shop:setPosition(bigWidth / 2 + 1, 200)
        icon_shop = cc.Sprite:create('image/homescene/home_page_store.png')
    else
        button_shop = ccui.Button:create("image/homescene/home_page_function_locked_bg1.png","","")
        button_shop:setPosition(bigWidth / 2 + 0.5, 200)
        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover1.png')
        cover:setPosition(button_shop:getContentSize().width / 2,button_shop:getContentSize().height / 2)
        button_shop:addChild(cover)
        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
        lock:setAnchorPoint(1,0)
        lock:setPosition(button_friend:getContentSize().width,button_friend:getContentSize().height * 0)
        button_shop:addChild(lock)
        icon_shop = cc.Sprite:create('image/homescene/home_page_store_locked.png')
    end

    button_shop:setScale9Enabled(true)
    button_shop:setAnchorPoint(0,0.5)
    --button_shop:setPosition(bigWidth / 2 + 1, 200)

    icon_shop:setPosition(button_shop:getContentSize().width / 2,button_shop:getContentSize().height / 2)
    button_shop:addChild(icon_shop)

    button_shop:addTouchEventListener(button_shop_clicked)
    backColor:addChild(button_shop) 
    self.button_shop = button_shop
end

--function HomeLayer:addFriendButton(backColor)
--    local button_right_clicked = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            AnalyticsFriendBtn()
--            playSound(s_sound_buttonEffect)
--        elseif eventType == ccui.TouchEventType.ended then
--            if s_CURRENT_USER:getLockFunctionState(1) == 0 then -- check is friend function unlock
--                local ShopAlter = require("view.shop.ShopAlter")
--                local shopAlter = ShopAlter.create(1, 'out')
--                shopAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--                self:addChild(shopAlter)
--            else
--                if  online == false then
--                    offlineTipFriend.setTrue()
--                else
--                    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
--                        s_CorePlayManager.enterFriendLayer()
--                    else
--    
--                        if s_CURRENT_USER.usertype == USER_TYPE_GUEST then
--                            local Item_popup = require("popup/PopupModel")
--                            local item_popup = Item_popup.create(Site_From_Friend_Guest)  
--    
--                            item_popup.update = function()
--                                if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
--                                    list[1].label:setString(s_CURRENT_USER.username)
--                                    list[5].button_back:setPosition(0, s_DESIGN_HEIGHT - list[5].button_back:getContentSize().height * (4 - 1) - 20)
--                                    if list[4].button_back ~= nil then list[4].button_back:removeFromParent() end
--                                end
--                            end
--    
--                            s_SCENE:popup(item_popup)
--                        else
--                            local Item_popup = require("popup/PopupModel")
--                            local item_popup = Item_popup.create(Site_From_Friend_Not_Enough_Level)  
--    
--                            s_SCENE:popup(item_popup)
--                        end
--                    end   
--                end
--            end
--        end
--    end
--    
--    local button_friend 
--    local icon_friend
--    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST and FRIEND_LOCKED == 0 then
--        button_friend = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
--        button_friend:setPosition(bigWidth / 2 - 1, 200)
--        icon_friend = cc.Sprite:create('image/homescene/home_page_friends.png')
--    else
--        button_friend = ccui.Button:create("image/homescene/home_page_function_locked_bg1.png","","")
--        button_friend:setPosition(bigWidth / 2 - 0.5, 200)
--        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover1.png')
--        cover:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
--        button_friend:addChild(cover)
--        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
--        lock:setAnchorPoint(1,0)
--        lock:setPosition(button_friend:getContentSize().width,button_friend:getContentSize().height * 0)
--        button_friend:addChild(lock)
--        icon_friend = cc.Sprite:create('image/homescene/home_page_friends_locked.png')
--    end
--    button_friend:setScale9Enabled(true)
--    button_friend:setAnchorPoint(1,0.5)
--    --button_friend:setPosition(bigWidth / 2 - 1, 200)
--    button_friend:addTouchEventListener(button_right_clicked)
--    backColor:addChild(button_friend)   
--
--    icon_friend:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
--    button_friend:addChild(icon_friend)
--
--    self.button_friend = button_friend
--
--    s_UserBaseServer.getFollowersAndFolloweesOfCurrentUser( 
--        function (api, result)
--            print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)
--            s_CURRENT_USER:getFriendsInfo()
--            print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)
--
--            if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
--                local redHint = cc.Sprite:create('image/friend/fri_infor.png')
--                redHint:setPosition(button_friend:getContentSize().width * 0.8,button_friend:getContentSize().height * 0.9)
--                button_friend:addChild(redHint)
--               
--                local num = cc.Label:createWithSystemFont(string.format('%d',s_CURRENT_USER.fansCount - s_CURRENT_USER.seenFansCount),'',28)
--                num:setPosition(redHint:getContentSize().width / 2,redHint:getContentSize().height / 2)
--                redHint:addChild(num)
--            end
--        end,
--        function (api, code, message, description)
--        end
--    )
--
--end

function HomeLayer:showDataLayer(checkIn)
    self.dataButton:setLocalZOrder(2)
    self.dataButton:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-280)))))
    if true then
        local PersonalInfo = require("view.PersonalInfo")
        PersonalInfo.getNotContainedInLocalDatas(function ()
            local personalInfoLayer = PersonalInfo.create(true)
            personalInfoLayer:setPosition(-s_LEFT_X,0)
            self.dataBack:addChild(personalInfoLayer,1,'PersonalInfo') 
        end)
        
    else
        local Item_popup = require("popup/PopupModel")
        local item_popup = Item_popup.create(Site_From_Information)  
        s_SCENE:popup(item_popup)
    end 
end

function HomeLayer:hideDataLayer()
    self.button_enter.animation()
    local action1 = cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, 0))
    local action2 = cc.CallFunc:create(function()
        self.dataButton:setLocalZOrder(0)
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

end

return HomeLayer
