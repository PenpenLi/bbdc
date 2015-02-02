#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import shutil

try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

BUILD_TARGET_DEBUG = '0'
BUILD_TARGET_RELEASE = '1'
BUILD_TARGET_RELEASE_TEST = '2'

# ---------------------------------------------------------

LEAN_CLOUD_XIAOMI    = ["94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp", "lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz", 'xiao mi']
LEAN_CLOUD_X_0       = ['2ktgzl363xwj3y3l9axd5hx3i8t31k48tt6344ds0qdg38jq', 'gycctmmh4csumv8opxtodi55e6837r3w5sjtm7tpunqgovjc', 'x_0']

UMENG_APP_XIAOMI     = ["5498fc3afd98c56b4200075d", "xiao-mi"]
UMENG_APP_ANDROID    = ['549a5eb9fd98c5b2ac00144e', 'android']

# ---------------------------------------------------------

LEAN_CLOUD_TEST = ["gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn", "x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3", 'test']
QQ_APP = ['true', 'package name', "1103783596", "n7vXdt6eDIggSsa6" , 'true']
WEIXIN_APP = ['true', 'wx68b3465c73ce139e']
LEAN_CLOUD_RELEASE = LEAN_CLOUD_XIAOMI
UMENG_APP = UMENG_APP_ANDROID

# ---------------------------------------------------------

def getCodeTypeDes(codeType):
    if codeType == BUILD_TARGET_DEBUG:
        return 'debug'
    elif codeType == BUILD_TARGET_RELEASE:
        return 'release'
    elif codeType == BUILD_TARGET_RELEASE_TEST:
        return 'release for test'

def getLeanCloudAppId(codeType):
    lean_cloud_id = LEAN_CLOUD_RELEASE[0]
    if codeType == BUILD_TARGET_DEBUG:
        lean_cloud_id = LEAN_CLOUD_TEST[0]
    return lean_cloud_id

def getLeanCloudAppKey(codeType):
    lean_cloud_key = LEAN_CLOUD_RELEASE[1]
    if codeType == BUILD_TARGET_DEBUG:
        lean_cloud_key = LEAN_CLOUD_TEST[1]        
    return lean_cloud_key

def getLeanCloudAppName(codeType):
    lean_cloud_name = LEAN_CLOUD_RELEASE[2]
    if codeType == BUILD_TARGET_DEBUG:
        lean_cloud_name = LEAN_CLOUD_TEST[2]        
    return lean_cloud_name

# ---------------------------------------------------------

def getJsonObjToStr(jsonObj):
    ret = str(json.dumps(jsonObj, ensure_ascii=False, indent=4).encode('utf8'))
    l = len(ret)
    if l > 1 and ret[0] == '"' and ret[l - 1] == '"':
        ret = ret[1:l-1]
    return ret

def init(channelName, channelConfigs, androidManifest, androidManifestTarget, channelConfigsDir, AppActivityJava, javaSrcDir):
    global LEAN_CLOUD_RELEASE
    global UMENG_APP
    global QQ_APP
    configs = open(channelConfigs).read()
    jsonObj = json.loads(configs)
    channels = jsonObj['channels']
    for c in channels:
        if c['name'] == channelName:
            print getJsonObjToStr(c)
            packageName = str(c['packageName'])

            am = open(androidManifest).read()
            # <meta-data android:name="Channel ID" android:value="LeanCloud"/>
            am = am.replace('LeanCloud', packageName)
            if len( str(c['QQAppId']) ) > 0:
                am = am.replace('1103783596', str(c['QQAppId']))
            else:
                am = am.replace('<!-- tencent start -->', '<!-- tencent start ')
                am = am.replace('<!-- tencent end -->', ' tencent end -->')

            # TODO
            # aaj = open(channelConfigsDir + AppActivityJava).read()
            # if packageName == "com.beibei.wordmaster.tencentmyapp":
            #     am = am.replace('com.beibei.wordmaster', 'com.beibei.wordmaster.tencentmyapp')
            #     aaj = aaj.replace('com.beibei.wordmaster', 'com.beibei.wordmaster.tencentmyapp')

            amt = open(androidManifestTarget, 'w')
            amt.write(am)
            amt.close()

            # newJavaSrcDir = javaSrcDir + packageName.replace('.', '/') + '/'
            # if os.path.exists(javaSrcDir + 'com/beibei/wordmaster'):
            #     shutil.rmtree(javaSrcDir + 'com/beibei/wordmaster')
            #     os.makedirs(newJavaSrcDir)
            # newAppActivityJava = open(newJavaSrcDir + AppActivityJava, 'w')
            # newAppActivityJava.write(aaj)
            # newAppActivityJava.close()

            LEAN_CLOUD_RELEASE = [str(c['leanCloudAppId']), str(c['leanCloudAppKey']), getJsonObjToStr(c['leanCloudAppName'])]
            UMENG_APP = [str(c['umengAppKey']), getJsonObjToStr(c['umengAppName'])]
            QQ_APP = [str(c['isQQLogInAvailable']), getJsonObjToStr(c['packageName']), str(c['QQAppId']), str(c['QQAppKey'])]

            print getJsonObjToStr(c['umengAppName'])
            print QQ_APP

            return
    

# ---------------------------------------------------------

