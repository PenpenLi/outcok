
--[[
	jinyan.zhang
	城内建筑数据
--]]

CityBuildingModel = class("CityBuildingModel")
local instance = nil
local _markId = 0

--创建一个标记id
--返回值(id)
function CityBuildingModel:createMarkId()
	_markId = _markId + 1
	if _markId > 9999 then
		_markId = 0
	end
	return _markId
end

--添加建筑数据
--data 数据
--返回值(建筑数据)
function CityBuildingModel:addBuildingData(data)
	local info = {}
	info.type = data.type 				 --建筑类型
	info.level = data.level    			 --建筑等级
	info.builderid_h = data.builderid_h  --建筑列表ID（锤子）builder ,升级建造使用builder, 如果没有升级或创建两个值为0
	info.builderid_l = data.builderid_l
	info.pos = data.pos  				 --建筑所在的格子位置, 从0开始
	info.timeoutid_h = data.timeoutid_h  --定时器ID，定时器timeout, 造兵等等使用timeout, 如果没有建筑内部创建两个值为0
	info.timeoutid_l = data.timeoutid_l
	table.insert(self.buildInfo,info)
	return info
end

--[[
	客户端本地保存的数据
--]]
--保存本地数据至建筑升级表中
--返回值(无)
function CityBuildingModel:saveBuildingRemoveLocalData(data)
	--[[
	for k,v in pairs(self.buildingUpLocalData) do
		if data.buildingPos == v.buildingPos then
			self.buildingUpLocalData[k] = nil
			break
		end
	end
	--]]

	data.markId = self:createMarkId()
	table.insert(self.buildingRemoveLocalData,data)
end

--获取本地建筑拆除数据
--markId 标记id
--返回值(建筑升级数据)
function CityBuildingModel:getBuildingRemoveLocalData(markId)
	for k,v in pairs(self.buildingRemoveLocalData) do
		if v.markId == markId then
			return v
		end
	end
end

--删除本地建筑拆除数据
--markId 标记id
--返回值(无)
function CityBuildingModel:delBuildingRemoveLocalData(markId)
	for k,v in pairs(self.buildingRemoveLocalData) do
		if v.markId == markId then
			self.buildingRemoveLocalData[k] = nil
			break
		end
	end
end

--[[
	客户端本地保存的数据
--]]
--保存本地数据至建筑升级表中
--返回值(无)
function CityBuildingModel:saveBuildingUpLocalData(data)
	--[[
	for k,v in pairs(self.buildingUpLocalData) do
		if data.buildingPos == v.buildingPos then
			self.buildingUpLocalData[k] = nil
			break
		end
	end
	--]]

	data.markId = self:createMarkId()
	table.insert(self.buildingUpLocalData,data)
	table.insert(self.buildInfo,data)
end

--获取本地建筑升级数据
--markId 标记id
--返回值(建筑升级数据)
function CityBuildingModel:getBuildingUpLocalData(markId)
	for k,v in pairs(self.buildingUpLocalData) do
		if v.markId == markId then
			return v
		end
	end
end

--删除本地建筑升级数据
--markId 标记id
--返回值(无)
function CityBuildingModel:delBuildingUpLocalData(markId)
	for k,v in pairs(self.buildingUpLocalData) do
		if v.markId == markId then
			self.buildingUpLocalData[k] = nil
			break
		end
	end
end

--[[
	城内建筑数据处理
--]]

--构造
--返回值(无)
function CityBuildingModel:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function CityBuildingModel:getInstance()
	if instance == nil then
		instance = CityBuildingModel.new()
	end
	return instance
end

--获取服务端下发的建筑信息
--pos 建筑位置
--返回值(建筑信息)
function CityBuildingModel:getBuildInfo(pos)
	for k,v in pairs(self.buildInfo) do
		if v.pos == pos then
			return v
		end
	end
end

--获取服务端下发的建筑信息
--buildingType 建筑类型
--返回值(建筑信息)
function CityBuildingModel:getBuildInfoByType(buildingType)
	for k,v in pairs(self.buildInfo) do
		if v.type == buildingType then
			return v
		end
	end
end

--根据建筑类型获取总训练量
--buildingType 建筑类型
--返回值(建筑信息数组)
function CityBuildingModel:getBuildListByType(buildingType)
	local arr = {}
	for k,v in pairs(self.buildInfo) do
		if v.type == buildingType then
			table.insert(arr,v)
		end
	end
	return arr
end

