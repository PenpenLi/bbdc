-- require("cocos.init")
-- require("common.global")

-- local BigAlter = require("view.alter.BigAlter")

-- local BookLayer = class("BookLayer", function ()
--     return cc.Layer:create()
-- end)


-- function BookLayer.create()
--     local layer = BookLayer.new()
--     layer.book = {}

--     local backColor = cc.LayerColor:create(cc.c4b(190,220,209,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
--     backColor:setAnchorPoint(0.5,0.5)
--     backColor:ignoreAnchorPointForPosition(false)  
--     backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
--     layer:addChild(backColor)    
    
--     local click_back = function(sender, eventType)
--         if eventType == ccui.TouchEventType.ended then
--             s_CorePlayManager.enterHomeLayer()
--             playSound(s_sound_buttonEffect)
--         end
--     end
    
--     local backButton = ccui.Button:create("image/book/choose_book_back.png","","")
--     backButton:setScale9Enabled(true)
--     backButton:setTouchEnabled(true)
--     backButton:ignoreAnchorPointForPosition(false)
--     backButton:setAnchorPoint(0.5 , 0.5)
--     backButton:setPosition((s_RIGHT_X - s_LEFT_X) / 2 - 238, 1073)
--     backButton:addTouchEventListener(click_back)
--     backColor:addChild(backButton)
    
--     --whether bookKey == nil
    
--     if s_CURRENT_USER.bookKey == '' then 
--        backButton:setVisible(false)
--     else
--        backButton:setVisible(true)
--     end
    
--     local hint = cc.Label:createWithSystemFont("请您先选择一本合适您的书籍","",24)
--     hint:setPosition((s_RIGHT_X - s_LEFT_X)/2,1073)
--     hint:setColor(cc.c4b(66,66,62,255))
--     backColor:addChild(hint) 
--     local name_array = {}
--     local full_name_array = {}
--     local key_array = {'cet4','cet6','ncee','toefl','ielts','gre','gse','pro4','pro8','gmat','sat','middle','primary'}
--     --local key_array = g_BOOKKEYS
--     for i = 1, #key_array do
--         name_array[i] = string.upper(key_array[i])
--         full_name_array[i] = string.upper(key_array[1])
--         if i <= 5 then
--             full_name_array[i] = string.upper(key_array[i])
--         end
--     end
--     local func_array = {}
--     local bookCount = #key_array
--     for i = 1, bookCount do
--         local index = 1
--         if i <= 5 then
--             index = i
--         end
--         local key = key_array[i]
--         local click = function(sender, eventType)
--             if eventType == ccui.TouchEventType.ended then
--                 AnalyticsTutorialBookSelect()
                
--                 if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
--                     AnalyticsFirstBook(key)
--                 end
                
--                 s_CURRENT_USER.bookKey = key
--                 saveUserToServer({['bookKey']=s_CURRENT_USER.bookKey})
--                 AnalyticsBook(key)
--                 AnalyticsFirst(ANALYTICS_FIRST_BOOK, key)
                
--                 s_CorePlayManager.enterHomeLayer()
--                 s_O2OController.getBulletinBoard()
            
--                 playSound(s_sound_buttonEffect)   

--                 if IS_DEVELOPMENT_MODE then s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD end
--             end
--         end
--         table.insert(func_array, click)
    
--         local smallBack = ccui.Button:create("image/book/"..name_array[i]..".png", "", "")
--         smallBack:setTouchEnabled(true)
--         smallBack:setScale9Enabled(true)

--         smallBack:addTouchEventListener(func_array[i])
--         smallBack:setAnchorPoint(0.5,0)

--         if key == s_CURRENT_USER.bookKey then
--             local shine = cc.Sprite:create('image/book/choose_book_using_now.png')
--             shine:setPosition(smallBack:getContentSize().width / 2 - 7,smallBack:getContentSize().height / 2)
--             smallBack:addChild(shine)
--             local girl = cc.Sprite:create('image/book/choose_book_using_now_beibei.png')
--             smallBack:addChild(girl,-1)
--             if i == 1 or i % 2 == 0 then
--                 girl:setPosition(-30,smallBack:getContentSize().height / 2 + 15)
--             else
--                 girl:setRotationSkewY(180)
--                 girl:setPosition(smallBack:getContentSize().width + 10,smallBack:getContentSize().height / 2 + 15)
--             end
--         end
--         if s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(key) > 0 then
--             local progressBack = cc.Sprite:create('image/book/book_progress2.png')
--             progressBack:setPosition(smallBack:getContentSize().width / 2 - 7,smallBack:getContentSize().height + 25)
--             smallBack:addChild(progressBack)
--             local percent = s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(key) / s_DataManager.books[key].words
--             --percent = 0.6
--             local progress = ccui.Scale9Sprite:create('image/book/book_progress1.png',cc.rect(0,0,127,15),cc.rect(7.5, 0, 112, 15))
--             progress:setContentSize(cc.size(15 + 178 * percent,15))
--             progress:ignoreAnchorPointForPosition(false)
--             progress:setAnchorPoint(0,0.5)
--             progress:setPosition(0,progressBack:getContentSize().height / 2)
--             progressBack:addChild(progress)
--             local per = '%'
--             local label = cc.Label:createWithSystemFont(string.format('%d%s',percent * 100,per),'',16)
--             label:ignoreAnchorPointForPosition(false)
--             label:setPosition(progress:getContentSize().width,progress:getContentSize().height / 2)
--             progress:addChild(label)
--             if percent < 0.5 then
--                 if percent < 0.01 then
--                     label:setString(string.format('%.1f%s',percent * 100,per))
--                 end
--                 label:setAnchorPoint(-0.3,0.5)
--                 label:setColor(cc.c3b(107,178,255))
--             else
--                 label:setAnchorPoint(1.3,0.5)
--             end
--         end

--         local richtext = ccui.RichText:create()
    
--         richtext:ignoreContentAdaptWithSize(false)
--         richtext:ignoreAnchorPointForPosition(false)
--         richtext:setAnchorPoint(cc.p(0.5,0.5))
        
--         richtext:setContentSize(cc.size(smallBack:getContentSize().width *0.95, 
--             smallBack:getContentSize().height *0.2))  

        
--         local richElement1 = ccui.RichElementText:create(1,cc.c3b(0, 0, 0),150,'单词量: ','',22)                           
--         richtext:pushBackElement(richElement1)       

        
--         local richElement2 = ccui.RichElementText:create(2,cc.c3b(255,255,255),255,string.format('%d',s_DataManager.books[key].words),'',22)                           
--         richtext:pushBackElement(richElement2)               
--         richtext:setPosition(smallBack:getContentSize().width *0.63, 
--             smallBack:getContentSize().height *0.2)
--         smallBack:addChild(richtext) 


--         if i == 1 then
--             if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
--                 local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
--                 tutorial_text:setPosition((s_RIGHT_X - s_LEFT_X)/2, 1073)
--                 backColor:addChild(tutorial_text,120)
--                 --tutorial_text:setColor(cc.c3b(255,255,255))
                
--                 local text = cc.Label:createWithSystemFont(s_DataManager.getTextWithIndex(TEXT__TUTORIAL_BOOK_SELECT),'',28)
--                 text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
--                 text:setColor(cc.c3b(0,0,0))
--                 tutorial_text:addChild(text)
                
--                 -- s_CURRENT_USER:setTutorialStep(s_tutorial_book_select+1)
--                 -- s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_book_select+1)
--             end
--         end
--         layer.book[i] = smallBack
        
--     end

--     local listView = ccui.ListView:create()
--     -- set list view ex direction
--     listView:setDirection(ccui.ScrollViewDir.vertical)
--     listView:setBounceEnabled(false)
--     listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.7 * s_DESIGN_HEIGHT))
--     listView:setPosition(s_LEFT_X,0.15 * s_DESIGN_HEIGHT)
--     layer:addChild(listView)
--     local count = math.ceil(bookCount / 2) + 1
--     for i = 1, count do 
--         local shelf = cc.Sprite:create('image/book/bookshelf_choose_book_button.png')
--         shelf:ignoreAnchorPointForPosition(false)
--         shelf:setAnchorPoint(0.5,0.5)

