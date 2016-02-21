

--[[
	jinyan.zhang
	邮件数据
--]]

MailsModel = class("MailsModel")

local instance = nil

--邮件类型
MailType ={
	battle = 1,  --战斗报告
	other = 2
}

--邮件子类型
MailSubType ={
	battle = 0,  --战斗
	watch = 1,   --侦查
	beWatch = 2, --被侦查
}

--部队数据类型
ArmsDataType = {
	soldier = 1, --士兵
	trap = 2,  --陷井
	hero = 3, --英雄
}

--侦察资源类型
local WatchResType = {
	food = 1,   --粮食
	wood = 2,   --木材
	iron = 3,   --铁矿
	mithril = 4, --秘银
}

--构造
--返回值(无)
function MailsModel:ctor(data)
	self:init(data)
end

--初始化
--返回值(无)
function MailsModel:init(data)
	self.listData = {}     		--邮件列表数据
	self.detailsList = {}  		--邮件详情列表数据
	self.unReadCount = 0   		--未读邮件数量
end

--收到邮件列表数据
--data 数据
--返回值(无)
function MailsModel:recvMailListData(data)
	self.listData = {}
	local list = data.mails
	for k,v in pairs(list) do
		local info = {}
		local id = {}
		id.id_h = v.mail_id.id_h
		id.id_l = v.mail_id.id_l
		info.id = id
		info.subType = v.mail_type   --邮件子类型
		info.title = v.title  		 --邮件标题 
		info.content = v.brief 		 --邮件内容
		info.sender_name = v.sender_name  --邮件发送者
		info.time = v.send_time 	  --邮件发送时间
		info.opened = v.opened 			  --邮件是否开启过
		info.index = k
		--邮件大类
		if info.subType >= MailSubType.battle and info.subType <= MailSubType.beWatch then
			info.type = MailType.battle 
		else
			info.type = MailType.other
		end
		table.insert(self.listData,info)
	end
	table.sort(self.listData,function(a,b) return a.index > b.index end)

	local mailCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY_BUILD_MAIL)
	if mailCtrl ~= nil then
		mailCtrl:updateMailList()
	end
end

--获取邮件列表数据
--返回值(邮件列表数据)
function MailsModel:getMailListData()
	return self.listData
end

--获取邮件列表(根据类型)
function MailsModel:getListByType(type)
	local arry = {}
	for k,v in pairs(self.listData) do
		if v.type == type then
			table.insert(arry,v)
		end
	end
	return arry
end

--获取未读邮件数量(根据类型)
function MailsModel:getUnReadMailNumByType(type)
	local count = 0
	local list = self:getListByType(type)
	for k,v in pairs(list) do
		if v.opened == 0 then
			count = count + 1
		end
	end
	return count
end

--获取邮件信息(根据邮件id)
function MailsModel:getMailInfoById(id)
	for k,v in pairs(self.listData) do
		if v.id.id_h == id.id_h and v.id.id_l == id.id_l then
			return v
		end
	end
end

--获取最新邮件内容根据类型
function MailsModel:getMostNewMailByType(type)
	local list = self:getListByType(type)
	if list ~= nil and #list > 0 then
		return list[1]
	end
end

--删除邮件通过id
function MailsModel:delMailById(id)
	for k,v in pairs(self.listData) do
		if v.id.id_h == id.id_h and v.id.id_l == id.id_l then
			table.remove(self.listData,k)
			break
		end
	end
	self:delMailDetailsById(id)
end

--删除邮件详情通过id
function MailsModel:delMailDetailsById(id)
	for k,v in pairs(self.detailsList) do
        if v.id.id_l == id.id_l and id.id_h == v.id.id_h then
            table.remove(self.detailsList,k)
            break
        end
    end
end

--设置未读邮件数量
--count 数量
--返回值(无)
function MailsModel:setUnReadMailCount(count)
	self.unReadCount = count

	local cityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCommand ~= nil then
		cityCommand:updateMailNum(count)
	end

	local cityOutCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if cityOutCommand ~= nil then
		cityOutCommand:updateMailNum(count)
	end
