local function getAnalyticsPrefix()
    if BUILD_TARGET == BUILD_TARGET_DEBUG then
        return 'TEST_'
    else
        return ''
    end
end

function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        print('Analytics', getAnalyticsPrefix() .. 'Channel', channelId); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Channel', channelId)
    end
end

----------------------------------------------------------------------------------------

function AnalyticsNewTutorial(step)
    print('Analytics', getAnalyticsPrefix() .. 'newTutorialStepRecord', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'newTutorialStepRecord', tostring(step))
end

----------------------------------------------------------------------------------------

function AnalyticsFollowBeibei()
    print('Analytics', getAnalyticsPrefix() .. 'FollowBeibei', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FollowBeibei', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsTutorial(step)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialStep_1st_day', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialStep_1st_day', tostring(step))
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialStep', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialStep', tostring(step))
end

function AnalyticsSmallTutorial(step)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialSmallStep_1st_day', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSmallStep_1st_day', tostring(step))
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialSmallStep', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSmallStep', tostring(step))
end

--function AnalyticsReviewBossTutorial(step)
--    print('Analytics', , ); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBossTutorialStep', tostring(step))
--end

----------------------------------------------------------------------------------------

function AnalyticsDailyCheckIn(day)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DailyCheckIn_1st_day', tostring(day)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DailyCheckIn_1st_day', tostring(day))
    end
    print('Analytics', getAnalyticsPrefix() .. 'DailyCheckIn', tostring(day)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DailyCheckIn', tostring(day))
end

----------------------------------------------------------------------------------------

function AnalyticsSignUp_Guest()
    print('Analytics', getAnalyticsPrefix() .. 'SignUp', 'Guest'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'Guest')
end

function AnalyticsSignUp_Normal()
    print('Analytics', getAnalyticsPrefix() .. 'SignUp', 'Normal'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'Normal')
end

function AnalyticsSignUp_QQ()
    print('Analytics', getAnalyticsPrefix() .. 'SignUp', 'QQ'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'QQ')
end

function AnalyticsAccountBind()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'AccountBind_1st_day', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountBind_1st_day', 'YES')
    end
    print('Analytics', getAnalyticsPrefix() .. 'AccountBind', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountBind', 'YES')
end

function AnalyticsLogOut()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'LogOut_1st_day', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LogOut_1st_day', 'YES')
    end
    print('Analytics', getAnalyticsPrefix() .. 'LogOut', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LogOut', 'YES')
end

function AnalyticsAccountChange()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'AccountChange_1st_day', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountChange_1st_day', 'YES')
    end
    print('Analytics', getAnalyticsPrefix() .. 'AccountChange', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountChange', 'YES')
end

----------------------------------------------------------------------------------------

function AnalyticsWordsLibBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'WordsLib_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'WordsLib_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'WordsLib', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'WordsLib', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsFriendBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Friend_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Friend', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'TOUCH')
end

function AnalyticsFriendRequest()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Friend_1st_day', 'Request'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend_1st_day', 'Request')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Friend', 'Request'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'Request')
end

function AnalyticsFriendAccept()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Friend_1st_day', 'Accept'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend_1st_day', 'Accept')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Friend', 'Accept'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'Accept')
end

----------------------------------------------------------------------------------------

function AnalyticsDataCenterBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DataCenter_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'DataCenter', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter', 'TOUCH')
end

function AnalyticsDataCenterPage(pageName)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DataCenter_1st_day', pageName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter_1st_day', pageName)
    end
    print('Analytics', getAnalyticsPrefix() .. 'DataCenter', pageName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter', pageName)
end

----------------------------------------------------------------------------------------

function AnalyticsTutorialBookSelect()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialBookSelect_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialBookSelect_1st_day', 'TOUCH')
        if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
            print('Analytics', getAnalyticsPrefix() .. 'TutorialBookSelect_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialBookSelect_1st_day_1st_time', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialBookSelect', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialBookSelect', 'TOUCH')
end

function AnalyticsTutorialHome()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialHome_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialHome_1st_day', 'TOUCH')
        if s_CURRENT_USER.tutorialStep == s_tutorial_home then
            print('Analytics', getAnalyticsPrefix() .. 'TutorialHome_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialHome_1st_day_1st_time', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialHome', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialHome', 'TOUCH')
end


function AnalyticsTutorialLevelSelect()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialLevelSelect_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialLevelSelect_1st_day', 'TOUCH')
        if s_CURRENT_USER.tutorialStep == s_tutorial_level_select then
            print('Analytics', getAnalyticsPrefix() .. 'TutorialLevelSelect_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialLevelSelect_1st_day_1st_time', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialLevelSelect', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialLevelSelect', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsChangeBookBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'ChangeBookBtn_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChangeBookBtn_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'ChangeBookBtn', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChangeBookBtn', 'TOUCH')
end

function AnalyticsBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Book_1st_day', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book_1st_day', 'selected_' .. bookname)
    end
    print('Analytics', getAnalyticsPrefix() .. 'Book', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book', 'selected_' .. bookname)
end

function AnalyticsFirstBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', 'FirstBook_1st_day', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstBook_1st_day', 'selected_' .. bookname)
    end
    print('Analytics','FirstBook', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstBook', 'selected_' .. bookname)
end

function AnalyticsDownloadBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Book_1st_day', 'download_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book_1st_day', 'download_' .. bookname)
    end
    print('Analytics', getAnalyticsPrefix() .. 'Book', 'download_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book', 'download_' .. bookname)
end

function AnalyticsSecondDayBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime + 24 * 3600) and s_CURRENT_USER.dataDailyUsing.usingTime < 10 then
        print('Analytics', getAnalyticsPrefix() .. 'Book_2nd_day', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book_2nd_day', 'selected_' .. bookname)
    end
end

----------------------------------------------------------------------------------------

function AnalyticsEnterLevelLayerBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'EnterLevelLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterLevelLayer_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'EnterLevelLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterLevelLayer', 'TOUCH')
end

function AnalyticsTasksBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Tasks_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Tasks_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Tasks', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Tasks', 'TOUCH')
end

function AnalyticsTasksFinished(layerName)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TasksFinished_1st_day', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksFinished_1st_day', layerName)
    end
    print('Analytics', getAnalyticsPrefix() .. 'TasksFinished', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksFinished', layerName)
end

----------------------------------------------------------------------------------------

-- 点击 重玩错词
function AnalyticsReplayWrongWordsBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'ReplayWrongWords_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReplayWrongWords_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'ReplayWrongWords', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReplayWrongWords', 'TOUCH')
end

