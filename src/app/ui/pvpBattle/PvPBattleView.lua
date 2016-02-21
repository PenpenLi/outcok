
--[[
    jinyan.zhang
    PVP战斗UI
--]]

PVPBattleView = class("PVPBattleView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function PVPBattleView:ctor(uiType,data)
    self.data = data
    self.speed = 1
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function PVPBattleView:init() 
    self.root = Common:loadUIJson(BATTLE_PVP_HEAD)
    self:addChild(self.root)

    --返回按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --加速
    self.speedBtn = Common:seekNodeByName(self.root,"accelerationBtn")
    self.speedBtn:addTouchEventListener(handler(self,self.speedCallback))
    self.speedBtn:setTitleText(CommonStr.ACC_SPEED .. "X2")

    --重新播放
    self.againPlayBtn = Common:seekNodeByName(self.root,"againBtn")
    self.againPlayBtn:addTouchEventListener(handler(self,self.againPlayBattleCallback))
    self.againPlayBtn:setTitleText(CommonStr.AGAIN_PLAYER)

    --防守方名称
    self.deferNameLab = Common:seekNodeByName(self.root,"we_nameLab")
    --防守方兵力
    self.derPowerLab = Common:seekNodeByName(self.root,"we_troopsLab")
    --进攻方名称
    self.atterNameLab = Common:seekNodeByName(self.root,"enemy_nameLab")
    --进攻方兵力
    self.atterPowerLab = Common:seekNodeByName(self.root,"enemy_troopsLab")
end

--UI加到舞台后会调用这个接口
--返回值(无)
function PVPBattleView:onEnter()
    --MyLog("PVPBattleView onEnter...")

    local atterPower = BattleData:getInstance():getSoldierTotal(CAMP.ATTER)
    self:setAtterPower(atterPower)
    local deferPower = BattleData:getInstance():getSoldierTotal(CAMP.DEFER)
    self:setDeferPower(deferPower)

    local atterCampName = BattleData:getInstance():getPvPCampName(CAMP.ATTER)
    self.atterNameLab:setString(CommonStr.ATTER2 .. ": " .. atterCampName)
    local deferCampName = BattleData:getInstance():getPvPCampName(CAMP.DEFER)
    self.deferNameLab:setString(CommonStr.DEFER .. ": " .. deferCampName)
end

--UI离开舞台后会调用这个接口
--返回值(无)
function PVPBattleView:onExit()
    --MyLog("PVPBattleView onExit()")
    BattleCommon:getInstance():setSpeed(1)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function PVPBattleView:onDestroy()
    --MyLog("PVPBattleView:onDestroy")
end

--设置攻击方兵力
--power 兵力
--返回值(无)
function PVPBattleView:setAtterPower(power)
    self.atterPowerLab:setString(CommonStr.LEFT_SOLDER_POWER .. ": " .. power)
end

--设置防守方兵力
--power 兵力
--返回值(无)
function PVPBattleView:setDeferPower(power)
    self.derPowerLab:setString(CommonStr.LEFT_SOLDER_POWER .. ": " .. power)
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function PVPBattleView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:close()
    end
end

--关闭界面
--返回值(无)
function PVPBattleView:close()
    self:clearData()
    UIMgr:getInstance():closeUI(self.uiType)
    local lastSceneType = SceneMgr:getInstance():getLastOpenSceneType()
    if lastSceneType == SCENE_TYPE.WORLD then
        SceneMgr:getInstance():fromPvpGoToWorldMap()
    else
        SceneMgr:getInstance():fromPvpGoToCity()
    end
end

--加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PVPBattleView:speedCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.speed == 1 then
            self.speed = 2
        else
            self.speed = 1
        end
        BattleCommon:getInstance():setSpeed(self.speed)
    end
end

--重新播放战斗按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PVPBattleView:againPlayBattleCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:clearData()
        UIMgr:getInstance():closeUI(UITYPE.PVP_BATTLE_RESULT)
        local sequence = transition.sequence({
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function()
            BattleData:getInstance():setSolderTotal()
            self:onEnter()
            BattleLogic:getInstance():stopTime()
            BattleLogic:getInstance():init()
            BattleLogic:getInstance():onEnter()
        end),
        })
        self:stopAllActions()
        self:runAction(sequence)
    end
end

--清理数据
--返回值(无)
function PVPBattleView:clearData()
    self.speed = 1
    BattleCommon:getInstance():setSpeed(self.speed)
    BattleLogic:getInstance():stopTime()

    HeroMgr:getInstance():delAllSoldier()
end


