require("cocos.init")
require("common.global")

local SummaryBossAlter = require("view.summaryboss.SummaryBossAlter")
local Pause = require("view.Pause")

local FlipNode = require("view.mat.FlipNode")
local TapNode = require("view.mat.TapNode")
local PauseButton           = require("view.newreviewboss.NewReviewBossPause")

local SummaryBossLayer = class("SummaryBosslayer", function ()
    return cc.NodeGrid:create()
end)

local scale = 0.92
local dir_up    = 1
local dir_down  = 2
local dir_left  = 3
local dir_right = 4
local HINT_TIME = 10
local bullet_damage = 2

function SummaryBossLayer.create(wordList,type,entrance)   
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_summaryBoss)
    AnalyticsSummaryBoss()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    local layer = SummaryBossLayer.new()
    math.randomseed(os.time())
    --add coconut
    --layer.levelConfig = levelConfig
    layer.isTrying = false
    layer.isGuiding = false
    local chapter = type
    --if (s_CURRENT_USER.tutorialStep <= s_tutorial_summary_boss and entrance) then
    if chapter == 0 then
        layer.isTrying = true
        layer.isGuiding = true
        chapter = 1
    end
    layer.chapter = chapter
    layer.coconut = {}
    layer.isFirst = {}
    layer.firstNodeArray = {}
    layer.wordPool = {}
    layer.startIndexPool = {}
    layer.currentIndex = 1
    layer.crab = {}
    layer.ccbcrab = {}
    layer.hintTime = 0
    layer.isPaused = false
    layer.isHinting = false
    layer.currentHintWord = {false,false,false}
    layer.wordStack = {}
    layer.letterStack = {}
    layer.firstIndex = 1
    layer.combo = 0
    layer.leftTime = 0
    layer.useTime = 0
    layer.gameStart = false
    layer.useItem = false
    layer.entrance = entrance
    layer.wordList = wordList
    -- slide coco
    local slideCoco = {}
    slideCoco[1] = s_sound_slideCoconut
    slideCoco[2] = s_sound_slideCoconut1
    slideCoco[3] = s_sound_slideCoconut2
    slideCoco[4] = s_sound_slideCoconut3
    slideCoco[5] = s_sound_slideCoconut4
    slideCoco[6] = s_sound_slideCoconut5
    slideCoco[7] = s_sound_slideCoconut6
    
    local startAtNode

    local startTouchLocation
    local lastTouchLocation

    local startNode
    local selectStack = {}

    local killedCrabCount = 0
    layer.crabOnView = {}

    -- location function
    local onTouchBegan
    local onTouchMoved
    local fakeTouchMoved
    local onTouchEnded
    local time1 = os.clock()
    layer:initWordList(wordList)
    local time2 = os.clock()
    --print('initWordList time =='..time2 - time1)
    time1 = os.clock()
    layer:initBossLayer_back(chapter)
    time2 = os.clock()
    --print('initBosslayer time =='..time2 - time1)
    local isTouchEnded = true
    local endTime = 0
    local loadingTime = 0
    local loadingState = 0
    layer:initMapInfo()
    local light = cc.Sprite:create('image/studyscene/long_light.png')
    light:setAnchorPoint(0.5,0.05)
    layer:addChild(light,10)
    light:setVisible(false)  


    local function checkAnswer(checkAtOnce)
            
        layer.isPaused = false
        if layer.globalLock or not layer.gameStart then
            return
        end
        if layer.onCrab > 0 then

            layer:crabSmall(chapter,layer.onCrab)
            layer.onCrab = 0
        end
        if chapter == 2 then
            light:setVisible(false)
        end
        if #selectStack < 1 then
            return
        end
        
    
        --local location = layer:convertToNodeSpace(touch:getLocation())

        local selectWord = ""
        for i = 1, #selectStack do
            selectWord = selectWord .. selectStack[i].main_character_content
        end
        --check answer
        local match = false
        for i = 1, #layer.wordPool[layer.currentIndex] do
            if layer.crabOnView[i] then
                if selectWord == layer.wordPool[layer.currentIndex][i] then
                    if layer.isTutorial and layer.isTrying then
                        layer:stopTutorial()
                    end
                    playWordSound(selectWord)
                    killedCrabCount = killedCrabCount + 1
                    layer.rightWord = layer.rightWord + 1
                    layer.hintTime = 0
                    match = true
                    layer.globalLock = true
                    layer.crabOnView[i] = false
                    if i == layer.firstIndex then
                        local j = i
                        while j <= #layer.wordPool[layer.currentIndex] do
                            if layer.crabOnView[j] then
                                layer.firstIndex = j
                                break
                            end
                            j = j + 1
                        end
                        if j > #layer.wordPool[layer.currentIndex] then
                            layer.firstIndex = 1
                        end
                    end
                    
                    if layer.currentHintWord[i] or layer.rightWord > layer.maxCount then
                        bullet_damage = 1
                        layer:addMapInfo(selectWord)
                    else
                        bullet_damage = 2 + math.floor(layer.combo / 3)
                        local hasHint = false
                        for k = 1,#layer.currentHintWord do
                            hasHint = hasHint or (layer.currentHintWord[k] and layer.crabOnView[k])
                        end
                        if not hasHint then
                            layer.combo = layer.combo + 1
                            
                        else 
                            layer.combo = 0
                        end
                    end
                    if layer.rightWord > layer.maxCount then
                        layer.combo = 0
                    end
                    if layer.combo > 9 then
                        layer.combo = 9
                    end
                    if layer.combo > 0 then
                        local combo_pic = cc.Sprite:create('image/summarybossscene/combo_zongjieboss.png')
                            combo_pic:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
                            layer:addChild(combo_pic,100)
                            combo_pic:setOpacity(0)
                            combo_pic:setScale(0.8)
                            local action1 = cc.Spawn:create(cc.FadeIn:create(0.3),cc.ScaleTo:create(0.3,1))
                            local action2 = cc.Spawn:create(cc.EaseSineIn:create(cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH * 0.9,s_DESIGN_HEIGHT * 0.95 + 5))),cc.ScaleTo:create(0.5,0))
                            local action3 = cc.CallFunc:create(function (  )
                                combo_pic:removeFromParent()
                                layer.combo_back:setScale(1)
                                layer.combo_back:setOpacity(255)
                                layer.combo_back:runAction(cc.Spawn:create(cc.FadeTo:create(0.5,0),cc.ScaleTo:create(0.5,1.3)))
                                local icon_index = layer.combo + 3
                                local icon = layer.combo_icon[icon_index]
                                icon:setScale(1.3)
                                icon:runAction(cc.Spawn:create(cc.FadeTo:create(0.5,255),cc.EaseBackIn:create(cc.ScaleTo:create(0.5,1))))
                                s_SCENE:callFuncWithDelay(0.5,function (  )
                                    
                                    if layer.combo % 3 == 0 then
                                        local label1 = layer.combo_label[2 * layer.combo / 3 + 1]
                                        label1:setScale(1.3)
                                        local label2 = layer.combo_label[2 * layer.combo / 3 + 2]
                                        label2:setScale(1.3)
                                        label1:runAction(cc.Spawn:create(cc.FadeTo:create(0.5,255),cc.EaseBackIn:create(cc.ScaleTo:create(0.5,1))))
                                        label2:runAction(cc.Spawn:create(cc.FadeTo:create(0.5,255),cc.EaseBackIn:create(cc.ScaleTo:create(0.5,1))))
                                        layer.combo_label[2 * layer.combo / 3]:runAction(cc.Spawn:create(cc.FadeOut:create(0.5)))
                                        layer.combo_label[2 * layer.combo / 3 - 1]:runAction(cc.Spawn:create(cc.FadeOut:create(0.5)))
                                    end
                                end)
                            end)
                            combo_pic:runAction(cc.Sequence:create(action1,action2,action3))
                        
                    else
                        layer:clearCombo()
                    end
                    layer.currentBlood = layer.currentBlood - #selectStack * bullet_damage
                    
                    layer.boss.blood:setPercentage(100 * layer.currentBlood / layer.totalBlood)
                    --layer.boss:setAnimation(0,'a3',false)
                    layer.boss:addAnimation(0,'a2',false)
                    layer:crabSmall(chapter,i)
                    layer.crab[i]:runAction(cc.EaseBackIn:create(cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT * 0.2))))
                    
                    -- slide true
                    playSound(s_sound_learn_true)
                    -- beat boss sound
                    -- s_SCENE:callFuncWithDelay(0.3,function()
                    -- playSound(s_sound_FightBoss)       
                    -- end)

                    
                    local delaytime = 0
                    for j = 1, #selectStack do
                        local node = selectStack[j]
                        node.win()
                        local bullet = node.bullet
                        bullet:setVisible(true)
                        local randP = cc.p(60 + math.random(0,80),60 + math.random(0,80))
                        local bossPos = cc.p(layer.bossNode:getPositionX() + randP.x,layer.bossNode:getPositionY() + randP.y)
                        local bulletPos = cc.p(bullet:getPosition())
                        bossPos = cc.p(bossPos.x + 0 - bulletPos.x, bossPos.y + 0 - bulletPos.y)
                        local time = math.sqrt(bossPos.x * bossPos.x + bossPos.y * bossPos.y) / (1200*(1 + j * 0.1))
                        if time > 0.5 then
                            time = 0.5
                        end
                        if delaytime < time then
                            delaytime = time
                        end
                        local delay = cc.DelayTime:create(0.2 *math.pow(j,0.8))
                        local hit = cc.MoveBy:create(time,bossPos)
                        local hide = cc.Hide:create()
                        local attacked = cc.CallFunc:create(function() 
                            layer.boss:setAnimation(0,'a3',false)
                            playSound(s_sound_FightBoss)  
                            local damage_label = cc.Label:createWithSystemFont(string.format('%d',bullet_damage),'',36)
                            damage_label:enableOutline(cc.c4b(255,0,0,255),2)
                            damage_label:setColor(cc.c4b(255,0,0,255))
                            damage_label:setPosition(randP)
                            --damage_label:setOpacity(0)
                            local action1 = cc.Spawn:create(cc.MoveBy:create(0.2,cc.p(0,30)),cc.FadeOut:create(0.2))
                            local action2 = cc.CallFunc:create(function (  )
                                damage_label:removeFromParent()
                            end,{})
                            damage_label:runAction(cc.Sequence:create(action1,action2))
                            layer.boss:addChild(damage_label)
                        end,{})
                        local resume = cc.MoveTo:create(0.0,cc.p(bullet:getPosition()))
                        bullet:runAction(cc.Sequence:create(delay,hit,attacked,hide,resume))
                        s_SCENE:callFuncWithDelay(0.2 *math.pow(#selectStack,0.8),function (  )
                                -- body
                            local recover = cc.CallFunc:create(
                                function()
                                    if killedCrabCount > 0 and layer.globalLock then
                                        layer.globalLock = false
                                    end
                                    if chapter == 2 then
                                        node.removeSelectStyle()
                                        node:setScale(scale)
                                    else
                                        node.normal()
                                        node:setScale(scale)
                                    end
                                    
                                    
                                end,{}
                            )
                            node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),recover))
                            -- if layer.currentBlood <= 0 then
                            --     --layer.boss:stopAllActions()
                            --     local move = cc.MoveTo:create(0.5,cc.p(0.9 * s_DESIGN_WIDTH,1.1 * s_DESIGN_HEIGHT))
                            --     local mini = cc.ScaleTo:create(0.5,0.5)
                            --     local rotate = cc.RotateBy:create(0.5,360)
                            --     local fly = cc.Spawn:create(move,rotate)
                            --     local win = cc.CallFunc:create(function()
                                    
                            --         --layer.boss:removeFromParent()
                            --         layer:win(chapter,entrance,wordList)
                            --     end,{})
                            --     layer.boss:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),fly,win))
                                
                            -- end
                            if killedCrabCount == #layer.wordPool[layer.currentIndex] and layer.currentBlood > 0 then
                            --next group
                                layer.globalLock = true
                                layer.currentIndex = layer.currentIndex + 1
                                killedCrabCount = 0
                                for m = 1, layer.mat_length do
                                    for n = 1, layer.mat_length do
                                        local remove = cc.CallFunc:create(function() 
    --                                        layer.coconut[m][n]:removeFromParent(true)    
                                        end,{})
                                        layer.coconut[m][n]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT*0.7)),remove))
                                    end
                                end
                                layer:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function() 
                                    layer.currentHintWord = {false,false,false}
                                    layer:initMap(chapter)
                                end,{})))
                            end
                        end)
                    end
                    if layer.bubble[8]~= nil then
                        layer.bubble[8]:removeFromParent()
                        layer.bubble[8] = nil
                    end
                    if layer.currentBlood <= 0 then
                        s_SCENE:callFuncWithDelay(0.2 * math.pow(#selectStack,0.8),function()
                            layer.globalLock = true
                            layer.blink:stopAllActions()
                            --layer.boss:stopAllActions()
                            local move = cc.MoveTo:create(0.5,cc.p(0.9 * s_DESIGN_WIDTH,1.1 * s_DESIGN_HEIGHT))
                            local mini = cc.ScaleTo:create(0.5,0.5)
                            local rotate = cc.RotateBy:create(0.5,360)
                            local fly = cc.Spawn:create(move,rotate)
                            local win = cc.CallFunc:create(function()
                                
                                --layer.boss:removeFromParent()
                                layer:win(chapter,entrance,wordList)
                            end,{})
                            layer.boss:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),fly,win))
                        end)
                    else
                        selectStack = {}
                        if layer.girlAfraid then
                            s = 'girl-afraid' 
                        else 
                            s = 'girl-stand'
                            local bubble_index = math.random(3,5)
                            layer.bubble[bubble_index]:runAction(cc.Sequence:create(cc.Show:create(),cc.DelayTime:create(2),cc.Hide:create()))
                            for i = 1,7 do
                                if i ~= bubble_index and layer.bubble[i]:isVisible() then
                                    layer.bubble[i]:setVisible(false)
                                end
                            end
                        end
                        layer.girl:setAnimation(0,'girl_happy',false)
                        layer.girl:addAnimation(0,'girl_happy',false)
                        layer.girl:addAnimation(0,s,true)
                        if killedCrabCount == #layer.wordPool[layer.currentIndex] then
                        --next group
