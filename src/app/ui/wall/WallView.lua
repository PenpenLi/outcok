--[[
    jinyan.zhang
    城墙UI
--]]

WallView = class("WallView",UIBaseView)

--城墙子界面类型
WallSubViewType = 
{
    def = 1,  --防御
    garrison = 2,  --驻军
    addHero = 3,  --添加英雄
}

--构造
--uiType UI类型
--data 数据
--返回值(无)
function WallView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function WallView:init()
    self.root = Common:loadUIJson(WALL_PATH)
    self:addChild(self.root)
    self.defPan = Common:seekNodeByName(self.root,"defPan")

    --标题
    self.titleLab = Common:seekNodeByName(self.defPan,"lab_title")
    self.titleLab:setString(CommonStr.DEFS)

     --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.defPan,"btn_close")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --城墙完好无损层
    self.wallokPan = Common:seekNodeByName(self.defPan,"wallokPan")
    self.okLab = Common:seekNodeByName(self.wallokPan,"lab_ok")
    self.okLab:setString(CommonStr.WALL_OK)

    --城防值
    self.defLab = Common:seekNodeByName(self.defPan,"lab_def")

    --城防进度条
    self.defProcessBg = Common:seekNodeByName(self.defPan,"img_processbg")
    self.defProcess = Common:seekNodeByName(self.defProcessBg,"bar_process")
    --城墙状态图片
    self.wallImg = Common:seekNodeByName(self.defPan,"img_wall")

    --信息层
    self.infoPan = Common:seekNodeByName(self.defPan,"infoPan")

    --描述层
    self.descrpPan = Common:seekNodeByName(self.infoPan,"descrpPan")
    self.descrpLab = Common:seekNodeByName(self.descrpPan,"lab_descrp")

    --灭火按钮
    self.delFireBtn = Common:seekNodeByName(self.infoPan,"btn_removefire")
    self.delFireBtn:addTouchEventListener(handler(self,self.delFireCallback))
    self.delFireLab = Common:seekNodeByName(self.delFireBtn,"lab_name")
    self.delFireLab:setString(CommonStr.WATERING_FIRE)
    self.delFireGoldLab = Common:seekNodeByName(self.delFireBtn,"lab_gold")

    --修补层
    self.repairPan = Common:seekNodeByName(self.infoPan,"modifPan")
    self.repairDescrpLab = Common:seekNodeByName(self.repairPan,"lab_modif")

    --修补按钮
    self.repairBtn = Common:seekNodeByName(self.infoPan,"btn_modif")
    self.repairBtn:addTouchEventListener(handler(self,self.repairCallback))
    self.repairLab = Common:seekNodeByName(self.repairBtn,"lab_name")
    self.repairLab:setString(CommonStr.REPAIR_WALL)
    self.coldTimeLab = Common:seekNodeByName(self.repairBtn,"lab_time")
end

function WallView:show()
    self.defPan:setVisible(true)
end

function WallView:hide()
    self.defPan:setVisible(false)
end

--更新修复城墙冷却时间UI
--返回值(无)
function WallView:updateRepairCoolTimeUI()
    local leftTime = WallModel:getInstance():getRepairLeftCoolTime()
    if leftTime == 0 then
        self.coldTimeLab:setVisible(false)
        self.repairBtn:setTouchEnabled(true)
    else
        self.repairBtn:setTouchEnabled(false)
        self.repairBtn:setBright(false)
        self.coldTimeLab:setString(Common:getFormatTime(leftTime))
    end
end

--更新城防值UI
function WallView:updateDefValueUI()
    --城防上限值
    local maxDefValue = WallModel:getInstance():getMaxDef()
     --城防值
    local def = WallModel:getInstance():getDef()
    self.defLab:setString(CommonStr.CITY_DEF_VALUE .. ": " .. def .. "/" .. maxDefValue)
    local per = def/maxDefValue*100
    self.defProcess:setPercent(per)
end

