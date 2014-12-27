require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local AlterI = require("view.alter.AlterI")
local ImproveInfo = require("view.home.ImproveInfo")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)

function judge_Whether_nil(mark)
    if mark == nil then
        return 0
    else
        return mark.isLevelUnlocked
    end
end


function HomeLayer.create()
    -- data begin
    local bookName          = s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].name
    local bookWordCount     = s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words
    local chapterIndex      = string.sub(s_CURRENT_USER.currentChapterKey,8)+1
    local chapterName       = s_DATA_MANAGER.chapters[chapterIndex].Name
    local levelIndex        = string.sub(s_CURRENT_USER.currentLevelKey,6)+1
    local levelName         = "第"..chapterIndex.."章 "..chapterName.." 第"..levelIndex.."关"
    local studyWordNum      = s_DATABASE_MGR.getStudyWordsNum(s_CURRENT_USER.bookKey)
    local graspWordNum      = s_DATABASE_MGR.getGraspWordsNum(s_CURRENT_USER.bookKey)
    local redHint = nil
    -- data end
    
    local list = {}
    local username = "游客"
    local logo_name = {"head","book","feedback","information","logout"}
    local label_name = {username,"选择书籍","用户反馈","完善个人信息","登出游戏"}

    s_SCENE.touchEventBlockLayer.unlockTouch()
    local layer = HomeLayer.new()
    
    local offset = 500
    local viewIndex = 1
    
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(211,239,254,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    local setting_back
    
    local name = cc.Sprite:create("image/homescene/title_shouye_name.png")
    name:setPosition(bigWidth/2, s_DESIGN_HEIGHT-120)
    backColor:addChild(name)
   
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            
        elseif eventType == ccui.TouchEventType.ended then
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            
                viewIndex = 2
            
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                
                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end
    end

    local button_main = ccui.Button:create("image/homescene/main_set.png","image/homescene/main_set.png","")
    button_main:setPosition((bigWidth-s_DESIGN_WIDTH)/2+50, s_DESIGN_HEIGHT-120)
    button_main:addTouchEventListener(button_left_clicked)
    backColor:addChild(button_main)
    
   
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            AnalyticsFriend()

            -- button sound
            playSound(s_sound_buttonEffect)
            
            elseif eventType == ccui.TouchEventType.ended then

            -- level 10
            local levelKey = 'level10'
            local ncee_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_NCEE, 'chapter0', levelKey)
            local cet4_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET4, 'chapter0', levelKey)
            local cet6_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET6, 'chapter0', levelKey)
            local ielts_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_IELTS, 'chapter0', levelKey)
            local toefl_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_TOEFL, 'chapter0', levelKey)
            

            if ( judge_Whether_nil(ncee_date) == 1 or judge_Whether_nil(cet4_date) == 1 or 
                judge_Whether_nil(cet6_date) == 1 or judge_Whether_nil(cet6_date) == 1 or 
                judge_Whether_nil(toefl_date)  == 1) and s_CURRENT_USER.isGuest == 0 then
