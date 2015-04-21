local DataClassBase = require('model.user.DataClassBase')
local DataEverydayInfo = require('model/user/DataEverydayInfo')
local DataLevelInfo = require('model.user.DataLevelInfo')
local DataDailyStudyInfo = require('model/user/DataDailyStudyInfo')
local DataDailyUsing = require('model.user.DataDailyUsing')

USER_TYPE_MANUAL = 0
USER_TYPE_GUEST  = 1
USER_TYPE_BIND   = 2
USER_TYPE_QQ     = 3
USER_TYPE_ALL    = 100

local DataUser = class("DataUser", function()
    return DataClassBase.new()
end)

function DataUser.create()
    local data = DataUser.new()
    return data
end

DataUser.BEANSKEY = 'bbbean'
local BEANS_PREFIX = 'xd928f'
local BEANS_SUBFIX = '$121M^'

function DataUser:ctor()
    self.className                         = '_User'
    
    self.localTime                         = 0
    self.serverTime                        = 0
    self.username                          = ''
    self.nickName                          = ''
    self.password                          = ''
    self.sessionToken                      = ''
    self.usertype                          = USER_TYPE_GUEST
    self.channelId                         = ''
    self.statsMask                         = 0

    self.appVersion                        = s_APP_VERSION 
    self.tutorialStep                      = 0 
    self.tutorialSmallStep                 = 0 
    self.newTutorialStep                   = 4 
    self.isSoundAm                         = 1 
--    self.reviewBossTutorialStep            = 0 
    self.bookKey                           = ''

--    self.energyLastCoolDownTime            = -1 
--    self.energyCount                       = s_energyMaxCount

    self.wordsCount                        = 0 
    self.masterCount                       = 0 
    
    self.fansCount                         = 0 
    self.friendsCount                      = 0 
    self.fans                              = {}
    self.friends                           = {}
    self.followees                         = {} -- who I follow
    self.followers                         = {} -- who follow me
    self.seenFansCount                     = 0

    self.currentWordsIndex                 = 0 
--    self.currentChapterKey                 = ''
    --self.currentSelectedChapterKey         = ''
--    self.currentLevelKey                   = ''
    --self.currentSelectedLevelKey           = ''

--    self.stars                             = 0 

    self.bulletinBoardTime                 = 0 
    self.bulletinBoardMask                 = 0
    self[DataUser.BEANSKEY]                = BEANS_PREFIX .. '0' .. BEANS_SUBFIX
    self.newStudyRightLayerMask            = 0


    self.needToUnlockNextChapter           = 0


--    self.needToUnlockNextChapter           = 0


--    self.levels                            = {}
    self.logInDatas                        = {}
    self.localAuthData                     = nil
    self.snsUserInfo                       = nil
    self.clientData                        = {0}
    self.levelInfo                         = DataLevelInfo.create()

    -- summary boss time
    self.timeAdjust                        = 0
    self.failTime                          = 0
    self.winCombo                          = 0

--    self.lastUpdateSummaryBossTime         = 0
--    self.summaryBossList                   = ''
--    self.chestList                         = ''
--    self.lastUpdateChestTime               = 0
    
    -- function lock
    self.lockFunction                      = 8

    self.isAlterOn                         = 1
    self.slideNum                          = 1
    self.familiarOrUnfamiliar              = 1 -- 0 for choose familiar ,1 for choose unfamiliar
    self.beanRewardForCollect              = 3 -- if begin a new mission ,bean = 3 ; if guess wrong word ,bean = 2 ,1 ,0
    self.beanRewardForIron                 = 3

    self.dataDailyUsing                    = DataDailyUsing.create()
end

function DataUser:getLockFunctionState(productId)
    local lockFunction = self.lockFunction
    for i = 1, productId - 1 do
        lockFunction = math.floor(lockFunction/2)
    end
    return lockFunction%2
end

function DataUser:unlockFunctionState(productId)
    AnalyticsBuy(productId)
    
    local lockFunction = self.lockFunction
    local addNum = 1
    for i = 1, productId - 1 do
        lockFunction = math.floor(lockFunction/2)
        addNum = addNum*2
    end
    if lockFunction%2 == 0 then
        self.lockFunction = self.lockFunction + addNum
    end
end

function DataUser:getBeans()
    local a = string.gsub(self[DataUser.BEANSKEY], BEANS_PREFIX,  "") 
    local b = string.gsub(a, BEANS_SUBFIX,  "") 
    return tonumber(b)