--服务端下发的建筑类型(先获取一下服务端下发的建筑信息，如果没下发，那就读取本地配置表里配置的信息)
--pos 建筑位置
--返回值(建筑类型)
function CityBuildingModel:getBuildType(pos)
	local info = self:getBuildInfo(pos)
	if info ~= nil then
		return info.type
	end

	info = self:getBuilderInfo(pos)
	if info ~= nil then
		return info.type
	end

	return BuildPosConfig:getInstance():getConfigInfoByPos(pos).buildType
end

--获取建筑等级
--buildingPos 建筑位置
--返回值(建筑等级)
function CityBuildingModel:getBuildingLv(buildingPos)
	local info = self:getBuildInfo(buildingPos)
	if info ~= nil then
		return info.level
	end
end

--获取建筑等级
--buildingType 建筑类型
--返回值(建筑等级)
function CityBuildingModel:getBuildingLvByType(buildingType)
	local info = self:getBuildInfoByType(buildingType)
	if info ~= nil then
		return info.level
	end
end

--获取服务端下发的建筑信息
--buildingType 建筑类型
--返回值(建筑信息)
function CityBuildingModel:getBuildInfoByBuildingType(buildingType)
	for k,v in pairs(self.buildInfo) do
		if v.type == buildingType then
			return v
		end
	end
end

--服务端下发的建筑位置
--buildingType 建筑类型
--返回值(建筑位置)
function CityBuildingModel:getBuildingPos(buildingType)
	local info = self:getBuildInfoByBuildingType(buildingType)
	if info ~= nil then
		return info.pos
	end
end

--获取升级和建造列表中的建筑信息
--buildingPos 建筑位置
--返回值(建筑信息)
function CityBuildingModel:getBuilderInfo(buildingPos)
	for k,v in pairs(self.builders) do
        if v.buildingPos == buildingPos then
            return v
        end
    end
end

--是否是兵营
--buildingType 建筑类型
--返回值(true:是，false:否)
function CityBuildingModel:isBarracks(buildingType)
	if buildingType == BuildType.infantryBattalion or buildingType == BuildType.cavalryBattalion or
		buildingType == BuildType.archerCamp or buildingType == BuildType.chariotBarracks
		or buildingType == BuildType.masterBarracks then
		return true
	end
	return false
end

--获取城墙外剩余空地数量
--返回值(剩余空地数量)
function CityBuildingModel:getOutWallLeftEmptyCount()
	local useTotal = 0
	local emptyList = BuildingTypeConfig:getInstance():getOutWallEmptyList()
	for k,v in pairs(emptyList) do
		local count = self:getHaveCreatBuildingCountByType(v.buildType)
		useTotal = useTotal + count
	end
	return self:getOutWallTotalEmptyCount() - useTotal
end

--获取城墙外空地总数量
--返回值(总数量)
function CityBuildingModel:getOutWallTotalEmptyCount()
	local total = 0
	local emptyList = BuildingTypeConfig:getInstance():getOutWallEmptyList()
	for k,v in pairs(emptyList) do
		total = total + v.count
	end
	return total
end

--获取已经建造的建筑个数
--buildingType 建筑类型
--返回值(建筑个数)
function CityBuildingModel:getHaveCreatBuildingCountByType(buildingType)
	local count = 0
	for k,v in pairs(self.buildInfo) do
		if v.type == buildingType then
			count = count + 1
		end
	end

	for k,v in pairs(self.builders) do
		if v.type == buildingType then
			count = count + 1
			break
		end
	end

	return count
end

--建筑是否丰收
--buildingPos 建筑位置
--返回值(true:是，false:否)
function CityBuildingModel:isBuildingHarvest(buildingPos)
	for k,v in pairs(self.buildInfo) do
		if v.pos == buildingPos then
			if v.state == ResourceState.harvest then
				return true
			end
			return false
		end
	end
	return false
end

