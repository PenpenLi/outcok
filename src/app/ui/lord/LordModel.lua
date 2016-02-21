--
-- Author: Your Name
-- Date: 2016-01-14 17:48:10
--
LordModel = class("LordModel")

local instance = nil

--构造
--返回值(无)
function LordModel:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function LordModel:getInstance()
	if instance == nil then
		instance = LordModel.new()
	end
	return instance
end

--初始化
--返回值(无)
function LordModel:init()
	-- 战斗天赋页面列表
	self.milTechArr = {}
	-- 资源天赋页面列表
	self.gdpTechArr = {}
	-- 辅助天赋页面列表
	self.defTechArr = {}
	-- 创建科技数据
	self:createAllArr()
end

-- 创建科技数据
function LordModel:createAllArr()
	--军事
	TalentData:getInstance():createListByType(self.milTechArr, TalentDataType.mil)
	--经济
	TalentData:getInstance():createListByType(self.gdpTechArr, TalentDataType.gdp)
	--防御
	TalentData:getInstance():createListByType(self.defTechArr, TalentDataType.def)
end

--获取列表成功
function LordModel:getListSuccess(data)
	print("获取天赋列表成功:",#data.fightTalents,#data.resTalents,#data.auxTalents)
	-- 设置战斗天赋页面列表
	TalentData:getInstance():setTalentInfo(data.fightTalents,self.milTechArr)
	-- 设置资源天赋页面列表
	TalentData:getInstance():setTalentInfo(data.resTalents,self.gdpTechArr)
	-- 设置辅助天赋页面列表
	TalentData:getInstance():setTalentInfo(data.auxTalents,self.defTechArr)
end

-- 升级成功
function LordModel:upgradeTelentSuccess(data)
	print("天赋升级成功")
	-- 设置战斗天赋页面列表
	TalentData:getInstance():setTalentInfo({data.talent},self.milTechArr)
	-- 设置资源天赋页面列表
	TalentData:getInstance():setTalentInfo({data.talent},self.gdpTechArr)
	-- 设置辅助天赋页面列表
	TalentData:getInstance():setTalentInfo({data.talent},self.defTechArr)
	-- 剩余天赋点数
	PlayerData:getInstance():setTalentPoint(data.talent_point)
	--天赋是否附带技能，从TalentPacket 的 skill_id 字段来关联
	if data.skill ~= 0 then
		LordSkillData:getInstance():setLordSkillList({data.skill})
	end
	--
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.LORD)
	if uiCommand ~= nil then
		uiCommand:updataTalentUI()
	end
end

-- 重置天赋后返回结果
function LordModel:resetTalentPointSuccess(data)
	print("剩余天赋点数：",data.talent_point,data.gold)
	-- 剩余天赋点数
	-- local talentPoint = data.talent_point
	PlayerData:getInstance():setTalentPoint(data.talent_point)
	-- 金币
	PlayerData:getInstance():setPlayerGold(data.gold)
	------------数据处理------------
	--军事
	self.milTechArr = {}
	TalentData:getInstance():createListByType(self.milTechArr, TalentDataType.mil)
	--经济
	self.gdpTechArr = {}
	TalentData:getInstance():createListByType(self.gdpTechArr, TalentDataType.gdp)
	--防御
	self.defTechArr = {}
	TalentData:getInstance():createListByType(self.defTechArr, TalentDataType.def)
	--
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.LORD)
	if uiCommand ~= nil then
		uiCommand:resetTalentPoint()
	end
end

-- 修改头像成功
function LordModel:changeHeadSuccess(data)
	-- 花费类型, 1 金币， 2 物品
	local costType = data.cost_type
	-- 该次花费掉的值, 如果是金币就为金币数量， 如果是物品就为物品ID（数量默认为1）
	local cost = data.cost
end

-- 添加体力值（服务器主动推送）
function LordModel:onAddPower(data)
	-- 
	local attribType = data.attribType
	-- 
	local attribValue = data.attribValue
end

-- 成功获取领主技能列表
function LordModel:getLordSkillListSuccess(data)
	LordSkillData:getInstance():setLordSkillList(data.skills)
end

-- 使用领主技能成功
function LordModel:useLordSkillSuccess(data)
	LordSkillData:getInstance():setLordSkillInfo(data)
end

-- 领主技能持续时间结束
function LordModel:lordSkillEnd(data)
	LordSkillData:getInstance():delLordSkillTimeObjId(data)
	-- 删除技能增加的属性
end

--清理缓存
function LordModel:clearCache()
	self:init()
end