end

function DataUser:setBeans(num)
    self[DataUser.BEANSKEY] = string.format('%s%d%s', BEANS_PREFIX, num, BEANS_SUBFIX)
end

function DataUser:addBeans(count)
    self:setBeans( self:getBeans() + count )
end

function DataUser:subtractBeans(count)
    self:setBeans( self:getBeans() - count )
end

function DataUser:generateChestList()
--    --print("###########start generate chest########")
--    local timePass = os.time() - s_CURRENT_USER.lastUpdateChestTime
----    print('osTime:'..os.time())
----    print('lastUpdate:'..s_CURRENT_USER.lastUpdateChestTime)
--    if timePass >= 3600 * 24 * 2 then   -- two days
--        s_CURRENT_USER.lastUpdateChestTime = os.time()
--        local currentIndex = s_CURRENT_USER.levelInfo:getBookCurrentLevelIndex()
--        if currentIndex == 0 then
--            return 
--        end
--        local chest1 = math.random(0, currentIndex - 1) + 0
--        local chest2 = math.random(0, currentIndex - 1) + 0
----        print('chest1:'..chest1)
----        print('chest2:'..chest2)
----        while (chest2 - chest1) == 0 do
----            print('chest1:'..chest1)
----            print('chest2:'..chest2)
----            chest2 = math.random(0, currentIndex - 1)
----            print('diff'..(chest2-chest1)..'###')
----        end
--        self.chestList = chest1..'|'..chest2
----        self.chestList = '0'
----        print('chestList:'..self.chestList)
--    end
end

function DataUser:generateSummaryBossList() 

