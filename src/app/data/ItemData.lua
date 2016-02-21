--
-- Author: oyhc
-- Date: 2015-12-04 20:11:43
--
ItemData = class("ItemData")

local instance = nil

--物品类型
ItmeType =
{
	quick = 2, --加速
}

--物品加速类型
ItemSpeedType =
{
	build = 1,  --建造加速,
	train = 2,  --训练加速,
	trap = 3,  --建造陷井加速
	treatment = 4, --治疗加速
	heroTrain = 6, --英雄训练加速
	all = 9, 	   --全加速
}

--构造
--返回值(无)
function ItemData:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function ItemData:getInstance()
	if instance == nil then
		instance = ItemData.new()
	end
	return instance
end

--初始化
--返回值(无)
function ItemData:init()
	self.itemList = {}
	self.shopItemList = {}
	-- 创建商城数据
	self:createShopList()
end

function ItemData:getItemList()
	return self.itemList
end

-- 创建物品列表
function ItemData:createItemList(arr)
	for k,v in pairs(arr) do
		local info = self:createItem(v)
		self:addItem(self.itemList,info)
	end
end

--添加物品通过id
function ItemData:addItmeById(templateId,number,objId)
	local item = self:getItemByID(id)
	if item == nil then
		local info = {}
		local itemTemp = ItemTemplateConfig:getInstance():getItemTemplateByID(templateId)
		--实例id
		info.objId = {
			id_h = objId.id_h,
			id_l = objId.id_l,
		}
		-- id 模板id
		info.templateId = templateId
		-- 数量
		info.number = number
		--创建物品通过配置
		self:createItemByConfig(info,itemTemp)
		--添加物品
		self:addItem(self.itemList,info)
	else
		item.number = number
	end
end

-- 创建物品
function ItemData:createItem(content)
	local info = {}
	local itemTemp = ItemTemplateConfig:getInstance():getItemTemplateByID(content.templateId)
	--实例id
	info.objId = {
		id_h = content.objId.id_h,
		id_l = content.objId.id_l,
	}
	-- id 模板id
	info.templateId = content.templateId
	-- 数量
	info.number = content.number
	--创建物品通过配置
	self:createItemByConfig(info,itemTemp)

	return info
end

function ItemData:createItemByConfig(info,itemTemp)
	-- 名字
	info.name = itemTemp.it_name
	-- 说明
	info.description = itemTemp.it_description
	-- 类型
	info.type = itemTemp.it_type
	-- 头像
	info.icon = itemTemp.it_icon
	-- 装备品质
	info.quality = itemTemp.it_quality
	--加速类型
	info.speedType = itemTemp.it_turbotype
	--加速时间
	info.speedTime = itemTemp.it_turbotime*60  --秒
end

-- 创建商店物品
function ItemData:createShopItem(itemTemp)
	local info = {}
	-- id
	info.templateId = itemTemp.it_id
	-- 名字
	info.name = itemTemp.it_name
	-- 说明
	info.description = itemTemp.it_description
	-- 类型
	info.type = itemTemp.it_type
	-- 头像
	info.icon = itemTemp.it_icon
	-- 装备品质
	info.quality = itemTemp.it_quality
	-- 价格
	info.price = itemTemp.it_price
	--
	local item = self:getItemByID(info.templateId)
	-- 数量
	if item ~= nil then
		info.number = item.number
	else
		info.number = 0
	end
	return info
end

--获取加速物品列表
function ItemData:getQuickItemList()
	local tab = {}
	for k,v in pairs(self.itemList) do
		if v.type == ItmeType.quick then
			table.insert(tab,v)
		end
	end
	return tab
end

-- 购买返回的物品和数量
function ItemData:bugItem(data)
	local info = self:createItem(data)
	for k,v in pairs(self.itemList) do
		if v.templateId == info.templateId then
			self.itemList[k] = info
			return
		end
	end
	self:addItem(self.itemList, info)
end

-- 使用返回的物品和数量
function ItemData:useItem(data)
	for k,v in pairs(self.itemList) do
		if v.templateId == data.templateId then
			if v.number == data.number then
				self.itemList[k] = nil
			else
				v.number = v.number - data.number
			end
			-- 使用物品后增加的物资（粮食 木头等）
			self:addMaterial(data)
			return
		end
	end
	print("使用了没有的物品")
end

--使用物品
function ItemData:useItemById(id,number)
	local item = self:getItemByID(id)
	if item ~= nil then
		item.number = item.number - number
		if item.number <= 0 then
			item.number = 0
		end
		self:addMaterial(item)
	end
end

-- 使用物品后增加的物资（粮食 木头等）
function ItemData:addMaterial(data)
	local itemTemp = ItemTemplateConfig:getInstance():getItemTemplateByID(data.templateId)
	-- 物资类型
	local materialKind = 0
	-- 物资值
	local materialValue = 0
	if itemTemp.it_incresegrain ~= 0 then --粮食
		materialValue = itemTemp.it_incresegrain * data.number
		-- 添加粮食
		PlayerData:getInstance():increaseFood(materialValue)
		-- 提示
		Prop:getInstance():showMsg("成功使用"..data.number.."个"..itemTemp.it_name.."，增加"..materialValue.."粮食")
	elseif itemTemp.it_incresewood ~= 0 then -- 木头
		materialValue = itemTemp.it_incresewood * data.number
		-- 添加木头
		PlayerData:getInstance():increaseWood(materialValue)
		-- 提示
		Prop:getInstance():showMsg("成功使用"..data.number.."个"..itemTemp.it_name.."，增加"..materialValue.."木头")
	elseif itemTemp.it_increseiron ~= 0 then -- 铁矿
		materialValue = itemTemp.it_increseiron * data.number
		-- 添加铁矿
		PlayerData:getInstance():increaseIron(materialValue)
		-- 提示
		Prop:getInstance():showMsg("成功使用"..data.number.."个"..itemTemp.it_name.."，增加"..materialValue.."铁矿")
	elseif itemTemp.it_incresemithril ~= 0 then -- 秘银
		materialValue = itemTemp.it_incresemithril * data.number
		-- 添加秘银
		PlayerData:getInstance():increaseMithril(materialValue)
		-- 提示
		Prop:getInstance():showMsg("成功使用"..data.number.."个"..itemTemp.it_name.."，增加"..materialValue.."秘银")
	elseif itemTemp.it_incresegold ~= 0 then -- 金币
		materialValue = itemTemp.it_incresegold * data.number
	else
		print("什么都没有增加")
	end
	-- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()
	print("添加了：",materialValue)
end

-- 添加数据
-- list 数组
-- info 数据
function ItemData:addItem(list,info)
	table.insert(list,info)
end

-- 根据id获取物品
-- templateId
function ItemData:getItemByID(templateId)
	for k,v in pairs(self.itemList) do
		if v.templateId == templateId then
			return v
		end
	end
end

-- 根据id改变物品数量
-- templateId
-- number
function ItemData:changeItemNumber(templateId,number)
	for k,v in pairs(self.itemList) do
		if v.templateId == templateId then
			v.number = number
			break
		end
	end
end

-- 根据id获取物品数量
-- templateId
function ItemData:getItemNumber(templateId)
	for k,v in pairs(self.itemList) do
		if v.templateId == templateId then
			return v.number
		end
	end
	return 0
end

-- 创建商城数据
function ItemData:createShopList()
	for k,v in pairs(ItemTemplateConfig:getInstance():getItemTemplate()) do
		if v.it_inmall == 1 then
			local info = self:createShopItem(v)
			self:addItem(self.shopItemList,info)
		end
	end
end