--             if true then
                s_CorePlayManager.enterFriendLayer()

            else
                if s_CURRENT_USER.isGuest == 1 then
                    local Item_popup = require("popup/PopupModel")
                    local item_popup = Item_popup.create(Site_From_Friend_Guest)  
                    
                    item_popup.update = function()
                        if s_CURRENT_USER.isGuest == 0 then
                            list[1].label:setString(s_CURRENT_USER.username)
                            list[5].button_back:setPosition(0, s_DESIGN_HEIGHT - list[5].button_back:getContentSize().height * (4 - 1) - 20)
                            if list[4].button_back ~= nil then list[4].button_back:removeFromParent() end
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
    
    local button_friend = ccui.Button:create("image/homescene/main_friends.png","image/homescene/main_friends.png","")
    button_friend:setPosition((bigWidth-s_DESIGN_WIDTH)/2+s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT-120)
    button_friend:addTouchEventListener(button_right_clicked)
    backColor:addChild(button_friend)   
    s_UserBaseServer.getFolloweesOfCurrentUser( 
        function (api, result)
            s_CURRENT_USER:parseServerFolloweesData(result.results)
            s_UserBaseServer.getFollowersOfCurrentUser( 
                function (api, result)
                    s_CURRENT_USER:parseServerFollowersData(result.results)
                    print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)
                    s_CURRENT_USER:getFriendsInfo()
                    print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)

                    if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
                        redHint = cc.Sprite:create('image/friend/fri_infor.png')
                        redHint:setPosition(button_friend:getContentSize().width * 0.8,button_friend:getContentSize().height * 0.9)
                        button_friend:addChild(redHint)
                        
                        -- level 10
                        local levelKey = 'level10'
                        local ncee_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_NCEE, 'chapter0', levelKey)
                        local cet4_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET4, 'chapter0', levelKey)
                        local cet6_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET6, 'chapter0', levelKey)
                        local ielts_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_IELTS, 'chapter0', levelKey)
                        local toefl_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_TOEFL, 'chapter0', levelKey)


                        if ( judge_Whether_nil(ncee_date) == 1 or judge_Whether_nil(cet4_date) == 1 or 
                            judge_Whether_nil(cet6_date) == 1 or judge_Whether_nil(cet6_date) == 1 or 
                            judge_Whether_nil(toefl_date)  == 1) and s_CURRENT_USER.isGuest == 0 then

                            if redHint ~= nil then
                                redHint:setVisible(false)
                            end
                        else
                            if redHint ~= nil then
                                redHint:setVisible(true)
                            end
                        end
                       
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

    local book_back = sp.SkeletonAnimation:create("res/spine/book.json", "res/spine/book.atlas", 1)
    book_back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
    backColor:addChild(book_back,1)
    
    local has_study = cc.ProgressTimer:create(cc.Sprite:create("image/homescene/book_front_blue_xuexi.png"))
    has_study:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    has_study:setMidpoint(cc.p(1, 0))
    has_study:setBarChangeRate(cc.p(0, 1))
    has_study:setPosition(book_back:getContentSize().width/2+20, book_back:getContentSize().height/2+58)
    has_study:setPercentage(100 * studyWordNum / bookWordCount)
    book_back:addChild(has_study)
    
    local has_grasp = cc.ProgressTimer:create(cc.Sprite:create("image/homescene/book_front_blue_zhangwo.png"))
    has_grasp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    has_grasp:setMidpoint(cc.p(1, 0))
    has_grasp:setBarChangeRate(cc.p(0, 1))
    has_grasp:setPosition(book_back:getContentSize().width/2+20, book_back:getContentSize().height/2+58)
    has_grasp:setPercentage(100 * graspWordNum / bookWordCount)
    book_back:addChild(has_grasp)
    
    local book_back_width = book_back:getContentSize().width
    
    local label1 = cc.Label:createWithSystemFont(bookName.."词汇","",28)
    label1:setColor(cc.c4b(255,255,255,255))
    label1:setPosition(book_back_width/2, 200)
    book_back:addChild(label1)
    
    local label2 = cc.Label:createWithSystemFont(bookWordCount.."词","",20)
    label2:setColor(cc.c4b(255,255,255,255))
    label2:setPosition(book_back_width/2, 170)
    book_back:addChild(label2)
    
    local label3 = cc.Label:createWithSystemFont("学习"..studyWordNum.."词","",34)
    label3:setColor(cc.c4b(255,255,255,255))
    label3:setPosition(book_back_width/2, 60)
    book_back:addChild(label3)
    
    local label4 = cc.Label:createWithSystemFont("掌握"..graspWordNum.."词","",34)
    label4:setColor(cc.c4b(255,255,255,255))
    label4:setPosition(book_back_width/2, 0)
    book_back:addChild(label4)
    
    local label = cc.Label:createWithSystemFont(levelName,"",28)
    label:setColor(cc.c4b(0,0,0,255))
    label:setPosition(bigWidth/2, 280)
    backColor:addChild(label)
    
    local button_play_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended and viewIndex == 1 then
            AnalyticsEnterLevelLayer()
            
            showProgressHUD()
            -- button sound
            playSound(s_sound_buttonEffect)  
            s_CorePlayManager.enterLevelLayer()  
            hideProgressHUD()
        end
    end

    local button_play = ccui.Button:create("image/homescene/main_play.png","image/homescene/main_play.png","")
    button_play:setTitleText("继续闯关   》")
    button_play:setTitleFontSize(30)
    button_play:setPosition(bigWidth/2, 200)
    button_play:addTouchEventListener(button_play_clicked)
    backColor:addChild(button_play)
    if s_CURRENT_USER.tutorialStep == s_tutorial_home then
        local finger = sp.SkeletonAnimation:create('spine/yindaoye_shoudonghua_dianji.json', 'spine/yindaoye_shoudonghua_dianji.atlas',1)
        finger:addAnimation(0, 'animation', true)
        finger:setPosition(button_play:getContentSize().width/2+20,-30)
        button_play:addChild(finger,10)
        s_CURRENT_USER:setTutorialStep(s_tutorial_home+1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_home+1)
    end

    local button_data
    local isDataShow = false
    local button_data_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended and viewIndex == 1 then
            AnalyticsDataCenter()

            -- button sound
            playSound(s_sound_buttonEffect)
            
            ----todo
            --
            -- level 7
            local levelKey = 'level7'
            local ncee_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_NCEE, 'chapter0', levelKey)
            local cet4_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET4, 'chapter0', levelKey)
            local cet6_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET6, 'chapter0', levelKey)
            local ielts_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_IELTS, 'chapter0', levelKey)
            local toefl_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_TOEFL, 'chapter0', levelKey)

            if   ( judge_Whether_nil(ncee_date) == 1 or judge_Whether_nil(cet4_date) == 1 or 
                judge_Whether_nil(cet6_date) == 1 or judge_Whether_nil(cet6_date) == 1 or 
                judge_Whether_nil(toefl_date)  == 1) then

                local PersonalInfo = require("view.PersonalInfo")
                local personalInfoLayer = PersonalInfo.create()
                s_SCENE:replaceGameLayer(personalInfoLayer) 

            else

                local Item_popup = require("popup/PopupModel")
                local item_popup = Item_popup.create(Site_From_Information)  
                s_SCENE:popup(item_popup)

            end 
            
