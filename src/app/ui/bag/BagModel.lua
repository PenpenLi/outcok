--
-- Author: oyhc
-- Date: 2015-12-04 15:55:34
--
BagModel = class("BagModel")

local instance = nil

--构造
--返回值(无)
function BagModel:ctor(data)
	self:init(data)
end

--获取单例
--返回值(单例)
function BagModel:getInstance()
	if instance == nil then
		instance = BagModel.new()
	end
	return instance
end

--初始化
--返回值(无)
function BagModel:init(data)
	--itemData
	self.itemData = ItemData:getInstance()
	--切换的数据
	self.selectList = {}
    -- 类型 0物品 1商城
    self.kind = 0
    -- 类型 1军事 2物资 3加速 4其他
    self.type = 1
    -- 记录购买几个商品
    self.buyNum = 0
end

-- 添加数据
-- list 数组
-- info 数据
function BagModel:addItem(list,info)
	table.insert(list,info)
end

-- 获取切换的数据
function BagModel:getSlectList()
	--
	local arr = {}
	if self.kind == 0 then
		arr = self.itemData.itemList
	else
		arr = self.itemData.shopItemList
	end

	self.selectList = {}
	for k,v in pairs(arr) do
		if v.type == self.type then
			self:addItem(self.selectList,v)
		end
	end
end

-- 根据id获取物品数量
-- id
function BagModel:getShopItemNum(templateId)
	local num = ItemData:getInstance():getItemNumber(templateId)
	return num
end

-- 购买返回的物品和数量
function BagModel:bugItem(data)
	ItemData:getInstance():bugItem(data)
	local itemTemplate = ItemTemplateConfig:getInstance():getItemTemplateByID(data.templateId)
	-- 类型 1军事 2物资 3加速 4其他
	if itemTemplate.it_type == 1 then
		self:bugGainItem(data)
	elseif itemTemplate.it_type == 2 then

	elseif itemTemplate.it_type == 3 then

	elseif itemTemplate.it_type == 4 then
		self:bugGainItem(data)
	end

	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.BAG)
	if uiCommand ~= nil then
		uiCommand:updateList()
	end
end


function BagModel:bugGainItem(data)
	if GainModel:getInstance().buyFrom == 0 then
		return
	end

	local info = PlusItemConfig:getInstance():getInfoByItemTemplateID(data.templateId)
	if info ~= nil then
		local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.GAIN)
		if uiCommand ~= nil then
			uiCommand:autoUseItem(data.templateId)
		end
	end
end

-- 使用返回的物品和数量
function BagModel:useItem(data)

	ItemData:getInstance():useItem(data)
	local itemTemplate = ItemTemplateConfig:getInstance():getItemTemplateByID(data.templateId)
	-- 类型 1军事 2物资 3加速 4其他
	if itemTemplate.it_type == 1 then
		self:useArmyItem(data)
	elseif itemTemplate.it_type == 2 then

	elseif itemTemplate.it_type == 3 then

	elseif itemTemplate.it_type == 4 then
		self:useArmyItem(data)
	end

	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.BAG)
	if uiCommand ~= nil then
		uiCommand:updateList()
	end
end

function BagModel:useArmyItem(data)
	local info = PlusItemConfig:getInstance():getInfoByItemTemplateID(data.templateId)
	if info ~= nil then
		--获取剩余总时间
		local time = PlusItemConfig:getInstance():getTimeByItemTemplateID(data.templateId) * data.number
	    GainData:getInstance():changeOrAddInfo(info.pi_plusid,time,time)

		local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.GAIN)
		if uiCommand ~= nil then
			uiCommand:updataTimeUI()
		end
	end
end

--清理缓存
function BagModel:clearCache()
	self:init()
end


