require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local s_layerHeight = 4540

local LevelLayerII = class('LevelLayerII', function()
    local widget = ccui.Widget:create()
    widget:setContentSize(cc.size(s_MAX_WIDTH, s_layerHeight))
    return widget
end)

function LevelLayerII.create()
    local layer = LevelLayerII.new()
    return layer
end

function LevelLayerII:plotReviewBossAppearOnLevel(levelKey)
    local levelButton = self:getChildByName(levelKey)
    local reviewBoss = sp.SkeletonAnimation:create('spine/3fxzlsxuanxiaoguandiaoluo.json', 'spine/3fxzlsxuanxiaoguandiaoluo.atlas', 1)
    reviewBoss:addAnimation(0, '1', false)
    s_SCENE:callFuncWithDelay(1,function()
        reviewBoss:addAnimation(1, '2', true)
    end)
    reviewBoss:setPosition(0, 0)
    levelButton:addChild(reviewBoss)
end

function LevelLayerII:getPlayerPositionForLevel(levelKey)
    local levelButton = self:getChildByName(levelKey)
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,'chapter1',levelKey)
    local levelIndex = string.sub(levelKey, 6)
    --print(levelButton:getPositionX()..','..levelButton:getPositionY())
    local position = cc.p(levelButton:getPositionX(), levelButton:getPositionY())
    if levelConfig['type'] == 1 then
        position.y = position.y - 50
    else
        position.y = position.y - 20
    end

    return position
end

function LevelLayerII:plotLevelStar(levelButton, heart)
    local star1, star2, star3
    if heart >= 3 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starFull.png')
        star3 = cc.Sprite:create('image/chapter_level/starFull.png')
    elseif heart == 2 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starFull.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    elseif heart == 1 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    else
        star1 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    end
    star1:setPosition(50,30)
    star2:setPosition(100,10)
    star3:setPosition(150,30)
    levelButton:addChild(star1, 5)
    levelButton:addChild(star2, 5)
    levelButton:addChild(star3, 5)
end

function LevelLayerII:plotStarAnimation(levelKey, starCount)
    local levelButton = self:getChildByName(levelKey)
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,'chapter1',levelKey)
    if levelConfig['type'] == 0 then
        local star1, star2, star3
        if starCount >= 3 then
            star1 = cc.Sprite:create('image/chapter_level/starFull.png')
            star2 = cc.Sprite:create('image/chapter_level/starFull.png')
            star3 = cc.Sprite:create('image/chapter_level/starFull.png')
        elseif starCount == 2 then
            star1 = cc.Sprite:create('image/chapter_level/starFull.png')
            star2 = cc.Sprite:create('image/chapter_level/starFull.png')
            star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        elseif starCount == 1 then
            star1 = cc.Sprite:create('image/chapter_level/starFull.png')
            star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
            star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        else
            star1 = cc.Sprite:create('image/chapter_level/starEmpty.png')
            star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
            star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        end
        star1:setPosition(50,30)
        star2:setPosition(100,10)
        star3:setPosition(150,30)
        star1:setScale(2)
        star2:setScale(2)
        star3:setScale(2)

        levelButton:addChild(star1, 5)
        levelButton:addChild(star2, 5)
        levelButton:addChild(star3, 5)
        star1:setVisible(false)
        star2:setVisible(false)
        star3:setVisible(false)

        s_SCENE:callFuncWithDelay(0.3,function()
            star1:setVisible(true)
            local action = cc.ScaleTo:create(0.4, 1.0)
            star1:runAction(action)
            --            -- star sound
            --            if starCount >= 1 then
            --                playSound(s_sound_star1)
            --            end
        end)
        s_SCENE:callFuncWithDelay(0.6,function()
            star2:setVisible(true)
            local action = cc.ScaleTo:create(0.4, 1.0)
            star2:runAction(action)
            --            --star sound
            --            if starCount >= 2 then
            --                playSound(s_sound_star2)
            --            end
        end)
        s_SCENE:callFuncWithDelay(0.9,function()
            star3:setVisible(true)
            local action = cc.ScaleTo:create(0.4, 1.0)
            star3:runAction(action)
            --            --star sound
            --            if starCount >= 3 then
            --                playSound(s_sound_star3)
            --            end
        end)
    end
end


function LevelLayerII:plotUnlockLevelAnimation(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelButton = self:getChildByName(levelKey)
    local lockSprite = levelButton:getChildByName('lockSprite'..levelIndex)
    local lockLayer = levelButton:getChildByName('lockLayer'..levelIndex)

    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),4)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0))  
    local action6 = cc.FadeOut:create(0.1)
    local action = cc.Sequence:create(action1, action4, action5, action6, nil)
    lockSprite:runAction(action)

    local action7 = cc.DelayTime:create(0.6)
    local action8 = cc.FadeOut:create(0.1)
    lockLayer:runAction(cc.Sequence:create(action7, action8))

    s_SCENE:callFuncWithDelay(1.1,function()
        self:plotLevelDecoration(levelKey)
    end)
