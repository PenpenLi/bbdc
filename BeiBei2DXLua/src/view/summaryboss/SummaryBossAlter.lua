require("common.global")

local Button                = require("view.button.longButtonInStudy")

local ENTRANCE_WORD_LIBRARY = false
local ENTRANCE_NORMAL = true

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)

function SummaryBossAlter.create(bossLayer,win,index,entrance)

    local layer = SummaryBossAlter.new()
    layer.wordCount = bossLayer.rightWord
    layer.win = win
    layer.index = index
    layer.levelIndex = levelIndex
    layer.wordList = bossLayer.wordList
    layer.bossLayer = bossLayer
    layer.entrance = entrance
    --disable pauseBtn
    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(false)
        s_SCENE.popupLayer.isOtherAlter = true
    end    
    if layer.index > 3 then
        layer.index = 3
    end
    local back = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    back:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    layer:addChild(back)
    back:setName('background')

    if win then
        if entrance == ENTRANCE_NORMAL then
            AnalyticsPassSecondSummaryBoss()
            s_CURRENT_USER:addBeans(3)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
        end
        layer:win1(entrance)  
        cc.SimpleAudioEngine:getInstance():stopMusic()

        s_SCENE:callFuncWithDelay(0.3,function()
            -- win sound
            playMusic(s_sound_win,true)
        end)
    else    
        if not bossLayer.useItem then
            layer:lose(entrance)
        else
            layer:lose2(entrance)
        end

        cc.SimpleAudioEngine:getInstance():stopMusic()

        -- s_SCENE:callFuncWithDelay(0.3,function()
        --     -- win sound
        --     playSound(s_sound_fail)
        -- end)
    end

    return layer
end

function SummaryBossAlter:lose(entrance)
    if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
        s_CURRENT_USER:setTutorialStep(s_tutorial_summary_boss + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_timeout)
    end

    --add board
    self.loseBoard = cc.Sprite:create("image/summarybossscene/background_zjboss_tanchu.png")
    self.loseBoard:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    self.loseBoard:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(self.loseBoard)

    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(beans)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)

    local boss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:addAnimation(0,'jianxiao',true)
    boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height / 3)
    self.loseBoard:addChild(boss)

    local label = cc.Label:createWithSystemFont("时间已经用完了！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.75)
    label:setColor(cc.c4b(52,177,241,255))
    self.loseBoard:addChild(label)

    local giveup = Button.create("giveup","blue","放弃挑战")
    giveup:setPosition(self.loseBoard:getContentSize().width / 2 + 10,self.loseBoard:getContentSize().height * 0.18 + 2)
    self.loseBoard:addChild(giveup)

    local function button_giveup_func()
        self:lose2(entrance)
    end

    giveup.func = function ()
        button_giveup_func()
    end

    boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height * 0.4)
    local buyTimeBtn = Button.create("addtime","blue","再来30秒")
    buyTimeBtn:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.3 + 15)
    self.loseBoard:addChild(buyTimeBtn)

    local been_button = cc.Sprite:create("image/shop/been.png")
    been_button:setScale(0.8)
    been_button:setPosition(buyTimeBtn.button_front:getContentSize().width * 0.8, buyTimeBtn.button_front:getContentSize().height/2)
    buyTimeBtn.button_front:addChild(been_button)

    local rewardNumber = cc.Label:createWithSystemFont(10,"",24)
    rewardNumber:enableOutline(cc.c4b(255,255,255,255),1)
    rewardNumber:setPosition(buyTimeBtn.button_front:getContentSize().width * 0.9,buyTimeBtn.button_front:getContentSize().height * 0.5)
    buyTimeBtn.button_front:addChild(rewardNumber)



    local function button_buyTime_func()
        if s_CURRENT_USER:getBeans() >= 10 then
            s_CURRENT_USER:addBeans(-10)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
            local boss = self.bossLayer.bossNode
            local distance = s_DESIGN_WIDTH * 0.45 * 30 / self.bossLayer.totalTime
            self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
            s_SCENE:callFuncWithDelay(0.3,function (  )
                -- body
                self:getChildByName('background'):runAction(cc.FadeOut:create(1.0))
                boss:runAction(cc.Sequence:create(cc.MoveTo:create(1.0,cc.p(s_DESIGN_WIDTH * 0.15 + distance , s_DESIGN_HEIGHT * 0.75 + 20)),cc.CallFunc:create(function (  )
                    -- body
                    self:removeChildByName('background')
                    self:addTime()
                end)))
            end)
        else
            local shopErrorAlter = require("view.shop.ShopErrorAlter").create()
            s_SCENE:popup(shopErrorAlter)
        end
    end

    buyTimeBtn.func = function ()
        button_buyTime_func()
    end

    onAndroidKeyPressed(self, function ()
        self:lose2(entrance)
    end, function ()

    end)


