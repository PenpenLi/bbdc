require("common.global")

local BigAlter      = require("view.alter.BigAlter")
local SmallAlter    = require("view.alter.SmallAlter")
local ImproveInfoNode     = require("view.home.ImproveInfoNode")

local ImproveInfo = {}

local showLogin = nil
local showRegister = nil

local back_login = nil
local back_register = nil

local main = nil
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

ImproveInfoLayerType_UpdateNamePwd_FROM_HOME_LAYER  = 'FROM_HOME_LAYER'
ImproveInfoLayerType_UpdateNamePwd_FROM_INTRO_LAYER = 'FROM_INTRO_LAYER'
ImproveInfoLayerType_UpdateNamePwd_FROM_FRIEND_LAYER = 'FROM_FRIEND_LAYER'

local function closeAnimation()
    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3))
    local action2 = cc.EaseBackIn:create(action1)
    local action3 = cc.CallFunc:create(function()
        s_SCENE:removeAllPopups()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    back_login:runAction(cc.Sequence:create(action2,action3))
end

function ImproveInfo.create(layerType)
    main = cc.Layer:create()

    main.layerType = layerType

    main.close = function()
    end

    back_login = nil    
    back_register = nil

    showLogin()

    local onTouchBegan = function(touch, event)
        --s_logd("touch began on block layer")
        return true
    end
    
    local onTouchEnded = function(touch, event)
        local location = main:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back_login:getBoundingBox(),location) then
           closeAnimation()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end


showLogin = function()
    if back_login then
        local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
        local action2 = cc.EaseBackOut:create(action1)
        back_login:runAction(action2)
        return
    end

    back_login = cc.Sprite:create("image/login/background_white_login.png")
    back_login:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3) 
    main:addChild(back_login)

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back_login:runAction(action2)

    local back_width = back_login:getContentSize().width
    local back_height = back_login:getContentSize().height


    local label1 = cc.Label:createWithSystemFont("游客信息完善","",40)
    label1:setColor(cc.c4b(115,197,243,255))
    label1:setPosition(back_width/2,680)
    back_login:addChild(label1)

    local label2 = cc.Label:createWithSystemFont("注：您的学习进度不会丢失","",24)
    label2:setColor(cc.c4b(100,100,100,255))
    label2:setPosition(back_width/2,640)
    back_login:addChild(label2)

    local username = ImproveInfoNode.create("username")
    username:setPosition(back_width/2, 550)
    back_login:addChild(username)

    local password = ImproveInfoNode.create("password")
    password:setPosition(back_width/2, 450)
    back_login:addChild(password)

    local submit_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then          
            cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)   

            -- button sound
            playSound(s_sound_buttonEffect)
            
        elseif eventType == ccui.TouchEventType.ended then
            
            if validateUsername(username.textField:getString()) == false then
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__USERNAME_ERROR))
                return
            end
            if validatePassword(password.textField:getString()) == false then
                s_TIPS_LAYER:showSmallWithOneButton(s_DataManager.getTextWithIndex(TEXT__PWD_ERROR))
                return
            end
            
            
            local updateUserNameAndPassword = function (callback)
                s_UserBaseServer.updateUsernameAndPassword(
                    username.textField:getString(), 
                    password.textField:getString(), 
                    function(username, password, errordescription, errorcode )  
                        AnalyticsAccountBind()                      
                        if errordescription then                  
                            s_TIPS_LAYER:showSmallWithOneButton(errordescription)
                            hideProgressHUD(true)
                        else        
                            main.close()     
                            AnalyticsImproveInfo()
                            hideProgressHUD(true)
                            if callback ~= nil then callback() end               
                        end     
                        
                    end
                )
            end

            showProgressHUD('', true)
            
            if main.layerType == ImproveInfoLayerType_UpdateNamePwd_FROM_HOME_LAYER
                or main.layerType == ImproveInfoLayerType_UpdateNamePwd_FROM_FRIEND_LAYER then
                updateUserNameAndPassword()
            else
                local tmpUser = DataUser.create()
                local hasAccount = s_LocalDatabaseManager.getLastLogInUser(tmpUser, USER_TYPE_ALL)
                s_UserBaseServer.logIn(tmpUser.username, tmpUser.password, function (userdata, errordescription, errorcode)
                    if errordescription ~= nil then
                        s_TIPS_LAYER:showSmallWithOneButton(errordescription)
                        hideProgressHUD(true)
                    else
                        updateUserNameAndPassword(function ()
                            s_O2OController.logInOnline(s_CURRENT_USER.username, s_CURRENT_USER.password)
                        end)
                    end
                end)
            end

        end
    end

    local submit = ccui.Button:create("image/login/sl_button_confirm.png","image/login/sl_button_confirm.png","")
    submit:setPosition(back_width/2, 350)
    submit:addTouchEventListener(submit_clicked)
    back_login:addChild(submit)

    local label_name = cc.Label:createWithSystemFont("完善信息","",30)
    label_name:setColor(cc.c4b(255,255,255,255))
    label_name:setPosition(submit:getContentSize().width/2, submit:getContentSize().height/2)
    submit:addChild(label_name)


    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)   
            -- button sound
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            closeAnimation()
        end
    end
    local button_close = ccui.Button:create("image/button/button_close.png")
    button_close:setPosition(back_width-30,back_height-10)
    button_close:addTouchEventListener(button_close_clicked)
    back_login:addChild(button_close)

    onAndroidKeyPressed(main, function ()
        closeAnimation()
    end, function ()

    end)
end


return ImproveInfo