--                             layer.globalLock = true
--                             layer.currentIndex = layer.currentIndex + 1
--                             killedCrabCount = 0
--                             for m = 1, 5 do
--                                 for n = 1, 5 do
--                                     local remove = cc.CallFunc:create(function() 
-- --                                        layer.coconut[m][n]:removeFromParent(true)    
--                                     end,{})
--                                     layer.coconut[m][n]:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT*0.7)),remove))
--                                 end
--                             end
--                             layer:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function() 
--                                 layer.currentHintWord = {false,false,false}
--                                 layer:initMap(chapter)
--                             end,{})))
                        else
                            s_SCENE:callFuncWithDelay(0.2 * math.pow(#selectWord,0.8),function (  )
                                -- body
                                layer.coconut[layer.firstNodeArray[layer.firstIndex].x][layer.firstNodeArray[layer.firstIndex].y].firstStyle()
                                layer.crab[layer.firstIndex]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(2),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
                                layer.coconut[layer.firstNodeArray[layer.firstIndex].x][layer.firstNodeArray[layer.firstIndex].y]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(2),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
            
                            end)
                            
                        end
                        break
                    end
                end
            end
        end
        
        if not match then
            -- if endTime < 1 and not checkAtOnce then
            --     return
            -- end
            layer:clearCombo()
            local s
            if layer.girlAfraid then
                s = 'girl-afraid'
            else 
                s = 'girl-stand'
                local bubble_index = math.random(6,7)
                layer.bubble[bubble_index]:runAction(cc.Sequence:create(cc.Show:create(),cc.DelayTime:create(2),cc.Hide:create()))
                for i = 1,#layer.bubble do
                    if i ~= bubble_index and layer.bubble[i]:isVisible() then
                        layer.bubble[i]:setVisible(false)
                    end
                end
            end
            layer.girl:setAnimation(0,'girl-no',false)
            layer.girl:addAnimation(0,s,true)
            for i = 1, #selectStack do
                local node = selectStack[i]
                node.removeSelectStyle()
                node:setScale(scale)
                if node.isFirst > 0 and layer.crabOnView[node.isFirst] then
                    if node.isFirst == layer.firstIndex then
                        node.firstStyle()
                    end
                    local shakeOnce = cc.Sequence:create(cc.RotateBy:create(0.05,9),cc.RotateBy:create(0.05,-18),cc.RotateBy:create(0.05,9))
                    local shake = cc.Repeat:create(shakeOnce,2)
                    local small = cc.CallFunc:create(function() 
                        layer:crabSmall(chapter,node.isFirst)   
                    end,{})
                    layer.crab[node.isFirst]:runAction(cc.Sequence:create(shake,small))
                end
            end
            selectStack = {}
            layer.crab[layer.firstIndex]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(2),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
            layer.coconut[layer.firstNodeArray[layer.firstIndex].x][layer.firstNodeArray[layer.firstIndex].y]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(2),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
            
            --slide wrong
            playSound(s_sound_learn_false)
        end
    end
    
    
    -- handing touch events
    onTouchBegan = function(touch, event)
        if layer.currentBlood <= 0 or layer.isLose or not layer.gameStart or s_SCENE.popupLayer.layerpaused or layer.globalLock then
            return true
        end

        local location = layer:convertToNodeSpace(touch:getLocation())
        
        startTouchLocation = location
        lastTouchLocation = location
        
        layer:checkTouchLocation(location)

        if layer.onNode then
            startNode = layer.coconut[layer.current_node_x][layer.current_node_y]
            if startNode.isFirst > 0 and layer.crabOnView[startNode.isFirst] and layer.isTutorial and not layer.isTrying then
                layer:stopTutorial()
            end
        end

        if layer.isTutorial and not layer.isTrying then
                return true
            end

        layer.crab[layer.firstIndex]:stopAllActions()
        layer.coconut[layer.firstNodeArray[layer.firstIndex].x][layer.firstNodeArray[layer.firstIndex].y]:stopAllActions()

        isTouchEnded = false
        endTime = 0
        
        if chapter == 2 then
            light:setPosition(location)
            light:setVisible(true)
        end
        if layer.onNode then
            if layer.isGuiding then
                layer:stopGuide()
            end
            layer.isPaused = true
            for i = 1, layer.mat_length do
                for j = 1,layer.mat_length do
                    layer.coconut[i][j]:stopAllActions()
                    layer.coconut[i][j]:setScale(scale)
                end
            end
            
            if not startNode.hasSelected then
                selectStack[#selectStack+1] = startNode
                layer:updateWord(selectStack,chapter)
                --startNode.hasSelected = true
                startNode.addSelectStyle()
                startNode.right()
                startNode.bigSize()
                if startNode.isFirst > 0 and layer.crabOnView[startNode.isFirst] then
                    layer:crabBig(chapter,startNode.isFirst)
                end
                startAtNode = true
            else
                checkAnswer(true)
            end
            
        else
            startAtNode = false
        end
        
        for i = 1,#layer.wordPool[layer.currentIndex] do
            if cc.rectContainsPoint(layer.crab[i]:getBoundingBox(), location) and location.y < 160 then
                layer.isPaused = true
                layer:crabBig(chapter,i)
                layer.onCrab = i
                for m = 1, layer.mat_length do
                    for n = 1,layer.mat_length do
                        if layer.coconut[m][n].isFirst == i then
                            layer.coconut[m][n]:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.2 * scale),cc.ScaleTo:create(0.5,1.0 * scale)),2))
                            break
                        end
                    end
                end
            end
        end
        if layer.isPaused then
            layer.isHinting = false
        end
        -- CCTOUCHBEGAN event must return true
        return true
    end

    onTouchMoved = function(touch, event)
        if layer.currentBlood <= 0 or layer.isLose or layer.globalLock or s_SCENE.popupLayer.layerpaused or not layer.gameStart or (layer.isTutorial and not layer.isTrying) then
            return true
        end
    
        local length_gap = 50.0

        local location = layer:convertToNodeSpace(touch:getLocation())
        if chapter == 2 then
            light:setPosition(location)
        end

        -- error handle
        if lastTouchLocation == nil then 
            saveLuaErrorToServer('view/summaryboss/SummaryBossLayer.luac; lastTouchLocation is nil;')
            lastTouchLocation = location 
        end

        local length = math.sqrt((location.x - lastTouchLocation.x)^2+(location.y - lastTouchLocation.y)^2)
        if length <= length_gap then
            fakeTouchMoved(location)
        else
            local deltaX = (location.x - lastTouchLocation.x) * length_gap/length
            local deltaY = (location.y - lastTouchLocation.y) * length_gap/length
            --print('length'..length..'length_gap'..length_gap)
            --local time = os.clock()
            for i = 1, length/length_gap do
                fakeTouchMoved({x=lastTouchLocation.x+(i-1)*deltaX,y=lastTouchLocation.y+(i-1)*deltaY})
            end
            fakeTouchMoved(location)
            --print('moved time = '..os.clock() -time)
        end

        lastTouchLocation = location
    end
    
    fakeTouchMoved = function(location)
        if layer.globalLock then
            return
        end

        local time1 = os.clock()
    
        layer:checkTouchLocation(location)
        if chapter == 2 then
            light:setPosition(location)
        end

        if startAtNode then
            startAtNode = false
            -- local x = location.x - startTouchLocation.x
            -- local y = location.y - startTouchLocation.y

            -- if math.abs(x) > 5 or math.abs(y) > 5 then
            --     if chapter ~= 2 then
            --         if y > x and y > -x then
            --             startNode:up()
            --         elseif y < x and y < -x then
            --             startNode:down()
            --         elseif y > x and y < -x then
            --             startNode:left()
            --         else
            --             startNode:right()
            --         end
            --     end
            --     startAtNode = false
            -- end
        else
            if layer.onNode then
                local currentNode = layer.coconut[layer.current_node_x][layer.current_node_y]
                if currentNode.hasSelected then
                    if #selectStack >= 2 then
                        local stackTop = selectStack[#selectStack]
                        local secondStackTop = selectStack[#selectStack-1]
                        if currentNode.logicX == secondStackTop.logicX and currentNode.logicY == secondStackTop.logicY then
                            stackTop.removeSelectStyle()
                            stackTop:setScale(scale)
                            if stackTop.isFirst == layer.firstIndex then
                                stackTop.firstStyle()
                            end
                            table.remove(selectStack)    
                            -- slide coco "s_sound_slideCoconut"
                            if #selectStack <= 7 then
                                playSound(slideCoco[#selectStack])
                            else
                                playSound(slideCoco[7])
                            end
                        end

                    end
                else
                    if #selectStack == 0 then
                        if chapter ~= 2 then
                            if layer.current_dir == dir_up then
                                currentNode.down()
                            elseif layer.current_dir == dir_down then
                                currentNode.up()
                            elseif layer.current_dir == dir_left then
                                currentNode.right()
                            else
                                currentNode.left()
                            end
                        end
                        currentNode.addSelectStyle()
                        currentNode.bigSize()
                        currentNode.hasSelected = true
                        selectStack[#selectStack+1] = currentNode
                        --layer:updateWord(selectStack)
                        --slide coco
                        playSound(s_sound_slideCoconut)
                    else
                        if layer.isTrying and layer.isTutorial and currentNode:getLocalZOrder() == 0 then
                            return
                        end 
                        local stackTop = selectStack[#selectStack]
                        if math.abs(currentNode.logicX - stackTop.logicX) + math.abs(currentNode.logicY - stackTop.logicY) == 1 then
                            selectStack[#selectStack+1] = currentNode
                            --layer:updateWord(selectStack)
                            -- slide coco "s_sound_slideCoconut"
                            if #selectStack <= 7 then
                                playSound(slideCoco[#selectStack])
                            else
                                playSound(slideCoco[7])
                            end
                            
                            currentNode.addSelectStyle()
                            currentNode.bigSize()
                            if chapter ~= 2 then
                                if layer.current_dir == dir_up then
                                    currentNode.down()
                                elseif layer.current_dir == dir_down then
                                    currentNode.up()
                                elseif layer.current_dir == dir_left then
                                    currentNode.right()
                                else
                                    currentNode.left()
                                end
                            end
                        end
                    end
                end
            else

            end
        end
        --print('chack location time = '..os.clock() - time1)
        layer:updateWord(selectStack,chapter)
    end

    onTouchEnded = function(touch, event)
        isTouchEnded = true
        checkAnswer(false)
    end

    

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    listener:setSwallowTouches(true)

    --update
    local function update(delta)
        if loadingTime > delta and loadingState < 2 then
            loadingState = 2
        elseif loadingTime > 1.5 and loadingState < 4 then
            loadingState = 4
        elseif loadingTime > 1.8 and loadingState < 6 then
            loadingState = 6    
        end       
        if loadingState == 0 then
            loadingState = 1
            layer:initBossLayer_girl(chapter)
        elseif loadingState == 2 then
            loadingState = 3
            
            
        elseif loadingState == 4 then
            loadingState = 5
            layer:initBossLayer_boss(chapter,entrance,wordList)
        elseif loadingState == 6 then
            loadingState = 7
            
            --layer:initMap(chapter)
        end
        if loadingTime < 5 then
            loadingTime = loadingTime + delta
        end
        
        if layer.currentBlood <= 0 or layer.isLose or s_SCENE.popupLayer.layerpaused or not layer.gameStart or layer.isTutorial then
            return
        end
        
        layer.leftTime = layer.leftTime - delta
        layer.useTime = layer.useTime + delta
        if layer.globalLock then
            return
        end
        if not layer.isHinting then
            layer.bubble[2]:setVisible(true)
        end
        if layer.leftTime < layer.totalTime - 2 and layer.bubble[2]:isVisible() then
            layer.bubble[2]:setVisible(false)
        end
        if layer.girlAfraid and not layer.bubble[1]:isVisible() then
            layer.bubble[1]:setVisible(true)
            for i = 2,#layer.bubble do
                if layer.bubble[i]:isVisible() then
                    layer.bubble[i]:setVisible(false)
                end
            end
        elseif not layer.girlAfraid and layer.bubble[1]:isVisible() then
            layer.bubble[1]:setVisible(false)
        end

        -- if endTime < 1 and #selectStack > 0 and isTouchEnded then
        --     endTime = endTime + delta
        -- end
        -- if endTime >= 1 then
            
        --     checkAnswer(false)
        --     endTime = 0
        -- end

        if layer.girlAfraid and HINT_TIME == 10 then
            HINT_TIME = 4
        end

        if not layer.girlAfraid and HINT_TIME == 4 then
            HINT_TIME = 10
        end        
        
        if layer.hintTime < HINT_TIME or layer.isPaused then
            if layer.hintTime >= 0.8 * HINT_TIME and layer.isPaused then
                layer.hintTime = 0.8 * HINT_TIME
            else
                layer.hintTime = layer.hintTime + delta
            end
        elseif not layer.isPaused and not layer.isHinting then
            
            layer:hint()
        end
        if layer.isHinting and not layer.girlAfraid then
            if layer.bubble[8] ~= nil and not layer.bubble[8]:isVisible() then
                layer.bubble[8]:setVisible(true)
            end
        end
    end
    layer:scheduleUpdateWithPriorityLua(update, 0)
    
    -- boss "s_sound_Get_Outside"
    playMusic(s_sound_Get_Outside,true)
    --playSoundByVolume(s_sound_Get_Outside_Speedup,0,true)
    
    return layer  
end

function SummaryBossLayer:updateWord(selectStack,chapter)
    for i = 1, #self.wordStack do
            self.wordStack[i]:stopAllActions()
            self.wordStack[i]:removeFromParent()

            self.letterStack[i]:removeFromParent()
    end
    self.wordStack = {}
    self.letterStack = {}
        
    local count = #selectStack
    local gap = 32
    local left = (s_DESIGN_WIDTH - (count-1)*gap)/2
        
    for i = 1, #selectStack do
        local wordBack = cc.Sprite:create(string.format("image/summarybossscene/global_zongjiebossdancixianshi_%d.png",chapter))
            --wordBack:setScaleX(count * gap/wordBack:getContentSize().width + 1.0/5)
        wordBack:setPosition(left + gap*(i - 1), 0.72*s_DESIGN_HEIGHT)
        --wordBack:setScale(0.7)
        self:addChild(wordBack)
        self.wordStack[i] = wordBack
        local letter = cc.Label:createWithTTF(selectStack[i].main_character_content,"font/CenturyGothic.ttf",36)
        --letter:setScale(10 / 7)
        --letter:setColor(cc.c3b(0,0,0))
        letter:setPosition(left + gap*(i - 1), 0.72*s_DESIGN_HEIGHT)
        self:addChild(letter,1)
        self.letterStack[i] = letter
    end
end

function SummaryBossLayer:showGuideRoute()
    local finger = cc.Sprite:create('image/newstudy/qian.png')
    finger:setPosition(cc.p(self.coconut[self.guidePath[1][1]][self.guidePath[1][2]]:getPosition()))
    finger:ignoreAnchorPointForPosition(false)
    finger:setAnchorPoint(0.2,0.8)
    finger:setScale(1.5)
    self:addChild(finger,1)
    finger:setOpacity(0) 
    self.finger = finger
    local fingerAction = {}
    for i = 2,#self.guidePath do
        fingerAction[i - 1] = cc.MoveTo:create(0.3,cc.p(self.coconut[self.guidePath[i][1]][self.guidePath[i][2]]:getPosition()))
    end
    finger:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.CallFunc:create(function ()
            finger:setTexture("image/newstudy/qian.png")
        end),
        cc.Spawn:create(
            cc.FadeIn:create(0.5),
            cc.ScaleTo:create(0.5,1)
        ),
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(function ()
            finger:setTexture("image/newstudy/hou.png")
        end),
        cc.Sequence:create(fingerAction),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function ()
            finger:setTexture("image/newstudy/qian.png")
        end),
        cc.Spawn:create(
            cc.FadeOut:create(0.2),
            cc.ScaleTo:create(0.2,1.5)
        ),
        cc.Place:create(cc.p(self.coconut[self.guidePath[1][1]][self.guidePath[1][2]]:getPosition()))
    )))

    local newList = {"up"}
    for i=1, #self.guidePath - 1 do
        if self.guidePath[i][1] == self.guidePath[i+1][1] and self.guidePath[i][2] > self.guidePath[i+1][2] then
            table.insert(newList,"down")
        elseif self.guidePath[i][1] == self.guidePath[i+1][1] and self.guidePath[i][2] < self.guidePath[i+1][2] then
            table.insert(newList,"up")
        elseif self.guidePath[i][1] > self.guidePath[i+1][1] and self.guidePath[i][2] == self.guidePath[i+1][2] then
            table.insert(newList,"left")
        elseif self.guidePath[i][1] < self.guidePath[i+1][1] and self.guidePath[i][2] == self.guidePath[i+1][2] then
            table.insert(newList,"right")
        end
    end
    for i = 1, #self.guidePath do
        local node = self.coconut[self.guidePath[i][1]][self.guidePath[i][2]]
        local action0 = cc.DelayTime:create(0.5 + 0.3 * i)
        local action2 = cc.DelayTime:create(1.2 + 0.3 * #self.guidePath - 0.3 * i)

        node:runAction(cc.RepeatForever:create(cc.Sequence:create(action0,
            cc.CallFunc:create(function ()
                if newList[i] == "down" then
                node.down()
                elseif newList[i] == "up" then
                node.up()
                elseif newList[i] == "left" then
                node.left()
                elseif newList[i] == "right" then
                node.right()
                end
            end)
            ,action2,
            cc.CallFunc:create(function ()
            node.removeSelectStyle()
            end)
        )))
    end
end

function SummaryBossLayer:stopGuide()
    self.finger:stopAllActions()
    self.finger:removeFromParent()
    self.isGuiding = false
    for i = 1,self.mat_length do
        for j = 1,self.mat_length do
            if i ~= self.current_node_x or j ~= self.current_node_y then
                self.coconut[i][j]:removeSelectStyle()
            end
        end
    end

end

function SummaryBossLayer:stopTutorial()
    self.isTutorial = false
    self.tutorial:removeFromParent()
    local bossAction = {}
    for i = 1, 10 do
        local stop = cc.DelayTime:create(self.totalTime / 10 * 0.8)
        local stopAnimation = cc.CallFunc:create(function() 
            self.boss:setAnimation(0,'a2',true)
        end,{})
        local move = cc.MoveBy:create(self.totalTime / 10 * 0.2,cc.p(- 0.45 * s_DESIGN_WIDTH / 10, 0))
        local moveAnimation = cc.CallFunc:create(function() 
            self.boss:setAnimation(0,'animation',false)
        end,{})
        bossAction[#bossAction + 1] = cc.Spawn:create(stop,stopAnimation)
        bossAction[#bossAction + 1] = cc.Spawn:create(move,moveAnimation)
    end
    if not self.isTrying then
        bossAction[#bossAction + 1] = cc.CallFunc:create(function() 

            if self.currentBlood > 0 then
                self.isLose = true
                self:lose(self.chapter,self.entrance,self.wordList)  
            end
        end,{})
    end
    self.bossNode:runAction(cc.Sequence:create(bossAction))

    local wait = cc.DelayTime:create(0.0 + self.totalTime * 0.9)
    local afraid = cc.CallFunc:create(function() 
        if self.currentBlood > 0 then
            self.girlAfraid = true
            HINT_TIME = 4
            self.girl:setAnimation(0,'girl-afraid',true)
            -- deadline "Mechanical Clock Ring "
            playSound(s_sound_Mechanical_Clock_Ring)
            playMusic(s_sound_Get_Outside_Speedup,true)
        end
    end,{})
    local blinkIn = cc.FadeTo:create(0.5,50)
    local blinkOut = cc.FadeTo:create(0.5,0.0)
    local blink = cc.Sequence:create(blinkIn,blinkOut)
    local repeatBlink = cc.Repeat:create(blink,math.ceil(self.totalTime * 0.1))
    self.blink:runAction(cc.Sequence:create(wait,afraid,repeatBlink))
end

function SummaryBossLayer:initBossLayer_back(chapter)
    self.globalLock = false
    --stage info
    self.girlAfraid = false
    self.hasMap = false
    self.rightWord = 0
    self.onCrab = 0
    self.isLose = false
    s_SCENE.popupLayer.layerpaused = false 
    --add back
    if chapter == 1 then
        local blueBack = cc.LayerColor:create(cc.c4b(52, 177, 240, 255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
        blueBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
        self:addChild(blueBack)
    
        local back = sp.SkeletonAnimation:create("res/spine/summaryboss/zongjieboss_diyiguan_background.json", "res/spine/summaryboss/zongjieboss_diyiguan_background.atlas", 1)
        back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
        self:addChild(back)
        back:addAnimation(0, 'animation', true)
    elseif chapter == 2 then
        local back = cc.Sprite:create("image/summarybossscene/summaryboss_dierguan_back.png")    
        back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
        self:addChild(back)

        local backEffect = sp.SkeletonAnimation:create('spine/summaryboss/second-level-summary-light.json','spine/summaryboss/second-level-summary-light.atlas',1)
        backEffect:setPosition(-30,0.675 * back:getContentSize().height)
        backEffect:setAnimation(0,'animation',true)
        self:addChild(backEffect)
    else 
        local back = cc.Sprite:create('image/summarybossscene/third_level_summary_boss_background.png')
        back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
        self:addChild(back)

        local light = sp.SkeletonAnimation:create("spine/summaryboss/third-level-summary-boss-background.json","spine/summaryboss/third-level-summary-boss-background.atlas",1)
        light:setPosition(-80,s_DESIGN_HEIGHT * 0.73)
        self:addChild(light)
        light:addAnimation(0,'animation',true)
    end
    
    --add hole
    local hole = {}    
    local gap = 120
    local left = (s_DESIGN_WIDTH - (self.mat_length - 1)*gap)/2
    local bottom = 220 + (5-self.mat_length)* 100
    for i = 1, self.mat_length do
        hole[i] = {}
        for j = 1, self.mat_length do
            hole[i][j] = cc.Sprite:create(string.format("image/summarybossscene/hole_%d.png",chapter))
            hole[i][j]:setScale(0.92)
            hole[i][j]:setPosition(left + gap * (i - 1), bottom + gap * (j - 1))
            self:addChild(hole[i][j],0)
        end
    end
    self.hole = hole
end

function SummaryBossLayer:initBossLayer_girl(chapter)
    --add pauseButton
    local pauseBtn = ccui.Button:create("res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png","res/image/button/pauseButtonWhite.png")
    pauseBtn:ignoreAnchorPointForPosition(false)
    pauseBtn:setAnchorPoint(0,1)
    s_SCENE.popupLayer.pauseBtn = pauseBtn
    self:addChild(pauseBtn)
    pauseBtn:setPosition(s_LEFT_X, s_DESIGN_HEIGHT)

    -- add combo icon
    local combo_icon = {}
    self.combo_label = {}
    local combo_color = {cc.c4b(156,220,240,255),cc.c4b(255,216,2,255),cc.c4b(170,246,62,255),cc.c4b(255,148,34,255)}

    local combo_back = cc.Sprite:create('image/summarybossscene/liangguang_study_1.png')
    combo_back:setPosition(s_DESIGN_WIDTH * 0.9,s_DESIGN_HEIGHT * 0.95 + 5)
    self:addChild(combo_back)
    self.combo_back = combo_back
    combo_back:setOpacity(0)

    for i = 1,12 do
        combo_icon[i] = cc.ProgressTimer:create(cc.Sprite:create(string.format('image/summarybossscene/yuanhuan_zjboss_%d.png',math.ceil(i/3))))
        combo_icon[i]:setPosition(s_DESIGN_WIDTH * 0.9,s_DESIGN_HEIGHT * 0.95 + 5)
        self:addChild(combo_icon[i])

        combo_icon[i]:setRotation(6 + 120 * ((i - 1)%3))
        combo_icon[i]:setPercentage(30)
        if i > 3 then
            combo_icon[i]:setOpacity(0)    
        end
    end

    for i = 1,4 do
        local label1 = cc.Label:createWithSystemFont('+','',30)
        label1:setAnchorPoint(1,0.5)
        label1:setPosition(combo_icon[i]:getPositionX() + 3,combo_icon[i]:getPositionY() + 3)
        self:addChild(label1)
        label1:setColor(combo_color[i])
        label1:enableOutline(combo_color[i],2)
        self.combo_label[#self.combo_label + 1] = label1

        local label2 = cc.Label:createWithSystemFont(string.format('%d',i - 1),'',30)
        label2:setAnchorPoint(0,0.5)
        label2:enableOutline(combo_color[i],2)
        label2:setPosition(combo_icon[i]:getPositionX() - 1,combo_icon[i]:getPositionY() + 1)
        self:addChild(label2)
        label2:setColor(combo_color[i])

        self.combo_label[#self.combo_label + 1] = label2

        if i > 1 then
            label1:setOpacity(0)
            label2:setOpacity(0)
        end
    end

    self.combo_icon = combo_icon

    local function createPausePopup()
        if self.currentBlood <= 0 or self.isLose or self.globalLock or s_SCENE.popupLayer.layerpaused or self.isTutorial then
            return
        end
        local pauseLayer = Pause.create()
        if self.isTrying then
            pauseLayer.inTryingLayer = true
        end
        pauseLayer:setPosition(s_LEFT_X, 0)
        s_SCENE.popupLayer:addBackground()
        s_SCENE.popupLayer:addChild(pauseLayer)
        s_SCENE.popupLayer.listener:setSwallowTouches(true)
    end

    local function pauseScene(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
           createPausePopup()
        
        --button sound
            playSound(s_sound_buttonEffect)
        end
    end
    pauseBtn:addTouchEventListener(pauseScene)

    onAndroidKeyPressed(pauseBtn, function ()
        createPausePopup()
    end, function ()

    end)
    --add girl
    local girl = sp.SkeletonAnimation:create("spine/summaryboss/girl-stand.json","spine/summaryboss/girl-stand.atlas",1)
    girl:setPosition(s_DESIGN_WIDTH * 0.05, s_DESIGN_HEIGHT * 0.76)
    if chapter == 2 then
        girl:setPosition(s_DESIGN_WIDTH * 0.07, s_DESIGN_HEIGHT * 0.79)
        local light_girl = cc.Sprite:create('image/summarybossscene/global_zongjiebosshuangshubeibei_dierguan.png')
        light_girl:setAnchorPoint(0.08,0.1)
        light_girl:setPosition(0,0)
        girl:addChild(light_girl,-1)
    end
    self:addChild(girl,1)
    girl:setAnimation(0,'girl-stand',true)
    self.girl = girl

     -- add bubble

    self:addBubble()
      
    --add readyGo
    local readyGoFile 
    if chapter == 1 then
        readyGoFile = "spine/summaryboss/readygo_diyiguan"
    elseif chapter == 2 then
        readyGoFile = "spine/summaryboss/readygo_dierguan"
    else
        readyGoFile = "spine/summaryboss/readygo_disanguan"
    end
    local readyGo = sp.SkeletonAnimation:create(string.format("%s.json",readyGoFile),string.format("%s.atlas",readyGoFile),1)
    readyGo:setPosition(s_DESIGN_WIDTH * 0.5, s_DESIGN_HEIGHT * 0.5)
    readyGo:addAnimation(0,'animation',false)
    self:addChild(readyGo,100)
    
    -- ready go "ReadyGo"
    playSound(s_sound_ReadyGo)
    
end

function SummaryBossLayer:addBubble()
    local bubble = {}
    self.bubble = bubble

    bubble[1] = cc.Sprite:create('image/summarybossscene/bubble3.png')
    bubble[1]:setAnchorPoint(0,0)
    bubble[1]:setPosition(60,170)
    self.girl:addChild(bubble[1]) 
    bubble[1]:setVisible(false)

    local emotion_label = cc.Label:createWithSystemFont('>﹏<','',20)
    emotion_label:enableOutline(cc.c4b(255,255,255,255),1)
    emotion_label:setPosition(bubble[1]:getContentSize().width / 2 + 7,bubble[1]:getContentSize().height / 2 + 10)
    bubble[1]:addChild(emotion_label) 

    bubble[2] = ccui.Scale9Sprite:create('image/summarybossscene/bubble1.png',cc.rect(0,0,175,88),cc.rect(60, 0, 55, 88))
    local start_label = cc.Label:createWithSystemFont('怪兽过来了，\n快划单词消灭它','',20)
    bubble[2]:setContentSize(cc.size(start_label:getContentSize().width + 20,88))
    bubble[2]:ignoreAnchorPointForPosition(false)
    bubble[2]:setAnchorPoint(0,0)
    bubble[2]:setPosition(90,140)
    self.girl:addChild(bubble[2])

    start_label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    start_label:setPosition(bubble[2]:getContentSize().width / 2,bubble[2]:getContentSize().height * 0.6)
    bubble[2]:addChild(start_label)
    bubble[2]:setVisible(false)
    local text = {'太棒了','wonderful','太厉害了','加油','再仔细想想'}
    for i = 3,7 do
        bubble[i] = ccui.Scale9Sprite:create('image/summarybossscene/bubble2.png',cc.rect(0,0,123,52),cc.rect(40, 0, 43, 52))
        local right_label = cc.Label:createWithSystemFont(text[i - 2],'',20)
        local width = 60
        if right_label:getContentSize().width > width then
            width = right_label:getContentSize().width
        end
        bubble[i]:setContentSize(cc.size(width + 20,52))
        bubble[i]:ignoreAnchorPointForPosition(false)
        bubble[i]:setAnchorPoint(0,0)
        bubble[i]:setPosition(100,150)
        self.girl:addChild(bubble[i])

        right_label:setPosition(bubble[i]:getContentSize().width / 2,bubble[i]:getContentSize().height * 0.6 + 2)
        bubble[i]:addChild(right_label)
        right_label:setName('label')
        bubble[i]:setVisible(false)
    end

end


function SummaryBossLayer:initBossLayer_boss(chapter,entrance,wordList)
    
    local blinkBack = cc.LayerColor:create(cc.c4b(0,0,0,0), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    blinkBack:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self:addChild(blinkBack,0)
    self.blink = blinkBack

    --add boss
    local bossNode = cc.Node:create()
    bossNode:setPosition(s_DESIGN_WIDTH * 0.65, s_DESIGN_HEIGHT * 1.15)
    self:addChild(bossNode)
    local boss = sp.SkeletonAnimation:create("spine/summaryboss/klswangqianzou.json","spine/summaryboss/klswangqianzou.atlas",1)
    boss:setPosition(0,0)
    bossNode:addChild(boss,1)
    boss:setAnimation(0,'a2',true)
    local bossAction = {}
    bossAction[1] = cc.DelayTime:create(0.0)
    bossAction[2] = cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.75 + 20)))
    if chapter == 2 then
        bossAction[2] = cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.6, s_DESIGN_HEIGHT * 0.76 + 20)))
        --boss light
        local light_boss = cc.Sprite:create('image/summarybossscene/global_zongjiebosshuangshuboss_dierguan.png')
        light_boss:setAnchorPoint(0,0)
        light_boss:setPosition(0,0)
        bossNode:addChild(light_boss)
        light_boss:setVisible(false)
        light_boss:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.Show:create()))
    end
    bossAction[3] = cc.CallFunc:create(function (  )
        -- body
        self:initMap(chapter)
    end,{})
    if not self.isTutorial then
        local wait = cc.DelayTime:create(0.0 + self.totalTime * 0.9)
        local afraid = cc.CallFunc:create(function() 
            if self.currentBlood > 0 then
                self.girlAfraid = true
                HINT_TIME = 4
                self.girl:setAnimation(0,'girl-afraid',true)
                -- deadline "Mechanical Clock Ring "
                playSound(s_sound_Mechanical_Clock_Ring)
                playMusic(s_sound_Get_Outside_Speedup,true)
            end
        end,{})
        local blinkIn = cc.FadeTo:create(0.5,50)
        local blinkOut = cc.FadeTo:create(0.5,0.0)
        local blink = cc.Sequence:create(blinkIn,blinkOut)
        local repeatBlink = cc.Repeat:create(blink,math.ceil(self.totalTime * 0.1))
        blinkBack:runAction(cc.Sequence:create(wait,afraid,repeatBlink))

        for i = 1, 10 do
            local stop = cc.DelayTime:create(self.totalTime / 10 * 0.8)
            local stopAnimation = cc.CallFunc:create(function() 
                boss:setAnimation(0,'a2',true)
            end,{})
            local move = cc.MoveBy:create(self.totalTime / 10 * 0.2,cc.p(- 0.45 * s_DESIGN_WIDTH / 10, 0))
            local moveAnimation = cc.CallFunc:create(function() 
                boss:setAnimation(0,'animation',false)
            end,{})
            bossAction[#bossAction + 1] = cc.Spawn:create(stop,stopAnimation)
            bossAction[#bossAction + 1] = cc.Spawn:create(move,moveAnimation)
        end
        bossAction[#bossAction + 1] = cc.CallFunc:create(function() 

            if self.currentBlood > 0 then
                self.isLose = true
                self:lose(chapter,entrance,wordList)    
            end
        end,{})
    end
    bossNode:runAction(cc.Sequence:create(bossAction))
    local bloodBack = cc.Sprite:create("image/summarybossscene/summaryboss_blood_back.png")
    bloodBack:setPosition(100,-10)
    boss:addChild(bloodBack)
    boss.blood = cc.ProgressTimer:create(cc.Sprite:create("image/summarybossscene/jindutiao.png"))
    boss.blood:setPosition(100,-10)
    boss.blood:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    boss.blood:setMidpoint(cc.p(0,0))
    boss.blood:setBarChangeRate(cc.p(1,0))
    boss.blood:setPercentage(100)
    boss:addChild(boss.blood) 
    self.boss = boss
    self.bossNode = bossNode
end

function SummaryBossLayer:initWordList(word)
    local wordList = word
    --if #wordList < 1 then
       -- wordList = {'apple','many','many','many','many','many','many','many','many','many','many','tea','banana','cat','dog','camel','ant'}
    --end
    if self.isTrying then
        wordList = {'apple','pear'}
    end
    local index = 1

    self.mat_length = 5
    self.isTutorial = false

    if (s_CURRENT_USER.newTutorialStep == s_newtutorial_sb_cn and self.entrance) or self.isTrying then
        self.mat_length = 4
        self.isTutorial = true
    end

    for i = 1, #wordList do
        local randomIndex = math.random(1,#wordList)
        local tmp = wordList[i]
        wordList[i] = wordList[randomIndex]
        wordList[randomIndex] = tmp
        
    end

    self.maxCount = #wordList
    AnalyticsSummaryBossWordCount(self.maxCount)

    self.totalBlood = 0
    for i = 1,#wordList do
        self.totalBlood = self.totalBlood + string.len(wordList[i]) * 2
    end
    self.currentBlood = self.totalBlood
    local isFirstBoss = #s_LocalDatabaseManager.getAllBossInfo()
    local time_value = 15
    if isFirstBoss <= 1 then
        time_value = 30
    else
        time_value = 15
    end
    if self.entrance then
        self.totalTime = math.ceil(self.totalBlood / 14) * time_value + s_CURRENT_USER.timeAdjust
    else
        self.totalTime = math.ceil(self.totalBlood / 14) * time_value
    end
    self.leftTime = self.totalTime
    -- print("~~~~~~~~time"..self.totalTime)
    -- print("~~~~~~~~value"..time_value)
    -- print("~~~~~~~~isFirstBoss"..isFirstBoss)
    --self:runAction(cc.Ripple3D:create(20, cc.size(32,24), cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2), 120, 40, 240))
    -- self.totalBlood = levelConfig.summary_boss_hp
    -- self.currentBlood = self.totalBlood
    -- self.totalTime = levelConfig.summary_boss_time


    while true do
        local totalLength = 0
        local tmp = {}
        local COUNT = 3
        if self.isTutorial then
            COUNT = 1
        end
        for i = 1,COUNT do
            local w = wordList[index]
            if(totalLength + string.len(w) <= self.mat_length^2) then
                tmp[#tmp + 1] = w
                totalLength = totalLength + string.len(w)
                index = index + 1
                if index > #wordList then
                    self.wordPool[#self.wordPool + 1] = tmp
                    break
                end
            end 
        end
        if index > #wordList then
            break
        end
        self.wordPool[#self.wordPool + 1] = tmp          
    end
end

function SummaryBossLayer:initStartIndex(index)
    self.startIndexPool = {}
    if #self.wordPool[index] == 1 then
        local localgap = self.mat_length^2 - string.len(self.wordPool[index][1])
        local randomStart = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart + 1
    elseif #self.wordPool[index] == 2 then
        local localgap = self.mat_length^2 - string.len(self.wordPool[index][1]) - string.len(self.wordPool[index][2])
        local randomStart1 = math.random(0,localgap)
        localgap = localgap - randomStart1
        local randomStart2 = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[index][1]) + randomStart2 + 1
    elseif #self.wordPool[index] == 3 then
        local localgap = self.mat_length^2 - string.len(self.wordPool[index][1]) - string.len(self.wordPool[index][2]) - string.len(self.wordPool[index][3])
        local randomStart1 = math.random(0,localgap)
        localgap = localgap - randomStart1
        local randomStart2 = math.random(0,localgap)
        localgap = localgap - randomStart2
        local randomStart3 = math.random(0,localgap)
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[index][1]) + randomStart2 + 1
        self.startIndexPool[#self.startIndexPool + 1] = randomStart1 + string.len(self.wordPool[index][1]) + randomStart2 + string.len(self.wordPool[index][2]) + randomStart3 + 1        
    end
end

function SummaryBossLayer:initCrab( chapter )
    if chapter == 1 then
        self:initCrab1()
    else
        self:initCrab2(chapter)
    end

end

function SummaryBossLayer:initCrab1()
    local proxy = cc.CCBProxy:create()
    self.ccb = {}
    if #self.wordPool[self.currentIndex] ==1 then
        self.ccbcrab[1] = {} 
        self.ccb[1] = {}
        self.ccb[1]['CCB_crab'] = self.ccbcrab[1]
        self.crab[1] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[1],self.ccb[1])
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.5, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[1],1)
    elseif #self.wordPool[self.currentIndex] ==2 then
        self.ccbcrab[1] = {} 
        self.ccb[1] = {}
        self.ccb[1]['CCB_crab'] = self.ccbcrab[1]
        self.crab[1] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[1],self.ccb[1])
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.3, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[1],1)
        
        self.ccbcrab[2] = {} 
        self.ccb[2] = {}
        self.ccb[2]['CCB_crab'] = self.ccbcrab[2]
        self.crab[2] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[2],self.ccb[2])
        self.crab[2]:setPosition(s_DESIGN_WIDTH * 0.7, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[2],1)
    elseif #self.wordPool[self.currentIndex] ==3 then
        self.ccbcrab[1] = {} 
        self.ccb[1] = {}
        self.ccb[1]['CCB_crab'] = self.ccbcrab[1]
        self.crab[1] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[1],self.ccb[1])
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.2, -s_DESIGN_HEIGHT * 0.1)
        self.crab[1]:setRotation(5)
        self:addChild(self.crab[1],1)
        self.ccbcrab[2] = {} 
        self.ccb[2] = {}
        self.ccb[2]['CCB_crab'] = self.ccbcrab[2]
        self.crab[2] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[2],self.ccb[2])
        self.crab[2]:setPosition(s_DESIGN_WIDTH * 0.5, -s_DESIGN_HEIGHT * 0.1 - 10)
        self:addChild(self.crab[2],1)
        self.ccbcrab[3] = {} 
        self.ccb[3] = {}
        self.ccb[3]['CCB_crab'] = self.ccbcrab[3]
        self.crab[3] = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab[3],self.ccb[3])
        self.crab[3]:setPosition(s_DESIGN_WIDTH * 0.8, -s_DESIGN_HEIGHT * 0.1)
        self:addChild(self.crab[3],1)
        
    end
    for i = 1,#self.crab do
        local appear = cc.EaseBackOut:create(cc.MoveBy:create(0.5,cc.p(0,s_DESIGN_HEIGHT * 0.2)))
        local delaytime = 0
        if self.currentIndex == 1 then
            --delaytime = 1.5
        end
        self.crab[i]:runAction(cc.Sequence:create(cc.DelayTime:create(1.1 + delaytime),appear))
        if self.isTrying then
            self.ccbcrab[i]['meaningSmall']:setString(self.wordPool[self.currentIndex][i])
            self.ccbcrab[i]['meaningBig']:setString(self.wordPool[self.currentIndex][i])
        else
            self.ccbcrab[i]['meaningSmall']:setString(s_LocalDatabaseManager.getWordInfoFromWordName(self.wordPool[self.currentIndex][i]).wordMeaningSmall)
            self.ccbcrab[i]['meaningBig']:setString(s_LocalDatabaseManager.getWordInfoFromWordName(self.wordPool[self.currentIndex][i]).wordMeaningSmall)
        end
    end
    self.crab[self.firstIndex]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(2),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
    --print('s_tutorial_summary_boss',s_tutorial_summary_boss,s_CURRENT_USER.tutorialStep)
    if self.isTutorial then
        s_SCENE:callFuncWithDelay(1.6 ,function (  )
            self:addTutorial()
        end)
    end
end

function SummaryBossLayer:addTutorial()
    local curtain = cc.LayerColor:create(cc.c4b(0,0,0,150),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    curtain:ignoreAnchorPointForPosition(false)
    curtain:setAnchorPoint(0.5,0.5)
    curtain:setPosition(0.5 *s_DESIGN_WIDTH,0.5 * s_DESIGN_HEIGHT)
    self:addChild(curtain)
    self.tutorial = curtain
    local hintboard = cc.Sprite:create('image/summarybossscene/hintboard2.png')
    hintboard:setPosition(curtain:getContentSize().width * 0.6,s_DESIGN_HEIGHT * 0.8)
    curtain:addChild(hintboard)
    if self.isTrying then
        self:showGuideRoute()
        hintboard:setTexture('image/summarybossscene/hintboard1.png')
    end
    self.gameStart = true
    self.globalLock = false
end

function SummaryBossLayer:initCrab2(chapter)
    if #self.wordPool[self.currentIndex] ==1 then
        self.crab[1] = cc.Sprite:create(string.format('image/summarybossscene/crab_%d_board_1.png',chapter))
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.3, -s_DESIGN_HEIGHT * 0.17)
        self:addChild(self.crab[1])
    elseif #self.wordPool[self.currentIndex] ==2 then
        self.crab[1] = cc.Sprite:create(string.format('image/summarybossscene/crab_%d_board_1.png',chapter))
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.3, -s_DESIGN_HEIGHT * 0.17)
        self:addChild(self.crab[1])
        self.crab[2] = cc.Sprite:create(string.format('image/summarybossscene/crab_%d_board_3.png',chapter))
        self.crab[2]:setPosition(s_DESIGN_WIDTH * 0.7, -s_DESIGN_HEIGHT * 0.17)
        self:addChild(self.crab[2])
    elseif #self.wordPool[self.currentIndex] ==3 then
        for i = 1,3 do
            self.crab[i] = cc.Sprite:create(string.format('image/summarybossscene/crab_%d_board_%d.png',chapter,i))
            self:addChild(self.crab[i])
        end
        self.crab[1]:setPosition(s_DESIGN_WIDTH * 0.2, -s_DESIGN_HEIGHT * 0.17)
        self.crab[2]:setPosition(s_DESIGN_WIDTH * 0.5, -s_DESIGN_HEIGHT * 0.17 - 10)
        self.crab[3]:setPosition(s_DESIGN_WIDTH * 0.8, -s_DESIGN_HEIGHT * 0.17)   
    end
    for i = 1,#self.crab do
        local hand = cc.Sprite:create(string.format('image/summarybossscene/crab_%d.png',chapter))
        hand:setAnchorPoint(0.5,0.7)
        hand:setPosition(0.5 * self.crab[i]:getContentSize().width,-10)
        self.crab[i]:addChild(hand)
        local meaning = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getWordInfoFromWordName(self.wordPool[self.currentIndex][i]).wordMeaningSmall,'',28)
        if chapter == 3 then
            meaning:setColor(cc.c3b(0,0,0))
        end
        meaning:setPosition(0.5 * self.crab[i]:getContentSize().width,0.5 * self.crab[i]:getContentSize().height)
        self.crab[i]:addChild(meaning)
        if #self.crab == 3 then 
            if i == 1 then
                self.crab[i]:setRotation(6.6)
            elseif i == 3 then
                self.crab[i]:setRotation(-3.12)
            end
        elseif #self.crab == 2 then
            if i == 1 then
                self.crab[i]:setRotation(6.6)
            elseif i == 2 then
                self.crab[i]:setRotation(-3.12)
            end
        end
        self.crab[i]:setAnchorPoint(0.5,0)
        local appear = cc.EaseBackOut:create(cc.MoveBy:create(0.5,cc.p(0,s_DESIGN_HEIGHT * 0.2)))
        local delaytime = 0
        if self.currentIndex == 1 then
            --delaytime = 1.5
        end
        self.crab[i]:runAction(cc.Sequence:create(cc.DelayTime:create(1.1 + delaytime),appear))
    end
