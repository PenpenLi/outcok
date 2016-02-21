
--[[
	jinyan.zhang
	定时器管理器
--]]

TimeMgr = class("TimeMgr",function()
    return display.newLayer()
end)

local instance = nil

local scheduler = require("framework.scheduler")

--构造
--返回值(无)
function TimeMgr:ctor()
    self:setNodeEventEnabled(true)
    self:init()
end

--初始化
--返回值(无)
function TimeMgr:init()
    self.timeList = {}
end

--加入到舞台后会调用这个接口
--返回值(无)
function TimeMgr:onEnter()
	--MyLog("TimeMgr onEnter()")
    self:openTime()
end

--离开舞台后会调用这个接口
--返回值(无)
function TimeMgr:onExit()
	--MyLog("TimeMgr onExit()")
    self:stopTime()
end

--从内存释放后会调用这个接口
--返回值(无)
function TimeMgr:onDestroy()
	--MyLog("TimeMgr onDestroy()")
end

--获取单例
--返回值(单例)
function TimeMgr:getInstance()
    if instance == nil then
        instance = TimeMgr.new()
    end
    return instance
end

--打开定时器
--返回值(无)
function TimeMgr:openTime()
    if self.handle ~= nil then
        return
    end
    self:stopTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.updateTime), 1)
end

--停止定时器
--返回值(无)
function TimeMgr:stopTime()
    if self.handle ~= nil then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

--清空定时器列表
--返回值(无)
function TimeMgr:clearTimeList()
    self.timeList = {}
end

--摧毁定时器
--返回值(无)
function TimeMgr:destroyTime()
    self:clearTimeList()
    self:stopTime()
end

--添加信息至定时器
--obj 回调对象
--callback 回调
--info 信息
--infoType 信息类型
--id
--返回值(无)
function TimeMgr:addInfo(infoType,info,id,callback,obj,callTime)
    local timeInfo = {}
    timeInfo.obj = obj
    timeInfo.callback = callback
    timeInfo.infoType = infoType
    timeInfo.info = info
    timeInfo.pause = false
    timeInfo.id = id
    timeInfo.callTime = callTime
    table.insert(self.timeList,timeInfo)
end

--查找某种类型的定时器信息
--infoType 信息类型
--id
--返回值(定时器信息)
function TimeMgr:findTypeInfo(infoType,id)
    local list = {}
    for k,v in pairs(self.timeList) do
        if v.infoType == infoType and id == v.id then
            table.insert(list,v)
            break
        end
    end
    return list
end

--删除信息
--infoType 信息类型
--id
--返回值(无)
function TimeMgr:removeInfo(infoType,id)
    for k,v in pairs(self.timeList) do
        if v.infoType == infoType and id == v.id then
            self.timeList[k] = nil
            break
        end
    end
end

--删除信息
--infoType 信息类型
--id
--返回值(无)
function TimeMgr:removeInfoByType(timeType)
    for k,v in pairs(self.timeList) do
        if v.infoType == timeType then
            self.timeList[k] = nil
        end
    end
end

--暂停计时某种类型的定时器信息
--infoType 信息类型
--id
--返回值(无)
function TimeMgr:pauseTimeTypeInfo(infoType,id)
    local list = self:findTypeInfo(infoType,id)
    for k,v in pairs(list) do
        v.pause = true
    end
end

--恢复计时某种类型的定时器信息
--infoType 信息类型
--id
--返回值(无)
function TimeMgr:resumeTimeTypeInfo(infoType,id)
    local list = self:findTypeInfo(infoType,id)
    for k,v in pairs(list) do
        v.pause = false
    end
end

--查找某种类型的定时器信息
--infoType 信息类型
--index 下标
--id
--返回值(定时器信息)
function TimeMgr:findTypeInfoByIndex(infoType,index,id)
    for k,v in pairs(self.timeList) do
        if v.infoType == infoType and v.info.index == index and v.id == id then
            return v
        end
    end
end

--删除某种类型的定时器信息
--infoType 信息类型
--index 下标
--id
--返回值(无)
function TimeMgr:removeTypeInfoByIndex(infoType,index,id)
    for k,v in pairs(self.timeList) do
        if v.infoType == infoType and v.info.index == index and v.id == id then
            table.remove(self.timeList,k)
            break
        end
    end
end

--暂停计时某种类型的定时器信息
--infoType 信息类型
--index 下标
--id
--返回值(无)
function TimeMgr:pauseTimeTypeInfoByIndex(infoType,index,id)
    local info = self:findTypeInfoByIndex(infoType,index,id)
    info.pause = true
end

--恢复计时某种类型的定时器信息
--infoType 信息类型
--index 下标
--返回值(无)
function TimeMgr:resumeTimeTypeInfoByIndex(infoType,index,id)
    local info = self:findTypeInfoByIndex(infoType,index,id)
    info.pause = true
end

--更新时间
--dt 时间
--返回值(无)
function TimeMgr:updateTime(dt)
	for k,v in pairs(self.timeList) do
        if v.pause == false then
            v.time = v.time or 0
            v.time = v.time + 1
            if v.info.time ~= nil then
                v.info.time = v.info.time - 1
                if v.info.time < 0 then
                    v.info.time = 0
                end
            end
        end

        if v.pause == false and v.callback then
            if v.callTime == nil then  --每秒钟调用一次
                v.callback(v.obj,v.info)
            else  -- 一段时间调用一次
                if v.time >= v.callTime then
                    v.callback(v.obj,v.info)
                    v.time = 0
                end
            end
        end
    end
end

--创建定时器
function TimeMgr:createTime(leftTime,callback,obj,timeType,id,data,callTime)
    if leftTime == nil or callback == nil then
        return
    end
    timeType = timeType or TimeType.COMMON
    id = id or 1

    local timeInfo = self:findTypeInfoByIndex(timeType,id,1)
    if timeInfo ~= nil then
        timeInfo.pause = false
        timeInfo.info.time = leftTime
        timeInfo.callTime = callTime
        return timeInfo
    else
        local info = {}
        info.index = 1
        info.time = leftTime
        info.id = id
        info.obj = obj
        info.timeType = timeType
        info.data = data
        self:addInfo(timeType, info, id,callback, obj,callTime)
    end
end











