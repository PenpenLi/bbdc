//
//  CXNetworkStatus.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/9/15.
//
//

#include "CXNetworkStatus.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"

@interface CXNS : NSObject

+ (CXNS *)getInstance;
- (void)start;
- (void)updateInternetReachability;
+ (NSString *) md5:(NSString *) input;

@end

@interface CXNS ()

@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;

@end

@implementation CXNS

static CXNS *g_instance = nil;

+ (CXNS *)getInstance {
    @synchronized(self) {
        if (nil == g_instance) {
            g_instance = [[super allocWithZone:nil] init];
        }
    }
    
    return g_instance;
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
//    NSString *remoteHostName = @"www.baidu.com";
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
//    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
//    [self.wifiReachability startNotifier];
//    [self updateInterfaceWithReachability:self.wifiReachability];
}

- (void) reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability {
//    if (reachability == self.internetReachability) {
//    }
//    if (reachability == self.wifiReachability) {
//    }
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
//    BOOL connectionRequired = [reachability connectionRequired];
     
    switch (netStatus) {
        case NotReachable: {
            // NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_NONE);
            break;
        }
            
        case ReachableViaWWAN: {
            // NSLocalizedString(@"Reachable WWAN", @"");
            CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_MOBILE);
            break;
        }
        case ReachableViaWiFi: {
            // NSLocalizedString(@"Reachable WiFi", @"");
            CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_WIFI);
            break;
        }
    }
}

- (void)updateInternetReachability {
    [self updateInterfaceWithReachability:self.internetReachability];
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end

int CXNetworkStatus::start() {
    [[CXNS getInstance] start];
    return m_status; 
}

int CXNetworkStatus::getStatus() { 
    [[CXNS getInstance] updateInternetReachability];
    return m_status; 
}

const char* CXNetworkStatus::getDeviceUDID() {
    // TODO: CXAnalytics.mm
    // std::string deviceId = cocos2d::UserDefault::getInstance()->getStringForKey(DA_DEVICE_ID);
    // if (deviceId.length() <= 0) {
    //     NSDate* datenow = [NSDate date];
    //     NSString* username = [NSString stringWithFormat: @"%d__%lf__%d", arc4random(), [datenow timeIntervalSince1970], arc4random()];
    //     std::string md5name(username.UTF8String);
    //     deviceId = CXUtils::md5(username.UTF8String, md5name);
    //     cocos2d::UserDefault::getInstance()->setStringForKey(DA_DEVICE_ID, md5name);
    // }
    NSDate *datenow = [NSDate date];
    NSString* username = [NSString stringWithFormat: @"%d__%lf__%d", arc4random(), [datenow timeIntervalSince1970], arc4random()];
    NSString* md5name = [CXNS md5:username];
    return md5name.UTF8String;
}

long CXNetworkStatus::getCurrentTimeMillis() {
    NSDate *datenow = [NSDate date];
    return [datenow timeIntervalSince1970] * 1000.0;
}
