//
//  CXAVCloud.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#include "CXAVCloud.h"
#import <AVOSCloud/AVOSCloud.h>
#include "CXUtils_iOS.h"

void CXAVCloud::callAVCloudFunction(const std::string& func, const std::string& parameters/*json*/, CXLUAFUNC callback) {
    NSString* avcloudFunc = [NSString stringWithUTF8String:func.c_str()];
    
    NSString* jsonString = [NSString stringWithUTF8String:parameters.c_str()];
    NSError* error_json = nil;
    NSDictionary* parsedData = JSONStringToNSDictionary(jsonString, &error_json);
    
    m_callback = callback;
    
    retain();
#if (COCOS2D_DEBUG > 0)
    NSString* funcx = [NSString stringWithUTF8String:func.c_str()];
    NSString* parametersx = [NSString stringWithUTF8String:parameters.c_str()];
#endif
    if (error_json == nil) {
        [AVCloud callFunctionInBackground:avcloudFunc withParameters:parsedData block:^(id object, NSError *error) {
            if (error) {
#if (COCOS2D_DEBUG > 0)
                CCLOG("funcx:%s", funcx.UTF8String);
                CCLOG("parametersx:%s", parametersx.UTF8String);
#endif
                NSString* errorjson = NSErrorToJSONString(error);
                invokeCallback(nullptr, errorjson.UTF8String);
            } else {
                NSString* objectjson = NSObjectToJSONString(object);
                invokeCallback(objectjson.UTF8String, nullptr);
            }
            release();
        }];
    } else {
        NSString* errorjson = NSErrorToJSONString(error_json);
        invokeCallback(nullptr, errorjson.UTF8String);
        release();
    }
}

void CXAVCloud::searchUser(const char* username, const char* nickName, CXLUAFUNC nHandler) {
    bool bu = username && strlen(username) > 0;
    AVQuery *query_username = nil;
    if (bu) {
        query_username = [AVQuery queryWithClassName:@"_User"];
        [query_username whereKey:@"username" equalTo:[NSString stringWithUTF8String:username]];
    }
    
    bool bn = nickName && strlen(nickName) > 0;
    AVQuery *query_nickName = nil;
    if (bn) {
        query_nickName = [AVQuery queryWithClassName:@"_User"];
        [query_nickName whereKey:@"nickName" equalTo:[NSString stringWithUTF8String:nickName]];
    }
    
    AVQuery *query = nil;
    if (bu && bn) {
        query = [AVQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query_username, query_nickName, nil]];
    } else if (bu) {
        query = query_username;
    } else if (bn) {
        query = query_nickName;
    }
    if (query != nil) {
        m_callback = nHandler;
        retain();
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSString* objectjson = @"";
                for (AVUser* u in objects) {
                    NSString* json = AVUserToJsonStr(u);
                    if (objectjson.length == 0) {
                        objectjson = [objectjson stringByAppendingFormat:@"{\"results\":[%@", json];
                    } else {
                        objectjson = [objectjson stringByAppendingFormat:@",%@", json];
                    }
                }
                if (objectjson.length > 0) {
                    objectjson = [objectjson stringByAppendingString:@"]}"];
                } else {
                    objectjson = @"{\"results\":[]}";
                }
                invokeCallback(objectjson.UTF8String, nullptr);
            } else {
                NSString* errorjson = NSErrorToJSONString(error);
                invokeCallback(nullptr, errorjson.UTF8String);
            }
            
            release();
        }];
    } else {
        invokeCallback(nullptr, "{\"code\":-1,\"message\":\"CXAVCloud-searchUser query\",\"description\":\"CXAVCloud-searchUser query\"}");
    }
}

void CXAVCloud::getBulletinBoard(CXLUAFUNC nHandler) {
    m_callback_getBulletinBoard = nHandler;
    retain();
    
    AVQuery* query = [AVQuery queryWithClassName:@"DataBulletinBoard"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (object != nil) {
            NSNumber* index = [object valueForKey:@"index"];
            NSString* content_top = [object valueForKey:@"content_top"];
            NSString* content = [object valueForKey:@"content"];
            invokeCallback_getBulletinBoard(index ? index.intValue : -1, content_top ? content_top.UTF8String : "", content ? content.UTF8String : "", nullptr);
        } else {
            NSString* errorjson = error ? NSErrorToJSONString(error) : nil;
            invokeCallback_getBulletinBoard(-1, "", "", errorjson ? errorjson.UTF8String : nullptr);
        }
        
        release();
    }];
}