-- 点击 依然复习
function AnalyticsContinueReviewBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'ContinueReview_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ContinueReview_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'ContinueReview', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ContinueReview', 'TOUCH')
end

-- 点击 下一步
function AnalyticsStudyNextBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'StudyNext_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'StudyNext_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'StudyNext', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'StudyNext', 'TOUCH')
end

-- 猜错
function AnalyticsStudyGuessWrong()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'GuessWrong')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'GuessWrong')
end

-- 答对
function AnalyticsStudyAnswerRight()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'AnswerRight')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'AnswerRight')
end

-- 不会
function AnalyticsStudyDontKnowAnswer()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'DontKnowAnswer')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'DontKnowAnswer')
end

-- 猜错
function AnalyticsStudyGuessWrong_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'GuessWrong')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'GuessWrong')
end

-- 答对
function AnalyticsStudyAnswerRight_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'AnswerRight')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'AnswerRight')
end

-- 不会
function AnalyticsStudyDontKnowAnswer_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'DontKnowAnswer')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'DontKnowAnswer')
end

-- 点击 跳过划单词步骤
function AnalyticsStudySkipSwipeWord()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SkipSwipeWord_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SkipSwipeWord_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'SkipSwipeWord', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SkipSwipeWord', 'TOUCH')
end

-- 点击 生词回看
function AnalyticsStudyLookBackWord()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'LookBackWord_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LookBackWord_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'LookBackWord', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LookBackWord', 'TOUCH')
end