--获取升级建筑的条件
--buildingType 建筑类型
--buildingLv 建筑等级
--num 建筑数量
--返回值(创建条件列表)
function CityBuildingModel:getUpBuildingCondition(buildingType,buildingLv,num)
	num = num or 1
	local index = 1
	local textInfo = {}
	local info = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingLv)
	local building1Name = BuildingTypeConfig:getInstance():getBuildingNameByType(info.bu_needbuilding1)
	local building1Lv = info.bu_needbuilding1level
	if building1Name ~= nil and building1Lv > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		local building1CurLv = self:getBuildingLvByType(info.bu_needbuilding1)
		if building1CurLv == nil or building1CurLv < building1Lv then  --前置前建筑还未创建或者等级不够
			color = cc.c3b(255,0,0)
			haveArrive = false
		end
		textInfo[index] = {}
		textInfo[index].name = building1Name .. " " .. building1Lv .. CommonStr.LEVEL
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
		index = index + 1
	end

	local building2Name = BuildingTypeConfig:getInstance():getBuildingNameByType(info.bu_needbuilding2)
	local building2Lv = info.bu_needbuilding2level
	if building2Name ~= nil and building2Lv > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		local building2CurLv = self:getBuildingLvByType(info.bu_needbuilding2)
		if building2CurLv == nil or building2CurLv < building2Lv then  --前置前建筑还未创建或者等级不够
			color = cc.c3b(255,0,0)
			haveArrive = false
		end
		textInfo[index] = {}
		textInfo[index].name = building2Name .. " " .. building2Lv .. CommonStr.LEVEL
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
		index = index + 1
	end

	if info.bu_grain > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		if PlayerData:getInstance().food < info.bu_grain*num then  --粮食不够
			color = cc.c3b(255,0,0)
			haveArrive = false
		end
		textInfo[index] = {}
		textInfo[index].name = CommonStr.FOOD .. " " .. info.bu_grain*num
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
		index = index + 1
	end

	if info.bu_wood > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		if PlayerData:getInstance().wood < info.bu_wood*num then
			color = cc.c3b(255,0,0)
			haveArrive = false
		end
		textInfo[index] = {}
		textInfo[index].name = CommonStr.WOOD .. " " .. info.bu_wood*num
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
		index = index + 1
	end

	if info.bu_iron > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		if PlayerData:getInstance().iron < info.bu_iron*num then
			color = cc.c3b(255,0,0)
			haveArrive = false
		end
		textInfo[index] = {}
		textInfo[index].name = CommonStr.IRON .. " " .. info.bu_iron*num
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
		index = index + 1
	end

	if info.bu_mithril > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		if PlayerData:getInstance().mithril < info.bu_mithril*num then
			color = cc.c3b(255,0,0)
			haveArrive = false
		end
		textInfo[index] = {}
		textInfo[index].name = CommonStr.MITHRIL .. " " .. info.bu_mithril*num
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
	end

	if info.bu_prop > 0 then
		local haveArrive = true
		local color = cc.c3b(0,0,0)
		local propId = CommonConfig:getInstance():getDefTowerPropID()
		local itemConfig = ItemTemplateConfig:getInstance():getItemTemplateByID(propId)
		if itemConfig == nil then
            print("读取物品配置失败")
            return
        end
        local item = ItemData:getInstance():getItemByID(propId)
        if item == nil or item.number < info.bu_prop*num then
        	color = cc.c3b(255,0,0)
			haveArrive = false
        end
        textInfo[index] = {}
		textInfo[index].name = Lan:lanText(3,"需要") .. itemConfig.it_name .. "  x" .. info.bu_prop*num
		textInfo[index].color = color
		textInfo[index].haveArrive = haveArrive
		textInfo[index].useProp = true
	end

	return textInfo
end

--获取建筑升级剩余时间
--beginTime 开始时间戳
--needTime 需要时间
--返回值(建筑升级时间)
function CityBuildingModel:getLeftUpBuildingTime(beginTime,needTime)
	local passTime = Common:getOSTime() - beginTime
	local leftTime =  needTime - passTime
	if leftTime < 0 then
		leftTime = 0
	end
	return leftTime
end

--获取建筑升级或者建筑剩余的进度时间
--pos 建筑位置
--返回值(时间)
function CityBuildingModel:getBuildingLeftProcessTime(pos)
	for k,v in pairs(self.builders) do
		if v.buildingPos == pos and v.finished == 0 then
			local passTime = Common:getOSTime() - v.start_time
			local leftTime = v.interval - passTime
			if leftTime < 0 then
				leftTime = 0
			end
			return leftTime
		end
	end
end

--设置建筑状态
--buildingPos 建筑位置
--state 建筑状态
--返回值(无)
function CityBuildingModel:setBuildingState(buildingPos,state)
	for k,v in pairs(self.buildInfo) do
		if v.pos == buildingPos then
			v.state = state
		end
	end
end

