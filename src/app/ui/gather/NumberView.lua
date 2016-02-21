--
-- Author: Your Name
-- Date: 2016-02-02 21:27:14
-- 选择数量

NumberView = class("NumberView")

--构造
--uiType UI类型
--data 数据
function NumberView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_num")
    self:init()
end

--初始化
--返回值(无)
function NumberView:init()
    self.img_num = Common:seekNodeByName(self.view,"img_num")
    -- self.img_num:addTouchEventListener(handler(self,self.onClickIcon))
end


function NumberView:onClickIcon(sender,eventType)
    if eventType == ccui.TouchEventType.ended then

    end
end

-- -- 显示界面
-- function NumberView:showView()
--     self.view:setVisible(true)
-- end

-- -- 隐藏界面
-- function NumberView:hideView()
--     self.view:setVisible(false)
-- end