end

--获取未读邮件数量
--返回值(未读的邮件数量)
function MailsModel:getUnReadMailCount()
	return self.unReadCount
end

--接收邮件详情信息
--data 邮件详情
--返回值(无)
function MailsModel:recvMailDetailsInfo(data)	
	local info = {} 
	info.id = {}
	info.id.id_h = data.mail_id.id_h  --邮件id
	info.id.id_l = data.mail_id.id_l
	info.title = data.title 		  --邮件标题
	info.type = self:getMailInfoById(info.id).type  --邮件类型
	info.subType = self:getMailInfoById(info.id).subType --邮件子类型
	info.time = self:getMailInfoById(info.id).time       --邮件时间
	local content = json.decode(data.content) --邮件内容
	if info.type == MailType.battle then  --战斗报告类型
		if info.subType == MailSubType.battle then  --战斗类型
			info.reportInfo = self:createBatRepInfo(content)  				--战斗报告信息
			local battleSeq = json.decode(data.fight_report) 				--战斗序列信息
			info.battleMemInfo = self:createBattleInfo(battleSeq) 	   		--战斗成员数据
			info.battleResInfo = self:createBattleResInfo(battleSeq) 		--战斗结果信息
			--战斗数据
			info.battle = self:createBattleData(info.battleMemInfo,battleSeq.battle,info.battleResInfo) 
		elseif info.subType == MailSubType.watch then  --侦察
			info.reportInfo = self:createWatchInfo(content)
		elseif info.subType == MailSubType.beWatch then  --被侦察
			info.reportInfo = self:createBeWatchInfo(content)
		end
	end

	--删除数据
	for k,v in pairs(self.detailsList) do
        if v.id.id_l == info.id.id_l and info.id.id_h == v.id.id_h then
            self.detailsList[k] = nil
            break
        end
    end
    --添加数据
    table.insert(self.detailsList,info)

	local mailCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY_BUILD_MAIL)
	if mailCtrl ~= nil then
		if info.subType == MailSubType.battle then  --战斗类型
			mailCtrl:updateBattleResUI(info)
		elseif info.subType == MailSubType.watch or info.subType == MailSubType.beWatch then --侦察
			mailCtrl:updateWatchUI(info)
		end
	end
end

--创建战斗数据
function MailsModel:createBattleData(memInfo,battleSeq,battleRes)
	local info = {}
	--战斗成员信息
	info.battleMemInfo = memInfo
	--战斗序列信息
	info.battleSeqInfo = battleSeq or {}
	--战斗结果信息
	info.battleResInfo = battleRes

	return info
end

--创建战斗报告信息
function MailsModel:createBatRepInfo(content)
	if content == nil then
		return
	end

	local info = {}
	info.grain = content.grain  --损失粮食
	info.wood = content.wood 	--损失木材
	info.iron = content.iron 	--损失铁矿
	info.mithril = content.mithril --损失秘银
	local arry = content.fightArray --攻守方数据

	local function getDataByType(type)
		for k,v in pairs(arry) do
			local info = {}
			info.type = v.type  --类型  0守方,1攻方
			info.x = v.x        --领主 x坐标
			info.y = v.y 		--领主 y坐标
			info.name = v.name  --领主名字
			info.img = v.img 	--领主头像
			info.kill = v.eliminate --消灭
			info.loss = v.loss 		--损失
			info.hurt = v.injured  --受伤
			info.live = v.live 	   --存活
			info.lsTrap = v.lsTrap  --陷井损失
			info.minusFightForce = v.fightForce --减少战斗力
			if type == info.type then
				return info
			end
		end
	end
	info.atterInfo = getDataByType(1)
	info.deferInfo = getDataByType(0)

	info.armsAttr = {}   --部队属性
	local arms = content.attrArray or {} --部队属性
	for k,v in pairs(arms) do
		local info = {}
		--属性
		info.type = v.type 	
		--值		
		info.value = v.value  
		table.insert(info.arms,info)
	end

	return info
end

