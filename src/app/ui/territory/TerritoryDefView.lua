
--[[
	jinyan.zhang
	城外守军界面
--]]

TerritoryDefView = class("TerritoryDefView",function()
    return cc.Layer:create()
end)

function TerritoryDefView:ctor(parent)
	self.parent = parent
	self:init()
end

function TerritoryDefView:init()
	self.view = Common:seekNodeByName(self.parent.root,"pan_def")
	--关闭按钮
    self.btnClose = Common:seekNodeByName(self.view,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))
    --标题
    self.labTitle = Common:seekNodeByName(self.view,"lab_title")
    self.labTitle:setString(Lan:lanText(215, "城外守军"))
    --设置守军按钮
    self.btnSet = Common:seekNodeByName(self.view,"btn_set")
    self.btnSet:addTouchEventListener(handler(self,self.onSet))
    self.btnSet:setTitleText(Lan:lanText(217, "设置守军"))
    --滚动列表
    self.scroll_list = Common:seekNodeByName(self.view,"scroll_pan")
    --列表层
    self.panContent = Common:seekNodeByName(self.scroll_list,"pan_content")
    self:createList()
end

--创建列表
function TerritoryDefView:createList()
    self.panContent:removeAllChildren()

    local size = self.panContent:getContentSize()
    local beginY = size.height
    local list = TerritoryModel:getInstance():getDefArms()
    for i=1,#list do
        local info = list[i]
        local heroId = info.heroId
        local arms = info.arms
        local hero = PlayerData:getInstance():getHeroById(heroId)
        --英雄头像
        local imgHead = MMUIHead:getInstance():getHead(hero)
        imgHead:setAnchorPoint(0,1)
        imgHead:setScale(0.5)
        self.panContent:addChild(imgHead)
        local x = 50
        local y = beginY
        imgHead:setPosition(x,y)
        y = y - imgHead:getBoundingBox().height + 60
        x = x + imgHead:getBoundingBox().width + 20
        --名字
        local labName = cc.Label:createWithSystemFont(hero.name, "Helvetica", 24)
        labName:setAnchorPoint(cc.p(0,0))
        self.panContent:addChild(labName)
        labName:setPosition(x,y)
        x = x + 110
        --可带兵数量
        local labCanHaveCount = cc.Label:createWithSystemFont("可带兵数量:222", "Helvetica", 24)
        labCanHaveCount:setAnchorPoint(cc.p(0,0))
        self.panContent:addChild(labCanHaveCount)
        labCanHaveCount:setPosition(x,y)
        labCanHaveCount:setString(Lan:lanText(226, "可带兵数量: {}", {hero:getHeroMaxSoldiers()}))
        x = x + 240
        --兵种适性
        local labAdapt = cc.Label:createWithSystemFont("", "Helvetica", 24)
        labAdapt:setAnchorPoint(cc.p(0,0))
        self.panContent:addChild(labAdapt)
        labAdapt:setPosition(x,y)
        if #arms > 0 then
            local str = hero:getSuitStr(arms[1].type)
            labAdapt:setString(str)
        end

        y = y - 50
        x = 50 + imgHead:getBoundingBox().width + 20
        --等级
        local labLevel = cc.Label:createWithSystemFont("等级:2", "Helvetica", 24)
        labLevel:setAnchorPoint(cc.p(0,0))
        self.panContent:addChild(labLevel)
        labLevel:setPosition(x,y)
        labLevel:setString("LV: " .. hero.level)
        x = x + 110
        --已带兵数量
        local haveArmsCount = cc.Label:createWithSystemFont("已带兵数量:22", "Helvetica", 24)
        haveArmsCount:setAnchorPoint(cc.p(0,0))
        self.panContent:addChild(haveArmsCount)
        haveArmsCount:setPosition(x,y)
        haveArmsCount:setString(Lan:lanText(227, "已带兵量: {}", {self:getSoldierNumber(arms)}))
        y = y - imgHead:getBoundingBox().height - 10
        --带兵列表
        for k,v in pairs(arms) do
            y = self:createSoldierImg(v.type,v.number,y)
        end
        beginY = y + 50
    end
    self:adjustSize(beginY)
end

--获取可带兵数量
function TerritoryDefView:getSoldierNumber(arms)
    local num = 0
    for k,v in pairs(arms) do
        num = v.number + num
    end
    return num
end

function TerritoryDefView:createSoldierImg(type,level,y)
    local config = ArmsAttributeConfig:getInstance():getArmyTemplate(type,level)
    if config ~= nil then
        local name = config.aa_name
        local smallPicName = "#" .. config.aa_icon .. ".png"
        --头像背景框
        local imgHeadBg = cc.Sprite:create("citybuilding/buildingbg.png")
        imgHeadBg:setAnchorPoint(cc.p(0,0.5))
        imgHeadBg:setPosition(cc.p(imgHeadBg:getBoundingBox().width/2, y))
        self.panContent:addChild(imgHeadBg)
        imgHeadBg:setScale(0.8)
        --士兵头像
        local sprite = display.newSprite(smallPicName)
        local x = imgHeadBg:getBoundingBox().width/2 + 
        (imgHeadBg:getBoundingBox().width - sprite:getBoundingBox().width)/2
        sprite:setPosition(x,imgHeadBg:getBoundingBox().height/2)
        local posY = imgHeadBg:getBoundingBox().height/2 + 
        (imgHeadBg:getBoundingBox().height - sprite:getBoundingBox().height)/2
        sprite:setPosition(x,posY)
        imgHeadBg:addChild(sprite)
        --名称
        local labName = cc.Label:createWithSystemFont(name, "Helvetica", 24)
        labName:setAnchorPoint(cc.p(0,0))
        self.panContent:addChild(labName)
        labName:setPosition(sprite:getPositionX()+sprite:getBoundingBox().width,y)
        y = y - sprite:getBoundingBox().height - 50
        return y
    end
end

--调整滚动列表大小
function TerritoryDefView:adjustSize(endY)
    MMUIAdjustScrollView:setScrollView(self.scroll_list)
    MMUIAdjustScrollView:setContentLayer(self.panContent)
    MMUIAdjustScrollView:setEndY(endY)
    MMUIAdjustScrollView:adjustHigh()
end

function TerritoryDefView:showView()
	self.view:setVisible(true)
end

function TerritoryDefView:hideView()
	self.view:setVisible(false)
end

--设置按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryDefView:onSet(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.parent:setVisible(false)
        UIMgr:getInstance():openUI(UITYPE.GO_BATTLE_CITY,{battleType=BattleType.def})
    end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryDefView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.parent.baseView:showView(self.parent)
    end
end