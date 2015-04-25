require("cocos.init")
require("common.global")

local ShareCheckIn = class('ShareCheckIn',function ()
	return cc.Layer:create()
end)

function ShareCheckIn.create(homelayer)
	local layer = ShareCheckIn.new()
	layer.homelayer = homelayer
	return layer
end

function ShareCheckIn:ctor()
	AnalyticsEnterShare()
	local background = cc.ProgressTimer:create(cc.Sprite:create('image/share/share_background.png'))
	--local background = cc.Sprite:create('image/share/share_background.png')
	background:setAnchorPoint(0.5,1)
	background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT)
	self:addChild(background)
	background:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	background:setMidpoint(cc.p(0.5, 0))
	background:setBarChangeRate(cc.p(1, 0))
	background:setPercentage((s_RIGHT_X - s_LEFT_X) / background:getContentSize().width * 100)
	self.background = background

	local label = cc.Label:createWithSystemFont('发现一个好玩的软件贝贝','',32)
	label:setColor(cc.c3b(254,241,99))
	label:setPosition(background:getContentSize().width / 2, s_DESIGN_HEIGHT * 7 / 8)
	background:addChild(label)

    local labelx = cc.Label:createWithSystemFont('背单词，根本停不下来','',32)
    labelx:setColor(cc.c3b(254,241,99))
    labelx:setPosition(background:getContentSize().width / 2, s_DESIGN_HEIGHT * 6.3 / 8)
    background:addChild(labelx)

	-- local label2 = cc.Label:createWithSystemFont('今日搞定  ','',32)
	-- label2:setAnchorPoint(0.5,0)
	-- label2:setColor(cc.c3b(254,241,99))
	-- background:addChild(label2)
	-- local length2 = label2:getContentSize().width

	-- local label3 = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getStudyWordsNum(os.date('%x',os.time())),'',64)
	-- label3:setAnchorPoint(0.5,0.2)
	-- label3:setColor(cc.c3b(254,108,0))
	-- background:addChild(label3)

	-- local label4 = cc.Label:createWithSystemFont('  个单词','',32)
	-- label4:setAnchorPoint(0.5,0)
	-- label4:setColor(cc.c3b(254,241,99))
	-- background:addChild(label4)

	-- local length2 = label2:getContentSize().width
	-- local length3 = label3:getContentSize().width
	-- local length4 = label4:getContentSize().width
	-- label2:setPosition(background:getContentSize().width / 2 - (length3 + length4) / 2,s_DESIGN_HEIGHT * 6.3 / 8)
	-- label3:setPosition(background:getContentSize().width / 2 + (length2 - length4) / 2,s_DESIGN_HEIGHT * 6.3 / 8)
	-- label4:setPosition(background:getContentSize().width / 2 + (length3 + length2) / 2,s_DESIGN_HEIGHT * 6.3 / 8)

	local close_button = ccui.Button:create('image/share/share_close_before_sharing.png')
	close_button:setScale9Enabled(true)
	--close_button:setScale(0.9)
	close_button:setAnchorPoint(1,1)
	close_button:setPosition(s_RIGHT_X * 0.99,s_DESIGN_HEIGHT * 0.99)
	self:addChild(close_button)
	self.close_button = close_button

	local function closeAnimation()
	    local remove = cc.CallFunc:create(function ()
	    	self.homelayer:showDataShare()
			self:removeFromParent()
		end,{})
		local move = cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT))
		self:runAction(cc.Sequence:create(move,remove))
	end

	local function close(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
           closeAnimation()
		end
	end

	close_button:addTouchEventListener(close)

	local share_button = ccui.Button:create('image/share/share_normal.png')
	share_button:setScale9Enabled(true)
	share_button:setTitleText("分 享")
    share_button:setTitleColor(cc.c3b(157,100,0))
    share_button:setTitleFontSize(36)
	share_button:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 8)
	self:addChild(share_button)
	self.share_button = share_button

	local icon = cc.Sprite:create('image/share/share_bottom_icon.png')
	icon:setPosition(background:getContentSize().width / 2,s_DESIGN_HEIGHT * 1 / 8)
	background:addChild(icon)
	icon:setVisible(false)
	self.icon = icon

	local label = cc.Label:createWithSystemFont('贝贝单词','',20)
	label:setPosition(0.5 * icon:getContentSize().width, - 0.25 * icon:getContentSize().height)
	label:setColor(cc.c3b(127,57,0))
	icon:addChild(label)

	local target = cc.RenderTexture:create(s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    target:retain()
    target:setPosition(cc.p(background:getContentSize().width / 2 + s_LEFT_X, s_DESIGN_HEIGHT / 2))
    self:addChild(target, -1)

	local function share(sender,eventType)
	    if eventType == ccui.TouchEventType.began then
        	icon:setVisible(true)
        	background:setPosition(s_DESIGN_WIDTH / 2 - s_LEFT_X,s_DESIGN_HEIGHT)
            target:begin()
            background:visit()
            target:endToLua()
            icon:setVisible(false)
            background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT)
            target:setVisible(false)
        end
		if eventType == ccui.TouchEventType.ended then
			AnalyticsButtonToShare()

			sender:setVisible(false)
			close_button:setVisible(false)
			background:runAction(cc.ScaleTo:create(0.3,0.78))

			local black = cc.LayerColor:create(cc.c4b(0,0,0,128),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
			black:ignoreAnchorPointForPosition(false)
			black:setAnchorPoint(0.5,0)
			black:setPosition(s_DESIGN_WIDTH / 2,0)
			self:addChild(black,-1)

			local ShareBottom = require('view.share.ShareBottom')
			local shareBottomLayer = ShareBottom.create(target)
			self:addChild(shareBottomLayer)

		end
	end

	-- create a render texture, this is what we are going to draw into
    

	share_button:addTouchEventListener(share)

	local onTouchBegan = function(touch, event)
        return true
    end    
    self.isOtherAlter = false
    
    local onTouchMoved = function(touch, event)
    end
    
    local onTouchEnded = function(touch, event)
    end
    
    self.listener = cc.EventListenerTouchOneByOne:create()
    
    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
    self.listener:setSwallowTouches(true)

    onAndroidKeyPressed(self, function ()
        closeAnimation()
    end, function ()

    end)

end

function ShareCheckIn:getBackground()
	return self.background
end

function ShareCheckIn:getIcon()
	return self.icon
end

function ShareCheckIn:shareEnd()
	local scale = cc.ScaleTo:create(0.3,1)
	local recover = cc.CallFunc:create(function ()
		self.close_button:setVisible(true)
		self.share_button:setVisible(true)
	end,{})
	self.background:runAction(cc.Sequence:create(scale,recover))

end

return ShareCheckIn
