//
//  CXAvos.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAvos.h"
#include "CCLuaEngine.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>
#import "CXTencentSDKCall.h"
#import "CXUtils_iOS.h"

#pragma mark -

@interface CXTencentSDKCallObserver : NSObject 
@end

@implementation CXTencentSDKCallObserver

static CXTencentSDKCallObserver* cxTencentSDKCallObserver = nil;

+ (CXTencentSDKCallObserver*)getInstance {
    @synchronized([CXTencentSDKCallObserver class]) {
        if (cxTencentSDKCallObserver == nil) {
            cxTencentSDKCallObserver = [[self alloc] init];
        }
    }
    return cxTencentSDKCallObserver;
}

- (id) init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[CXTencentSDKCall getInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[CXTencentSDKCall getInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo:) name:kGetUserInfoResponse object:[CXTencentSDKCall getInstance]];
    }
    return self;
}

- (void)loginSuccessed {
    TencentOAuth* oauth = [CXTencentSDKCall getInstance].oauth;
    BOOL isGotUserInfo = [oauth getUserInfo];
    if (isGotUserInfo == NO) {
        CXAvos::getInstance()->invokeLuaCallbackFunction_logInByQQ(nullptr, nullptr, nullptr, "QQ log in error", 0);
    }
}

- (void)loginFailed {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
//    [alertView show];
    CXAvos::getInstance()->invokeLuaCallbackFunction_logInByQQ(nullptr, nullptr, nullptr, "QQ 登录失败", 0);
}

- (void)getUserInfo:(NSNotification*)info {
    NSDictionary* userinfo = [info userInfo];
    APIResponse* response = userinfo != nil ? userinfo[kResponse] : nil;
    TencentOAuth* oauth = [CXTencentSDKCall getInstance].oauth;
    NSDictionary* authData = @{@"openid":oauth.openId,
                               @"access_token":oauth.accessToken,
                               @"expires_in":[NSString stringWithFormat:@"%ld", (long)oauth.expirationDate.timeIntervalSince1970]};
    [AVUser loginWithAuthData:authData
                     platform:AVOSCloudSNSPlatformQQ
                        block:^(AVUser *user, NSError *error) {
        CXAvos::getInstance()->invokeLuaCallbackFunction_logInByQQ(user ? AVUserToJsonStr(user).UTF8String : nullptr,
                                                                   response ? [response message].UTF8String : nullptr,
                                                                   NSDictionaryToJSONString(authData).UTF8String,
                                                                   error ? error.localizedDescription.UTF8String : nullptr,
                                                                   error ? (int)error.code : 0);
    }];
}

@end

#pragma mark -

using namespace cocos2d;

void CXAvos::init() {
    [CXTencentSDKCallObserver getInstance];
}

void CXAvos::downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler) {
    NSString* oID = [NSString stringWithUTF8String:objectId];
    NSString* path = [NSString stringWithUTF8String:savepath];
    mLuaHandlerId_dl = nHandler;
    
    [AVFile getFileWithObjectId:oID withBlock:^(AVFile *file, NSError *error) {
        if (!file || error) {
            invokeLuaCallbackFunction_dl(oID.UTF8String, file ? file.name.UTF8String : "", error ? error.localizedDescription.UTF8String : "get file object error", false);
            return;
        }
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                invokeLuaCallbackFunction_dl(oID.UTF8String, file.name.UTF8String, error.localizedDescription.UTF8String, false);
            } else {
                NSString *filePath = [path stringByAppendingPathComponent:file.name];
                [data writeToFile:filePath atomically:YES];
                invokeLuaCallbackFunction_dl(oID.UTF8String, file.name.UTF8String, "save file succeed", true);
            }
        } progressBlock:^(NSInteger percentDone) {
            //
        }];
    }];
}

void CXAvos::downloadConfigFiles(const char* objectIds, const char* path) {
    
}

void CXAvos::downloadWordSoundFiles(const char* prefix, const char* wordsList, const char* subfix, const char* path) {
    
}

void CXAvos::signUp(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_signUp = nHandler;
    AVUser* user = [AVUser user];
    user.username = [NSString stringWithUTF8String:username];
    user.password = [NSString stringWithUTF8String:password];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        const char* objson = nullptr;
        if (user && user.objectId) {
            objson = AVUserToJsonStr(user).UTF8String;
        }
        invokeLuaCallbackFunction_su(objson, error ? error.localizedDescription.UTF8String : nullptr, error ? (int)error.code : 0);
    }];
}

void CXAvos::logIn(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_logIn = nHandler;
    [AVUser logInWithUsernameInBackground:[NSString stringWithUTF8String:username] password:[NSString stringWithUTF8String:password] block:^(AVUser *user, NSError *error) {
        invokeLuaCallbackFunction_li(user ? AVUserToJsonStr(user).UTF8String : nullptr, error ? error.localizedDescription.UTF8String : nullptr, error ? (int)error.code : 0);
    }];
}

void CXAvos::initTencentQQ(const char* appId, const char* appKey) {
    [[CXTencentSDKCall getInstance] setAppId:[NSString stringWithUTF8String:appId] appKey:[NSString stringWithUTF8String:appKey]];
}

void CXAvos::logInByQQ(CXLUAFUNC nHandler) {
    mLuaHandlerId_logInByQQ = nHandler;
    [[CXTencentSDKCall getInstance] login];
}

void CXAvos::logInByQQAuthData(const char* openid, const char* access_token, const char* expires_in, CXLUAFUNC nHandler) {
    mLuaHandlerId_logInByQQ = nHandler;
    NSDictionary* authData = @{@"openid":[NSString stringWithUTF8String:openid],
                               @"access_token":[NSString stringWithUTF8String:access_token],
                               @"expires_in":[NSString stringWithUTF8String:expires_in]};
    [AVUser loginWithAuthData:authData
                     platform:AVOSCloudSNSPlatformQQ
                        block:^(AVUser *user, NSError *error) {
        invokeLuaCallbackFunction_logInByQQ(user ? AVUserToJsonStr(user).UTF8String : nullptr,
                                            nullptr,
                                            nullptr,
                                            error ? error.localizedDescription.UTF8String : nullptr,
                                            error ? (int)error.code : 0);
    }];
}

void CXAvos::logOut() {
    [AVUser logOut];
}
