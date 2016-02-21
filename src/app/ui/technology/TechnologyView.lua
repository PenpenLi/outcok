--[[
    hejun
    科技界面
--]]

TechnologyView = class("TechnologyView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function TechnologyView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
    --建筑位置
    self.pos = data
end

--初始化
--返回值(无)
function TechnologyView:init()
    self.root = Common:loadUIJson(COLLEGE_PATH)
    self:addChild(self.root)
    -- 选择的科技
    self.selectTech = nil
    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.closeCallback))

    --列表
    -- 军事
    self.techMilView = TechMilView.new(self)
    self.techMilView:setData()
    -- 经济
    self.techEcoView = TechEcoView.new(self)
    self.techEcoView:hideView()
    -- 防御
    self.techDefView = TechDefView.new(self)
    self.techDefView:hideView()
    -- 开始研究界面
    self.researchView = ResearchView.new(self)
    self.researchView:hideView()
    -- 加速研究界面
    self.accelerateView = AccelerateView.new(self)
    self.accelerateView:hideView()
    --切换
    self.check1 = Common:seekNodeByName(self.root,"btn_military")
    self.check1:addTouchEventListener(handler(self,self.onCheck1))
    self.check1:setSelected(true)
    self.check1:setTouchEnabled(false)
    self.check2 = Common:seekNodeByName(self.root,"btn_economics")
    self.check2:addTouchEventListener(handler(self,self.onCheck2))
    self.check3 = Common:seekNodeByName(self.root,"btn_defense")
    self.check3:addTouchEventListener(handler(self,self.onCheck3))
end

-- 更新ui
function TechnologyView:updataTechUI()
    Lan:hintClient(15,"升级{}科技成功",{self.selectTech.name})
    self.researchView:hideView()
    if self.check1:isSelected() == true then
        -- 设置数据
        self.techMilView:setData()
    end
    if self.check2:isSelected() == true then
        -- 设置数据
        self.techEcoView:setData()
    end
    if self.check3:isSelected() == true then
        -- 设置数据
        self.techDefView:setData()
    end
end

--勾选1
--返回值(无)
function TechnologyView:onCheck1(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check1:isSelected() == false then
            self.check2:setSelected(false)
            self.check3:setSelected(false)
            self.check1:setTouchEnabled(false)
            self.check2:setTouchEnabled(true)
            self.check3:setTouchEnabled(true)
            -- 界面显示与隐藏
            self.techMilView:showView()
            self.techEcoView:hideView()
            self.techDefView:hideView()
            -- 设置数据
            self.techMilView:setData()
        end
    end
end

--勾选2
--返回值(无)
function TechnologyView:onCheck2(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check2:isSelected() == false then
            self.check1:setSelected(false)
            self.check3:setSelected(false)
            self.check1:setTouchEnabled(true)
            self.check2:setTouchEnabled(false)
            self.check3:setTouchEnabled(true)
            -- 界面显示与隐藏
            self.techMilView:hideView()
            self.techEcoView:showView()
            self.techDefView:hideView()
            -- 设置数据
            self.techEcoView:setData()
        end
    end
end

--勾选3
--返回值(无)
function TechnologyView:onCheck3(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check3:isSelected() == false then
            self.check1:setSelected(false)
            self.check2:setSelected(false)
            self.check1:setTouchEnabled(true)
            self.check2:setTouchEnabled(true)
            self.check3:setTouchEnabled(false)
            -- 界面显示与隐藏
            self.techMilView:hideView()
            self.techEcoView:hideView()
            self.techDefView:showView()
            -- 设置数据
            self.techDefView:setData()
        end
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function TechnologyView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function TechnologyView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function TechnologyView:onDestroy()
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function TechnologyView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:getParent().baseView:showTopView()
    end
end

-- 显示界面
function TechnologyView:showView()
    self:setVisible(true)
end

-- 隐藏界面
function TechnologyView:hideView()
    self:setVisible(false)
end




