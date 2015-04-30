require("cocos.init")
require("common.global")

local SoundMark         = require("view.newstudy.NewStudySoundMark")
local GuessWrong        = require("view.newstudy.GuessWrongPunishPopup")
local ProgressBar           = require("view.newstudy.NewStudyProgressBar")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local Button                = require("view.newstudy.BlueButtonInStudyLayer")

local  CollectUnfamiliarLayer = class("CollectUnfamiliarLayer", function ()
    return cc.Layer:create()
end)

function CollectUnfamiliarLayer:createWordInfo(word) 
    local currentWord       = s_LocalDatabaseManager.getWordInfoFromWordName(word)
    local wordname          = currentWord.wordName
    local wordSoundMarkEn   = currentWord.wordSoundMarkEn
    local wordSoundMarkAm   = currentWord.wordSoundMarkAm
    local wordMeaningSmall  = currentWord.wordMeaningSmall
    local wordMeaning       = currentWord.wordMeaning
    local sentenceEn        = currentWord.sentenceEn
    local sentenceCn        = currentWord.sentenceCn
    local sentenceEn2       = currentWord.sentenceEn2
    local sentenceCn2       = currentWord.sentenceCn2
    
    return {currentWord,wordname,wordSoundMarkEn,wordSoundMarkAm,wordMeaningSmall,
        wordMeaning,sentenceEn,sentenceCn,sentenceEn2,sentenceCn2 }
end

function CollectUnfamiliarLayer:createRandWord(word,randomWrongNumber)
    local randomNameArray  = {}
    table.insert(randomNameArray, word)
    local word1 = split(tostring(s_LocalDatabaseManager.getWordInfoFromWordName(word).wordMeaningSmall),"%.")

    local wordList = {}

    if word1[1] == "num" then
        wordList = {"thirty","eighty","fourteen","eight"}
    elseif word1[1] == "int" then 
        wordList = {"lord","please","oh","hey"}
    elseif word1[1] == "pron" then
        wordList = {"hers","which","our","something"}
    elseif word1[1] == "prep" then
        wordList = {"who","from","of","regarding"}
    elseif word1[1] == "conj" then
        wordList = {"whether","because","or","provided"}
    elseif word1[1] == "aux" then
        wordList = {"do","could","can","have"}
    elseif word1[1] == "art" then
        wordList = {"an","thirty","lord","who"}
    end
    
    if wordList ~= nil then
        for i = 1 ,randomWrongNumber - 1 do
            if word == wordList[i] then
                table.insert(randomNameArray, wordList[4])
            else
                table.insert(randomNameArray, wordList[i])
            end
        end
    end
    
    local test = 1
    while 1 do
        if #randomNameArray >= randomWrongNumber then
            break
        end 
        local randomIndex = math.random(1, #s_BookWord[s_CURRENT_USER.bookKey])
        local randomWord = s_BookWord[s_CURRENT_USER.bookKey][randomIndex]
        local isIn = 0
        for i = 1, #randomNameArray do
            test = test + 1
            if test > 200 then
               break
            end
            if randomNameArray[i] == randomWord then
                isIn = 1
                break
            end
            if tostring(s_LocalDatabaseManager.getWordInfoFromWordName(randomNameArray[i]).wordMeaningSmall) == 
                tostring(s_LocalDatabaseManager.getWordInfoFromWordName(randomWord).wordMeaningSmall) then
                isIn = 1
                break
            end
            local word1 = split(tostring(s_LocalDatabaseManager.getWordInfoFromWordName(word).wordMeaningSmall),"%.")
            local word2 = split(tostring(s_LocalDatabaseManager.getWordInfoFromWordName(randomWord).wordMeaningSmall),"%.")
            if word1[1] ~= word2[1] then
                isIn = 1
                break
            end

        end
        
        if isIn == 0 then
            table.insert(randomNameArray, randomWord)
        end
    end
    return randomNameArray
end

local function createOptions(randomNameArray,word,wrongNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local wordMeaningTable= {}
    for i = 1, 4 do
        local name = randomNameArray[i]
        local meaning = s_LocalDatabaseManager.getWordInfoFromWordName(name).wordMeaningSmall
        table.insert(wordMeaningTable, meaning)
    end
    local rightIndex = math.random(1, 4)
    local tmp = wordMeaningTable[1]
    wordMeaningTable[1] = wordMeaningTable[rightIndex]
    wordMeaningTable[rightIndex] = tmp
    
    local click_choose = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if sender.tag == 1 then  
                playSound(s_sound_learn_true)
            else  
                playSound(s_sound_learn_false)
            end   
        elseif eventType == ccui.TouchEventType.ended then  
--            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local feedback 
            if sender.tag == 1 then  
                feedback = cc.Sprite:create("image/newstudy/right.png")            
            else  
                feedback = cc.Sprite:create("image/newstudy/wrong.png")
            end    
            feedback:setPosition(sender:getContentSize().width * 0.8 ,sender:getContentSize().height * 0.5)
            sender:addChild(feedback)
          

            if sender.tag == 1 then  
                local action1 = cc.DelayTime:create(0.3)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    AnalyticsStudyAnswerRight()
--                    local ChooseRightLayer = require("view.newstudy.ChooseRightLayer")
--                    local chooseRightLayer = ChooseRightLayer.create(word,wrongNum, preWordName, preWordNameState)
--                    s_SCENE:replaceGameLayer(chooseRightLayer)
                    s_CorePlayManager.leaveStudyModel(true)
                end)))            
            else
                local action1 = cc.DelayTime:create(0.3)
                feedback:runAction(cc.Sequence:create(action1,cc.CallFunc:create(function()
                    AnalyticsStudyGuessWrong()
                    local bean = s_CURRENT_USER.beanRewardForCollect
                    local total = 3
                    if bean > 0 then
                        local guessWrong = GuessWrong.create(bean,total)
                        s_SCENE:popup(guessWrong)
                        s_CURRENT_USER.beanRewardForCollect  = s_CURRENT_USER.beanRewardForCollect - 1
                    end
                    local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
                    local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum, preWordName, preWordNameState,CreateWrongLayer_From_CollectWord,nil)
                    s_SCENE:replaceGameLayer(chooseWrongLayer)   
                end)))
            end

        end
    end
    
    local choose_button = {}
    
    for i = 1 , 4 do
        choose_button[i] = ccui.Button:create("image/newstudy/button_words_white_normal.png","image/newstudy/button_words_white_pressed.png","")
        choose_button[i]:setPosition(bigWidth/2, 319+(i-1)*135)
        if i == rightIndex then
            choose_button[i].tag = 1
        else
            choose_button[i].tag = 0
        end
        choose_button[i]:addTouchEventListener(click_choose)

        local choose_label = cc.Label:createWithSystemFont(wordMeaningTable[i],"",32)
        choose_label:setAnchorPoint(0,0.5)
        choose_label:setPosition(40, choose_button[i]:getContentSize().height/2 + 4)
        choose_label:setColor(cc.c4b(98,124,148,255))
        choose_button[i]:addChild(choose_label)
    end
    
    return choose_button
