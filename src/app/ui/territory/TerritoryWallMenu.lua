
--[[
    jinyan.zhang
    城墙
--]]

TerritoryWallMenu = class("TerritoryWallMenu",TerritoryMenuBaseView)

--构造
--uiType UI类型
--data 数据
function TerritoryWallMenu:ctor(uiType,parent)
    self.parent = parent
    baseView = self.parent.baseView
    self.super.ctor(self,uiType)
    self:hideView()
    --详情界面
    self.detailsView = UIBaseCityOutDetailListView.new(self)
    self:addChild(self.detailsView)
    baseView:addView(self.detailsView)
    --升级界面
    self.upLevelView = WallUpLevel.new(uiType)
    self:addChild(self.upLevelView)
    baseView:addView(self.upLevelView)
    self.upLevelView:hideView()
    --加速界面
    self.acceView = WallAcceView.new(uiType)
    self:addChild(self.acceView)
    baseView:addView(self.acceView)
    self.acceView:hideView()
end

function TerritoryWallMenu:updateUI(buildingType,level,arryWall)
    --城墙列表
    self.arryWall = arryWall
    --城墙数量
    self.wallCount = #arryWall
    self.labTitle:setString(Lan:lanText(184, "城墙  LV{}", {level}))
    self:setBuildingType(buildingType)
    self:setLevel(level)
    self:updateWall()
    --有城墙在升级中
    local leftTime = TimeInfoData:getInstance():getLeftTimeByInstanceIdList(self.arryWall)
    if leftTime ~= 0 then
        self:upLevel()
        self.acceView:setBuildingIds(arryWall)
    else
        self:normal()
        if self.wallCount == 0 then
            self.btn_third:setVisible(false)
        end
    end
    self:setInstanceIds(arryWall)
end

--更新UI
function TerritoryWallMenu:updateUIByType(buildingType,level,arryWall)
    self:updateUI(buildingType,level,arryWall)
end

--更新城墙建筑
function TerritoryWallMenu:updateWall()
    self:updateBuildingPic()
    local config = OutWallConfig:getInstance():getConfig(self.level)
    if config ~= nil then
        self.labDescrp:setString(Lan:lanText(187, "防御值: {}", {config.wwe_defence}))
    end
    self.labLevel:setVisible(true)
    local unPlaceCount = #OutBuildingData:getInstance():getUnPlaceWallCount(self.level)
    local count = #OutBuildingData:getInstance():getWallCount(self.level)
    self.labLevel:setString(Lan:lanText(188, "持有数量: {}/{}块", {unPlaceCount,count}))
end

--详情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryWallMenu:onDetails(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local descrp = BuildingTypeConfig:getInstance():getBuildingDesByType(self.buildingType)
        self.detailsView:setTitle(self.detailsTitle,self.level,descrp)
        local level = Lan:lanText(144, "等级")
        local defvalue = Lan:lanText(200, "防御值")
        local list = OutWallConfig:getInstance():getConfigList()
        self.detailsView:setData({level,defvalue},list)
    end
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryWallMenu:onUpLevel(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.upLevelView:updateUI(self.buildingType,self.level,self.detailsTitle,self.wallCount)
    end
end

--建造加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryWallMenu:onAccele(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.acceView:init()
        self.baseView:showView(self.acceView)
        self.acceView:upLevelById()
    end
end


