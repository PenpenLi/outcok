
--[[
    jinyan.zhang
    城外城墙配置
--]]

OutWallConfig = class("OutWallConfig")
local instance = nil

local WildwallEffectTab = require(CONFIG_SRC_PRE_PATH .. "WildwallEffect") 

--构造
--返回值(无)
function OutWallConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function OutWallConfig:init()

end

--获取单例
--返回值(单例)
function OutWallConfig:getInstance()
    if instance == nil then
        instance = OutWallConfig.new()
    end
    return instance
end

function OutWallConfig:getConfig(level)
    for k,v in pairs(WildwallEffectTab) do
        if v.wwe_level == level then
            return v
        end
    end
end

function OutWallConfig:getConfigList()
    local arry = {}
    for k,v in pairs(WildwallEffectTab) do
        table.insert(arry,{v.wwe_level,v.wwe_defence})
    end
    table.sort(arry,function(a,b) return a[1] < b[1] end)
    return arry
end



