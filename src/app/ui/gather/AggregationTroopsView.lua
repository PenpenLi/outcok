--
-- Author: Your Name
-- Date: 2016-01-25 16:17:14
--集结处部队列表

AggregationTroopsView = class("AggregationTroopsView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function AggregationTroopsView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function AggregationTroopsView:init()
    self.root = Common:loadUIJson(TRAP_TROOPS)
    self:addChild(self.root)

    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.onClose))

    --标题
    self.lbl_title = Common:seekNodeByName(self.root,"lbl_title")
    self.lbl_title:setString(Lan:lanText(32,"士兵"))

    --消耗文本
    self.lbl_consume = Common:seekNodeByName(self.root,"lbl_consume")
    self.lbl_consume:setString(Lan:lanText(36,"粮食消耗") .. ":")

    --数量
    self.lbl_num = Common:seekNodeByName(self.root,"lbl_num")
    self.lbl_num:setString(Lan:lanText(35,"士兵数量") .. ":")

    --详情
    self.btn_1 = Common:seekNodeByName(self.root,"btn_1")
    self.btn_1:addTouchEventListener(handler(self,self.onBtn))

    --详情
    self.btn_2 = Common:seekNodeByName(self.root,"btn_2")
    self.btn_2:setVisible(false)

end

--关闭按钮
function AggregationTroopsView:onClose(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        self:hideView()
    end
end

--详情按钮
function AggregationTroopsView:onBtn(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 陷阱详情界面
        self.troopsDetailsView = TroopsDetailsView.new(self)
        self.troopsDetailsView:showView()
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function AggregationTroopsView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后会调用这个接口
--返回值(无)
function AggregationTroopsView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function AggregationTroopsView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end

-- 显示界面
function AggregationTroopsView:showView()
    self:setVisible(true)
end

-- 隐藏界面
function AggregationTroopsView:hideView()
    self:setVisible(false)
end