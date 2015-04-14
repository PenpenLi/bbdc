#include "lua_cx_common.hpp"
#include "CXAvos.h"
#include "CXAnalytics.h"
#include "CXUtils.h"
#include "CXStore.h"
#include "CXProgressHUD.h"
#include "CXNetworkStatus.h"
#include "CXAVCloud.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cx_common_CXAvos_logInByQQAuthData(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logInByQQAuthData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        CXLUAFUNC arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:logInByQQAuthData"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:logInByQQAuthData"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:logInByQQAuthData"); arg2 = arg2_tmp.c_str();

        arg3 = (  toluafix_ref_function(tolua_S,5,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logInByQQAuthData'", nullptr);
            return 0;
        }
        cobj->logInByQQAuthData(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logInByQQAuthData",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logInByQQAuthData'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        bool arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_dl"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_dl"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:invokeLuaCallbackFunction_dl"); arg2 = arg2_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "CXAvos:invokeLuaCallbackFunction_dl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_dl(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_dl",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_su(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_su'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        int arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_su"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_su"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CXAvos:invokeLuaCallbackFunction_su");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_su'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_su(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_su",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_su'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_signUp(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_signUp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:signUp"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:signUp"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_signUp'", nullptr);
            return 0;
        }
        cobj->signUp(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:signUp",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_signUp'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_downloadFile(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_downloadFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:downloadFile"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:downloadFile"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_downloadFile'", nullptr);
            return 0;
        }
        cobj->downloadFile(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:downloadFile",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_logInByQQ(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logInByQQ'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        CXLUAFUNC arg0;

        arg0 = (  toluafix_ref_function(tolua_S,2,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logInByQQ'", nullptr);
            return 0;
        }
        cobj->logInByQQ(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logInByQQ",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logInByQQ'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_downloadWordSoundFiles(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_downloadWordSoundFiles'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:downloadWordSoundFiles"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:downloadWordSoundFiles"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:downloadWordSoundFiles"); arg2 = arg2_tmp.c_str();

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "CXAvos:downloadWordSoundFiles"); arg3 = arg3_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_downloadWordSoundFiles'", nullptr);
            return 0;
        }
        cobj->downloadWordSoundFiles(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:downloadWordSoundFiles",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadWordSoundFiles'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_downloadConfigFiles(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_downloadConfigFiles'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:downloadConfigFiles"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:downloadConfigFiles"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_downloadConfigFiles'", nullptr);
            return 0;
        }
        cobj->downloadConfigFiles(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:downloadConfigFiles",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadConfigFiles'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_logOut(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logOut'", nullptr);
            return 0;
        }
        cobj->logOut();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logOut",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_logIn(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logIn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:logIn"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:logIn"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logIn'", nullptr);
            return 0;
        }
        cobj->logIn(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logIn",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logIn'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_li(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        int arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_li"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_li"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CXAvos:invokeLuaCallbackFunction_li");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_li(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_li",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 5) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;
        int arg4;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg2 = arg2_tmp.c_str();

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg3 = arg3_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "CXAvos:invokeLuaCallbackFunction_logInByQQ");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_logInByQQ(arg0, arg1, arg2, arg3, arg4);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_logInByQQ",argc, 5);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_initTencentQQ(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_initTencentQQ'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:initTencentQQ"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:initTencentQQ"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_initTencentQQ'", nullptr);
            return 0;
        }
        cobj->initTencentQQ(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:initTencentQQ",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_initTencentQQ'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_getInstance'", nullptr);
            return 0;
        }
        CXAvos* ret = CXAvos::getInstance();
        object_to_luaval<CXAvos>(tolua_S, "CXAvos",(CXAvos*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAvos:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXAvos_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXAvos)");
    return 0;
}

