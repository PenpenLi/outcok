
--[[
	jinyan.zhang
	检测障碍物
--]]

CheckObstacle = class("CheckObstacle")

local instance = nil

function CheckObstacle:ctor()
	self:init()
end

function CheckObstacle:init()

end

--获取单例
--返回值(单例)
function CheckObstacle:getInstance()
    if instance == nil then
        instance = CheckObstacle.new()
    end
    return instance
end

--是否有障碍物
function CheckObstacle:isHaveBlock(gridPos)
	--检测城堡
	local castleData = CastleModel:getInstance():getData()
	for k,v in pairs(castleData) do
		if v.x == gridPos.x and v.y == gridPos.y then
			return true
		end
	end

	--检测野外建筑
	local outBuildingData = OutPlaceBuildingData:getInstance():getList()
	for k,v in pairs(outBuildingData) do
		if v.x == gridPos.x and v.y == gridPos.y then
			return true
		end
	end

	return false
end

