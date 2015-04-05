require("cocos.init")
require("common.global")

local LEARN_TIME --= math.ceil(s_CURRENT_USER.dataDailyUsing.usingTime / 60.0)
local LEARN_INDEX --= math.ceil(LEARN_TIME * 2.5)
local LEARN_COUNT

local DataShare = class("DataShare", function ()
    return cc.Layer:create()
end)

function DataShare.create()
	local layer = DataShare.new()
	return layer
end

function DataShare:ctor()
	
	LEARN_TIME = math.floor(s_CURRENT_USER.dataDailyUsing.usingTime / 60.0)
	LEARN_INDEX = math.ceil(LEARN_TIME * 2.5)
	LEARN_COUNT = s_LocalDatabaseManager.getStudyWordsNum(os.date('%x',os.time()))
	-- LEARN_TIME = 23
	-- LEARN_INDEX = math.ceil(LEARN_TIME * 2.5)
	if LEARN_INDEX > 100 then
		LEARN_INDEX = 100
	end
	-- -- add curtain
	local curtain = cc.LayerColor:create(cc.c4b(0,0,0,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
	curtain:ignoreAnchorPointForPosition(false)
	curtain:setAnchorPoint(0.5,0.5)
	curtain:setPosition((s_RIGHT_X - s_LEFT_X) / 2,s_DESIGN_HEIGHT / 2)
	self:addChild(curtain)
	self.curtain = curtain
	self.curtain:setOpacity(0)
	-- data share UI
	local background = cc.LayerColor:create(cc.c4b(200,240,255,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT * 1.2)
	background:ignoreAnchorPointForPosition(false)
	background:setAnchorPoint(0.5,0)
	background:setPosition((s_RIGHT_X - s_LEFT_X) / 2,s_DESIGN_HEIGHT)
	self:addChild(background)
	self.background = background
	--background:runAction(cc.EaseBackOut:create(cc.MoveBy:create(0.5,cc.p(0,- s_DESIGN_HEIGHT * 5 / 6))))
	self.background = background
	-- add label
	self:addLabel(background,150)
	--add medal
	self:addMedal(background,150,true)

	--add animation

	local node = cc.Node:create()
	node:setPosition(s_DESIGN_WIDTH * 0.25 + (background:getContentSize().width - s_DESIGN_WIDTH) * 0.5,0)
	background:addChild(node,-1)

	local bangle = ccui.Button:create('image/homescene/datashare/main_interface_drop_down_share_bangle.png')
	bangle:setAnchorPoint(0.5,1)
	bangle:setPosition(0,40)
	node:addChild(bangle)
	bangle:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.4,cc.p(0,-20)),cc.MoveBy:create(0.4,cc.p(0,20)),cc.DelayTime:create(2.2))))

	local girl = sp.SkeletonAnimation:create("res/spine/girl_wave/girl_wave.json", "res/spine/girl_wave/girl_wave.atlas", 1)
    --girl:setAnchorPoint(0.9,0.7)
    girl:setPosition(-128,-350)
    girl:setScale(0.75)
    node:addChild(girl,-1)
    girl:addAnimation(0, 'animation', true)

   	local girlBtn = ccui.Button:create('image/homescene/datashare/main_interface_drop_down_share_beibei.png')
   	girlBtn:setAnchorPoint(0,0)
   	girlBtn:setScale(4 / 3)
   	girlBtn:setOpacity(0)
   	girlBtn:setPosition(0,0)
   	girl:addChild(girlBtn)

   	self.girlBtn = girlBtn
   	

	self.bangle = bangle
	self.girl = girl
	self.node = node

	local function onBangle(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:moveDown()
			
		end
	end  
	girlBtn:addTouchEventListener(onBangle)
	bangle:addTouchEventListener(onBangle)

	local button = ccui.Button:create('image/homescene/datashare/main_interface_drop_down_share_up_button.png','image/homescene/datashare/main_interface_drop_down_share_up_button_click.png')
	button:setPosition(background:getContentSize().width * 0.5,background:getContentSize().height / 12)
	background:addChild(button)
	self.close_button = button

	local function onBtnClicked(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
			girl:setPosition(-128,-350)
			--self.curtain:setOpacity(100)
			self.curtain:runAction(cc.FadeOut:create(1))
			background:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.MoveBy:create(1.0,cc.p(0,s_DESIGN_HEIGHT * 1.1))),cc.CallFunc:create(function (  )
				self:setLocalZOrder(0)
				background:runAction(cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT * 0.1)))
				girl:runAction(cc.Sequence:create(cc.JumpBy:create(0.3, cc.p(0,0), 170, 1),cc.CallFunc:create(function (  )
					s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
					bangle:setPosition(0,40)
					bangle:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.4,cc.p(0,-20)),cc.MoveBy:create(0.4,cc.p(0,20)),cc.DelayTime:create(2.2))))
					self.listener:setSwallowTouches(false)
					girl:setAnimation(0, 'animation', true)
				end,{})))
			end,{})))
		end
	end

	button:addTouchEventListener(onBtnClicked)

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
    -- self.listener:setSwallowTouches(true)