--设置建筑位置
--id_l,id_h 定时器高低位id
--buildingPos 建筑位置
--返回值(无)
function CityBuildingModel:setBuilderBuildingPos(id_l,id_h,buildingPos)
	for k,v in pairs(self.builders) do
		if v.id_l == id_l and v.id_h == id_h then
			v.buildingPos = buildingPos
			break
		end
	end
end

--设置建筑等级
--buildingPos 建筑位置
--buildingLv  建筑等级
--返回值(true:成功,false:失败)
function CityBuildingModel:setBuildingLv(buildingPos,buildingLv)
	for k,v in pairs(self.buildInfo) do
	    if v.pos == buildingPos then
	       v.level = buildingLv
	       return true
	    end
	end
	return false
end

--能否升级建筑
--buildingType 建筑类型
--lv 建筑要提升的的等级
--返回值(true:能,false:否)
function CityBuildingModel:isCanUpBuidling(buildingType,lv)
	if self:isHaveBuildingUp(true) then
		return false
	end

	local info = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,lv)
	if info == nil then
		return false
	end

	local building1Lv = self:getBuildingLvByType(info.bu_needbuilding1)
	if building1Lv == nil then  --前置前建筑还未创建
		return false
	end

	if building1Lv < info.bu_needbuilding1level then  --前置建筑等级不够
		return false
	end

	local building2Lv = self:getBuildingLvByType(info.bu_needbuilding2)
	if building2Lv == nil then  --前置前建筑还未创建
		return false
	end

	if building2Lv < info.bu_needbuilding2level then  --前置建筑等级不够
		return false
	end

	if PlayerData:getInstance().food < info.bu_grain then  --粮食不够
		return false
	end

	if PlayerData:getInstance().wood < info.bu_wood then  --木材不够
		return false
	end

	if PlayerData:getInstance().iron < info.bu_iron then  --铁矿不够
		return false
	end

	if PlayerData:getInstance().mithril < info.bu_mithril then  --秘银不够
		return false
	end

	return true
end

--是否有建筑在升级或者建造中
--返回值(true:是，false:否)
function CityBuildingModel:isHaveBuildingUp(isNeedProp)
	for k,v in pairs(self.builders) do
		if v.finished == BuidState.UN_FINISH then
			if v.action == BuildingState.createBuilding then
				if isNeedProp then
					Prop:getInstance():showMsg(CommonStr.HAVE_BUILDING_MAKE)
				end
			elseif action == BuildingState.removeBuilding then
				if isNeedProp then
					Prop:getInstance():showMsg(CommonStr.HAVE_BUILDING_REMOVE)
				end
			elseif action == BuildingState.uplving then
				if isNeedProp then
					Prop:getInstance():showMsg(CommonStr.HAVE_BUILDING_UP)
				end
			else
				if isNeedProp then
					Prop:getInstance():showMsg(CommonStr.HAVE_BUILDING_UP)
				end
			end

			return true
		end
	end
    return false
end

--是否已经创建过该建筑
--buildingType 建筑类型
--返回值(true:是,false:否)
function CityBuildingModel:isHaveCreateBuilding(buildingType)
	for k,v in pairs(self.buildInfo) do
		if v.type == buildingType then
			return true
		end
	end

	for k,v in pairs(self.builders) do
		if v.type == buildingType then
			return true
		end
	end

	return false
end

--获取建筑状态
--pos 建筑位置
--返回值(建筑状态)
function CityBuildingModel:getBuildingState(pos)
    for k,v in pairs(self.builders) do
        if v.buildingPos == pos and v.finished == BuidState.UN_FINISH then
            return v.action
        end
    end

    local timeInfo = TimeInfoData:getInstance():getTimeInfoByBuildingPos(pos)
    if timeInfo ~= nil and timeInfo.action ~= TimeAction.produc_res_speed then
    	return timeInfo.action
    end

    if MakeSoldierModel:getInstance():isHaveReadyArms(pos) then
    	return BuildingState.makeSoldiers
    end

	return BuildingState.buildOk
end

--删除正在升级或者建造中的建筑列表
--buildingPos 建筑位置
--返回值(无)
function CityBuildingModel:delBuilder(buildingPos)
	for k,v in pairs(self.builders) do
		if v.buildingPos == buildingPos then
			self.builders[k] = nil
			break
		end
	end
end

--减少建筑时间
--buildingPos 建筑位置
--返回值(无)
function CityBuildingModel:minusBuilderTime(buildingPos,changeTime)
	for k,v in pairs(self.builders) do
		if v.buildingPos == buildingPos then
			v.interval = v.interval - changeTime
			if v.interval < 0 then
				v.interval = 0
			end
			return v
		end
	end
