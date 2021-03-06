//
//  CXAvos.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#ifndef __BeiBei2DXLua__CXAvos__
#define __BeiBei2DXLua__CXAvos__

#include <stdio.h>
#include "cocos2d.h"

typedef int CXLUAFUNC;

class CXAvos : public cocos2d::Ref {
public:
    static CXAvos* getInstance();
    
    void downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler);
    void downloadConfigFiles(const char* objectIds, const char* path);
    void downloadWordSoundFiles(const char* prefix, const char* wordsList, const char* subfix, const char* path);
    void invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved);
    
    void signUp(const char* username, const char* password, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_su(const char* objectjson, const char* error, int errorcode);
    
    void logIn(const char* username, const char* password, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_li(const char* objectjson, const char* error, int errorcode);
    
    void initTencentQQ(const char* appId, const char* appKey);
    void logInByQQ(CXLUAFUNC nHandler);
    void logInByQQAuthData(const char* openid, const char* access_token, const char* expires_in, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_logInByQQ(const char* objectjson, const char* qqjson, const char* authjson, const char* error, int errorcode);
    
    void logOut();
    
private:
    static CXAvos* m_pInstance;
    CXAvos();
    void init();
    
    int mLuaHandlerId_dl;
    int mLuaHandlerId_signUp;
    int mLuaHandlerId_logIn;
    int mLuaHandlerId_logInByQQ;
};

#endif /* defined(__BeiBei2DXLua__CXAvos__) */