--创建侦察信息
function MailsModel:createWatchInfo(content)
	local info = {}
	--领主名字
	info.name = content.name
	--简要信息
	info.brif = Lan:lanText(133, "已侦查到{}的信息", {info.name})
	info.x = content.x 
	info.y = content.y
	--领主等级
	info.lordLv = content.lordLv
	--城堡等级
	info.castleLv = content.castleLv
	--领主头像id
	info.imgId = content.imgId 
	if info.imgId == 0 then
		info.imgId = 1
	end
	--领主信息
	info.lordInfo = {}
	--领主名字
	info.lordInfo.name = info.name
	--领主等级
	info.lordInfo.level = info.lordLv
	--x,y坐标
	info.lordInfo.x = info.x
	info.lordInfo.y = info.y
	--城堡等级
	info.lordInfo.castleLv = info.castleLv
	--领主头像id
	info.lordInfo.imgId = info.imgId

	--资源列表
	local arry = content.res or {}
	for k,v in pairs(arry) do
		local resInfo = {}
		--资源类型
		resInfo.type = v.type
		--仓库内数量
		resInfo.depotNum = v.depotNum
		--城内未收取
		resInfo.inUncoll = v.inUncoll
		if v.type == WatchResType.food then  --粮食
			info.foodInfo = resInfo
		elseif v.type == WatchResType.wood then  --木材
			info.woodInfo = resInfo
		elseif v.type == WatchResType.iron then  --铁矿
			info.ironInfo = resInfo
		elseif v.type == WatchResType.mithril then  --秘银
			info.mithrilInfo = resInfo
		end

		if resInfo.depotNum > 0 or resInfo.inUncoll > 0 then
			info.haveCastRes = true
		end
	end

	local function setResInfo(resInfo)
		if resInfo == nil then
			resInfo = {}
			resInfo.depotNum = 0
			resInfo.inUncoll = 0
		end
		return resInfo
	end
	info.foodInfo = setResInfo(info.foodInfo)
	info.woodInfo = setResInfo(info.woodInfo)
	info.ironInfo = setResInfo(info.ironInfo)
	info.mithrilInfo = setResInfo(info.mithrilInfo)

	--城防值
	info.wallVal = content.wallVal
	--最大城防值
	info.maxWallVal = content.maxWallVal or content.wallVal
	--陷井列表
	info.arryTrap = {}
	local arryTrap = content.traps or {}
	for k,v in pairs(arryTrap) do
		local trapInfo = {}
		--陷井类型
		trapInfo.type = v.type
		--陷井等级
		trapInfo.level = v.level
		--陷井数量
		trapInfo.number = v.num
		--名字
		trapInfo.name = TrapListConfig:getInstance():getConfigByType(trapInfo.type,trapInfo.level).tl_name
		table.insert(info.arryTrap,trapInfo)
	end
	--英雄列表
	local arryHero = content.heros or {}
	info.arrHero = {}
	for k,v in pairs(arryHero) do
		local heroInfo = {}
		--英雄名字
		heroInfo.name = v.name
		--等级
		heroInfo.level = v.level
		--头像
		heroInfo.img = v.img
		--技能
		heroInfo.skill = v.skill
		if heroInfo.skill == 0 then
			heroInfo.skill = 1
		end
		--技能名字
		heroInfo.skillname = SkillConfig:getInstance():getSkillTemplateByID(heroInfo.skill).sl_name
		--战斗力
		heroInfo.fight = v.fight
		table.insert(info.arrHero,heroInfo)
	end
	--士兵列表
	local arrArms = content.arms or {}
	info.arrArms = {}
	for k,v in pairs(arrArms) do
		local armsInfo = {}
		--士兵类型
		armsInfo.type = v.type
		--等级
		armsInfo.level = v.level
		--数量
		armsInfo.number = v.num
		--名字
		armsInfo.name = ArmsAttributeConfig:getInstance():getArmyTemplate(armsInfo.type,armsInfo.level).aa_name
		table.insert(info.arrArms,armsInfo)
	end
	--领主技能列表
	local arrylordSkill = content.lordSkill or {}
	info.arrLordSkill = {}
	for k,v in pairs(arrylordSkill) do
		local lordSkillInfo = {}
		--技能id
		lordSkillInfo.skillId = v.skill
		if lordSkillInfo.skillId == 0 then
			lordSkillInfo.skillId = 1
		end
		local config = LordSkillConfig:getInstance():getConfig(lordSkillInfo.skillId)
		--技能名字
		lordSkillInfo.name = config.ls_name
		--技能图标
		lordSkillInfo.icon = config.ls_icon
		table.insert(info.arrLordSkill,lordSkillInfo)
	end
	--部队属性
	local arrArmsAttr = content.attrArray or {}
	info.arrArmsAttr = {}
	for k,v in pairs(arrArmsAttr) do
		local armsAttrInfo = {}
		--属性类型
		armsAttrInfo.type = v.type
		--属性值
		armsAttrInfo.value = v.value
		armsAttrInfo.name = "攻击加成"
		table.insert(info.arrArmsAttr,armsAttrInfo)
	end

	return info
