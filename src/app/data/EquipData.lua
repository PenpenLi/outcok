--
-- Author: oyhc
-- Date: 2015-12-17 22:32:06
--
EquipData = class("EquipData")

local instance = nil

--构造
--返回值(无)
function EquipData:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function EquipData:getInstance()
	if instance == nil then
		instance = EquipData.new()
	end
	return instance
end

--初始化
--返回值(无)
function EquipData:init()
	self.equipList = {}
end

-- 创建物品列表
-- arr
function EquipData:createEquipList(arr,type)
	self.equipList = {}
	for k,v in pairs(arr) do
		local info = self:createEquip(v,1)
		self:addItem(self.equipList,info)
	end
end

-- 创建物品
-- arr
-- type 1为装备列表 2为英雄装备
function EquipData:createEquip(data,type)
	local info = {}
	local equipTemp = EquipConfig:getInstance():getEquipTemplateByID(data.template_id)
	--实例id
	info.objId = {
		id_h = data.equip_id.id_h,
		id_l = data.equip_id.id_l,
	}
	-- 唯一id
	info.id = data.equip_id.id_h .. data.equip_id.id_l
	print("装备模板id：" .. data.template_id)
	-- id 模板id
	info.templateId = data.template_id
	-- 数量
	if type == 1 then
		info.number = data.number
	else
		print("英雄身上装备数量")
		info.number = 1
	end
	-- info.number = data.number
	-- 名字
	info.name = equipTemp.el_name
	-- 等级
	info.level = equipTemp.el_level
	-- 图片
	info.icon = equipTemp.el_icon
	-- 类型
	info.type = equipTemp.el_type
	-- 品质
	info.quality = equipTemp.el_quality
	return info
end

-- 根据装备类型查找装备列表
-- equipType 装备类型
function EquipData:getEquipByType(equipType)
	local arr = {}
	for i=1,#self.equipList do
		local v = self.equipList[i]
		if v.type == equipType then
			self:addItem(arr,v)
		end
	end
	return arr
end

-- 根据唯一id查找装备
-- id 唯一ID
function EquipData:getEquipByID(id)
	for k,v in pairs(self.equipList) do
		if id == v.id then
			return v
		end
	end
	print("找不到唯一id是"..id.."的装备")
end

-- 根据模板id查找装备
-- templateID 模板ID
function EquipData:getEquipByTemplateID(templateID)
	for k,v in pairs(self.equipList) do
		if templateID == v.templateId then
			return v
		end
	end
	print("找不到模板id是"..templateID.."的装备")
end

-- 改变或者删除装备（穿装备）
-- id 唯一ID
-- number 数量
function EquipData:changeOrDelEquip(id,number)
	for k,v in pairs(self.equipList) do
		if id == v.id then
			print("判断装备个数：",number, v.number)
			if number == v.number then
				table.remove(self.equipList,k)
				print("穿装备（删）：",v.name.."长度:"..#self.equipList)
			else
				v.number = v.number - number
			end
			return
		end
	end
	print("改变或者删除装备找不到唯一id是"..id.."的装备")
end

-- 改变或者添加装备（脱装备）
-- id 唯一ID
-- info 装备数据
function EquipData:changeOrAddEquip(id,info)
	for k,v in pairs(self.equipList) do
		if id == v.id then
			v.number = v.number + 1
			return
		end
	end
	self:addItem(self.equipList,info)
	print("脱装备（加）：",info.name.."长度:"..#self.equipList)
end

-- 添加数据
-- list 数组
-- info 数据
function EquipData:addItem(list,info)
	table.insert(list,info)
end
