app_version_debug   = 206000
app_version_release = 206000

local function _initConstant()
    -- number
    s_max_wrong_num_everyday                = 10
    s_max_wrong_num_first_island            = 3
    s_max_wrong_num                         = {3,5,7,10}

    s_gamestate_reviewbossmodel_beforetoday = 1
    s_gamestate_studymodel                  = 2
    s_gamestate_reviewmodel                 = 3
    s_gamestate_studymodel_extra            = 4
    s_gamestate_reviewmodel_extra           = 5
    s_level_popup_state                     = 0

    -- checkInAnimation state
    s_isCheckInAnimationDisplayed           = true
    
    --need to do next version maybe
    s_gamestate_reviewbossmodel_today       = 9
    
    
    --
    s_spineCoconutLightJson   = "res/spine/coconut_light.json"
    s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

    s_sound_Aluminum_Can_Open = 'res/sound/Aluminum_Can_Open.mp3'
    s_sound_bgm1 = 'res/sound/bgm1.mp3'
    s_sound_buttonEffect = 'res/sound/buttonEffect.mp3'
    s_sound_clickLocked = 'res/sound/clickLocked.mp3'
    s_sound_clickWave = 'res/sound/clickWave.mp3'
    s_sound_cost = 'res/sound/cost.mp3'
    s_sound_faila = 'res/sound/fail.m4a'
    s_sound_fail = 'res/sound/fail.mp3'
    s_sound_FightBoss = 'res/sound/FightBoss.mp3'
    s_sound_First_Noel_pluto = 'res/sound/First_Noel_pluto.mp3'
    s_sound_Get_Outside = 'res/sound/Get_Outside.mp3'
    s_sound_Get_Outside_Speedup = 'res/sound/Get_Outside_speedup.mp3'
    s_sound_learn_false = 'res/sound/learn_false.mp3'
    s_sound_learn_true = 'res/sound/learn_true.mp3'
    s_sound_Mechanical_Clock_Ring = 'res/sound/faster.wav'
    s_sound_Pluto = 'res/sound/Pluto.mp3'
    s_sound_ReadyGo = 'res/sound/ReadyGo.mp3'
    s_sound_Road_to_Moscow = 'res/sound/Road_to_Moscow.mp3'
    s_sound_slideCoconut = 'res/sound/slideCoconut.mp3'
    s_sound_slideCoconut1 = 'res/sound/slideCoconut1.mp3'
    s_sound_slideCoconut2 = 'res/sound/slideCoconut2.mp3'
    s_sound_slideCoconut3 = 'res/sound/slideCoconut3.mp3'
    s_sound_slideCoconut4 = 'res/sound/slideCoconut4.mp3'
    s_sound_slideCoconut5 = 'res/sound/slideCoconut5.mp3'
    s_sound_slideCoconut6 = 'res/sound/slideCoconut6.mp3'
    s_sound_star1 = 'res/sound/star1.mp3'
    s_sound_star2 = 'res/sound/star2.mp3'
    s_sound_star3 = 'res/sound/star3.mp3'
    s_sound_wina = 'res/sound/win.m4a'
    s_sound_win = 'res/sound/win.mp3'
    s_sound_wrong = 'res/sound/wrong.mp3'

    CUSTOM_EVENT_SIGNUP = 'CUSTOMxx_EVENT_SIGNUP'
    CUSTOM_EVENT_LOGIN = 'CUSTOMxx_EVENT_LOGIN'

    s_WordDictionaryDatabase = s_WordDictionaryDatabase or require('model.WordDictionaryDatabase')
    if not IS_DEVELOPMENT_MODE then s_WordDictionaryDatabase.init() end

    s_DataManager = reloadModule('model.DataManager')
    s_DataManager.clear()
end

local function _initTool()
    reloadModule("cocos.init")
    -- reloadModule('Deprecated')
    
    -- tools
    s_JSON = reloadModule("common/json")

    -- debug
    s_debugger = reloadModule("common.debugger")
    s_debugger.configLog(true, true)
    s_logd     = s_debugger.logd
    s_logdStr  = s_debugger.logdStr

    reloadModule('common.utils')
    reloadModule("AudioMgr")
    s_O2OController = reloadModule('controller.O2OController')

    DEBUG_PRINT_LUA_TABLE = true
end

local function _initScene()
    -- create main scene 
    local scene = reloadModule("AppScene")
    s_SCENE = scene.create()
    -- layers of main scene
    s_BG_LAYER                = s_SCENE.bgLayer
    s_GAME_LAYER              = s_SCENE.gameLayer
    s_HUD_LAYER               = s_SCENE.hudLayer
    s_POPUP_LAYER             = s_SCENE.popupLayer
    s_TIPS_LAYER              = s_SCENE.tipsLayer
    s_TOUCH_EVENT_BLOCK_LAYER = s_SCENE.touchEventBlockLayer
    s_DEBUG_LAYER             = s_SCENE.debugLayer
end

local function _initServer()
    -- server
    s_SERVER                  = reloadModule('server.Server')
    s_SERVER.debugLocalHost   = false -- 'http://localhost:3000/avos/'
    s_SERVER.isAppStoreServer = false
    s_SERVER.production       = 0
    s_SERVER.sessionToken     = ''

    reloadModule('server.protocol.protocols')
    
    -- user base server
    s_UserBaseServer          = reloadModule('server.UserBaseServer')
    s_HttpRequestClient       = reloadModule('server.HttpRequestClient')

    reloadModule('server.Analytics')
end

local function _initData()
    DataUser = reloadModule('model.user.DataUser')
    
    s_LocalDatabaseManager = reloadModule('model.LocalDatabaseManager')
    s_LocalDatabaseManager.init()

    s_CURRENT_USER = DataUser.create()
end

local function _initStore()
    s_STORE = reloadModule('store.Store')
    s_STORE.init()
end

local function _declaration()
    s_CorePlayManager = nil
end

function initApp()
    _initConstant()
    _initTool()
    _initScene()
    _initServer()
    _initData()
    _initStore()
    _declaration()
end

local flag_getMaxWrongNumEveryLevel = {}
function getMaxWrongNumEveryLevel()
    if s_CURRENT_USER.bookKey == nil or s_CURRENT_USER.bookKey == '' or flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] == nil or flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] <= 9 then
        local bossList = s_LocalDatabaseManager.getAllBossInfo()
        flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] = #bossList
    end
    if flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] <= 1 then
        return s_max_wrong_num[1]
    elseif flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] == 2 or flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] == 5 then 
        return s_max_wrong_num[2]
    elseif flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] == 3 or flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] == 6 or flag_getMaxWrongNumEveryLevel[s_CURRENT_USER.bookKey] == 8 then 
        return s_max_wrong_num[3]
    else
        return s_max_wrong_num[4]
    end
end