end

--创建被侦察信息
function MailsModel:createBeWatchInfo(content)
	local info = {}
	info.name = content.name   --名字
	info.img = content.imageId --头像
	if info.img == 0 then
		info.img = 1
	end
	info.content = Lan:lanText(141, "{}侦查了您的城堡", {info.name})

	return info
end

--获取邮件详情(通过邮件id)
--返回值(邮件详情)
function MailsModel:getMailDetailsById(id)
	for k,v in pairs(self.detailsList) do
        if v.id.id_l == id.id_l and id.id_h == v.id.id_h then
            return v
        end
    end
end

--记录上次打开的邮件详情数据
--data 邮件详情数据
--返回值(无)
function MailsModel:setLastOpenMailDetailsData(data)
	self.lastOpenMailDetailsData = data
end

--获取上次打开的邮件详情数据
--返回值(无)
function MailsModel:getLastOpenMailDetailsData()
	return self.lastOpenMailDetailsData
end

--创建战斗结果信息
function MailsModel:createBattleResInfo(content)
	local info = {}
	--获胜阵营
	info.winCamp = content.winCamp
	--攻击方阵营名字
	info.atterCampName = content.atName
	--防守方阵营名字
	info.deferCampName = content.deName

	--我方是否胜利
	if PlayerData:getInstance().name == self.atterCampName then
		info.isAtter = true   --我方是攻击方
		if self.winCamp == CAMP.ATTER then
			info.isWin = true 			   --我方获胜
			info.title = Lan:lanText(76, "攻城胜利")
		else
			info.isWin = false 				--我方失败
			info.title = Lan:lanText(77, "攻城失败")
		end
		info.attContent = Lan:lanText(87, "我攻击了{}的城堡",{info.deferCampName})
	else
		info.isAtter = false   --我方是防守方
		if self.winCamp == CAMP.ATTER then
			info.isWin = false
			info.title = Lan:lanText(78, "守城失败")
		else
			info.isWin = true
			info.title = Lan:lanText(79, "守城成功")
		end
		info.attContent = Lan:lanText(88, "{}攻击了我的城堡",{info.atterCampName})
	end

	return info
end

-- 创建战斗详细数据
function MailsModel:createBattleInfo(content)
	print("邮件战斗json:",content)
	local data = {}
	--攻击阵营数据
	data.atterArms = {}
	data.atterHeros = {}
	if content.at_arms ~= nil then
		for k,v in pairs(content.at_arms) do
			local info = self:createInfo(v)
			table.insert(data.atterArms, info)
		end
	end
	if content.at_heros ~= nil then
		for k,v in pairs(content.at_heros) do
			local info = self:createHeroInfo(v)
			table.insert(data.atterHeros, info)
		end
	end
	--攻击方部队个数
	data.atterArmsCount = #data.atterArms + #data.atterHeros

	--防守阵营数据
	data.deferArms = {}
	data.deferHeros = {}
	data.deferTraps = {}
	data.deferTowers = {}
	if content.de_arms ~= nil then
		for k1,v1 in pairs(content.de_arms) do
			local info = self:createInfo(v1)
			table.insert(data.deferArms, info)
		end
	end
	if content.de_heros ~= nil then
		for k,v in pairs(content.de_heros) do
			local info = self:createHeroInfo(v)
			table.insert(data.deferHeros, info)
		end
	end
	if content.de_traps ~= nil then
		for k,v in pairs(content.de_traps) do
			local info = self:createTrapInfo(v)
			table.insert(data.deferTraps, info)
		end
	end
	if content.de_towers ~= nil then
		for k,v in pairs(content.de_towers) do
			local info = self:createTowerInfo(v)
			table.insert(data.deferTowers, info)
		end
	end
	--防守方部队个数
	data.deferArmsCount = #data.deferArms + #data.deferHeros + #data.deferTraps + #data.deferTowers

	return data