end

function DataShare:moveDown()
	-- if LEARN_TIME == 0 then
	-- 	return
	-- end
 -- print('s_CURRENT_USER.dataDailyUsing.startTime',s_CURRENT_USER.dataDailyUsing.startTime)
	--  print('s_CURRENT_USER.dataDailyUsing.usingTime',s_CURRENT_USER.dataDailyUsing.usingTime)
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	self.bangle:stopAllActions()
	self.bangle:setPosition(0,20)
	self.listener:setSwallowTouches(true)
	self.girl:setAnimation(0,'stable_girl',false)
	self.girl:runAction(cc.Sequence:create(cc.JumpBy:create(0.3, cc.p(0,100), -70, 1),cc.CallFunc:create(function (  )
		self.curtain:runAction(cc.EaseSineOut:create(cc.FadeTo:create(2,230)))
		self.node:runAction(cc.Sequence:create(cc.RotateBy:create(0.5,30),cc.RotateBy:create(1,-60),cc.RotateBy:create(0.5,30)))
		self:setLocalZOrder(1)
		self.background:runAction(cc.Sequence:create(cc.EaseSineOut:create(cc.MoveBy:create(1,cc.p(0,- s_DESIGN_HEIGHT))),cc.CallFunc:create(function (  )
			s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
		end)))
	end,{})))	
end

function DataShare:addLabel(background,offset)
	local label1 = cc.Label:createWithSystemFont('今日学习','',30)
	label1:setColor(cc.c3b(62,179,237))
	label1:setAnchorPoint(1,1)
	
	background:addChild(label1)

	local count1 = cc.Label:createWithTTF(LEARN_TIME,'font/impact.ttf',90)
	count1:setColor(cc.c3b(62,179,237))
	count1:setAnchorPoint(0.5,0)
	count1:setPosition(background:getContentSize().width / 2 + 30,s_DESIGN_HEIGHT * 5 / 6 - 153 - label1:getContentSize().height - 15 + offset)
	background:addChild(count1)

	label1:setPosition(background:getContentSize().width / 2 + 5 - count1:getContentSize().width / 2,s_DESIGN_HEIGHT * 5 / 6 - 153+ offset)

	local label2 = cc.Label:createWithSystemFont('分钟','',30)
	label2:setColor(cc.c3b(62,179,237))
	label2:setAnchorPoint(0,1)
	label2:setPosition(background:getContentSize().width / 2 + 55 + count1:getContentSize().width / 2,s_DESIGN_HEIGHT * 5 / 6 - 153+ offset)
	background:addChild(label2)

	local count2 = cc.Label:createWithTTF(LEARN_COUNT,'font/impact.ttf',60)
	count2:setColor(cc.c3b(62,179,237))
	count2:setAnchorPoint(0.5,0)
	count2:setPosition(background:getContentSize().width / 2,s_DESIGN_HEIGHT * 5 / 6 - 280 - label1:getContentSize().height - 5+ offset)
	background:addChild(count2)

	local label3 = cc.Label:createWithSystemFont('过了','',30)
	label3:setColor(cc.c3b(62,179,237))
	label3:setAnchorPoint(1,1)
	label3:setPosition(background:getContentSize().width / 2 - 25 - count2:getContentSize().width / 2,s_DESIGN_HEIGHT * 5 / 6 - 280+ offset)
	background:addChild(label3)

	local label4 = cc.Label:createWithSystemFont('单词','',30)
	label4:setColor(cc.c3b(62,179,237))
	label4:setAnchorPoint(0,1)
	label4:setPosition(background:getContentSize().width / 2 + 25 + count2:getContentSize().width / 2,s_DESIGN_HEIGHT * 5 / 6 - 280+ offset)
	background:addChild(label4)


end

