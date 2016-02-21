--
-- Author: Your Name
-- Date: 2016-01-22 20:28:07
--天赋加点界面
LordSkillOperationView = class("LordSkillOperationView")

--构造
--uiType UI类型
--data 数据
function LordSkillOperationView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_more")
    self.view:addTouchEventListener(handler(self,self.onClose))
    self:init()
end

--初始化
--返回值(无)
function LordSkillOperationView:init()
    -- 弹窗底框背景
    self.bg_img = Common:seekNodeByName(self.parent.root,"img_more")
    -- 弹窗底框下半灰色背景
    -- local bg_img2 = Common:seekNodeByName(self.parent.root,"list")
end

function LordSkillOperationView:setData(info,arr)
    --
    self.info = info
    self.bg_img:removeAllChildren()
    -- 名字
    local lbl_name = display.newTTFLabel({
        text = info.name,
        font = "Arial",
        size = 26,
        color = cc.c3b(255, 255, 255),
    })
    lbl_name:setPosition(self.bg_img:getContentSize().width / 2, self.bg_img:getContentSize().height - 30)
    lbl_name:addTo(self.bg_img)
    -- 图片
    local img = MMUISprite:getInstance():create("#"..info.icon..".png")
    img:setPosition(140, self.bg_img:getContentSize().height - 150)
    img:addTo(self.bg_img)
    -- 说明
    local lbl_des = display.newTTFLabel({
        text = info.des,
        font = "Arial",
        size = 26,
        color = cc.c3b(255, 255, 255),
    })
    lbl_des:setPosition(430, self.bg_img:getContentSize().height - 150)
    lbl_des:addTo(self.bg_img)
    lbl_des:setWidth(380)
    lbl_des:setHeight(35)
    if info.level == info.maxlv then
        -- 满级
        self:fullTakent(info)
    else
        local canLearn = true
        for i=1,#info.beforeArr do
            local v = info.beforeArr[i]
            -- 条件的数据
            local talentInfo = TalentData:getInstance():getInfoByID(arr, v.id)
            if talentInfo.level >= v.level then
                canLearn = true
                break
            else
                canLearn = false
            end
        end
        -- 判断是否有学习条件
        if canLearn == true then
            self:learnTakent(info)
        else
            self:canNotLearn(info)
        end
        
    end
end

-- 能学习的天赋
-- 天赋数据
function LordSkillOperationView:learnTakent(info)
    -- 当前等级
    local lbl_level = display.newTTFLabel({
        text = Lan:lanText(206,"当前等级：") .. info.level,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 255, 255),
    })
    lbl_level:setPosition(150, 260)
    lbl_level:addTo(self.bg_img)
    -- 是不是天赋技能判断
    if info.maxlv ~= 1 then
        -- 下一等级
        local lbl_nextLevel = display.newTTFLabel({
            text = Lan:lanText(207,"下一等级：") .. (info.level + 1),
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255),
        })
        lbl_nextLevel:setPosition(480, 260)
        lbl_nextLevel:addTo(self.bg_img)
        -- 效果
        local lbl_att = display.newTTFLabel({
            text = Lan:lanText(208,"效果：")..info.gain,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255),
        })
        lbl_att:setPosition(150, 200)
        lbl_att:addTo(self.bg_img)
        -- 下一等级效果
        local lbl_nextAtt = display.newTTFLabel({
            text = Lan:lanText(208,"效果：")..info.nextLevelGain,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255),
        })
        lbl_nextAtt:setPosition(480, 200)
        lbl_nextAtt:addTo(self.bg_img)
    else
        lbl_level:setPosition(self.bg_img:getContentSize().width / 2, 220)
    end
    -- 学习
    local btn_learn = ccui.Button:create("")
    btn_learn:loadTextureNormal("btn_blue.png",ccui.TextureResType.plistType)
    btn_learn:setTitleFontSize(26)
    btn_learn:setTitleText(Lan:lanText(209,"学习"))
    btn_learn:setPosition(self.bg_img:getContentSize().width / 2, 90)
    btn_learn:addTo(self.bg_img)
    btn_learn:addTouchEventListener(handler(self,self.onLearn))
end

-- 满级的天赋
-- 天赋数据
function LordSkillOperationView:fullTakent(info)
    -- 当前等级
    local lbl_level = display.newTTFLabel({
        text = Lan:lanText(206,"当前等级：") .. info.level,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 255, 255),
    })
    lbl_level:setPosition(self.bg_img:getContentSize().width / 2, 260)
    lbl_level:addTo(self.bg_img)
    -- 是不是天赋技能判断
    if info.maxlv ~= 1 then
        -- 效果
        local lbl_att = display.newTTFLabel({
            text = Lan:lanText(208,"效果：")..info.gain,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255),
        })
        lbl_att:setPosition(self.bg_img:getContentSize().width / 2, 200)
        lbl_att:addTo(self.bg_img)
    else
        lbl_level:setPosition(self.bg_img:getContentSize().width / 2, 220)
    end
end

-- 不能学习的天赋
-- 天赋数据
function LordSkillOperationView:canNotLearn(info)
    -- 效果
    local lbl_att = display.newTTFLabel({
        text = Lan:lanText(210,"满足任意条件中的一个即可解锁当前天赋"),
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 0, 0),
    })
    lbl_att:setPosition(self.bg_img:getContentSize().width / 2, 280)
    lbl_att:addTo(self.bg_img)

    local totalW = #info.beforeArr * 150
    --
    local myLayer = cc.Layer:create()
    myLayer:setContentSize(cc.size(totalW, 150))
    myLayer:setAnchorPoint(0, 0.5)
    myLayer:setPosition((self.bg_img:getContentSize().width - totalW) / 2, 80)
    myLayer:addTo(self.bg_img)

    for i=1,#info.beforeArr do
        local v = info.beforeArr[i]
        -- 图片
        local img = MMUISprite:getInstance():create("#"..v.icon..".png")
        img:setAnchorPoint(0, 0.5)
        img:setPosition((i - 1) * 150, 90)
        img:addTo(myLayer)
        -- 当前等级
        local lbl_level = display.newTTFLabel({
            text = Lan:lanText(144,"等级：") .. v.level,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 0, 0),
        })
        lbl_level:setPosition((i - 1) * 150 + 70, 0)
        lbl_level:addTo(myLayer)
    end
end

-- 学习
function LordSkillOperationView:onLearn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("学习天赋",self.info.id,self.info.level + 1)
        if PlayerData:getInstance():getTalentPoint() > 0 then
            LordService:getInstance():sentUpgradeTalent(self.info.id,self.info.level + 1)
        else
            Lan:hintClient(12,"天赋点数不足")
        end
        
    end
end

--关闭按钮回调
function LordSkillOperationView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 隐藏自己
        self:hideView()
    end
end

-- 显示界面
function LordSkillOperationView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function LordSkillOperationView:hideView()
    self.view:setVisible(false)
end
