require("cocos.init")
require('common.global')

s_chapter_resource_start_type = "start"
s_chapter_resource_middle_type = "middle" 
s_chapter_resource_end_type = "end"
s_chapter0_base_height = 3014
s_chapter_layer_width = 854

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

local ChapterLayerBase = class('ChapterLayerBase',function() 
    return ccui.Widget:create()
    --return cc.Layer:create()
end)

function ChapterLayerBase.create(chapterKey, startLevelKey)
    local layer = ChapterLayerBase.new(chapterKey, startLevelKey)
    return layer
end


function ChapterLayerBase:ctor(chapterKey, startLevelKey)
    self.chapterKey = chapterKey
    self.startLevelKey = startLevelKey
    self.levelPos = {}
end

function ChapterLayerBase:getLevelPosition(levelKey)
    for k, v in pairs(self.levelPos) do
        if string.sub(levelKey, 6) - k == 0 then
            return v
        end
    end
end

--t[1]: res
--t[2]: anchorPoint
--t[3]: position
function ChapterLayerBase:createObjectForResource(t)
    local object
    if t[1]~=nil then 
        if t[4] ~=nil and t[4]=='island' then
            -- define touchEvent
            local function touchEvent(sender,eventType)
                if eventType == ccui.TouchEventType.ended then
                    print('levelbutton '..sender.getName()..' touched...')
                end
            end
            print('create level button')
            object = ccui.Button:create(t[1],t[1],t[1])
            object:setScale9Enabled(true)
            object:setName(t[5])
            object:addTouchEventListener(touchEvent)
        else
            object = cc.Sprite:create(t[1])
        end
        
        if t[2]~=nil then 
            object:setAnchorPoint(t[2].x,t[2].y)
        end

        if t[3]~=nil then
            object:setPosition(t[3].x,t[3].y)
        end
--        if t[4]~=nil and t[4]== "island" then
--            object:setTag(islandTag)
--            islandTag=islandTag + 1
--        end
        if t[4] ~= nil then
            if t[4] == "back" then
                self:addChild(object,40)
            elseif t[4] == "add" then
                self:addChild(object,45)
            end
        else
            self:addChild(object,50)
        end
    end
    return object
end

function ChapterLayerBase:plotUnlockLevelAnimation(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local lockSprite = self:getChildByName('lock'..levelIndex)
    local lockLayer = self:getChildByName('lockLayer'..levelIndex)
    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),2)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0))  
    local action6 = cc.FadeOut:create(0.1)
    local action = cc.Sequence:create(action1, action4, action5, action6, nil)
    if lockSprite ~= nil then
        lockSprite:runAction(action)
    end

    local action7 = cc.DelayTime:create(0.6)
    local action8 = cc.FadeOut:create(0.1)
    if lockLayer ~= nil then
        lockLayer:runAction(cc.Sequence:create(action7, action8))
    end
    if lockSprite ~= nil or lockLayer ~= nil then
        s_SCENE:callFuncWithDelay(0.7,function()
            self:plotDecorationOfLevel(levelIndex-0)
        end)
    end
end

function ChapterLayerBase:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end


function ChapterLayerBase:plotDecorationOfLevel(levelIndex)
    local levelPosition = self.levelPos[levelIndex]
    
    -- define touchEvent
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print('BaseLayer:levelbutton '..sender:getName()..' touched...')                
            self:addPopup(sender:getName())
--              self:checkLevelStateBeforePopup(sender:getName())
            
        end
    end

    local levelButton = ccui.Button:create('image/chapter/chapter0/island.png','image/chapter/chapter0/island.png','image/chapter/chapter0/island.png')
    levelButton:setScale9Enabled(true)
    levelButton:setPosition(levelPosition)
    levelButton:setName(levelIndex)
    levelButton:addTouchEventListener(touchEvent)
    self:addChild(levelButton, 129)
    

    local currentIndex = levelIndex
    -- to do get level state
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local levelState, coolingDay
    local currentTaskBossIndex = -1
    for bossID, bossInfo in pairs(bossList) do
        if bossInfo["coolingDay"] + 0 == 0 and currentTaskBossIndex == -1 and bossInfo["typeIndex"] - 8 < 0 then
            currentTaskBossIndex = bossID - 1
        end
        if bossID - (levelIndex + 1) == 0 then
            levelState = bossInfo["typeIndex"] 
            coolingDay = bossInfo["coolingDay"] + 0
        end
    end
    
    -- check active