int lua_register_cx_common_CXAvos(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXAvos");
    tolua_cclass(tolua_S,"CXAvos","CXAvos","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXAvos");
        tolua_function(tolua_S,"logInByQQAuthData",lua_cx_common_CXAvos_logInByQQAuthData);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_dl",lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_su",lua_cx_common_CXAvos_invokeLuaCallbackFunction_su);
        tolua_function(tolua_S,"signUp",lua_cx_common_CXAvos_signUp);
        tolua_function(tolua_S,"downloadFile",lua_cx_common_CXAvos_downloadFile);
        tolua_function(tolua_S,"logInByQQ",lua_cx_common_CXAvos_logInByQQ);
        tolua_function(tolua_S,"downloadWordSoundFiles",lua_cx_common_CXAvos_downloadWordSoundFiles);
        tolua_function(tolua_S,"downloadConfigFiles",lua_cx_common_CXAvos_downloadConfigFiles);
        tolua_function(tolua_S,"logOut",lua_cx_common_CXAvos_logOut);
        tolua_function(tolua_S,"logIn",lua_cx_common_CXAvos_logIn);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_li",lua_cx_common_CXAvos_invokeLuaCallbackFunction_li);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_logInByQQ",lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ);
        tolua_function(tolua_S,"initTencentQQ",lua_cx_common_CXAvos_initTencentQQ);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXAvos_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXAvos).name();
    g_luaType[typeName] = "CXAvos";
    g_typeCast["CXAvos"] = "CXAvos";
    return 1;
}

int lua_cx_common_CXAnalytics_logUsingTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        const char* arg0;
        const char* arg1;
        int arg2;
        int arg3;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:logUsingTime"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAnalytics:logUsingTime"); arg1 = arg1_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CXAnalytics:logUsingTime");
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "CXAnalytics:logUsingTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_logUsingTime'", nullptr);
            return 0;
        }
        CXAnalytics::logUsingTime(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:logUsingTime",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_logUsingTime'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXAnalytics_beginLog(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:beginLog"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_beginLog'", nullptr);
            return 0;
        }
        CXAnalytics::beginLog(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:beginLog",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_beginLog'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXAnalytics_endLog(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:endLog"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_endLog'", nullptr);
            return 0;
        }
        CXAnalytics::endLog(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:endLog",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_endLog'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXAnalytics_logEventAndLabel(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:logEventAndLabel"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAnalytics:logEventAndLabel"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_logEventAndLabel'", nullptr);
            return 0;
        }
        CXAnalytics::logEventAndLabel(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:logEventAndLabel",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_logEventAndLabel'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXAnalytics_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXAnalytics)");
    return 0;
}

int lua_register_cx_common_CXAnalytics(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXAnalytics");
    tolua_cclass(tolua_S,"CXAnalytics","CXAnalytics","",nullptr);

    tolua_beginmodule(tolua_S,"CXAnalytics");
        tolua_function(tolua_S,"logUsingTime", lua_cx_common_CXAnalytics_logUsingTime);
        tolua_function(tolua_S,"beginLog", lua_cx_common_CXAnalytics_beginLog);
        tolua_function(tolua_S,"endLog", lua_cx_common_CXAnalytics_endLog);
        tolua_function(tolua_S,"logEventAndLabel", lua_cx_common_CXAnalytics_logEventAndLabel);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXAnalytics).name();
    g_luaType[typeName] = "CXAnalytics";
    g_typeCast["CXAnalytics"] = "CXAnalytics";
    return 1;
}

