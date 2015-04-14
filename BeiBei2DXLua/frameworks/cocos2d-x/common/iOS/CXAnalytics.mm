//
//  CXAnalytics.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAnalytics.h"
#import <AVOSCloud/AVOSCloud.h>
#include "CXUtils.h"
#include "CXNetworkStatus.h"

#define DA_DEVICE_ID "DA_DEVICE_ID"
void _save(AVObject* dataAnalytics, NSString* deviceId, NSString* eventKey) {
    if ([dataAnalytics objectForKey:@DA_DEVICE_ID] == nil) {
        [dataAnalytics setObject:deviceId forKey:@DA_DEVICE_ID];
    }
    if ([dataAnalytics objectForKey:eventKey] == nil) {
        [dataAnalytics setObject:[NSNumber numberWithInt:1] forKey:eventKey];
    } else {
        [dataAnalytics incrementKey:eventKey];
    }
#if (COCOS2D_DEBUG > 0)
    [dataAnalytics saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error) {
            CCLOG("dataAnalytics:%s", eventKey.UTF8String);
        } else {
            CCLOG("dataAnalytics:%s,%s", eventKey.UTF8String, error.localizedDescription.UTF8String);
        }
    }];
#else
    [dataAnalytics saveEventually];
#endif
    
    [deviceId release];
    [eventKey release];
}
void saveDataAnalytics(const char* event, const char* label) {
    std::string deviceId = cocos2d::UserDefault::getInstance()->getStringForKey(DA_DEVICE_ID);
    if (deviceId.length() <= 0) {
        NSDate* datenow = [NSDate date];
        NSString* username = [NSString stringWithFormat: @"%d__%lf__%d", arc4random(), [datenow timeIntervalSince1970], arc4random()];
        std::string md5name(username.UTF8String);
        deviceId = CXUtils::md5(username.UTF8String, md5name);
        cocos2d::UserDefault::getInstance()->setStringForKey(DA_DEVICE_ID, md5name);
    }
    
    static AVObject* dataAnalytics = nil;
    __block NSString* did = [NSString stringWithUTF8String:deviceId.c_str()];
    [did retain];
    __block NSString* eventKey = [NSString stringWithFormat:@"%s_%s", event, label];
    [eventKey retain];
    
    if (CXNetworkStatus::getInstance()->getStatus() == CXNetworkStatus::STATUS_MOBILE
        || CXNetworkStatus::getInstance()->getStatus() == CXNetworkStatus::STATUS_WIFI
        || CXNetworkStatus::getInstance()->start() == CXNetworkStatus::STATUS_MOBILE
        || CXNetworkStatus::getInstance()->start() == CXNetworkStatus::STATUS_WIFI) {
    
        if (dataAnalytics == nil) {
            AVQuery *query = [AVQuery queryWithClassName:@"DataAnalytics"];
            [query whereKey:@DA_DEVICE_ID equalTo:did];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects.count > 0) {
                        dataAnalytics = objects[0];
                    }
                } else {
                    CCLOG("dataAnalytics:%s,%s", eventKey.UTF8String, error.localizedDescription.UTF8String);
                }
                
                if (dataAnalytics == nil) {
                    dataAnalytics = [AVObject objectWithClassName:@"DataAnalytics"];
                }
                [dataAnalytics retain];
                
                _save(dataAnalytics, did, eventKey);
            }];
        } else {
            _save(dataAnalytics, did, eventKey);
        }
        
    } else {
        if (dataAnalytics == nil) {
            dataAnalytics = [AVObject objectWithClassName:@"DataAnalytics"];
            [dataAnalytics retain];
        }
        _save(dataAnalytics, did, eventKey);
    }
}

void CXAnalytics::beginLog(const char* pageName) {
    [AVAnalytics beginLogPageView:[NSString stringWithUTF8String:pageName]];
}

void CXAnalytics::endLog(const char* pageName) {
    [AVAnalytics endLogPageView:[NSString stringWithUTF8String:pageName]];
}

void CXAnalytics::logEventAndLabel(const char* event, const char* label) {
    [AVAnalytics event:[NSString stringWithUTF8String:event]
                 label:[NSString stringWithUTF8String:label]];
    saveDataAnalytics(event, label);
}

void CXAnalytics::logUsingTime(const char* userId, const char* bookKey, int startTime, int usingTime) {
    AVObject* dataDailyUsing = [AVObject objectWithClassName:@"DataDailyUsing"];
    [dataDailyUsing setObject:[NSString stringWithUTF8String:userId] forKey:@"userId"];
    [dataDailyUsing setObject:[NSString stringWithUTF8String:bookKey] forKey:@"bookKey"];
    [dataDailyUsing setObject:[NSNumber numberWithInt:startTime] forKey:@"startTime"];
    [dataDailyUsing setObject:[NSNumber numberWithInt:usingTime] forKey:@"usingTime"];
#if (COCOS2D_DEBUG > 0)
    [dataDailyUsing saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error) {
            CCLOG("dataDailyUsing:%d,%d", startTime, usingTime);
        } else {
            CCLOG("dataDailyUsing:%d,%d,%s", startTime, usingTime, error.localizedDescription.UTF8String);
        }
    }];
#else
    [dataDailyUsing saveEventually];
#endif
}
