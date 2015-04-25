local DataClassBase = require('model.user.DataClassBase')

local DataDailyUsing = class("DataDailyUsing", function()
    return DataClassBase.new()
end)

function DataDailyUsing.create()
    local data = DataDailyUsing.new()
    return data
end

function DataDailyUsing:ctor()
    self.className = 'DataDailyUsing'
    self.startTime = 0 -- seconds
    self.usingTime = 0 -- seconds
end

function DataDailyUsing:isInited()
    return self.startTime > 0
end

function DataDailyUsing:isToday()
    return is2TimeInSameDay(self.startTime, os.time())
end

function DataDailyUsing:update(dt)
    self.usingTime = self.usingTime + dt
end

function DataDailyUsing:reset()
    updateDataFromUser(self, s_CURRENT_USER)
    --print('reset'..self.startTime)
    s_LocalDatabaseManager.getDatas('DataDailyUsing', s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        self.startTime = row.startTime
        self.usingTime = row.usingTime
    end)
    --print('reset startTime'..self.startTime)

    if not self:isToday() or not self:isInited() then
     --   print('reset startTime')
        self.startTime = os.time() -- seconds
        self.usingTime = 0 -- seconds
    end

    s_LocalDatabaseManager.saveDataClassObject(self, s_CURRENT_USER.objectId, s_CURRENT_USER.username)
end

return DataDailyUsing
