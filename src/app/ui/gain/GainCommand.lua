
--[[
    hejun
    增益界面
--]]

GainCommand = class("GainCommand")
local instance = nil

--构造
--返回值(无)
function GainCommand:ctor()

end

--打开界面
--uiType UI类型
--data 数据
--返回值(无)
function GainCommand:open(uiType,data)
    self.view = GainView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭界面
--返回值(无)
function GainCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function GainCommand:getInstance()
    if instance == nil then
        instance = GainCommand.new()
    end
    return instance
end

--更新时间UI
function GainCommand:updataTimeUI()
    if self.view ~= nil then
        self.view.GainDetails:updataTimeUI()
    end
end

--购买增益物品
function GainCommand:autoUseItem(templateId)
    if self.view ~= nil then
        self.view.GainDetails:autoUseItem(templateId)
    end
end