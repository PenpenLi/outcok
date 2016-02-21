--
-- Author: oyhj
-- Date: 2015-12-24 15:29:31
--
-- 增益描述表
local castleplusList = require(CONFIG_SRC_PRE_PATH .. "CastleplusList")

CastleplusListConfig = class("CastleplusListConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function CastleplusListConfig:getInstance()
    if instance == nil then
        instance = CastleplusListConfig.new()
    end
    return instance
end

-- 构造
function CastleplusListConfig:ctor()
    -- self:init()
end

-- 初始化
function CastleplusListConfig:init()

end

-- 获取列表
function CastleplusListConfig:getList()
    return castleplusList
end

-- 根据id获取增益描述
-- id
function CastleplusListConfig:getCastleplusListByID(id)
    for k,v in pairs(castleplusList) do
        if v.cl_id == id then
            return v
        end
    end
end
