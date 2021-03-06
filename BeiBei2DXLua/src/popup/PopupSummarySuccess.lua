
local PopupSummarySuccess = class('PopupSummarySuccess', function()
    return cc.Layer:create()
end)

local width = s_RIGHT_X-s_LEFT_X

function PopupSummarySuccess.create(levelKey, current_star, total_star)
    local layer = PopupSummarySuccess.new(levelKey, current_star, total_star)
    return layer
end

function PopupSummarySuccess:ctor(levelKey, current_star, total_star)

    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    

    
    self.ccbPopupSummarySuccess = {}
    self.ccbPopupSummarySuccess['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end
    self.ccbPopupSummarySuccess['onGoButtonClicked'] = function()
        self:onGoButtonClicked(levelKey)
    end
    
    self.ccb = {}
    self.ccb['levelKey'] = levelKey
    self.ccb['popup_summary_success'] = self.ccbPopupSummarySuccess
    local proxy = cc.CCBProxy:create()
    local node

    if s_CURRENT_USER.currentSelectedChapterKey == 'chapter0' then
        node = CCBReaderLoad('res/ccb/popup_summary_success.ccbi',proxy,self.ccbPopupSummarySuccess, self.ccb)
    elseif s_CURRENT_USER.currentSelectedChapterKey == 'chapter1' then
        node = CCBReaderLoad('res/ccb/popup_summary_success2.ccbi',proxy,self.ccbPopupSummarySuccess, self.ccb)
    else
        node = CCBReaderLoad('res/ccb/popup_summary_success3.ccbi',proxy,self.ccbPopupSummarySuccess, self.ccb)
    end
    
    -- set title
    self.ccbPopupSummarySuccess['summary_boss_text']:setString(s_DataManager.getTextWithIndex(TEXT__NORMAL_START_PLAY_SUMMARY_BOSS))
    -- add summary boss
    local boss = sp.SkeletonAnimation:create('spine/klschongshangdaoxia.json', 'spine/klschongshangdaoxia.atlas',1)
    boss:addAnimation(0, 'jianxiao', true)
    boss:setPosition(s_LEFT_X + width * 0.35, node:getContentSize().height/3)
    node:addChild(boss, 10)
    
    -- set stars
    self.ccbPopupSummarySuccess['current_star_count']:setString(current_star)
    self.ccbPopupSummarySuccess['total_star_count']:setString(total_star) 
    
    -- run action
    node:setPosition(0, 200)
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    self:addChild(node)
end

function PopupSummarySuccess:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
    
    -- button sound
    playSound(s_sound_buttonEffect)
end

function PopupSummarySuccess:onGoButtonClicked(levelKey)
    self:onCloseButtonClicked()
    s_logd('on go button clicked')
    s_SCENE.gameLayerState = s_summary_boss_game_state
    
    -- button sound
    playSound(s_sound_buttonEffect)
    showProgressHUD('正在加载关卡')
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentSelectedChapterKey,levelKey)
    if levelData.isPassed == 1 or s_CURRENT_USER.energyCount >= s_summary_boss_energy_cost then
        if levelData.isPassed ~= 1 then
--            s_CURRENT_USER:useEnergys(s_summary_boss_energy_cost)
            -- energy cost "cost"
--            s_SCENE:callFuncWithDelay(0.3,function()
--                playSound(s_sound_cost)
--            end)
        end
        local levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentSelectedChapterKey,levelKey)
        local summaryboss = require('view.summaryboss.SummaryBossLayer')
        if s_CURRENT_USER.currentSelectedChapterKey == 'chapter0' then
            local layer = summaryboss.create(levelConfig,1)
            layer:setAnchorPoint(0.5,0)
            s_SCENE:replaceGameLayer(layer)
        elseif s_CURRENT_USER.currentSelectedChapterKey == 'chapter1' then
            local layer = summaryboss.create(levelConfig,2)
            layer:setAnchorPoint(0.5,0)
            s_SCENE:replaceGameLayer(layer)
        else
            local layer = summaryboss.create(levelConfig,3)
            layer:setAnchorPoint(0.5,0)
            s_SCENE:replaceGameLayer(layer)
        end
--    else 
--        local energyInfoLayer = require('popup.PopupEnergyInfo')
--        local layer = energyInfoLayer.create()
--        s_SCENE:popup(layer)
    end
    hideProgressHUD()
end

return PopupSummarySuccess