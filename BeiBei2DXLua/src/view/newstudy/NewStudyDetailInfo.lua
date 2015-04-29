require("cocos.init")
require("common.global")
local SliderView        = require("view.SliderView")

local WordDetailInfo = class("WordDetailInfo", function()
    return cc.Layer:create()
end)

function WordDetailInfo.create(word)

    local height = 480

    local main = cc.Layer:create()
    main:setContentSize(s_DESIGN_WIDTH, height)
    main:setAnchorPoint(0.5,1)
    main:ignoreAnchorPointForPosition(false)

    local label_wordname
    local label_wordmeaning
    local sprite_split
    local label_sentenceen
    local label_sentencecn
    local label_sentenceen2
    local label_sentencecn2

    local index_y = height - 40
    local text_length = 460
    local left = (s_DESIGN_WIDTH - text_length)/2

    -- label_wordname = cc.Label:createWithSystemFont(word.wordName,"",40)
    -- label_wordname:setAnchorPoint(0,1)
    -- label_wordname:setColor(cc.c4b(0,0,0,255))
    -- label_wordname:setDimensions(text_length,0)
    -- label_wordname:setAlignment(0)
    -- label_wordname:setPosition(left, index_y)
    -- main:addChild(label_wordname)
    -- index_y = index_y - label_wordname:getContentSize().height - 10
    local meanings = split(word.wordMeaning, "|||")
    for i = 1, #meanings do
        label_wordmeaning = cc.Label:createWithSystemFont(meanings[i],"",24)
        label_wordmeaning:setOpacity(200)
        label_wordmeaning:setAnchorPoint(0,1)
        label_wordmeaning:setColor(cc.c4b(0,0,0,255))
        label_wordmeaning:setDimensions(text_length,0)
        label_wordmeaning:setAlignment(0)
        label_wordmeaning:setPosition(left, index_y)
        main:addChild(label_wordmeaning)
        index_y = index_y - label_wordmeaning:getContentSize().height - 10 
    end 

    index_y = index_y - 20

    -- add sprite for split
    sprite_split = cc.Sprite:create("image/studyscene/studyscene_detailinfo_splitline.png")
    sprite_split:setOpacity(200)
    sprite_split:ignoreAnchorPointForPosition(false)
    sprite_split:setAnchorPoint(0.5,1)
    sprite_split:setPosition(s_DESIGN_WIDTH/2, index_y)
    main:addChild(sprite_split)
    index_y = index_y - sprite_split:getContentSize().height - 25
    local y = index_y

    local length = {}
    local wordHeight
    
    label_sentenceen = cc.Label:createWithTTF(word.sentenceEn,'font/CenturyGothic.ttf',26)
    label_sentenceen:setOpacity(180)
    label_sentenceen:setAnchorPoint(0,1)
    label_sentenceen:setColor(cc.c4b(0,0,0,255))
    label_sentenceen:setDimensions(text_length,0)
    label_sentenceen:setAlignment(0)
    label_sentenceen:setString(word.sentenceEn)
    label_sentenceen:setPosition(left, index_y)
    --main:addChild(label_sentenceen)
    index_y = index_y - label_sentenceen:getContentSize().height - 10
    label_sentenceen:setDimensions(0,0)
    length[1] = label_sentenceen:getContentSize().width
    wordHeight = label_sentenceen:getContentSize().height

    label_sentencecn = cc.Label:createWithSystemFont(word.sentenceCn,"",24)
    label_sentencecn:setOpacity(200)
    label_sentencecn:setAnchorPoint(0,1)
    label_sentencecn:setColor(cc.c4b(0,0,0,255))
    label_sentencecn:setDimensions(text_length,0)
    label_sentencecn:setAlignment(0)
    label_sentencecn:setPosition(left, index_y)
    main:addChild(label_sentencecn)
    index_y = index_y - label_sentencecn:getContentSize().height - 10
    length[2] = label_sentencecn:getContentSize().width
    local y2 = index_y

    label_sentenceen2 = cc.Label:createWithTTF(word.sentenceEn2,'font/CenturyGothic.ttf',26)
    label_sentenceen2:setOpacity(180)
    label_sentenceen2:setAnchorPoint(0,1)
    label_sentenceen2:setColor(cc.c4b(0,0,0,255))
    label_sentenceen2:setDimensions(text_length,0)
    label_sentenceen2:setAlignment(0)
    label_sentenceen2:setPosition(left, index_y)
    --main:addChild(label_sentenceen2)
    index_y = index_y - label_sentenceen2:getContentSize().height - 10
    label_sentenceen2:setDimensions(0,0)
    length[3] = label_sentenceen2:getContentSize().width

    label_sentencecn2 = cc.Label:createWithSystemFont(word.sentenceCn2,"",24)
    label_sentencecn2:setOpacity(200)
    label_sentencecn2:setAnchorPoint(0,1)
    label_sentencecn2:setColor(cc.c4b(0,0,0,255))
    label_sentencecn2:setDimensions(text_length,0)
    label_sentencecn2:setAlignment(0)
    label_sentencecn2:setPosition(left, index_y)
    main:addChild(label_sentencecn2)
    
    local realHeight = height-index_y

    local sentence1
    local sentence2
    local split1 = false
    local split2 = false
    if #split(word.sentenceEn,'||') > 1 then
        sentence1 = split(word.sentenceEn,'||')
        split1 = true
    else
        sentence1 = split(word.sentenceEn,word.wordName)
    end 

    if #split(word.sentenceEn2,'||') > 1 then
        sentence2 = split(word.sentenceEn2,'||')
        split2 = true
    else
        sentence2 = split(word.sentenceEn2,word.wordName)
    end 

    local richtext = ccui.RichText:create()

    richtext:ignoreContentAdaptWithSize(false)
    
    richtext:setContentSize(cc.size(text_length, wordHeight * math.ceil(length[1] / text_length)))  
    richtext:ignoreAnchorPointForPosition(false) 
    richtext:setPosition(left + text_length / 2, y - richtext:getContentSize().height / 2)
    main:addChild(richtext)  

    local index = 1
    for i = 1,#sentence1 do
        if split1 then
            local clr = cc.c3b(0,0,0)
            if i % 2 == 0 then
                clr = cc.c3b(255, 90, 17)
            end
            local richElement1 = ccui.RichElementText:create(index,clr,200,sentence1[i],'font/CenturyGothic.ttf',26)
            index = index + 1                           
            richtext:pushBackElement(richElement1) 
        else
            local richElement1 = ccui.RichElementText:create(index,cc.c3b(0, 0, 0),200,sentence1[i],'font/CenturyGothic.ttf',26)     
            index = index + 1                   
            richtext:pushBackElement(richElement1)
            
            if i < #sentence1 then
                local clr = cc.c3b(255, 90, 17)
                local c1 = 0
                local c2 = 0
                local isSeperate = true
                if string.len(sentence1[i]) > 0 then
                    c1 = string.byte(string.sub(sentence1[i],string.len(sentence1[i]),string.len(sentence1[i])))
                    if (c1 <= 122 and c1 >= 97) or (c1 <= 90 and c1 >= 65) then
                        isSeperate = false
                        print(c1)
                        print(sentence1[i]..'false')
                    end
                end
                if i < #sentence1 and string.len(sentence1[i + 1]) > 0 and string.len(sentence1[i + 1])< 5 and isSeperate then
                    c2 = string.byte(string.sub(sentence1[i + 1],1,1))
                    if (c2 <= 122 and c2 >= 97) or (c2 <= 90 and c2 >= 65) then
                        isSeperate = false
                        print(c2)
                        print('false'..sentence1[i + 1])
                    end
                end
                if not isSeperate then
                    clr = cc.c3b(0,0,0)
                end
                local richElement2 = ccui.RichElementText:create(index,clr,200,word.wordName,'font/CenturyGothic.ttf',26)
                index = index + 1                           
                richtext:pushBackElement(richElement2) 
            else
                local richElement2 = ccui.RichElementText:create(index,cc.c3b(255, 90, 17),200,'\n','',26)
                index = index + 1                           
                richtext:pushBackElement(richElement2)
            end
        end
    end
    -- local richElementCn1 = ccui.RichElementText:create(index,cc.c3b(0, 0, 0),200,word.sentenceCn,'',26) 
    -- index = index + 1                       
    -- richtext:pushBackElement(richElementCn1) 
    local richtext2 = ccui.RichText:create()

    richtext2:ignoreContentAdaptWithSize(false)
    
    richtext2:setContentSize(cc.size(text_length, wordHeight * math.ceil(length[3] / text_length)))  
    richtext2:ignoreAnchorPointForPosition(false) 
    richtext2:setPosition(left + text_length / 2, y2 - richtext2:getContentSize().height / 2)
    main:addChild(richtext2)  
    index = 1
    for i = 1,#sentence2 do
        if split2 then
            local clr = cc.c3b(0,0,0)
            if i % 2 == 0 then
                clr = cc.c3b(255, 90, 17)
            end
            local richElement1 = ccui.RichElementText:create(index,clr,200,sentence2[i],'font/CenturyGothic.ttf',26)
            index = index + 1                           
            richtext2:pushBackElement(richElement1) 
        else
            local richElement1 = ccui.RichElementText:create(index,cc.c3b(0, 0, 0),200,sentence2[i],'font/CenturyGothic.ttf',26)     
            index = index + 1                   
            richtext2:pushBackElement(richElement1)     
            if i < #sentence2 then
                local clr = cc.c3b(255, 90, 17)
                local c1 = 0
                local c2 = 0
                local isSeperate = true
                if string.len(sentence2[i]) > 0 then
                    c1 = string.byte(string.sub(sentence2[i],string.len(sentence2[i]),string.len(sentence2[i])))
                    if (c1 <= 122 and c1 >= 97) or (c1 <= 90 and c1 >= 65) then
                        isSeperate = false
                    end
                end
                if i < #sentence2 and string.len(sentence2[i + 1]) > 0 and string.len(sentence2[i + 1])< 5 and isSeperate then
                    c2 = string.byte(string.sub(sentence2[i + 1],1,1))
                    if (c2 <= 122 and c2 >= 97) or (c2 <= 90 and c2 >= 65) then
                        isSeperate = false
                    end
                end
                if not isSeperate then
                    clr = cc.c3b(0,0,0)
                end
                local richElement2 = ccui.RichElementText:create(index,clr,200,word.wordName,'font/CenturyGothic.ttf',26)
                index = index + 1                           
                richtext2:pushBackElement(richElement2) 
            end
        end
    end
    -- local richElementCn2 = ccui.RichElementText:create(index,cc.c3b(0, 0, 0),200,word.sentenceCn2,'',26) 
    -- index = index + 1                       
    -- richtext:pushBackElement(richElementCn2) 

    local layer
    if realHeight <= height then
        layer = WordDetailInfo.new()
        layer:setContentSize(s_DESIGN_WIDTH, height)
        
        main:setPosition(s_DESIGN_WIDTH/2, height)
        layer:addChild(main)
    else
        layer = WordDetailInfo.new()
        layer:setContentSize(s_DESIGN_WIDTH, height)
    
        local tmp = cc.Layer:create()
        tmp:setContentSize(s_DESIGN_WIDTH, height)

        local sliderView = SliderView.create(s_DESIGN_WIDTH, height, realHeight)
        tmp:addChild(sliderView)

        local backColor = cc.Layer:create()
        backColor:setContentSize(s_DESIGN_WIDTH, realHeight)  
        backColor:setAnchorPoint(0.5,0.5)
        backColor:ignoreAnchorPointForPosition(false)
        backColor:setPosition(s_DESIGN_WIDTH/2,realHeight/2)
        sliderView.scrollView:addChild(backColor)

        main:setPosition(s_DESIGN_WIDTH/2, realHeight)
        backColor:addChild(main)

        tmp:setAnchorPoint(0.5,0.5)
        tmp:ignoreAnchorPointForPosition(false)
        tmp:setPosition(s_DESIGN_WIDTH/2,height/2)
        layer:addChild(tmp)
    end
    
    return layer
end


return WordDetailInfo







