--
-- Author: Your Name
-- Date: 2016-01-13 17:28:14
-- 修改名字

LordNameView = class("LordNameView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LordNameView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function LordNameView:init()
    self.root = Common:loadUIJson(LAIRD_NAME)
    self:addChild(self.root)

    --关闭背景
    self.btn_close = Common:seekNodeByName(self.root,"Panel_Name")
    self.btn_close:addTouchEventListener(handler(self,self.onClose))

    --修改名字背景
    self.img_name = Common:seekNodeByName(self.root,"img_name")

    --确定按钮
    self.btn_sure = Common:seekNodeByName(self.root,"btn_sure")
    self.btn_sure:addTouchEventListener(handler(self,self.onSure))

    --修改名字输入框
    self.lbl_name = Common:seekNodeByName(self.root,"lbl_name")

    --修改名字文本（默认隐藏）
    self.lbl_changeName = Common:seekNodeByName(self.root,"lbl_changeName")

    --修改名字金币文本（默认隐藏）
    self.lbl_gold = Common:seekNodeByName(self.root,"lbl_gold")

end

--关闭背景
function LordNameView:onClose(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:hideView()
    end
end

--确定按钮
function LordNameView:onSure(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        print("确定")
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function LordNameView:onEnter()

end

--UI离开舞台后会调用这个接口
--返回值(无)
function LordNameView:onExit()

end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LordNameView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end

-- 显示界面
function LordNameView:showView()
    self:setVisible(true)
end

-- 隐藏界面
function LordNameView:hideView()
    self:setVisible(false)
end