end

--模拟服务器数据，测试用的
--返回值(无)
function CityBuildingModel:testData()
	--城堡
	local info = {}
	info.type = BuildType.castle 				
	info.level = 1   			 
	info.builderid_h = 0
	info.builderid_l = 0
	info.pos = 0  				
	info.timeoutid_h = 0
	info.timeoutid_l = 0
	table.insert(self.buildInfo,info)

	--步兵营
	local info = {}
	info.type = BuildType.infantryBattalion 				
	info.level = 1   			 
	info.builderid_h = 0
	info.builderid_l = 0
	info.pos = 2  				
	info.timeoutid_h = 0
	info.timeoutid_l = 0
	table.insert(self.buildInfo,info)

	--城墙
	local info = {}
	info.type = BuildType.wall 				
	info.level = 1   			 
	info.builderid_h = 0
	info.builderid_l = 0
	info.pos = 1  				
	info.timeoutid_h = 0
	info.timeoutid_l = 0
	table.insert(self.buildInfo,info)

	--仓库
	local info = {}
	info.type = BuildType.warehouse 				
	info.level = 1   			 
	info.builderid_h = 0
	info.builderid_l = 0
	info.pos = 7  				
	info.timeoutid_h = 0
	info.timeoutid_l = 0
	table.insert(self.buildInfo,info)

	--酒錧
	local info = {}
	info.type = BuildType.PUB 				
	info.level = 4   			 
	info.builderid_h = 0
	info.builderid_l = 0
	info.pos = 3  				
	info.timeoutid_h = 0
	info.timeoutid_l = 0
	table.insert(self.buildInfo,info)

	--训练场
	local info = {}
	info.type = BuildType.trainingCamp 				
	info.level = 4   			 
	info.builderid_h = 0
	info.builderid_l = 0
	info.pos = 3  				
	info.timeoutid_h = 0
	info.timeoutid_l = 0
	table.insert(self.buildInfo,info)
end

--添加建筑相关定时器
--data 定时器信息
--返回值(无)
function CityBuildingModel:addBuilderInfo(data)
	local info = {}
	info.pos = data.pos    --锤子位置
	info.id_h = data.id_h 	--定时器id
	info.id_l = data.id_l
	info.start_time = Common:getOSTime()  --定时器开始时间点
	info.interval = data.interval  --定时时长(秒)
	info.finished = data.finished  --定时器状态
	info.action = data.action     --定时器类型
	info.markId = data.markId 	  --客户端用的标记id
	table.insert(self.builders,info)
end

--初始化
--返回值(无)
function CityBuildingModel:init()
	self.buildInfo = {}  --建筑信息
	self.builders = {}   --升级或者创建中的建筑信息
	self.resInfo = {}    --建筑生产的资源信息
	self.buildingUpLocalData = {}  --本地升级建筑数据
	self.buildingRemoveLocalData = {} --本地拆除建筑数据
	--self:testData()
end

--保存登录时服务端下发的建筑信息
--data 数据
--返回值(无)
function CityBuildingModel:setBuildingData(data)
	for k,v in pairs(data.buildings) do
		self:addBuildingData(v)
	end

	MyLog("self.buildInfo count=", #self.buildInfo,"self.buildInfo=",self.buildInfo)
	for k,v in pairs(self.buildInfo) do
		local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(v.type)
		MyLog("self.buildInfo type=",v.type,"pos=",v.pos,"buildingName=",buildingName)
	end

	for k,v in pairs(data.builders) do
		self:addBuilderInfo(v)
	end

	for k,v in pairs(self.buildInfo) do
		if v.builderid_h ~= 0 or v.builderid_l ~= 0 then
			for k,builder in pairs(self.builders) do
				if v.builderid_h == builder.id_h and v.builderid_l == builder.id_l then
					builder.buildingPos = v.pos
					builder.type = v.type
					break
				end
			end
		end

		TimeInfoData:getInstance():setBuildingPos(v.timeoutid_h,v.timeoutid_l,v.pos)
	end

	--[[
	for k,v in pairs(self.builders) do
		local needTime = 0
		local buildingType = self:getBuildType(v.buildingPos)
		local buildingInfo = self:getBuildInfo(v.buildingPos)
		local upInfo = self:getBuildingUpInfo(buildingType,buildingInfo.level+1)
		if v.action == BuildingState.createBuilding then
			local upInfo = self:getBuildingUpInfo(buildingType,1)
			needTime = upInfo.bu_time
		elseif v.action == BuildingState.uplving then
			local upInfo = self:getBuildingUpInfo(buildingType,buildingInfo.level+1)
			needTime = upInfo.bu_time
		elseif v.action == BuildingState.removeBuilding then
			local upInfo = self:getBuildingUpInfo(buildingType,buildingInfo.level+1)
			needTime = upInfo.bu_time/2
		end
		local curTime = Common:getOSTime()
		local passTime = needTime - v.interval
		if passTime < 0 then
			passTime = 0
		end
		v.start_time = curTime - passTime
	end

	for k,v in pairs(self.timeouts) do

		local curTime = Common:getOSTime()
		v.start_time = curTime - v.interval
	end
	--]]
end

--建筑升级需要消耗的材料
--buildingPos 建筑位置
--buildingType 建筑类型
--返回值(无)
function CityBuildingModel:buildingUpgtadeCost(buildingPos,buildingType)
	-- body
	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
	if buildingInfo == nil then
		return
	end
	local nextLV = buildingInfo.level + 1
	local nextInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,nextLV)
	self:castResource(nextInfo,buildingType)
