
MMUISprite = class("MMUISprite")

local instance = nil

function MMUISprite:ctor()
	self:init()
end

function MMUISprite:init()
	
end

--获取单例
--返回值(单例)
function MMUISprite:getInstance()
	if instance == nil then
		instance = MMUISprite.new()
	end
	return instance
end

-- path 图片路径 
-- callback 回调
function MMUISprite:create(path,callback,obj)
	if path == nil then
		return
	end

	local imgType = ccui.TextureResType.localType
	local pos = string.find(path,"#")
	if pos ~= nil then
		path = string.gsub(path,"#","",1)
		imgType = ccui.TextureResType.plistType
	end

	local sprite = ccui.ImageView:create()
    sprite:loadTexture(path,imgType)
    sprite:setTouchEnabled(true)
    if callback ~= nil then
    	sprite:addTouchEventListener(function(sender,eventType)
    		if eventType == ccui.TouchEventType.ended then
    			callback(obj,sprite,eventType)
		    end
    	end)
    end

    return sprite
end

-- 创建灰色可点击Sprite
-- path 图片路径 
-- callback 回调
function MMUISprite:createGray(path,callback,obj)
	local sprite = self:create(path,callback,obj)
    InvokeLuaMgr:getInstance():setGrap(sprite)
    return sprite
end