end

function SummaryBossAlter:addTime()

    AnalyticsSummaryBossAddTime()

    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(true)
        s_SCENE.popupLayer.isOtherAlter = false
    end 

    local bossLayer = self.bossLayer
    local boss = bossLayer.bossNode
    local distance = s_DESIGN_WIDTH * 0.45 * 30 / bossLayer.totalTime
    local index = self.index
    local entrance = self.entrance
    local wordList = self.wordList
    bossLayer.useItem = true
    playMusic(s_sound_Get_Outside,true)

    --boss:setPosition(s_DESIGN_WIDTH * 0.15 + distance , s_DESIGN_HEIGHT * 0.75)
    bossLayer.globalLock = false
    bossLayer.girlAfraid = false
    bossLayer.girl:setAnimation(0,'girl-stand',true)
    bossLayer.isLose = false
    bossLayer.leftTime = 30
    bossLayer.totalTime = 30
    local wait = cc.DelayTime:create(30.0 - bossLayer.totalTime * 0.2)
    local afraid = cc.CallFunc:create(function() 
        if bossLayer.currentBlood > 0 then
            bossLayer.girlAfraid = true
            HINT_TIME = 4
            bossLayer.girl:setAnimation(0,'girl-afraid',true)
            -- deadline "Mechanical Clock Ring "
            playSound(s_sound_Mechanical_Clock_Ring)
            playMusic(s_sound_Get_Outside_Speedup,true)
        end
    end,{})
    local blinkIn = cc.FadeTo:create(0.5,50)
    local blinkOut = cc.FadeTo:create(0.5,0.0)
    local blink = cc.Sequence:create(blinkIn,blinkOut)
    local repeatBlink = cc.Repeat:create(blink,math.ceil(bossLayer.totalTime * 0.2))
    bossLayer.blink:runAction(cc.Sequence:create(wait,afraid,repeatBlink))
    local bossAction = {}
    for i = 1, 6 do
        local stop = cc.DelayTime:create(bossLayer.totalTime / 6 * 0.8)
        local stopAnimation = cc.CallFunc:create(function() 
            bossLayer.boss:setAnimation(0,'a2',true)
        end,{})
        local move = cc.MoveBy:create(bossLayer.totalTime / 6 * 0.2,cc.p(- distance / 6, 0))
        local moveAnimation = cc.CallFunc:create(function() 
            bossLayer.boss:setAnimation(0,'animation',false)
        end,{})
        bossAction[#bossAction + 1] = cc.Spawn:create(stop,stopAnimation)
        bossAction[#bossAction + 1] = cc.Spawn:create(move,moveAnimation)
    end
    bossAction[#bossAction + 1] = cc.CallFunc:create(function() 

            if bossLayer.currentBlood > 0 then
                bossLayer.isLose = true
                --print('chapter index'..self.index)
                bossLayer:lose(index,entrance,wordList)    
            end
    end,{})
    boss:runAction(cc.Sequence:create(bossAction))
    self:removeFromParent()
    --bossLayer.girl:
end

function SummaryBossAlter:lose2(entrance)
    if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
        s_CURRENT_USER:setTutorialStep(s_tutorial_summary_boss + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_lose)
    end

    playMusic(s_sound_fail,true)

    self.loseBoard2 = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_%d.png",self.index))
    self.loseBoard2:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5)
    if self.loseBoard ~= nil then
        self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
    end
    self.loseBoard2:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5)))))
    self:addChild(self.loseBoard2)

    local boss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:addAnimation(0,'jianxiao',true)
    boss:setPosition(self.loseBoard2:getContentSize().width / 4,self.loseBoard2:getContentSize().height * 0.22)
    self.loseBoard2:addChild(boss)

    local label = cc.Label:createWithSystemFont("挑战失败！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.64)
    label:setColor(cc.c4b(251.0, 39.0, 10.0, 255))
    self.loseBoard2:addChild(label)

    local label1 = cc.Label:createWithSystemFont(string.format("还需要找出%d个单词！\n做好准备再来",#self.wordList - self.wordCount),'',40)
    label1:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label1:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.55)
    label1:setColor(cc.c4b(52,177,241,255))
    self.loseBoard2:addChild(label1)

    local head = cc.Sprite:create("image/summarybossscene/summaryboss_lose_head.png")
    head:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.75)
    self.loseBoard2:addChild(head)

    local continue = Button.create("small","blue","返回学习")
    continue:setPosition(self.loseBoard2:getContentSize().width / 2 - 130,self.loseBoard2:getContentSize().height * 0.15)
    self.loseBoard2:addChild(continue)

    local function backToLevelScene()
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        playSound(s_sound_buttonEffect)
    end

    continue.func = function ()
        backToLevelScene()
    end

    local again = Button.create("small","blue","再来一次")
    again:setPosition(self.loseBoard2:getContentSize().width / 2 + 130,self.loseBoard2:getContentSize().height * 0.15)
    self.loseBoard2:addChild(again)

    local function challengeAgain()
        if entrance == ENTRANCE_NORMAL then
            s_CorePlayManager.initSummaryModel()
        else
            local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(self.wordList,1,false)
            s_SCENE:replaceGameLayer(summaryBossLayer) 
        end

        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        playSound(s_sound_buttonEffect)
        AnalyticsSummaryBossResult('again')
    end

    again.func = function ()
        challengeAgain()
    end



    onAndroidKeyPressed(self, function ()
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
    end, function ()

    end)

end

function SummaryBossAlter:win1(entrance)

    if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
        s_CURRENT_USER:setTutorialStep(s_tutorial_summary_boss + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_win)
    end
    local hasCheckedIn = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey)
    if s_LocalDatabaseManager:getTodayRemainTaskNum() < 2 and not hasCheckedIn then
        checkInEverydayInfo()
        s_isCheckInAnimationDisplayed = false
    end

    if not hasCheckedIn and entrance == ENTRANCE_NORMAL then
        local missionCompleteCircle = require('view.MissionCompleteCircle').create()
        s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionComplete')
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
            self:win2(entrance,hasCheckedIn)
            if entrance == ENTRANCE_NORMAL then
                s_CorePlayManager.leaveSummaryModel(true)
            end
        end,{})))
    else
        self:win2(entrance,hasCheckedIn)
        if entrance == ENTRANCE_NORMAL then
            s_CorePlayManager.leaveSummaryModel(true)
        end
    end


