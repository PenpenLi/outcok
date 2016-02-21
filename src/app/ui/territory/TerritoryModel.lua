
--[[
	jinyan.zhang
	野外建筑数据
--]]

TerritoryModel = class("TerritoryModel")

local instance = nil
local _markId = 1

--创建一个标记id
--返回值(id)
function TerritoryModel:createMarkId()
    _markId = _markId + 1
    if _markId > 9999 then
        _markId = 1
    end
    return _markId
end

--获取单例
--返回值(单例)
function TerritoryModel:getInstance()
	if instance == nil then
		instance = TerritoryModel.new()
	end
	return instance
end

--清理缓存数据
--返回值(无)
function TerritoryModel:clearCache()
	self:init()
end

function TerritoryModel:ctor()
	self:init()
end

function TerritoryModel:init()
	self.useGoldAcceUpLevelInfo = {}
	self.usePropAcceUpLevelInfo = {}
	self.upLevelInfo = {}
	self.garrison = {}
end

--保存升级野外建筑信息
function TerritoryModel:saveUpLevelInfo(info)
    info.markId = self:createMarkId()
    table.insert(self.upLevelInfo,info)
end

--获取升级信息
function TerritoryModel:getUpLevelInfo(markId)
	for k,v in pairs(self.upLevelInfo) do
		if v.markId == markId then
			return v
		end 
	end
end

--删除升级信息
function TerritoryModel:delUpLevelInfo(markId)
	for k,v in pairs(self.upLevelInfo) do
		if v.markId == markId then
			table.remove(self.upLevelInfo,k)
			break
		end
	end
end

--保存使用金币加速升级信息
function TerritoryModel:saveUseGoldAcceInfo(info)
    info.markId = self:createMarkId()
    table.insert(self.useGoldAcceUpLevelInfo,info)
end

--获取使用金币加速升级信息
function TerritoryModel:getUseGoldAcceInfo(markId)
	for k,v in pairs(self.useGoldAcceUpLevelInfo) do
		if v.markId == markId then
			return v
		end
	end
end

--删除使用金币加速升级信息
function TerritoryModel:delUseGoldAcceInfo(markId)
	for k,v in pairs(self.useGoldAcceUpLevelInfo) do
		if v.markId == markId then
			table.remove(self.useGoldAcceUpLevelInfo,k)
			break
		end
	end
end

--保存使用道具加速升级信息
function TerritoryModel:saveUsePropAcceInfo(info)
    info.markId = self:createMarkId()
    table.insert(self.usePropAcceUpLevelInfo,info)
end

--获取使用道具加速升级信息
function TerritoryModel:getUsePropAcceInfo(markId)
	for k,v in pairs(self.usePropAcceUpLevelInfo) do
		if v.markId == markId then
			return v
		end
	end
end

--删除使用道具加速升级信息
function TerritoryModel:delUsePropAcceInfo(markId)
	for k,v in pairs(self.usePropAcceUpLevelInfo) do
		if v.markId == markId then
			table.remove(self.usePropAcceUpLevelInfo,k)
			break
		end
	end
end

--收到野外建筑列表
function TerritoryModel:recvOutBuildingList(data)
	--野外建筑基础实例列表
	local buildings = data.buildings
	--已放置的野外建筑实例列表
	local placeBuildings = data.placeBuildings
	OutBuildingData:getInstance():createBuildingList(buildings)
	OutPlaceBuildingData:getInstance():createBuildingList(placeBuildings)
end

--升级野外建筑结果
function TerritoryModel:upLevelBuildingRes(data)
	--添加到定时器列表中
	local timeInfo = TimeInfoData:getInstance():addTimeInfo(data)
	--获取本地保存的升级数据
	local info = self:getUpLevelInfo(timeInfo.markId)
	--把定时器和实例id相关联
	TimeInfoData:getInstance():setInstanceIdList(timeInfo.id_h,timeInfo.id_l,info.wildBuildingIds)
	--获取建筑信息
	local buildingInfo = OutBuildingData:getInstance():getInfoById(info.wildBuildingIds[1])
	--todo 刷新UI
	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
	if command ~= nil then
		command:updateUpLevelUI(buildingInfo.type,timeInfo.interval,info.wildBuildingIds)
	end
	--删除本地数据
	self:delUpLevelInfo(info.markId)
end

--完成升级野外建筑结果
function TerritoryModel:finishUpLevelBuildingRes(data)
	--建筑实例ID列表
	local wildBuildingIds = data.wildBuildings
	--玩家增加多少战力
	local fightforce = data.fightforce
	--等级
	local level = OutBuildingData:getInstance():getLevelById(wildBuildingIds[1]) + 1
	--设置建筑等级
    for k,v in pairs(wildBuildingIds) do
    	OutBuildingData:getInstance():setLevelById(v,level)
    end
	--删除定时器
	TimeInfoData:getInstance():delInfoByInstanceIdList(wildBuildingIds)
	--增加战斗力
    if fightforce ~= 0 then
        PlayerData:getInstance():increaseBattleForce(fightforce)
    end
    UICommon:getInstance():updatePlayerDataUI()
    --获取建筑信息
	local buildingInfo = OutBuildingData:getInstance():getInfoById(wildBuildingIds[1])
    --todo 刷新UI
    local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
	if command ~= nil then
		command:updateFinishUpLevelUI(buildingInfo.type,level,wildBuildingIds)
	end
