
--[[
	jinyan.zhang
	城堡数据
--]]

CastleModel = class("CastleModel")
local instance = nil

--构造
--返回值(无)
function CastleModel:ctor()
	self:init()
end

--初始化
--返回值(无)
function CastleModel:init()
	self.data = {}
end

--获取单例
--返回值(单例)
function CastleModel:getInstance()
	if instance == nil then
		instance = CastleModel.new()
	end
	return instance
end

function CastleModel:getData()
	return self.data
end

--保存城堡列表数据
--data 数据
--返回值(无)
function CastleModel:setData(data)
	self.data = {}
	for k,v in pairs(data) do
		--对象类型
		local object_type = v.object_type
		if object_type == ObjType.player then  --玩家
			local info = {}
			--x网格坐标
			info.x = v.x
			--y网格坐标
			info.y = v.y
			--对象实例ID
			info.object_id = v.object_id
			--等级
			info.level = v.object_level
			--名字
			info.name = v.object_name
			table.insert(self.data,info)
		end
	end

	local worldMap = MapMgr:getInstance():getWorldMap()
    if worldMap ~= nil then
    	worldMap.castleView:delAllCastle()
    	worldMap.castleView:createCastlelList(self.data)
    end
end

--获取城堡信息
--x 坐标
--y 坐标
--mapId 地图id
--返回值(城堡信息)
function CastleModel:getCastleLvByPos(x,y,mapId)
	for k,v in pairs(self.data) do
		if v.x == x and v.y == y then
			return v
		end
	end
end

--清理缓存数据
--返回值(无)
function CastleModel:clearCache()
	self:init()
end