int lua_cx_common_CXUtils_decryptXxteaFile(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_decryptXxteaFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:decryptXxteaFile"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_decryptXxteaFile'", nullptr);
            return 0;
        }
        const char* ret = cobj->decryptXxteaFile(arg0);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:decryptXxteaFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_decryptXxteaFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_shareImageToWeiXin(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_shareImageToWeiXin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CXUtils:shareImageToWeiXin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CXUtils:shareImageToWeiXin");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CXUtils:shareImageToWeiXin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_shareImageToWeiXin'", nullptr);
            return 0;
        }
        cobj->shareImageToWeiXin(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:shareImageToWeiXin",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_shareImageToWeiXin'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_compressAndBase64EncodeString(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_compressAndBase64EncodeString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CXUtils:compressAndBase64EncodeString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_compressAndBase64EncodeString'", nullptr);
            return 0;
        }
        std::string ret = cobj->compressAndBase64EncodeString(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:compressAndBase64EncodeString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_compressAndBase64EncodeString'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_base64DecodeAndDecompressString(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_base64DecodeAndDecompressString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CXUtils:base64DecodeAndDecompressString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_base64DecodeAndDecompressString'", nullptr);
            return 0;
        }
        std::string ret = cobj->base64DecodeAndDecompressString(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:base64DecodeAndDecompressString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_base64DecodeAndDecompressString'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_addImageToGallery(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_addImageToGallery'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CXUtils:addImageToGallery");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_addImageToGallery'", nullptr);
            return 0;
        }
        cobj->addImageToGallery(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:addImageToGallery",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_addImageToGallery'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_shutDownApp(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_shutDownApp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_shutDownApp'", nullptr);
            return 0;
        }
        cobj->shutDownApp();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:shutDownApp",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_shutDownApp'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils__testCppApi_(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils__testCppApi_'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils__testCppApi_'", nullptr);
            return 0;
        }
        cobj->_testCppApi_();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:_testCppApi_",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils__testCppApi_'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_shareImageToQQFriend(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_shareImageToQQFriend'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CXUtils:shareImageToQQFriend");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CXUtils:shareImageToQQFriend");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CXUtils:shareImageToQQFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_shareImageToQQFriend'", nullptr);
            return 0;
        }
        cobj->shareImageToQQFriend(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:shareImageToQQFriend",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_shareImageToQQFriend'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_download(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_download'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:download"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXUtils:download"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXUtils:download"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_download'", nullptr);
            return 0;
        }
        cobj->download(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:download",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_download'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_showMail(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:showMail"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXUtils:showMail"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_showMail'", nullptr);
            return 0;
        }
        CXUtils::showMail(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXUtils:showMail",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_showMail'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXUtils_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_getInstance'", nullptr);
            return 0;
        }
        CXUtils* ret = CXUtils::getInstance();
        object_to_luaval<CXUtils>(tolua_S, "CXUtils",(CXUtils*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXUtils:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXUtils_md5(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        std::string arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:md5"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CXUtils:md5");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_md5'", nullptr);
            return 0;
        }
        std::string& ret = CXUtils::md5(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXUtils:md5",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_md5'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXUtils_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXUtils)");
    return 0;
}

int lua_register_cx_common_CXUtils(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXUtils");
    tolua_cclass(tolua_S,"CXUtils","CXUtils","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXUtils");
        tolua_function(tolua_S,"decryptXxteaFile",lua_cx_common_CXUtils_decryptXxteaFile);
        tolua_function(tolua_S,"shareImageToWeiXin",lua_cx_common_CXUtils_shareImageToWeiXin);
        tolua_function(tolua_S,"compressAndBase64EncodeString",lua_cx_common_CXUtils_compressAndBase64EncodeString);
        tolua_function(tolua_S,"base64DecodeAndDecompressString",lua_cx_common_CXUtils_base64DecodeAndDecompressString);
        tolua_function(tolua_S,"addImageToGallery",lua_cx_common_CXUtils_addImageToGallery);
        tolua_function(tolua_S,"shutDownApp",lua_cx_common_CXUtils_shutDownApp);
        tolua_function(tolua_S,"_testCppApi_",lua_cx_common_CXUtils__testCppApi_);
        tolua_function(tolua_S,"shareImageToQQFriend",lua_cx_common_CXUtils_shareImageToQQFriend);
        tolua_function(tolua_S,"download",lua_cx_common_CXUtils_download);
        tolua_function(tolua_S,"showMail", lua_cx_common_CXUtils_showMail);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXUtils_getInstance);
        tolua_function(tolua_S,"md5", lua_cx_common_CXUtils_md5);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXUtils).name();
    g_luaType[typeName] = "CXUtils";
    g_typeCast["CXUtils"] = "CXUtils";
    return 1;
}

int lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        const char* arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CXStore:invokeLuaCallbackFunction_requestProducts");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXStore:invokeLuaCallbackFunction_requestProducts"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_requestProducts(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:invokeLuaCallbackFunction_requestProducts",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_payForProduct(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_payForProduct'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        CXLUAFUNC arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXStore:payForProduct"); arg0 = arg0_tmp.c_str();

        arg1 = (  toluafix_ref_function(tolua_S,3,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_payForProduct'", nullptr);
            return 0;
        }
        cobj->payForProduct(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:payForProduct",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_payForProduct'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_requestProducts(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_requestProducts'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        CXLUAFUNC arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXStore:requestProducts"); arg0 = arg0_tmp.c_str();

        arg1 = (  toluafix_ref_function(tolua_S,3,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_requestProducts'", nullptr);
            return 0;
        }
        cobj->requestProducts(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:requestProducts",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_requestProducts'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        const char* arg1;
        const char* arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CXStore:invokeLuaCallbackFunction_payForProduct");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXStore:invokeLuaCallbackFunction_payForProduct"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXStore:invokeLuaCallbackFunction_payForProduct"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_payForProduct(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:invokeLuaCallbackFunction_payForProduct",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_getInstance'", nullptr);
            return 0;
        }
        CXStore* ret = CXStore::getInstance();
        object_to_luaval<CXStore>(tolua_S, "CXStore",(CXStore*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXStore:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXStore_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXStore)");
    return 0;
}

int lua_register_cx_common_CXStore(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXStore");
    tolua_cclass(tolua_S,"CXStore","CXStore","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXStore");
        tolua_function(tolua_S,"invokeLuaCallbackFunction_requestProducts",lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts);
        tolua_function(tolua_S,"payForProduct",lua_cx_common_CXStore_payForProduct);
        tolua_function(tolua_S,"requestProducts",lua_cx_common_CXStore_requestProducts);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_payForProduct",lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXStore_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXStore).name();
    g_luaType[typeName] = "CXStore";
    g_typeCast["CXStore"] = "CXStore";
    return 1;
}

int lua_cx_common_CXProgressHUD_hide(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXProgressHUD",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXProgressHUD_hide'", nullptr);
            return 0;
        }
        CXProgressHUD::hide();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXProgressHUD:hide",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXProgressHUD_hide'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXProgressHUD_setupWindow(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXProgressHUD",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        void* arg0;
        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXProgressHUD_setupWindow'", nullptr);
            return 0;
        }
        CXProgressHUD::setupWindow(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXProgressHUD:setupWindow",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXProgressHUD_setupWindow'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXProgressHUD_show(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXProgressHUD",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXProgressHUD:show"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXProgressHUD_show'", nullptr);
            return 0;
        }
        CXProgressHUD::show(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXProgressHUD:show",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXProgressHUD_show'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXProgressHUD_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXProgressHUD)");
    return 0;
}

int lua_register_cx_common_CXProgressHUD(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXProgressHUD");
    tolua_cclass(tolua_S,"CXProgressHUD","CXProgressHUD","",nullptr);

    tolua_beginmodule(tolua_S,"CXProgressHUD");
        tolua_function(tolua_S,"hide", lua_cx_common_CXProgressHUD_hide);
        tolua_function(tolua_S,"setupWindow", lua_cx_common_CXProgressHUD_setupWindow);
        tolua_function(tolua_S,"show", lua_cx_common_CXProgressHUD_show);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXProgressHUD).name();
    g_luaType[typeName] = "CXProgressHUD";
    g_typeCast["CXProgressHUD"] = "CXProgressHUD";
    return 1;
}

