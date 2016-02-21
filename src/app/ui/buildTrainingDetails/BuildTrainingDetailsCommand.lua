
--[[
    hejun
    训练场详情界面
--]]

BuildTrainingDetailsCommand = class("BuildTrainingDetailsCommand")
local instance = nil

--构造
--返回值(无)
function BuildTrainingDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildTrainingDetailsCommand:open(uiType,data)
    self.view = BuildTrainingDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildTrainingDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildTrainingDetailsCommand:getInstance()
    if instance == nil then
        instance = BuildTrainingDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildTrainingDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end