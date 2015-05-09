require("cocos.init")
require("common.global")

local StoryLayer = class("StoryLayer", function()
	return cc.Layer:create()
end)

function StoryLayer.create(tag)
	return StoryLayer.new(tag)
end

function StoryLayer:ctor(tag)
	self.tag = tag
	self.skip = false
	if tag == 1 then
		self:addIntroduction1()
	elseif tag == 2 then
		self:addIntroduction2()
	elseif tag == 3 then
   		self:addIntroduction3()
	elseif tag == 4 then
		self:addIntroduction4()
	elseif tag == 5 then
		self:addIntroduction5()
	elseif tag == 6 then
		self:addIntroduction6()
	else
		self:addIntroduction7()
	end
	self:addSkipButton()
end

function StoryLayer:addSkipButton()
	local click_skip = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.skip = true
            self:directStory(self.tag)
        end
    end
    local skipButton = ccui.Button:create("image/tutorial/skip.png","image/tutorial/skip.png","")
    skipButton:addTouchEventListener(click_skip)
    skipButton:ignoreAnchorPointForPosition(false)
    skipButton:setPosition(s_RIGHT_X - 100  , 100)
    skipButton:setLocalZOrder(1)
    self:addChild(skipButton,200)

    -- add label
    local skipLabel = cc.Label:createWithSystemFont("skip",'',35)
    skipLabel:setPosition(skipButton:getContentSize().width/2, skipButton:getContentSize().height/2)
    -- skipLabel:setColor(cc.c3b(0,0,0))
    skipButton:addChild(skipLabel)
end

function StoryLayer:directStory(requestTag)   -- request tag:发起切换剧情请求的tag
	if requestTag - self.tag < 0 then 
		return -- request disabled (because skip button)
	end
	if self.tag == 1 then
		self.tag = self.tag + 1
		local action1 = cc.MoveBy:create(0.8, cc.p(-s_DESIGN_WIDTH*2, 0))
		local action2 = cc.FadeOut:create(0.8)
		local action3 = cc.Spawn:create(action1, action2)
		self:getChildByName('drama1'):runAction(action3)
		self:addIntroduction2() 
	elseif self.tag == 2 then
		self.tag = self.tag + 1
		local action1 = cc.MoveBy:create(0.8, cc.p(-s_DESIGN_WIDTH*2, 0))
		local action2 = cc.FadeOut:create(0.8)
		local action3 = cc.Spawn:create(action1, action2)
		self:getChildByName('drama2'):runAction(action3)
		self:addIntroduction3() 
	elseif self.tag == 3 then
		self.tag = self.tag + 1
		local action1 = cc.MoveBy:create(0.8, cc.p(-s_DESIGN_WIDTH*2, 0))
		local action2 = cc.FadeOut:create(0.8)
		local action3 = cc.Spawn:create(action1, action2)
		self:getChildByName('drama3'):runAction(action3)
		self:addIntroduction4() 
	elseif self.tag == 4 then
		self.tag = self.tag + 1
		local action1 = cc.MoveBy:create(0.8, cc.p(-s_DESIGN_WIDTH*2, 0))
		local action2 = cc.FadeOut:create(0.8)
		local action3 = cc.Spawn:create(action1, action2)
		self:getChildByName('drama4'):runAction(action3)
		self:addIntroduction5() 
	elseif self.tag == 5 then
		self.tag = self.tag + 1
		local action1 = cc.MoveBy:create(0.8, cc.p(-s_DESIGN_WIDTH*2, 0))
		local action2 = cc.FadeOut:create(0.8)
		local action3 = cc.Spawn:create(action1, action2)
		self:getChildByName('drama5'):runAction(action3)
		self:addIntroduction6() 
	elseif self.tag == 6 then
		self.tag = self.tag + 1
		local action1 = cc.MoveBy:create(0.8, cc.p(-s_DESIGN_WIDTH*2, 0))
		local action2 = cc.FadeOut:create(0.8)
		local action3 = cc.Spawn:create(action1, action2)
		self:getChildByName('drama6'):runAction(action3)
		self:addIntroduction7() 
	elseif self.tag == 7 then
		-- enter level layer
		self.tag = self.tag + 1
		if s_CURRENT_USER.newTutorialStep == s_newtutorial_story then
	        s_CURRENT_USER.newTutorialStep = s_newtutorial_island_finger
	        saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})   
    	end
		s_CorePlayManager.enterLevelLayer() 
		    -- 更新引导步骤
    	s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterLevel)
	end
end

function StoryLayer:addIntroduction1()
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory1)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/jieshao1.json","spine/tutorial/story/jieshao1.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', false)
	drama:setName("drama1")
	self:addChild(drama)
	self:callFuncWithDelay(2, function()
		self:directStory(1)
	end)
end

function StoryLayer:addIntroduction2() 
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory2)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/skeleton.json","spine/tutorial/story/skeleton.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', false)
	drama:setName("drama2")
	self:addChild(drama)
	self:callFuncWithDelay(2, function()
		self:directStory(2)
	end)
end

function StoryLayer:addIntroduction3()
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory3)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/jieshao_2.5.json","spine/tutorial/story/jieshao_2.5.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', true)
	drama:setName("drama3")
	self:addChild(drama)
	self:callFuncWithDelay(2, function()
		self:directStory(3)
	end)
end

function StoryLayer:addIntroduction4()
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory4)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/jieshao_3.json","spine/tutorial/story/jieshao_3.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', true)
	drama:setName("drama4")
	self:addChild(drama)
	self:callFuncWithDelay(2, function()
		self:directStory(4)
	end)
end

function StoryLayer:addIntroduction5()
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory5)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/jieshao_4.json","spine/tutorial/story/jieshao_4.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', true)
	drama:setName("drama5")
	self:addChild(drama)
	self:callFuncWithDelay(2, function()
		self:directStory(5)
	end)
end

function StoryLayer:addIntroduction6()
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory6)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/jieshao_5.json","spine/tutorial/story/jieshao_5.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', true)
	drama:setName("drama6")
	self:addChild(drama)
	-- self:callFuncWithDelay(2.5, function()
	-- 	self:directStory(6)
	-- end)
	local button = require("view.button.longButtonInStudy").create("small","blue","试玩")
	button:setPosition(0,-s_DESIGN_HEIGHT / 2.6)
	drama:addChild(button)

	button.func = function ()
        s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStoryBoss)
		local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
        local summaryBossLayer = SummaryBossLayer.create(nil,0,true)
        s_SCENE:replaceGameLayer(summaryBossLayer) 
	end
end

function StoryLayer:addIntroduction7()
	-- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_enterStory7)
	local drama = sp.SkeletonAnimation:create("spine/tutorial/story/jieshao_6.json","spine/tutorial/story/jieshao_6.atlas",1)
	drama:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
	drama:setAnchorPoint(0.5, 0.5)
	drama:addAnimation(0, 'animation', true)
	drama:setName("drama7")
	self:addChild(drama)

	-- TODO
	self:callFuncWithDelay(2, function()
		self:directStory(7)
	end)
end

function StoryLayer:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

return StoryLayer