end

function CityBuildingModel:castResource(info,buildingType)
	local playerData = PlayerData:getInstance()
    --木材
    if info.bu_wood ~= nil then
        playerData:setPlayerWood(info.bu_wood)
    end

    --粮食
    if info.bu_grain ~= nil then
        playerData:setPlayerFood(info.bu_grain)
    end

    --矿石
    if info.bu_iron ~= nil then
        playerData:setPlayerIron(info.bu_iron)
    end

    --秘银
    if info.bu_mithril ~= nil then
        playerData:setPlayerMithril(info.bu_mithril)
    end

    --扣道具
    if info.bu_prop ~= nil and info.bu_prop > 0 then
    	if buildingType == BuildType.arrowTower or buildingType == BuildType.turret 
		or buildingType == BuildType.magicTower then
			local propId = CommonConfig:getInstance():getDefTowerPropID()
        	ItemData:getInstance():useItemById(propId,info.bu_prop)
		end
    end
    UICommon:getInstance():updatePlayerDataUI()
end

--创建建筑
--data 数据
--返回值(无)
function CityBuildingModel:syncCreateBuildingData(data)
	for k,v in pairs(self.builders) do
		if data.id_h == v.id_h and data.id_l == v.id_l then
			self.builders[k] = nil
			break
		end
	end
	data.start_time = Common:getOSTime()
	table.insert(self.builders,data)
	self:createHammerBuildTime(data.buildingPos)
	self:buildingUpgtadeCost(data.buildingPos,data.type)

	--关掉UI
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_LIST)
    UIMgr:getInstance():closeUI(UITYPE.OUT_WALL_BUILDINGLIST)
    UIMgr:getInstance():closeUI(UITYPE.TOWER_DEFENSE_LIST)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
    UICommon:getInstance():updatePlayerDataUI()

     --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		--通知UI刷新创建建筑
    	cityBuildingListCtrl:updateCreateBuildingUI(data.buildingPos,data.type,BuidState.UN_FINISH,data.start_time,data.interval)
	end
end

--完成创建建筑
--data 数据
--返回值(无)
function CityBuildingModel:syncFinishCreateBuildingData(data)
	local fightforce = data.fightforce
	local buildingData = data.building
	local buildingInfo = self:addBuildingData(buildingData)
	self:delHammerBuildTime(buildingInfo.pos)
    self:delBuilder(buildingInfo.pos)

	if fightforce ~= 0 then
		PlayerData:getInstance():increaseBattleForce(fightforce)
	end
	UICommon:getInstance():updatePlayerDataUI()

    --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		--通知UI刷新创建建筑
        cityBuildingListCtrl:updateCreateBuildingUI(buildingInfo.pos,buildingInfo.type,BuidState.FINISH)
	end
end

--升级建筑
--data 数据
--返回值(无)
function CityBuildingModel:syncUpLvBuildingData(data)
	for k,v in pairs(self.builders) do
		if data.id_h == v.id_h and data.id_l == v.id_l then
			table.remove(self.builders,k)
			break
		end
	end
	data.start_time = Common:getOSTime()
	table.insert(self.builders,data)
	self:createHammerBuildTime(data.buildingPos)
	self:buildingUpgtadeCost(data.buildingPos,data.type)

	--关掉UI
	UIMgr:getInstance():closeUI(data.type)
	UIMgr:getInstance():closeUI(UITYPE.OUT_WALL_BUILDINGLIST)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_UPGRADE)
    UIMgr:getInstance():closeUI(UITYPE.TOWER_DEFENSE_LIST)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	UICommon:getInstance():updatePlayerDataUI()

     --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		--todo 通知客户端建筑等级提升了
	 	cityBuildingListCtrl:updateUpBuildingUI(data.buildingPos,data.type,BuidState.UN_FINISH,data.start_time,data.interval)
	end