--            if isDataShow then
--                isDataShow = false
--                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, 0))
--                local action2 = cc.CallFunc:create(function()
--                    button_data:setLocalZOrder(0)
--                end)
--                button_data:runAction(cc.Sequence:create(action1, action2))
--            else
--                isDataShow = true
--                button_data:setLocalZOrder(2)
--                button_data:runAction(cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT-300)))
--            end

        end
    end

    button_data = ccui.Button:create("image/homescene/main_bottom.png","image/homescene/main_bottom.png","")
    button_data:setAnchorPoint(0.5,0)
    button_data:setPosition(bigWidth/2, 0)
    button_data:addTouchEventListener(button_data_clicked)
    backColor:addChild(button_data)
    
    local data_back = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT)  
    data_back:setAnchorPoint(0.5,1)
    data_back:ignoreAnchorPointForPosition(false)  
    data_back:setPosition(button_data:getContentSize().width/2, 0)
    button_data:addChild(data_back)
    
    local data_name = cc.Label:createWithSystemFont("数据","",28)
    data_name:setColor(cc.c4b(0,0,0,255))
    data_name:setPosition(button_data:getContentSize().width/2+30, button_data:getContentSize().height/2-5)
    button_data:addChild(data_name)

    -- setting ui
    setting_back = cc.Sprite:create("image/homescene/setup_background.png")
    setting_back:setAnchorPoint(1,0.5)
    setting_back:setPosition(s_LEFT_X, s_DESIGN_HEIGHT/2)
    layer:addChild(setting_back)
    
