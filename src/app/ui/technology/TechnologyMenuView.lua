--
-- Author: Your Name
-- Date: 2016-01-05 15:50:44
--
TechnologyMenuView = class("TechnologyMenuView",UIBaseBuildMenuView)

--构造
--uiType UI类型
--data 数据
function TechnologyMenuView:ctor(uiType,data)
    self.super.ctor(self,uiType,data)
end

function TechnologyMenuView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)

    self.btn_first:setTitleText("详情")
    self.btn_first:addTouchEventListener(handler(self,self.onFirst))
    self.btn_second:setTitleText("升级")
    self.btn_second:addTouchEventListener(handler(self,self.onSecond))
    self.btn_third:setTitleText("科技")
    self.btn_third:addTouchEventListener(handler(self,self.onThird))
    -- 父类onEnter
    self:setBuildBaseData()
end

function TechnologyMenuView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--详情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TechnologyMenuView:onFirst(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.techDetailView == nil then
            -- 科技界面
            self.techDetailView = UIBaseDetailView.new(self.uiType, self.pos)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.techDetailView)
            -- 添加
            self:addChild(self.techDetailView)
        end
        -- 显示界面
        self.baseView:showView(self.techDetailView)
        -- local arr = {}
        -- for i=1,3 do
        --     local info = {}
        --     info.icon = "ui_food"
        --     info.name = "点点滴滴"
        --     info.value = "100"+i
        --     table.insert(arr,info)
        -- end
        -- 创建详情数据
        self.techDetailView:setBuildBaseData(arr)
        -- 详情列表
        local arr1 = {}
        local builingUpInfo = BuildingUpLvConfig:getInstance():getDetailsInfo(1)
        --当前多少级
        local buildingLv = CityBuildingModel:getInstance():getBuildingLv(self.pos)

        for j=1,#builingUpInfo do
            -- if builingUpInfo[j].bu_level == buildingLv then
            --     bgPath = "ui/build_details/bg2.jpg"
            -- end
            local info1 = {builingUpInfo[j].bu_level,builingUpInfo[j].bu_fightforce}
            table.insert(arr1,info1)
        end
        local fightforce = Lan:lanText(56, "战斗力")
        local level = Lan:lanText(144, "等级")
        self.techDetailView.detailListView:setData({level,fightforce},arr1)
    end
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TechnologyMenuView:onSecond(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("升级:",self.uiType, self.pos)
        if self.upgradeView == nil then
            -- 科技界面
            self.upgradeView = UIBaseBuildUpgradeView.new(self.uiType, self.pos)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.upgradeView)
            -- 添加
            self:addChild(self.upgradeView)
        end
        -- 显示界面
        self.baseView:showView(self.upgradeView)
    end
end

--第三个按钮
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TechnologyMenuView:onThird(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.technologyView == nil then
            -- 科技界面
            self.technologyView = TechnologyView.new(self.uiType, self.pos)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.technologyView)
            -- 添加
            self:addChild(self.technologyView)
        end
        -- 显示界面
        self.baseView:showView(self.technologyView)
    end
end