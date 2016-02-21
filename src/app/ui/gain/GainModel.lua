--
-- Author: oyhc
-- Date: 2015-12-04 15:55:34
--
GainModel = class("GainModel")

local instance = nil

--构造
--返回值(无)
function GainModel:ctor()
    self:init()
end

--获取单例
--返回值(单例)
function GainModel:getInstance()
    if instance == nil then
        instance = GainModel.new()
    end
    return instance
end

--初始化
--返回值(无)
function GainModel:init()
    --(0正常商店购买，1增益界面购买)
    self.buyFrom = 0
end

--清理缓存
function GainModel:clearCache()
    self:init()
end