--    
--    local list = {}
--    local username = "游客"
--    local logo_name = {"head","book","feedback","information","logout"}
--    local label_name = {username,"选择书籍","用户反馈","完善个人信息","登出游戏"}
    if s_CURRENT_USER.isGuest == 0 then
        username = s_CURRENT_USER.username
        logo_name = {"head","book","feedback","logout"}
        label_name = {username,"选择书籍","用户反馈","登出游戏"}
    end
    for i = 1, #logo_name do
        local button_back_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                playSound(s_sound_buttonEffect)
                if label_name[i] == "选择书籍" then
                    AnalyticsChangeBook()
                    s_CorePlayManager.enterBookLayer()
                elseif label_name[i] == "用户反馈" then
                    local alter = AlterI.create("用户反馈")
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                elseif label_name[i] == "完善个人信息" then
                    local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_HOME_LAYER)
                    improveInfo:setTag(1)
                    improveInfo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(improveInfo)
                    
                    improveInfo.close = function()
                        layer:removeChildByTag(1)
                        if s_CURRENT_USER.isGuest == 0 then
                            list[1].label:setString(s_CURRENT_USER.username)
                            list[5].button_back:setPosition(0, s_DESIGN_HEIGHT - list[5].button_back:getContentSize().height * (4 - 1) - 20)
                            if list[4].button_back ~= nil then list[4].button_back:removeFromParent() end
                        end
                    end
                elseif label_name[i] == "登出游戏" then
                    -- logout
                    AnalyticsLogOut()
                    cx.CXAvos:getInstance():logOut()
                    s_DATABASE_MGR.setLogOut(true)
                    s_DATABASE_MGR.close()
                    s_START_FUNCTION()
                else
                    -- do nothing
                end
            end
        end

        local button_back = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
        button_back:setAnchorPoint(0, 1)
        button_back:setPosition(0, s_DESIGN_HEIGHT-button_back:getContentSize().height * (i - 1) - 20)
        button_back:addTouchEventListener(button_back_clicked)
        setting_back:addChild(button_back)
        
        local logo = cc.Sprite:create("image/homescene/setup_"..logo_name[i]..".png")
        logo:setPosition(button_back:getContentSize().width-offset+50, button_back:getContentSize().height/2)
        button_back:addChild(logo)
        
        local label = cc.Label:createWithSystemFont(label_name[i],"",28)
        label:setColor(cc.c4b(0,0,0,255))
        label:setAnchorPoint(0, 0.5)
        label:setPosition(button_back:getContentSize().width-offset+100, button_back:getContentSize().height/2)
        button_back:addChild(label)
        
        local split = cc.Sprite:create("image/homescene/setup_line.png")
        split:setAnchorPoint(0.5,0)
        split:setPosition(button_back:getContentSize().width/2, 0)
        button_back:addChild(split)

        local t = {}
        t.button_back = button_back
        t.logo = logo
        t.label = label
        t.split = split
        table.insert(list, t)
    end
    
    local setting_shadow = cc.Sprite:create("image/homescene/setup_shadow.png")
    setting_shadow:setAnchorPoint(1,0.5)
    setting_shadow:setPosition(setting_back:getContentSize().width, setting_back:getContentSize().height/2)
    setting_back:addChild(setting_shadow)
    
    local moveLength = 100
    local moved = false
    local start_x = nil
    local onTouchBegan = function(touch, event)
        if has_study and viewIndex == 1 then
            AnalyticsLib()

            local location_book = has_study:convertToNodeSpace(touch:getLocation())
            if cc.rectContainsPoint({x=0,y=0,width=has_study:getContentSize().width,height=has_study:getContentSize().height}, location_book) then

                --level 4
                local levelKey = 'level4'
                local ncee_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_NCEE, 'chapter0', levelKey)
                local cet4_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET4, 'chapter0', levelKey)
                local cet6_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_CET6, 'chapter0', levelKey)
                local ielts_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_IELTS, 'chapter0', levelKey)
                local toefl_date = s_CURRENT_USER:getBookChapterLevelData(s_BOOK_KEY_TOEFL, 'chapter0', levelKey)
                
                if   ( judge_Whether_nil(ncee_date) == 1 or judge_Whether_nil(cet4_date) == 1 or 
                    judge_Whether_nil(cet6_date) == 1 or judge_Whether_nil(cet6_date) == 1 or 
                    judge_Whether_nil(toefl_date)  == 1) then
                    
                    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                    -- button sound
                    playSound(s_sound_buttonEffect)

                    book_back:removeAllChildren()
                    book_back:addAnimation(0, 'animation', false)


                    local action1 = cc.DelayTime:create(1.5)
                    local action2 = cc.CallFunc:create(function()
                        s_CorePlayManager.enterWordListLayer()
                        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                    end)
                    layer:runAction(cc.Sequence:create(action1, action2))

                else

                    local Item_popup = require("popup/PopupModel")
                    local item_popup = Item_popup.create(Site_From_Book)  
                    s_SCENE:popup(item_popup)

                end 
            end
        end

        local location = layer:convertToNodeSpace(touch:getLocation())
        start_x = location.x
        moved = false
        return true
    end
    
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
    
        local location = layer:convertToNodeSpace(touch:getLocation())
        local now_x = location.x
        if now_x - moveLength > start_x then
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                viewIndex = 2

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        elseif now_x + moveLength < start_x then
            if viewIndex == 2 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    -- main pape  "First_Noel_pluto" 
    playMusic(s_sound_First_Noel_pluto,true)

    return layer
end

return HomeLayer
