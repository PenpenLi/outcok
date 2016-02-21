
--[[
	jinyan.zhang
	迁城
--]]

MoveCastleAniModel = class("MoveCastleAniModel")
local instance = nil

--构造
--返回值(无)
function MoveCastleAniModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function MoveCastleAniModel:init()
	self.isMoveCastle = false
end

--获取单例
--返回值(单例)
function MoveCastleAniModel:getInstance()
	if instance == nil then
		instance = MoveCastleAniModel.new()
	end
	return instance
end

--是否迁城
function MoveCastleAniModel:isNeedMoveCastle()
	return self.isMoveCastle
end

--设置是否迁城
function MoveCastleAniModel:setMoveCastle(isMove)
	self.isMoveCastle = isMove
	if self.isMoveCastle == true then
		SpecialTimeMgr:getInstance():createTime(9999,self.updateTime,self,TimeType.MOVE_CASTLE,1)
	else
		SpecialTimeMgr:getInstance():removeInfoByType(TimeType.MOVE_CASTLE) 
	end
end

--更新时间
function MoveCastleAniModel:updateTime(info)
	if not SceneMgr:getInstance():isAtBattle() then
		SpecialTimeMgr:getInstance():removeInfoByType(TimeType.MOVE_CASTLE) 
		UIMgr:getInstance():openUI(UITYPE.MOVE_CASTLE)
	end
end

--设置迁城数据
function MoveCastleAniModel:setMoveCastleData(data)
	if data == nil then
		return
	end
	local x = data.x
	local y = data.y
	if x == 0 or y == 0 then
		return
	end

	PlayerData:getInstance():setCastlePos(x,y)
	MoveCastleAniModel:getInstance():setMoveCastle(true)
end

--清理缓存
--返回值(无)
function MoveCastleAniModel:clearCache()
	self:init()
end


