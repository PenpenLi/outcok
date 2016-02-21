
--[[
    jinyan.zhang
    写邮件
--]]

WriteMailsView = class("WriteMailsView")

--构造
--uiType UI类型
--data 数据
--返回值(无)
function WriteMailsView:ctor(parent)
    self.parent = parent
    self:init()
end

--初始化
--返回值(无)
function WriteMailsView:init()
    --写邮件面板
    self.panWrite = Common:seekNodeByName(self.parent.root,"pan_write")
    self.panWrite:setTouchEnabled(true)
    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.panWrite,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))
    --标题
    self.labTitle = Common:seekNodeByName(self.panWrite,"lab_title")
    self.labTitle:setString(Lan:lanText(40, "邮件"))
    --发送者
    self.editSenderName = Common:seekNodeByName(self.panWrite,"edit_name")
    --发送内容
    self.editContent = Common:seekNodeByName(self.panWrite,"edit_content")
    --发送邮件按钮
    self.btnSend = Common:seekNodeByName(self.panWrite,"btn_send")
    self.btnSend:addTouchEventListener(handler(self,self.onSend))
    --添加按钮
    self.btnAdd = Common:seekNodeByName(self.panWrite,"btn_add")
    self.btnAdd:addTouchEventListener(handler(self,self.onAdd))
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WriteMailsView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hide()
    end
end

--发送邮件按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WriteMailsView:onSend(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        
    end
end


--添加按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WriteMailsView:onAdd(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        
    end
end

--显示
function WriteMailsView:show()
    self.panWrite:setVisible(true)
end

--隐藏
function WriteMailsView:hide()
    self.panWrite:setVisible(false)
end


