baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos run \
    -p ios \
    -j 4 \
    --lua-encrypt --lua-encrypt-key "fuck2dxLua" --lua-encrypt-sign "fuckXXTEA" \
    --sign-identity "com.beibei.wordmaster"


# xcrun   -sdk iphoneos PackageApplication \
#         -v ${baseDirForScriptSelf}/../BeiBei2DXLua/runtime/ios/BeiBei2DXLua.app \
#         -o ${baseDirForScriptSelf}/../BeiBei2DXLua/runtime/ios/BeiBei2DXLua.ipa