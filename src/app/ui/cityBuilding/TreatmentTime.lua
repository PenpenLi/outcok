
--[[
    hejun
    治疗倒计时
--]]

TreatmentTime = class("TreatmentTime")
local instance = nil

local upAndCreateProcessTag = 1111  --升级或建造建筑的进度条tag
local upAndCreateProcessZorder = 4   --升级或者建筑的进度条层级

local upAndCreateProcessBgPath = "test/expbase.png"  --升级或者创建建筑的进度背景路径
local upAndCreateProcessPath = "test/expbar.png"     --升级或者创建建筑的进度条路径


--构造
--返回值(无)
function TreatmentTime:ctor(parent)
    self.parent = parent
    self:init()
end

function TreatmentTime:init()
    self.data = {}
end

--刷新UI
--buildingList 建筑列表
--返回值(无)
function TreatmentTime:updateUI(buildingList)
    self:delTime()

    local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
    if timeInfo == nil then
        return
    end

    local leftTime = Common:getLeftTime(timeInfo.start_time,timeInfo.interval)
    if leftTime == 0 then
        return
    end

    for k,v in pairs(buildingList) do
        self:createProcess(v.buildingImg,k,leftTime)
    end
end

--创建进度条
--buildingImg 建筑图片
--index 第几个建筑
--返回值(无)
function TreatmentTime:createProcess(buildingImg,index,leftTime)
    local parent = buildingImg:getParent()
    local x,y = buildingImg:getPosition()
    local pos = cc.p(x,y-50)

    local processBg = UICommon:getInstance():createProgress(leftTime,parent,upAndCreateProcessBgPath,upAndCreateProcessPath,pos,cc.p(37,3),upAndCreateProcessZorder,upAndCreateProcessTag)
    local picPath = "test/loading_juhua.png"

    local info = {}
    info.process = processBg
    table.insert(self.data,info)

    local spr = display.newSprite(picPath)
    processBg:addChild(spr)
    spr:setPosition(0, 0)

    local timeLabel = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 255, 255), -- 使用纯红色
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    timeLabel:setPosition(50, 30)
    processBg:addChild(timeLabel)

    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.TREATMENT,index,1)
    if not timeInfo then
        local info = {}
        info.index = index
        info.timeLab = timeLabel
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.TREATMENT, info, 1,self.updateTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--删除定时器
--返回值(无)
function TreatmentTime:delTime()
    for k,v in pairs(self.data) do
       v.process:removeFromParent()
    end
    self.data = {}
    TimeMgr:getInstance():removeInfo(TimeType.TREATMENT,1)
end

--更新治疗时间
--info 数据
--返回值(无)
function TreatmentTime:updateTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        info.timeLab:setString(Common:getFormatTime(info.leftTime))
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.TREATMENT,1,1)
        return
    end
    info.timeLab:setString(Common:getFormatTime(info.leftTime))
end