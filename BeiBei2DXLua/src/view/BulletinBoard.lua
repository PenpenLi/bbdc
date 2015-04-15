require("cocos.init")
require("common.global")

local BulletinBoard = class("BulletinBoard", function()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

ccbBulletinBoard = ccbBulletinBoard or {}

function BulletinBoard.create()
    local layer = BulletinBoard.new()
    return layer
end

local cw = 0
local ch = 0

function BulletinBoard:ctor()
    self.ccb = {}

    self.w = s_RIGHT_X - s_LEFT_X
    self.h = s_DESIGN_HEIGHT

    ccbBulletinBoard['onClose'] = self.onClose
    self.ccb['bullet_in_board'] = ccbBulletinBoard
    ccbBulletinBoard['Layer'] = self
    self:setContentSize(cc.size(self.w, self.h))

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/bullet_in_board.ccbi", proxy, ccbBulletinBoard, self.ccb)
    cw = node:getContentSize().width
    ch = node:getContentSize().height
    node:setAnchorPoint(cc.p(0.5, 0.5))
    node:setPosition(cc.p(s_LEFT_X, 0))
    self:addChild(node)

    ccbBulletinBoard['board']:setPosition(cc.p(cw / 2, ch * 1.5))
    ccbBulletinBoard['board']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.4, cc.p(cw / 2, ch * 0.5))))

    --click effect
    local menu = cc.Menu:create()
    menu:setPosition(cc.p(ccbBulletinBoard['effect']:getPosition()))
    ccbBulletinBoard['board']:addChild(menu)
    local click = cc.MenuItemImage:create('','','')
    --click:setScale(0.5)
    click:setContentSize(cc.size(40,40))
    menu:addChild(click)
    
    local function onClick(sender)
        ccbBulletinBoard['effect']:setVisible(not ccbBulletinBoard['effect']:isVisible())
        if self.index >= 0 then
            local b = math["and"](s_CURRENT_USER.bulletinBoardMask, (2 ^ self.index)) ~= 0
            if ccbBulletinBoard['effect']:isVisible() and not b then
                s_CURRENT_USER.bulletinBoardMask = s_CURRENT_USER.bulletinBoardMask + (2 ^ self.index)
            elseif not ccbBulletinBoard['effect']:isVisible() and b then
                s_CURRENT_USER.bulletinBoardMask = s_CURRENT_USER.bulletinBoardMask - (2 ^ self.index)
            end
        
            if s_CURRENT_USER.bulletinBoardMask < 0 then
                s_CURRENT_USER.bulletinBoardMask = 0
            end
        end
    end
    click:registerScriptTapHandler(onClick)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = node:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(ccbBulletinBoard['board']:getBoundingBox(),location) then
            self:onClose()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

function BulletinBoard:updateValue(index, title, content)
    self.index = index
    ccbBulletinBoard["labelTitle"]:setString(title)
    ccbBulletinBoard["labelContent"]:setString(content)
end

function BulletinBoard:onClose()
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    saveUserToServer({['bulletinBoardMask']=s_CURRENT_USER.bulletinBoardMask, ['bulletinBoardTime']=s_CURRENT_USER.bulletinBoardTime})
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(cw / 2, ch * 1.5)))
    local remove = cc.CallFunc:create(function() 
        s_SCENE:removeAllPopups()
    end,{})
    ccbBulletinBoard['board']:runAction(cc.Sequence:create(move,remove))

    local currentWeek = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]
    local isGot = currentWeek:isGotReward(os.time())

    s_SCENE:callFuncWithDelay(0.4,function()
        if isGot == false and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) == false then
            local Loginreward = require("view.loginreward.LoginRewardPopup")
            local loginreward = Loginreward:create()
            s_SCENE:popup(loginreward) 
        end
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    -- button sound
    playSound(s_sound_buttonEffect)
end

return BulletinBoard