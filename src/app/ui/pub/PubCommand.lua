--
-- Author: oyhc
-- Date: 2015-11-27 17:22:34
--
PubCommand = class("PubCommand")
local instance = nil

--构造
--返回值(无)
function PubCommand:ctor()
end

--获取单例
--返回值(单例)
function PubCommand:getInstance()
    if instance == nil then
        instance = PubCommand.new()
    end
    return instance
end

--打开提示框界面
--uiType UI类型
--data 数据
--返回值(无)
function PubCommand:open(uiType,data)
	self.view = PubMainView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭提示框界面
--返回值(无)
function PubCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

-- 显示酒馆英雄列表
function PubCommand:showPubList(panel)
	if self.view ~= nil then
		self.view.pubMain:setVisible(false)
        -- 显示英雄列表
        self.view.heroListView:showView()
		-- 加载英雄列表数据
		self.view.heroListView:init(panel)
	end
end

-- 获得上次刷新时间
function PubCommand:getRefreshTime(refresh_time,state)
	if self.view ~= nil then
		self.view.heroListView:getRefreshTime(refresh_time,state)
	end
end

-- 显示酒馆英雄列表
function PubCommand:showPubListFromInfo(panel)
	if self.view ~= nil then
		self.view.heroInfoView:hideView()
        -- 显示英雄列表
        self.view.heroListView:showView()
		-- 加载英雄列表数据
		self.view.heroListView:init(panel)
	end
end