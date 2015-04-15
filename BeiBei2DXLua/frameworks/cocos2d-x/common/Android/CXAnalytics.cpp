//
//  CXAnalytics.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAnalytics.h"
#include "platform/android/jni/JniHelper.h"

void CXAnalytics::beginLog(const char* pageName) {

}

void CXAnalytics::endLog(const char* pageName) {

}

void CXAnalytics::logEventAndLabel(const char* event, const char* tag) {
    if (!event || !tag) 
        return;

    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "c/bb/dc/BBNDK", "onEvent", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArgEvent = t.env->NewStringUTF(event);
        jstring stringArgTag = t.env->NewStringUTF(tag);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArgEvent, stringArgTag);

        t.env->DeleteLocalRef(stringArgEvent);
        t.env->DeleteLocalRef(stringArgTag);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAnalytics::logUsingTime(const char* userId, const char* bookKey, int startTime, int usingTime) {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "c/bb/dc/BBNDK", "logUsingTime", "(Ljava/lang/String;Ljava/lang/String;II)V")) {
        jstring stringArgEvent = t.env->NewStringUTF(userId);
        jstring stringArgTag = t.env->NewStringUTF(bookKey);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArgEvent, stringArgTag, startTime, usingTime);

        t.env->DeleteLocalRef(stringArgEvent);
        t.env->DeleteLocalRef(stringArgTag);
        t.env->DeleteLocalRef(t.classID);
    }
}