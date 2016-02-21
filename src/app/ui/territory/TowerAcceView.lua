
--[[
	jinyan.zhang
	防御塔加速UI
--]]

TowerAcceView = class("TowerAcceView",AccelerationBase)

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function TowerAcceView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.baseView:showView(self:getParent())
    end
end