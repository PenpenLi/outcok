--
-- Author: oyhc
-- Date: 2016-01-14 17:09:20
--
-- 科技升级列表
local talentUpgrade = require(CONFIG_SRC_PRE_PATH .. "TalentUpgrade")

TalentUpgradeConfig = class("TalentUpgradeConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function TalentUpgradeConfig:getInstance()
	if instance == nil then
		instance = TalentUpgradeConfig.new()
	end
	return instance
end

-- 构造
function TalentUpgradeConfig:ctor()
	-- self:init()
end

-- 初始化
function TalentUpgradeConfig:init()

end

-- 根据id和等级获取天赋升级模板
-- id
-- level
function TalentUpgradeConfig:getTemplateByIDAndLevel(id, level)
	for k,v in pairs(talentUpgrade) do
		if v.tu_talentid == id and v.tu_level == level then
			return v
		end
	end
	print("错误 根据id和等级获取天赋升级模板"..id,level)
end

-- 获取科技加成属性
function TalentUpgradeConfig:getTalentAttribute(info)
	-- local info = self:getTemplateByIDAndLevel(id, level)
	-- 增加士兵训练速度百分比
	if info.tu_trainsoldierspeed ~= 0 then
		return (info.tu_trainsoldierspeed * 100).."％"
	end
	-- 增加行军帐篷的训练士兵量百分比
	if info.tu_campnum ~= 0 then
		return (info.tu_campnum * 100).."％"
	end
	-- 训练英雄的资源消耗减少
	if info.tu_trainlessresource ~= 0 then
		return info.tu_trainlessresource
	end
	-- 提升行军速度的百分比
	if info.tu_armyspeed ~= 0 then
		return (info.tu_armyspeed * 100).."％"
	end
	-- 提升部队出征的数量
	-- if info.tu_armynum ~= 0 then
	-- 	return info.tu_armynum
	-- end
	-- 增加负重的百分比
	if info.tu_weight ~= 0 then
		return (info.tu_weight * 100).."％"
	end
	-- 训练英雄获得更多经验
	if info.tu_trainmoreexp ~= 0 then
		return info.tu_trainmoreexp
	end
	-- 提升急救帐篷的治疗速度百分比
	if info.tu_curespeed ~= 0 then
		return (info.tu_curespeed * 100).."％"
	end
	-- 增加攻击的目标类型，1为步兵，2为骑兵，3为弓兵，4为法师，5为战车，6为防御塔，7为陷阱，8为英雄
	-- if info.tu_addattacktarget ~= 0 then
	-- 	return info.tu_addattacktarget
	-- end
	-- 增加攻击的百分比
	if info.tu_addattack ~= 0 then
		return (info.tu_addattack * 100).."％"
	end
	-- 增加防御的目标类型，1为步兵，2为骑兵，3为弓兵，4为法师，5为战车，6为防御塔，7为陷阱，8为英雄
	-- if info.tu_adddefencetarget ~= 0 then
	-- 	return info.tu_adddefencetarget
	-- end
	-- 增加防御的百分比
	if info.tu_adddefence ~= 0 then
		return (info.tu_adddefence * 100).."％"
	end
	-- 增加血量的目标类型，1为步兵，2为骑兵，3为弓兵，4为法师，5为战车，6为防御塔，7为陷阱，8为英雄
	-- if info.tu_addhptarget ~= 0 then
	-- 	return info.tu_addhptarget
	-- end
	-- 增加血量的百分比
	if info.tu_addhp ~= 0 then
		return (info.tu_addhp * 100).."％"
	end
	-- 增加英雄带兵上限的百分比
	-- if info.tu_heroarmy ~= 0 then
	-- 	return (info.tu_heroarmy * 100).."％"
	-- end
	-- 增加资源产量的目标类型，1为城内粮食，2为城内木材，3为城内铁矿，4为城内秘银，5为城外粮食，6为城外木材，7为城外铁矿，8为城外秘银，9为城外黄金
	-- if info.tu_resourcetype ~= 0 then
	-- 	return info.tu_resourcetype
	-- end
	-- 增加资源产量的百分比
	if info.tu_resourceyield ~= 0 then
		return (info.tu_resourceyield * 100).."％"
	end
	-- 提升仓库和地窖容量的百分比
	if info.tu_storehouse ~= 0 then
		return (info.tu_storehouse * 100).."％"
	end
	-- 减少建筑建造时间百分比
	if info.tu_lessbuildtime ~= 0 then
		return (info.tu_lessbuildtime * 100).."％"
	end
	-- 提升体力恢复速度的百分比
	if info.tu_powerspeed ~= 0 then
		return (info.tu_powerspeed * 100).."％"
	end
	-- 减少科技研究时间
	if info.tu_lesstechtime ~= 0 then
		return (info.tu_lesstechtime * 100).."％"
	end
	-- 增加城内城墙的防御值的百分比
	-- if info.tu_wallinside ~= 0 then
	-- 	return (info.tu_wallinside * 100).."％"
	-- end
	-- 增加城外城墙防御值的百分比
	-- if info.tu_walloutside ~= 0 then
	-- 	return (info.tu_walloutside * 100).."％"
	-- end
	-- 减少陷阱制造时间百分比
	if info.tu_lesstrapbuild ~= 0 then
		return (info.tu_lesstrapbuild * 100).."％"
	end
	-- 增加城墙容纳陷阱数量的百分比
	-- if info.tu_moretrapinwall ~= 0 then
	-- 	return (info.tu_moretrapinwall * 100).."％"
	-- end
	-- 提升急救帐篷的士兵容量百分比
	if info.tu_moresoldiercure ~= 0 then
		return (info.tu_moresoldiercure * 100).."％"
	end
	-- 增加守军的攻击力百分比
	-- if info.tu_defenderattack ~= 0 then
	-- 	return (info.tu_defenderattack * 100).."％"
	-- end
	-- 增加守军防御力的百分比
	-- if info.tu_defenderdefence ~= 0 then
	-- 	return (info.tu_defenderdefence * 100).."％"
	-- end
	-- 转化出征部队的伤兵百分比
	-- if info.tu_turnwounded ~= 0 then
	-- 	return (info.tu_turnwounded * 100).."％"
	-- end
end
