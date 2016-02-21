--
-- Author: oyhc
-- Date: 2015-12-16 16:56:29
-- 资源路径 ResPath

ResPath = class("ResPath")

local instance = nil

-- 获取单例
-- 返回值(单例)
function ResPath:getInstance()
	if instance == nil then
		instance = ResPath.new()
	end
	return instance
end

-- 构造
function ResPath:ctor()
	-- self:init()
end

-- 初始化
function ResPath:init()
	
end

-- 获取头像品种框
-- quality 品质 1为白色，2为绿色，3为蓝色，4为紫色，5为橙色
function ResPath:getHeadQualityPath(quality)
	local path = ""
	if quality == QUALITY.white then --白色
		path = "head_quality/1.png"
	elseif quality == QUALITY.green then --绿色
		path = "head_quality/2.png"
	elseif quality == QUALITY.blue then --蓝色
		path = "head_quality/3.png"
	elseif quality == QUALITY.purple then --紫色
		path = "head_quality/4.png"
	elseif quality == QUALITY.orange then --橙色
		path = "head_quality/5.png"
	end
	return path
end

-- 获取头像地址
-- id 头像id
function ResPath:getHeroHeadPath(id)
	local path = "herohead/" .. id .. ".png"
	return path
end

