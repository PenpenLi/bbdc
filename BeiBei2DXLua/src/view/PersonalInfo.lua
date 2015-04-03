require("cocos.init")
require("common.global")
CC_USE_DEPRECATED_API = true

local PersonalInfo = class("PersonalInfo", function()
    return cc.Layer:create()
end)

PersonalInfo.hasGotNotContainedInLocalDatas = false
-- function callback() end
function PersonalInfo.getNotContainedInLocalDatas(callback)
    if PersonalInfo.hasGotNotContainedInLocalDatas or (not s_SERVER.isNetworkConnectedWhenInited() or not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken()) then
        if callback then callback() end
        return
    end

    showProgressHUD('', true)
    getNotContainedInLocalEverydayInfosFromServer(function (serverDatas, error)
        PersonalInfo.hasGotNotContainedInLocalDatas = (error == nil)

        getNotContainedInLocalDailyStudyInfoFromServer(function (serverDatas, error)
        
            PersonalInfo.hasGotNotContainedInLocalDatas = (error == nil)
            if callback then callback() end
            hideProgressHUD(true)

        end)

    end)
end

function PersonalInfo.create(checkIn,homelayer,targetIndex)
    local layer = PersonalInfo.new()
    layer.checkIn = false
    layer.homelayer = homelayer
    if checkIn then
        layer.checkIn = true
    end
    if targetIndex ~= nil then
        layer.targetIndex = targetIndex
    end
    return layer
end

function PersonalInfo:ctor()

    math.randomseed(os.time())
    local UNLOCK = 1
    self.totalDay = 1
    local moved = false
    local start_y = nil
    local colorArray = {cc.c4b(56,182,236,255),cc.c4b(238,75,74,255 ),cc.c4b(251,166,24,255 ),cc.c4b(128,172,20,255 )}
    local titleArray = {'单词掌握统计','单词学习日增长','登陆贝贝天数','学习效率统计'}
    self.intro_array = {}
    local target = {}

    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT - 280))
    pageView:setPosition(s_LEFT_X,0)
    pageView:setVertical(true)   
    pageView:setUsingCustomScrollThreshold(true)
    pageView:setCustomScrollThreshold(180)
    
    for i = 1 , 4 do
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT))

        local intro = cc.LayerColor:create(cc.c4b(255,255,255,255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT - 280)
        intro:ignoreAnchorPointForPosition(false)
        intro:setAnchorPoint(0.5,0) 
        intro:setPosition((s_RIGHT_X - s_LEFT_X) / 2 ,0)
        layout:addChild(intro,0,string.format('back%d',i))
        if i > 1 then
            local scrollButton = cc.Sprite:create("image/PersonalInfo/scrollHintButton.png")
            scrollButton:setPosition(s_DESIGN_WIDTH/2 - s_LEFT_X  ,s_DESIGN_HEIGHT * 0.05)
            scrollButton:setLocalZOrder(1)
            layout:addChild(scrollButton)
            local move = cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-20)),cc.MoveBy:create(0.5,cc.p(0,20)))
            scrollButton:runAction(cc.RepeatForever:create(move))

            local scrollPageButton = ccui.Button:create('image/PersonalInfo/scroll_page_button.png','')
            --scrollPageButton:setScale9Enabled(true)
            scrollPageButton:setScaleY(0.5)
            scrollPageButton:setPosition(s_DESIGN_WIDTH/2 - s_LEFT_X  ,s_DESIGN_HEIGHT * 0.05)
            layout:addChild(scrollPageButton)

            local function scrollPageEvent(sender,eventType)
                if eventType == ccui.TouchEventType.ended then
                    pageView:scrollToPage(i - 2)
                end
            end
            scrollPageButton:addTouchEventListener(scrollPageEvent)

        end

        local share = ccui.Button:create('image/PersonalInfo/button_fenxiang_data.png','image/PersonalInfo/button_fenxiang_data_pressed.png','')
        share:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X + 250,0.9 * intro:getContentSize().height + 30)
        layout:addChild(share)
        local title_here = titleArray[5 - i]
        local title
        if s_CURRENT_USER:getLockFunctionState(6 - i) ~= UNLOCK then
            title_here = titleArray[5 - i].."被锁住了!"
            
            
            local ShopPanel = require('view.shop.ShopPanel')
            local shopPanel = ShopPanel.create(6-i)
            shopPanel:setPosition((s_RIGHT_X - s_LEFT_X)/2, 0)
            layout:addChild(shopPanel)
            
            shopPanel.feedback = function()
                local curPage = pageView:getCurPageIndex()
                share:setVisible(true)
                title:setString(titleArray[5 - i])
                title:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.9 * intro:getContentSize().height + 30)
                if curPage == 3 then
                    self:PLVM()
                    AnalyticsDataCenterPage('PLVM')
                elseif curPage == 2 then
                    self:PLVI()
                    AnalyticsDataCenterPage('PLVI')
                elseif curPage == 1 then
                    self:login()
                    AnalyticsDataCenterPage('LOGIN')
                elseif curPage == 0 then
                    self:XXTJ()
                    AnalyticsDataCenterPage('XXTJ')
                end
            end
            
            share:setVisible(false)
        end
        title = cc.Label:createWithSystemFont(title_here,'',36)
        --title:enableOutline(colorArray[5- i],1)
        if s_CURRENT_USER:getLockFunctionState(6 - i) ~= UNLOCK then
            title:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.9 * intro:getContentSize().height - 15)
        else
            title:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.9 * intro:getContentSize().height + 30)
        end
        title:setColor(colorArray[5 - i])
        layout:addChild(title)

        
        local counter = 0
        --local target = nil

        local top = nil
        local function addTop()
            top = cc.LayerColor:create(cc.c4b(211,239,254,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT - intro:getContentSize().height)
            top:ignoreAnchorPointForPosition(false)
            top:setAnchorPoint(0,0)
            top:setPosition(0,intro:getContentSize().height)
            intro:addChild(top)

            local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
            head:setPosition(top:getContentSize().width * 0.25, top:getContentSize().height * 0.5)
            top:addChild(head)

            local logoWord = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/title_shouye_name.png'))
            logoWord:setType(cc.PROGRESS_TIMER_TYPE_BAR)
            logoWord:setMidpoint(cc.p(0.5, 1))
            logoWord:setBarChangeRate(cc.p(0, 1))
            logoWord:setPercentage(80) 
            logoWord:setScale(0.8)
            logoWord:setAnchorPoint(0,0.5)
            logoWord:setPosition(top:getContentSize().width * 0.4 + 30, top:getContentSize().height * 0.55)
            top:addChild(logoWord)

            local name = cc.Label:createWithSystemFont(s_CURRENT_USER:getNameForDisplay(),'',36)
            name:setAnchorPoint(0,1)
            name:setPosition(top:getContentSize().width * 0.4 + 30, top:getContentSize().height * 0.5 - 15)
            name:setColor(cc.c3b(92,130,140))
            top:addChild(name)

            local title = cc.Label:createWithSystemFont(titleArray[5 - i],'',36)
            title:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.9 * intro:getContentSize().height + 30)
            title:setColor(colorArray[5 - i])
            intro:addChild(title)
            target[i]:begin()
            intro:visit()
            target[i]:endToLua()
            top:removeFromParent()
        end

        local function saveImage(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                addTop()
            end
            if eventType == ccui.TouchEventType.ended then
                AnalyticsButtonToShare()
                local ShareDataInfo = require('view.share.ShareDataInfo')
                local shareDataInfo = ShareDataInfo.create(target[i],i)
                self:addChild(shareDataInfo,20)
                counter = counter + 1
            end
        end
        share:addTouchEventListener(saveImage)

        -- create a render texture, this is what we are going to draw into
        target[i] = cc.RenderTexture:create(s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
        target[i]:retain()
        target[i]:setPosition(cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2))
        intro:addChild(target[i],10)
        
        table.insert(self.intro_array, intro)
        pageView:addPage(layout)

    end 

    self:addChild(pageView)
    local lastPage = -1
    local function update(delta)
        
        local curPage = pageView:getCurPageIndex()
        if self.checkIn ~= nil and self.checkIn then
            if curPage ~= 1 then
                pageView:scrollToPage(1)
            end
        end
        if self.targetIndex ~= nil then
            pageView:scrollToPage(self.targetIndex)
            self.targetIndex = nil
        end
        if curPage ~= lastPage then
            if lastPage >= 0 then
                self.intro_array[curPage+1]:removeAllChildren()
            end
            lastPage = curPage
            if s_CURRENT_USER:getLockFunctionState(5 - curPage) == UNLOCK then
                if curPage == 3 then
                    self:PLVM()
                    AnalyticsDataCenterPage('PLVM')
                elseif curPage == 2 then
                    self:PLVI()
                    AnalyticsDataCenterPage('PLVI')
                elseif curPage == 1 then
                    self:login()
                    AnalyticsDataCenterPage('LOGIN')
                elseif curPage == 0 then
                    self:XXTJ()
                    AnalyticsDataCenterPage('XXTJ')
                end
            end
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0)

