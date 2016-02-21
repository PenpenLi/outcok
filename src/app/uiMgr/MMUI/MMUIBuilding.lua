
--[[
	jinyan.zhang
	建筑控件带时间
--]]

MMUIBuilding = class("MMUIBuilding",function()
	return cc.Layer:create()
end)

function MMUIBuilding:ctor(path,plistType)
	self.imgType = plistType or ccui.TextureResType.localType
	self.path = path
	self:setNodeEventEnabled(true)
	self:init()
end

function MMUIBuilding:init()
	if self.path == nil then
		return
	end

	self.sprite = ccui.ImageView:create()
	self.sprite:loadTexture(self.path,self.imgType)
	self:addChild(self.sprite)
end

function MMUIBuilding:addTouchEventListener(callback,target)
	if callback == nil or self.sprite == nil then
		return
	end
	
	self:setTouchEnabled(true)
	self.sprite:addTouchEventListener(function(sender,eventType)
		callback(target,sender,eventType)
	end)
end 

function MMUIBuilding:setTouchEnabled(able)
	if self.sprite ~= nil then
		self.sprite:setTouchEnabled(able)
	end
end

function MMUIBuilding:onEnter()

end

function MMUIBuilding:onExit()

end

function MMUIBuilding:onDestroy()

end