end

--使用金币加速升级野外建筑结果
function TerritoryModel:useGoldUpLevelRes(data)
	--建筑实例ID列表
	local wildBuildingIds = data.wildBuildings
	--玩家增加多少战力
	local fightforce = data.fightforce 
	--客户端使用的id
	local markId = data.markId
	--等级
	local level = OutBuildingData:getInstance():getLevelById(wildBuildingIds[1]) + 1
	--设置建筑等级
    for k,v in pairs(wildBuildingIds) do
    	OutBuildingData:getInstance():setLevelById(v,level)
    end
    --删除定时器
	TimeInfoData:getInstance():delInfoByInstanceIdList(wildBuildingIds)

	--扣除金币
	local info = self:getUseGoldAcceInfo(markId)
	PlayerData:getInstance():setPlayerMithrilGold(info.castGold)
	--增加战斗力
    if fightforce ~= 0 then
        PlayerData:getInstance():increaseBattleForce(fightforce)
    end
    UICommon:getInstance():updatePlayerDataUI()
    --todo 刷新UI
    local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
	if command ~= nil then
		command:updateFinishAcceUI()
	end
	--删除本地数据
	self:delUseGoldAcceInfo(markId)
end

--使用道具加速升级建筑结果
function TerritoryModel:usePropUpLevelRes(data)
	--建筑实例ID
	--local wildBuildingId = data.wildBuildingId
	--使用掉的物品
	local items = data.items
	--客户端使用的id
	local markId = data.markId
	--本地配置
	local info = self:getUsePropAcceInfo(markId)
	--建筑实例ID
	local wildBuildingIds = info.wildBuildingIds
	--物品配置
	local config = ItemTemplateConfig:getInstance():getItemTemplateByID(items.templateId)
	--加速时间
	local second = config.it_turbotime*60
	--减少时间
	local timeInfo = TimeInfoData:getInstance():minusTimeByInstanceIdList(wildBuildingIds,second)
	if timeInfo == nil then
		--等级
		local level = OutBuildingData:getInstance():getLevelById(wildBuildingIds[1]) + 1
		--设置建筑等级
	    for k,v in pairs(wildBuildingIds) do
	    	OutBuildingData:getInstance():setLevelById(v,level)
	    end
	end
	--使用掉物品
	BagModel:getInstance():useItem(items)
	--todo 刷新UI
	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
	if command ~= nil then
		command:updateFinishAcceUI()
	end
	--删除本地配置
	self:delUsePropAcceInfo(markId)
end

--是否有野外建筑在升级
function TerritoryModel:isHaveUpLevelBuilding()
	local arryTime = TimeInfoData:getInstance():getTimeByAction(BuildingState.uplvingOut)
	if #arryTime > 0 then
		Lan:hintClient(17, "对不起!有建筑在升级中,无法再进行升级")
		return true
	end
	return false
end

--升级城堡后添加城墙数据
function TerritoryModel:syncAddOutWallRes(data)
	--野外建筑基础实例列表
	local buildings = data.buildings
	--新增的战斗力
	local fightForce = data.fightForce
	--增加战斗力
    if fightforce ~= 0 then
        PlayerData:getInstance():increaseBattleForce(fightforce)
    end
    UICommon:getInstance():updatePlayerDataUI()
    --创建野外建筑列表
    OutBuildingData:getInstance():createBuildingList(buildings)
end

--收到守军部队数据
function TerritoryModel:recvDeferArmsRes(data)
	self.garrison = data.garrison
	for k,v in pairs(self.garrison) do
		local heroId = v.heroId
		local arms = v.arms
		local hero = PlayerData:getInstance():getHeroById(heroId)
		if hero ~= nil then
			hero:setState(HeroState.garrison)
		end
		--删除部队
		ArmsData:getInstance():delArms(arms)
	end
end

--收到守军部队数据
function TerritoryModel:recvDeferArmListRes(data)
	self.garrison = data.garrison
	-- for k,v in pairs(self.garrison) do
	-- 	local heroId = v.heroId
	-- 	local arms = v.arms
	-- 	local hero = PlayerData:getInstance():getHeroById(heroId)
	-- 	if hero ~= nil then
	-- 		hero:setState(HeroState.garrison)
	-- 	end
	-- 	--删除部队
	-- 	ArmsData:getInstance():delArms(arms)
	-- end
end

function TerritoryModel:getDefArms()
	return self.garrison
end