end

function LevelLayerII:plotLevelDecoration(levelKey)
    local levelButton = self:getChildByName(levelKey)
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,'chapter1',levelKey)
    local levelData = s_CURRENT_USER:getUserLevelData('chapter1', levelKey)
    local levelIndex = string.sub(levelKey, 6)
    if  levelData ~= nil and levelData.isLevelUnlocked == 1 then  -- test
        if levelData.stars > 0 and levelConfig['type'] ~= 1 then
            if s_CURRENT_USER.currentLevelKey ~= levelData.levelKey or s_SCENE.levelLayerState == s_review_boss_appear_state or s_SCENE.levelLayerState == s_review_boss_pass_state then
                self:plotLevelStar(levelButton, levelData.stars)
            elseif s_CURRENT_USER.currentLevelKey == levelData.levelKey and s_CURRENT_USER.currentChapterKey ~= 'chapter1' then
                self:plotLevelStar(levelButton, levelData.stars)
            end 
    end
    if levelConfig['type'] == 1 then
        -- add summary boss
        local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
        summaryboss:setPosition(40,40)
        summaryboss:setName('summaryboss'..string.sub(levelKey, 6))
        summaryboss:addAnimation(0, 'jianxiao', true)
        summaryboss:setScale(0.7)
        levelButton:addChild(summaryboss, 3)
    end
    end
end

function LevelLayerII:plotLevelNumber(levelKey)
    local levelButton = self:getChildByName(levelKey)
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,'chapter1',levelKey)
    local levelData = s_CURRENT_USER:getUserLevelData('chapter1', levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelNumber = levelIndex + 1
    if  levelData ~= nil and levelData.isLevelUnlocked == 1 then
        if levelConfig['type'] == 1 then -- summary boss
--            local summaryboss = levelButton:getChildByName('summaryboss'..string.sub(levelKey,6))
--            local number = ccui.TextBMFont:create()
--            number:setFntFile('font/number_straight.fnt')
--            number:setScale(1.6)
--            number:setString(levelNumber)
--            number:setPosition(125, 100)
--            summaryboss:addChild(number)
        else 
            local number = ccui.TextBMFont:create()
            number:setFntFile('font/number_inclined.fnt')
            number:setString(levelNumber)
            number:setPosition(levelButton:getContentSize().width/2-8, levelButton:getContentSize().height/2+3)
            levelButton:addChild(number)
        end
    else
        local lockSprite = levelButton:getChildByName('lockSprite'..levelIndex)
        local lockNumber = ccui.TextBMFont:create()        
        lockNumber:setFntFile('font/number_brown.fnt')
        lockNumber:setString(levelNumber)
        lockNumber:setPosition(lockSprite:getContentSize().width/2, lockSprite:getContentSize().height/2-6)
        lockSprite:addChild(lockNumber)
    end
end

-- define touch event
local onTouchBegan = function(touch, event) 
    local touchPosition = touch:getLocation()
end

function LevelLayerII:clickLockedLevelAnmation(levelKey)
    local clickedIndex = string.sub(levelKey, 6)
    local clickedButton = self:getChildByName(levelKey)
    local lockSprite = clickedButton:getChildByName('lockSprite'..clickedIndex)
    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),3)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0)) 
    local action = cc.Sequence:create(action1, action4, action5, nil)
    lockSprite:runAction(action)

    local action7 = cc.ScaleTo:create(0.15,1.15,0.85)
    local action8 = cc.ScaleTo:create(0.15,0.85,1.15)
    local action9 = cc.ScaleTo:create(0.1, 1, 1)
    clickedButton:runAction(cc.Sequence:create(action7, action8, action9, nil))
end

