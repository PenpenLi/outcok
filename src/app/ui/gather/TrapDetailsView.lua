--
-- Author: Your Name
-- Date: 2016-02-02 21:27:14
-- 陷阱详情

TrapDetailsView = class("TrapDetailsView")

--构造
--uiType UI类型
--data 数据
function TrapDetailsView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_trap")
    self:init()
end

--初始化
--返回值(无)
function TrapDetailsView:init()
    -- 关闭背景
    self.trap_details = Common:seekNodeByName(self.view,"Panel_trap")
    self.trap_details:addTouchEventListener(handler(self,self.onClickIcon))

    -- 销毁按钮
    self.btn_destroy = Common:seekNodeByName(self.view,"btn_destroy")
    self.btn_destroy:addTouchEventListener(handler(self,self.onDestroy))

end

-- 关闭背景回调
function TrapDetailsView:onClickIcon(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
    end
end

-- 销毁按钮回调
function TrapDetailsView:onDestroy(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 选择数量界面
        self.numberView = NumberView.new(self)
        self.numberView:showView()
    end
end

-- 显示界面
function TrapDetailsView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function TrapDetailsView:hideView()
    self.view:setVisible(false)
end