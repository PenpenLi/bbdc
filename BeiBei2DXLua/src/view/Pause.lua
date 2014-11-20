require("Cocos2d")
require("Cocos2dConstants")
require("common.global")
require("CCBReaderLoad")
local Pause = class("Pause", function()
    return cc.Layer:create()
end)

ccbPause = ccbPause or {}

function Pause.create()
    local layer = Pause.new()
    
    return layer
end

function Pause:ctor()

    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.25) 
    
    -- Pause actions
    local director = cc.Director:getInstance()
    self.targets = director:getActionManager():pauseAllRunningActions()
    s_logd(#self.targets)
    
    local back = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    back:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(back)
    
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
    node:setPosition(0,0)
    self:addChild(node)
    
    ccbPause['soundOff']:setVisible(false)
    ccbPause['musicOff']:setVisible(false)
    ccbPause['mask']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    
end

function Pause:onClose()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)))
    local remove = cc.CallFunc:create(function() 
        local director = cc.Director:getInstance()
        director:getActionManager():resumeTargets(ccbPause['Layer'].targets)
        ccbPause['Layer']:getParent().layerPaused = false
        ccbPause['Layer']:removeFromParent()
    end,{})
    ccbPause['mask']:runAction(cc.Sequence:create(move,remove))
    s_SCENE:removeAllPopups()
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
end

function Pause:onRetry()
    
    ccbPause['Layer']:onBack()
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
end

function Pause:onBack()
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
end

function Pause:onContinue()
    ccbPause['Layer']:onClose()
    
    --button sound
    playSound(s_sound_buttonEffect)
    --control volune
    cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
end

function Pause:onHelp()
 -- judge normal / review / summary
--    if xx.class.__cname == 
--    for i=1,5 do
--        print(tostring(s_GAME_LAYER.class.__cname[i]))
--
--   end


    local site  = "view.pausehelp.PauseHelpNormal"
--    site = "view.pausehelp.PauseHelpSummary"  
--    site = "view.pausehelp.PauseHelpReview" 
    local IntroLayer = require(site)
    local introLayer = IntroLayer.create()
    s_SCENE:popup(introLayer)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onSoundOn()
    ccbPause['soundOn']:setVisible(false)
    ccbPause['soundOff']:setVisible(true)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onSoundOff()
    ccbPause['soundOn']:setVisible(true)
    ccbPause['soundOff']:setVisible(false)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onMusicOn()
    ccbPause['musicOn']:setVisible(false)
    ccbPause['musicOff']:setVisible(true)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

function Pause:onMusicOff()
    ccbPause['musicOn']:setVisible(true)
    ccbPause['musicOff']:setVisible(false)
    
    --button sound
    playSound(s_sound_buttonEffect)
end

return Pause