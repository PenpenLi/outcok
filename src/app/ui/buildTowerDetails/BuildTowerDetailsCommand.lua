
--[[
    hejun
    防御塔详情界面
--]]

BuildTowerDetailsCommand = class("BuildTowerDetailsCommand")
local instance = nil

--构造
--返回值(无)
function BuildTowerDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildTowerDetailsCommand:open(uiType,data)
    self.view = BuildTowerDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildTowerDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildTowerDetailsCommand:getInstance()
    if instance == nil then
        instance = BuildTowerDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildTowerDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end