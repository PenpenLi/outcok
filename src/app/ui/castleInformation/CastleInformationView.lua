--[[
    hejun
    城堡信息界面
--]]

CastleInformationView = class("CastleInformationView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function CastleInformationView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function CastleInformationView:init()
    self.root = Common:loadUIJson(CASTLE_INFORMATION)
    self:addChild(self.root)

    --主界面层容器
    self.view = Common:seekNodeByName(self.root,"Panel_1")

    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.closeCallback))

    local buildingPos = self:getBuildingPos()
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)

    --标题
    self.lbl_title = Common:seekNodeByName(self.root,"lbl_title")
    local text = Lan:lanText(17,"城堡")
    self.lbl_title:setString(text .. " " .. CommonStr.GRADE .. buildingLv)

    self:createList()
    local buildingPos = self:getBuildingPos()
end

--城堡信息列表
function CastleInformationView:createList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1200),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.gainListBG = Common:seekNodeByName(self.view,"list")
    self.gainListBG:addChild(self.listView,0)
    --
    local myCell = Common:seekNodeByName(self.root,"item")

    for i=1,4 do
        local type = 0
        local lanID = -1
        if i == 1 then
            lanID = 12
            type = BuildType.loggingField
        elseif i == 2 then
            lanID = 13
            type = BuildType.farmland
        elseif i == 3 then
            lanID = 15
            type = BuildType.ironOre
        elseif i == 4 then
            lanID = 16
            type = BuildType.illithium
        end

        local copyCell = myCell:clone()
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 180)
        cell:setPosition(0, 1200)
        self.listView:addItem(cell)
        cell:addContent(copyCell)
        --
        self:setCellInfo(copyCell,type,lanID,i)
    end
    self.listView:setTouchEnabled(true)
    self.listView:reload()
end

function CastleInformationView:setCellInfo(cell,type,lanID,index)
    local num = self:getAllTurbo(type)

    local rowBgSize = cell:getContentSize()

    local lbl_yield = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    cell:addChild(lbl_yield)
    lbl_yield:setPosition(rowBgSize.width/2 - 100,90)
    lbl_yield:setAnchorPoint(0,0.5)
    local text1 = Lan:lanText(lanID)
    lbl_yield:setString(text1 .. "  " .. num .. "/h")

    if index == 2 then
        local consume = ArmsData:getInstance():getAllCost()

        local lbl_consume = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        cell:addChild(lbl_consume)
        lbl_consume:setPosition(rowBgSize.width/2 - 100,60)
        lbl_consume:setAnchorPoint(0,0.5)
        local text1 = Lan:lanText(14,"总粮食消耗")
        lbl_consume:setString(text1 .. "  " .. consume .. "/h")
        lbl_yield:setPosition(rowBgSize.width/2 - 100,120)
    end
end

--获取总产量
--返回值()
function CastleInformationView:getAllTurbo(type)
    local num = 0
    local arr = CityBuildingModel:getInstance():getBuildListByType(type)
    for k,v in pairs(arr) do
        num = ResourcebuildingEffectConfig:getConfigInfo(type,v.level).re_yields + num
    end
    return num
end

--获取建筑物位置
--返回值(建筑位置)
function CastleInformationView:getBuildingPos()
    return self.data.building:getTag()
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function CastleInformationView:onEnter()

end

--UI离开舞台后都会调用这个接口
--返回值(无)
function CastleInformationView:onExit()

end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function CastleInformationView:onDestroy()

end

--关闭按钮回调
--返回值(无)
function CastleInformationView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end