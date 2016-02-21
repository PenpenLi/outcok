--
-- Author: oyhc
-- Date: 2015-12-17 22:39:32
--
-- 物品表
local equipList = require(CONFIG_SRC_PRE_PATH .. "EquipList") 

EquipConfig = class("EquipConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function EquipConfig:getInstance()
	if instance == nil then
		instance = EquipConfig.new()
	end
	return instance
end

-- 构造
function EquipConfig:ctor()
	-- self:init()
end

-- 初始化
function EquipConfig:init()
	
end

-- 
function EquipConfig:getEquipTemplate()
	return equipList
end

-- 根据id获取物品模板
-- templateId 
function EquipConfig:getEquipTemplateByID(templateId)
	for k,v in pairs(equipList) do
		if v.el_id == templateId then
			return v
		end
	end
end

-- 获取装备属性列表
function EquipConfig:getEquipAttributeList(templateId)
	local info = self:getEquipTemplateByID(templateId)
	local arr = {}
	if info.el_attack ~= 0 then --增加攻击力
		self:addItem(arr, {name = "攻击力：", value = "+" .. info.el_attack})
	end
	if info.el_defence ~= 0 then --增加防御力
		self:addItem(arr, {name = "防御力：", value = "+" .. info.el_defence})
	end
	if info.el_hp ~= 0 then --增加最大血量
		self:addItem(arr, {name = "最大血量：", value = "+" .. info.el_hp})
	end
	if info.el_footmanattack ~= 0 then --增加步兵攻击百分比
		self:addItem(arr, {name = "步兵攻击：", value = "+" .. (info.el_footmanattack * 100).."％"})
	end
	if info.el_footmandefence ~= 0 then --增加步兵防御百分比
		self:addItem(arr, {name = "步兵防御：", value = "+" .. (info.el_footmandefence * 100).."％"})
	end
	if info.el_footmanhp ~= 0 then --增加步兵最大血量百分比
		self:addItem(arr, {name = "步兵最大血量：", value = "+" .. (info.el_footmanhp * 100).."％"})
	end
	if info.el_cavalryattack ~= 0 then --增加骑兵攻击百分比
		self:addItem(arr, {name = "骑兵攻击：", value = "+" .. (info.el_cavalryattack * 100).."％"})
	end
	if info.el_cavalrydefence ~= 0 then --增加骑兵防御百分比
		self:addItem(arr, {name = "骑兵防御：", value = "+" .. (info.el_cavalrydefence * 100).."％"})
	end
	if info.el_cavalryhp ~= 0 then --增加骑兵最大血量百分比
		self:addItem(arr, {name = "骑兵最大血量：", value = "+" .. (info.el_cavalryhp * 100).."％"})
	end
	if info.el_archerattack ~= 0 then --增加弓兵攻击百分比
		self:addItem(arr, {name = "弓兵攻击：", value = "+" .. (info.el_archerattack * 100).."％"})
	end
	if info.el_archerdefence ~= 0 then --增加弓兵防御百分比
		self:addItem(arr, {name = "弓兵防御：", value = "+" .. (info.el_archerdefence * 100).."％"})
	end
	if info.el_archerhp ~= 0 then --增加弓兵最大血量百分比
		self:addItem(arr, {name = "弓兵最大血量：", value = "+" .. (info.el_archerhp * 100).."％"})
	end
	if info.el_magicattack ~= 0 then --增加法师攻击百分比
		self:addItem(arr, {name = "法师攻击：", value = "+" .. (info.el_magicattack * 100).."％"})
	end
	if info.el_magicdefence ~= 0 then --增加法师防御百分比
		self:addItem(arr, {name = "法师防御：", value = "+" .. (info.el_magicdefence * 100).."％"})
	end
	if info.el_magichp ~= 0 then --增加法师最大血量百分比
		self:addItem(arr, {name = "法师最大血量：", value = "+" .. (info.el_magichp * 100).."％"})
	end
	if info.el_tankattack ~= 0 then --增加战车攻击百分比
		self:addItem(arr, {name = "战车攻击：", value = "+" .. (info.el_tankattack * 100).."％"})
	end
	if info.el_tankdefence ~= 0 then --增加战车防御百分比
		self:addItem(arr, {name = "战车防御：", value = "+" .. (info.el_tankdefence * 100).."％"})
	end
	if info.el_tankhp ~= 0 then --增加战车最大血量百分比
		self:addItem(arr, {name = "战车最大血量：", value = "+" .. (info.el_tankhp * 100).."％"})
	end
	if info.el_weight ~= 0 then --增加兵种负重百分比
		self:addItem(arr, {name = "部队负重：", value = "+" .. (info.el_weight * 100).."％"})
	end
	if info.el_speed ~= 0 then --增加行军速度百分比
		self:addItem(arr, {name = "行军速度：", value = "+" .. (info.el_speed * 100).."％"})
	end
	-- if info.el_fight ~= 0 then --增加战斗力
	-- 	self:addItem(arr, {name = "战斗力：", value = "+" .. info.el_fight})
	-- end
	return arr
end

-- 添加数据
-- list 数组
-- info 数据
function EquipConfig:addItem(list,info)
	table.insert(list,info)
end
