local Store = {}

require('anysdkConst')

Store.isRequestProductsSucceed = false

function Store.init()
    s_logd('getTargetPlatform:' .. cc.Application:getInstance():getTargetPlatform())
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
--xiao mi
-- 包名： com.beibei.wordmaster.cet.beta.mi
-- AppID： 2882303761517321888
-- AppKey： 5641732154888
-- AppSecret： bP7urwnvwK7uvsQbSBKEaA==

        local appKey = "7FA34EB7-E4FB-8FC1-E9B3-B886EA7752EC"
        local appSecret = "22577f7dcb9462e963d32ff0cb230db8"
        local privateKey = "7D1ACA383F155FD22D52C6FE64B87C03"
        local oauthLoginServer = "http://oauth.anysdk.com/api/User/LoginOauth/"
        local agent = AgentManager:getInstance()
        agent:init(appKey,appSecret,privateKey,oauthLoginServer)
        agent:loadALLPlugin()

        AnalyticsChannel(agent:getChannelId())
    end
end

-- function onResult( pPlugin, code, msg )
function Store.login(onResult)
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        local agent = AgentManager:getInstance()
        local user_plugin = agent:getUserPlugin()    
        local onActionListener = function ( pPlugin, code, msg )
           s_logd("on user action listener. " .. code .. ", msg:" .. msg)
           -- s_logd("agent is " .. agent .. " user_plugin is " .. user_plugin)
           local pId = user_plugin:getPluginId()
           local userID = user_plugin:getUserID()
           local customParam = agent:getCustomParam()
           local channelId = agent:getChannelId()
        end
        if onResult ~= nil then onActionListener = onResult end
        user_plugin:setActionListener(onActionListener)
        user_plugin:login()
    end
end

-- function onResult( code, msg, info )   --code: pay result code, msg: par result message, info: product info
function Store.buy(onResult)
    local productId = "com.beibei.wordmaster.ep30"
    --- android
    --支付成功           kPaySuccess null或者错误信息的简单描述
    --支付取消           kPayCancel  null或者错误信息的简单描述
    --支付失败           kPayFail    null或者错误信息的简单描述
    --支付网络出现错误     kPayNetworkError    null或者错误信息的简单描述
    --支付信息提供不完全   kPayProductionInforIncomplete   null或者错误信息的简单描述
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        local agent = AgentManager:getInstance()
        local iap_plugin_maps = agent:getIAPPlugin()

        for key, value in pairs(iap_plugin_maps) do
            value:setResultListener(onResult)
        end

        local user_plugin = agent:getUserPlugin()

        local info = {
            Product_Id=productId,  
            Product_Name="贝贝体力值10点",  
            Product_Price="1", 
            Product_Count="1",  

            Role_Name=s_CURRENT_USER.username,
            Role_Grade=s_CURRENT_USER.currentLevelIndex,
            Role_Balance="0",

            Server_Id="1"
        }
        if user_plugin ~= nil then
            local userID = user_plugin:getUserID()
            info.Role_Id = userID
        else
            info.Role_Id = s_CURRENT_USER.username
        end

        s_logd('Store.buy')
        print_lua_table(info)
        s_logd('Store.buy')
        print_lua_table(iap_plugin_maps)
        s_logd('Store.buy')
        for key, value in pairs(iap_plugin_maps) do
            value:payForProduct(info)
        end
        s_logd('payForProduct: ' .. info.Product_Id)

    --- iOS
    -- kPaySuccess = 0,
    -- kPayFail,
    -- kPayCancel,
    -- kPayTimeOut,
    elseif Store.isRequestProductsSucceed == true then
        cx.CXStore:getInstance():payForProduct(productId, onResult)
    else
        -- RequestSuccees=0,
        -- RequestFail,
        -- RequestTimeout,
        cx.CXStore:getInstance():requestProducts(productId, function (ret, json)
            if ret == 0 then
                Store.isRequestProductsSucceed = true
                cx.CXStore:getInstance():payForProduct(productId, onResult)
            elseif onResult ~= nil then
                onResult(ret, json, info)
            end
        end)
    end
end

return Store
