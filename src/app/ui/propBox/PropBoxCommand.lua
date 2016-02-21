
--[[
    jinyan.zhang
    弹出框
--]]

PropBoxCommand = class("PropBoxCommand")
local instance = nil

--构造
--返回值(无)
function PropBoxCommand:ctor()
end

--获取单例
--返回值(单例)
function PropBoxCommand:getInstance()
    if instance == nil then
        instance = PropBoxCommand.new()
    end
    return instance
end

--打开提示框界面
--uiType UI类型
--data 数据
--返回值(无)
function PropBoxCommand:open(uiType,data)
	self.view = PropBoxView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.PROP)
end

--关闭提示框界面
--返回值(无)
function PropBoxCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取建筑位置
--返回值(建筑位置)
function PropBoxCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

--获取UI
--返回值(UI)
function PropBoxCommand:getView()
    return self.view
end




