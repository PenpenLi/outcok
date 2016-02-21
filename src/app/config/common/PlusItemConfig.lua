--
-- Author: oyhj
-- Date: 2015-12-24 15:29:31
--
-- 增益表
local plusItem = require(CONFIG_SRC_PRE_PATH .. "PlusItem")

PlusItemConfig = class("PlusItemConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function PlusItemConfig:getInstance()
    if instance == nil then
        instance = PlusItemConfig.new()
    end
    return instance
end

-- 构造
function PlusItemConfig:ctor()
    -- self:init()
end

-- 初始化
function PlusItemConfig:init()

end

-- 根据type获取增益描述
-- type
function PlusItemConfig:getPlusItemByType(type)
    local arr = {}
    for k,v in pairs(plusItem) do
        if v.pi_plusid == type then
            table.insert(arr,v)
        end
    end
    return arr
end

-- 根据templateID获取时间
-- templateID
function PlusItemConfig:getTimeByItemTemplateID(templateID)
    for k,v in pairs(plusItem) do
        if v.pi_itemid == templateID then
            return v.pi_time
        end
    end
    print("找不到物品模板为" .. templateID)
end

-- 根据templateID获取数据
-- templateID
function PlusItemConfig:getInfoByItemTemplateID(templateID)
    for k,v in pairs(plusItem) do
        if v.pi_itemid == templateID then
            return v
        end
    end
    print("找不到物品模板为" .. templateID)
end