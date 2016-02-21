
--[[
	jinyan.zhang
	创建动画方法类
--]]

CreateAnimation = class("CreateAnimation")

local instance = nil

function CreateAnimation:ctor()
	self:init()
end

function CreateAnimation:init()
	-- body
end

--获取单例
--返回值(单例)
function CreateAnimation:getInstance()
	if instance == nil then
		instance = CreateAnimation.new()
	end
	return instance
end

--创建动画
--params 配置
function CreateAnimation:create(params)
	--创建精灵
	local fileName = "#" .. params.name .. params.defaultFileName
	local sprite = display.newSprite(fileName)
	sprite:setAnchorPoint(0.5,0.5)
	sprite:setPosition(0, 0)

	local anmation = AnmationHelp:getInstance():createAnmation(params.name,params.begin,
																params.count,params.time)
	AnmationHelp:playAnmationForver(anmation,sprite)

	return sprite
end



