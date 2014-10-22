-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message)

require("common.global")

local UserBaseServer = {}

function UserBaseServer.signup(username, password, onSucceed, onFailed)
    s_SERVER.request('apiSignUp', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

function UserBaseServer.login(username, password, onSucceed, onFailed)
    s_SERVER.request('apiLogIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

function UserBaseServer.dailyCheckIn(userId, onSucceed, onFailed)
    s_SERVER.request('apiuserdailycheckin', {['userId']=userId}, onSucceed, onFailed)
end

return UserBaseServer
