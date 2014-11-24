#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "Runtime.h"
#include "ConfigParser.h"
#include "lua_cx_common.hpp"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "anysdkbindings.h"
#include "anysdk_manual_bindings.h"
#endif

#if (COCOS2D_DEBUG>0 && CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#define DEBUG_RUNTIME 1
#endif

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    
#if (COCOS2D_DEBUG>0 && DEBUG_RUNTIME > 0)
    initRuntime();
#endif
    
    if (!ConfigParser::getInstance()->isInit()) {
        ConfigParser::getInstance()->readConfig();
    }

    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();    
    if(!glview) {
        Size viewSize = ConfigParser::getInstance()->getInitViewSize();
        string title = ConfigParser::getInstance()->getInitViewName();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        extern void createSimulator(const char* viewName, float width, float height,bool isLandscape = true, float frameZoomFactor = 1.0f);
        bool isLanscape = ConfigParser::getInstance()->isLanscape();
        createSimulator(title.c_str(),viewSize.width,viewSize.height,isLanscape);
#else
        glview = GLView::createWithRect(title.c_str(), Rect(0,0,viewSize.width,viewSize.height));
        director->setOpenGLView(glview);
#endif
    }

   
    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);
   
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("fuck2dxLua", strlen("fuck2dxLua"), "fuckXXTEA", strlen("fuckXXTEA"));
    
    //register custom function
    auto state = stack->getLuaState();
    lua_getglobal(state, "_G");
    register_all_cx_common(state);
    lua_pop(state, 1);
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    {
    LuaStack* stack = engine->getLuaStack();
    lua_getglobal(stack->getLuaState(), "_G");
    tolua_anysdk_open(stack->getLuaState());
    tolua_anysdk_manual_open(stack->getLuaState());
    lua_pop(stack->getLuaState(), 1);
    }
#endif
    
#if (COCOS2D_DEBUG>0 && DEBUG_RUNTIME > 0)
    if (startRuntime())
        return true;
#endif

    engine->executeScriptFile(ConfigParser::getInstance()->getEntryFile().c_str());
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    auto engine = LuaEngine::getInstance();
    engine->executeScriptFile("view/Pause.lua");
    
    engine->executeGlobalFunction("createPauseLayerWhenTestOrBoss");
    
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}

