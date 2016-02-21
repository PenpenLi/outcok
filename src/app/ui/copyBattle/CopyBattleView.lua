--[[
    hejun
    副本战斗界面
--]]

CopyBattleView = class("CopyBattleView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function CopyBattleView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function CopyBattleView:init() 
    self.root = Common:loadUIJson(INSTANCE_BATTLE_HEAD)
    self:addChild(self.root)

    self.view = Common:seekNodeByName(self.root,"pan_battle")
    --防守方名称
    self.deferNameLab = Common:seekNodeByName(self.view,"we_nameLab")
    --防守方兵力
    self.derPowerLab = Common:seekNodeByName(self.view,"we_troopsLab")
    --进攻方名称
    self.atterNameLab = Common:seekNodeByName(self.view,"enemy_nameLab")
    --进攻方兵力
    self.atterPowerLab = Common:seekNodeByName(self.view,"enemy_troopsLab")

    --胜利界面
    self.copyWinView = CopyWinView.new(self)
    self:addChild(self.copyWinView)
    --失败界面
    self.copyFailView = CopyFailView.new(self)
    self:addChild(self.copyFailView)
end

function CopyBattleView:showView()
    self.view:setVisible(true)
end

function CopyBattleView:hideView()
    self.view:setVisible(false)
end

--设置攻击方兵力
--power 兵力
--返回值(无)
function CopyBattleView:setAtterPower(power)
    self.atterPowerLab:setString(CommonStr.LEFT_SOLDER_POWER .. ": " .. power)
end

--设置防守方兵力
--power 兵力
--返回值(无)
function CopyBattleView:setDeferPower(power)
    self.derPowerLab:setString(CommonStr.LEFT_SOLDER_POWER .. ": " .. power)
end

--显示胜利界面
--返回值(无)
function CopyBattleView:showWinView()
    self:hideView()
    self.copyWinView:showView()
    self.copyWinView:updateUI()
end

--显示失败界面
--返回值(无)
function CopyBattleView:showFailView()
    self:hideView()
    self.copyFailView:showView()
end

--隐藏显示建筑详请面板
--visible (true:显示，false:隐藏)
--返回值(无)
function CopyBattleView:setPanVis(visible)
    self.panel:setVisible(visible)
    self.panel2:setVisible(visible) 
    self.panel3:setVisible(visible)       
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function CopyBattleView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)

    local atterPower = BattleData:getInstance():getSoldierTotal(CAMP.ATTER)
    self:setAtterPower(atterPower)
    local deferPower = BattleData:getInstance():getSoldierTotal(CAMP.DEFER)
    self:setDeferPower(deferPower)

    local atterCampName = BattleData:getInstance():getPvPCampName(CAMP.ATTER)
    self.atterNameLab:setString(CommonStr.ATTER2 .. ": " .. atterCampName)
    local deferCampName = BattleData:getInstance():getPvPCampName(CAMP.DEFER)
    self.deferNameLab:setString(CommonStr.DEFER .. ": " .. deferCampName)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function CopyBattleView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function CopyBattleView:onDestroy()
end