--    local updateTime = self.levelInfo:getUpdateBossTime(self.bookKey)
--    --print('!!!!updatetime:'..os.date('%x',updateTime))
--    local list = self.levelInfo:getBossList(self.bookKey)
--    local isSameDate = (os.date('%x',updateTime) == os.date('%x',os.time()))
--    local summaryBossList = split(list,'|')
--    if list == '' then
--        summaryBossList = {}
--    end
--    local index = self.levelInfo:getBookCurrentLevelIndex()
--    if index == 0 then
--        return
--    end
--    
--    if (not isSameDate) and #summaryBossList < 3 and index - #summaryBossList > 0 then
--        updateTime = os.time()
--        --print('currentIndex:'..index)
--        if #summaryBossList == 0 then
--            list = tostring(math.random(0,index - 1)) 
--        else
--            local id = math.random(1,index - 1 - #summaryBossList)
--            for i = 1,#summaryBossList do
--                if summaryBossList[i] == '' then
--                    break
--                end
--                if id - summaryBossList[i] < 0 then
--                    table.insert(summaryBossList,i,tostring(id))
--                    break
--                else
--                    id = id + 1
--                end
--            end
--            if summaryBossList[#summaryBossList] ~= '' and id - summaryBossList[#summaryBossList] > 0 then
--                table.insert(summaryBossList,#summaryBossList + 1,tostring(id))
--            end
--            self.summaryBossList = summaryBossList[1]
--            for i = 2,#summaryBossList do
--                list = list..'|'..summaryBossList[i]
--            end
--        end
--   
--        self.levelInfo:updateBossList(self.bookKey,list)
--        
--    end
--    self.levelInfo:updateTime(self.bookKey,os.time())
--    self.levelInfo:sysData()
    --print("summaryBossList:"..self.summaryBossList.."lastUpdate:"..os.date('%x',self.lastUpdateSummaryBossTime))
end

function DataUser:removeChest(index)

--    local list = split(self.chestList,'|')
--    local tempList = ''
--    print_lua_table(list)
--    for i = 1, #list do 
--        if list[i] - index ~= 0 then
--            if tempList == '' then
--                tempList = list[i]
--            else
--                tempList = tempList..'|'..list[i]
--            end
--        end
--    end
--    self.chestList = tempList

end

function DataUser:removeSummaryBoss(index)
--    local bosslist = self.levelInfo:getBossList(self.bookKey)
--    local list = split(bosslist,'|')
--    local tempList = ''
--    for i = 1, #list do 
--        if list[i] - index ~= 0 then
--            if tempList == '' then
--                tempList = list[i]
--            else
--                tempList = tempList..'|'..list[i]
--            end
--        end
--    end
--    self.levelInfo:updateBossList(self.bookKey, tempList)
--    self.levelInfo:sysData()
end

function DataUser:getNameForDisplay()
    if s_CURRENT_USER.usertype == USER_TYPE_QQ then return self.nickName end
    if s_CURRENT_USER.usertype == USER_TYPE_GUEST then return '游客' end
    return self.username
end

function DataUser:parseServerData(data)
    for key, value in pairs(self) do
        if nil ~= data[key] then
            self[key] = data[key]
        end
    end
end

-- function DataUser:parseServerDataEverydayInfo(results)
--     local DataDailyCheckIn = require('model.user.DataEverydayInfo')
--    self.logInDatas = {}
--    for i, v in ipairs(results) do
--        local data = DataEverydayInfo.create()
--        parseServerDataToClientData(v, data)
--        self.logInDatas[i] = data
--        print_lua_table(data)
--    end 
-- end

function DataUser:parseServerDataLevelInfo(results)
    for i, v in ipairs(results) do
        parseServerDataToClientData(v, self.levelInfo)
        return self.levelInfo
    end 
end

function DataUser:setTutorialStep(step)
    self.tutorialStep = step
    saveUserToServer({['tutorialStep']=tutorialStep})
    AnalyticsTutorial(step)
end

function DataUser:setTutorialSmallStep(step)
    self.tutorialSmallStep = step
    saveUserToServer({['tutorialSmallStep']=tutorialSmallStep})
    AnalyticsSmallTutorial(step)
end

-- who I follow
function DataUser:parseServerFolloweesData(results)
    self.followees = {}
    for i, v in ipairs(results) do
        local data = DataUser.create()
        parseServerDataToClientData(v.followee, data)
        self.followees[i] = data
    end
end

-- who follow me
function DataUser:parseServerFollowersData(results)
    self.followers = {}
    for i, v in ipairs(results) do
        local data = DataUser.create()
        parseServerDataToClientData(v.follower, data)
        self.followers[i] = data
    end
end

function DataUser:parseServerFollowData(obj)
    if obj ~= nil then
        table.insert(self.followees, obj)
    end
end

function DataUser:parseServerUnFollowData(obj)
    if obj ~= nil then
        for i = 1,#s_CURRENT_USER.followees do
            if s_CURRENT_USER.followees[i].username == obj.username then
                table.remove(s_CURRENT_USER.followees,i)
                break
            end
        end
    end
end

function DataUser:parseServerRemoveFanData(obj)
    if obj ~= nil then
        for i = 1,#s_CURRENT_USER.followees do
            if s_CURRENT_USER.followers[i].username == obj.username then
                table.remove(s_CURRENT_USER.followees,i)
                break
            end
        end
    end
end
function DataUser:getFriendsInfo()
    
    self.friends = {}
    self.fans = {}
    local friendsObjId = {}
    local friends = {}
   print_lua_table (s_CURRENT_USER.followers)
   print_lua_table (s_CURRENT_USER.followees)
    for key, followee in pairs(self.followees) do
        friendsObjId[followee.objectId] = 1
        friends[followee.objectId] = followee
    end

    for key, follower in pairs(self.followers) do
        print(friendsObjId[follower.objectId])
        if friendsObjId[follower.objectId] == 1 then
            friendsObjId[follower.objectId] = 2
            friends[follower.objectId] = follower
            self.friends[#self.friends + 1] = follower
        else
            table.insert(self.fans,1,follower)
            if #self.fans > s_friend_request_max_count then
                s_UserBaseServer.removeFan(self.fans[#self.fans],
                    function(api,result)
                        table.remove(self.fans,#self.fans)
                    end,
                    function(api, code, message, description)
                    end)
                
            end
        end
    end

    self.friendsCount = #self.friends
    self.fansCount = #self.fans
    print_lua_table (s_CURRENT_USER.fans)
    saveUserToServer({['friendsCount']=self.friendsCount, ['fansCount']=self.fansCount})
end

function DataUser:getBookChapterLevelData(bookKey, chapterKey, levelKey)
    for i,v in ipairs(self.levels) do
        if v.chapterKey == chapterKey and v.levelKey == levelKey and v.bookKey == bookKey then

            return v
        end
    end
    return nil
end



function DataUser:getUserLevelData(chapterKey, levelKey)  
    --print('begin get user level data: size--'..#self.levels) 
    for i,v in ipairs(self.levels) do
        --s_logd('getUserLevelData: '..v.bookKey .. v.chapterKey .. ', ' .. v.levelKey..',star:'..v.stars..',unlocked:'..v.isLevelUnlocked..','..'tested:'..v.isTested)
        --s_logd('getUserLevelData: '..v.bookKey .. v.chapterKey .. ', ' .. v.levelKey..',star:'..v.stars..',unlocked:'..v.isLevelUnlocked..','..v.userId..','..v.objectId)
        if v.chapterKey == chapterKey and v.levelKey == levelKey and v.bookKey == s_CURRENT_USER.bookKey then
            return v
        end
    end
    --print('end get user level data')
    return nil
end

function DataUser:getUserBookObtainedStarCount()
    local count = 0
    for i, v in ipairs(self.levels) do
        if v.bookKey == self.bookKey then
            local levelConfig = s_DataManager.getLevelConfig(self.bookKey,v.chapterKey,v.levelKey)
            if levelConfig ~= nil and levelConfig['type'] == 0 then
                count = count + v.stars
            end
        end
    end
    return count
end


-- function DataUser:initLevels()
--     for i = 1, #self.levels do
--         self.levels[i].chapterKey = 'chapter0'
--         self.levels[i].stars = 0
--         self.levels[i].levelKey = 'level'..(i-1)
--         if self.levels[i].levelKey ~= 'level0' then
--             self.levels[i].isLevelUnlocked = 0
--         else
--             self.levels[i].isLevelUnlocked = 1
--         end
--         s_UserBaseServer.saveDataObjectOfCurrentUser(self.levels[i],
--             function(api,result)
--             end,
--             function(api, code, message, description)
--             end) 
--     end
--     self.currentChapterKey = 'chapter0'
--     self.currentSelectedChapterKey = 'chapter0'
--     self.currentLevelKey = 'level0'
--     self.currentSelectedLevelKey = 'level0'
--     self:updateDataToServer()
-- end

-- function DataUser:initChapterLevelAfterLogin()
--     self.currentChapterKey = 'chapter0'
--     self.currentLevelKey = 'level0'
--     self.currentSelectedLevelKey = 'level0'
--     s_SCENE.levelLayerState = s_normal_level_state
    
--     local levelConfig = s_DataManager.getLevels(s_CURRENT_USER.bookKey)
--     if levelConfig ~= nil then
--         for i, v in ipairs(levelConfig) do
--             local levelData = self:getUserLevelData(v['chapter_key'],v['level_key'])
--             if levelData ~= nil and levelData.isLevelUnlocked == 1 then
--                 self.currentChapterKey = v['chapter_key']
--                 self.currentSelectedChapterKey = v['chapter_key']
--                 self.currentLevelKey = v['level_key']
--                 self.currentSeletedLevelKey = v['levelKey']
--             else 
--                 break
--             end
--         end
--     end

-- --    self.currentLevelKey = 'level39'
-- --    self.currentSelectedLevelKey = 'level39'
-- --    self.currentSelectedChapterKey = 'chapter3'
-- --    self.currentChapterKey = 'chapter3'
-- --    s_CURRENT_USER:setUserLevelDataOfUnlocked(self.currentChapterKey,self.currentLevelKey,1)
-- --    s_CURRENT_USER:setUserLevelDataOfStars(self.currentChapterKey,self.currentLevelKey,3)
--  --s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
-- end

-- function DataUser:setUserLevelDataOfStars(chapterKey, levelKey, stars)
--     local levelData = self:getUserLevelData(chapterKey, levelKey)
--     if levelData == nil then
--         local DataLevel = require('model.user.DataLevel')
--         levelData = DataLevel.create()
--         levelData.bookKey = s_CURRENT_USER.bookKey
--         levelData.chapterKey = chapterKey
--         levelData.levelKey = levelKey
--         levelData.stars = stars
--         levelData.isTested = 1
--         if levelData.stars > 0 then
--             levelData.isPassed = 1
--         end
--         --print('------ before insert table-----')
--         print_lua_table(levelData)
--         table.insert(self.levels,levelData)
-- --        print('-------- after insert table -----')
-- --        print('levels_count:'..#self.levels)
--     end
--     levelData.isTested = 1
--     if levelData.stars < stars then
--         levelData.stars = stars
--     end
--     if levelData.stars > 0 then
--         levelData.isPassed = 1
--     end
--     --print('---print stars: levelData.objectId is '..levelData.objectId)
--     s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
--     function(api,result)
--         --print('call back stars')
--         --print_lua_table(result)
--         --print('levelData.objectId:'..levelData.objectId..','..levelData.levelKey)
--     end,
--     function(api, code, message, description)
--     end)        
-- end

-- function DataUser:setUserLevelDataOfIsPlayed(chapterKey, levelKey, isPlayed)
--     local levelData = self:getUserLevelData(chapterKey, levelKey)
--     if levelData == nil then
--         local DataLevel = require('model.user.DataLevel')
--         levelData = DataLevel.create()
--         levelData.bookKey = s_CURRENT_USER.bookKey
--         levelData.chapterKey = chapterKey
--         levelData.levelKey = levelKey
--         levelData.isPlayed = isPlayed
--         table.insert(self.levels,levelData)
--     end
--     levelData.isPlayed = isPlayed
--     s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
--         function(api,result)
--         end,
--         function(api, code, message, description)
--         end) 
-- end

-- function DataUser:setUserLevelDataOfUnlocked(chapterKey, levelKey, unlocked, onSucceed, onFailed)
--     local levelData = self:getUserLevelData(chapterKey, levelKey)
--     if levelData == nil then
--         local DataLevel = require('model.user.DataLevel')
--         levelData = DataLevel.create()
--         levelData.bookKey = s_CURRENT_USER.bookKey
--         levelData.chapterKey = chapterKey
--         levelData.levelKey = levelKey
--         levelData.isLevelUnlocked = unlocked
--         table.insert(self.levels,levelData)
--     end

--     levelData.isLevelUnlocked = unlocked
--     s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
--         function (api, result)
--             --print('call back unlocked')
--             local callLevelData = self:getUserLevelData(chapterKey, levelKey)
--             callLevelData.objectId = levelData.objectId
--             --print('levelData.objectId'..levelData.objectId..','..levelData.levelKey)
--             s_LocalDatabaseManager.saveDataClassObject(levelData)
--             if onSucceed ~= nil then onSucceed(api, result) end
--         end,
--         function (api, code, message, description)
--             if onFailed ~= nil then onFailed(api, code, message, description) end
--         end)  
-- end

-- function DataUser:getIsLevelUnlocked(chapterKey, levelKey) 
--     local levelData = self:getUserLevelData(chapterKey, levelKey)
--     if levelData == nil then
--         return false
--     end
    
--     if levelData.isLevelUnlocked ~= 0 then
--         return true
--     else
--         return false
--     end
-- end

-- -- energy api
-- function DataUser:resetEnergyLastCoolDownTime()
--     if self.energyCount >= s_energyMaxCount then
--         self.energyLastCoolDownTime = self.serverTime
--     end
--     if self.energyLastCoolDownTime > self.serverTime and self.serverTime > 0 then
--         self.energyLastCoolDownTime = self.serverTime
--     end
-- end

-- function DataUser:useEnergys(count)
--     self:resetEnergyLastCoolDownTime()
--     self.energyCount = self.energyCount - count
--     self:updateDataToServer()
-- end

-- function DataUser:addEnergys(count)
--     self:resetEnergyLastCoolDownTime()
--     self.energyCount = self.energyCount + count
--     self:updateDataToServer()
-- end

function DataUser:updateDataToServer()
    saveUserToServer(self)
end


-- get word in one book 
function DataUser:getUserBookWord()
    local wordTable = {}
    local wordTableOp = {}
    local chapterIndex = 0
    while chapterIndex < 4 do
        local levelIndex = 0
        local levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,'chapter'..chapterIndex,'level'..levelIndex)
        while levelConfig ~= nil do
            if levelConfig['type'] == 0 then
                table.insert(wordTable,split(levelConfig.word_content,'|'))
            end      
                levelIndex = levelIndex + 1
                levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,'chapter'..chapterIndex,'level'..levelIndex)
        end
        chapterIndex = chapterIndex + 1
    end
    table.foreachi(wordTable, function(i, v) table.foreachi(v, function(i, v)  table.insert(wordTableOp,v) end) end)
    table.foreachi(wordTableOp, function(i, v)  print(i ,v)  end)
    return wordTableOp
end

return DataUser