int lua_cx_common_CXNetworkStatus_start(lua_State* tolua_S)
{
    int argc = 0;
    CXNetworkStatus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXNetworkStatus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXNetworkStatus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXNetworkStatus_start'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXNetworkStatus_start'", nullptr);
            return 0;
        }
        int ret = cobj->start();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXNetworkStatus:start",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXNetworkStatus_start'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXNetworkStatus_getStatus(lua_State* tolua_S)
{
    int argc = 0;
    CXNetworkStatus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXNetworkStatus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXNetworkStatus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXNetworkStatus_getStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXNetworkStatus_getStatus'", nullptr);
            return 0;
        }
        int ret = cobj->getStatus();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXNetworkStatus:getStatus",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXNetworkStatus_getStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXNetworkStatus_getDeviceUDID(lua_State* tolua_S)
{
    int argc = 0;
    CXNetworkStatus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXNetworkStatus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXNetworkStatus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXNetworkStatus_getDeviceUDID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXNetworkStatus_getDeviceUDID'", nullptr);
            return 0;
        }
        const char* ret = cobj->getDeviceUDID();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXNetworkStatus:getDeviceUDID",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXNetworkStatus_getDeviceUDID'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXNetworkStatus_getCurrentTimeMillis(lua_State* tolua_S)
{
    int argc = 0;
    CXNetworkStatus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXNetworkStatus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXNetworkStatus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXNetworkStatus_getCurrentTimeMillis'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXNetworkStatus_getCurrentTimeMillis'", nullptr);
            return 0;
        }
        long ret = cobj->getCurrentTimeMillis();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXNetworkStatus:getCurrentTimeMillis",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXNetworkStatus_getCurrentTimeMillis'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXNetworkStatus_setStatus(lua_State* tolua_S)
{
    int argc = 0;
    CXNetworkStatus* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXNetworkStatus",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXNetworkStatus*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXNetworkStatus_setStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CXNetworkStatus:setStatus");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXNetworkStatus_setStatus'", nullptr);
            return 0;
        }
        cobj->setStatus(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXNetworkStatus:setStatus",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXNetworkStatus_setStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXNetworkStatus_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXNetworkStatus",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXNetworkStatus_getInstance'", nullptr);
            return 0;
        }
        CXNetworkStatus* ret = CXNetworkStatus::getInstance();
        object_to_luaval<CXNetworkStatus>(tolua_S, "CXNetworkStatus",(CXNetworkStatus*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXNetworkStatus:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXNetworkStatus_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXNetworkStatus_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXNetworkStatus)");
    return 0;
}

int lua_register_cx_common_CXNetworkStatus(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXNetworkStatus");
    tolua_cclass(tolua_S,"CXNetworkStatus","CXNetworkStatus","",nullptr);

    tolua_beginmodule(tolua_S,"CXNetworkStatus");
        tolua_function(tolua_S,"start",lua_cx_common_CXNetworkStatus_start);
        tolua_function(tolua_S,"getStatus",lua_cx_common_CXNetworkStatus_getStatus);
        tolua_function(tolua_S,"getDeviceUDID",lua_cx_common_CXNetworkStatus_getDeviceUDID);
        tolua_function(tolua_S,"getCurrentTimeMillis",lua_cx_common_CXNetworkStatus_getCurrentTimeMillis);
        tolua_function(tolua_S,"setStatus",lua_cx_common_CXNetworkStatus_setStatus);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXNetworkStatus_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXNetworkStatus).name();
    g_luaType[typeName] = "CXNetworkStatus";
    g_typeCast["CXNetworkStatus"] = "CXNetworkStatus";
    return 1;
}

