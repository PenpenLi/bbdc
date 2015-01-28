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
    backColor:setPosition(s_DESIGN_WIDTH/2, bigHeight/2)
    scrollView:addChild(backColor)

    local back_head = cc.Sprite:create("image/shop/headback.png")
    back_head:setAnchorPoint(0.5, 1)
    back_head:setPosition(bigWidth/2, s_DESIGN_HEIGHT)
    layer:addChild(back_head)

    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           s_CorePlayManager.enterHomeLayer()
        end
    end

    local button_back = ccui.Button:create("image/shop/button_back.png","image/shop/button_back.png","")
    button_back:setPosition(50, s_DESIGN_HEIGHT-50)
    button_back:addTouchEventListener(button_back_clicked)
    layer:addChild(button_back) 

    local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    been_number_back:setPosition(s_DESIGN_WIDTH-100, s_DESIGN_HEIGHT-50)
    layer:addChild(been_number_back)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(0, been_number_back:getContentSize().height/2)
    been_number_back:addChild(been)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER.beans,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width/2 , been_number_back:getContentSize().height/2)
    been_number_back:addChild(been_number)

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
                local shopAlter = ShopAlter.create(i)
                shopAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                layer:addChild(shopAlter)
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



    return layer
end


return ShopLayer







