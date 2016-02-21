
--[[
    hejun
    升级界面
--]]

BuildingUpLvCommand = class("BuildingUpLvCommand")
local instance = nil

--构造
--返回值(无)
function BuildingUpLvCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildingUpLvCommand:open(uiType,data)
    self.view = BuildingUpLvView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--更新粮食 木头等材料
function BuildingUpLvCommand:updateLable( ... )
    -- body
end

--关闭登录界面
--返回值(无)
function BuildingUpLvCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildingUpLvCommand:getInstance()
    if instance == nil then
        instance = BuildingUpLvCommand.new()
    end
    return instance
end

