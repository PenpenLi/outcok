--
-- Author: Your Name
-- Date: 2015-12-16 16:07:32
-- 头像表
local heroFace = require(CONFIG_SRC_PRE_PATH .. "HeroFace")

HeroFaceConfig = class("HeroFaceConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function HeroFaceConfig:getInstance()
	if instance == nil then
		instance = HeroFaceConfig.new()
	end
	return instance
end

-- 构造
function HeroFaceConfig:ctor()
	-- self:init()
end

-- 初始化
function HeroFaceConfig:init()

end

--
function HeroFaceConfig:getItemTemplate()
	return heroFace
end

-- 根据id获取头像
-- id
function HeroFaceConfig:getHeroFaceByID(id)
	if id == 0 then
		print("找不到英雄头像模板")
		id = 1
	end

	for k,v in pairs(heroFace) do
		if v.hf_id == id then
			return v.hf_icon
		end
	end	
	print("找不到英雄头像模板")
end
