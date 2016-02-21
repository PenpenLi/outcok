--
-- Author: oyhc
-- Date: 2015-12-04 15:50:43
--
BagCommand = class("BagCommand")
local instance = nil

--构造
--返回值(无)
function BagCommand:ctor()
end

--获取单例
--返回值(单例)
function BagCommand:getInstance()
    if instance == nil then
        instance = BagCommand.new()
    end
    return instance
end

--打开提示框界面
--uiType UI类型
--data 数据
--返回值(无)
function BagCommand:open(uiType,data)
	self.view = BagView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭提示框界面
--返回值(无)
function BagCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--
--返回值(无)
function BagCommand:updateList()
	if self.view ~= nil then
        -- 获取切换的数据
        self.view.model:getSlectList()
		self.view:createList()
	end
end