function AnalyticsStudySlideCoconut_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat1_3 then
                print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_1st_day_1st_time', 'TOUCH')
            end 
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer', 'TOUCH')
end



function AnalyticsStudySlideCoconut_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat2_1 then
                print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_1st_day_1st_time', 'TOUCH')
            end
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer', 'TOUCH')
end

function AnalyticsStudyCollectAllWord()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'CollectAllWord_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat2_2 then
                print('Analytics', getAnalyticsPrefix() .. 'CollectAllWord_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord_1st_day_1st_time', 'TOUCH')
            end
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'CollectAllWord', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord', 'TOUCH')
end

function AnalyticsForgeIron_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat2_3 then
                print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_1st_day_1st_time', 'TOUCH')
            end
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_EnterLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer', 'TOUCH')
end

function AnalyticsForgeIron_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_study and s_CURRENT_USER.tutorialSmallStep == s_smalltutorial_studyRepeat3_1 then
                print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_1st_day_1st_time', 'TOUCH')                           
            end
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer', 'TOUCH')
end
function AnalyticsFirstDayEnterSecondIsland()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if bossList == nil then
        return
    end
    if #bossList == 2 and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) and  #s_LocalDatabaseManager.getBossInfo(2).rightWordList == 0 and #s_LocalDatabaseManager.getBossInfo(2).wrongWordList == 0 then
        print('Analytics', getAnalyticsPrefix() .. 'FirstDayEnterSecondIsland', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstDayEnterSecondIsland', 'TOUCH')
    end
    if #bossList == 2 then
    print('Analytics', getAnalyticsPrefix() .. 'EnterSecondIsland', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterSecondIsland', 'TOUCH')
    end
end

----------------------------------------------------------------------------------------

function AnalyticsReviewBoss()
    print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss', 'SHOW')
end

function AnalyticsReviewBoss_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_review_boss then
                print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_1st_day_1st_time', 'TOUCH')
            end
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer', 'SHOW')
end

function AnalyticsReviewBoss_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_1st_day', 'TOUCH')
            if s_CURRENT_USER.tutorialStep == s_tutorial_review_boss then
                print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_1st_day_1st_time', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_1st_day_1st_time', 'TOUCH')
            end  
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer', 'SHOW')
end
----------------------------------------------------------------------------------------

function AnalyticsSummaryBoss()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'SHOW')
        if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
            print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day_1st_time', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day_1st_time', 'SHOW')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'SHOW')
end

function AnalyticsSummaryBossWordCount(cnt)
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', 'wordsCount_' .. tostring(cnt)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'wordsCount_' .. tostring(cnt))
end

function AnalyticsSummaryBossResult(result)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day', result); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day', result)
        if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
            print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day_1st_time', result); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day_1st_time', result)
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', result); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', result)
end

function AnalyticsPassSecondSummaryBoss()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
        if #bossList >= 2 and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'PassSecondSummaryBoss_1st_day', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'PassSecondSummaryBoss_1st_day', 'SHOW')
        elseif #bossList >= 2 then
            print('Analytics', getAnalyticsPrefix() .. 'PassSecondSummaryBoss', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'PassSecondSummaryBoss', 'SHOW')
        end
    
end

function AnalyticsSummaryBossAddTime()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'AddTime')
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'AddTime')
    end
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', 'AddTime')
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'AddTime')
end

----------------------------------------------------------------------------------------

function AnalyticsChestGeneratedCnt(cnt)
    print('Analytics', getAnalyticsPrefix() .. 'ChestGeneratedCnt', tostring(cnt)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChestGeneratedCnt', tostring(cnt))
end

function AnalyticsChestCollectedCnt(name)
    print('Analytics', getAnalyticsPrefix() .. 'ChestCollectedCnt', name); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChestCollectedCnt', name)
end

function Analytics_applicationDidEnterBackground(layerName)
    print('Analytics', getAnalyticsPrefix() .. 'AppEnterBackground', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AppEnterBackground', layerName)
end

function Analytics_replaceGameLayer(layerName)
    print('Analytics', getAnalyticsPrefix() .. 'replaceGameLayer', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'replaceGameLayer', layerName)
end

----------------------------------------------------------------------------------------

function AnalyticsButtonToShare()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Share_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Share', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', 'TOUCH')
end

function AnalyticsShare(name)
    print('Analytics', getAnalyticsPrefix() .. 'Share', name); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', name)
end

function AnalyticsEnterShare()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Share_1st_day', 'ENTER'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share_1st_day', 'ENTER')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Share', 'ENTER'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', 'ENTER')
end

