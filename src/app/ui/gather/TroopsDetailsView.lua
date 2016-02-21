--
-- Author: Your Name
-- Date: 2016-02-02 21:27:14
-- 士兵详情

TroopsDetailsView = class("TroopsDetailsView")

--构造
--uiType UI类型
--data 数据
function TroopsDetailsView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_troops")
    self:init()
end

--初始化
--返回值(无)
function TroopsDetailsView:init()
    self.trap_details = Common:seekNodeByName(self.view,"Panel_troops")
    self.trap_details:addTouchEventListener(handler(self,self.onClickIcon))
end


function TroopsDetailsView:onClickIcon(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
    end
end

-- 显示界面
function TroopsDetailsView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function TroopsDetailsView:hideView()
    self.view:setVisible(false)
end