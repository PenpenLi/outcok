--
-- Author: oyhc 
-- Date: 2015-12-10 20:04:36
--
-- 英雄成长表
local characterUpdata = require(CONFIG_SRC_PRE_PATH .. "CharacterUpdata") 

CharacterUpdataConfig = class("CharacterUpdataConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function CharacterUpdataConfig:getInstance()
	if instance == nil then
		instance = CharacterUpdataConfig.new()
	end
	return instance
end

-- 构造
function CharacterUpdataConfig:ctor()
	-- self:init()
end

-- 初始化
function CharacterUpdataConfig:init()
	
end

-- 获取性格成长
-- character 性格
-- level
function CharacterUpdataConfig:getCharacterUpdata(character,level)
	for k,v in pairs(characterUpdata) do
		if character == v.cu_characterid and level == v.cu_level then
			return v
		end
	end
end

-- 获取hp成长
-- character 性格
-- level
function CharacterUpdataConfig:getHPUpdata(character,level)
	local info = self:getCharacterUpdata(character,level)
	if info ~= nil then
		return info.cu_hpadd
	else
		print("获取不到性格成长")
	end
	return 0
end

-- 获取攻击成长
-- character 性格
-- level
function CharacterUpdataConfig:getAttackUpdata(character,level)
	local info = self:getCharacterUpdata(character,level)
	if info ~= nil then
		return info.cu_attackadd
	else
		print("获取不到性格成长")
	end
	return 0
end

-- 获取防御成长
-- character 性格
-- level
function CharacterUpdataConfig:getDefenceUpdata(character,level)
	local info = self:getCharacterUpdata(character,level)
	if info ~= nil then
		return info.cu_defenceadd
	else
		print("获取不到性格成长")
	end
	return 0
end

-- 获取防御成长
-- character 性格
-- level
function CharacterUpdataConfig:getMaxhp(character,level)
	local info = self:getCharacterUpdata(character,level)
	if info ~= nil then
		return info.cu_exp
	else
		print("获取不到性格成长")
	end
	return 0
end