----------------------------------------------------------------------------------------

function AnalyticsDownloadSoundBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DownloadSound_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSound_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'DownloadSound', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSound', 'TOUCH')
end

function AnalyticsBuy(itemId)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'BuyProduct_1st_day', tostring(itemId)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BuyProduct_1st_day', tostring(itemId))
    end
    print('Analytics', getAnalyticsPrefix() .. 'BuyProduct', tostring(itemId)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BuyProduct', tostring(itemId))
end

function AnalyticsShopBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Shop_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Shop_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Shop', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Shop', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsImproveInfo()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'AnalyticsImproveInfo_1st_day', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AnalyticsImproveInfo_1st_day', 'SHOW')
    end
    print('Analytics', getAnalyticsPrefix() .. 'AnalyticsImproveInfo', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AnalyticsImproveInfo', 'SHOW')
end

function AnalyticsLoginReward()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'LoginReward_1st_day', 'TOUCH');
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LoginReward_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'LoginReward', 'TOUCH');
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LoginReward', 'TOUCH')
end

function AnalyticsDownloadSuccessful()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DownloadSuccessful_1st_day', 'TOUCH');
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSuccessful_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'DownloadSuccessful', 'TOUCH');
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSuccessful', 'TOUCH')
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- first
ANALYTICS_FIRST_BOOK = 0
ANALYTICS_FIRST_LEVEL = 1

ANALYTICS_FIRST_STUDY = 2
ANALYTICS_FIRST_SKIP_REVIEW = 3
ANALYTICS_FIRST_DONT_KNOW = 4
ANALYTICS_FIRST_SWIPE_WORD = 5

ANALYTICS_FIRST_GOT_ENOUGH_UNKNOWN_WORDS = 6

ANALYTICS_FIRST_STUDY_STRIKEWHILEHOT = 7
ANALYTICS_FIRST_SKIP_REVIEW_STRIKEWHILEHOT = 8
ANALYTICS_FIRST_DONT_KNOW_STRIKEWHILEHOT = 9
ANALYTICS_FIRST_SWIPE_WORD_STRIKEWHILEHOT = 10
ANALYTICS_FIRST_FINISH = 11

ANALYTICS_FIRST_REVIEW_BOSS = 12
ANALYTICS_FIRST_REVIEW_BOSS_RESULT = 13

local ANALYTICS_FIRST_EVENTS = {
    'firstBook', 'firstLevelScene', 
    'firstStudy', 'firstSkipReview', 'firstDontKnow', 'firstSwipeWord', 
    'firstGotEnoughUnknownWords', 
    'firstStudyStrikeWhileHot', 'firstSkipReviewStrikeWhileHot', 'firstDontKnowStrikeWhileHot', 'firstSwipeWordStrikeWhileHot', 'firstFinish',
    'firstReviewBoss', 'firstReviewBossResult'
}

function AnalyticsFirst(eventindex, eventDes)
    if math["and"](s_CURRENT_USER.statsMask, (2 ^ eventindex)) == 0 then
        local event = ANALYTICS_FIRST_EVENTS[eventindex + 1]
        print('Analytics', getAnalyticsPrefix() .. event, eventDes); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. event, eventDes)

        if s_SERVER.isNetworkConnectedNow() and string.len(s_CURRENT_USER.objectId) > 0 then
            s_CURRENT_USER.statsMask = s_CURRENT_USER.statsMask + (2 ^ eventindex)
            local obj = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId, ['statsMask']=s_CURRENT_USER.statsMask}
            s_SERVER.updateData(obj, nil, nil)
        end
    end
end

----------------------------------------------------------------------------------------