end

--创建防御塔信息
function MailsModel:createTowerInfo(content)
	local info = {}
	--类型
	info.type = content.type
	--等级
	info.level = content.level
	--位置
	info.pos = content.pos
	--击杀数量
	info.kill = content.kill
	--存活数量
	info.live = "--"
	--损失数量
	info.lose = "--"
	--受伤数量
	info.hurt = "--"
	--数据类型
	info.dataType = ArmsDataType.tower
	--头像
	info.img = "#" .. BuildingUpLvConfig:getInstance():getBuildingResPath2(info.type,info.level)
	--头像放大倍数
	info.imgScale = 0.35

	return info
end

--创建陷井信息
function MailsModel:createTrapInfo(content)
	local info = {}
	--类型
	info.type = content.type
	--数量
	info.number = content.num
	--等级
	info.level = content.level
	--击杀数量
	info.kill = content.kill
	--损失数量
	info.lose = content.loss
	--存活数量
	info.live = content.num - info.lose
	--受伤数量
	info.hurt = "--"
	--数据类型
	info.dataType = ArmsDataType.trap
	--头像
	local config = TrapListConfig:getInstance():getConfigByType(info.type,info.level)
	if config ~= nil then
		info.img = "#" .. config.tl_icon .. ".png"
	end
	--头像放大倍数
	info.imgScale = 1

	return info
end

--创建英雄信息
function MailsModel:createHeroInfo(content)
	local info = {}
	-- 英雄位置
	info.pos = content.pos
	--头像
	info.img = 	HeroFaceConfig:getInstance():getHeroFaceByID(content.img)
	--名字
	info.name = content.name
	--品质
	info.quality = content.quality
	--击杀数量
	info.kill = content.kill
	--最大血量
	info.maxHp = content.maxHp
	--剩余血量
	info.hp = content.hp
	--数据类型
	info.dataType = ArmsDataType.hero
	--头像放大倍数
	info.imgScale = 1

	return info
end

--创建士兵信息
function MailsModel:createInfo(content)
	local info = {}
	--类型
	info.type = content.type
	-- 兵数量
	info.number = content.num
	-- 士兵名字
	info.soldierName = ArmsData:getInstance():getSoldierName(info.type)
	--击杀数量
	info.kill = content.kill
	--损失数量
	info.lose = content.loss
	--存活数量
	info.live = content.live
	--受伤数量
	info.hurt = content.injured
	--数据类型
	info.dataType = ArmsDataType.soldier
	--士兵头像
	local config = ArmsAttributeConfig:getInstance():getArmyTemplatebySubType(info.type)
	if config ~= nil then
		info.img = "#" .. config.aa_icon .. ".png"
	end
	--头像放大倍数
	info.imgScale = 1

	return info
end

--收到删除邮件结果
function MailsModel:recvDelMailRes(data)
	--邮件id列表
	local mailids = data.mail_id
	for k,v in pairs(mailids) do
		self:delMailById(v)
	end
	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY_BUILD_MAIL)
	if command ~= nil then
		command:updateReportListUI()
	end
end

--获取单例
--返回值(单例)
function MailsModel:getInstance()
	if instance == nil then
		instance = MailsModel.new()
	end
	return instance
end

--清理缓存数据
--返回值(无)
function MailsModel:clearCache()
	self:init()
end