end

function PersonalInfo:PLVM()
    
    local updateTime = 0
    local tolearnCount = s_LocalDatabaseManager.getTotalStudyWordsNum()
    local toMasterCount = s_LocalDatabaseManager.getTotalGraspWordsNum()
    local learnPercent = tolearnCount / s_DataManager.books[s_CURRENT_USER.bookKey].words
    local masterPercent = toMasterCount / s_DataManager.books[s_CURRENT_USER.bookKey].words
    
    local back = self.intro_array[4]
    local circleBack = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_circle_white.png')
    circleBack:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.42 * s_DESIGN_HEIGHT - 40)
    back:addChild(circleBack)
    
    local toLearn = cc.ProgressTo:create(learnPercent,learnPercent * 100)
    local toMaster = cc.ProgressTo:create(masterPercent,masterPercent * 100)

    local backProgress = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVM/shuju_circle_ligheblue.png'))
    backProgress:setScaleX(483 / 526)
    backProgress:setScaleY(483 / 527)
    backProgress:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    backProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    --backProgress:setReverseDirection(true)
    backProgress:setPercentage(0)
    backProgress:runAction(toLearn)
    circleBack:addChild(backProgress)
    
    local circleBackBig = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_big.png')
    circleBackBig:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(circleBackBig)
    
    local circleBackSmall = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_small.png')
    circleBackSmall:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(circleBackSmall)
    
    local learnStr = string.format('已学习%d',tolearnCount)
    local masterStr = string.format('生词数%d',toMasterCount)
    for i = 1,#learnStr - 9 do
        local label = cc.Label:createWithSystemFont(string.sub(learnStr,9 + i,9 + i),'',28)
        local angle =  (1 - i) * 5 - 24
        label:setRotation(- angle)
        --label:setColor(cc.c3b(0,0,0))
        label:setPosition(circleBack:getContentSize().width / 2 + 220 * math.cos(math.pi * (0.5 + angle / 180)),circleBack:getContentSize().height / 2 + 220 * math.sin(math.pi * (0.5 + angle / 180)))
        circleBack:addChild(label,100)
    end
    
    for i = 1,3 do
        local label = cc.Label:createWithSystemFont(string.sub(learnStr,3 * (i - 1) + 1,3 * i),'',28)
        local angle = (1 - i) * 8
        label:setRotation(-angle)
        --label:setColor(cc.c3b(0,0,0))
        label:setPosition(circleBack:getContentSize().width / 2 + 220 * math.cos(math.pi * (0.5 + angle / 180)),circleBack:getContentSize().height / 2 + 220 * math.sin(math.pi * (0.5 + angle / 180)))
        circleBack:addChild(label,100)
    end
    
    for i = 1,#masterStr - 9 do
        local label = cc.Label:createWithSystemFont(string.sub(masterStr,9 + i,9 + i),'',28)
        local angle = (1 - i) * 6 - 33
        label:setRotation(-angle)
        --label:setColor(cc.c3b(0,0,0))
        label:setPosition(circleBack:getContentSize().width / 2 + 161 * math.cos(math.pi * (0.5 + angle / 180)),circleBack:getContentSize().height / 2 + 161 * math.sin(math.pi * (0.5 + angle / 180)))
        circleBack:addChild(label,100)
    end

    for i = 1,3 do
        local label = cc.Label:createWithSystemFont(string.sub(masterStr,3 * (i - 1) + 1,3 * i),'',28)
        --local angle = (#masterStr - 10) * 6 + (4 - i) * 10
        local angle = -(i - 1) * 11
        label:setRotation(-angle)
        --label:setColor(cc.c3b(0,0,0))
        label:setPosition(circleBack:getContentSize().width / 2 + 161 * math.cos(math.pi * (0.5 + angle / 180)),circleBack:getContentSize().height / 2 + 161 * math.sin(math.pi * (0.5 + angle / 180)))
        circleBack:addChild(label,100)
    end
    
    local learnProgress = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_big_dark.png'))
    learnProgress:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    learnProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    --learnProgress:setReverseDirection(true)
    learnProgress:setPercentage(0)
    learnProgress:runAction(cc.ProgressTo:create(learnPercent,learnPercent * 100))
    circleBack:addChild(learnProgress)
    
    local masterProgress = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVM/shuju_ring_blue_small_dark.png'))
    masterProgress:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    masterProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    --masterProgress:setReverseDirection(true)
    masterProgress:setPercentage(0)
    masterProgress:runAction(toMaster)
    circleBack:addChild(masterProgress)
    
    local smallCircle1 = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue1.png')
    smallCircle1:setScale(1,42 / 41)
    smallCircle1:setPosition(0.5 * circleBackBig:getContentSize().width,461.5)
    circleBackBig:addChild(smallCircle1)
    
    local smallCircle2 = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue2.png')
    smallCircle2:setScale(1,42 / 41)
    smallCircle2:setPosition(0.5 * circleBackSmall:getContentSize().width,344)
    circleBackSmall:addChild(smallCircle2)
    
    local smallCircleTail = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue1.png')
    smallCircleTail:setScale(1,42 / 41)
    smallCircleTail:setPosition(0.5 * circleBackBig:getContentSize().width + 220 * math.cos((0.5 + 2 * 0) * math.pi),0.5 * circleBackBig:getContentSize().height + 220 * math.sin((0.5 + 2 * 0) * math.pi))
    circleBackBig:addChild(smallCircleTail)
    if tolearnCount == 0 then
        smallCircleTail:setVisible(false)
        smallCircle1:setVisible(false)
    end
    
    local smallCircleTail2 = cc.Sprite:create('image/PersonalInfo/PLVM/shuju_smallcircle_blue2.png')
    smallCircleTail2:setScale(1,42 / 41)
    smallCircleTail2:setPosition(0.5 * circleBackSmall:getContentSize().width + 161 * math.cos((0.5 + 2 * 0) * math.pi),0.5 * circleBackSmall:getContentSize().height + 161 * math.sin((0.5 + 2 * 0) * math.pi))
    circleBackSmall:addChild(smallCircleTail2)
    
    if toMasterCount == 0 then
        smallCircleTail2:setVisible(false)
        smallCircle2:setVisible(false)
    end
    
    local line = cc.LayerColor:create(cc.c4b(0,0,0,255),150,1)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0.5,0.5)
    line:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(line)
    
    local label_study = cc.Label:createWithSystemFont("已学单词","",30)
    label_study:ignoreAnchorPointForPosition(false)
    label_study:setAnchorPoint(0.5,1)
    label_study:setColor(cc.c4b(38,64,80,255))
    label_study:setOpacity(150)
    label_study:setPosition(0.5 * circleBack:getContentSize().width,0.49 * circleBack:getContentSize().height - 7)
    circleBack:addChild(label_study)
    
    local label_book = cc.Label:createWithSystemFont(s_DataManager.books[s_CURRENT_USER.bookKey].name,"",20)
    label_book:ignoreAnchorPointForPosition(false)
    label_book:setAnchorPoint(0.5,1)
    label_book:setColor(cc.c4b(38,64,80,255))
    label_book:setOpacity(150)
    label_book:setPosition(0.5 * circleBack:getContentSize().width,0.4 * circleBack:getContentSize().height + 2)
    circleBack:addChild(label_book)
    
    local label_percent = cc.Label:createWithSystemFont("0%","",60)
    label_percent:ignoreAnchorPointForPosition(false)
    label_percent:setAnchorPoint(0.5,0)
    label_percent:setColor(cc.c4b(38,64,80,255))
    label_percent:setPosition(0.5 * circleBack:getContentSize().width,0.5 * circleBack:getContentSize().height)
    circleBack:addChild(label_percent)
    
    local function update(delta)
        local per = '%'
        local str = string.format("%.1f%s",learnProgress:getPercentage(),per)
        label_percent:setString(str)
        smallCircleTail:setPosition(0.5 * circleBackBig:getContentSize().width + 220 * math.cos((0.5 - 0.02 * learnProgress:getPercentage()) * math.pi),0.5 * circleBackBig:getContentSize().height + 220 * math.sin((0.5 + 0.02 * learnProgress:getPercentage()) * math.pi))
        smallCircleTail2:setPosition(0.5 * circleBackSmall:getContentSize().width + 161 * math.cos((0.5 - 0.02 * masterProgress:getPercentage()) * math.pi),0.5 * circleBackSmall:getContentSize().height + 161 * math.sin((0.5 + 0.02 * masterProgress:getPercentage()) * math.pi))
    end
    back:scheduleUpdateWithPriorityLua(update, 0)
