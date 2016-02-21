
--[[
    jinyan.zhang
    建筑升级配置
--]]

CommonConfig = class("CommonConfig")
local instance = nil

local Config = require(CONFIG_SRC_PRE_PATH .. "Config") --建筑升级表

--构造
--返回值(无)
function CommonConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function CommonConfig:init()

end

--获取单例
--返回值(单例)
function CommonConfig:getInstance()
    if instance == nil then
        instance = CommonConfig.new()
    end
    return instance
end

--获取建筑加速系数
--返回值(系数)
function CommonConfig:getBuildingAccelerationCoefficient()
    return Config[27].value
end

function CommonConfig:getCastGold(time,coeff)
    local min = math.ceil(time/60)
    local castGold = coeff*min
    return math.ceil(castGold)
end

--获取建筑加速消耗金币
--time(时间)
--返回值(金币)
function CommonConfig:getBuildingAccelerationCastGold(time)
    local min = math.ceil(time/60)
    local castGold = self:getBuildingAccelerationCoefficient()*min
    return math.ceil(castGold)
end

--获取资源加速消耗金币
--buildingLv 建筑等级
--buildingType 建筑状态
--返回值(金币)
function CommonConfig:getAccelerationResourceCastGold(buildingLv,buildingType)
    local coeffic = 1
    if buildingType == BuildType.farmland then
        coeffic = Config[28].value
    elseif buildingType == BuildType.loggingField then
        coeffic = Config[29].value
    elseif buildingType == BuildType.ironOre then
        coeffic = Config[30].value
    elseif buildingType == BuildType.illithium then
        coeffic = Config[31].value
    end

    local castGold = coeffic * buildingLv
    return math.ceil(castGold)
end

--获取金币加速训练英雄
--返回值(初始值)
function CommonConfig:getAccGoldTrainHero(leftTime)
    local min = math.ceil(leftTime/60)
    return math.ceil(min*self:getTrainingGold())
end

--获取造兵初始数量
--返回值(初始值)
function CommonConfig:getMakeSoldierInitNum()
    return Config[35].value
end

--获取加速造兵消耗的金币
--makeTime 造兵时间
function CommonConfig:getAccelerationMakeSoldierCastGold(makeTime)
    local min = math.ceil(makeTime/60)
    return math.ceil(min*Config[36].value)
end

--获取加速创建陷井消耗的金币
--makeTime 造兵时间
function CommonConfig:getAccelerationMakeTrapCastGold(makeTime)
    local min = math.ceil(makeTime/60)
    return math.ceil(min*Config[37].value)
end

--获取加速治疗消耗的金币
--time 治疗时间
function CommonConfig:getAccelerationTreatmentCastGold(time)
    local min = math.ceil(time/60)
    return math.ceil(min*Config[25].value)
end

-- 获取招贤馆刷新时间
function CommonConfig:getResHeroTime()
    return Config[13].value
end

-- 获取聚贤庄刷新时间
function CommonConfig:getGoldHeroTime()
    return Config[14].value
end

-- 获取招贤馆刷新花费
function CommonConfig:getResHeroRefreshGold()
    return Config[15].value
end

-- 获取聚贤庄刷新花费
function CommonConfig:getGoldHeroRefreshGold()
    return Config[16].value
end

-- 获取带兵系数
function CommonConfig:getSoldierMaxnumber()
    return Config[17].value
end

-- 获取招募用粮食系数
function CommonConfig:getHireGrain()
    return Config[18].value
end

-- 获取招募用木材系数
function CommonConfig:getHireWood()
    return Config[19].value
end

-- 获取招募用金币系数
function CommonConfig:getHireGold()
    return Config[20].value
end

-- 初始英雄上限数量
function CommonConfig:getHeroMaxNum()
    return Config[21].value
end

-- 技能刷新所需金币
function CommonConfig:refreshHeroSkill()
    return Config[22].value
end

--训练场训练时间1
function CommonConfig:getTrainHeroTime1()
    return Config[39].value
end

--训练场训练时间2
function CommonConfig:getTrainHeroTime2()
    return Config[40].value
end

--训练场训练时间3
function CommonConfig:getTrainHeroTime3()
    return Config[41].value
end

--获取立即训练金币系数
function CommonConfig:getTrainingGold()
    return Config[42].value
end

--获取防御塔升级道具id
function CommonConfig:getDefTowerPropID()
    return Config[43].value
end

--获取灭火金币数量
function CommonConfig:getDelFireGold()
    return Config[44].value
end

--获取修补城墙冷却时间
function CommonConfig:getRepairWallColdTime()
    return Config[45].value
end

-- 初始出征部队数量
function CommonConfig:getBattleNum()
    return Config[50].value
end

-- 重置天赋需要的金币数量
function CommonConfig:getResetTalentGold()
    return Config[53].value
end

--获取世界地图id
function CommonConfig:getWorldMapId()
    return Config[64].value
end
