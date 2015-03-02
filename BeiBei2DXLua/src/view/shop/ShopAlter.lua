require("common.global")

local ShopErrorAlter = require("view.shop.ShopErrorAlter")

local ShopAlter = class("ShopAlter", function()
    return cc.Layer:create()
end)

local button_sure

function ShopAlter.create(itemId, location)
    local state = s_CURRENT_USER:getLockFunctionState(itemId)
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local main = cc.LayerColor:create(cc.c4b(0,0,0,100),bigWidth,s_DESIGN_HEIGHT)
    main:setAnchorPoint(0.5,0.5)
    main:ignoreAnchorPointForPosition(false)

    main.sure = function()
        if s_CURRENT_USER:getBeans() >= s_DataManager.product[itemId].productValue then
            s_CURRENT_USER:subtractBeans(s_DataManager.product[itemId].productValue)
            s_CURRENT_USER:unlockFunctionState(itemId)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY], ['lockFunction']=s_CURRENT_USER.lockFunction})

            main:removeFromParent()
            
            if location == 'in' then
                local ShopLayer = require("view.shop.ShopLayer")
                local shopLayer = ShopLayer.create()
                s_SCENE:replaceGameLayer(shopLayer)
            else
                
            end
        else
            local shopErrorAlter = ShopErrorAlter.create()
            shopErrorAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
            main:addChild(shopErrorAlter)
        end
    end

    
    local back
    if location == 'out' then
        back = cc.Sprite:create("image/shop/alter_back_out.png")
    else
        back = cc.Sprite:create("image/shop/alter_back_in.png")
    end
    back:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2*3)
    main:addChild(back)

    local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT/2))
    local action2 = cc.EaseBackOut:create(action1)
    back:runAction(action2)

    local maxWidth = back:getContentSize().width
    local maxHeight = back:getContentSize().height

    if state == 0 then
        local item = cc.Sprite:create("image/shop/item"..itemId..".png")
        item:setPosition(maxWidth/2, maxHeight/2+150)
        back:addChild(item)
        
        local button_sure_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                main.sure()
            end
        end

        button_sure = ccui.Button:create("image/shop/long_button.png","image/shop/long_button_clicked.png","")
        button_sure:setPosition(maxWidth/2,100)
        button_sure:addTouchEventListener(button_sure_clicked)
        back:addChild(button_sure)

        local item_name = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productValue.."贝贝豆购买",'',30)
        item_name:setColor(cc.c4b(255,255,255,255))
        item_name:setPosition(button_sure:getContentSize().width/2+10, button_sure:getContentSize().height/2)
        button_sure:addChild(item_name)

        local been = cc.Sprite:create("image/shop/been.png")
        been:setPosition(50, button_sure:getContentSize().height/2)
        button_sure:addChild(been)
    else
        local title = cc.Sprite:create("image/shop/label"..itemId..".png")
        title:setPosition(maxWidth/2, maxHeight-80)
        back:addChild(title)
        
        local item = cc.Sprite:create("image/shop/product"..itemId..".png")
        item:setPosition(maxWidth/2, maxHeight/2+150)
        back:addChild(item)
    end
    
    local label_content
    if itemId == 6 and state == 1 then -- vip
        local vip_content = "恭喜你！获得贝贝VIP门票一张！请加微信：beibei001，距离VIP群，仅有一步之遥！"
        label_content = cc.Label:createWithSystemFont(vip_content,"",32)
    else
        label_content = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productDescription,"",32)
    end
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(0,0,0,255))
    label_content:setDimensions(maxWidth-180,0)
    label_content:setAlignment(0)
    label_content:setPosition(maxWidth/2, maxHeight/2-60)
    back:addChild(label_content)
    
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT * 1.5))
            local action2 = cc.EaseBackOut:create(action1)
            local remove = cc.CallFunc:create(function() 
            main:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,remove))
        end
    end

    button_close = ccui.Button:create("image/button/button_close.png","image/button/button_close.png","")
    button_close:setPosition(maxWidth-30,maxHeight-30)
    button_close:addTouchEventListener(button_close_clicked)
    back:addChild(button_close)

    -- touch lock
    local onTouchBegan = function(touch, event)        
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = main:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, main)

    return main
end

return ShopAlter
