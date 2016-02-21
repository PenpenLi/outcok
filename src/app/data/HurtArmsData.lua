
--[[
	jinyan.zhang
	定时器数据
--]]

HurtArmsData = class("HurtArmsData")

local instance = nil

--构造
--返回值(无)
function HurtArmsData:ctor()
	self:init()
end

--初始化
--返回值(无)
function HurtArmsData:init()
	self.armsList = {}
end

--获取单例
--返回值(单例)
function HurtArmsData:getInstance()
	if instance == nil then
		instance = HurtArmsData.new()
	end
	return instance
end

--军队列表
-- list 服务器下发的列表
function HurtArmsData:createArmsList(list)
	for k,v in pairs(list) do
		local info = self:createInfo(v)
		-- 添加到self.armsList
		self:addInfo(info)
	end
end

-- 军队列表数据
-- content 服务器下发json解析出来的数据（table）
-- 返回值 军队数据
function HurtArmsData:createInfo(content)
	local info = {}
	-- 类型ID （配置表ID）
	info.type = content.type
	-- 兵等级
	info.level = content.level
	-- 兵数量
	info.number = content.number
	-- 消耗粮食
	info.consumption = content.consumption
	-- 增加多少战力
	info.fightforce = content.fightforce
	-- 添加到self.armsList
	-- table.insert(self.armsList,info)
	return info
end

-- 根据士兵类型和等级添加数量
-- info 军队
function HurtArmsData:addInfo(info)
	table.insert(self.armsList,info)
end

--获取军队列表
function HurtArmsData:getList()
	return self.armsList
end

-- 根据士兵类型和等级获取军队
-- type 士兵类型
-- level 等级
-- 返回值 军队数据
function HurtArmsData:getInfoByTypeAndLevel(type,level)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			return v
		end
	end
end

-- 根据士兵类型和等级获取军队
-- index 数组索引
-- info 军队
function HurtArmsData:getInfoByIndex(index)
	for k,v in pairs(self.armsList) do
		if index == k then
			return v
		end
	end
end

-- 替换单个军队信息
-- info 军队
function HurtArmsData:replaceInfo(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			self.armsList[k] = info
			local config = self:getArmyTemplate(info.type,info.level)
			if config ~= nil then
				local addForce = config.aa_fightforce*v.number
				PlayerData:getInstance():increaseBattleForce(addForce)
			end
			return
		end
	end
	-- 如果arms里面找不到就添加
	self:addInfo(info)
  local config = self:getArmyTemplate(info.type,info.level)
  if config ~= nil then
      local addForce = config.aa_fightforce*info.number
      PlayerData:getInstance():increaseBattleForce(addForce)
  end
end

-- 替换单个军队信息
-- info 军队
function HurtArmsData:replaceInfoNoIncreaseBattle(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			self.armsList[k] = info
			return
		end
	end
	-- 如果arms里面找不到就添加
	self:addInfo(info)
end

-- 替换多个军队信息
-- arms 部队
-- 返回值(无)
function HurtArmsData:replaceArmsData(arms)
	for k,v in pairs(arms) do
		self:replaceInfo(v)
	end
end

-- 添加伤兵列表
-- arms 部队
-- 返回值(无)
function HurtArmsData:addArmsData(arms)
	for k,v in pairs(arms) do
		self:addInfoOrChangeNumber(v)
	end
end

-- 根据士兵类型和等级添加数量（如果要减数量要传负数）
-- info 军队数据
function HurtArmsData:addInfoOrChangeNumber(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			v.number = v.number + info.number
			return
		end
	end
	-- self.armsList 里面找不到就添加
	self:addInfo(info)
end

-- 根据士兵类型和等级删除军队
-- type 士兵类型
-- level 等级
function HurtArmsData:delInfoByTypeAndLevel(type,level)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			table.remove(self.armsList,k)
			break
		end
	end
end

--删除部队
--arms 部队数据
--返回值(无)
function HurtArmsData:delArms(arms)
	for k,v in pairs(arms) do
		self:delInfoOrChangeNumber(v.type,v.level,v.number)
	end
end

-- 根据士兵类型和等级删除军队
-- type 士兵类型
-- level 等级
-- number 数量（要减多少数量）
function HurtArmsData:delInfoOrChangeNumber(type,level,number)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			local config = self:getArmyTemplate(type,level)
			if config ~= nil then
				local loseForce = config.aa_fightforce*number
				PlayerData:getInstance():minusBattleForce(loseForce)
			end

			if number == v.number then
				table.remove(self.armsList,k)
			else
				v.number = v.number - number
			end
			break
		end
	end
end

--删除部队
--arms 部队数据
--返回值(无)
function HurtArmsData:delArmsNoChangeForce(arms)
	for k,v in pairs(arms) do
		self:delSoldierByNumber(v.type,v.level,v.number)
	end
end

-- 根据数量删除士兵
-- type 士兵类型
-- level 等级
-- number 数量（要减多少数量）
function HurtArmsData:delSoldierByNumber(type,level,number)
	for k,v in pairs(self.armsList) do
		if type == v.type and level == v.level then
			v.number = v.number - number
			if v.number <= 0 then
				self.armsList[k] = nil
			end
		    break
		end
	end
end

-- 根据士兵类型和等级删除军队
-- index 数组索引
function HurtArmsData:delInfoByIndex(index)
	for k,v in pairs(self.armsList) do
		if index == k then
			table.remove(self.armsList,k)
			break
		end
	end
end

-- 获取军队所有士兵的数量
-- 返回值 军队所有士兵的数量
function HurtArmsData:getTotalNumber()
	local num = 0
	for k,v in pairs(self.armsList) do
		num = num + v.number
	end
	return num
end

-- 根据士兵类型和等级获取军队数量
-- type 士兵类型
-- level 等级
-- 返回值 士兵的数量
function HurtArmsData:getNumberByTypeAndLevel(type,level)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			return v.number
		end
	end
	return 0
end

--获取士兵列表(5种职业士兵)
function HurtArmsData:getSoldierArmsList()
	local arry = {}
	for k,v in pairs(self.armsList) do
		if v.type <= 5 then 
			table.insert(arry,v)
		end
	end
	return arry
end

--清理缓存数据
--返回值(无)
function HurtArmsData:clearCache()
	self:init()
end



