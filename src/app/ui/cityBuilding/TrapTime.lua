
--[[
    hejun
    陷井倒计时
--]]

TrapTime = class("TrapTime")
local instance = nil

local upAndCreateProcessTag = 1111  --升级或建造建筑的进度条tag
local upAndCreateProcessZorder = 4   --升级或者建筑的进度条层级
local headBtnPath = "test/trainbtn.png"  --头顶上的按钮资源路径

local upAndCreateProcessBgPath = "test/expbase.png"  --升级或者创建建筑的进度背景路径
local upAndCreateProcessPath = "test/expbar.png"     --升级或者创建建筑的进度条路径

--构造
--返回值(无)
function TrapTime:ctor(parent)
    self.parent = parent
    self:init()
end

function TrapTime:init()
    self.data = {}
end

--创建建筑头顶上的完成按钮
--tab 表格
--返回值(无)
function TrapTime:createHeadFinishBtn(tab)
    self:delHeadBtn()

    local headTrainBtn = cc.ui.UIPushButton.new(headBtnPath)
    tab.buildingImg:getParent():addChild(headTrainBtn,1000)
    local x,y = tab.buildingImg:getPosition()
    headTrainBtn:setPosition(x,y+100)
    headTrainBtn:onButtonClicked(function(event)
        FortressService:getMakeTrapSeq(tab.buildingImg:getTag())
    end)
    self.data.headImg = headTrainBtn
end

--删除建筑物头顶上的按钮
--headImg 图片
--返回值(无)
function TrapTime:delHeadBtn()
    if self.data.headImg ~= nil then
        self.data.headImg:removeFromParent()
        self.data.headImg = nil
    end
end

--创建定时器UI
--buildingPos 建筑位置
--返回值(无)
function TrapTime:createTimeUI(buildingPos)
    local info = self.parent:getBuildingInfoByPos(buildingPos)
    local timeInfo = TimeInfoData:getInstance():getTimeInfoByBuildingPos(buildingPos)
    if timeInfo == nil then
       return
    end

    local leftTime = Common:getLeftTime(timeInfo.start_time,timeInfo.interval)
    if leftTime == 0 then
        return
    end

   self:delTime()
   self:createProcess(info.buildingImg,leftTime,timeInfo.name,timeInfo.num)
end

--创建进度条
--buildingImg 建筑图片
--leftTime 剩余时间
--name 名字
--num 数量
--返回值(无)
function TrapTime:createProcess(buildingImg,leftTime,name,num)
    local parent = buildingImg:getParent()
    local x,y = buildingImg:getPosition()
    local pos = cc.p(x,y-50)

    local processBg = UICommon:getInstance():createProgress(leftTime,parent,upAndCreateProcessBgPath,upAndCreateProcessPath,pos,cc.p(37,3),upAndCreateProcessZorder,upAndCreateProcessTag)
    self.data.process = processBg
    local picPath = "test/loading_juhua.png"

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

    local nameLabel = display.newTTFLabel({
        text = name .. ": " .. num,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 255, 255), -- 使用纯红色
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    nameLabel:setPosition(50, -30)
    processBg:addChild(nameLabel)

    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.TRAP,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.timeLab = timeLabel
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.TRAP, info, 1,self.updateTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--完成制造陷井
--buildingPos 建筑位置
--返回值(无)
function TrapTime:finishMakeTrap(buildingPos)
    self:delTime()
    local info = self.parent:getBuildingInfoByPos(buildingPos)
    if info ~= nil then
        self:createHeadFinishBtn(info)
    end
end

--取消制造陷井
--返回值(无)
function TrapTime:cancelMakeTrap()
    self:delHeadBtn()
    self:delTime()
end

--领取制造的陷井
function TrapTime:getMakeTrap()
    self:delHeadBtn()
end

--更新UI
--buildingPos 建筑位置
--返回值(无)
function TrapTime:updateUI(buildingPos)
    if TimeInfoData:getInstance():isMakeingSoldier(buildingPos) then
        self:createTimeUI(buildingPos)
    else
        if MakeSoldierModel:getInstance():isHaveReadyArms(buildingPos) then
           self:finishMakeTrap(buildingPos)
        end
    end
end

--删除定时器
--返回值(无)
function TrapTime:delTime()
    if self.data.process ~= nil then
        self.data.process:removeFromParent()
    end
    self.data = {}
    TimeMgr:getInstance():removeInfo(TimeType.TRAP,1)
end

--更新时间
--info 数据
--返回值(无)
function TrapTime:updateTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        info.timeLab:setString(Common:getFormatTime(info.leftTime))
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.TRAP,1,1)
        return
    end
    info.timeLab:setString(Common:getFormatTime(info.leftTime))
end

