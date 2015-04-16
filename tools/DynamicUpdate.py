#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import zipfile
import shutil
import hashlib

def deleteUselessFiles(src):
    for parent, dirnames, filenames in os.walk(src):
        for filename in filenames:
            if filename.find('.DS_Store') >= 0:
                os.remove(os.path.join(parent, filename))

def getMD5(file_name):
    # Open,close, read file and calculate MD5 on its contents 
    with open(file_name) as file_to_check:
        # read contents of the file
        data = file_to_check.read()    
        # pipe contents of the file through
        md5_returned = hashlib.md5(data).hexdigest()

        return md5_returned

def zipFolder(path, folder):
    zipname = path + folder + '.zip'
    with zipfile.ZipFile(zipname, 'w') as myzip:
        myzip.write(path + folder, folder, zipfile.ZIP_DEFLATED)
        for parent, dirnames, filenames in os.walk(path + folder):
            myzip.write(parent, parent.replace(path, ''), zipfile.ZIP_DEFLATED)
            for filename in filenames:
                fullPath = os.path.join(parent, filename)
                if fullPath.find('model/words') < 0:
                    myzip.write(fullPath, fullPath.replace(path, ''), zipfile.ZIP_DEFLATED)

        return zipname

def getAssetsMD5(folderName, src, dst):
    deleteUselessFiles(src)

    if os.path.exists(dst):
        shutil.rmtree(dst)
    os.makedirs(dst)

    retList = []
    for name in os.listdir(src):
        if name.find('.luac') > 0:
            md5 = getMD5(src + name)
            shutil.copy(src + name, dst)
            c = '''
        "ServerAssets/%s/%s" : 
        {
            "md5" : "%s",
            "compressed" : false
        }
            ''' % (folderName, name, md5)
            retList.append( c )
        elif os.path.isdir(src + name):
            zipname = zipFolder(src, name)
            md5 = getMD5(zipname)
            shutil.move(zipname, dst)
            c = '''
        "ServerAssets/%s/%s" : 
        {
            "md5" : "%s",
            "compressed" : true
        }
            ''' % (folderName, name + '.zip', md5)
            retList.append( c )
    return retList

def exportAssets(isDebug, assetsPath, tmp_assetPath, AssetsManagerReleaseFolder, version, engineVersion, manifestFilePath, manifestVersionFilePath):
    versionDebug = '''
    { 
        "packageUrl" : "http://123.56.84.196/AssetsManagerDebug/",
        "remoteManifestUrl" : "http://123.56.84.196/AssetsManagerDebug/project_server_debug.manifest", 
        "remoteVersionUrl" : "http://123.56.84.196/AssetsManagerDebug/version_debug.manifest", 
        "version" : "%s", 
        "engineVersion" : "%s" 
    ''' % (version, engineVersion)
    versionRelease = '''
    { 
        "packageUrl" : "http://123.56.84.196/AssetsManagerDebug/%s",
        "remoteManifestUrl" : "http://123.56.84.196/AssetsManagerDebug/%s/project_server_debug.manifest", 
        "remoteVersionUrl" : "http://123.56.84.196/AssetsManagerDebug/%s/version_debug.manifest", 
        "version" : "%s", 
        "engineVersion" : "%s"
    ''' % (AssetsManagerReleaseFolder, AssetsManagerReleaseFolder, AssetsManagerReleaseFolder, version, engineVersion)

    headDebug = '''
        %s, 
        "assets" : {    
    ''' % (versionDebug, )
    headRelease = '''
        %s, 
        "assets" : {    
    ''' % (versionRelease, )

    end = '''
        }, 

        "searchPaths" : [
        
        ] 
    }
    '''

    versionContent = versionRelease + '\n}'
    mContent = headRelease
    if isDebug:
        versionContent = versionDebug + '\n}'
        mContent = headDebug

    if os.path.exists(tmp_assetPath):
        shutil.rmtree(tmp_assetPath)
    os.makedirs(tmp_assetPath)

    src = getAssetsMD5('src', assetsPath + 'src/', tmp_assetPath + 'src/')
    i = 0
    for c in src:
        if i > 0:
            mContent = mContent + ',\n' + c
        else:
            mContent = mContent + '\n' + c
            i = 1

    res = getAssetsMD5('res', assetsPath + 'res/', tmp_assetPath + 'res/')
    for c in res:
        if i > 0:
            mContent = mContent + ',\n' + c
        else:
            mContent = mContent + '\n' + c
            i = 1

    mContent = mContent + end

    manifestFile = open(manifestFilePath, "w")
    manifestFile.write(mContent)
    manifestFile.close()

    manifestFile = open(manifestVersionFilePath, "w")
    manifestFile.write(versionContent)
    manifestFile.close()

# --------------------------------------------------------------------------------

assetsPath = os.getcwd() + '/../BeiBei2DXLua/frameworks/runtime-src/proj.android/assets/'
AssetsManagerReleaseFolder = '2.0.8'
version = '2.0.8.0.0.0'
engineVersion = '3.3 rc2'

tmp_assetPath = os.getcwd() + '/../tmp_asset/debug/'
manifestDebugFilePath = tmp_assetPath + 'project_server_debug.manifest'
manifestVersionDebugFilePath = tmp_assetPath + 'version_debug.manifest'
exportAssets(True, assetsPath, tmp_assetPath, AssetsManagerReleaseFolder, version, engineVersion, manifestDebugFilePath, manifestVersionDebugFilePath)

tmp_assetPath = os.getcwd() + '/../tmp_asset/release/'
manifestReleaseFilePath = tmp_assetPath + 'project_server_release.manifest'
manifestVersionReleaseFilePath = tmp_assetPath + 'version_release.manifest'
exportAssets(False, assetsPath, tmp_assetPath, AssetsManagerReleaseFolder, version, engineVersion, manifestReleaseFilePath, manifestVersionReleaseFilePath)
