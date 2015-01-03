require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")

require("view.level.LevelLayerI")
require("view.level.LevelLayerII")
require("view.level.RepeatLevelLayer")


local LevelLayer = class("LevelLayer", function()
    return cc.Layer:create()
end)

local listView
local player
local levelLayerI
local levelLayerII
local item1
local connection1_2
local item2
local connection2_3
local item3
local currentChapterLayer

function LevelLayer.create()
    local layer = LevelLayer.new()
    return layer
end

function LevelLayer:levelStateManager()
    -- set levelState if relogin after logout
    if s_SCENE.levelLayerState == s_normal_level_state then
        local currentLevelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        if currentLevelData.stars > 0 then  -- set unlock next level state
            s_SCENE.levelLayerState = s_unlock_normal_notPlotInfo_state
        end
    end
    -- test
    --s_CURRENT_USER:initLevels()
    -- check current chapter
    self:updateCurrentChapterLayer()
    -- CHECK unlock chapter state
    if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
        local chapterConfig = s_DATA_MANAGER.getChapterConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentChapterKey)
        if s_CURRENT_USER.currentLevelKey == chapterConfig[#chapterConfig]['level_key'] then
            s_SCENE.levelLayerState = s_unlock_next_chapter_state
        end
    end
    
--    print('state0:'..s_SCENE.levelLayerState)
    -- TODO Check Review boss state
    local reviewBossId = s_DATABASE_MGR.getCurrentReviewBossID()
    if reviewBossId ~= -1 then
        -- check whether current level is passed
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
--        print('levelData.stars'..levelData.stars)
        if levelData.stars > 0 then
            if s_SCENE.levelLayerState ~= s_review_boss_appear_state 
                and s_SCENE.levelLayerState ~= s_review_boss_pass_state then
                if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
                    currentChapterLayer:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
                    s_SCENE.levelLayerState = s_review_boss_appear_state
                    Analytics_reviewBoss()
                end
                
            end
        end
    end

    
    -- CHECK tutorial review boss
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
--    print('tutuorial step:'..s_CURRENT_USER.reviewBossTutorialStep)
--    print_lua_table(levelData)
    if levelData ~= nil and s_CURRENT_USER.currentLevelKey == 'level0' and levelData.stars > 0 and s_SCENE.levelLayerState ~= s_review_boss_pass_state and s_CURRENT_USER.reviewBossTutorialStep == 0 then
        s_SCENE.levelLayerState = s_review_boss_appear_state
        currentChapterLayer:plotLevelDecoration(s_CURRENT_USER.currentLevelKey)
    end

    -- TODO switch state
--         s_SCENE.levelLayerState = s_unlock_next_chapter_state
    --    s_CURRENT_USER.currentChapterKey = 'chapter1'
--    print('state!!!!!!!!!!!!!!!:'..s_SCENE.levelLayerState)
    if s_SCENE.levelLayerState == s_normal_level_state then
        print(s_SCENE.levelLayerState)
    elseif s_SCENE.levelLayerState == s_normal_retry_state then
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        s_SCENE:callFuncWithDelay(0.3,function()
            currentChapterLayer:onLevelButtonClicked(s_CURRENT_USER.currentSelectedLevelKey) 
            s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
        end)
    elseif s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
        -- lock screen and plot animation
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        
        -- TODO check the unlock state
        s_SCENE:callFuncWithDelay(3.9, function()
            s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
        end)
        -- plot star animation
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        currentChapterLayer:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
        
        -- save and update level data
        --s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        s_CURRENT_USER.currentSelectedLevelKey = s_CURRENT_USER.currentLevelKey
        s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey, 1)
        -- plot unlock next level animation
        self:updateCurrentChapterLayer()
        currentChapterLayer:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
        -- plot player animation
        s_SCENE:callFuncWithDelay(1.3,function()
            local targetPosition = currentChapterLayer:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(0.8, targetPosition)
            player:runAction(action)      
        end)
        
        -- update level state and plot popup(call on level button clicked)
        if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
            s_SCENE:callFuncWithDelay(3,function()
                currentChapterLayer:onLevelButtonClicked(s_CURRENT_USER.currentLevelKey)
            end)
        end
        s_SCENE.levelLayerState = s_normal_level_state
        
        -- TODO CHECK level index valid
        
        s_SCENE:callFuncWithDelay(3,function()
            local currentLevelButton = currentChapterLayer:getChildByName(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(1, cc.p(currentLevelButton:getPosition()))
            player:runAction(action)
        end
        )
     elseif s_SCENE.levelLayerState == s_review_boss_appear_state then
        currentChapterLayer:plotReviewBossAppearOnLevel('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
     elseif s_SCENE.levelLayerState == s_review_boss_retry_state then
        currentChapterLayer:plotReviewBossAppearOnLevel('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        s_SCENE:callFuncWithDelay(1.5,function()
            currentChapterLayer:onLevelButtonClicked('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
            s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
        end)
     elseif s_SCENE.levelLayerState == s_review_boss_pass_state then
        --currentChapterLayer:plotReviewBossPassOnLevel('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
        -- save and update level data
        --s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        s_CURRENT_USER.currentSelectedLevelKey = s_CURRENT_USER.currentLevelKey
        s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey, 1)
        -- plot unlock level animation
        self:updateCurrentChapterLayer()
        currentChapterLayer:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
        -- plot player animation
        s_SCENE:callFuncWithDelay(1.3,function()
            local targetPosition = currentChapterLayer:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(0.8, targetPosition)
            player:runAction(action)      
        end)

        -- update level state and plot popup(call on level button clicked)
        --if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
            s_SCENE:callFuncWithDelay(3,function()
                currentChapterLayer:onLevelButtonClicked(s_CURRENT_USER.currentLevelKey)
            end)
        --end
        s_SCENE.levelLayerState = s_normal_level_state
        if s_CURRENT_USER.reviewBossTutorialStep == 0 then
            s_CURRENT_USER.reviewBossTutorialStep = 1
        end
     elseif s_SCENE.levelLayerState == s_unlock_next_chapter_state then
        s_SCENE.levelLayerState = s_normal_level_state
        if s_CURRENT_USER.currentChapterKey ~= 'chapter3' then
            -- lock screen and plot animation
            s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
            s_SCENE:callFuncWithDelay(1.5, function()
                s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
            end)
            -- plot star animation
            local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
            currentChapterLayer:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
    
            -- save and update level data
            --s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
            s_CURRENT_USER.currentChapterKey = 'chapter'..(string.sub(s_CURRENT_USER.currentChapterKey,8)+1)
            s_CURRENT_USER.currentSelectedChapterKey = s_CURRENT_USER.currentChapterkey
            s_CURRENT_USER.currentLevelKey = 'level0'
            s_CURRENT_USER.currentSelectedLevelKey = s_CURRENT_USER.currentLevelKey
            s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey, 1)
            -- plot unlock next level animation
            if s_CURRENT_USER.currentChapterKey == 'chapter1' then
                self.chapterDic['connection0_1']:plotUnlockChapterAnimation()
            elseif s_CURRENT_USER.currentChapterKey == 'chapter2' then
                self.chapterDic['connection1_2']:plotUnlockChapterAnimation()
            elseif s_CURRENT_USER.currentChapterKey == 'chapter3' then
                self.chapterDic['connection2_3']:plotUnlockChapterAnimation()
            end
            self:updateCurrentChapterLayer()
            currentChapterLayer:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
            player:removeFromParent()
            player = cc.Sprite:create('image/chapter_level/gril_head.png')
            player:setPosition(currentChapterLayer:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey))
            player:setScale(0.4)
            currentChapterLayer:addChild(player, 5)
        end
     end
     s_SCENE.gameLayerState = s_normal_game_state
     s_CURRENT_USER:updateDataToServer()
end

function LevelLayer:updateCurrentChapterLayer()
    if s_CURRENT_USER.currentChapterKey == 'chapter0' then
        currentChapterLayer = self.chapterDic['chapter0']
    elseif s_CURRENT_USER.currentChapterKey == 'chapter1' then
        currentChapterLayer = self.chapterDic['chapter1']
    elseif s_CURRENT_USER.currentChapterKey == 'chapter2' then
        chapterDicKey = 'chapter2_'..(math.floor(string.sub(s_CURRENT_USER.currentLevelKey, 6) / 10))
        currentChapterLayer = self.chapterDic[chapterDicKey]
    elseif s_CURRENT_USER.currentChapterKey == 'chapter3' then
        chapterDicKey = 'chapter3_'..(math.floor(string.sub(s_CURRENT_USER.currentLevelKey, 6) / 10))
        currentChapterLayer = self.chapterDic[chapterDicKey]
    end
end

function LevelLayer:getItemByName(listView, itemName)
    local itemList = listView:getItems()
    for i = 1,#itemList do
        if itemList[i]:getName() == itemName then
            return itemList[i]
        end
    end
    return nil
end

-- scroll listview to show current level
function LevelLayer:scrollLevelLayer(chapterKey, levelKey)
--    chapterKey = 'chapter2'
--    levelKey = 'level25'
    -- compute listView inner height
    local itemList = listView:getItems()
    local innerHeight = 0
    for i = 1,#itemList do
        innerHeight = innerHeight + itemList[i]:getContentSize().height
    end
--    print('innerHeight:'..innerHeight)
    listView:setInnerContainerSize(cc.size(itemList[1]:getContentSize().width, innerHeight))
    
    local chapterConfig = s_DATA_MANAGER.getChapterConfig(s_CURRENT_USER.bookKey,chapterKey)
    if chapterKey == 'chapter0' then
        local item0 = self.chapterDic['chapter0']
        local currentVerticalPercent = (string.sub(levelKey,6)+1)/#chapterConfig * item0:getContentSize().height / innerHeight * 100 -2
        print('currentScroll Percent:'..currentVerticalPercent)
        listView:scrollToPercentVertical(currentVerticalPercent,0,false)
        listView:setInertiaScrollEnabled(true)
    elseif chapterKey == 'chapter1' then
        local item0 = self.chapterDic['chapter0']
        local connection0_1 = self.chapterDic['connection0_1']
        local item1 = self.chapterDic['chapter1']
        local currentVerticalPercent =(item0:getContentSize().height+connection0_1:getContentSize().height+ (string.sub(levelKey,6)+1)/#chapterConfig * item1:getContentSize().height) / innerHeight * 100

        print('currentScroll Percent:'..currentVerticalPercent)
        listView:scrollToPercentVertical(currentVerticalPercent,0,false)
        listView:setInertiaScrollEnabled(true)
    elseif chapterKey == 'chapter2' then
        local item0 = self.chapterDic['chapter0']
        local connection0_1 = self.chapterDic['connection0_1']
        local item1 = self.chapterDic['chapter1']
        local connection1_2 = self.chapterDic['connection1_2']
        local upHeight = item0:getContentSize().height+connection0_1:getContentSize().height+item1:getContentSize().height+connection1_2:getContentSize().height
        -- update upHeight seperately (chapter2 is splited into 3 parts)
        local chapterConfig = s_DATA_MANAGER.getChapterConfig(s_CURRENT_USER.bookKey,'chapter2')
        
        local item2 = self.chapterDic['chapter2_'..math.floor(string.sub(levelKey, 6) / 10)]
        local currentVerticalPercent =(upHeight+ (string.sub(levelKey,6)+1)/#chapterConfig * item2:getContentSize().height * #chapterConfig/10) / innerHeight * 100

        print('currentScroll Percent:'..currentVerticalPercent)
        listView:scrollToPercentVertical(currentVerticalPercent,0,false)
        listView:setInertiaScrollEnabled(true)
    elseif chapterKey == 'chapter3' then
        local item0 = self.chapterDic['chapter0']
        local connection0_1 = self.chapterDic['connection0_1']
        local item1 = self.chapterDic['chapter1']
        local connection1_2 = self.chapterDic['connection1_2']
        local upHeight = item0:getContentSize().height+connection0_1:getContentSize().height+item1:getContentSize().height+connection1_2:getContentSize().height
        local chapterConfig2 = s_DATA_MANAGER.getChapterConfig(s_CURRENT_USER.bookKey,'chapter2')
        upHeight = upHeight + self.chapterDic['chapter2_0']:getContentSize().height * #chapterConfig2 / 10
        local chapterConfig3 = s_DATA_MANAGER.getChapterConfig(s_CURRENT_USER.bookKey,'chapter3')

        local item3 = self.chapterDic['chapter3_'..math.floor(string.sub(levelKey, 6) / 10)]
        local currentVerticalPercent =(upHeight+ (string.sub(levelKey,6)+1)/#chapterConfig3 * item3:getContentSize().height * #chapterConfig3/10) / innerHeight * 100 + 3
        print('currentScroll Percent:'..currentVerticalPercent)
        listView:scrollToPercentVertical(currentVerticalPercent,0,false)
        listView:setInertiaScrollEnabled(true)
    end
end

function LevelLayer:manageListViewItem(itemName, command)
    if itemName == 'chapter0' then
        if command == 'add' then       
            --local levelStypeI = require('view.level.LevelLayerI')
            --levelLayerI = levelStypeI.create()
            -- add list view item1
            item1 = ccui.Layout:create()
            item1:setContentSize(levelLayerI:getContentSize())  
            item1:setName('chapter0')  
            levelLayerI:setPosition(cc.p(0, 0))
            listView:insertCustomItem(levelLayerI,0)
            --listView:insert
        elseif command == 'delete' then
            local index = listView:getIndex(item1)
            listView:removeItem(index)
        end
    end
end



function LevelLayer:addChapterIntoListView(chapterKey)  -- chapter3, 4, 5,6,7
    local chapterConfig = s_DATA_MANAGER.getChapterConfig(s_CURRENT_USER.bookKey,chapterKey)
    --local chapterIndex = string.sub(chapterKey, 8)
    if chapterKey == 'chapter0' then    
        local levelStypeI = require('view.level.LevelLayerI')
        self.chapterDic['chapter0'] = levelStypeI.create()
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic['chapter0']:getContentSize())  
        custom_item:setName('chapter0')  
        self.chapterDic['chapter0']:setPosition(cc.p(0, 0))
        listView:insertCustomItem(self.chapterDic['chapter0'],0)
    elseif chapterKey == 'chapter1' then
        -- add connection 
        local connectionLayer0_1 = require('view.level.connection.Connection0_1')
        self.chapterDic['connection0_1'] = connectionLayer0_1.create()
        if string.sub(s_CURRENT_USER.currentChapterKey,8) - string.sub(chapterKey, 8) >= 0 then
            self.chapterDic['connection0_1']:plotUnlockChapterAnimation()
        end
        local item0_1 = ccui.Layout:create()
        item0_1:setContentSize(self.chapterDic['connection0_1']:getContentSize())
        self.chapterDic['connection0_1']:setPosition(cc.p(0,0))
        item0_1:addChild(self.chapterDic['connection0_1'])
        listView:insertCustomItem(item0_1,1)
        local levelStypeII = require('view.level.LevelLayerII')
        self.chapterDic['chapter1'] = levelStypeII.create()
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic['chapter1']:getContentSize())  
        custom_item:setName('chapter1')  
        self.chapterDic['chapter1']:setPosition(cc.p(0, 0))
        listView:insertCustomItem(self.chapterDic['chapter1'],2)
    elseif chapterKey == 'chapter2' then
        local connectionLayer1_2 = require('view.level.connection.Connection1_2')
        self.chapterDic['connection1_2'] = connectionLayer1_2.create()
        if string.sub(s_CURRENT_USER.currentChapterKey,8) - string.sub(chapterKey, 8) >= 0 then
            self.chapterDic['connection1_2']:plotUnlockChapterAnimation()
        end
        local item1_2 = ccui.Layout:create()
        item1_2:setContentSize(self.chapterDic['connection1_2']:getContentSize())
        self.chapterDic['connection1_2']:setPosition(cc.p(0,0))
        item1_2:addChild(self.chapterDic['connection1_2'])
        listView:insertCustomItem(item1_2,3)
        for i = 1, #chapterConfig / 10 do
            local levelStyle3 = require('view.level.RepeatLevelLayer')
            self.chapterDic[chapterKey..'_'..(i-1)] = levelStyle3.create(chapterKey,'level'..((i-1)*10))
            self.chapterDic[chapterKey..'_'..(i-1)]:setPosition(cc.p(0,0))
            local item = ccui.Layout:create()
            item:setContentSize(self.chapterDic[chapterKey..'_'..(i-1)]:getContentSize())
            item:addChild(self.chapterDic[chapterKey..'_'..(i-1)])
            item:setName(chapterKey..'_'..(i-1))
            listView:insertCustomItem(item,3+i)
        end
    else -- chapter3
        local chapterIndex = string.sub(chapterKey, 8)
        local connectionLayer_repeat = require('view.level.connection.Connection_repeat')
        self.chapterDic['connection'..(chapterIndex-1)..'_'..chapterIndex] = connectionLayer_repeat.create()
        if string.sub(s_CURRENT_USER.currentChapterKey,8) - string.sub(chapterKey, 8) >= 0 then
            self.chapterDic['connection'..(chapterIndex-1)..'_'..chapterIndex]:plotUnlockChapterAnimation()
        end
        local item_connection = ccui.Layout:create()
        item_connection:setContentSize(self.chapterDic['connection'..(chapterIndex-1)..'_'..chapterIndex]:getContentSize())
        self.chapterDic['connection'..(chapterIndex-1)..'_'..chapterIndex]:setPosition(cc.p(0,0))
        item_connection:addChild(self.chapterDic['connection'..(chapterIndex-1)..'_'..chapterIndex])
        listView:addChild(item_connection)
        for i = 1, #chapterConfig / 10 do
            local levelStyle3 = require('view.level.RepeatLevelLayer')
            self.chapterDic[chapterKey..'_'..(i-1)] = levelStyle3.create(chapterKey,'level'..((i-1)*10))
            self.chapterDic[chapterKey..'_'..(i-1)]:setPosition(cc.p(0,0))
            local item = ccui.Layout:create()
            item:setContentSize(self.chapterDic[chapterKey..'_'..(i-1)]:getContentSize())
            item:addChild(self.chapterDic[chapterKey..'_'..(i-1)])
            item:setName(chapterKey..'_'..(i-1))
            listView:addChild(item)
        end
    end
    
end

function LevelLayer:ctor()
    self.chapterDic = {}  -- container of chapter layers
    
    --local levelStypeI = require('view.level.LevelLayerI')
    --local levelStypeII = require('view.level.LevelLayerII')
    --local connectionLayer1_2 = require('view.level.connection.Connection1_2')
    --local connectionLayer2_3 = require('view.level.connection.Connection2_3')
    --levelLayerI = levelStypeI.create()
    --levelLayerII = levelStypeII.create()
    --connection1_2 = connectionLayer1_2.create()
    --connection2_3 = connectionLayer2_3.create()
    --connection1_2:plotUnlockChapterAnimation()
    --connection2_3:plotUnlockChapterAnimation()
    --self.chapterDic['chapter0'] = levelLayerI
    --self.chapterDic['chapter1'] = levelLayerII
    --self.chapterDic['connection0_1'] = connection1_2
    --self.chapterDic['connection1_2'] = connection2_3
--    s_CURRENT_USER.currentChapterKey = 'chapter1'
--    s_CURRENT_USER.currentLevelKey = 'level3'
    --s_SCENE.levelLayerState = s_unlock_next_chapter_state

    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
            print("select child index = ",sender:getCurSelectedIndex())
            local curItemName = sender:getItem(sender:getCurSelectedIndex()):getName()
            print('curItemName'..curItemName)
            
--            if curItemName == 'chapter1' then
--                connection1_2:plotUnlockChapterAnimation()
--                self:manageListViewItem('chapter0','delete')
--            elseif curItemName == 'chapter2' then
--                self:manageListViewItem('chapter0','add')
--            end
        end
    end

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            print("SCROLL_TO_BOTTOM")
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            print("SCROLL_TO_TOP")
        elseif evenType == ccui.ScrollviewEventType.scrolling then
            --print('SCROLLING:'..sender:getPosition())
        end
    end  
    -- create list view
    listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
--    local fullWidth = levelLayerI:getContentSize().width
--    listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
--    listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    listView:addEventListener(listViewEvent)
    listView:addScrollViewEventListener(scrollViewEvent)
    listView:removeAllChildren()
    self:addChild(listView)
  
    --self:manageListViewItem('chapter0','add')
    self:addChapterIntoListView('chapter0')
    self:addChapterIntoListView('chapter1')
    self:addChapterIntoListView('chapter2')
    self:addChapterIntoListView('chapter3')
    local fullWidth = self.chapterDic['chapter0']:getContentSize().width
    listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    -- add list view connection 
--    local item1_2 = ccui.Layout:create()
--    item1_2:setTouchEnabled(true)
--    item1_2:setContentSize(connection1_2:getContentSize())
--    connection1_2:setPosition(cc.p(0,0))
--    item1_2:addChild(connection1_2)
--    listView:addChild(item1_2)
    -- add list view item2
--    local item2 = ccui.Layout:create()
--    item2:setTouchEnabled(true)
--    item2:setContentSize(levelLayerII:getContentSize())  
--    levelLayerII:setPosition(cc.p(0, 0))
--    item2:addChild(levelLayerII)
--    item2:setName('chapter1')
--    listView:addChild(item2)
    -- add chapter3
--    local levelStyle3 = require('view.level.RepeatLevelLayer')
--    local levelLayer3 = levelStyle3.create('chapter3','level0')
--    levelLayer3:setPosition(cc.p(0,0))
--    local item3 = ccui.Layout:create()
--    item3:setContentSize(levelLayer3:getContentSize())
--    item3:addChild(levelLayer3)
--    listView:addChild(item3)
    -- add list view connection 
--    local item2_3 = ccui.Layout:create()
--    item2_3:setTouchEnabled(true)
--    item2_3:setContentSize(connection2_3:getContentSize())
--    connection2_3:setPosition(cc.p(0,0))
--    item2_3:addChild(connection2_3)
--    listView:addChild(item2_3)
    
    --self:addChapterIntoListView('chapter3')
    --self:addChapterIntoListView('chapter4')
    --self:addChapterIntoListView('chapter5')
    
    self:updateCurrentChapterLayer()
    self:scrollLevelLayer(s_CURRENT_USER.currentSelectedChapterKey,s_CURRENT_USER.currentSelectedLevelKey)
    
    -- plot player position
    player = cc.Sprite:create('image/chapter_level/gril_head.png')
    player:setPosition(currentChapterLayer:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey))
    player:setScale(0.4)
    currentChapterLayer:addChild(player, 5)
    
    -- level layer state manager
    self:levelStateManager()

    -- right top node

    local IntroLayer = require("view.hud.RightTopNode")
    local introLayer = IntroLayer.create()
    self:addChild(introLayer)
    
    local click_home = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local IntroLayer = require("view.home.HomeLayer")
            local introLayer = IntroLayer.create()  
            s_SCENE:replaceGameLayer(introLayer)
        end
    end
    
    
    -- return to homepage button
    local homeButton = ccui.Button:create("image/chapter_level/button_home_book.png","image/chapter_level/button_home_book.png","")
    homeButton:addTouchEventListener(click_home)
    homeButton:ignoreAnchorPointForPosition(false)
    homeButton:setAnchorPoint(0,1)
    homeButton:setPosition(s_LEFT_X + 50  , s_DESIGN_HEIGHT - 50 )
    homeButton:setLocalZOrder(1)
    self:addChild(homeButton)
    
    
--    -- pause call
--    
--    local click_pause = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            local IntroLayer = require("view/Pause")
--            local introLayer = IntroLayer.create()  
--            s_SCENE:popup(introLayer)
--
--            local action1 = cc.MoveTo:create(0.3, cc.p(0,-600))          
--            introLayer:runAction(action1)
--        end
--    end
--    
--    -- pause node
--    
--    local pauseButton = ccui.Button:create("image/button/pauseButtonWhite.png", "image/button/pauseButtonWhite.png", "")
--    pauseButton:addTouchEventListener(click_pause)
--    pauseButton:ignoreAnchorPointForPosition(false)
--    pauseButton:setAnchorPoint(0,0.5)
--    pauseButton:setPosition(s_LEFT_X  , s_DESIGN_HEIGHT - 100 )
--    pauseButton:setLocalZOrder(1)
--    self:addChild(pauseButton)

    -- level select "s_sound_bgm1"
    playMusic(s_sound_bgm1,true)
    
    
    
end
return LevelLayer