require("common.global")

local ShopErrorAlter = require("view.shop.ShopErrorAlter")
local Button                = require("view.button.longButtonInStudy")

local ShopPanel = class("ShopPanel", function()
    return cc.Layer:create()
end)

local button_sure

function ShopPanel.create(itemId)    
    local maxWidth = s_DESIGN_WIDTH
    local maxHeight = 800

    local main = cc.LayerColor:create(cc.c4b(255,255,255,255), maxWidth, maxWidth)
    main:setAnchorPoint(0.5,0)
    main:ignoreAnchorPointForPosition(false)

    main.feedback = function()
    end

    main.sure = function()
        if s_CURRENT_USER:getBeans() >= s_DataManager.product[itemId].productValue then

            s_CURRENT_USER:subtractBeans(s_DataManager.product[itemId].productValue)
            s_CURRENT_USER:unlockFunctionState(itemId)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY], ['lockFunction']=s_CURRENT_USER.lockFunction})

            main.feedback()
            main:removeFromParent()
        else
            local shopErrorAlter = ShopErrorAlter.create()
            s_SCENE:popup(shopErrorAlter)
        end
    end

    local item = cc.Sprite:create("image/shop/item"..itemId..".png")
    item:setPosition(maxWidth/2, 470)
    main:addChild(item)

    local button_func = function()
        main.sure()
    end

    button_sure = Button.create("middle","blue",s_DataManager.product[itemId].productValue.."贝贝豆购买") 
    button_sure:setPosition(maxWidth/2,240)
    button_sure.func = function ()
        button_func()
    end

    local cantBuy_Sprite = cc.Sprite:create("image/islandPopup/lock.png")
    cantBuy_Sprite:setPosition(maxWidth/2,240)

    local cantBuy_Label = cc.Label:createWithSystemFont("现在不卖！","",30)
    cantBuy_Label:setPosition(cc.p(cantBuy_Sprite:getContentSize().width / 2 ,cantBuy_Sprite:getContentSize().height / 2))
    cantBuy_Label:setColor(cc.c4b(155,155,155,255))
    cantBuy_Sprite:addChild(cantBuy_Label)

    if s_CURRENT_USER.newTutorialStep < s_newtutorial_loginreward then
        main:addChild(cantBuy_Sprite)
    else
        main:addChild(button_sure)
    end

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(50, button_sure.button_front:getContentSize().height/2)
    button_sure.button_front:addChild(been)

    local label_content = cc.Label:createWithSystemFont(s_DataManager.product[itemId].productDescription,"",30)
    label_content:setAnchorPoint(0.5, 1)
    label_content:setColor(cc.c4b(84,107,144,255))
    label_content:setDimensions(370,0)
    label_content:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label_content:setPosition(maxWidth/2, 700)
    main:addChild(label_content)

    return main
end

return ShopPanel
