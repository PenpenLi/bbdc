require("cocos.init")
require("common.global")

local ShareBottom = class('ShareBottom',function ()
	return cc.Layer:create()
end)

function ShareBottom.create(target)
	local layer = ShareBottom.new()
	layer.target = target
	return layer
end

function ShareBottom:ctor()

	local function addTitle(button,str,x)
		local label = cc.Label:createWithSystemFont(str,'',20)
		label:setPosition(x * button:getContentSize().width, - 0.25 * button:getContentSize().height)
		button:addChild(label)
	end
	
	local bottom = cc.LayerColor:create(cc.c4b(0,0,0,87),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT * 0.21)
	bottom:ignoreAnchorPointForPosition(false)
	bottom:setAnchorPoint(0.5,1)
	bottom:setPosition(s_DESIGN_WIDTH / 2,0)
	self:addChild(bottom)
	bottom:runAction(cc.MoveBy:create(0.3,cc.p(0,s_DESIGN_HEIGHT * 0.21)))

	local save_button = ccui.Button:create('image/share/share_preserve.png','')
	save_button:setScale9Enabled(true)
	save_button:setPosition(0.26 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	bottom:addChild(save_button)
	addTitle(save_button,'保存',0.5)

	-- create a render texture, this is what we are going to draw into
    -- target = cc.RenderTexture:create(s_DESIGN_WIDTH * 1, s_DESIGN_HEIGHT * 1, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    -- target:retain()
    -- target:setPosition(cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2))

    local png = "image_saved.png"
    local time_png = png
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        time_png = 'image_saved_' .. tostring(os.time()) .. '.png'
    end
    local function saveImage(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            self.target:saveToFile(time_png, cc.IMAGE_FORMAT_PNG)
        elseif eventType == ccui.TouchEventType.ended then
        	AnalyticsShare('save')
            local imagePath = cc.FileUtils:getInstance():getWritablePath()..time_png
            cx.CXUtils:getInstance():addImageToGallery(imagePath)
            self:getParent():shareEnd()
            
            local move = cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT * 0.21))
            local remove = cc.CallFunc:create(function ()
				self:removeFromParent()
			end)
            bottom:runAction(cc.Sequence:create(move,remove))
        end
    end
    

	save_button:addTouchEventListener(saveImage)

	local weixin_button = ccui.Button:create('image/share/share_weichat.png','')
	weixin_button:setScale9Enabled(true)
	weixin_button:setPosition(0.5 * (s_RIGHT_X - s_LEFT_X) + 5,0.55 * bottom:getContentSize().height)
	bottom:addChild(weixin_button)
	addTitle(weixin_button,'朋友圈',0.45)
	if not IS_SNS_WEIXIN_SHARE_AVAILABLE then
		weixin_button:setVisible(false)
	end

	local qq_button = ccui.Button:create('image/share/share_QQ.png','')
	qq_button:setScale9Enabled(true)
	qq_button:setPosition(0.74 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	bottom:addChild(qq_button)
	addTitle(qq_button,'QQ好友',0.5)
	if not IS_SNS_QQ_SHARE_AVAILABLE then
		qq_button:setVisible(false)
	end

	if (not IS_SNS_WEIXIN_SHARE_AVAILABLE) and (not IS_SNS_QQ_SHARE_AVAILABLE) then
		save_button:setPosition(0.5 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	elseif (not IS_SNS_WEIXIN_SHARE_AVAILABLE) and (IS_SNS_QQ_SHARE_AVAILABLE) then
		save_button:setPosition(0.33 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
		qq_button:setPosition(0.67 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	elseif (IS_SNS_WEIXIN_SHARE_AVAILABLE) and (not IS_SNS_QQ_SHARE_AVAILABLE) then
		save_button:setPosition(0.33 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
		weixin_button:setPosition(0.67 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	end 

	local png_shared = "image_shared.png"
	local function shareTo(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self.target:saveToFile(png_shared, cc.IMAGE_FORMAT_PNG)
        elseif eventType == ccui.TouchEventType.ended then
        	--local png = string.format("image-saved%s.png",os.date('%X',os.time()))
            --self.target:saveToFile(png, cc.IMAGE_FORMAT_PNG)
            local imagePath = cc.FileUtils:getInstance():getWritablePath()..png_shared
            if sender == qq_button then
            	AnalyticsShare('qq')
                cx.CXUtils:getInstance():shareImageToQQFriend(imagePath, '分享我的记录', '贝贝单词－根本停不下来')
            else
            	AnalyticsShare('weixin')
                cx.CXUtils:getInstance():shareImageToWeiXin(imagePath, '分享我的记录', '贝贝单词－根本停不下来')
            end

            self:getParent():shareEnd()
            local move = cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT * 0.21))
            local remove = cc.CallFunc:create(function ()
        		os.remove(imagePath)
				self:removeFromParent()
			end)
            bottom:runAction(cc.Sequence:create(move,remove))
        end
    end

    weixin_button:addTouchEventListener(shareTo)
    qq_button:addTouchEventListener(shareTo)

	local close = ccui.Button:create('image/share/share_close_sharing.png','')
	close:setScale9Enabled(true)
	--close:setVisible(false)
	close:setAnchorPoint(1,1)
	close:setPosition(s_RIGHT_X * 0.99,s_DESIGN_HEIGHT * 0.99)
	self:addChild(close)

	local function closeShare(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			local remove = cc.CallFunc:create(function ()
				for i = 1, 4 do 
					local png = string.format("share_sample%d.png",i)
					local filename = string.format('%s%s',cc.FileUtils:getInstance():getWritablePath(),png)
        			os.remove(filename)
        		end
				self:getParent():removeFromParent()
			end)
			bottom:runAction(remove)
		end
	end

	close:addTouchEventListener(closeShare)
	
end

return ShareBottom