--
-- Author: oyhc
-- Date: 2015-12-10 15:29:31
--
-- 英雄性格表
local characterList = require(CONFIG_SRC_PRE_PATH .. "CharacterList") 

CharacterListConfig = class("CharacterListConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function CharacterListConfig:getInstance()
	if instance == nil then
		instance = CharacterListConfig.new()
	end
	return instance
end

-- 构造
function CharacterListConfig:ctor()
	-- self:init()
end

-- 初始化
function CharacterListConfig:init()
	
end

-- 获取性格
-- id
function CharacterListConfig:getCharacterByID(id)
	for k,v in pairs(characterList) do
		if id == v.cl_id then
			return v.cl_name
		end
	end
	return "无性格"
end
