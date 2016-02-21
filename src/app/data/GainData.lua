--
-- Author: oyhc
-- Date: 2015-12-17 22:32:06
--
GainData = class("GainData")

local instance = nil

--构造
--返回值(无)
function GainData:ctor()
    self:init()
end

--获取单例
--返回值(单例)
function GainData:getInstance()
    if instance == nil then
        instance = GainData.new()
    end
    return instance
end

--初始化
--返回值(无)
function GainData:init()
    self.gainList = {}
end

-- 创建物品列表
-- arr
function GainData:createGainList(arr)
    self.gainList = {}
    for k,v in pairs(arr) do
        local info = self:createGain(v)
        self:addItem(self.gainList,info)
    end
end

-- 创建物品
-- data
function GainData:createGain(data)
    local info = {}
    info.type = data.type            --增益类型
    info.totalTime = data.totalTime  --总时间
    info.time = data.time            --剩余时间
    info.beginTime = Common:getOSTime()
    return info
end

-- 创建物品
-- data
function GainData:createGain1(type,totalTime,time)
    local info = {}
    info.type = type            --增益类型
    info.totalTime = totalTime  --总时间
    info.time = time            --剩余时间
    info.beginTime = Common:getOSTime()
    return info
end

-- 改变或者添加增益数据
-- 类型 type
-- 总时间 totalTime
-- 剩余时间 time
function GainData:changeOrAddInfo(type,totalTime,time)
    local info = self:getInfoByType(type)
    if info ~= nil then
        --是否叠加（0：不叠加，1：叠加）
        local castleplusInfo = CastleplusListConfig:getInstance():getCastleplusListByID(type)
        if castleplusInfo.cl_over == 0 then
            info.totalTime = totalTime  --总时间
            info.time = time            --剩余时间
            info.beginTime = Common:getOSTime()
        else
            info.totalTime = totalTime + info.totalTime  --总时间
            info.time = time + info.time          --剩余时间
        end
    else
        local newInfo = self:createGain1(type,totalTime,time)
        self:addItem(self.gainList,newInfo)
    end
end

-- 根据类型增益数据
-- 类型 type
function GainData:getInfoByType(type)
    for k,v in pairs(self.gainList) do
        if v.type == type then
            return v
        end
    end
end

-- 根据类型获取剩余时间
-- 类型 type
function GainData:getLeftTimeByType(type)
    for k,v in pairs(self.gainList) do
        if v.type == type then
            return Common:getLeftTime(v.beginTime,v.time)
        end
    end
end

-- 根据类型删除增益数据
-- 类型 type
function GainData:delInfoByType(type)
    for k,v in pairs(self.gainList) do
        if v.type == type then
            print("type=",type)
            table.remove(self.gainList,k)
            break
        end
    end
end

-- 添加数据
-- list 数组
-- info 数据
function GainData:addItem(list,info)
    table.insert(list,info)
end