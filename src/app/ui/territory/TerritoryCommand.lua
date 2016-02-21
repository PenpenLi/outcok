
--[[
    hechun
    城防领土UI
--]]

TerritoryCommand = class("TerritoryCommand")
local instance = nil

--构造
--返回值(无)
function TerritoryCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function TerritoryCommand:open(uiType,data)
    self.view = TerritoryView.new(uiType,data)
    self.view.baseView:addToLayer(GAME_ZORDER.UI)
end

--返回值(无)
function TerritoryCommand:close()
    if self.view ~= nil then
        self.view.baseView:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function TerritoryCommand:getInstance()
    if instance == nil then
        instance = TerritoryCommand.new()
    end
    return instance
end

--更新正在升级中的建筑
function TerritoryCommand:updateUpLevelUI(buildingType,upLevelTime,buildingIds)
    if self.view ~= nil then
        local upLevelView = nil
        if buildingType >= BuildType.out_farmland and    --资源田
            buildingType <= BuildType.out_goldoreField then
            upLevelView = self.view.resBuildingMenu.upLevelView
        elseif buildingType >= BuildType.out_arrowTower and  --防御塔
            buildingType <= BuildType.out_magicTower then
            upLevelView = self.view.towerMenu.upLevelView
        elseif buildingType == BuildType.out_wall then  --城墙
            upLevelView = self.view.wallMenu.upLevelView
        end
        if upLevelView and upLevelView:isShowVew() and upLevelView:getBuildingType() == buildingType then
            upLevelView:updateUpLevelUI(upLevelTime)
        end

        local menuView = upLevelView:getParent()
        if menuView and menuView:getBuildingType() == buildingType then
            menuView:updateUIByType(buildingType,menuView.level,buildingIds)
        end
    end
end

--更新完成升级的建筑
function TerritoryCommand:updateFinishUpLevelUI(buildingType,level,buildingIds)
    if self.view ~= nil then
        local upLevelView = nil
        if buildingType >= BuildType.out_farmland and    --资源田
            buildingType <= BuildType.out_goldoreField then
            upLevelView = self.view.resBuildingMenu.upLevelView
        elseif buildingType >= BuildType.out_arrowTower and  --防御塔
            buildingType <= BuildType.out_magicTower then
            upLevelView = self.view.towerMenu.upLevelView
        elseif buildingType == BuildType.out_wall then  --城墙
            upLevelView = self.view.wallMenu.upLevelView
        end
        if upLevelView and upLevelView:isShowVew() and upLevelView:getBuildingType() == buildingType then
            upLevelView:updateFinishUpLevelUI(buildingType,level)
        end
        self.view:updateUI()

        local menuView = upLevelView:getParent()
        if menuView and menuView:getBuildingType() == buildingType then
            menuView:updateUIByType(buildingType,level,buildingIds)
        end
    end
end

--更新完成升级加速UI
function TerritoryCommand:updateFinishAcceUI()
    if self.view ~= nil then
        self.view.baseView:showTopView()
        self.view:updateUI()
    end
end

--更新守军UI
function TerritoryCommand:updateDefArmsUI()
    if self.view ~= nil then
       self.view:setVisible(true)
       self.view.territoryDefView:createList()
    end
end

