--
-- Author: Your Name
-- Date: 2016-01-11 16:52:02
--领主天赋view

LordTalentView = class("LordTalentView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LordTalentView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function LordTalentView:init()
    self.root = Common:loadUIJson(LAIRD_SKILL)
    self:addChild(self.root)
    -- 选择的天赋
    self.selectTalent = nil
    --列表
    -- 军事
    self.lairdMilView = LordMilView.new(self)
    self.lairdMilView:setData()
    -- 经济
    self.lairdEcoView = LordEcoView.new(self)
    -- self.lairdEcoView:hideView()
    -- 防御
    self.lairdDefView = LordDefView.new(self)
    -- self.lairdDefView:hideView()

    -- 领主技能点提示操作
    self.lordSkillOperationView = LordSkillOperationView.new(self)
    -- 剩余天赋点数
    self.lbl_surplus = Common:seekNodeByName(self.root,"lbl_surplus")
    self.lbl_surplus:setString(Lan:lanText(211,"剩余天赋点数：") .. PlayerData:getInstance():getTalentPoint())

    self.lbl_gold = Common:seekNodeByName(self.root,"lbl_gold")
    self.lbl_gold:setString(Lan:lanText(6,"金币") .. CommonConfig:getResetTalentGold())
    -- 重置天赋按钮
    self.btn_reset = Common:seekNodeByName(self.root,"btn_reset")
    self.btn_reset:addTouchEventListener(handler(self,self.onReset))
    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.closeCallback))
    --切换
    self.check1 = Common:seekNodeByName(self.root,"btn_battle")
    self.check1:addTouchEventListener(handler(self,self.onCheck1))
    self.check1:setSelected(true)
    self.check1:setTouchEnabled(false)
    self.check2 = Common:seekNodeByName(self.root,"btn_economics")
    self.check2:addTouchEventListener(handler(self,self.onCheck2))
    self.check3 = Common:seekNodeByName(self.root,"btn_defense")
    self.check3:addTouchEventListener(handler(self,self.onCheck3))
    -- 战斗
    self.lbl_fight = Common:seekNodeByName(self.root,"lbl_military")
    -- 资源
    self.lbl_res = Common:seekNodeByName(self.root,"lbl_economics")
    -- 辅助
    self.lbl_auxiliary = Common:seekNodeByName(self.root,"lbl_defense")
    -- 设置点数
    self:setPoint()
end

-- 设置点数
function LordTalentView:setPoint()
    -- 战斗
    local fightPoint = TalentData:getInstance():getPointByArr(LordModel:getInstance().milTechArr)
    if fightPoint > 0 then
        self.lbl_fight:setString(Lan:lanText(43,"战斗") .. " " .. fightPoint)
    else
        self.lbl_fight:setString(Lan:lanText(43,"战斗"))
    end
    -- 资源
    local resPoint = TalentData:getInstance():getPointByArr(LordModel:getInstance().gdpTechArr)
    if resPoint > 0 then
        self.lbl_res:setString(Lan:lanText(54,"资源") .. " " .. resPoint)
    else
        self.lbl_res:setString(Lan:lanText(54,"资源"))
    end
    -- 辅助
    local auxiliaryPoint = TalentData:getInstance():getPointByArr(LordModel:getInstance().defTechArr)
    if auxiliaryPoint > 0 then
        self.lbl_auxiliary:setString(Lan:lanText(219,"辅助") .. " " .. auxiliaryPoint)
    else
        self.lbl_auxiliary:setString(Lan:lanText(219,"辅助"))
    end
end

--关闭按钮回调
--返回值(无)
function LordTalentView:onReset(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=Lan:lanText(212,"确定要重置天赋吗？"),
            callback=handler(self, self.sureResetTalent),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL
            })
    end
end

-- 重置天赋
function LordTalentView:sureResetTalent()
    LordService:getInstance():sentResetTalentPoint()
end

-- 重置天赋
function LordTalentView:resetTalentPoint()
    Lan:hintClient(13,"重置天赋成功")
    self.lbl_surplus:setString(Lan:lanText(211,"剩余天赋点数：") .. PlayerData:getInstance():getTalentPoint())
    self.lairdMilView:setData()
    self.lairdEcoView:setData()
    self.lairdDefView:setData()
    -- 设置点数
    self:setPoint()
end

-- 更新ui
function LordTalentView:updataTalentUI()
    Lan:hintClient(14,"升级{}天赋成功",{self.selectTalent.name})
    self.lbl_surplus:setString(Lan:lanText(211,"剩余天赋点数：") .. PlayerData:getInstance():getTalentPoint())
    if self.check1:isSelected() == true then
        -- 设置数据
        self.lairdMilView:setData()
        self.lordSkillOperationView:setData(self.selectTalent,LordModel:getInstance().milTechArr)
    end
    if self.check2:isSelected() == true then
        -- 设置数据
        self.lairdEcoView:setData()
        self.lordSkillOperationView:setData(self.selectTalent,LordModel:getInstance().gdpTechArr)
    end
    if self.check3:isSelected() == true then
        -- 设置数据
        self.lairdDefView:setData()
        self.lordSkillOperationView:setData(self.selectTalent,LordModel:getInstance().defTechArr)
    end
    -- 设置点数
    self:setPoint()
end

--勾选1
--返回值(无)
function LordTalentView:onCheck1(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check1:isSelected() == false then
            self.check2:setSelected(false)
            self.check3:setSelected(false)
            self.check1:setTouchEnabled(false)
            self.check2:setTouchEnabled(true)
            self.check3:setTouchEnabled(true)
            -- 界面显示与隐藏
            self.lairdMilView:showView()
            self.lairdEcoView:hideView()
            self.lairdDefView:hideView()
            -- 设置数据
            self.lairdMilView:setData()
        end
    end
end

--勾选2
--返回值(无)
function LordTalentView:onCheck2(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check2:isSelected() == false then
            self.check1:setSelected(false)
            self.check3:setSelected(false)
            self.check1:setTouchEnabled(true)
            self.check2:setTouchEnabled(false)
            self.check3:setTouchEnabled(true)
            -- 界面显示与隐藏
            self.lairdMilView:hideView()
            self.lairdEcoView:showView()
            self.lairdDefView:hideView()
            -- 设置数据
            self.lairdEcoView:setData()
        end
    end
end

--勾选3
--返回值(无)
function LordTalentView:onCheck3(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check3:isSelected() == false then
            self.check1:setSelected(false)
            self.check2:setSelected(false)
            self.check1:setTouchEnabled(true)
            self.check2:setTouchEnabled(true)
            self.check3:setTouchEnabled(false)
            -- 界面显示与隐藏
            self.lairdMilView:hideView()
            self.lairdEcoView:hideView()
            self.lairdDefView:showView()
            -- 设置数据
            self.lairdDefView:setData()
        end
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function LordTalentView:onEnter()

end

--UI离开舞台后都会调用这个接口
--返回值(无)
function LordTalentView:onExit()
    -- MMUIProcess:getInstance():closeTimeByType(TimeType.GAIN)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LordTalentView:onDestroy()

end

--关闭按钮回调
--返回值(无)
function LordTalentView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:getParent().baseView:showTopView()
    end
end

-- 显示界面
function LordTalentView:showView()
    self:setVisible(true)
end

-- 隐藏界面
function LordTalentView:hideView()
    self:setVisible(false)
end