--更新防御UI
function WallView:updateDefUI()
    --城防上限值
    local maxDefValue = WallModel:getInstance():getMaxDef()
    --城防值
    local def = WallModel:getInstance():getDef()
    self.defLab:setString(CommonStr.CITY_DEF_VALUE .. ": " .. def .. "/" .. maxDefValue)
    local per = def/maxDefValue*100
    self.defProcess:setPercent(per)

    --配置
    local config = WallEffectConfig:getInstance():getConfigByLevel(WallModel:getInstance():getWallLevel())

    --着火描述
    self.descrpLab:setString(CommonStr.DESTROY_FIR_MINUS .. config.we_firedefend .. CommonStr.DESTROY_FIR_HOU)
    
    --破损描述
    self.repairDescrpLab:setString(CommonStr.REPAIR_WALL_BE .. config.we_repairedefend .. 
        CommonStr.REPAIR_WALL_HO .. CommonConfig:getInstance():getRepairWallColdTime() ..
        CommonStr.MIN .. "。" .. CommonStr.REPQIR_WALL_HH)

    --灭火消耗金币
    self.delFireGoldLab:setString(WallModel:getInstance():getDelFireCastGold() .. CommonStr.GOLD)
    
    local leftTime = WallModel:getInstance():getRepairLeftCoolTime()
    if leftTime == 0 then
        self.coldTimeLab:setVisible(false)
        self.repairBtn:setTouchEnabled(true)
        self.repairBtn:setBright(true)
    else
        self.repairBtn:setTouchEnabled(false)
        self.repairBtn:setBright(false)
        self.coldTimeLab:setVisible(true)
        self.coldTimeLab:setString(Common:getFormatTime(leftTime))
    end
end

--更新城墙图片
function WallView:updateWallImg()
     --城墙状态
    local wallState = WallModel:getInstance():getState()
    if wallState == WallState.fire then  --着火
        self.infoPan:setVisible(true)
        self.wallokPan:setVisible(false)
        self.delFireBtn:setTouchEnabled(true)
        self.delFireBtn:setBright(true)
        self.delFireGoldLab:setVisible(true)
        self.wallImg:loadTexture("citybuilding/firewall.png")
    elseif wallState == WallState.bad then  --破损
        self.infoPan:setVisible(true)
        self.wallokPan:setVisible(false)
        self.delFireBtn:setTouchEnabled(false)
        self.delFireBtn:setBright(false)
        self.delFireGoldLab:setVisible(false)
        self.wallImg:loadTexture("citybuilding/badwall.png")
    elseif wallState == WallState.normal then  --正常
        self.infoPan:setVisible(false)
        self.wallokPan:setVisible(true)
        self.wallImg:loadTexture("citybuilding/normalwall.png")
    end
end

--灭火结果
function WallView:delFireRes()
    self:updateDefUI()
    self:updateWallImg()
end

--修复结果
function WallView:repairRes()
    self:updateDefUI()
    self:updateWallImg()
end

--收到通知城墙着火
function WallView:recvNoticeWallFireRes()
    self:updateDefUI()
    self:updateWallImg()
end

--获取建筑物位置
--返回值(建筑位置)
function WallView:getBuildingPos()
    return self.data.building:getTag()
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function WallView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
    if self.data.subViewType == WallSubViewType.def then  --防御
        self:updateDefUI()
        self:updateWallImg()
    elseif self.data.subViewType == WallSubViewType.garrison then  --驻军
        self:hide()
        self.garrisionView = GarrisionView.new(self)
    end
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function WallView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeInfo(TimeType.COMMON,1)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function WallView:onDestroy()
end

--灭火按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function WallView:delFireCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if PlayerData:getInstance().gold < WallModel:getInstance():getDelFireCastGold() then
            Prop:getInstance():showMsg(CommonStr.NO_GOLD_DEL_FIRE)
            return
        end
        WallService:getInstance():sendDelFireSeq()
    end
end

--修补按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function WallView:repairCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        WallService:getInstance():sendRepairSeq()
    end
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function WallView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end


