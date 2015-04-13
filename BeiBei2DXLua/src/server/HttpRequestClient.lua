local HttpRequestClient = {}

---------------------------------------------------------------------------------------------------------------------

-- callbackFunc: function (index, title, content)
function HttpRequestClient.getBulletinBoard(callbackFunc)
    local request = cx.CXAVCloud:new()
    request:getBulletinBoard(function (index, content_top, content, errorjson)
        print('getBulletinBoard', index, content_top, content)
        if callbackFunc ~= nil then callbackFunc(index, content_top, content) end
    end)
    -- local retIdx = -1
    -- local retTitle = ''
    -- local retContent = ''
    -- local onSucceed = function (api, result)
    --     if result.results ~= nil and type(result.results) == 'table' then
    --         for i, v in ipairs(result.results) do
    --             local idx = v["index"]
    --             local t = v["content_top"]
    --             local ct = v["content"]
    --             if idx > retIdx then
    --                 retIdx = idx
    --                 retTitle = t
    --                 retContent = ct
    --             end
    --         end
    --     else
    --         LUA_ERROR = LUA_ERROR .. 'getBulletinBoard:' .. tostring(result.results) .. '\n'
    --     end
    --     if callbackFunc ~= nil then callbackFunc(retIdx, retTitle, retContent) end
    -- end
    -- local onFailed = function (api, code, message, description)
    --     if callbackFunc ~= nil then callbackFunc(retIdx, retTitle, retContent) end
    -- end
    -- if s_SERVER.isNetworkConnectedNow() then
    --     s_SERVER.search('classes/DataBulletinBoard', onSucceed, onFailed)
    -- else
    --     onFailed()
    -- end
end

---------------------------------------------------------------------------------------------------------------------

-- test: '5430b806e4b0c0d48049e293'
-- onDownloaded: function (objectId, filename, err, isSaved)
function HttpRequestClient.downloadFileFromAVOSWithObjectId(fileObjectId, onDownloaded)
    print ('downloadFileFromAVOSWithObjectId:', fileObjectId)
    cx.CXAvos:getInstance():downloadFile(fileObjectId, cc.FileUtils:getInstance():getWritablePath(), 
        function (objectId, filename, err, isSaved)
            print('objectId:' .. fileObjectId .. ', filename:' .. cc.FileUtils:getInstance():getWritablePath() .. filename .. ', error:' .. tostring(err) .. ', isSaved:' .. tostring(isSaved))
            if onDownloaded ~= nil then onDownloaded(objectId, filename, err, isSaved) end
    end)
end

--[[
    s_HttpRequestClient.downloadWordSoundFile('great', function (objectId, filename, err, isSaved) 
        print(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
    end)
]]--
local function getWordObject(word, onSucceed, onFailed)
    local sql = 'classes/_File?where={"name":"' .. getWordSoundFileName(word) .. '"}'
    if s_SERVER.isNetworkConnectedNow() then
        s_SERVER.search(sql, onSucceed, onFailed)
    else
        onFailed(sql, -1, '', '')
    end
end
function HttpRequestClient.downloadWordSoundFile(word, onDownloaded)
    local localPath = getWordSoundFilePath(word)
    print('downloadWordSoundFile:' .. localPath)
    if localPath == nil or string.len(localPath) <= 0 or cc.FileUtils:getInstance():isFileExist(localPath) then
        if onDownloaded ~= nil then onDownloaded(nil, localPath, nil, true) end
    else
        getWordObject(word, 
            function (api, result)
                local len = #(result.results)
                if len <= 0 then 
                    if onDownloaded ~= nil then onDownloaded(nil, localPath, 'not found', false) end
                else
                    for i, v in ipairs(result.results) do
                        local objectId = v['objectId']
                        HttpRequestClient.downloadFileFromAVOSWithObjectId(objectId, 
                            function (objectId, filename, err, isSaved)
                                if onDownloaded ~= nil then onDownloaded(objectId, filename, err, isSaved) end                
                            end)
                        break
                    end
                end
            end,
            function (api, code, message, description)
                if onDownloaded ~= nil then onDownloaded(nil, localPath, message, false) end
            end)
    end
end

function HttpRequestClient.downloadSoundsOfLevel(levelKey, idOffset, prefix)
    local nextLevelKey = string.sub(levelKey, 1, 5) .. tostring(string.sub(levelKey, 6) + idOffset)
    print(string.format('downloadSoundsOfNext5thLevel: %s, %s, %s', s_CURRENT_USER.bookKey, s_CURRENT_USER.currentChapterKey, nextLevelKey))
    local nextLevelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey, s_CURRENT_USER.currentChapterKey, nextLevelKey)
    if nextLevelConfig == nil or string.len(nextLevelConfig.word_content) <= 0 then
        return
    end

    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        if s_SERVER.isNetworkConnectedNow() then
            cx.CXAvos:getInstance():downloadWordSoundFiles(
                prefix .. '_', 
                nextLevelConfig.word_content, 
                '.mp3', 
                cc.FileUtils:getInstance():getWritablePath())
        end
    else
        local wordList = split(nextLevelConfig.word_content, "|")
        local index = 1
        local total = #wordList
        if total > 0 then
            local downloadFunc
            downloadFunc = function ()
                s_HttpRequestClient.downloadWordSoundFile(wordList[index], function (objectId, filename, err, isSaved) 
                    print(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
                    index = index + 1
                    if index <= total then downloadFunc() end 
                end)
            end

            downloadFunc(handleFunc)
        end
    end
end

function HttpRequestClient.downloadSoundsFromURL(currentIndex)
    if s_BookWord == nil 
        or s_CURRENT_USER == nil 
        or s_CURRENT_USER.bookKey == nil 
        or string.len(s_CURRENT_USER.bookKey) <= 0 
        or s_BookWord[s_CURRENT_USER.bookKey] == nil 
        or currentIndex > #s_BookWord[s_CURRENT_USER.bookKey] then
        return
    end

    local length = #s_BookWord[s_CURRENT_USER.bookKey]
    local i = currentIndex + 5
    if i > length then return end

    local wordName = s_BookWord[s_CURRENT_USER.bookKey][i]
    local urls = getWordSoundFileDownloadURLs(wordName)
    if not cc.FileUtils:getInstance():isFileExist(urls[3]) then
        print('downloadSoundsFromURL ', urls[1])
        cx.CXUtils:getInstance():download(urls[1], cc.FileUtils:getInstance():getWritablePath(), urls[3])
    end
    if not cc.FileUtils:getInstance():isFileExist(urls[4]) then
        print('downloadSoundsFromURL ', urls[2])
        cx.CXUtils:getInstance():download(urls[2], cc.FileUtils:getInstance():getWritablePath(), urls[4])
    end
    
end

return HttpRequestClient
