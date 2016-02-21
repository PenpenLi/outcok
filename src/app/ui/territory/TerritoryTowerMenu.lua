
--[[
    jinyan.zhang
    防御塔
--]]

TerritoryTowerMenu = class("TerritoryTowerMenu",TerritoryMenuBaseView)

--构造
--uiType UI类型
--data 数据
function TerritoryTowerMenu:ctor(uiType,parent)
    self.parent = parent
    local baseView = self.parent.baseView
    self.super.ctor(self,uiType,buildingType,level)
    self:hideView()
    --详情界面
    self.detailsView = UIBaseCityOutDetailListView.new(self)
    self:addChild(self.detailsView)
    baseView:addView(self.detailsView)
    --升级界面
    self.upLevelView = TowerUpLevel.new(uiType)
    self:addChild(self.upLevelView)
    baseView:addView(self.upLevelView)
    self.upLevelView:hideView()
    --加速界面
    self.acceView = TowerAcceView.new(uiType)
    self:addChild(self.acceView)
    baseView:addView(self.acceView)
    self.acceView:hideView()
end

function TerritoryTowerMenu:updateUI(buildingType,level,titleId,configType)
    self.titleId = titleId
    local strTitle = Lan:lanText(self.titleId, "", {level})
    self.labTitle:setString(strTitle)
    self:setBuildingType(buildingType)
    self:setLevel(level)
    self:updateBuilding(configType)
    self.configType = configType

    --设置建筑的实例ID
    local info = OutBuildingData:getInstance():getInfoByType(buildingType)
    if info ~= nil then
        local arry = {}
        table.insert(arry,info.id)
        self.acceView:setBuildingIds(arry)
        self:setInstanceIds(arry)
        local leftTime = TimeInfoData:getInstance():getLeftTimeByInstanceIdList(arry)
        if leftTime ~= 0 then
            self:upLevel()
        else
            self:normal() 
            local outBuildingInfo = OutPlaceBuildingData:getInstance():getInfoByType(buildingType)
            if outBuildingInfo ~= nil then
                self.btn_third:setVisible(false)
            end
        end
    end
end

--更新UI
function TerritoryTowerMenu:updateUIByType(buildingType,level)
    self:updateUI(buildingType,level,self.titleId,self.configType)
end

--更新建筑
function TerritoryTowerMenu:updateBuilding(configType)
    self:updateBuildingPic()
    local config = OutTowerEffectConfig:getInstance():getConfig(configType,self.level)
    if config ~= nil then
        local att = Lan:lanText(185, "攻击: {}", {config.wre_attack})
        local range = Lan:lanText(186, "范围: {}", {config.wre_range})
        self.labDescrp:setString(att .. "\n\n" .. range)
    end
end

--详情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryTowerMenu:onDetails(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local descrp = BuildingTypeConfig:getInstance():getBuildingDesByType(self.buildingType)
        self.detailsView:setTitle(self.detailsTitle,self.level,descrp)
        local level = Lan:lanText(144, "等级")
        local attPower = Lan:lanText(197, "攻击力")
        local range = Lan:lanText(198, "范围")
        local force = Lan:lanText(56, "战斗力")
        local list = OutTowerEffectConfig:getInstance():getConfigList(self.configType,self.buildingType)
        self.detailsView:setData({level,attPower,range,force},list)
    end
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryTowerMenu:onUpLevel(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.upLevelView:updateUI(self.buildingType,self.level,self.detailsTitle,self.configType)
    end
end

--建造加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryTowerMenu:onAccele(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.acceView:init()
        self.baseView:showView(self.acceView)
        self.acceView:upLevelById()
    end
end

