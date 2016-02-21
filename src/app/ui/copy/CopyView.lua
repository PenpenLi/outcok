--[[
    hejun
    副本界面
--]]

CopyView = class("CopyView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function CopyView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function CopyView:init()
    self.root = Common:loadUIJson(INSTANCE_HEAD)
    self:addChild(self.root)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    self.titleLab = Common:seekNodeByName(self.root,"instanceLab")

    self.copyListPan = Common:seekNodeByName(self.root,"Panel_1")
    self.copyInfoPan = Common:seekNodeByName(self.root,"Panel_2")
    self.monsterListPan = Common:seekNodeByName(self.root,"monsterInformationPanel")
    self.dropListPan = Common:seekNodeByName(self.root,"goodsPanel")

    self:createCheckpointList()

    if self.data ~= nil and self.data.copyIndex ~= nil then
       self:showCopyInfoPan(self.data.copyIndex)
    end
end

--显示副本介绍界面
--copyIndex 第几个副本
--返回值(无)
function CopyView:showCopyInfoPan(copyIndex)
    self.copyInfoPan:setVisible(true)
    self.copyListPan:setVisible(false)

    local copyConifg = CopyMapConfig:getInstance():getConfig()
    self.copyId = copyConifg[copyIndex].cm_id
    self.copyIndex = copyIndex

    --名称
    local titleLab = Common:seekNodeByName(self.copyInfoPan,"titleLab")
    titleLab:setString(copyConifg[copyIndex].cm_name)
    --关闭
    local closeBtn = Common:seekNodeByName(self.copyInfoPan,"closeBtn")
    closeBtn:addTouchEventListener(handler(self,self.closeCallback))
    --副本剧情介绍
    local stroyLab = Common:seekNodeByName(self.copyInfoPan,"copyStoryLab")
    stroyLab:setString(copyConifg[copyIndex].cm_description)
    --需求等级
    local needLvLab = Common:seekNodeByName(self.copyInfoPan,"lvLab")
    needLvLab:setString(CommonStr.NEED_LV .. ": " .. copyConifg[copyIndex].cm_lv)
    --副本状态
    local copyStateLab = Common:seekNodeByName(self.copyInfoPan,"consumptionLab")
    local passCount = CopyModel:getInstance():getPassCount()
    if copyIndex <= passCount then
        copyStateLab:setString(CommonStr.COPY_STATE .. ": " .. CommonStr.HAVE_ATT_SCCU)
    else
        copyStateLab:setString(CommonStr.COPY_STATE .. ": " .. CommonStr.UN_ATT_SCCU)
    end
     --体力
    local powerLab = Common:seekNodeByName(self.copyInfoPan,"typeLab")
    powerLab:setString(CommonStr.CAST_POWER .. ": " .. copyConifg[copyIndex].cm_energy)
    --掉落物品
    local dropGoodLab = Common:seekNodeByName(self.copyInfoPan,"dropItemsLab")
    dropGoodLab:setString(CommonStr.DROP_GOOD)
    --怪物信息
    local monsterInfoLab = Common:seekNodeByName(self.copyInfoPan,"monsterInformationLab")
    monsterInfoLab:setString(CommonStr.MONSTER_INFO)
    --出征按钮
    local goBattleBtn = Common:seekNodeByName(self.copyInfoPan,"attackBtn")
    goBattleBtn:addTouchEventListener(handler(self,self.goBattleCallback))

    --怪物列表
    local monsterList = MonsterListConfig:getInstance():getMonsterList(copyConifg[copyIndex].cm_map)
    self:createMonsterList(monsterList)

    self:createDropList()
end

--创建掉落物品
--返回值(无)
function CopyView:createDropList()
    if self.dropList ~= nil then
        self.dropList:removeFromParent()
        self.dropList = nil
    end

    local dropItems = DropListConfig:getInstance():getDropItems(self.copyId)
    if #dropItems == 0 then
        return
    end

    self.dropList = cc.ui.UIListView.new {
        bgColor = cc.c4b(255, 0, 0, 0),
        viewRect = cc.rect(0, 0, 750, self.dropListPan:getContentSize().height),
        direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
    }
    self.dropListPan:addChild(self.dropList)
    self.dropListPan:setTouchEnabled(false)

    for i=1,#dropItems do
        local itemId = dropItems[i]
        local item = self.dropList:newItem()
        local content = display.newCutomColorLayer(cc.c4b(0,255,0,0),200,self.dropListPan:getContentSize().height)
        content:setContentSize(200, self.dropListPan:getContentSize().height)
        item:addContent(content)
        item:setItemSize(200, self.dropListPan:getContentSize().height)
        self.dropList:addItem(item)

        local node =  MMUISimpleUI:getInstance():getItmeById(itemId)
        node:setScale(0.6)
        content:addChild(node)
        node:setPosition(10,20)
        node:setTouchEnabled(false)
    end
    self.dropList:reload()
end

--创建怪物列表
--data 数据
--返回值(无)
function CopyView:createMonsterList(data)
    if self.monsterList ~= nil then
        self.monsterList:removeFromParent()
    end

    self.monsterList = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 128),
        viewRect = cc.rect(0, 0, 750, self.monsterListPan:getContentSize().height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.monsterListPan:addChild(self.monsterList)
    self.monsterListPan:setTouchEnabled(false)

    for i=1,#data do
        local item = self.monsterList:newItem()
        local content = display.newCutomColorLayer(cc.c4b(0,255,0,0),750,150)
        content:setContentSize(750, 150)
        item:addContent(content)
        item:setItemSize(750, 150)
        self.monsterList:addItem(item)

        --头像
        local headImg = display.newSprite("test/cityAddBtn.png")
        content:addChild(headImg)
        headImg:setPosition(100, 100)

        --名字
        local nameLab = cc.ui.UILabel.new(
            {text = data[i].ml_name,
            size = 24,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
        nameLab:setPosition(150, 120)
        nameLab:addTo(content)

        --兵种类型
        local soldierTypeLab = cc.ui.UILabel.new(
            {text = ArmsData:getInstance():getOccupatuinName(data[i].ml_type),
            size = 24,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
        soldierTypeLab:setPosition(300, 120)
        soldierTypeLab:addTo(content)

        --等级
        local lvLab = cc.ui.UILabel.new(
            {text = "LV: " .. data[i].ml_lv,
            size = 24,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
        lvLab:setPosition(150, 65)
        lvLab:addTo(content)

        --数量
        local numLab = cc.ui.UILabel.new(
            {text = CommonStr.NUM .. data[i].ml_num,
            size = 24,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
        numLab:setPosition(300, 65)
        numLab:addTo(content)
    end
    self.monsterList:reload()
end

--显示副本列表界面
--返回值(无)
function CopyView:showCopyListPan()
    self.copyInfoPan:setVisible(false)
    self.copyListPan:setVisible(true)
end

--创建关卡列表
--返回值(无)
function CopyView:createCheckpointList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    local rect = cc.rect(0, 0, 750, 1200)
    self.listView = cc.ui.UIScrollView.new({viewRect=rect,bgColor=cc.c4b(255, 0, 0, 128)})
    self.listView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
    self.copyListPan:addChild(self.listView)

    local size = cc.size(750, 1200)
    local node = display.newCutomColorLayer(cc.c4b(0,255,0,128),size.width,size.height)
    self.listView:addScrollNode(node)

    local passCount = CopyModel:getInstance():getPassCount()
    local copyConifg = CopyMapConfig:getInstance():getConfig()
    for i=1,#copyConifg do
        local copyBtn = cc.ui.UIPushButton.new("test/cityAddBtn.png")
        node:addChild(copyBtn)
        copyBtn:setPosition(100, rect.height-i*150)
        copyBtn:onButtonClicked(function(event)
            self:showCopyInfoPan(i)
        end)

        --副本名字
        local copyNameLab = cc.ui.UILabel.new(
            {text = copyConifg[i].cm_name,
            size = 24,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
        copyNameLab:setPosition(-50, 60)
        copyNameLab:addTo(copyBtn)

        if i <= passCount then
            local passLab = cc.ui.UILabel.new(
                {text = CommonStr.HAVE_ATT_SCCU,
                size = 24,
                align = cc.ui.TEXT_ALIGN_LEFT,
                color = display.COLOR_WHITE})
            passLab:setPosition(-30, -4)
            passLab:addTo(copyBtn)
        else
            copyBtn:setTouchEnabled(false)
        end

        if i == passCount + 1 then
            copyBtn:setTouchEnabled(true)
        end
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function CopyView:onEnter()
   -- MyLog("CopyView onEnter...")
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function CopyView:onExit()
    MyLog("CopyView onExit()")
    UICommon:getInstance():setMapTouchAable(true)

end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function CopyView:onDestroy()
    --MyLog("CopyView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function CopyView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if sender == self.closeBtn then
            -- UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        else
            self:showCopyListPan()
        end
    end
end

--出征按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function CopyView:goBattleCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local copyIndex = self.copyIndex
        local copyId=self.copyId
        --local building = self.data.building
        UIMgr:getInstance():closeUI(self.uiType)
        UIMgr:getInstance():openUI(UITYPE.GO_BATTLE_CITY,{battleType=BattleType.copy,copyIndex=copyIndex,copyId=copyId})
    end
end


