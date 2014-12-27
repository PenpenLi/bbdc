require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local FriendLayer = class("FriendLayer", function()
    return cc.Layer:create()
end)

function FriendLayer.create()
   local layer = FriendLayer.new()
   return layer 
end

function FriendLayer:ctor()
    

    local back = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,0.5 * s_DESIGN_HEIGHT)
    self:addChild(back)
    local topline = cc.LayerColor:create(cc.c4b(98,113,121,255),s_RIGHT_X - s_LEFT_X,87)
    topline:ignoreAnchorPointForPosition(false)
    topline:setAnchorPoint(0.5,0.5)
    topline:setPosition(0.5 * s_DESIGN_WIDTH,0.89 * s_DESIGN_HEIGHT + 87)
    self:addChild(topline)
    
    local usrname = cc.Label:createWithSystemFont(s_CURRENT_USER.username,'',32)
    usrname:setAnchorPoint(0,0.5)
    usrname:setPosition(0.2 * topline:getContentSize().width,0.5 * topline:getContentSize().height)
    topline:addChild(usrname)
    
    local backBtn = ccui.Button:create('image/friend/button_back.png','','')
    backBtn:setScale9Enabled(true)
    backBtn:setAnchorPoint(0,0.5)
    backBtn:setPosition(0.05 * (s_RIGHT_X - s_LEFT_X),0.5 * topline:getContentSize().height)
    topline:addChild(backBtn)
    
    local function onBack(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        
            s_CURRENT_USER.seenFansCount = s_CURRENT_USER.fansCount
            s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER,
                function(api,result)
                    local HomeLayer = require('view.home.HomeLayer')
                    local homeLayer = HomeLayer.create()
                    s_SCENE:replaceGameLayer(homeLayer)
                end,
                function(api, code, message, description)
                    local HomeLayer = require('view.home.HomeLayer')
                    local homeLayer = HomeLayer.create()
                    s_SCENE:replaceGameLayer(homeLayer)
                end)
            
        end
    end
    backBtn:addTouchEventListener(onBack)
    
    local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
    
    local menu = cc.Menu:create()
    menu:setPosition(0,0.89 * s_DESIGN_HEIGHT)
    self:addChild(menu)
    self.friendListButton = cc.MenuItemImage:create('image/friend/fri_titleback_select.png','image/friend/fri_titleback_select.png','')
    self.friendListButton:setScaleX(scale)
    self.friendListButton:setAnchorPoint(0,0.5)
    self.friendListButton:setPosition(s_LEFT_X,0)
    local title1 = cc.Label:createWithSystemFont('好友列表','',28)
    title1:setScaleX(1 / scale)
    title1:setPosition(self.friendListButton:getContentSize().width / 2,self.friendListButton:getContentSize().height / 2)
    self.friendListButton:addChild(title1,1)
    menu:addChild(self.friendListButton)
    self.friendSearchButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    self.friendSearchButton:setScaleX(scale)
    self.friendSearchButton:setPosition(s_DESIGN_WIDTH / 2,0)
    local title2 = cc.Label:createWithSystemFont('查找好友','',28)
    title2:setScaleX(1 / scale)
    title2:setPosition(self.friendSearchButton:getContentSize().width / 2,self.friendSearchButton:getContentSize().height / 2)
    self.friendSearchButton:addChild(title2,1)
    menu:addChild(self.friendSearchButton)
    self.friendRequestButton = cc.MenuItemImage:create('image/friend/fri_titleback_unselect.png','image/friend/fri_titleback_unselect.png','')
    self.friendRequestButton:setScaleX(scale)
    self.friendRequestButton:setAnchorPoint(1,0.5)
    self.friendRequestButton:setPosition(s_RIGHT_X,0)
    local title3 = cc.Label:createWithSystemFont('好友请求','',28)
    title3:setScaleX(1 / scale)
    title3:setPosition(self.friendRequestButton:getContentSize().width / 2,self.friendRequestButton:getContentSize().height / 2)
    self.friendRequestButton:addChild(title3,1)
    menu:addChild(self.friendRequestButton)
    s_CURRENT_USER:getFriendsInfo()
    local redHint = nil
    if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
        redHint = cc.Sprite:create('image/friend/fri_infor.png')
        redHint:setPosition(self.friendRequestButton:getContentSize().width * 0.8,self.friendRequestButton:getContentSize().height * 0.9)
        redHint:setScaleX(1 / scale)
        self.friendRequestButton:addChild(redHint,100)
        local num = cc.Label:createWithSystemFont(string.format('%d',s_CURRENT_USER.fansCount - s_CURRENT_USER.seenFansCount),'',28)
        num:setPosition(redHint:getContentSize().width / 2,redHint:getContentSize().height / 2)
        redHint:addChild(num)
    end
    
    local list = require('view.friend.FriendList')
    local layer = list.create()
    layer:setAnchorPoint(0.5,0)
    self:addChild(layer,1,'list')
    
    local search = require('view.friend.FriendSearch')
    local searchlayer = search.create()
    searchlayer:setAnchorPoint(0.5,0)
    self:addChild(searchlayer,0,'search')
    
    local function onFriendList(sender)
        self.friendListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.friendRequestButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendSearchButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        --self:removeChildByName('search',true)
        self:removeChildByName('request',true)
        if not self:getChildByName('list') then
            local list = require('view.friend.FriendList')
            local layer = list.create()
            layer:setAnchorPoint(0.5,0)
            self:addChild(layer,1,'list')
            searchlayer:setLocalZOrder(-1)
        end
    end
    
    local function onFriendSearch(sender)
        self.friendListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendRequestButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendSearchButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self:removeChildByName('list',true)
        self:removeChildByName('request',true)
        searchlayer:setLocalZOrder(0)
    end
    
    local function onFriendRequest(sender)
        if redHint then
            redHint:setVisible(false)
        end
        self.friendListButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        self.friendRequestButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_select.png',cc.rect(0,0,213,87)))
        self.friendSearchButton:setNormalSpriteFrame(cc.SpriteFrame:create('image/friend/fri_titleback_unselect.png',cc.rect(0,0,213,87)))
        --self:removeChildByName('search',true)
        self:removeChildByName('list',true)
        if not self:getChildByName('request') then
            local request = require('view.friend.FriendRequest')
            local layer = request.create()
            layer:setAnchorPoint(0.5,0)
            self:addChild(layer,1,'request')
            searchlayer:setLocalZOrder(-1)
        end
    end
        
    self.friendListButton:registerScriptTapHandler(onFriendList)
    self.friendSearchButton:registerScriptTapHandler(onFriendSearch)
    self.friendRequestButton:registerScriptTapHandler(onFriendRequest)
    
end

return FriendLayer