end

function SummaryBossLayer:initMapInfo()
    local start = os.time()
    self.isFirst = {}
    self.isCrab = {}
    self.character = {}
    self.guidePath = {}
    for i = 1,string.len(self.wordPool[1][1]) do
        self.guidePath[i] = {0,0}
    end
    self:initMapInfoByIndex(1)
end

function SummaryBossLayer:initMapInfoByIndex(startIndex)
    -- local start = os.time()
    -- self.isFirst = {}
    -- self.isCrab = {}
    -- self.character = {}
    for k = startIndex,#self.wordPool do
        self:initStartIndex(k)
        self.character[k] = {}
        self.isFirst[k] = {}
        self.isCrab[k] = {}
        local charaster_set_filtered = {}
        for i = 1, 26 do
            local char = string.char(96+i)
            charaster_set_filtered[#charaster_set_filtered+1] = char
        end
        local main_logic_mat
        if (s_CURRENT_USER.newTutorialStep == s_newtutorial_sb_cn and self.entrance) or self.isTrying then
            main_logic_mat = randomMat(4, 4)
        else
            main_logic_mat = getRandomBossPath()
        end
        for i = 1, self.mat_length do
            self.character[k][i] = {}
            self.isFirst[k][i] = {}
            self.isCrab[k][i] = {}
            for j = 1, self.mat_length do
                local randomIndex = math.random(1, #charaster_set_filtered)
                self.isFirst[k][i][j] = 0
                self.isCrab[k][i][j] = 0
                if #self.wordPool[k] == 1 then
                    local diff = main_logic_mat[i][j] - self.startIndexPool[1]
                    if diff >= 0 and diff < string.len(self.wordPool[k][1]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][1],diff+1,diff+1)
                        self.isCrab[k][i][j] = 1
                        if diff == 0 then
                            self.isFirst[k][i][j] = 1
                        end
                        if self.isTutorial and self.isTrying and k == 1 then
                            self.guidePath[diff + 1] = {i,j}
                        end
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        self.character[k][i][j] = charaster_set_filtered[randomIndex]

                    end
                elseif #self.wordPool[k] == 2 then
                    local diff1 = main_logic_mat[i][j] - self.startIndexPool[1]
                    local diff2 = main_logic_mat[i][j] - self.startIndexPool[2]
                    if diff1 >= 0 and diff1 < string.len(self.wordPool[k][1]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][1],diff1+1,diff1+1)
                        self.isCrab[k][i][j] = 1
                    elseif diff2 >= 0 and diff2 < string.len(self.wordPool[k][2]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][2],diff2+1,diff2+1)
                        self.isCrab[k][i][j] = 2
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        self.character[k][i][j] = charaster_set_filtered[randomIndex]
                    end
                    if diff1 * diff2 == 0 then
                        if diff1 == 0 then
                            self.isFirst[k][i][j] = 1
                        else
                            self.isFirst[k][i][j] = 2
                        end
                    end
                elseif #self.wordPool[k] == 3 then
                    local diff1 = main_logic_mat[i][j] - self.startIndexPool[1]
                    local diff2 = main_logic_mat[i][j] - self.startIndexPool[2]
                    local diff3 = main_logic_mat[i][j] - self.startIndexPool[3]
                    if diff1 >= 0 and diff1 < string.len(self.wordPool[k][1]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][1],diff1+1,diff1+1)
                        self.isCrab[k][i][j] = 1
                    elseif diff2 >= 0 and diff2 < string.len(self.wordPool[k][2]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][2],diff2+1,diff2+1)
                        self.isCrab[k][i][j] = 2
                    elseif diff3 >= 0 and diff3 < string.len(self.wordPool[k][3]) then
                        self.character[k][i][j] = string.sub(self.wordPool[k][3],diff3+1,diff3+1)
                        self.isCrab[k][i][j] = 3
                    else
                        local randomIndex = math.random(1, #charaster_set_filtered)
                        self.character[k][i][j] = charaster_set_filtered[randomIndex]
                    end

                    if diff1 * diff2 * diff3 == 0 then
                        if diff1 == 0 then
                            self.isFirst[k][i][j] = 1
                        elseif diff2 == 0 then
                            self.isFirst[k][i][j] = 2
                        else
                            self.isFirst[k][i][j] = 3
                        end
                    end

                end
            end
        end
    end
    local finish = os.time()
end

function SummaryBossLayer:addMapInfo(word)
    local flag = false
    if #self.wordPool[#self.wordPool] >= 3 or self.currentIndex == #self.wordPool then
        flag = true
    else
        local length = string.len(word)
        for i = 1,#self.wordPool[#self.wordPool] do
            length = string.len(self.wordPool[#self.wordPool][i]) + length
        end
        if length > self.mat_length^2 then
            flag = true
        end
    end
    if flag then
        self.wordPool[#self.wordPool + 1] = {}
        --print(word)
        self.wordPool[#self.wordPool][1] = word
    else
        self.wordPool[#self.wordPool][#self.wordPool[#self.wordPool] + 1] = word
    end
    self:initMapInfoByIndex(#self.wordPool)
end

function SummaryBossLayer:initMap(chapter)

    self.firstNodeArray = {}
    for i = 1, #self.wordPool[self.currentIndex] do
        self.firstNodeArray[i] = cc.p(0,0)
    end
    for i = 1, #self.crab do
        self.crab[i]:removeFromParent()
    end
    self.crab = {}
    for i = 1, #self.wordPool[self.currentIndex] do
        self.crabOnView[i] = true
    end
    
    for i = 1, self.mat_length do
        if self.currentIndex == 1 then
            self.coconut[i] = {}
        end
        for j = 1, self.mat_length do
            
             if self.currentIndex > 1 then
                self.coconut[i][j].main_character_content = self.character[self.currentIndex][i][j]
                self.coconut[i][j].main_character_label:setString(self.character[self.currentIndex][i][j])
             else
                if chapter == 1 then
                    self.coconut[i][j] = FlipNode.create("coconut_dark", self.character[self.currentIndex][i][j], i, j)
                elseif chapter == 2 then 
                    self.coconut[i][j] = TapNode.create("popcorn", self.character[self.currentIndex][i][j], i, j)
                else
                    self.coconut[i][j] = FlipNode.create("coin", self.character[self.currentIndex][i][j], i, j)
                end
             end
             if self.isFirst[self.currentIndex][i][j] == 1 or self.isFirst[self.currentIndex][i][j] == 2 or self.isFirst[self.currentIndex][i][j] == 3 then
                self.firstNodeArray[self.isFirst[self.currentIndex][i][j]].x = i
                self.firstNodeArray[self.isFirst[self.currentIndex][i][j]].y = j
             end
             if self.isFirst[self.currentIndex][i][j] == self.firstIndex then
                self.coconut[i][j].firstStyle()
                self.coconut[i][j]:setLocalZOrder(1)
                self.coconut[i][j]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(2),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale),cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
             end
             if self.isTrying and self.isCrab[self.currentIndex][i][j] == 1 then
                self.coconut[i][j]:setLocalZOrder(1)
             end
           
            if self.currentIndex == 1 then
                if chapter == 1 then
                    self.coconut[i][j].bullet = sp.SkeletonAnimation:create("spine/summaryboss/zongjieboss_2_douzi_zhuan.json","spine/summaryboss/zongjieboss_2_douzi_zhuan.atlas",1)
                    self.coconut[i][j].bullet:setAnimation(0,'animation',true)
                elseif chapter == 2 then
                    self.coconut[i][j].bullet = cc.Sprite:create('image/summarybossscene/bullet_popcorn.png')
                else
                    self.coconut[i][j].bullet = sp.SkeletonAnimation:create("spine/summaryboss/third-level-summary-boss-coin-effect.json","spine/summaryboss/third-level-summary-boss-coin-effect.atlas",1)
                    self.coconut[i][j].bullet:setAnimation(0,'animation',true)
                end
                self:addChild(self.coconut[i][j])
                self:addChild(self.coconut[i][j].bullet,2)
            else
                self.coconut[i][j].bullet:stopAllActions()  
            end
            self.coconut[i][j].bullet:setPosition(self.hole[i][j]:getPosition())
            self.coconut[i][j].bullet:setVisible(false)
            self.coconut[i][j]:setScale(0)
            self.coconut[i][j]:setPosition(self.hole[i][j]:getPosition())
            
            local delaytime = 0
            if self.currentIndex == 1 then
                --delaytime = 1.5
            end
            if i == self.mat_length and j == 1 then
                local unlock = cc.CallFunc:create(function() 
                    if not self.isTutorial then
                        self.gameStart = true
                        self.globalLock = false
                    end
                end,{})
                self.coconut[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (self.mat_length - 1 + i - j) + delaytime),cc.ScaleTo:create(0.1, scale),unlock))
            else
                self.coconut[i][j]:runAction(cc.Sequence:create(cc.DelayTime:create(0.1 * (self.mat_length - 1 + i - j) + delaytime),cc.ScaleTo:create(0.1, scale)))
            end
            self.coconut[i][j].isFirst = self.isFirst[self.currentIndex][i][j]
        end
    end
    
    self:initCrab(chapter)
end

function SummaryBossLayer:checkTouchLocation(location)
    --local time1 = os.clock()
    local main_width    = 640
    
    local gap       = 120
    local left      = (main_width - (self.mat_length-1)*gap) / 2
    local bottom    = 220 + (5-self.mat_length)* 100
    local main_height   = bottom * 2 + (self.mat_length-1) * gap 
    local i = 0
    local j = 0

    local node_example = self.coconut[1][1]
    local node_example_size = node_example:getContentSize()

    if location.x < (left - node_example_size.width / 2) or location.x > (main_width - (left - node_example_size.width / 2)) or
        location.y < (bottom - node_example_size.height / 2) or location.y > (main_height - (bottom - node_example_size.height / 2)) then
        self.onNode = false
    elseif  ((gap - node_example_size.width )/2) < ((location.x - (left - node_example_size.width / 2)) % gap) and
        ((gap + node_example_size.width )/2) > ((location.x - (left - node_example_size.width / 2)) % gap) and
        ((gap - node_example_size.height )/2) < ((location.y - (bottom - node_example_size.height / 2)) % gap) and
        ((gap + node_example_size.height )/2) > ((location.y - (bottom - node_example_size.height / 2)) % gap) then

        i = math.ceil((location.x - (left - node_example_size.width / 2)) / gap)
        j = math.ceil((location.y - (bottom - node_example_size.height / 2)) / gap)

        self.current_node_x = i
        self.current_node_y = j
        --print('current_node',i,j)

        local node = self.coconut[i][j]
        local node_position = cc.p(node:getPosition())

        local x = location.x - node_position.x
        local y = location.y - node_position.y

        if y > x and y > -x then
            self.current_dir = dir_up
        elseif y < x and y < -x then
            self.current_dir = dir_down
        elseif y > x and y < -x then
            self.current_dir = dir_left
        else
            self.current_dir = dir_right
        end
        self.onNode = true
    else
        self.onNode = false
    end
    --print('chack location time = '..os.clock() - time1)
end

function SummaryBossLayer:crabSmall(chapter,index)
    if chapter == 1 then
        self.ccbcrab[index]['boardBig']:setVisible(false)
        self.ccbcrab[index]['boardSmall']:setVisible(true)
        self.ccbcrab[index]['legBig']:setVisible(false)
        self.ccbcrab[index]['legSmall']:setVisible(true)
    else
        self.crab[index]:setScale(1.0)
    end
end

function SummaryBossLayer:crabBig(chapter,index)
    if chapter == 1 then
        self.ccbcrab[index]['boardBig']:setVisible(true)
        self.ccbcrab[index]['boardSmall']:setVisible(false)
        self.ccbcrab[index]['legBig']:setVisible(true)
        self.ccbcrab[index]['legSmall']:setVisible(false)
    else
        self.crab[index]:setScale(1.2)
    end
end

function SummaryBossLayer:win(chapter,entrance,wordList)
    self.globalLock = true
    if self.isTrying then
        self:leaveTutorial()
        return
    end

    self.failTime = 0
    if self.leftTime < 10 or self.useItem then
        s_CURRENT_USER.winCombo = 0
    else 
        s_CURRENT_USER.winCombo = s_CURRENT_USER.winCombo + 1
    end
    if entrance then
        if s_CURRENT_USER.winCombo > 3 and s_CURRENT_USER.timeAdjust > -30 then
            s_CURRENT_USER.timeAdjust = s_CURRENT_USER.timeAdjust - 5
        elseif s_CURRENT_USER.winCombo <= 3 then
            s_CURRENT_USER.timeAdjust = 0
        end
    end

    saveUserToServer({['timeAdjust']=s_CURRENT_USER.timeAdjust, 
                      ['winCombo']=s_CURRENT_USER.winCombo,
                      ['failTime']=s_CURRENT_USER.failTime})
    --s_CorePlayManager.leaveSummaryModel(true)
    self.girl:setAnimation(0,'girl_win',true)
    s_SCENE:callFuncWithDelay(1.5,function (  )
        local alter = SummaryBossAlter.create(self,true,chapter,entrance)
        alter:setPosition(0,0)
        self:addChild(alter,1000)
    end)
    
--    -- win sound
--    playSound(s_sound_win)

    AnalyticsSummaryBossResult('win')
end

function SummaryBossLayer:lose(chapter,entrance,wordList)
    self.globalLock = true
    self.girl:setAnimation(0,'girl-fail',true)
    if not self.useItem then
        s_CURRENT_USER.winCombo = 0
        s_CURRENT_USER.failTime = s_CURRENT_USER.failTime + 1
        if entrance then
            if s_CURRENT_USER.failTime > 3 and s_CURRENT_USER.timeAdjust < 30 then
                s_CURRENT_USER.timeAdjust = s_CURRENT_USER.timeAdjust + 5
            elseif s_CURRENT_USER.failTime <= 3 then
                s_CURRENT_USER.timeAdjust = 0
            end
        end
        saveUserToServer({['timeAdjust']=s_CURRENT_USER.timeAdjust, 
                          ['winCombo']=s_CURRENT_USER.winCombo,
                          ['failTime']=s_CURRENT_USER.failTime})
    end

    s_SCENE:callFuncWithDelay(2,function (  )
            -- body
        print('chapter',chapter)
        local alter = SummaryBossAlter.create(self,false,chapter,entrance)
        alter:setPosition(0,0)
        self:addChild(alter,1000)
    end)
    
--    -- lose sound
--    playSound(s_sound_fail)    
    --AnalyticsSummaryBossResult('lose')
end

function SummaryBossLayer:leaveTutorial()
    local StoryLayer = require('view.level.StoryLayer')
    local storyLayer = StoryLayer.create(7)
    s_SCENE:replaceGameLayer(storyLayer)
end

function SummaryBossLayer:hint()
    self:clearCombo()
    self.crab[self.firstIndex]:stopAllActions()
    self.coconut[self.firstNodeArray[self.firstIndex].x][self.firstNodeArray[self.firstIndex].y]:stopAllActions()
    self.isHinting = true
    local num = math.random(1,#self.wordPool[self.currentIndex])
    local index = 1
    for i = 1, #self.wordPool[self.currentIndex] do
        if self.crabOnView[i] then
            index = i
            break
        end
    end
    self.currentHintWord[index] = true
    self.crab[self.firstIndex]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
    for i = 1, self.mat_length do
        for j = 1, self.mat_length do
            if self.isCrab[self.currentIndex][i][j] == index then
                self.coconut[i][j]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.15 * scale),cc.ScaleTo:create(0.5,1.0 * scale))))
            end
        end
    end
    if not self.girlAfraid then
        for i = 1,7 do
            if self.bubble[i]:isVisible() then
                self.bubble[i]:setVisible(false)
            end
        end
        if self.bubble[8] == nil then
            local bubble = ccui.Scale9Sprite:create('image/summarybossscene/bubble1.png',cc.rect(0,0,175,88),cc.rect(60, 0, 55, 88))
            local start_label = cc.Label:createWithSystemFont('恩~这个单词\n应该是'..self.wordPool[self.currentIndex][index],'',20)
            bubble:setContentSize(cc.size(start_label:getContentSize().width + 30,88))
            bubble:ignoreAnchorPointForPosition(false)
            bubble:setAnchorPoint(0,0)
            bubble:setPosition(90,140)
            self.girl:addChild(bubble)
            start_label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
            start_label:setPosition(bubble:getContentSize().width / 2,bubble:getContentSize().height * 0.6)
            bubble:addChild(start_label)
            self.bubble[8] = bubble
        end
        self.bubble[8]:setVisible(true)
    end
end

function SummaryBossLayer:clearCombo()
    self.combo = 0
    for i = 4,12 do
        self.combo_icon[i]:runAction(cc.FadeOut:create(0))
    end
    for i = 1,2 do
        self.combo_label[i]:runAction(cc.FadeTo:create(0.2,255))
    end
    for i = 3,8 do
        self.combo_label[i]:runAction(cc.FadeTo:create(0.2,0))
    end
end

return SummaryBossLayer