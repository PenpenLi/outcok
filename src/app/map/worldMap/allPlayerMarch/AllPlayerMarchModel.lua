
--[[
	jinyan.zhang
	地图上所有玩家的行军数据
--]]

AllPlayerMarchModel = class("AllPlayerMarchModel")
local instance = nil
local _id = 0

--创建id
--返回值(id)
function AllPlayerMarchModel:createId()
	_id = _id + 1
	if _id > 99999 then
		_id = 1
	end
	return _id
end

--构造
--返回值(无)
function AllPlayerMarchModel:ctor()
	self:init()
end

--初始化
--返回值(无)
function AllPlayerMarchModel:init()
	self.data = {}
end

--获取单例
--返回值(单例)
function AllPlayerMarchModel:getInstance()
	if instance == nil then
		instance = AllPlayerMarchModel.new()
	end
	return instance
end

--保存行军数据
--data 数据
--返回值(无)
function AllPlayerMarchModel:setData(data)
	for k,v in pairs(data) do
		local info = {}
		--开始坐标
		info.startPos = cc.p(v.startX,v.startY)
		--结束坐标
		info.endPos = cc.p(v.endX,v.endY)
		--领主名称
		info.leaderName = v.name
		--剩余时间
		info.leftTime = v.interval
		--行军类型  0:侦查 1:攻击 2:资源援助 3:士兵援助
		info.type = v.type
		--行军状态 0:出征 1:返回
		info.state = v.status
		--行军部队id
		info.id_h = self:createId()
		info.id_l = -9232
		info.marchArmsId = {id_h = info.id_h, id_l=info.id_l}

		--步兵
		local arms = {}
		if v.footNum > 0 then
			local armsInfo = {}
			armsInfo.type = OCCUPATION.footsoldier
			armsInfo.level = 1
			armsInfo.number = v.footNum
			table.insert(arms,armsInfo)
		end

		--骑兵
		if v.cavalryNum > 0 then
			local armsInfo = {}
			armsInfo.type = OCCUPATION.cavalry
			armsInfo.level = 1
			armsInfo.number = v.cavalryNum
			table.insert(arms,armsInfo)
		end

		--弓兵
		if v.archerNum > 0 then
			local armsInfo = {}
			armsInfo.type = OCCUPATION.archer
			armsInfo.level = 1
			armsInfo.number = v.archerNum
			table.insert(arms,armsInfo)
		end

		--战车
		if v.tankNum > 0 then
			local armsInfo = {}
			armsInfo.type = OCCUPATION.tank
			armsInfo.level = 1
			armsInfo.number = v.tankNum
			table.insert(arms,armsInfo)
		end

		--战车
		if v.masterNum > 0 then
			local armsInfo = {}
			armsInfo.type = OCCUPATION.master
			armsInfo.level = 1
			armsInfo.number = v.masterNum
			table.insert(arms,armsInfo)
		end

		if #arms == 0 then
			local armsInfo = {}
			armsInfo.type = OCCUPATION.master
			armsInfo.level = 1
			armsInfo.number = 1
			table.insert(arms,armsInfo)
			info.moveSpeed = ArmsData:getInstance():getLookArmsMoveSpeed()
		else
			if info.type == OTHER_MARCH_OPTION_TYPE.reconnaissance then
				info.moveSpeed = ArmsData:getInstance():getLookArmsMoveSpeed()
			else
				info.moveSpeed = ArmsAttributeConfig:getInstance():getMarchMinSpeed(arms)
			end	
		end
		info.arms = arms

		--开始时间点
		info.beginTime = Common:getOSTime()		

    	local otherPlayerCastlePos = info.startPos

		--不是自己
		if (PlayerData:getInstance().x ~= otherPlayerCastlePos.x or PlayerData:getInstance().y ~= otherPlayerCastlePos.y) and info.leftTime > 0 then
			table.insert(self.data,info)
		end
	end

	local worldMap = MapMgr:getInstance():getWorldMap()
	if worldMap ~= nil then
		worldMap:delAllArmsButMe()
		worldMap:synArmsMarch()
	end
end

--创建一个测试用的行军数据
--返回值(无)
function AllPlayerMarchModel:createTextMarchData()
	local info = {}
	--开始坐标
	info.startPos = cc.p(PlayerData:getInstance().x,PlayerData:getInstance().y)
	--结束坐标
	info.endPos = cc.p(info.startPos.x+4,info.startPos.y+2)
	--领主名称
	info.leaderName = "aaa"
	--剩余时间
	info.leftTime = 10
	--行军类型  0:侦查 1:攻击 2:资源援助 3:士兵援助
	info.type = 0
	--行军状态 0:出征 1:返回
	info.state = 0
	--行军部队id
	info.id_h = self:createId()
	info.id_l = -9232
	info.marchArmsId = {id_h = info.id_h, id_l=info.id_l}

	local footNum = 1
	local cavalryNum  = 1
	local archerNum = 0
	local tankNum = 0
	local masterNum = 0

	--步兵
	local arms = {}
	if footNum > 0 then
		local armsInfo = {}
		armsInfo.type = OCCUPATION.footsoldier
		armsInfo.level = 1
		armsInfo.number = footNum
		table.insert(arms,armsInfo)
	end

	--骑兵
	if cavalryNum > 0 then
		local armsInfo = {}
		armsInfo.type = OCCUPATION.cavalry
		armsInfo.level = 1
		armsInfo.number = cavalryNum
		table.insert(arms,armsInfo)
	end

	--弓兵
	if archerNum > 0 then
		local armsInfo = {}
		armsInfo.type = OCCUPATION.archer
		armsInfo.level = 1
		armsInfo.number = archerNum
		table.insert(arms,armsInfo)
	end

	--战车
	if tankNum > 0 then
		local armsInfo = {}
		armsInfo.type = OCCUPATION.tank
		armsInfo.level = 1
		armsInfo.number = tankNum
		table.insert(arms,armsInfo)
	end

	--战车
	if masterNum > 0 then
		local armsInfo = {}
		armsInfo.type = OCCUPATION.master
		armsInfo.level = 1
		armsInfo.number = masterNum
		table.insert(arms,armsInfo)
	end

	if #arms == 0 then
		local armsInfo = {}
		armsInfo.type = OCCUPATION.master
		armsInfo.level = 1
		armsInfo.number = 1
		table.insert(arms,armsInfo)
		info.moveSpeed = ArmsData:getInstance():getLookArmsMoveSpeed()
	else
		if info.type == OTHER_MARCH_OPTION_TYPE.reconnaissance then
			info.moveSpeed = ArmsData:getInstance():getLookArmsMoveSpeed()
		else
			info.moveSpeed = ArmsAttributeConfig:getInstance():getMarchMinSpeed(arms)
		end
	end
	info.arms = arms

	--开始时间点
	info.beginTime = Common:getOSTime()		

	table.insert(self.data,info)

	local worldMap = MapMgr:getInstance():getWorldMap()
	if worldMap ~= nil then
		worldMap:synArmsMarch()
	end
end

--获取数据
--返回值(数据)
function AllPlayerMarchModel:getData()
	return self.data
end

--清理缓存数据
--返回值(无)
function AllPlayerMarchModel:clearCache()
	self:init()
end




