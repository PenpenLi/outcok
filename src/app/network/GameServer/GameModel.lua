
--[[
	jinyan.zhang
	公共数据处理
--]]

GameModel = class("GameModel")

local instance = nil

function GameModel:ctor()

end

function GameModel:init()

end

--获取单例
--返回值(单例)
function GameModel:getInstance()
    if instance == nil then
        instance = GameModel.new()
    end
    return instance
end

