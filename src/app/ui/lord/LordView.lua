--
-- Author:  hejun
-- Date: 2016-01-11 16:37:17
--领主界面view

LordView = class("LordView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LordView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function LordView:init()
    self.root = Common:loadUIJson(LAIRD)
    self:addChild(self.root)

    --修改名字按钮
    self.btn_changeName = Common:seekNodeByName(self.root,"btn_changeName")
    self.btn_changeName:addTouchEventListener(handler(self,self.changeNameCallback))

    --领主信息按钮
    self.btn_detail = Common:seekNodeByName(self.root,"btn_detail")
    self.btn_detail:addTouchEventListener(handler(self,self.detailCallback))

    --标题
    self.lbl_title = Common:seekNodeByName(self.root,"lbl_title")
    self.lbl_title:setString(Lan:lanText(218,"领主信息"))

    --名字
    self.lbl_name = Common:seekNodeByName(self.root,"lbl_name")
    self.lbl_name:setString(PlayerData:getInstance():getPlayerName())
    --等级
    self.lbl_level = Common:seekNodeByName(self.root,"lbl_level")
    self.lbl_level:setString("LV:"..PlayerData:getInstance():getPlayerLevel())

    --战斗力
    self.lbl_sword = Common:seekNodeByName(self.root,"lbl_sword")
    self.lbl_sword:setString(Lan:lanText(74,"战斗力:{}",{PlayerData:getInstance():getFightForce()}))
    --消灭敌军
    self.lbl_eliminate = Common:seekNodeByName(self.root,"lbl_eliminate")

    --成就
    self.lbl_achievement = Common:seekNodeByName(self.root,"lbl_achievement")

    --勋章
    self.lbl_medal = Common:seekNodeByName(self.root,"lbl_medal")

    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.closeCallback))

    --天赋按钮
    self.btn_skill = Common:seekNodeByName(self.root,"btn_skill")
    self.btn_skill:addTouchEventListener(handler(self,self.skillCallback))
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function LordView:onEnter()

end

--UI离开舞台后都会调用这个接口
--返回值(无)
function LordView:onExit()
    -- MMUIProcess:getInstance():closeTimeByType(TimeType.GAIN)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LordView:onDestroy()

end

--修改名字按钮回调
--返回值(无)
function LordView:changeNameCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- if self.lordNameView == nil then
            -- 科技界面
            self.lordNameView = LordNameView.new(self.uiType)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.lordNameView)
            -- 添加
            self:addChild(self.lordNameView)
        -- end
        -- 显示界面
        -- self.baseView:showView(self.lordNameView)
    end
end

--领主信息按钮回调
--返回值(无)
function LordView:detailCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.lordDataView == nil then
            -- 科技界面
            self.lordDataView = LordDataView.new(self.uiType)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.lordDataView)
            -- 添加
            self:addChild(self.lordDataView)
        end
        -- 显示界面
        self.baseView:showView(self.lordDataView)
    end
end

--关闭按钮回调
--返回值(无)
function LordView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--天赋技能按钮回调
--返回值(无)
function LordView:skillCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.lordTalentView == nil then
            -- 科技界面
            self.lordTalentView = LordTalentView.new(self.uiType)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.lordTalentView)
            -- 添加
            self:addChild(self.lordTalentView)
        end
        -- 显示界面
        self.baseView:showView(self.lordTalentView)
    end
end

-- 显示界面
function LordView:showView()
    self.root:setVisible(true)
end

-- 隐藏界面
function LordView:hideView()
    self.root:setVisible(false)
end