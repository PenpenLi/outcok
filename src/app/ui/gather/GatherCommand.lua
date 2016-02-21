--
-- Author: oyhc
-- Date: 2015-12-01 20:20:06
--
GatherCommand = class("GatherCommand")
local instance = nil

--构造
--返回值(无)
function GatherCommand:ctor()
end

--获取单例
--返回值(单例)
function GatherCommand:getInstance()
    if instance == nil then
        instance = GatherCommand.new()
    end
    return instance
end

--打开提示框界面
--uiType UI类型
--data 数据
--返回值(无)
function GatherCommand:open(uiType,data)
	self.view = GatherMenuView.new(uiType,data)
	self.view.baseView:addToLayer(GAME_ZORDER.UI)
end

--显示菜单界面
function GatherCommand:showMenu()
	if self.view ~= nil then
		self.view:setVisible(true)
	end
end

--打开英雄列表
--uiType UI类型
--data 数据
--返回值(无)
function GatherCommand:showHeroList(uiType,data)
	self.heroListView = GatherHeroListView.new(uiType,data)
	self.heroListView:addToLayer(GAME_ZORDER.UI)
end

--关闭提示框界面
--返回值(无)
function GatherCommand:close()
	if self.view ~= nil then
		self.view.baseView:removeFromLayer()
		self.view = nil
	end
end

--刷新装备界面ui
--type 1穿装备返回 2脱装备返回
function GatherCommand:updateEquipUI(type)
	self.view.heroListView.weaponView:updateUI(type)
end

--刷新新技能界面ui
--skill 技能
function GatherCommand:updateNewSkillUI()
	self.view.heroListView.skillView:setNewSkillData()
end

--刷新旧技能界面ui
--skill 技能
function GatherCommand:updateOldSkillUI()
	self.view.heroListView.skillView:setOldSkillData()
end

-- 显示酒馆英雄列表
function GatherCommand:showHeroListFromInfo()
	-- 显示界面
    self.view.baseView:showView(self.view.heroListView)
    -- self.view.heroListView.heroInfoView:hideView()
    -- self.view.heroListView:showView()
	-- 加载英雄列表数据
	self.view.heroListView:createHeroList()
end