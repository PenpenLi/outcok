--
-- Author: Your Name
-- Date: 2016-01-05 15:52:10
--
TechnologyModel = class("TechnologyModel")

local instance = nil

--构造
--返回值(无)
function TechnologyModel:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function TechnologyModel:getInstance()
	if instance == nil then
		instance = TechnologyModel.new()
	end
	return instance
end

--初始化
--返回值(无)
function TechnologyModel:init()
	-- 军事页面列表
	self.milTechArr = {}
	-- 经济页面列表
	self.gdpTechArr = {}
	-- 防御页面列表
	self.defTechArr = {}
	-- 定时器id_h
	self.timeID_h = 0
	-- 定时器id_l
	self.timeID_l = 0
	-- 升级中的科技id
	self.techUpgradeID = 0
	-- 是否是立即研究的科技
	self.isQuickTech = false
	-- 创建科技数据
	self:createAllArr()
end

function TechnologyModel:getTimeId()
	return self.timeID_h,self.timeID_l
end

-- 创建科技数据
function TechnologyModel:createAllArr()
	--军事
	TechData:getInstance():createListByType(self.milTechArr, TechDataType.mil)
	--经济
	TechData:getInstance():createListByType(self.gdpTechArr, TechDataType.gdp)
	--防御
	TechData:getInstance():createListByType(self.defTechArr, TechDataType.def)
end

--获取列表成功
function TechnologyModel:getListSuccess(data)
	print("获取列表成功:",#data.milTechs,#data.gdpTechs,#data.defTechs,data.timeout)
	-- 设置军事科技
	TechData:getInstance():setTechInfo(data.milTechs,self.milTechArr)
	-- 设置经济科技
	TechData:getInstance():setTechInfo(data.gdpTechs,self.gdpTechArr)
	-- 设置防御科技
	TechData:getInstance():setTechInfo(data.defTechs,self.defTechArr)
	-- 添加定时器
	TimeInfoData:getInstance():addTimeInfo(data.timeout)
end

-- 升级中
function TechnologyModel:upgradeTechSuccess(data)
	print("升级中",data.timeout)
	-- 设置军事科技
	TechData:getInstance():setTechInfo({data.tech},self.milTechArr)
	-- 设置经济科技
	TechData:getInstance():setTechInfo({data.tech},self.gdpTechArr)
	-- 设置防御科技
	TechData:getInstance():setTechInfo({data.tech},self.defTechArr)
	-- 添加定时器
	TimeInfoData:getInstance():addTimeInfo(data.timeout)
	-- 扣资源
	PlayerData:getInstance():setPlayerGold(data.gold)
	PlayerData:getInstance().wood = data.wood
	PlayerData:getInstance().food = data.food
	PlayerData:getInstance().iron = data.iron
	PlayerData:getInstance().mithril = data.mithril
	self:setTechUpgradeData(data.timeout.id_h,data.timeout.id_l,data.tech.type_id)
    -- 刷新所有资源UI
	UICommon:getInstance():updatePlayerDataUI()
	-- 是否是立即研究的科技
	if self.isQuickTech == true then
		-- 设置升级中的科技数据
		self:setTechUpgradeData(0, 0, 0)
		local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.COLLEGE)
		if uiCommand ~= nil then
			uiCommand:updataTechUI()
		end
	else
		-- 关闭ui
		UIMgr:getInstance():closeUI(UITYPE.COLLEGE)
		--升级科技
		local command = MapMgr:getInstance():getCityBuildingListCtrl()
		if command ~= nil then
		 	command:upGradeTechnology()
		end
	end
end

-- 完成科技
function TechnologyModel:completeTech(data)
	print("完成科技")
	-- 设置军事科技
	TechData:getInstance():setTechInfo({data.tech},self.milTechArr)
	-- 设置经济科技
	TechData:getInstance():setTechInfo({data.tech},self.gdpTechArr)
	-- 设置防御科技
	TechData:getInstance():setTechInfo({data.tech},self.defTechArr)
	-- 删除定时器
	TimeInfoData:getInstance():detTimeInfoById(self.timeID_h, self.timeID_l)
	--删除定时器UI
	local command = MapMgr:getInstance():getCityBuildingListCtrl()
	if command ~= nil then
	 	command:delTechnologyProcess()
	end
	-- 设置升级中的科技数据
	self:setTechUpgradeData(0, 0, 0)
end

-- 设置升级中的科技数据
function TechnologyModel:setTechUpgradeData(id_h, id_l, id)
	-- 定时器id_h
	self.timeID_h = id_h
	-- 定时器id_l
	self.timeID_l = id_l
	-- 升级中的科技id
	self.techUpgradeID = id
end

--清理缓存
function TechnologyModel:clearCache()
	self:init()
end
