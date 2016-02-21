--[[
    hejun
    pvp战斗结果界面
--]]

PvPBattleResultView = class("PvPBattleResultView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function PvPBattleResultView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function PvPBattleResultView:init() 
    self.root = Common:loadUIJson(BATTLE_RESULT)
    self:addChild(self.root)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    self.winPanel = Common:seekNodeByName(self.root,"winPanel")
    self.failurePanel = Common:seekNodeByName(self.root,"failurePanel")
    
    if self.data.win then
        self:openWinView()
    else
        self:openFailView() 
    end
end

--隐藏显示胜利面板
--visible (true:显示，false:隐藏)
--返回值(无)
function PvPBattleResultView:openWinView()
	self.winPanel:setVisible(true)
    self.failurePanel:setVisible(false)    
end

--隐藏显示失败面板
--visible (true:显示，false:隐藏)
--返回值(无)
function PvPBattleResultView:openFailView()
	self.winPanel:setVisible(false)
    self.failurePanel:setVisible(true)    
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function PvPBattleResultView:onEnter()
    --MyLog("PvPBattleResultView onEnter...")
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function PvPBattleResultView:onExit()
    --MyLog("PvPBattleResultView onExit()")
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function PvPBattleResultView:onDestroy()
   -- MyLog("PvPBattleResultView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function PvPBattleResultView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():closeUI(self.uiType)
        local pvpCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.PVP_BATTLE)
        if pvpCtrl ~= nil then
            pvpCtrl:closePvpView()
        end
    end
end


