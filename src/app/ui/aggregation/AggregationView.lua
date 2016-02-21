--[[
    hejun
    集结界面
--]]

AggregationView = class("AggregationView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function AggregationView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function AggregationView:init() 
    self.root = Common:loadUIJson(AGGREGATION_HEAD)
    self:addChild(self.root)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --返回集结按钮
    self.close2Btn = Common:seekNodeByName(self.root,"close2Btn")
    self.close2Btn:addTouchEventListener(handler(self,self.close2Callback))

    self.panel = Common:seekNodeByName(self.root,"Panel_1")
    self.panel2 = Common:seekNodeByName(self.root,"Panel_2")

    --自动编队按钮
    self.formationBtn = Common:seekNodeByName(self.root,"formationBtn")
    self.formationBtn:addTouchEventListener(handler(self,self.formationBtnCallback))
    
    --集结按钮
    self.aggregationBtn = Common:seekNodeByName(self.root,"aggregationBtn")
    self.aggregationBtn:addTouchEventListener(handler(self,self.aggregationBtnCallback))

    --解散按钮
    self.dissolutionBtn = Common:seekNodeByName(self.root,"dissolutionBtn")
    self.dissolutionBtn:addTouchEventListener(handler(self,self.dissolutionBtnCallback))

    
end

--隐藏显示建筑详请面板
--visible (true:显示，false:隐藏)
--返回值(无)
function AggregationView:setPanVis(visible)
    self.panel:setVisible(visible)
    self.panel2:setVisible(visible)    
end

--自动编队按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function AggregationView:formationBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    MyLog("自动编队")
    end
end

--集结按钮回调
--sender按钮本身
--eventType 事件类型
--返回值(无)
function AggregationView:aggregationBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("集结")
        self:setPanVis(false)
        self.panel2:setVisible(true) 
    end
end

--自动编队按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function AggregationView:dissolutionBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    MyLog("解散")
    end
end

--返回集结按钮回调
--sender按钮本身
--eventType 事件类型
--返回值(无)
function AggregationView:close2Callback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:setPanVis(true)
        self.panel2:setVisible(false) 
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function AggregationView:onEnter()
    --MyLog("AggregationView onEnter...")
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function AggregationView:onExit()
    --MyLog("AggregationView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function AggregationView:onDestroy()
   -- MyLog("AggregationView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function AggregationView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():closeUI(self.uiType)
    end
end