//
//  CXAvos.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAvos.h"
#include "CCLuaEngine.h"
#include "platform/android/jni/JniHelper.h"

using namespace cocos2d;

CXAvos* CXAvos::m_pInstance = nullptr;

CXAvos* CXAvos::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXAvos();
    }
    return m_pInstance;
}

CXAvos::CXAvos()
: mLuaHandlerId_dl(0) {
    
}

void CXAvos::downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler) {
    mLuaHandlerId_dl = nHandler;

    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "com/beibei/wordmaster/AppActivity", "downloadFile", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_objectId = t.env->NewStringUTF(objectId);
        jstring stringArg_savepath = t.env->NewStringUTF(savepath);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_objectId, stringArg_savepath);

        t.env->DeleteLocalRef(stringArg_objectId);
        t.env->DeleteLocalRef(stringArg_savepath);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved)
{
    if (mLuaHandlerId_dl > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectId);
        stack->pushString(filename);
        stack->pushString(error);
        stack->pushBoolean(isSaved);
        stack->executeFunctionByHandler(mLuaHandlerId_dl, 4);
        stack->clean();
    }
}