--启动模块
--处理分辨率、版本号、控制热更新等 

local start = {}

-- 下边两个变量用来区分是正式代码还是测试代码，测试代码运行example\example.lua
-- All test code must in example.example
local TEST_CODE   = 1 -- constant value
local NORMAL_CODE = 0 -- constant value
local test_code = NORMAL_CODE -- switch normal or test in this line

reloadModule("AppVersionInfo")
local HotUpdateController = reloadModule("hu.HotUpdateController")
local HotUpdateScene = reloadModule("hu.HotUpdateScene")

local function initResolution()
    -- size
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local _SCREEN_WIDTH  = size.width
    local _SCREEN_HEIGHT = size.height
    
    -- ********************** --
    s_DESIGN_WIDTH  = 640.0
    s_DESIGN_HEIGHT = 1136.0

    s_MAX_WIDTH     = 854.0
    -- ********************** --

    local _HEIGHT        = _SCREEN_HEIGHT
    local _HEIGHT_SCALE  = _SCREEN_HEIGHT / s_DESIGN_HEIGHT
    local _WIDTH         = s_DESIGN_WIDTH * _HEIGHT_SCALE

    -- ********************** --
    s_DESIGN_OFFSET_WIDTH = (_SCREEN_WIDTH - _WIDTH) / 2.0 / _HEIGHT_SCALE
    s_LEFT_X = -s_DESIGN_OFFSET_WIDTH
    s_RIGHT_X = s_DESIGN_WIDTH + s_DESIGN_OFFSET_WIDTH
    -- ********************** --

    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT, cc.ResolutionPolicy.FIXED_HEIGHT)
end

function start.init()
    initResolution()
    initBuildTarget()
    --加载语言配置文件 UI上的各种文字
    reloadModule('common.text')

    NETWORK_STATUS_WIFI = 1
    NETWORK_STATUS_MOBILE = 2
    --获取网络状态
    local status = cx.CXNetworkStatus:getInstance():start()
    print('start.init: ', status)
    --有网络的情况下会执行热更新逻辑
    if status == NETWORK_STATUS_WIFI or status == NETWORK_STATUS_MOBILE then
        --
        local scene = HotUpdateScene.create()
        if cc.Director:getInstance():getRunningScene() then
            cc.Director:getInstance():replaceScene(scene)
        else
            cc.Director:getInstance():runWithScene(scene)
        end

        --进入loading界面，同时启动热更逻辑
        local function go()
            local LoadingView = require("view.LoadingView")
            local loadingView = LoadingView.create()
            scene.rootLayer:addChild(loadingView)
            HotUpdateController.start()
        end
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
            --启动界面，一闪而过的，只在Android上有
            local SplashView = require("view.SplashView")
            local sv = SplashView.create()
            scene.rootLayer:addChild(sv)
            sv:setOnFinished(go)
        else
            go()
        end

    else
        --无网络情况下直接进入游戏  不更新
        start.start(false)
    end
end

function start.start(hotUpdate)
    reloadModule('common.text')   --常用提示文本
    reloadModule("common.global") --全局常量模块 类似单例
    s_APP_VERSION = app_version_release -- reset

    initApp()   --in global.lua，初始化各种单例 层 数据什么的
    if IS_SNS_QQ_LOGIN_AVAILABLE or IS_SNS_QQ_SHARE_AVAILABLE then 
        cx.CXAvos:getInstance():initTencentQQ(SNS_QQ_APPID, SNS_QQ_APPKEY) 
    end

    if BUILD_TARGET == BUILD_TARGET_RELEASE then
        -- remove print debug info when release app
        print = function ( ... )
        end

        test_code = NORMAL_CODE
       
        s_debugger.configLog(false, false)  --设置log打印规则  全都不打印
        DEBUG_PRINT_LUA_TABLE     = false   --不可以打印table
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false   -- TODO
        s_SERVER.production       = 1
        s_SERVER.hasLog           = false
        s_SERVER.closeNetwork     = false

        s_SERVER.appName = LEAN_CLOUD_NAME
        s_SERVER.appId = LEAN_CLOUD_ID
        s_SERVER.appKey = LEAN_CLOUD_KEY

    else
        --设置log打印规则 debugger.log  logd logdStr全部都打印
        s_debugger.configLog(true, true)
        DEBUG_PRINT_LUA_TABLE     = true
        s_SERVER.debugLocalHost   = false
        s_SERVER.isAppStoreServer = false
        s_SERVER.production       = 0
        s_SERVER.hasLog           = true

        if BUILD_TARGET == BUILD_TARGET_RELEASE_TEST then
            test_code = NORMAL_CODE

            s_SERVER.closeNetwork = false
            
            --LEAN_CLOUD_XXX在AppversionInfo.lua里
            s_SERVER.appName = LEAN_CLOUD_NAME
            s_SERVER.appId = LEAN_CLOUD_ID
            s_SERVER.appKey = LEAN_CLOUD_KEY
        else
            s_APP_VERSION = app_version_debug

            s_SERVER.appName = LEAN_CLOUD_NAME_TEST
            s_SERVER.appId = LEAN_CLOUD_ID_TEST
            s_SERVER.appKey = LEAN_CLOUD_KEY_TEST
        end
    end

    s_CURRENT_USER.appVersion = s_APP_VERSION
    if AgentManager ~= nil then s_CURRENT_USER.channelId = AgentManager:getInstance():getChannelId() end
    --报错信息推送到服务器上
    saveLuaError = function (msg)
        if s_SERVER.isNetworkConnectedNow() then
            local errorObj = {}
            errorObj['className'] = 'LuaError'
            local a = string.gsub(msg, ":",  ".    ") 
            local b = string.gsub(a,   '"',  "'") 
            local c = string.gsub(b,   "\n", ".    ") 
            local d = string.gsub(c,   "\t", ".    ") 
            errorObj['msg'] = s_CURRENT_USER.objectId .. ' ;' .. d
            errorObj['appVersion'] = s_APP_VERSION
            errorObj['RA'] = BUILD_TARGET
            s_SERVER.createData(errorObj)
        end

        onErrorNeedRestartAppHappendWithSingleButton('贝贝开小差了。。。需要重新启动', '原谅你')
    end
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(s_SCENE)
    else
        cc.Director:getInstance():runWithScene(s_SCENE)
    end


    
    -- *************************************
    if test_code == NORMAL_CODE then -- do NOT change this line
        --启动数据同步控制器
        local startApp = function ()
            s_O2OController.start()
        end
        --如果之前已经启动过更新逻辑 hotUpdate 会为true，然后直接startApp()
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID and hotUpdate == false then
            local SplashView = require("view.SplashView")
            local sv = SplashView.create()
            s_SCENE:replaceGameLayer(sv)
            sv:setOnFinished(startApp)
        else
            startApp()
        end
    else    
       -- *************************************
       -- for test
       -- all test codes MUST be written in example.example.lua
       -- do NOT write any test codes in here
       -- do NOT change these lines below
       require("example.example")
       test()
       -- *************************************
    end

end

return start
