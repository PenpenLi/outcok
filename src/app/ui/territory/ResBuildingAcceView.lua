
--[[
	jinyan.zhang
	资源建筑加速UI
--]]

ResBuildingAcceView = class("ResBuildingAcceView",AccelerationBase)

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function ResBuildingAcceView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.baseView:showView(self:getParent())
    end
end

 

