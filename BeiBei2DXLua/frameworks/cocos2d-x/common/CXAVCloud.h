//
//  CXAVCloud.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#ifndef __BeiBei2DXLua__CXAVCloud__
#define __BeiBei2DXLua__CXAVCloud__

#include <stdio.h>
#include "cocos2d.h"

typedef int CXLUAFUNC;

class CXAVCloud : public cocos2d::Ref
{
public:
    CXAVCloud();
    ~CXAVCloud();
    
    void callAVCloudFunction(const std::string& func, const std::string& parameters/*json*/, CXLUAFUNC callback);
    
    void invokeCallback(const char* objectjson, const char* errorjson);
    
    void searchUser(const char* username, const char* nickName, CXLUAFUNC nHandler);
    
    void getBulletinBoard(CXLUAFUNC nHandler);
    void invokeCallback_getBulletinBoard(int index, const char* content_top, const char* content, const char* errorjson);
    
private:
    CXLUAFUNC m_callback;
    CXLUAFUNC m_callback_getBulletinBoard;
};

#endif /* defined(__BeiBei2DXLua__CXAVCloud__) */