--    local todayReviewBoss = s_LocalDatabaseManager.getTodayReviewBoss()
--    local active
--    if #todayReviewBoss == 0 or todayReviewBoss[0] - (levelIndex + 1) ~= 0 then
--        active = 0
--    else
--        active = 1
--    end
--    print('####active'..active..','..levelState)
--    if levelConfig['type'] == 1 then
    local currentProgress = s_CURRENT_USER.levelInfo:computeCurrentProgress() + 0
    local currentChapterKey = 'chapter'..math.floor(currentProgress/10)


    if levelState == 0 then
        local deco = sp.SkeletonAnimation:create("spine/chapterlevel/beibeidaizi.json","spine/chapterlevel/beibeidaizi.atlas",1)
        deco:setPosition(levelPosition.x-60,levelPosition.y-10)
        deco:setAnchorPoint(1,1)
        deco:addAnimation(0, 'animation', true)
        self:addChild(deco, 130)
        -- local deco = cc.Sprite:create('image/chapter/elements/tubiao_daizi_tanchu_xiaoguan.png')
        -- deco:setPosition(levelPosition.x,levelPosition.y+20)
        -- self:addChild(deco, 130)
    elseif levelState == 1 then
        local deco = cc.Sprite:create('image/chapter/elements/tubiao_chuizi_tanchu_xiaoguan.png')
        deco:setPosition(levelPosition.x,levelPosition.y+20)
        self:addChild(deco, 130)
        if s_level_popup_state ~= 0 then
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/beibeidaizi.json","spine/chapterlevel/beibeidaizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
            deco:runAction(cc.FadeOut:create(1.0));
            self:callFuncWithDelay(0.5, function()
                local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
                deco:setPosition(levelPosition.x-60,levelPosition.y-10)
                deco:setAnchorPoint(1,1)
                deco:addAnimation(0, 'animation', true)
                self:addChild(deco, 130)
            end)
        else
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
        end


    elseif levelState == 2 or (levelState >= 4 and levelIndex == currentTaskBossIndex) then
        if s_level_popup_state ~= 0 and levelState < 4 then
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
            deco:runAction(cc.FadeOut:create(1.0))
            self:callFuncWithDelay(0.5, function()
                local reviewBoss = sp.SkeletonAnimation:create('spine/3 fxzlsxuanxiaoguandiaoluo1.json', 'spine/3 fxzlsxuanxiaoguandiaoluo1.atlas', 1)
                reviewBoss:addAnimation(1, '2', true)   
                reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
                self:addChild(reviewBoss, 140)
            end)
        else
            local reviewBoss = sp.SkeletonAnimation:create('spine/3 fxzlsxuanxiaoguandiaoluo1.json', 'spine/3 fxzlsxuanxiaoguandiaoluo1.atlas', 1)
            reviewBoss:addAnimation(1, '2', true)   
            reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
            self:addChild(reviewBoss, 140)
        end
        -- only one review boss
    elseif levelState == 3 then 
        if s_level_popup_state ~= 0 then
            -- local reviewBoss = sp.SkeletonAnimation:create('spine/3 fxzlsxuanxiaoguandiaoluo1.json', 'spine/3 fxzlsxuanxiaoguandiaoluo1.atlas', 1)
            -- reviewBoss:addAnimation(1, '2', true)   
            -- reviewBoss:setPosition(levelPosition.x-110, levelPosition.y-80)
            -- self:addChild(reviewBoss, 140)
            -- reviewBoss:setAnchorPoint(0.5,0.5)
            -- -- reviewBoss:runAction(cc.FadeOut:create(1.0))
            -- local action1 = cc.RotateBy:create(0.5, 360)
            -- local action2 = cc.MoveBy:create(0.5, cc.p(250, 800))
            -- local action3 = cc.ScaleTo:create(0.5, 0.75)
            -- local action4 = cc.Spawn:create(action1, action2, action3)
            -- reviewBoss:runAction(action4)
            -- self:callFuncWithDelay(0.4, function() 
            --     reviewBoss:runAction(cc.FadeOut:create(0.2))
            -- end)
            local deco = sp.SkeletonAnimation:create("spine/chapterlevel/chuizi.json","spine/chapterlevel/chuizi.atlas",1)
            deco:setPosition(levelPosition.x-60,levelPosition.y-10)
            deco:setAnchorPoint(1,1)
            deco:addAnimation(0, 'animation', true)
            self:addChild(deco, 130)
            deco:runAction(cc.FadeOut:create(1.0))
            self:callFuncWithDelay(0.5, function()
                local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
                summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
                summaryboss:setAnchorPoint(1,1)
                summaryboss:addAnimation(0, 'jianxiao', true)
                summaryboss:setScale(0.7)
                self:addChild(summaryboss, 140)
            end)
        else
            local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
            summaryboss:setPosition(levelPosition.x-100,levelPosition.y-50)
            summaryboss:setAnchorPoint(1,1)
            summaryboss:addAnimation(0, 'jianxiao', true)
            summaryboss:setScale(0.7)
            self:addChild(summaryboss, 140)
        end
    else
        -- plot level number
        self:plotLevelNumber('level'..levelIndex)
    end