def exportLua(codeType, appVersionInfo, fullpathLua):
    appVersionInfoLua = '''-- %s

--------------------------------------------------------------------------------

IS_SNS_QQ_LOGIN_AVAILABLE = %s
-- PACKAGE NAME : %s
SNS_QQ_APPID  = '%s'
SNS_QQ_APPKEY = '%s'

--------------------------------------------------------------------------------

-- debug server: %s
LEAN_CLOUD_ID_TEST   = "%s"
LEAN_CLOUD_KEY_TEST  = "%s"

-- release server: %s
LEAN_CLOUD_ID        = "%s"
LEAN_CLOUD_KEY       = "%s"

--------------------------------------------------------------------------------

BUILD_TARGET_DEBUG            = '0'
BUILD_TARGET_RELEASE          = '1'
BUILD_TARGET_RELEASE_TEST     = '2'

BUILD_TARGET = '%s' -- BUILD_TARGET_DEBUG, BUILD_TARGET_RELEASE, BUILD_TARGET_RELEASE_TEST

--------------------------------------------------------------------------------

LUA_ERROR = ''

function getAppVersionDebugInfo()
    if BUILD_TARGET_RELEASE == BUILD_TARGET then return end

    local str = ''
    -- if s_CURRENT_USER.sessionToken ~= '' then str = s_CURRENT_USER.username .. '\\nnick:' .. s_CURRENT_USER.nickName end
    str = s_CURRENT_USER.username .. '\\nnick:' .. s_CURRENT_USER.nickName
    if AgentManager ~= nil then
        str = 'name:' .. str .. '\\nchannel:' .. AgentManager:getInstance():getChannelId() .. ' v:' .. s_APP_VERSION .. '\\n%s'
    else
        str = 'name:' .. str .. '\\nchannel:' .. 'unknown' .. ' v:' .. s_APP_VERSION .. '\\n%s'
    end
    str = '[%s]' .. ' ' .. str .. '\\n' .. LUA_ERROR
    return str
end

''' % (getCodeTypeDes(codeType), \
    QQ_APP[0], QQ_APP[1], QQ_APP[2], QQ_APP[3], \
    LEAN_CLOUD_TEST[2], LEAN_CLOUD_TEST[0], LEAN_CLOUD_TEST[1], LEAN_CLOUD_RELEASE[2], LEAN_CLOUD_RELEASE[0], LEAN_CLOUD_RELEASE[1], \
    codeType, appVersionInfo, appVersionInfo, getCodeTypeDes(codeType))

    appVersionInfoLuaFile = open(fullpathLua, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportObjc(codeType, appVersionInfo, fullpath):
    isProduction = 'NO'
    if codeType == BUILD_TARGET_RELEASE:
        isProduction = 'YES'

    appVersionInfoLua = '''
// %s
// server: %s

#define INIT_APP \\
    [AVOSCloud setApplicationId:@"%s" \\
                      clientKey:@"%s"]; \\
    [AVCloud setProductionMode:%s];\\
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];\\
    \\
    [WXApi registerApp:@"%s"]; //TODO

''' % (getCodeTypeDes(codeType), getLeanCloudAppName(codeType), getLeanCloudAppId(codeType), getLeanCloudAppKey(codeType), isProduction, WEIXIN_APP[1])

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportJava(codeType, appVersionInfo, fullpath):
    macro_type = getCodeTypeDes(codeType)
    lean_cloud_id = getLeanCloudAppId(codeType)
    lean_cloud_key = getLeanCloudAppKey(codeType)
    umeng_app_key = UMENG_APP[0]
    umeng_app_channel = UMENG_APP[1]

    isDebugLogEnabled = 'true'
    isProduction = 'false'
    if codeType == BUILD_TARGET_RELEASE:
        isDebugLogEnabled = 'false'
        isProduction = 'true'

    appVersionInfoLua = '''
// ----------
// %s
// ----------
package c.bb.dc;

import android.app.Activity;

import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVOSCloud;
import com.umeng.analytics.AnalyticsConfig;
import com.tencent.mm.sdk.openapi.WXTextObject;

public class AppVersionInfo {
    private static final String WEIXIN_APP_ID = "%s"; //TODO
    private IWXAPI api;

    public static void initServer(Activity a) {
        // server: %s
        AVOSCloud.initialize(a, "%s", "%s");
        AVOSCloud.setDebugLogEnabled(%s);
        AVCloud.setProductionMode(%s);

        AnalyticsConfig.setAppkey("%s");
        AnalyticsConfig.setChannel("%s");

        api = WXAPIFactory.createWXAPI(a, WEIXIN_APP_ID, true);
        api.registerApp(WEIXIN_APP_ID);
    }
}
''' % (macro_type, WEIXIN_APP[1], getLeanCloudAppName(codeType), lean_cloud_id, lean_cloud_key, isDebugLogEnabled, isProduction, umeng_app_key, umeng_app_channel)

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def export(codeType, appVersionInfo, fullpathLua, fullpathObjc, fullpathJava):
    exportLua(codeType, appVersionInfo, fullpathLua)
    exportObjc(codeType, appVersionInfo, fullpathObjc)
    exportJava(codeType, appVersionInfo, fullpathJava)
    pass
                
if __name__ == "__main__":
    if len(sys.argv) > 6:
        # channelName, channelConfigs, androidManifest, androidManifestTarget, channelConfigsDir, AppActivityJava, javaSrcDir
        init(sys.argv[6], sys.argv[7], sys.argv[8], sys.argv[9], sys.argv[10], sys.argv[11], sys.argv[12])
    export(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

# channelConfigs = '/Users/bmo/Dev/YiSiYiDian/BeiBeiDanCiX/tools/channel_configs/configs.json'
# configs = open(channelConfigs).read()
# jsonStr = json.loads(configs)
# channels = jsonStr['channels'][0]['umengAppName']
# print str(json.dumps(channels, ensure_ascii=False, indent=4).encode('utf8'))