end

--完成升级建筑
--data 数据
--返回值(无)
function CityBuildingModel:syncUpLvBuildingFinishData(data)
	local buildingPos = data.pos
	local level = data.level
	local fightforce = data.fightforce

	for k,v in pairs(self.buildInfo) do
	    if v.pos == buildingPos then
	       v.level = level
	       break
	    end
	end
	self:delHammerBuildTime(buildingPos)
	self:delBuilder(buildingPos)

	if fightforce ~= 0 then
		PlayerData:getInstance():increaseBattleForce(fightforce)
	end
	UICommon:getInstance():updatePlayerDataUI()

    --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
       	--todo 通知客户端建筑等级提升了
	 	cityBuildingListCtrl:updateUpBuildingUI(buildingPos,0,BuidState.FINISH)
	end
end

--移除建筑
--data 数据
--返回值(无)
function CityBuildingModel:syncDelBuildingData(data)
	for k,v in pairs(self.builders) do
		if data.id_h == v.id_h and data.id_l == v.id_l then
			self.builders[k] = nil
			break
		end
	end
	data.start_time = Common:getOSTime()
	self:addBuilderInfo(data)
	self:setBuilderBuildingPos(data.id_l,data.id_h,data.buildingPos)
	self:createHammerBuildTime(data.buildingPos)

	--关掉UI
	UIMgr:getInstance():closeUI(UITYPE.OUT_WALL_BUILDINGLIST)
	UIMgr:getInstance():closeUI(UITYPE.TOWER_DEFENSE_LIST)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_RES_DETAILS)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_AID_DETAILS)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MARCH_DETAILS)
    UIMgr:getInstance():closeUI(UITYPE.TOWER_DETAILS)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
    UICommon:getInstance():updatePlayerDataUI()

    --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		--todo 通知客户端删除建筑
		cityBuildingListCtrl:updateRemoveBuildingUI(data.buildingPos,data.type,BuidState.UN_FINISH,data.start_time,data.interval)
	end
end

--删除建筑数据
--buildingPos 建筑位置
--返回值(无)
function CityBuildingModel:delBuildingDataByPos(buildingPos)
	for k,v in pairs(self.buildInfo) do
        if v.pos == buildingPos then
        	self.buildInfo[k] = nil
			break
		end
	end
end

--完成移除建筑
--data 数据
--返回值(无)
function CityBuildingModel:syncDelBuildingFinishData(data)
	local buildingPos = data.pos
	local fightforce = data.fightforce
	self:delHammerBuildTime(buildingPos)
	self:delBuildingDataByPos(buildingPos)

	self:delBuilder(buildingPos)
	TimeInfoData:getInstance():delTimeInfoByBuildingPos(buildingPos)

	if fightforce ~= 0 then
		PlayerData:getInstance():minusBattleForce(fightforce)
	end
	UICommon:getInstance():updatePlayerDataUI()

	--移除建筑后删除详情UI
	local detailsCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.BUILDING_RES_DETAILS)
	if detailsCommand ~= nil then
		if detailsCommand:getBuildingPos() == buildingPos then
			UIMgr:getInstance():closeUI(UITYPE.BUILDING_RES_DETAILS)
			Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_DESTORY)
		end
	end

	--移除建筑后删除建筑菜单UI
	local buildingMenuCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.BUILDING_MENU)
	if buildingMenuCommand ~= nil then
		if buildingMenuCommand:getBuildingPos() == buildingPos then
			UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
			Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_DESTORY)
		end
	end

	--移除建筑删除提示框UI
	local propBoxCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
	if propBoxCommand ~= nil then
		if propBoxCommand:getBuildingPos() == buildingPos then
			UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
			Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_DESTORY)
		end
	end

	--移除建筑后删除加速建筑UI
	local buildingAccelerationCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.BUILDING_ACCELERATION)
	if buildingAccelerationCommand ~= nil then
		if buildingAccelerationCommand:getBuildingPos() == buildingPos then
			UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
			Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_DESTORY)
		end
	end

	--刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
	 	cityBuildingListCtrl:updateRemoveBuildingUI(buildingPos,0,BuidState.FINISH)
	end