end

function ChapterLayerBase:checkLevelStateBeforePopup(levelIndex)
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    local state, coolingDay
    for bossID, bossInfo in pairs(bossList) do
        if bossID - (levelIndex + 1) == 0 then
            state = bossInfo["typeIndex"] + 0
            coolingDay = bossInfo["coolingDay"] + 0
        end
    end
    
    if state >= 4 and active ~= 0 then
        local WordLibrary = require("view.islandPopup.WordLibraryPopup")
        local wordLibrary = WordLibrary.create(levelIndex)
        s_SCENE.popupLayer:addChild(wordLibrary)   
        back:runAction(cc.MoveBy:create(0.2,cc.p(800,0)))
        wordLibrary.close = function ()
            back:runAction(cc.MoveBy:create(0.2,cc.p(-800,0)))
        end
    else
        self:addPopup(levelIndex)
    end
end

function ChapterLayerBase:addPopup(levelIndex,isAnimation)
    local LevelProgressPopup = require("view.islandPopup.LevelProgressPopup")
    local levelProgressPopup = LevelProgressPopup.create(levelIndex + 1,isAnimation)
    s_SCENE:popup(levelProgressPopup)  
end

function ChapterLayerBase:plotDecoration()
    local levelInfo = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey)
    local currentLevelIndex = levelInfo
    local currentChapterIndex = math.floor(levelInfo / s_islands_per_page)
    local chapterIndex = string.sub(self.chapterKey, 8)
    -- add state information
    
    for levelIndex, levelPosition in pairs(self.levelPos) do
        -- add level button
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                local levelIndex = string.sub(sender:getName(), 10)
                local lockSprite = self:getChildByName('lock'..levelIndex)
                local lockLayer = self:getChildByName('lockLayer'..levelIndex)
                local action1 = cc.ScaleTo:create(0.12, 1.15, 0.85)
                local action2 = cc.ScaleTo:create(0.12, 0.85, 1.15)
                local action3 = cc.ScaleTo:create(0.12, 1.08, 0.92)
                local action4 = cc.ScaleTo:create(0.12, 0.92, 1.08)
                local action5 = cc.ScaleTo:create(0.12, 1.0, 1.0)
                local action6 = cc.Sequence:create(action1, action2, action3, action4, action5, nil)

                local l1 = cc.MoveBy:create(0.1, cc.p(10,0))
                local l2 = cc.MoveBy:create(0.1, cc.p(-20,0))
                local l3 = cc.MoveBy:create(0.1, cc.p(20,0))

                local l4 = cc.Repeat:create(cc.Sequence:create(l2, l3),3)
                local l5 = cc.MoveBy:create(0.1, cc.p(-10, 0))
                lockSprite:runAction(cc.Sequence:create(l1,l4, l5,nil))
                lockLayer:runAction(action6)
            end
        end
        if (levelIndex - currentLevelIndex) > 0 then
            -- local lockIsland = cc.Sprite:create('image/chapter/chapter0/lockisland2.png')
            -- lockIsland:setName('lockLayer'..levelIndex)
            -- lockIsland:addTouchEventListener(touchEvent)

            local lockIsland = ccui.Button:create('image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png')
            lockIsland:setScale9Enabled(true)
            lockIsland:setName('lockLayer'..levelIndex)
            lockIsland:addTouchEventListener(touchEvent)

            local lock = cc.Sprite:create('image/chapter/chapter0/lock.png')
            lock:setName('lock'..levelIndex)
            lockIsland:setPosition(levelPosition)
            -- lock:setPosition(lockIsland:getContentSize().width/2, lockIsland:getContentSize().height/2)
            lock:setPosition(levelPosition)
            self:addChild(lock,130)
            self:addChild(lockIsland,120)
        else
            self:plotDecorationOfLevel(levelIndex)
        end  
    end
end

function ChapterLayerBase:plotLevelNumber(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelPosition = self:getLevelPosition(levelKey)
    local chapterIndex = string.sub(self.chapterKey, 8)
--    if levelIndex - 0 == 0 and chapterIndex - 0 == 0 then  -- start 
--        local start = cc.Sprite:create('image/chapter/chapter0/start.png')
--        start:setPosition(levelPosition.x, levelPosition.y)
--        self:addChild(start, 130)
--    else
        local number = ccui.TextBMFont:create()
        number:setFntFile('font/number_inclined.fnt')
        --number:setColor(cc.c3b(56,26,23))
        number:setString(levelIndex+1)
        number:setPosition(levelPosition.x-5, levelPosition.y+10)
        self:addChild(number,130)
--    end

 
end

function ChapterLayerBase:loadResource()
end

return ChapterLayerBase
