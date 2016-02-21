
--[[
    hejun
    集结界面
--]]

AggregationCommand = class("AggregationCommand")
local instance = nil

--构造
--返回值(无)
function AggregationCommand:ctor()

end

--打开集结界面
--uiType UI类型
--data 数据
--返回值(无)
function AggregationCommand:open(uiType,data)
    self.view = AggregationView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭集结界面
--返回值(无)
function AggregationCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function AggregationCommand:getInstance()
    if instance == nil then
        instance = AggregationCommand.new()
    end
    return instance
end