end

--取消移除建筑结果
--data 数据
--返回值(无)
function CityBuildingModel:cancelRemoveBuildingRes(data)
	local buildingPos = data.pos
	self:delHammerBuildTime(buildingPos)
	self:delBuilder(buildingPos)

	UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
	UICommon:getInstance():updatePlayerDataUI()

	 --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		--todo 通知客户端建筑等级提升了
	 	cityBuildingListCtrl:finishUpBuilding(buildingPos)
	end
end

--取消升级建筑结果
--返回值(无)
function CityBuildingModel:syncCancelUpBuildingRes(data)
	local buildingPos = data.pos
	self:delHammerBuildTime(buildingPos)
	self:delBuilder(buildingPos)

	--建筑描述
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    local info = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level+1)

    PlayerData:getInstance():increaseFood(math.ceil(info.bu_grain/2))
    PlayerData:getInstance():increaseWood(math.ceil(info.bu_wood/2))
    PlayerData:getInstance():increaseIron(math.ceil(info.bu_iron/2))
    PlayerData:getInstance():increaseMithril(math.ceil(info.bu_mithril/2))
    UICommon:getInstance():updatePlayerDataUI()

	UIMgr:getInstance():closeUI(buildingType)
	UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)

    --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
       	--todo 通知客户端建筑等级提升了
	 	cityBuildingListCtrl:updateUpBuildingUI(data.pos,0,BuidState.FINISH)
	end
end

--收集资源结果
--data 数据
--返回值(无)
function CityBuildingModel:collectingResourcesRes(data)
	local buildingPos = data.pos  --建筑位置
	local collect = data.collect  --收集数量
	local status = data.status    --仓库状态
	if collect == 0 then
		Prop:getInstance():showMsg(CommonStr.NO_RES_CAN_COLLECT)
		return
	end
	Prop:getInstance():showMsg(CommonStr.COLLECT_RES_NUM .. collect)

	local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
	if buildingType == BuildType.farmland then
		PlayerData:getInstance():increaseFood(collect)
	elseif buildingType == BuildType.loggingField then
		PlayerData:getInstance():increaseWood(collect)
	elseif buildingType == BuildType.ironOre then
		PlayerData:getInstance():increaseIron(collect)
	elseif buildingType == BuildType.illithium then
		PlayerData:getInstance():increaseMithril(collect)
	end

	--改变丰收状态
	self:setBuildingState(buildingPos,ResourceState.noHarvest)

	local warehouse = self:getBuildInfoByType(BuildType.warehouse)
	self:setBuildingState(warehouse.pos,status)

	UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	UICommon:getInstance():updatePlayerDataUI()

	 --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
       	--todo 通知客户端建筑等级提升了
	 	cityBuildingListCtrl:harvestRes(buildingPos)
	end
end

--通知资源田完成生产结果
--data 数据
--返回值(无)
function CityBuildingModel:recvNoticeHarvestResourcesRes(data)
	local buildingPos = data.pos  --建筑位置
	--改变丰收状态
	self:setBuildingState(buildingPos,ResourceState.harvest)

	 --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
	 	cityBuildingListCtrl:noticeHarvestRes(buildingPos)
	end
end

--清理缓存数据
--返回值(无)
function CityBuildingModel:clearCache()
	self:init()
end

--创建锤子建造时间
--buildingPos 建筑位置
--返回值(无)
function CityBuildingModel:createHammerBuildTime(buildingPos)
	local cityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCommand == nil then
		return
	end

	local builderInfo = self:getBuilderInfo(buildingPos)
	if builderInfo == nil then
		return
	end

	local leftTime = self:getBuildingLeftProcessTime(buildingPos)
	if leftTime == nil or leftTime == 0 then
		return
	end

	if builderInfo.pos == 0 then
		cityCommand:createFirstHammerBuildTime(leftTime)
	else
		--todo
	end
end

--删除锤子建造时间
--buildingPos 建筑位置
--返回值(无)
function CityBuildingModel:delHammerBuildTime(buildingPos)
	local cityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCommand == nil then
		return
	end

	local builderInfo = self:getBuilderInfo(buildingPos)
	if builderInfo == nil then
		return
	end

	if builderInfo.pos == 0 then
		cityCommand:delFirstHammerBuildTime()
	else
		--todo
	end
end



