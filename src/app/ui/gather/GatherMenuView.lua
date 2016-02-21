--
-- Author: oyhc
-- Date: 2015-12-31 16:40:23
--
GatherMenuView = class("GatherMenuView",UIBaseBuildMenuView)

--构造
--uiType UI类型
--data 数据
function GatherMenuView:ctor(uiType,data)
    self.super.ctor(self,uiType,data)
end

function GatherMenuView:onEnter()
    self.abc = "aabbcc"
	-- 父类onEnter
    self:setBuildBaseData()
    --
    self.buildingLvLab:setVisible(false)

    self.btn_first:setTitleText("士兵")
    self.btn_first:addTouchEventListener(handler(self,self.onSoldiers))
    self.btn_second:setTitleText("英雄")
    self.btn_second:addTouchEventListener(handler(self,self.onHero))
    self.btn_third:setTitleText("陷阱")
    self.btn_third:addTouchEventListener(handler(self,self.onTrap))
end

--详情按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function GatherMenuView:onSoldiers(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("士兵")
        -- if self.aggregationTroopsView == nil then
            -- 陷阱界面
            self.aggregationTroopsView = AggregationTroopsView.new(self.uiType)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.aggregationTroopsView)
            -- 添加
            self:addChild(self.aggregationTroopsView)
        -- end
        -- 显示界面
        -- self.baseView:showView(self.aggregationTroopsView)
    end
end

--升级按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function GatherMenuView:onHero(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("英雄")
        if self.heroListView == nil then
            -- 英雄界面
            self.heroListView = GatherHeroListView.new(self.uiType,self.data)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.heroListView)
            -- 添加
            self:addChild(self.heroListView)
        end
        -- 显示界面
        self.baseView:showView(self.heroListView)
    end
end

-- 第三个按钮
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function GatherMenuView:onTrap(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("陷阱")
        -- if self.aggregationTrapView == nil then
            -- 陷阱界面
            self.aggregationTrapView = AggregationTrapView.new(self.uiType)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.aggregationTrapView)
            -- 添加
            self:addChild(self.aggregationTrapView)
        -- end
        -- 显示界面
        -- self.baseView:showView(self.aggregationTrapView)
    end
end
