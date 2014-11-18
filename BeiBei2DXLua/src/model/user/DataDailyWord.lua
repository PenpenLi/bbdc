local DataClassBase = require('model/user/DataClassBase')

local DataDailyWord = class("DataDailyWord", function()
    return DataClassBase.new()
end)

function DataDailyWord.create()
    local data = DataDailyWord.new()
    return data
end

function DataDailyWord:ctor()
    self.className = 'DataDailyWord'
    
    self.bookKey = ''
    self.learnedDate = 0
    self.learnedWordCount = 0
end

return DataDailyWord
