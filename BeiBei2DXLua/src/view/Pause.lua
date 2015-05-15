require("cocos.init")
require("common.global")
local Pause = class("Pause", function()
    return cc.Layer:create()
end)

ccbPause = ccbPause or {}

function Pause.create()
    local layer = Pause.new()
    s_SCENE.popupLayer.pauseLayer = layer
    s_SCENE.popupLayer.layerpaused = true
    layer.pauseBtn = nil
    return layer
end

function Pause:ctor()
        
    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    --control volune
    if s_LocalDatabaseManager.isMusicOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.1) 
    end

    -- Pause actions
    local director = cc.Director:getInstance()
    self.targets = director:getActionManager():pauseAllRunningActions()
    
    self.ccb = {}
    
    ccbPause['onClose'] = self.onClose
    ccbPause['onRetry'] = self.onRetry    
    ccbPause['onBack'] = self.onBack
    ccbPause['onContinue'] = self.onContinue
    ccbPause['onHelp'] = self.onHelp
    
    ccbPause['onSoundOn'] = self.onSoundOn
    ccbPause['onSoundOff'] = self.onSoundOff
    ccbPause['onMusicOn'] = self.onMusicOn
    ccbPause['onMusicOff'] = self.onMusicOff
    
    self.ccb['pause'] = ccbPause
    ccbPause['Layer'] = self

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/pause.ccbi", proxy, ccbPause, self.ccb)
    --temp
    ccbPause['retry']:setVisible(false)
    ccbPause['help']:setVisible(false)
    ccbPause['title']:setPositionX(ccbPause['title']:getPositionX()+25)
    ccbPause['back']:setPositionX(ccbPause['back']:getPositionX()+80)
    ccbPause['continue']:setPositionX(ccbPause['continue']:getPositionX()+80)
    
    node:setPosition(0,0)
    self:addChild(node)
    
    if s_LocalDatabaseManager.isSoundOn() then
        ccbPause['soundOn']:setVisible(true)
        ccbPause['soundOff']:setVisible(false)
    else
        ccbPause['soundOn']:setVisible(false)
        ccbPause['soundOff']:setVisible(true)
    end
    
    if s_LocalDatabaseManager.isMusicOn() then
        ccbPause['musicOn']:setVisible(true)
        ccbPause['musicOff']:setVisible(false)
    else
        ccbPause['musicOn']:setVisible(false)
        ccbPause['musicOff']:setVisible(true)        
    end


    ccbPause['mask']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p((s_RIGHT_X - s_LEFT_X) * 0.5,s_DESIGN_HEIGHT * 0.5))))
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = node:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(ccbPause['mask']:getBoundingBox(),location) then
            self:onClose()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)

    self.inTryingLayer = false
    
    onAndroidKeyPressed(node, function ()
        self:onClose()
    end, function ()

    end)
 end

function Pause:onClose()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p((s_RIGHT_X - s_LEFT_X) * 0.5,s_DESIGN_HEIGHT * 1.3)))
    local remove = cc.CallFunc:create(function() 
        local director = cc.Director:getInstance()
        director:getActionManager():resumeTargets(ccbPause['Layer'].targets)
        s_SCENE.popupLayer.layerpaused = false
        s_SCENE.popupLayer.listener:setSwallowTouches(false)
        ccbPause['Layer']:removeFromParent()
        s_SCENE:removeAllPopups()
    end,{})
    ccbPause['mask']:runAction(cc.Sequence:create(move,remove))
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    if s_LocalDatabaseManager.isMusicOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.2) 
    end
end

function Pause:onRetry()
    
--    local sceneState = ""
--    if  s_SCENE.gameLayerState == s_review_boss_game_state then
--        s_SCENE.levelLayerState = s_review_boss_retry_state 
--    elseif s_SCENE.gameLayerState == s_summary_boss_game_state then
--        s_SCENE.levelLayerState = s_normal_retry_state  
--    else
--        s_SCENE.levelLayerState = s_normal_retry_state
--    end
--    
--    ccbPause['Layer']:onBack()
--
--    --button sound
--    playSound(s_sound_buttonEffect)
--    --control volune
--    if s_LocalDatabaseManager.isMusicOn() then
--        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.2) 
--    end
end

function Pause:onBack()
    ccbPause['Layer']:onClose()
    playSound(s_sound_buttonEffect)
    --cc.SimpleAudioEngine:getInstance():stopMusic()
    
    --control volune
    if s_LocalDatabaseManager.isMusicOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.2) 
    end

    if ccbPause['Layer'].inTryingLayer then
        local StoryLayer = require('view.level.StoryLayer')
        local storyLayer = StoryLayer.create(7)
        s_SCENE:replaceGameLayer(storyLayer)
    else
        s_CorePlayManager.enterLevelLayer()
    end

    s_CURRENT_USER.beanRewardForIron = 3
    --if self.win and isPassed == 0 then
    --    s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
    --end
end

function Pause:onContinue()
    ccbPause['Layer']:onClose()
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    if s_LocalDatabaseManager.isMusicOn() then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.2) 
    end

end

function Pause:onHelp()
    local site = ""
    if  s_SCENE.gameLayerState == s_review_boss_game_state then
        site = "view.pausehelp.PauseHelpReview" 
    elseif s_SCENE.gameLayerState == s_summary_boss_game_state then
        site = "view.pausehelp.PauseHelpSummary"  
    else
        site = "view.pausehelp.PauseHelpNormal"
    end

    local IntroLayer = require(site)
    local introLayer = IntroLayer.create()
    s_SCENE.popupLayer:addChild(introLayer) 
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onSoundOn()
    s_LocalDatabaseManager.setSoundOn(false)

    ccbPause['soundOn']:setVisible(false)
    ccbPause['soundOff']:setVisible(true)
end

function Pause:onSoundOff()
    s_LocalDatabaseManager.setSoundOn(true)

    ccbPause['soundOn']:setVisible(true)
    ccbPause['soundOff']:setVisible(false)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onMusicOn()
    s_LocalDatabaseManager.setMusicOn(false)
    
    ccbPause['musicOn']:setVisible(false)
    ccbPause['musicOff']:setVisible(true)
    
    cc.SimpleAudioEngine:getInstance():stopMusic()
end

function Pause:onMusicOff()
    s_LocalDatabaseManager.setMusicOn(true)
    
    ccbPause['musicOn']:setVisible(true)
    ccbPause['musicOff']:setVisible(false)
    
    --button sound
    if currentBGM ~="" then
        playMusic(currentBGM,true)
    end
end

function createPauseLayerWhenTestOrBoss()   
    if s_SCENE.gameLayerState == s_test_game_state
    or s_SCENE.gameLayerState == s_review_boss_game_state
    or s_SCENE.gameLayerState == s_summary_boss_game_state then 

        if s_SCENE.popupLayer.layerpaused == false and s_SCENE.popupLayer.isOtherAlter == false then
            local pauseLayer = Pause:create()
            s_SCENE.popupLayer.listener:setSwallowTouches(true)
            pauseLayer:setPosition(s_LEFT_X, 0)
            s_SCENE.popupLayer.layerPaused = true
            s_SCENE.popupLayer:removeAllChildren()
            s_SCENE.popupLayer:addChild(pauseLayer) 
        end
    end
end

return Pause