function DataShare:addMedal(background,offset,forShare)
	local medal_file = 'image/homescene/datashare/main_interface_drop_down_share_medal_less_than_100.png'
	local medal_Y = s_DESIGN_HEIGHT * 5 / 6 - 444
	local count_Y 

	if LEARN_INDEX >= 60 then
		medal_file = 'image/homescene/datashare/main_interface_drop_down_share_medal_front_100.png'
		medal_Y = s_DESIGN_HEIGHT * 5 / 6 - 459
	else

	end
	local medal = cc.Sprite:create(medal_file)
	medal:setPosition(background:getContentSize().width / 2,medal_Y+ offset)
	medal:setAnchorPoint(0.5,1)
	background:addChild(medal)

	if LEARN_INDEX >= 60 then
		local medalBack = cc.Sprite:create('image/homescene/datashare/main_interface_drop_down_share_medal_back_100.png')
		medalBack:setPosition(medal:getContentSize().width / 2,medal:getContentSize().height / 2 + 15)
		medal:addChild(medalBack,-1)
		count_Y = medal:getContentSize().height / 2 + 17


		if LEARN_INDEX >= 100 then

			local roll = cc.Sprite:create('image/homescene/datashare/main_interface_drop_down_share_medal_halo_100.png')
			roll:setPosition(medal:getContentSize().width / 2,medal:getContentSize().height / 2 + 17)
			medal:addChild(roll,-1)
			roll:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,360)))
			
			local shine1 = cc.Sprite:create('image/homescene/datashare/main_interface_drop_down_share_glow1.png')
			shine1:setAnchorPoint(0.5,0)
			shine1:setPosition(medal:getContentSize().width / 2,medal:getContentSize().height / 3 + 20)
			medal:addChild(shine1,-2)

			shine1:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.Show:create(),cc.DelayTime:create(0.4),cc.Hide:create(),cc.DelayTime:create(0.4),cc.Show:create(),cc.DelayTime:create(0.4))))

			local shine2 = cc.Sprite:create('image/homescene/datashare/main_interface_drop_down_share_glow2.png')
			shine2:setAnchorPoint(0.5,0)
			shine2:setPosition(medal:getContentSize().width / 2,medal:getContentSize().height / 3 - 5)
			medal:addChild(shine2,-2)

			shine2:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.Hide:create(),cc.DelayTime:create(0.4),cc.Show:create(),cc.DelayTime:create(0.8))))
		end

		if forShare then
			local shareBtn = ccui.Button:create('image/homescene/datashare/main_interface_drop_down_share_button.png','image/homescene/datashare/main_interface_drop_down_share_button_click.png')
			shareBtn:setPosition(background:getContentSize().width / 2,s_DESIGN_HEIGHT / 5 + 50)
			background:addChild(shareBtn)
			shareBtn:setTitleText('分 享')
			shareBtn:setTitleFontSize(30)
		
		
			self.shareBtn = shareBtn
			local pageForShare = self:getPageForShare()
		

			local target = cc.RenderTexture:create(s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT * 6 / 6 , cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
		    target:retain()
		    target:setPosition(cc.p(background:getContentSize().width / 2 + s_LEFT_X, s_DESIGN_HEIGHT))
		    self:addChild(target, -1)

			local function share(sender,eventType)
			    if eventType == ccui.TouchEventType.began then
		        	--shareBtn:setVisible(false)
		        	--background:setPosition(s_DESIGN_WIDTH / 2 - s_LEFT_X,0)
		        	pageForShare:setVisible(true)
		            target:begin()
		            pageForShare:visit()
		            target:endToLua()
		            --shareBtn:setVisible(true)
		            pageForShare:setVisible(false)
		            --background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 6)
		            target:setVisible(false)
		        end
				if eventType == ccui.TouchEventType.ended then
					--AnalyticsButtonToShare()
					sender:setVisible(false)
					self.close_button:setVisible(false)
					self.bangle:setVisible(false)
					self.girl:setVisible(false)

					-- background:setAnchorPoint(0.5,1)
					-- background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT)
					--background:runAction(cc.ScaleTo:create(0.3,0.78))

					local ShareBottom = require('view.share.ShareBottom')
					local shareBottomLayer = ShareBottom.create(target)
					self:addChild(shareBottomLayer)

				end
			end

			shareBtn:addTouchEventListener(share)
		end

	else
		count_Y = medal:getContentSize().height / 2 + 10
	end

	local count3 = cc.Label:createWithTTF(LEARN_INDEX,'font/impact.ttf',125)
	count3:setPosition(medal:getContentSize().width / 2,count_Y)
	medal:addChild(count3)
end

function DataShare:getPageForShare()
	local background = cc.LayerColor:create(cc.c4b(200,240,255,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
	background:ignoreAnchorPointForPosition(false)
	background:setAnchorPoint(0.5,0)
	background:setPosition(s_DESIGN_WIDTH / 2,0)
	self:addChild(background)
	background:setVisible(false)
	-- add label
	self:addLabel(background,100)
	--add medal
	self:addMedal(background,100,false)
	return background
end

function DataShare:shareEnd()
	self.close_button:setVisible(true)
	self.bangle:setVisible(true)
	self.girl:setVisible(true)
	self.shareBtn:setVisible(true)
	--self.background:runAction(cc.ScaleTo:create(0.3,1))
end

function DataShare:setEnabled(enable)
	self.girlBtn:setEnabled(enable)
	self.bangle:setEnabled(enable)
end

return DataShare