end


function PersonalInfo:PLVI()
    local back = self.intro_array[3]
    local to = os.time()
--    local from = os.time({year = tonumber(os.date("%Y", s_CURRENT_USER.localTime),10), 
--                         month = tonumber(os.date("%Y", s_CURRENT_USER.localTime),10),  
--                          date = tonumber(os.date("%Y", s_CURRENT_USER.localTime),10),
--                        hour = 0,
--                         min = 0})
    local from = s_CURRENT_USER.localTime - s_CURRENT_USER.localTime % (24 * 3600)
    local sub = to - from
    
    --local dayCount = math.floor(sub / (24 * 3600)) + 1
    local dayCount = tonumber(os.date('%w',os.time()))
    if dayCount == 0 then
        dayCount = 7
    end
    local scale = 1
    
    local yBar = cc.Sprite:create("image/PersonalInfo/PLVI/lv_information_zuobiantiao_1.png")
    yBar:setScaleX(scale)
    yBar:setAnchorPoint(0, 1)
    yBar:setPosition(-s_LEFT_X, s_DESIGN_HEIGHT * 0.77 - 100)
    back:addChild(yBar)
    
    local gezi = cc.Sprite:create("image/PersonalInfo/PLVI/wsy_gezi.png")
    gezi:setScaleX(scale)
    gezi:setOpacity(0)
    gezi:setAnchorPoint(0.0,0.5)
    gezi:setPosition(-s_LEFT_X + yBar:getContentSize().width * scale, s_DESIGN_HEIGHT * 0.5 - 100)
    back:addChild(gezi)
    
    local countArray = {}
    countArray[1] = 0
    local loginData = s_CURRENT_USER.logInDatas
    local daytime = os.time() - dayCount * 24 * 3600
    if #loginData > 1 then
        --local time = os.time() - dayCount * 24 * 3600
        local time = daytime
        for i = 1,#loginData - 1 do
            for j = 1,7 do
                local str = getDayStringForDailyStudyInfo(time)
                countArray[1] = countArray[1] + s_LocalDatabaseManager.getStudyWordsNum(str)
                --print(str,countArray[1])
                time = time - 24 * 3600
            end
        end
    end
    local dateArray = {'周一','周二','周三','周四','周五','周六','周日'}
    math.random(0,20)
    local selectDate = daytime
    for i = 2 , dayCount + 1 do 
        selectDate = selectDate + 24 * 3600
        local str = getDayStringForDailyStudyInfo(selectDate)
        countArray[i] = s_LocalDatabaseManager.getStudyWordsNum(str)
        countArray[i] = countArray[i - 1] + countArray[i]
        --countArray[i] = i * i * 5
    end
    local point = {}
    local selectPoint
    local countLabel
    local tableHeight = gezi:getContentSize().height
    local tableWidth = gezi:getContentSize().width
    local function drawXYLabel(count)
        local max = count[#count] * 1.1 + 10
        local min = count[1]
        if max == min then
            min = 0
        end
        local yLabel = {}
        local xLabel = dateArray
        point = {}
        for i = 1, #count do
            local x
            local y
            x = (i - 1.3) / 7.5
            
            if max > min then
                y = (count[i] - min) / (max - min) * 1.0
            elseif max > 0 then
                y = 1.0
            else 
                y = 0              
            end
            point[i] = cc.p(x,y)
            
        end
        for i = 1,#xLabel do
            local x_i = cc.Label:createWithSystemFont(xLabel[i],'',24)
            x_i:setScaleX(1/ scale)
            x_i:setColor(cc.c4b(238,75,74,255 ))
            x_i:setPosition((i - 0.3) / 7.5 * tableWidth , - 0.2 * tableHeight)
            gezi:addChild(x_i)
            local line = cc.LayerColor:create(cc.c4b(150,150,150,255),1, 1.0 * tableHeight)
            line:setAnchorPoint(0.5,0)
            line:setPosition((i - 0.3) / 7.5 * tableWidth , - 0.1 * tableHeight)
            gezi:addChild(line)

        end
        local y = {}
        for i = 1, 7 do
            yLabel[i] = min + (max - min) * (i - 1) / (7 - 1)
            y[i] = cc.Label:createWithSystemFont(math.ceil(yLabel[i]),'',24)
            y[i]:setScaleX(1/ scale)
            y[i]:setColor(cc.c4b(238,75,74,255))
            y[i]:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
            y[i]:setPosition(0.4 * yBar:getContentSize().width , (0.0 + 1.0 * (i - 1) / 6) * tableHeight)
            yBar:addChild(y[i])
        end
        if max == 0 then
            for i = 1, 7 do
                y[i]:setString(string.format('%d',10 * (i - 1)))
            end
        end
        local length = {}
        local time = 0
        local curLine = 1
        local curLength = 0
        local drawSpeed = 500
        if #count > 1 then
            for i = 1,#count - 1 do
                length[i] = math.sqrt( math.pow((point[i + 1].x - point[i].x) * tableWidth,2) + math.pow((point[i + 1].y - point[i].y) * tableHeight,2))
                local angle = math.acos((point[i + 1].x - point[i].x) * tableWidth / length[i])
                local line = ccui.Scale9Sprite:create('image/PersonalInfo/PLVI/spot_message_red.png',cc.rect(0,0,17,15),cc.rect(7.5,0,2,15))
                line:setScale9Enabled(true)
                --line:setContentSize(cc.size(15 + length[i] , 15))
                line:setContentSize(cc.size(0,0))
                line:ignoreAnchorPointForPosition(false)
                line:setAnchorPoint(7.5 / (15 + length[i]),0.5)
                line:setPosition(point[i].x * tableWidth ,point[i].y * tableHeight+ (yBar:getPositionY() - (yBar:getContentSize().height - gezi:getContentSize().height * 0.5 ) - gezi:getPositionY()))
                line:setRotation(-angle * 180 / math.pi)
                gezi:addChild(line)
                line:setName(string.format('line%d',i))
            end
        end
        selectPoint = cc.Sprite:create('image/PersonalInfo/PLVI/spot2_message_red_white.png')
        selectPoint:setScaleX(1 / scale)
        selectPoint:ignoreAnchorPointForPosition(false)
        selectPoint:setAnchorPoint(0.5,0.5)
        selectPoint:setPosition(point[#count].x * tableWidth ,point[#count].y * tableHeight + (yBar:getPositionY() - (yBar:getContentSize().height - gezi:getContentSize().height * 0.5 ) - gezi:getPositionY()))
        s_logd(string.format('selectPoint = %d, %d',selectPoint:getPositionX(),#count))
        gezi:addChild(selectPoint)
        selectPoint:setVisible(false)
        --selectPoint:setScale(0.8)
        
        local function update( delta )
            if curLine > #length then
                selectPoint:setVisible(true)
            else
                curLength = curLength + delta * drawSpeed
                if curLength <= length[curLine] then
                    local line = gezi:getChildByName(string.format('line%d',curLine))
                    line:setContentSize(cc.size(15 + curLength , 15))
                    line:setAnchorPoint(7.5 / (15 + curLength),0.5)
                else
                    local line = gezi:getChildByName(string.format('line%d',curLine))
                    line:setContentSize(cc.size(15 + length[curLine] , 15))
                    line:setAnchorPoint(7.5 / (15 + length[curLine]),0.5)
                    curLength = curLength - length[curLine]
                    curLine = curLine + 1
                    if curLine > #length then
                        selectPoint:setVisible(true)
                        return
                    else
                        local line = gezi:getChildByName(string.format('line%d',curLine))
                        line:setContentSize(cc.size(15 + curLength , 15))
                        line:setAnchorPoint(7.5 / (15 + curLength),0.5)
                    end
                end
            end
        end
        back:scheduleUpdateWithPriorityLua(update,0)
        
        local board = cc.Sprite:create('image/PersonalInfo/PLVI/back_message_red.png')
        board:ignoreAnchorPointForPosition(false)
        board:setAnchorPoint(0.5,0)
        board:setPosition(0.5 * selectPoint:getContentSize().width,selectPoint:getContentSize().height)
        selectPoint:addChild(board)
        
        countLabel = cc.Label:createWithSystemFont(string.format('%d',count[#count] - count[#count - 1]),'',55)
        countLabel:enableOutline(cc.c4b(255,255,255,255),1)
        countLabel:setAnchorPoint(0.5,0)
        countLabel:setPosition(0.55 * board:getContentSize().width,0.4 * board:getContentSize().height + 10)
        board:addChild(countLabel,0,'count')

        local label = cc.Label:createWithSystemFont('+','',24)
        label:enableOutline(cc.c4b(255,255,255,255),1)
        --label:setColor(cc.c3b(0,0,0))
        label:setAnchorPoint(0.5,0)
        label:setPosition(countLabel:getPositionX() - countLabel:getContentSize().width / 2 - 10,countLabel:getPositionY() + 10)
        board:addChild(label)

        local totalLabel = cc.Label:createWithSystemFont(string.format('共学%d',count[#count]),'',24)
        totalLabel:setAnchorPoint(0.5,0.5)
        --totalLabel:setColor(cc.c3b(0,0,0))
        totalLabel:setOpacity(150)
        totalLabel:setPosition(0.5 * board:getContentSize().width - 5,0.35 * board:getContentSize().height + 5)
        board:addChild(totalLabel,0,'count')
    end
    
    local xArray = {}
    local yArray = {}
    local labelCount = 4
    if dayCount < 4 then
        labelCount = dayCount
    end
    for i = 1, labelCount + 1 do
        yArray[i] = countArray[dayCount - labelCount + i]
        xArray[i] = dateArray[dayCount - labelCount + i]
    end
    drawXYLabel(countArray)
    
end

function PersonalInfo:login()
    local back = self.intro_array[2]
    local loginData = s_CURRENT_USER.logInDatas
    --local loginData_array = {{0,1,1,0,1,1,1},{2,2,1,0,1,0,0}}
    local loginData_array = {}
    --print('loginData_array = '..#loginData)
    for i = 1,#loginData do
        loginData_array[i] = loginData[i]:getDays()
        print_lua_table(loginData_array[i])
    end
    local calendar = {}
    local weekDay = {'SUN','MON','TUE','WED','THU','FRI','SAT'}
    local year_begin = tonumber(os.date('%Y',s_CURRENT_USER.localTime),10)
    local month_begin = tonumber(os.date('%m',s_CURRENT_USER.localTime),10) 
    local year_today = tonumber(os.date('%Y',os.time()),10)
    local month_today = tonumber(os.date('%m',os.time()),10)
    local monthCount = (year_today - year_begin) * 12 + (month_today - month_begin) + 1
    local showMonth = monthCount
    local nowDate = os.time()
    local nowWeekDay = tonumber(os.date('%w',nowDate),10)
    if nowWeekDay == 0 then
        nowWeekDay = 7
    end
    nowDate = nowDate + 8 * 3600
    nowDate = nowDate - nowDate % (24 * 3600)
    local firstDate = nowDate - (7 * (#loginData_array - 1) + nowWeekDay - 1) * 24 * 3600
    local title = cc.Label:createWithSystemFont(string.format('%d，%d',year_today,month_today),'',36)
    title:setColor(cc.c4b(251,166,24,255))
    title:setPosition(0.5 * (s_RIGHT_X - s_LEFT_X), 0.8 * back:getContentSize().height)
    back:addChild(title)

    local nextDate
    local formerDate
    local loadingList = {}
    local lengthList = {}
    local checkInList = {}

    local drawCalendar = function(selectDate,index)
        calendar[index] = nil
        calendar[index] = cc.Node:create()
        calendar[index]:setPosition((index - 2) * (s_RIGHT_X - s_LEFT_X),0)
        back:addChild(calendar[index],1)

        formerDate = selectDate - 24 * 3600
        formerDate = formerDate - (tonumber(os.date('%d',formerDate),10) - 1) * 24 * 3600

        for j = 1, #weekDay do
            local label = cc.Label:createWithSystemFont(weekDay[j],'',28)
            label:setColor(cc.c4b(251,166,24,255))
            label:setPosition(j / 8 * s_DESIGN_WIDTH - s_LEFT_X, 0.7 * back:getContentSize().height)
            calendar[index]:addChild(label)
        end

        local offset = tonumber(os.date('%w',selectDate),10)
        local delayTime = 0
        if #loadingList > 0 then
            for j = 1,#loadingList do
                loadingList[j]:removeFromParent()
            end
        end
        if #checkInList > 0 then
            for j = 1,#checkInList do
                checkInList[j]:removeFromParent()
            end
        end
        loadingList = {}
        lengthList = {}
        checkInList = {}
        while true do
            local date = tonumber(os.date('%d',selectDate),10)
            local week = tonumber(os.date('%w',selectDate),10)
            local label = cc.Label:createWithSystemFont(string.format('%d',date),'',28)
            label:setColor(cc.c4b(150,150,150,255))
            label:setPosition((week + 1) / 8 * s_DESIGN_WIDTH - s_LEFT_X, (0.68 - 0.08 * math.ceil((date + offset) / 7)) * back:getContentSize().height)
            calendar[index]:addChild(label,2)

            --login circle
            local sDate = (selectDate - selectDate % (24 * 3600))
            

            local weekIndex = math.floor((sDate - firstDate) / (7 * 24 * 3600)) + 1
            local dayIndex = ((sDate - firstDate) % (7 * 24 * 3600)) / (24 * 3600) + 1
            
            if weekIndex > 0 and weekIndex <= #loginData_array and dayIndex > 0 and dayIndex <= 7 then
                
                if loginData_array[weekIndex][dayIndex] >= 1 and sDate <= nowDate then
                    --label:setColor(cc.c3b(255,255,255))
                    --print('selectDate',os.date('%x',selectDate))
                    if s_CURRENT_USER.logInDatas[weekIndex]:isCheckIn(selectDate,s_CURRENT_USER.bookKey) then
                        --print('selectDate is checkIn',os.date('%x',selectDate))
                        table.insert(checkInList,label)
                    end
                    if dayIndex < 7 then
                        if loginData_array[weekIndex][dayIndex + 1] == 0 or dayIndex == 6 or tonumber(os.date('%d',selectDate + 24 * 3600),10) == 1  then
                            local length = 1
                            for i = 1,dayIndex do
                                if i < dayIndex then
                                    if loginData_array[weekIndex][dayIndex - i] == 0 then
                                        break
                                    end
                                elseif i == dayIndex and weekIndex > 1 then
                                    if loginData_array[weekIndex - 1][7] == 0 then
                                        break
                                    end
                                else
                                    break
                                end
                                if os.date('%m',selectDate) ~= os.date('%m',selectDate - length * 24 * 3600) then
                                    break
                                end
                                length = length + 1
                            end
                            if length == 1 then
                                local circle = cc.Sprite:create('image/PersonalInfo/login/circle_login_days.png')
                                circle:setPosition(cc.p(label:getPosition()))
                                calendar[index]:addChild(circle)
                                circle:setOpacity(0)
                                table.insert(loadingList,circle)
                                table.insert(lengthList,length)
                            else

                                local loadingBar = ccui.LoadingBar:create()
                                loadingBar:setAnchorPoint(1 - 27.5 / (55 + s_DESIGN_WIDTH / 8 * (length - 1)),0.5)
                                loadingBar:setTag(0)
                                loadingBar:setName("LoadingBar")
                                loadingBar:setVisible(false)
                                loadingBar:loadTexture("image/PersonalInfo/login/continious_login.png")
                                loadingBar:setScale9Enabled(true)
                                loadingBar:setCapInsets(cc.rect(0,0,0,0))
                                loadingBar:setContentSize(cc.size(55 + s_DESIGN_WIDTH / 8 * (length - 1),55))
                                loadingBar:setDirection(ccui.LoadingBarDirection.LEFT)
                                local percent = 55 / (55 + s_DESIGN_WIDTH / 8 * (length - 1)) * 100

                                loadingBar:setPercent(percent)
                                loadingBar:setPosition(cc.p(label:getPosition()))
                                back:addChild(loadingBar)
                                table.insert(loadingList,loadingBar)
                                table.insert(lengthList,length)

                            end
                        end
                    elseif dayIndex == 7 and weekIndex < #loginData_array and loginData_array[weekIndex + 1][1] == 0 then
                        local circle = cc.Sprite:create('image/PersonalInfo/login/circle_login_days.png')
                        circle:setPosition(cc.p(label:getPosition()))
                        calendar[index]:addChild(circle)
                        circle:setOpacity(0)
                        table.insert(loadingList,circle)
                        table.insert(lengthList,1)
                    end
                end
            end
            
            if nowDate == sDate then
                local circle = cc.Sprite:create('image/PersonalInfo/login/circle_today.png')
                circle:setPosition(cc.p(label:getPosition()))
                calendar[index]:addChild(circle,1)
                circle:setScale(0)
                table.insert(loadingList,circle)
                table.insert(lengthList,0)
            end

            selectDate = selectDate + 24 * 3600
            if tonumber(os.date('%d',selectDate),10) == 1 then
                nextDate = selectDate
                break
            end
        end

        local curIndex = 1
            local function update(delta)
                if curIndex > #loadingList then
                    local tickCount = #checkInList
                    if self.checkIn ~= nil and self.checkIn then
                        tickCount = tickCount - 1
                    end
                    
                    if tickCount > 0 then
                        for i = 1,tickCount do
                            --local pos = checkInList[i]:getPosition()
                            local tick = cc.Sprite:create('image/PersonalInfo/login/learning_process_finish_task_tick_on_canlender.png')
                            tick:setPosition(checkInList[i]:getPositionX(),checkInList[i]:getPositionY())
                            calendar[index]:addChild(tick,2)
                            checkInList[i]:setVisible(false)
                            if i == tickCount and self.checkIn ~= nil and self.checkIn then
                                -- s_SCENE:callFuncWithDelay(1.0,function ()
                                --     self.homelayer:hideDataLayer()
                                -- end)
                            end
                        end
                    else
                        -- if self.checkIn ~= nil and self.checkIn then
                        --     s_SCENE:callFuncWithDelay(1.0,function ()
                        --         self.homelayer:hideDataLayer()
                        --     end)
                        -- end
                    end
                    calendar[index]:unscheduleUpdate()
                    return
                end
                if lengthList[curIndex] == 1 then
                    loadingList[curIndex]:setOpacity(255)
                    curIndex = curIndex + 1
                elseif lengthList[curIndex] > 1 then
                    local length = lengthList[curIndex]
                    loadingList[curIndex]:setVisible(true)
                    local percent = loadingList[curIndex]:getPercent() + s_DESIGN_WIDTH * 0.125 / (55 + s_DESIGN_WIDTH / 8 * (length - 1)) * 100 / 6
                    loadingList[curIndex]:setPercent(percent)
                    if percent >= 100 then
                        curIndex = curIndex + 1
                    end
                else
                    local fadeIn = cc.EaseBackOut:create(cc.ScaleTo:create(0.4,1))
                    loadingList[curIndex]:runAction(fadeIn)
                    --print('curIndex'..curIndex)
                    
                    if self.checkIn ~= nil and self.checkIn then
                        local tick = nil
                        if s_HUD_LAYER:getChildByName('missionComplete') ~= nil then
                           tick = s_HUD_LAYER:getChildByName('missionComplete'):getChildByName('back')
                        end
                        local move = cc.MoveTo:create(0.5,cc.p(loadingList[curIndex]:getPositionX() + s_LEFT_X,loadingList[curIndex]:getPositionY()))
                        local delay = cc.DelayTime:create(0.5)
                        local tickChange = cc.CallFunc:create(function ()
                            local newtick = cc.Sprite:create('image/PersonalInfo/login/learning_process_finish_task_tick_on_canlender.png')
                            newtick:setPosition(loadingList[#loadingList]:getContentSize().width / 2,loadingList[#loadingList]:getContentSize().height / 2)
                            loadingList[#loadingList]:addChild(newtick,2)
                            if #checkInList > 0 then 
                                checkInList[#checkInList]:setVisible(false) 
                            else
                                saveLuaErrorToServer('PersonalInfo.lua; #checkInList <= 0; checkInList[#checkInList]:setVisible(false);')
                            end
                            if tick ~= nil then
                                tick:removeFromParent()
                            end
                            newtick:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function ()
                                s_SCENE:checkInOver(self.homelayer)
                            end,{})))
                        end,{})
                        if tick ~= nil then
                            tick:runAction(cc.Sequence:create(delay,move,tickChange))
                        else
                            back:runAction(cc.Sequence:create(delay,tickChange))
                        end
                    end
                    curIndex = curIndex + 1
                end
            end

            calendar[index]:scheduleUpdateWithPriorityLua(update, 0)
        
    end

    
    local selectDate = os.time() - (tonumber(os.date('%d',os.time()),10) - 1) * 24 * 3600
    drawCalendar(selectDate,2)

    local backButton = ccui.Button:create('image/PersonalInfo/login/back_button.png','','')
    backButton:setScale9Enabled(true)
    backButton:setScale(3)
    backButton:setPosition(1 / 8 * s_DESIGN_WIDTH - s_LEFT_X, 0.8 * back:getContentSize().height)
    back:addChild(backButton)
    if monthCount == 1 then
        backButton:setVisible(false)
    end

    local frontButton = ccui.Button:create('image/PersonalInfo/login/front_button.png','','')
    frontButton:setScale9Enabled(true)
    frontButton:setScale(3)
    frontButton:setPosition(7 / 8 * s_DESIGN_WIDTH - s_LEFT_X, 0.8 * back:getContentSize().height)
    back:addChild(frontButton)
    frontButton:setVisible(false)

    local function onFront(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            showMonth = showMonth + 1
            if not backButton:isVisible() then
                backButton:setVisible(true)
            end
            if showMonth == monthCount then
                sender:setVisible(false)
            elseif not sender:isVisible() then
                sender:setVisible(true)
            end

            title:setString(string.format('%d，%d',tonumber(os.date('%Y',nextDate),10),tonumber(os.date('%m',nextDate),10)))
            drawCalendar(nextDate,3)
            calendar[1] = calendar[2]
            calendar[2] = calendar[3]
            local move = cc.MoveBy:create(0.2,cc.p(-(s_RIGHT_X - s_LEFT_X),0))
            local remove = cc.CallFunc:create(function()
                calendar[1]:removeFromParent()
            end,{})
            calendar[1]:runAction(cc.Sequence:create(move,remove))
            calendar[2]:runAction(cc.MoveBy:create(0.2,cc.p(-(s_RIGHT_X - s_LEFT_X),0)))
        end
    end

    local function onBack(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            showMonth = showMonth - 1
            if not frontButton:isVisible() then
                frontButton:setVisible(true)
            end
            if showMonth == 1 then
                sender:setVisible(false)
            elseif not sender:isVisible() then
                sender:setVisible(true)
            end
            title:setString(string.format('%d，%d',tonumber(os.date('%Y',formerDate),10),tonumber(os.date('%m',formerDate),10)))
            drawCalendar(formerDate,1)
            calendar[3] = calendar[2]
            calendar[2] = calendar[1]
            local move = cc.MoveBy:create(0.2,cc.p((s_RIGHT_X - s_LEFT_X),0))
            local remove = cc.CallFunc:create(function()
                calendar[3]:removeFromParent()
            end,{})
            calendar[3]:runAction(cc.Sequence:create(move,remove))
            calendar[2]:runAction(cc.MoveBy:create(0.2,cc.p((s_RIGHT_X - s_LEFT_X),0)))
        end
    end

    frontButton:addTouchEventListener(onFront)
    backButton:addTouchEventListener(onBack)

end   

function PersonalInfo:XXTJ()

    local totalDay = s_LocalDatabaseManager.getStudyDayNum()
    if totalDay < 1 then
        totalDay = 1
    end
    local everydayWord = math.floor(s_LocalDatabaseManager.getTotalStudyWordsNum() / totalDay)
    local totalWord = s_DataManager.books[s_CURRENT_USER.bookKey].words
    local wordFinished = s_LocalDatabaseManager.getTotalStudyWordsNum()
    local dayToFinish = 100
    if everydayWord > 0 then
        dayToFinish = math.ceil((totalWord - s_LocalDatabaseManager.getTotalStudyWordsNum()) / everydayWord)
    end
    local back = self.intro_array[1]
    local list = {}

    local drawLabel = function(label,count,unit,y,index)
   
        local speedLabel = cc.Label:createWithSystemFont(string.format('%s ',label),'',36)
        speedLabel:setAnchorPoint(0,0)
        speedLabel:setColor(cc.c4b(128,172,20,255))
        back:addChild(speedLabel)

        local speed = cc.Label:createWithSystemFont(string.format('%d',count),'',80)
        speed:setAnchorPoint(0,0.1)
        speed:setColor(cc.c4b(128,172,20,255))
        speed:setVisible(false)
        back:addChild(speed)
        table.insert(list,1,speed)

        local unit1 = cc.Label:createWithSystemFont(string.format(' %s',unit),'',36)
        unit1:setAnchorPoint(1,0)
        unit1:setColor(cc.c4b(128,172,20,255))
        back:addChild(unit1)

        local length = speed:getContentSize().width + speedLabel:getContentSize().width + unit1:getContentSize().width
        speedLabel:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X - length / 2,y)
        speed:setPosition(speedLabel:getPositionX() + speedLabel:getContentSize().width,y)
        unit1:setPosition(speedLabel:getPositionX() + length,y)
    end

    drawLabel('日均学习',everydayWord,'个',0.3 * back:getContentSize().height,1)
    local dayLabel = '还需学习'
    if dayToFinish > 99 then
        dayToFinish = 99
        dayLabel = '还需学习大于'
    end
    drawLabel(dayLabel,dayToFinish,'天',0.5 * back:getContentSize().height,1)

    if dayToFinish > 99 then
        dayToFinish = 99
    end
    local finishTime = os.time() + dayToFinish * 24 * 3600

        local speedLabel = cc.Label:createWithSystemFont(string.format('完成日期预测%s年 ',os.date('%y',finishTime)),'',36)
        speedLabel:setAnchorPoint(0,0)
        speedLabel:setColor(cc.c4b(128,172,20,255))
        back:addChild(speedLabel)

        local month = cc.Label:createWithSystemFont(string.format('%s',tonumber(os.date('%m',finishTime),10)),'',76)
        month:setAnchorPoint(0,0.1)
        month:setColor(cc.c4b(128,172,20,255))
        month:setVisible(false)
        back:addChild(month)

        local unit1 = cc.Label:createWithSystemFont(' 月 ','',36)
        unit1:setAnchorPoint(0,0)
        unit1:setColor(cc.c4b(128,172,20,255))
        back:addChild(unit1)

        local day = cc.Label:createWithSystemFont(string.format('%s',tonumber(os.date('%d',finishTime),10)),'',76)
        day:setAnchorPoint(0,0.1)
        day:setColor(cc.c4b(128,172,20,255))
        day:setVisible(false)
        back:addChild(day)

        local unit2 = cc.Label:createWithSystemFont(' 日','',36)
        unit2:setAnchorPoint(1,0)
        unit2:setColor(cc.c4b(128,172,20,255))
        back:addChild(unit2)

        local length = month:getContentSize().width + day:getContentSize().width + speedLabel:getContentSize().width + unit1:getContentSize().width + unit2:getContentSize().width
        speedLabel:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X - length / 2,0.7 * back:getContentSize().height)
        month:setPosition(speedLabel:getPositionX() + speedLabel:getContentSize().width,0.7 * back:getContentSize().height)
        unit1:setPosition(month:getPositionX() + month:getContentSize().width,0.7 * back:getContentSize().height)
        day:setPosition(unit1:getPositionX() + unit1:getContentSize().width,0.7 * back:getContentSize().height)
        unit2:setPosition(speedLabel:getPositionX() + length,0.7 * back:getContentSize().height)  
        --speedLabel:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)  

        table.insert(list,1,day)
        table.insert(list,1,month)
        for i = 1, #list do
            list[i]:setString('')
            list[i]:setVisible(true)
        end
    local numList = {}
    numList[1] = tonumber(os.date('%m',finishTime),10)
    numList[2] = tonumber(os.date('%d',finishTime),10)
    numList[3] = dayToFinish
    numList[4] = everydayWord
    local updateIndex = 1
    local curNum = 0
    local function update(delta)
        if updateIndex > 4 then
            return
        end
        local offset = numList[updateIndex] / 10
        if 1 > offset then
            offset = 1
        end
        curNum = math.ceil(offset + curNum)
        if curNum > numList[updateIndex] then
            curNum = numList[updateIndex]
        end
        list[updateIndex]:setString(string.format('%d',curNum))
        if curNum >= numList[updateIndex] then
            updateIndex = updateIndex + 1
            curNum = 0
        end

    end
    back:scheduleUpdateWithPriorityLua(update, 0)
	
end

return PersonalInfo