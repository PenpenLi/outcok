
--[[
	jinyan.zhang
	公共消息处理
--]]

GameServer = class("GameServer")

local instance = nil

function GameServer:init()
	
end

--获取单例
--返回值(单例)
function GameServer:getInstance()
    if instance == nil then
        instance = GameServer.new()
    end
    return instance
end

GameServer:getInstance():init()