end

local function createDontknow(word,wrongNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local click_dontknow_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            AnalyticsStudyDontKnowAnswer()  
            AnalyticsFirst(ANALYTICS_FIRST_DONT_KNOW, 'TOUCH')
            local ChooseWrongLayer = require("view.newstudy.ChooseWrongLayer")
            local chooseWrongLayer = ChooseWrongLayer.create(word,wrongNum, preWordName, preWordNameState,CreateWrongLayer_From_CollectWord,nil)
            s_SCENE:replaceGameLayer(chooseWrongLayer)          
        end
    end

    local choose_dontknow_button = Button.create("不认识")
    choose_dontknow_button:setPosition(bigWidth/2, 100)
    choose_dontknow_button:addTouchEventListener(click_dontknow_button)
    
    return choose_dontknow_button
end

function CollectUnfamiliarLayer.create(wordName, wrongWordNum, preWordName, preWordNameState)
    local layer = CollectUnfamiliarLayer.new(wordName, wrongWordNum, preWordName, preWordNameState)
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    cc.SimpleAudioEngine:getInstance():stopMusic()
    return layer
end

function CollectUnfamiliarLayer:ctor(wordName, wrongWordNum, preWordName, preWordNameState)
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(45) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.currentWord = wordName

    self.wordInfo = self:createWordInfo(self.currentWord)
    self.randWord = self:createRandWord(self.currentWord,4)
    
    local progressBar_total_number = getMaxWrongNumEveryLevel()

    local progressBar = ProgressBar.create(progressBar_total_number, wrongWordNum, "blue")
    progressBar:setPosition(bigWidth/2+44, 1054)
    backColor:addChild(progressBar,2)
    
    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    local todayNumber = LastWordAndTotalNumber:getCurrentLevelNum()
    self.lastWordAndTotalNumber.setNumber(todayNumber)
    if preWordName ~= nil then
    self.lastWordAndTotalNumber.setWord(preWordName,preWordNameState)
    end


    
    local soundMark = SoundMark.create(self.wordInfo[2], self.wordInfo[3], self.wordInfo[4])
    soundMark:setPosition(bigWidth/2, 930)
    backColor:addChild(soundMark)
    
    self.options = createOptions(self.randWord,wordName,wrongWordNum, preWordName, preWordNameState)
    for i = 1, #self.options do
        backColor:addChild(self.options[i])
    end
    
    self.dontknow = createDontknow(wordName,wrongWordNum, preWordName, preWordNameState)
    backColor:addChild(self.dontknow)
    
    local label_dontknow = cc.Label:createWithSystemFont("不认识的单词请选择不认识","",26)
    label_dontknow:setPosition(bigWidth/2, 220)
    label_dontknow:setColor(cc.c4b(37,158,227,255))
    backColor:addChild(label_dontknow)
    
end

return CollectUnfamiliarLayer