end

function SummaryBossAlter:win2(entrance,hasCheckedIn)
    local backColor = cc.LayerColor:create(cc.c4b(180,241,254,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backColor)

    -- local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    -- been_number_back:setPosition(s_RIGHT_X - s_LEFT_X -100, s_DESIGN_HEIGHT-50)
    -- backColor:addChild(been_number_back)

    -- local been = cc.Sprite:create("image/shop/been.png")
    -- been:setPosition(0, been_number_back:getContentSize().height/2)
    -- been_number_back:addChild(been)

    -- local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    -- been_number:setColor(cc.c4b(0,0,0,255))
    -- been_number:setPosition(been_number_back:getContentSize().width/2 , been_number_back:getContentSize().height/2)
    -- been_number_back:addChild(been_number)

    local win_back = cc.Sprite:create('image/summarybossscene/win_back.png')
    win_back:setAnchorPoint(0.5,0)
    win_back:setPosition(s_DESIGN_WIDTH / 2,-140)
    self:addChild(win_back)
    if not self.entrance then
        win_back:setPosition(s_DESIGN_WIDTH / 2,0)
    end

    local function button_func()
        if entrance == ENTRANCE_WORD_LIBRARY then
            s_CorePlayManager.enterLevelLayer()
        else
            if s_HUD_LAYER:getChildByName('missionComplete') ~= nil then
                s_HUD_LAYER:getChildByName('missionComplete'):setVisible(false)
            end
            s_CorePlayManager.enterLevelLayer()
        end
    end

    local button = Button.create("long","blue","完成")
    button:setPosition(s_DESIGN_WIDTH / 2 ,150)
    self:addChild(button)
    button.func = function ()
        button_func()
    end

    -- if self.entrance == ENTRANCE_NORMAL then

    --     local been_button = cc.Sprite:create("image/shop/been.png")
    --     been_button:setPosition(button:getContentSize().width * 0.75, button:getContentSize().height/2)
    --     button:addChild(been_button)

    --     local rewardNumber = cc.Label:createWithSystemFont("+"..3,"",36)
    --     rewardNumber:setPosition(button:getContentSize().width * 0.88,button:getContentSize().height * 0.5)
    --     button:addChild(rewardNumber)
    -- end
    if hasCheckedIn or not self.entrance then
        --print('self:addWinLabel(win_back)')
        self:addWinLabel(win_back)
    else
        s_SCENE:callFuncWithDelay(2,function (  )
            self:addWinLabel(win_back)
        end)
    end

    onAndroidKeyPressed(self, function ()
        s_HUD_LAYER:removeChildByName('missionComplete')
        s_CorePlayManager.enterLevelLayer()
    end, function ()

    end)


end

function SummaryBossAlter:addWinLabel(win_back)

    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_RIGHT_X -100, s_DESIGN_HEIGHT-70)
    self:addChild(beans)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans()-3,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)
    been_number:setVisible(false)

    local title = cc.Sprite:create('image/summarybossscene/title_shengli_study.png')
    title:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.92)
    self:addChild(title)

    local right_label = cc.Label:createWithSystemFont('答对         单词','',32)
    right_label:setColor(cc.c3b(70,136,158))
    right_label:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.92 - 100)
    self:addChild(right_label)
    local word_count = 0
    local word_count_label = cc.Label:createWithSystemFont(string.format('%d',word_count),'',48)
    word_count_label:setPosition(right_label:getPositionX(),right_label:getPositionY() + 2)
    word_count_label:setColor(cc.c3b(251,227,65))
    word_count_label:enableOutline(cc.c4b(255,172,40,255),2)
    self:addChild(word_count_label)

    local time_label = cc.Label:createWithSystemFont('耗时       分钟         秒','',32)
    time_label:setColor(cc.c3b(70,136,158))
    time_label:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.92 - 170)
    self:addChild(time_label)   

    local min_count = 0
    local sec_count = 0
    local min_count_label = cc.Label:createWithSystemFont(string.format('%d',min_count),'',48)
    min_count_label:setPosition(time_label:getPositionX() - 52,time_label:getPositionY() + 2)
    min_count_label:setColor(cc.c3b(255,0,0))
    --min_count:enableOutline(cc.c4b(255,0,0,255),1)
    self:addChild(min_count_label)

    local sec_count_label = cc.Label:createWithSystemFont(string.format('%d',sec_count),'',48)
    sec_count_label:setPosition(time_label:getPositionX() + 72,time_label:getPositionY() + 2)
    sec_count_label:setColor(cc.c3b(255,0,0))
    --sec_count:enableOutline(cc.c4b(255,0,0,255),1)
    self:addChild(sec_count_label)
    local bean_back = {}
    for i = 1,3 do
        bean_back[i] = cc.Sprite:create('image/summarybossscene/been_background_complete_studys.png')
        self:addChild(bean_back[i],1)
        bean_back[i]:setVisible(false)
    end
    bean_back[1]:setPosition(s_DESIGN_WIDTH / 2 - 100,s_DESIGN_HEIGHT * 0.67)
    bean_back[2]:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.67 + 30)
    bean_back[3]:setPosition(s_DESIGN_WIDTH / 2 + 100,s_DESIGN_HEIGHT * 0.67)

    if self.entrance then
        been_number:setVisible(true)
        for i = 1,3 do
            bean_back[i]:setVisible(true)
        end
    end
    local function update(delta)
        --print('delta='..delta)
        if word_count < self.bossLayer.maxCount then
            word_count = word_count + 1
            word_count_label:setString(string.format('%d',word_count))
        end
        if min_count < math.floor(self.bossLayer.useTime/60) then
            min_count = min_count + 1
            min_count_label:setString(string.format('%d',min_count))
        end
        if sec_count < math.floor(self.bossLayer.useTime%60) then
            -- if 60 - sec_count > 1 then
            --     sec_count = sec_count + 2
            -- else
            sec_count = sec_count + 1 
            -- end
            sec_count_label:setString(string.format('%d',sec_count))
        end
        if word_count == self.bossLayer.maxCount and min_count == math.floor(self.bossLayer.useTime/60) and sec_count >= math.floor(self.bossLayer.useTime%60) then
            if self.entrance then
                for i = 1,3 do
                    local bean = cc.Sprite:create('image/summarybossscene/been_complete_studys.png')
                    bean:setPosition(bean_back[i]:getContentSize().width / 2,bean_back[i]:getContentSize().height / 2 + 10)
                    bean_back[i]:addChild(bean)
                    bean:setOpacity(0)
                    bean:setScale(3)
                    local action1 = cc.DelayTime:create(0.3 * i)
                    local action2 = cc.EaseSineIn:create(cc.ScaleTo:create(0.3,1))
                    local action3 = cc.FadeIn:create(0.3)
                    bean:runAction(cc.Sequence:create(action1,cc.Spawn:create(action2,action3)))
                end
                local shine = cc.Sprite:create('image/summarybossscene/shine_complete_studys.png')
                shine:setOpacity(0)
                shine:setPosition(bean_back[2]:getPositionX(),bean_back[2]:getPositionY())
                self:addChild(shine)
                local fadeInOut = cc.Sequence:create(cc.FadeTo:create(1,255 * 0.7),cc.FadeOut:create(1))
                shine:runAction(cc.Spawn:create(fadeInOut,cc.RotateBy:create(2,360)))
                for i = 1,3 do
                    local action1 = cc.DelayTime:create(2 + 0.3 * i)
                    local action2 = cc.EaseSineIn:create(cc.MoveTo:create(0.3,cc.p(beans:getPosition())))
                    local action3 = cc.ScaleTo:create(0.3,0)
                    local action4 = cc.CallFunc:create(function (  )
                        been_number:setString(s_CURRENT_USER:getBeans() - 3 + i)
                    end,{})
                    local bean = cc.Sprite:create('image/summarybossscene/been_complete_studys.png')
                    bean:setPosition(bean_back[i]:getPositionX(),bean_back[i]:getPositionY() + 10)
                    self:addChild(bean,2)
                    bean:setVisible(false)
                    bean:runAction(cc.Sequence:create(cc.DelayTime:create(1.2),cc.Show:create()))
                    bean:runAction(cc.Sequence:create(action1,cc.Sequence:create(action2,action3),action4))
                end
            end
            --print('count time = '..os.clock() - time1)
            self:unscheduleUpdate()

        end


    end
    self:scheduleUpdateWithPriorityLua(update, 0)

    local boss = sp.SkeletonAnimation:create("spine/summaryboss/beidadekls.json","spine/summaryboss/beidadekls.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:setPosition(0.5 * s_DESIGN_WIDTH- 200,230)
    self:addChild(boss)


end

return SummaryBossAlter