int lua_cx_common_CXAVCloud_callAVCloudFunction(lua_State* tolua_S)
{
    int argc = 0;
    CXAVCloud* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAVCloud",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAVCloud*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAVCloud_callAVCloudFunction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        CXLUAFUNC arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CXAVCloud:callAVCloudFunction");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CXAVCloud:callAVCloudFunction");

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAVCloud_callAVCloudFunction'", nullptr);
            return 0;
        }
        cobj->callAVCloudFunction(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAVCloud:callAVCloudFunction",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAVCloud_callAVCloudFunction'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAVCloud_invokeCallback(lua_State* tolua_S)
{
    int argc = 0;
    CXAVCloud* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAVCloud",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAVCloud*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAVCloud_invokeCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAVCloud:invokeCallback"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAVCloud:invokeCallback"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAVCloud_invokeCallback'", nullptr);
            return 0;
        }
        cobj->invokeCallback(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAVCloud:invokeCallback",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAVCloud_invokeCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAVCloud_invokeCallback_getBulletinBoard(lua_State* tolua_S)
{
    int argc = 0;
    CXAVCloud* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAVCloud",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAVCloud*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAVCloud_invokeCallback_getBulletinBoard'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        int arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CXAVCloud:invokeCallback_getBulletinBoard");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAVCloud:invokeCallback_getBulletinBoard"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAVCloud:invokeCallback_getBulletinBoard"); arg2 = arg2_tmp.c_str();

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "CXAVCloud:invokeCallback_getBulletinBoard"); arg3 = arg3_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAVCloud_invokeCallback_getBulletinBoard'", nullptr);
            return 0;
        }
        cobj->invokeCallback_getBulletinBoard(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAVCloud:invokeCallback_getBulletinBoard",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAVCloud_invokeCallback_getBulletinBoard'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAVCloud_getBulletinBoard(lua_State* tolua_S)
{
    int argc = 0;
    CXAVCloud* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAVCloud",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAVCloud*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAVCloud_getBulletinBoard'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        CXLUAFUNC arg0;

        arg0 = (  toluafix_ref_function(tolua_S,2,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAVCloud_getBulletinBoard'", nullptr);
            return 0;
        }
        cobj->getBulletinBoard(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAVCloud:getBulletinBoard",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAVCloud_getBulletinBoard'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAVCloud_searchUser(lua_State* tolua_S)
{
    int argc = 0;
    CXAVCloud* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAVCloud",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAVCloud*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAVCloud_searchUser'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAVCloud:searchUser"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAVCloud:searchUser"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAVCloud_searchUser'", nullptr);
            return 0;
        }
        cobj->searchUser(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAVCloud:searchUser",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAVCloud_searchUser'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAVCloud_constructor(lua_State* tolua_S)
{
    int argc = 0;
    CXAVCloud* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAVCloud_constructor'", nullptr);
            return 0;
        }
        cobj = new CXAVCloud();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"CXAVCloud");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAVCloud:CXAVCloud",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAVCloud_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cx_common_CXAVCloud_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXAVCloud)");
    return 0;
}

int lua_register_cx_common_CXAVCloud(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXAVCloud");
    tolua_cclass(tolua_S,"CXAVCloud","CXAVCloud","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXAVCloud");
        tolua_function(tolua_S,"new",lua_cx_common_CXAVCloud_constructor);
        tolua_function(tolua_S,"callAVCloudFunction",lua_cx_common_CXAVCloud_callAVCloudFunction);
        tolua_function(tolua_S,"invokeCallback",lua_cx_common_CXAVCloud_invokeCallback);
        tolua_function(tolua_S,"invokeCallback_getBulletinBoard",lua_cx_common_CXAVCloud_invokeCallback_getBulletinBoard);
        tolua_function(tolua_S,"getBulletinBoard",lua_cx_common_CXAVCloud_getBulletinBoard);
        tolua_function(tolua_S,"searchUser",lua_cx_common_CXAVCloud_searchUser);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXAVCloud).name();
    g_luaType[typeName] = "CXAVCloud";
    g_typeCast["CXAVCloud"] = "CXAVCloud";
    return 1;
}
TOLUA_API int register_all_cx_common(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cx",0);
	tolua_beginmodule(tolua_S,"cx");

	lua_register_cx_common_CXNetworkStatus(tolua_S);
	lua_register_cx_common_CXUtils(tolua_S);
	lua_register_cx_common_CXAVCloud(tolua_S);
	lua_register_cx_common_CXAnalytics(tolua_S);
	lua_register_cx_common_CXProgressHUD(tolua_S);
	lua_register_cx_common_CXStore(tolua_S);
	lua_register_cx_common_CXAvos(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

