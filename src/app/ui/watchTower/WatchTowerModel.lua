--[[
	jinyan.zhang
	瞭望塔数据
--]]

WatchTowerModel = class("WatchTowerModel")

local instance = nil

--构造
--返回值(无)
function WatchTowerModel:ctor(data)
	self:init(data)
end

--初始化
--返回值(无)
function WatchTowerModel:init(data)
	self.watchtowerList = {}
	self.isNeedCreateWarnPic = false
end

--获取暸望塔列表
function WatchTowerModel:getList()
	return self.watchtowerList
end

-- 设置服务器下发的暸望塔数据
-- data 服务器下发的数据
function WatchTowerModel:setWatchTowerModel(data)
	self.watchtowerList = {}
	for k,v in pairs(data) do
		print("暸望塔列表的json:",v.data)
		local content = json.decode(v.data)
		self:createInfo(content,v.marchingid)
	end
	--更新UI操作
	local watchtowerCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY_WATCHTOWER)
	if watchtowerCtrl ~= nil then
		watchtowerCtrl:updateWatchtowerList()
	end
end

-- 瞭望塔列表数据
-- content 服务器下发json解析出来的数据（table）
-- marchingid 实例id
function WatchTowerModel:createInfo(content,marchingid)
	local info = {}
	--实例ID
	info.marchingid = marchingid
	--根据实例ID创建的唯一id
	info.id = marchingid.id_h .. marchingid.id_l 
	--行军类型（0：侦查，1：攻击）
	info.type = content.type
	--行军目标
	info.target = content.target
	--玩家名字
	info.name = content.name
	--头像ID
	info.imageId = content.imageId
	--开始时间
	info.startTime = content.startTime
	--用时
	info.interval = content.interval
	--玩家等级
	info.level = nil
	--X坐标
	info.x = nil
	--Y坐标
	info.y = nil
	--攻击阵营数据
	info.armsArray = nil
	table.insert(self.watchtowerList,info)
end

-- 瞭望塔列表详情数据
-- data 服务器下发的数据
function WatchTowerModel:detailtInfo(data)
	--实例ID
	local marchingid = data.marchingid
	--根据实例ID创建的唯一id
	local id = marchingid.id_h .. marchingid.id_l 
	local info =  self:getWatchTowerModelByID(id)
	if info == nil then
		return
	end
	--数据详情
	print("暸望塔详情json:",data.data)
	local detail = json.decode(data.data)
	--等级
	info.level = detail.level
	--X坐标
	info.x = detail.x
	--Y坐标
	info.y = detail.y
	if info.type == 1 then
		info.armsArray = {}
		for k,v in pairs(detail.armsArray) do
			info.armsArray[k] = {}
			--兵类型ID
			info.armsArray[k].type = v.type
			--等级
			info.armsArray[k].level = v.level
			--数量
			info.armsArray[k].number = v.number
		end
	end
	--更新UI操作
	local watchtowerCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY_WATCHTOWER)
	if watchtowerCtrl ~= nil then
		watchtowerCtrl:getWatchtowerDetail(info)
	end

end

-- 根据唯一id获取暸望塔数据
--id 唯一id
function WatchTowerModel:getWatchTowerModelByID(id)
	for k,v in pairs(self.watchtowerList) do
		if id == v.id then
			return v
		end
	end
end

-- 根据数组索引获取暸望塔数据
-- 索引
function WatchTowerModel:getWatchTowerModelByIndex(index)
	for k,v in pairs(self.watchtowerList) do
		if k == index then
			return v
		end
	end
end

--根据唯一id删除暸望塔数据
--id 唯一id
function WatchTowerModel:delWatchTowerModelByID(id)
	for k,v in pairs(self.watchtowerList) do
		if id == v.id then
			self.watchtowerList[k] = nil
			break
		end
	end
	--更新UI操作
	local watchtowerCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY_WATCHTOWER)
	if watchtowerCtrl ~= nil then
		watchtowerCtrl:updateWatchtowerList()
	end
end

--获取单例
--返回值(单例)
function WatchTowerModel:getInstance()
	if instance == nil then
		instance = WatchTowerModel.new()
	end
	return instance
end

--设置是否需要创建警告图片标志
--isNeedCreate(true:需要,false:不需要)
--返回值(无)
function WatchTowerModel:setIsNeedCreateWarnPicFlg(isNeedCreate)
	self.isNeedCreateWarnPic = isNeedCreate
	if self.isNeedCreateWarnPic then
        UICommon:getInstance():createBlankPic()
    else
        UICommon:getInstance():delBlankPic()
    end
end

--是否需要创建警告图片
--返回值(true:需要,false:不需要)
function WatchTowerModel:isNeedCreateWarnImg()
	return self.isNeedCreateWarnPic 
end

--清理缓存数据
--返回值(无)
function WatchTowerModel:clearCache()
	self:init()
end



