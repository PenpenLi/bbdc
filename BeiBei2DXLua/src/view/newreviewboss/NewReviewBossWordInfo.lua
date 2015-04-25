local SliderView        = require("view.SliderView")

local NewReviewBossWordInfo = class("NewReviewBossWordInfo", function()
    return cc.Layer:create()
end)

function NewReviewBossWordInfo.create(word,y)
    local height = 480
    if y ~= nil then
    	height = y
    end
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

    local index_y = height
    local text_length = 460
    local left = (s_DESIGN_WIDTH - text_length)/2




    local meanings = split(word.wordMeaning, "|||")

    for i = 1, #meanings do
        label_wordmeaning = cc.Label:createWithSystemFont(meanings[i],"",28)
        label_wordmeaning:setAnchorPoint(0,1)
        label_wordmeaning:setColor(cc.c4b(0,0,0,255))
        label_wordmeaning:setDimensions(text_length,0)
        label_wordmeaning:setAlignment(0)
        label_wordmeaning:setPosition(left, index_y)
        main:addChild(label_wordmeaning)
        index_y = index_y - label_wordmeaning:getContentSize().height - 10 
    end    
    
     -- add sprite for split
    sprite_split = cc.Sprite:create("image/studyscene/studyscene_detailinfo_splitline.png")
    sprite_split:setAnchorPoint(0.5,1)
    sprite_split:setPosition(s_DESIGN_WIDTH/2, index_y)
    sprite_split:setColor(cc.c4b(136,154,174,255))
    main:addChild(sprite_split)
    index_y = index_y - sprite_split:getContentSize().height - 10

    label_sentenceen = cc.Label:createWithSystemFont(word.sentenceEn,"",28)
    label_sentenceen:setAnchorPoint(0,1)
    label_sentenceen:setColor(cc.c4b(0,0,0,255))
    label_sentenceen:setDimensions(text_length,0)
    label_sentenceen:setAlignment(0)
    label_sentenceen:setPosition(left, index_y)
    main:addChild(label_sentenceen)
    index_y = index_y - label_sentenceen:getContentSize().height - 10

    label_sentencecn = cc.Label:createWithSystemFont(word.sentenceCn,"",28)
    label_sentencecn:setAnchorPoint(0,1)
    label_sentencecn:setColor(cc.c4b(0,0,0,255))
    label_sentencecn:setDimensions(text_length,0)
    label_sentencecn:setAlignment(0)
    label_sentencecn:setPosition(left, index_y)
    main:addChild(label_sentencecn)
    index_y = index_y - label_sentencecn:getContentSize().height - 10

    label_sentenceen2 = cc.Label:createWithSystemFont(word.sentenceEn2,"",28)
    label_sentenceen2:setAnchorPoint(0,1)
    label_sentenceen2:setColor(cc.c4b(0,0,0,255))
    label_sentenceen2:setDimensions(text_length,0)
    label_sentenceen2:setAlignment(0)
    label_sentenceen2:setPosition(left, index_y)
    main:addChild(label_sentenceen2)
    index_y = index_y - label_sentenceen2:getContentSize().height - 10

    label_sentencecn2 = cc.Label:createWithSystemFont(word.sentenceCn2,"",28)
    label_sentencecn2:setAnchorPoint(0,1)
    label_sentencecn2:setColor(cc.c4b(0,0,0,255))
    label_sentencecn2:setDimensions(text_length,0)
    label_sentencecn2:setAlignment(0)
    label_sentencecn2:setPosition(left, index_y)
    main:addChild(label_sentencecn2)
    index_y = index_y - label_sentencecn2:getContentSize().height - 10

    local realHeight = height-index_y
    local layer
    if realHeight <= height then
        layer = NewReviewBossWordInfo.new()
        layer:setContentSize(s_DESIGN_WIDTH, height)

        main:setPosition(s_DESIGN_WIDTH/2, height)
        layer:addChild(main)
    else
        layer = NewReviewBossWordInfo.new()
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


return NewReviewBossWordInfo