--         local custom_item = ccui.Layout:create()
--         custom_item:setTouchEnabled(true)
--         custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.26 * s_DESIGN_HEIGHT))
--         shelf:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height * 0.2))
--         custom_item:addChild(shelf,0,'shelf')

--         listView:insertCustomItem(custom_item,i - 1)
--         if i == 1 and bookCount%2 == 1 then
--             layer.book[i]:setPosition(0.5 * custom_item:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
--             custom_item:addChild(layer.book[i])
--             local flower = cc.Sprite:create('image/book/flower_choose_book.png')
--             flower:setAnchorPoint(0.5,0)
--             flower:setPosition(0.75 * shelf:getContentSize().width,0.75 * shelf:getContentSize().height)
--             shelf:addChild(flower)
--         elseif i < count then
--             layer.book[2 * (i - 1) + bookCount%2 - 1]:setPosition(custom_item:getContentSize().width / 2.0 - 0.2 * shelf:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
--             layer.book[2 * (i - 1) + bookCount%2]:setPosition(custom_item:getContentSize().width / 2.0 + 0.2 * shelf:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
--             custom_item:addChild(layer.book[2 * (i - 1) + bookCount%2 - 1])
--             custom_item:addChild(layer.book[2 * (i - 1) + bookCount%2])
--         end

--     end

--     local backBar = cc.Sprite:create('image/book/process_button_light_color.png')
--     backBar:setPosition(0.97 * backColor:getContentSize().width,0.5 * backColor:getContentSize().height)
--     backColor:addChild(backBar)  

--     local progressBar = ccui.Scale9Sprite:create('image/book/process_button_dark_color.png',cc.rect(0,0,15,856),cc.rect(0, 10, 15, 836))
--     --backBar:setContentSize(cc.size(15,1000))
--     local percent = 0.85 / (count * 0.26)
--     if percent > 1 then
--         percent = 1
--     end
--     progressBar:setContentSize(cc.size(15,20 + 836 * percent))
--     progressBar:ignoreAnchorPointForPosition(false)
--     progressBar:setAnchorPoint(0.5,1)
--     progressBar:setPosition(0.5 * backBar:getContentSize().width,backBar:getContentSize().height)
--     backBar:addChild(progressBar)    
--     backBar:setVisible(false)

--     local isScrolling = false
--     local isTouched = false
--     local time = 0
--     local overtime = 0
--     local scrollY = listView:getInnerContainer():getPositionY()
    
--     local onTouchBegan = function(touch, event) 
--         isTouched = true
--         return true  
--     end

--     local onTouchEnded = function(touch, event) 
--         isTouched = false
--         return true
--     end

--     local listener = cc.EventListenerTouchOneByOne:create()
--     listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
--     listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
--     local eventDispatcher = listView:getItem(count - 1):getChildByName('shelf'):getEventDispatcher()
--     eventDispatcher:addEventListenerWithSceneGraphPriority(listener, listView:getItem(count - 1):getChildByName('shelf'))

--     -- onAndroidKeyPressed(layer, function ()
--     --         s_CorePlayManager.enterHomeLayer()
        
--     -- end, function ()

--     -- end)

--     local function update(delta)
--         local h = listView:getInnerContainer():getPositionY()
--         if h == scrollY and not isTouched or time < 0.5 then
--             if overtime > 0.2 or time < 0.5 then
--                 backBar:setVisible(false)
--                 overtime = 0
--             else
--                 overtime = overtime + delta
--             end
--         elseif h ~= scrollY then
--             backBar:setVisible(true)
--             overtime = 0
--         end
--         scrollY = h
--         time = time + delta
--         local y = - h / (count * 0.26 * s_DESIGN_HEIGHT) - (count * 0.26 - 0.85) / (count * 0.26)
--         if h > 0 then
--             local p = percent * (s_DESIGN_HEIGHT - h) / s_DESIGN_HEIGHT
--             progressBar:setContentSize(cc.size(15,20 + 836 * p))
--             progressBar:setAnchorPoint(0.5,0)
--             progressBar:setPositionY(0)
--         elseif y < 0 then
--             progressBar:setContentSize(cc.size(15,20 + 836 * percent))
--             progressBar:setAnchorPoint(0.5,1)
--             progressBar:setPositionY((1 + y) * backBar:getContentSize().height)
--         else
--             local p = percent * (1 - y)
--             progressBar:setContentSize(cc.size(15,20 + 836 * p))
--             progressBar:setAnchorPoint(0.5,1)
--             progressBar:setPositionY(backBar:getContentSize().height)
--         end
        
--     end

--     layer:scheduleUpdateWithPriorityLua(update, 0)
--     return layer
-- end

-- return BookLayer
require("cocos.init")
require("common.global")

local BigAlter = require("view.alter.BigAlter")

local BookLayer = class("BookLayer", function ()
    return cc.Layer:create()
end)


function BookLayer.create()
    -- 更新引导步骤
    s_CURRENT_USER:setNewTutorialStepRecord(s_newTutorialStepRecord_selectBook)
    local layer = BookLayer.new()
    layer.book = {}

    local backColor = cc.LayerColor:create(cc.c4b(190,220,209,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)    
    
    local click_back = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterHomeLayer()
            playSound(s_sound_buttonEffect)
        end
    end
    
    local backButton = ccui.Button:create("image/book/choose_book_back.png","","")
    backButton:setScale9Enabled(true)
    backButton:setTouchEnabled(true)
    backButton:ignoreAnchorPointForPosition(false)
    backButton:setAnchorPoint(0.5 , 0.5)
    backButton:setPosition((s_RIGHT_X - s_LEFT_X) / 2 - 238, 1073)
    backButton:addTouchEventListener(click_back)
    backColor:addChild(backButton)
    
    --whether bookKey == nil
    
    if s_CURRENT_USER.bookKey == '' then 
       backButton:setVisible(false)
    else
       backButton:setVisible(true)
    end
    
    local hint = cc.Label:createWithSystemFont("请您先选择一本合适您的书籍","",24)
    hint:setPosition((s_RIGHT_X - s_LEFT_X)/2,1073)
    hint:setColor(cc.c4b(66,66,62,255))
    backColor:addChild(hint) 
    local name_array = {}
    local full_name_array = {}
    local key_array = {'cet4','cet6'}--,'ncee','toefl','ielts','gre','gse','pro4','pro8','gmat','sat','middle','primary'}
    --local key_array = g_BOOKKEYS
    for i = 1, #key_array do
        name_array[i] = string.upper(key_array[i])
        full_name_array[i] = string.upper(key_array[1])
        if i <= 5 then
            full_name_array[i] = string.upper(key_array[i])
        end
    end
    local func_array = {}
    local bookCount = #key_array
    for i = 1, bookCount do
        local index = 1
        if i <= 5 then
            index = i
        end
        local key = key_array[i]
        local click = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                AnalyticsTutorialBookSelect()
                
                if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
                    AnalyticsFirstBook(key)
                end
                
                s_CURRENT_USER.bookKey = key
                saveUserToServer({['bookKey']=s_CURRENT_USER.bookKey})
                AnalyticsBook(key)
                AnalyticsFirst(ANALYTICS_FIRST_BOOK, key)
                
                s_CorePlayManager.enterHomeLayer()
                -- s_O2OController.getBulletinBoard()
            
                playSound(s_sound_buttonEffect)   

                if IS_DEVELOPMENT_MODE then s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD end
            end
        end
        table.insert(func_array, click)
    
        local smallBack = ccui.Button:create("image/book/"..name_array[i]..".png", "", "")
        smallBack:setTouchEnabled(true)
        smallBack:setScale9Enabled(true)

        smallBack:addTouchEventListener(func_array[i])
        smallBack:setAnchorPoint(0.5,0)

        if key == s_CURRENT_USER.bookKey then
            local shine = cc.Sprite:create('image/book/choose_book_using_now.png')
            shine:setPosition(smallBack:getContentSize().width / 2 - 7,smallBack:getContentSize().height / 2)
            smallBack:addChild(shine)
            local girl = cc.Sprite:create('image/book/choose_book_using_now_beibei.png')
            smallBack:addChild(girl,-1)
            if i == 1 or i % 2 == 0 then
                girl:setPosition(-30,smallBack:getContentSize().height / 2 + 15)
            else
                girl:setRotationSkewY(180)
                girl:setPosition(smallBack:getContentSize().width + 10,smallBack:getContentSize().height / 2 + 15)
            end
        end
        if s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(key) > 0 then
            local progressBack = cc.Sprite:create('image/book/book_progress2.png')
            progressBack:setPosition(smallBack:getContentSize().width / 2 - 7,smallBack:getContentSize().height + 25)
            smallBack:addChild(progressBack)
            local percent = s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(key) / s_DataManager.books[key].words
            --percent = 0.6
            local progress = ccui.Scale9Sprite:create('image/book/book_progress1.png',cc.rect(0,0,127,15),cc.rect(7.5, 0, 112, 15))
            progress:setContentSize(cc.size(15 + 178 * percent,15))
            progress:ignoreAnchorPointForPosition(false)
            progress:setAnchorPoint(0,0.5)
            progress:setPosition(0,progressBack:getContentSize().height / 2)
            progressBack:addChild(progress)
            local per = '%'
            local label = cc.Label:createWithSystemFont(string.format('%d%s',percent * 100,per),'',16)
            label:ignoreAnchorPointForPosition(false)
            label:setPosition(progress:getContentSize().width,progress:getContentSize().height / 2)
            progress:addChild(label)
            if percent < 0.5 then
                if percent < 0.01 then
                    label:setString(string.format('%.1f%s',percent * 100,per))
                end
                label:setAnchorPoint(-0.3,0.5)
                label:setColor(cc.c3b(107,178,255))
            else
                label:setAnchorPoint(1.3,0.5)
            end
        end

        local richtext = ccui.RichText:create()
    
        richtext:ignoreContentAdaptWithSize(false)
        richtext:ignoreAnchorPointForPosition(false)
        richtext:setAnchorPoint(cc.p(0.5,0.5))
        
        richtext:setContentSize(cc.size(smallBack:getContentSize().width *0.95, 
            smallBack:getContentSize().height *0.2))  

        
        local richElement1 = ccui.RichElementText:create(1,cc.c3b(0, 0, 0),150,'单词量: ','',22)                           
        richtext:pushBackElement(richElement1)       

        
        local richElement2 = ccui.RichElementText:create(2,cc.c3b(255,255,255),255,string.format('%d',s_DataManager.books[key].words),'',22)                           
        richtext:pushBackElement(richElement2)               
        richtext:setPosition(smallBack:getContentSize().width *0.63, 
            smallBack:getContentSize().height *0.2)
        smallBack:addChild(richtext) 


        if i == 1 then
            if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
                local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
                tutorial_text:setPosition((s_RIGHT_X - s_LEFT_X)/2, 1073)
                backColor:addChild(tutorial_text,120)
                --tutorial_text:setColor(cc.c3b(255,255,255))
                
                local text = cc.Label:createWithSystemFont(s_DataManager.getTextWithIndex(TEXT__TUTORIAL_BOOK_SELECT),'',28)
                text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
                text:setColor(cc.c3b(0,0,0))
                tutorial_text:addChild(text)
                
                -- s_CURRENT_USER:setTutorialStep(s_tutorial_book_select+1)
                -- s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_book_select+1)
            end
        end
        layer.book[i] = smallBack
        
    end

    local listView = ccui.ListView:create()
    -- set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.7 * s_DESIGN_HEIGHT))
    listView:setPosition(s_LEFT_X,0.15 * s_DESIGN_HEIGHT)
    layer:addChild(listView)
    local count = math.ceil(bookCount / 2) + 1
    for i = 1, count do 
        local shelf = cc.Sprite:create('image/book/bookshelf_choose_book_button.png')
        shelf:ignoreAnchorPointForPosition(false)
        shelf:setAnchorPoint(0.5,0.5)

        local custom_item = ccui.Layout:create()
        custom_item:setTouchEnabled(true)
        custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.35 * s_DESIGN_HEIGHT))
        shelf:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height * 0.2))
        custom_item:addChild(shelf,0,'shelf')

        listView:insertCustomItem(custom_item,i - 1)
        if i == 1 then
            layer.book[i]:setPosition(0.5 * custom_item:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
            custom_item:addChild(layer.book[i])
            local flower = cc.Sprite:create('image/book/flower_choose_book.png')
            flower:setAnchorPoint(0.5,0)
            flower:setPosition(0.75 * shelf:getContentSize().width,0.75 * shelf:getContentSize().height)
            shelf:addChild(flower)
            
        elseif i < count then
            layer.book[2 * (i - 1) + bookCount%2 - 1]:setPosition(custom_item:getContentSize().width / 2.0 - 0.2 * shelf:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
            layer.book[2 * (i - 1) + bookCount%2]:setPosition(custom_item:getContentSize().width / 2.0 + 0.2 * shelf:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
            custom_item:addChild(layer.book[2 * (i - 1) + bookCount%2 - 1])
            custom_item:addChild(layer.book[2 * (i - 1) + bookCount%2])
        elseif bookCount <= 2 and i == 2 then
            layer.book[2]:setPosition(0.5 * custom_item:getContentSize().width,custom_item:getContentSize().height * 0.2 + 0.25 * shelf:getContentSize().height)
            custom_item:addChild(layer.book[2])
        end

    end

    local backBar = cc.Sprite:create('image/book/process_button_light_color.png')
    backBar:setPosition(0.97 * backColor:getContentSize().width,0.5 * backColor:getContentSize().height)
    backColor:addChild(backBar)  

    local progressBar = ccui.Scale9Sprite:create('image/book/process_button_dark_color.png',cc.rect(0,0,15,856),cc.rect(0, 10, 15, 836))
    --backBar:setContentSize(cc.size(15,1000))
    local percent = 0.85 / (count * 0.26)
    if percent > 1 then
        percent = 1
    end
    progressBar:setContentSize(cc.size(15,20 + 836 * percent))
    progressBar:ignoreAnchorPointForPosition(false)
    progressBar:setAnchorPoint(0.5,1)
    progressBar:setPosition(0.5 * backBar:getContentSize().width,backBar:getContentSize().height)
    backBar:addChild(progressBar)    
    backBar:setVisible(false)

    local isScrolling = false
    local isTouched = false
    local time = 0
    local overtime = 0
    local scrollY = listView:getInnerContainer():getPositionY()
    
    local onTouchBegan = function(touch, event) 
        isTouched = true
        return true  
    end

    local onTouchEnded = function(touch, event) 
        isTouched = false
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = listView:getItem(count - 1):getChildByName('shelf'):getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, listView:getItem(count - 1):getChildByName('shelf'))

    -- onAndroidKeyPressed(layer, function ()
    --         s_CorePlayManager.enterHomeLayer()
        
    -- end, function ()

    -- end)

    local function update(delta)
        local h = listView:getInnerContainer():getPositionY()
        if h == scrollY and not isTouched or time < 0.5 then
            if overtime > 0.2 or time < 0.5 then
                backBar:setVisible(false)
                overtime = 0
            else
                overtime = overtime + delta
            end
        elseif h ~= scrollY then
            backBar:setVisible(true)
            overtime = 0
        end
        scrollY = h
        time = time + delta
        local y = - h / (count * 0.26 * s_DESIGN_HEIGHT) - (count * 0.26 - 0.85) / (count * 0.26)
        if h > 0 then
            local p = percent * (s_DESIGN_HEIGHT - h) / s_DESIGN_HEIGHT
            progressBar:setContentSize(cc.size(15,20 + 836 * p))
            progressBar:setAnchorPoint(0.5,0)
            progressBar:setPositionY(0)
        elseif y < 0 then
            progressBar:setContentSize(cc.size(15,20 + 836 * percent))
            progressBar:setAnchorPoint(0.5,1)
            progressBar:setPositionY((1 + y) * backBar:getContentSize().height)
        else
            local p = percent * (1 - y)
            progressBar:setContentSize(cc.size(15,20 + 836 * p))
            progressBar:setAnchorPoint(0.5,1)
            progressBar:setPositionY(backBar:getContentSize().height)
        end
        
    end

    layer:scheduleUpdateWithPriorityLua(update, 0)
    return layer
end

return BookLayer

