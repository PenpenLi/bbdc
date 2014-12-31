
function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        cx.CXAnalytics:logEventAndLabel('Channel', channelId)
    end
end

----------------------------------------------------------------------------------------

function AnalyticsTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialStep', tostring(step))
end

function AnalyticsSmallTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialSmallStep', tostring(step))
end

function AnalyticsReviewBossTutorial(step)
    cx.CXAnalytics:logEventAndLabel('ReviewBossTutorialStep', tostring(step))
end

----------------------------------------------------------------------------------------

function AnalyticsDailyCheckIn(day)
    cx.CXAnalytics:logEventAndLabel('DailyCheckIn', tostring(day))
end

----------------------------------------------------------------------------------------

function AnalyticsSignUp_Guest()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'Guest')
end

function AnalyticsSignUp_Normal()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'Normal')
end

function AnalyticsSignUp_QQ()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'QQ')
end

function AnalyticsAccountBind()
    cx.CXAnalytics:logEventAndLabel('AccountBind', 'YES')
end

function AnalyticsLogOut()
    cx.CXAnalytics:logEventAndLabel('LogOut', 'YES')
end

----------------------------------------------------------------------------------------

function AnalyticsWordsLibBtn()
    cx.CXAnalytics:logEventAndLabel('WordsLib', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsFriendBtn()
    cx.CXAnalytics:logEventAndLabel('Friend', 'TOUCH')
end

function AnalyticsFriendRequest()
    cx.CXAnalytics:logEventAndLabel('Friend', 'Request')
end

function AnalyticsFriendAccept()
    cx.CXAnalytics:logEventAndLabel('Friend', 'Accept')
end

----------------------------------------------------------------------------------------

function AnalyticsDataCenterBtn()
    cx.CXAnalytics:logEventAndLabel('DataCenter', 'TOUCH')
end

function AnalyticsDataCenterPage(pageName)
    cx.CXAnalytics:logEventAndLabel('DataCenter', pageName)
end

----------------------------------------------------------------------------------------

function AnalyticsChangeBookBtn()
    cx.CXAnalytics:logEventAndLabel('Book', 'TOUCH')
end

function AnalyticsBook(bookname)
    cx.CXAnalytics:logEventAndLabel('Book', 'selected_' .. bookname)
end

function AnalyticsDownloadBook(bookname)
    cx.CXAnalytics:logEventAndLabel('Book', 'download_' .. bookname)
end

----------------------------------------------------------------------------------------

function AnalyticsEnterLevelLayerBtn()
    cx.CXAnalytics:logEventAndLabel('EnterLevelLayer', 'TOUCH')
end

function AnalyticsTasksBtn()
    cx.CXAnalytics:logEventAndLabel('Tasks', 'TOUCH')
end

----------------------------------------------------------------------------------------

-- 点击 重玩错词
function AnalyticsReplayWrongWordsBtn()
    cx.CXAnalytics:logEventAndLabel('ReplayWrongWords', 'TOUCH')
end

-- 点击 依然复习
function AnalyticsContinueReviewBtn()
    cx.CXAnalytics:logEventAndLabel('ContinueReview', 'TOUCH')
end

-- 点击 下一步
function AnalyticsStudyNextBtn()
    cx.CXAnalytics:logEventAndLabel('StudyNext', 'TOUCH')
end

-- 猜错
function AnalyticsStudyGuessWrong()
    cx.CXAnalytics:logEventAndLabel('answerWordMeaning', 'GuessWrong')
end

-- 答对
function AnalyticsStudyAnswerRight()
    cx.CXAnalytics:logEventAndLabel('answerWordMeaning', 'AnswerRight')
end

-- 不会
function AnalyticsStudyDontKnowAnswer()
    cx.CXAnalytics:logEventAndLabel('answerWordMeaning', 'DontKnowAnswer')
end

-- 猜错
function AnalyticsStudyGuessWrong_strikeWhileHot()
    cx.CXAnalytics:logEventAndLabel('answerWordMeaningHOT', 'GuessWrong')
end

-- 答对
function AnalyticsStudyAnswerRight_strikeWhileHot()
    cx.CXAnalytics:logEventAndLabel('answerWordMeaningHOT', 'AnswerRight')
end

-- 不会
function AnalyticsStudyDontKnowAnswer_strikeWhileHot()
    cx.CXAnalytics:logEventAndLabel('answerWordMeaningHOT', 'DontKnowAnswer')
end

-- 点击 跳过划单词步骤
function AnalyticsStudySkipSwipeWord()
    cx.CXAnalytics:logEventAndLabel('SkipSwipeWord', 'TOUCH')
end

-- 点击 生词回看
function AnalyticsStudyLookBackWord()
    cx.CXAnalytics:logEventAndLabel('LookBackWord', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsReviewBoss()
    cx.CXAnalytics:logEventAndLabel('ReviewBoss', 'SHOW')
end

----------------------------------------------------------------------------------------

function AnalyticsSummaryBoss()
    cx.CXAnalytics:logEventAndLabel('SummaryBoss', 'SHOW')
end

function AnalyticsSummaryBossWordCount(cnt)
    cx.CXAnalytics:logEventAndLabel('SummaryBoss', 'wordsCount_' .. tostring(cnt))
end

function AnalyticsSummaryBossResult(result)
    cx.CXAnalytics:logEventAndLabel('SummaryBoss', result)
end

----------------------------------------------------------------------------------------

function Analytics_applicationDidEnterBackground(layerName)
    cx.CXAnalytics:logEventAndLabel('AppEnterBackground', layerName)
end

