--
-- Author: Your Name
-- Date: 2016-01-13 17:28:14
-- 领主信息

LordDataView = class("LordDataView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LordDataView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function LordDataView:init()
    self.root = Common:loadUIJson(LAIRD_DETAILS)
    self:addChild(self.root)
    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.onClose))
    --修改名字按钮
    self.btn_changeName = Common:seekNodeByName(self.root,"btn_changeName")
    self.btn_changeName:addTouchEventListener(handler(self,self.onName))

    --头像
    self.img_head = Common:seekNodeByName(self.root,"img_head")

    --等级
    self.lbl_level = Common:seekNodeByName(self.root,"lbl_level")

    --姓名
    self.lbl_name = Common:seekNodeByName(self.root,"lbl_name")

    --王国
    self.lbl_kingdom = Common:seekNodeByName(self.root,"lbl_kingdom")

    --头衔
    self.lbl_honor = Common:seekNodeByName(self.root,"lbl_honor")

    --详情列表
    self.list = Common:seekNodeByName(self.root,"list")

end

--关闭按钮
function LordDataView:onClose(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:getParent().baseView:showTopView()
    end
end

--修改名字
function LordDataView:onName(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 科技界面
        self.lordNameView = LordNameView.new(self.uiType)
        -- 添加到这个模块的ui组里
        self.baseView:addView(self.lordNameView)
        -- 添加
        self:addChild(self.lordNameView)
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function LordDataView:onEnter()

end

--UI离开舞台后会调用这个接口
--返回值(无)
function LordDataView:onExit()

end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LordDataView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end

-- 显示界面
function LordDataView:showView()
    self:setVisible(true)
end

-- 隐藏界面
function LordDataView:hideView()
    self:setVisible(false)
end