function LevelLayerII:ctor()
    --    self:initHead()
    self.ccbLevelLayerII = {}
    self.ccbLevelLayerII['onLevelButtonClicked'] = 
    function(levelTag)
        self:onLevelButtonClicked('level'..(levelTag-1))
    end
    self.ccb = {}
    self.ccb['chapter2'] = self.ccbLevelLayerII

    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/chapter2.ccbi',proxy,self.ccbLevelLayerII,self.ccb)
    self.ccbLevelLayerII['contentNode'] = contentNode
    self.ccbLevelLayerII['levelSet'] = contentNode:getChildByTag(5)
    for i = 1, #self.ccbLevelLayerII['levelSet']:getChildren() do
        self.ccbLevelLayerII['levelSet']:getChildren()[i]:setName('level'..(self.ccbLevelLayerII['levelSet']:getChildren()[i]:getTag()-1)..'Container')
    end
    contentNode:setContentSize(cc.size(s_MAX_WIDTH, s_layerHeight))
    self:setContentSize(contentNode:getContentSize())
    self:setAnchorPoint(0,0)
    self:addChild(contentNode)
    print('in levelLayerII:---------')
    print_lua_table(self:getContentSize())
    print_lua_table(contentNode:getContentSize())
    -- level button touch event
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local levelKey = sender:getName()
            print('button clicked')
            self:onLevelButtonClicked(levelKey)
        end
    end

    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.getLevels(s_CURRENT_USER.bookKey)
    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == 'chapter1' then
            -- change button image
            local levelContainer = self.ccbLevelLayerII['levelSet']:getChildByName(levelConfig[i]['level_key']..'Container')
            
            if string.format('%s',levelConfig[i]['type']) == '1' then
                --levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_unlocked.png'))
                --levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_unlocked.png'))
                local levelImageName = 'ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_unlocked.png'
                local levelButton = ccui.Button:create(levelImageName, levelImageName, levelImageName)
                levelButton:setPosition(levelContainer:getPositionX(),levelContainer:getPositionY())
                levelButton:setName(levelConfig[i]['level_key'])
                levelButton:setScale9Enabled(true)
                self:addChild(levelButton) 
                levelButton:addTouchEventListener(touchEvent)  
                if s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    self:plotLevelDecoration(levelConfig[i]['level_key'])
                else
                    local lockLayer = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_locked.png')
                    lockLayer:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                    lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))
                    levelButton:addChild(lockLayer)
                    
                    local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked_zongjieboss.png')
                    lockSprite:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2+5)
                    lockSprite:setName('lockSprite'..string.sub(levelButton:getName(),6))
                    levelButton:addChild(lockSprite)
                end
            else  
                local levelImageName = 'ccb/ccbResources/chapter_level/button_xuanxiaoguan2_level_unlocked.png'
                local levelButton = ccui.Button:create(levelImageName, levelImageName, levelImageName) 
                levelButton:setPosition(levelContainer:getPositionX(),levelContainer:getPositionY())
                levelButton:setName(levelConfig[i]['level_key'])
                self:addChild(levelButton)   
                levelButton:addTouchEventListener(touchEvent)                
                if  s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then  
                    self:plotLevelDecoration(levelConfig[i]['level_key'])
                else       
                    local lockLayer = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_level_locked.png')
                    lockLayer:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                    levelButton:addChild(lockLayer)
                    lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))

                    local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked_Lock.png')
                    lockSprite:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2+5)
                    lockSprite:setName('lockSprite'..string.sub(levelButton:getName(), 6))
                    levelButton:addChild(lockSprite)               
                end
            end
            self:plotLevelNumber(levelConfig[i]['level_key'])
        end
    end

    -- register touch event
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function LevelLayerII:onLevelButtonClicked(levelKey)
    s_CURRENT_USER.currentSelectedLevelKey = levelKey
    s_CURRENT_USER.currentSelectedChapterKey = 'chapter1'
    --s_logd('LevelLayerI:onLevelButtonClicked: ' .. levelKey .. ', ' .. s_CURRENT_USER.bookKey .. ', ' .. s_CURRENT_USER.currentChapterKey..', selectedKey:'..s_CURRENT_USER.currentSelectedLevelKey)
    local levelButton = self:getChildByName(levelKey)
    -- check level type
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentSelectedChapterKey,levelKey)
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentSelectedChapterKey, levelKey)
    if (s_SCENE.levelLayerState == s_review_boss_appear_state or s_SCENE.levelLayerState == s_review_boss_retry_state) and levelKey == 'level'..(string.sub(s_CURRENT_USER.currentLevelKey,6)+1)then -- review boss appear
        local popupReview = require('popup.PopupReviewBoss')
        local layer = popupReview.create()
        s_SCENE:popup(layer)
    elseif levelData == nil or levelData.isLevelUnlocked == 0 then
        self:clickLockedLevelAnmation(levelKey)
        --locked sound
        playSound(s_sound_clickLocked)
    elseif levelConfig['type'] == 0 then  -- normal level
        local popupNormal = require('popup.PopupNormalLevel')
        local layer = popupNormal.create(levelKey)
        s_SCENE:popup(layer)
    elseif levelConfig['type'] == 1 then -- summaryboss level
        -- check whether summary boss level can be played (starcount)
        if s_CURRENT_USER:getUserBookObtainedStarCount() >= levelConfig['summary_boss_stars'] + s_DATA_MANAGER.getSummaryBossIncrementsOfChapter('chapter1') then
            local popupSummary = require('popup.PopupSummarySuccess')
            local layer = popupSummary.create(levelKey, s_CURRENT_USER:getUserBookObtainedStarCount(),levelConfig['summary_boss_stars'] + s_DATA_MANAGER.getSummaryBossIncrementsOfChapter('chapter1'))
            s_SCENE:popup(layer)
    else
        local popupSummary = require('popup.PopupSummaryFail')
        local layer = popupSummary.create(s_CURRENT_USER:getUserBookObtainedStarCount(),levelConfig['summary_boss_stars'] + s_DATA_MANAGER.getSummaryBossIncrementsOfChapter('chapter1'))
        s_SCENE:popup(layer)
    end
    end
end

return LevelLayerII