require("cocos.init")
require("common.global")

local ShopAlter = require("view.shop.ShopAlter")

local ShopLayer = class("ShopLayer", function()
    return cc.Layer:create()
end)

function ShopLayer.create()    
    local layer = ShopLayer.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local bigHeight = 1.0*s_DESIGN_HEIGHT

    local initColor = cc.LayerColor:create(cc.c4b(248,247,235,255), bigWidth, s_DESIGN_HEIGHT)
    initColor:setAnchorPoint(0.5,0.5)
    initColor:ignoreAnchorPointForPosition(false)  
    initColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(initColor)

    local scrollView = ccui.ScrollView:create()
    scrollView:setTouchEnabled(true)
    scrollView:setBounceEnabled(true)
    scrollView:setAnchorPoint(0.5,0.5)
    scrollView:ignoreAnchorPointForPosition(false)
    scrollView:setContentSize(cc.size(bigWidth, s_DESIGN_HEIGHT))  
    scrollView:setInnerContainerSize(cc.size(bigWidth, bigHeight))      
    scrollView:setPosition(cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    layer:addChild(scrollView)

    local backColor = cc.LayerColor:create(cc.c4b(248,247,235,255), bigWidth, bigHeight)
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(bigWidth/2, bigHeight/2)
    scrollView:addChild(backColor)

    local back_head = cc.ProgressTimer:create(cc.Sprite:create("image/shop/headback.png"))
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT)
    back_head:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    back_head:setMidpoint(cc.p(0.5, 0))
    back_head:setBarChangeRate(cc.p(1, 0))
    back_head:setPercentage((s_RIGHT_X - s_LEFT_X) / back_head:getContentSize().width * 100)
    layer:addChild(back_head)

    layer.backToHome = function ()

    end

    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if s_CURRENT_USER.newTutorialStep == s_newtutorial_over then
                local HomeLayer = require("view.home.HomeLayer")
                local HomeLayer = HomeLayer.create()  
                s_SCENE:replaceGameLayer(HomeLayer)
            else
                layer.backToHome()
            end
        end
    end

    local button_back = ccui.Button:create("image/shop/button_back.png","image/shop/button_back.png","")
    button_back:setPosition(50, s_DESIGN_HEIGHT-50)
    button_back:addTouchEventListener(button_back_clicked)
    layer:addChild(button_back) 

    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    layer:addChild(beans)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)

    local height = 320
    local productNum = #s_DataManager.product
    for i = 1, math.ceil(productNum/2) do
        local shelf = cc.Sprite:create("image/shop/shelf.png")
        shelf:setPosition(s_DESIGN_WIDTH/2, bigHeight-80-height*i)
        backColor:addChild(shelf) 
    end

    for i = 1, productNum do
        local x = s_DESIGN_WIDTH/2+150*(1-2*(i%2))
        local y = bigHeight-height*(math.floor((i-1)/2))-435
        
        local item_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                local shopAlter = ShopAlter.create(i, 'in')
                s_SCENE:popup(shopAlter)
            end
        end
        
        local item_name_back = cc.Sprite:create("image/shop/item_name_back.png")
        item_name_back:setPosition(x+15, y)
        backColor:addChild(item_name_back) 

        if s_CURRENT_USER:getLockFunctionState(i) == 0 then
            local item = ccui.Button:create("image/shop/item"..i..".png","image/shop/item"..i..".png","")
            item:setPosition(x, y+150)
            item:addTouchEventListener(item_clicked)
            backColor:addChild(item)
        
            local item_name = cc.Label:createWithSystemFont(s_DataManager.product[i].productValue,'',28)
            item_name:setColor(cc.c4b(0,0,0,255))
            item_name:setPosition(item_name_back:getContentSize().width/2-10, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(item_name)

            local been_small = cc.Sprite:create("image/shop/been_small.png")
            been_small:setPosition(40, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(been_small)
        else
            local item = ccui.Button:create("image/shop/product"..i..".png","image/shop/product"..i..".png","")
            item:setPosition(x, y+150)
            item:addTouchEventListener(item_clicked)
            backColor:addChild(item)
            
            local label = cc.Sprite:create("image/shop/label"..i..".png")
            label:setPosition(x-10, y+110)
            backColor:addChild(label) 
        
            local item_name = cc.Label:createWithSystemFont('已购','',28)
            item_name:setColor(cc.c4b(0,0,0,255))
            item_name:setPosition(item_name_back:getContentSize().width/2-20, item_name_back:getContentSize().height/2-5)
            item_name_back:addChild(item_name)
        end
    end

    onAndroidKeyPressed(layer, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if #isPopup == 0 then
            layer.backToHome()
        end
    end, function ()

    end)

    if s_CURRENT_USER.newTutorialStep == s_newtutorial_shop then
        local darkColor = cc.LayerColor:create(cc.c4b(0,0,0,150), bigWidth, s_DESIGN_HEIGHT)
        darkColor:setAnchorPoint(0.5,0.5)
        darkColor:ignoreAnchorPointForPosition(false)
        darkColor:setPosition(s_DESIGN_WIDTH / 2 ,s_DESIGN_HEIGHT/2)
        layer:addChild(darkColor, 2)

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(function(touch, event) return true end,cc.Handler.EVENT_TOUCH_BEGAN )
        darkColor:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, darkColor)

        local back = cc.Sprite:create("image/newstudy/background_word_xinshouyindao_yellow.png")
        back:setPosition(bigWidth/2, s_DESIGN_HEIGHT*0.5)
        back:ignoreAnchorPointForPosition(false)
        back:setAnchorPoint(0.5,0.5)
        darkColor:addChild(back)

        local body = cc.Sprite:create("image/guide/beibei_xinshouyindao_buy.png")
        body:setPosition(150, 250)
        back:addChild(body)

        local beibei_arm = cc.Sprite:create("image/guide/beibei_hand2_xinshouyindao_buy.png")
        beibei_arm:setPosition(body:getContentSize().width/2 + 80,body:getContentSize().height/2 - 115)
        beibei_arm:ignoreAnchorPointForPosition(false)
        beibei_arm:setAnchorPoint(0,0)
        body:addChild(beibei_arm,-1)

        local title = cc.Label:createWithSystemFont('买一个试试！','',40)
        title:setPosition(back:getContentSize().width/2,back:getContentSize().height/2)
        title:setColor(cc.c3b(35,181,229))
        back:addChild(title)

        local i = 2
        local x = bigWidth/2+150*(1-2*(i%2))
        local y = bigHeight-height*(math.floor((i-1)/2))-435

        local item_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                s_CURRENT_USER.newTutorialStep = s_newtutorial_allover
                saveUserToServer({['newTutorialStep'] = s_CURRENT_USER.newTutorialStep})
                darkColor:removeFromParent()
                local shopAlter = ShopAlter.create(i, 'in')
                s_SCENE:popup(shopAlter)
            end
        end

        local item = ccui.Button:create("image/shop/item"..i..".png","image/shop/item"..i..".png","")
        item:setPosition(x, y+150)
        item:addTouchEventListener(item_clicked)
        darkColor:addChild(item)

        local item_name_back = cc.Sprite:create("image/shop/item_name_back.png")
        item_name_back:setPosition(x+15, y)
        darkColor:addChild(item_name_back) 
    
        local item_name = cc.Label:createWithSystemFont(s_DataManager.product[i].productValue,'',28)
        item_name:setColor(cc.c4b(0,0,0,255))
        item_name:setPosition(item_name_back:getContentSize().width/2-10, item_name_back:getContentSize().height/2-5)
        item_name_back:addChild(item_name)

        local been_small = cc.Sprite:create("image/shop/been_small.png")
        been_small:setPosition(40, item_name_back:getContentSize().height/2-5)
        item_name_back:addChild(been_small)

    end
    
    return layer
end


return ShopLayer







