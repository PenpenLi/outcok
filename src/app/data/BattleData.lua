
--[[
	jinyan.zhang
	战斗数据
--]]

BattleData = class("BattleData")
local instance = nil

--战斗序列类型
BattleSeqType ={
	common = 1,  --普通攻击
	trap = 3,   --陷井
	hero = 2,  --英雄技能
	tower = 4,  --防御塔
}

--构造
function BattleData:ctor()
	self:init()
end

--初始化数据
function BattleData:init()
	self.soldierConfigInfos = {}
	for i=OCCUPATION.cavalry,OCCUPATION.arrowTower do
		self.soldierConfigInfos[i] = {}
	end

	self.bubinInfo = {}
	self.bubinInfo.maxColCount = 5
	self.bubinInfo.maxRowCount = 5
	self.bubinInfo.countToModeValue = 200
	self.soldierConfigInfos[OCCUPATION.footsoldier] = self.bubinInfo

	self.qibinInfo = {}
	self.qibinInfo.maxColCount = 5
	self.qibinInfo.maxRowCount = 4
	self.qibinInfo.countToModeValue = 200
	self.soldierConfigInfos[OCCUPATION.cavalry] = self.qibinInfo

	self.gonbinInfo = {}
	self.gonbinInfo.maxColCount = 5
	self.gonbinInfo.maxRowCount = 5
	self.gonbinInfo.countToModeValue = 200
	self.soldierConfigInfos[OCCUPATION.archer] = self.gonbinInfo

	self.fashiInfo = {}
	self.fashiInfo.maxColCount = 5
	self.fashiInfo.maxRowCount = 5
	self.fashiInfo.countToModeValue = 200
	self.soldierConfigInfos[OCCUPATION.master] = self.fashiInfo

	self.zhangchebinInfo = {}
	self.zhangchebinInfo.maxColCount = 5
	self.zhangchebinInfo.maxRowCount = 3
	self.zhangchebinInfo.countToModeValue = 400
	self.soldierConfigInfos[OCCUPATION.tank] = self.zhangchebinInfo

	-- self.bubinInfo.countToModeValue = 1
	-- self.qibinInfo.countToModeValue = 1
	-- self.gonbinInfo.countToModeValue = 1
	-- self.fashiInfo.countToModeValue = 1
	-- self.zhangchebinInfo.countToModeValue = 1

end

--获取单例
--返回值(单例)
function BattleData:getInstance()
	if instance == nil then
		instance = BattleData.new()
	end
	return instance
end

--获取士兵站位信息
--soldierInfo 士兵信息
--count 士兵数
--返回值(站位信息)
function BattleData:getSoldierPosInfo(soldierInfo,count,campInfo)
	soldierInfo.count = count
	if soldierInfo.count == nil or soldierInfo.count <= 0 then
		return
	end

	local posInfo = {}
	local bin1Count = 0
	local bin2Count = 0
	if campInfo.bin1 > 0 then
		bin1Count = campInfo.bin1/soldierInfo.countToModeValue
		bin1Count = math.ceil(bin1Count)
		if bin1Count < 1 then
			bin1Count = 1
		end
	end
	if campInfo.bin2 > 0 then
		bin2Count = campInfo.bin2/soldierInfo.countToModeValue
		bin2Count = math.ceil(bin2Count)
		if bin2Count < 1 then
			bin2Count = 1
		end
	end
	local modeCount = bin1Count + bin2Count

	local col = math.mod(modeCount,soldierInfo.maxColCount)
	if col == 0 then
		col = soldierInfo.maxColCount
	end
	local modeCount = modeCount/soldierInfo.maxColCount
	local row,yu = math.modf(modeCount)
	if yu ~= 0 then
		row = row + 1
	end
	if row > soldierInfo.maxRowCount then
		row = soldierInfo.maxRowCount
	end
	posInfo.row = row
	posInfo.col = col
	posInfo.maxColCount = soldierInfo.maxColCount
	return posInfo
end

--获取士兵配置信息
--soldierType 士兵类型
--返回值(士兵配置信息)
function BattleData:getSoldierConfigInfo(soldierType)
	local job = Common:soldierTypeToOccupation(soldierType)
	if job == OCCUPATION.cavalry then
		return self.qibinInfo
	elseif job == OCCUPATION.footsoldier then
		return self.bubinInfo
	elseif job == OCCUPATION.archer then
		return self.gonbinInfo
	elseif job == OCCUPATION.master then
		return self.fashiInfo
	elseif job == OCCUPATION.tank then
		return self.zhangchebinInfo
	end
end

--获取士兵站位信息
--job 职业
--camp 阵营
--返回值(士兵站位信息)
function BattleData:getSoldierPosInfoByType(job,camp)
	local soldierConfigInfo = self.soldierConfigInfos[job]
	if camp == CAMP.ATTER then
		local count = self.atterCountInfo[job].count
		return self:getSoldierPosInfo(soldierConfigInfo,count,self.atterCountInfo[job])
	else
		local count = self.deferCountInfo[job].count
		return self:getSoldierPosInfo(soldierConfigInfo,count,self.deferCountInfo[job])
	end
end

--设置士兵总数
--返回值(无)
function BattleData:setSolderTotal()
	local atterPower = 0
	for k,v in pairs(self.atterCountInfo) do
		atterPower = atterPower + v.count
	end

	local deferPower = 0
	for k,v in pairs(self.deferCountInfo) do
		deferPower = deferPower + v.count
	end

	self.atterPower = atterPower + self.atterHeroCount
	self.deferPower = deferPower + self.deferheroCount
	
	self.curbattleReport = clone(self.battleReport)

	self.atterCountInfo = clone(self.oldAtterCountInfo)
	self.deferCountInfo = clone(self.oldDeferCountInfo)
end

--获取士兵总数 
--camp 阵营
--返回值(士兵总数)
function BattleData:getSoldierTotal(camp)
	if camp == CAMP.ATTER then
		return self.atterPower
	elseif camp == CAMP.DEFER then
		return self.deferPower
	end
end

--减少兵力
--camp 阵营
--hurtNum 受损兵力
--返回值(无)
function BattleData:hurtSoldierNum(camp,hurtNum)
	if hurtNum <= 0 then
		return
	end
	if camp == CAMP.ATTER then
		self.atterPower = self.atterPower - hurtNum
	elseif camp == CAMP.DEFER then
		self.deferPower = self.deferPower - hurtNum
	end
end

--获取战报
--index 第几回合
--返回值(战报)
function BattleData:getBattleReportData(index)
	return self.curbattleReport[index]
end

--获取阵营名字
--camp 阵营
--返回值(无)
function BattleData:getPvPCampName(camp)
	if camp == CAMP.ATTER then
		return self.atterCampName
	elseif camp == CAMP.DEFER then
		return self.deferCampName
	end
end

--data 数据
--isMonster(true:是怪物,false:不是怪物)
--返回值(士兵个数)
function BattleData:getSoldierCount(data,isMonster)
	if data == nil then
		return 0
	end

	local num = 0
	for i=1,#data do
		if isMonster then
			num = num + data[i].number
		else
			num = num + data[i].number
		end
	end

	return num
end

--获取排序后的士兵列表
--soldierlist1 某种类型的士兵列表
--soldierlist2 某种类型的士兵列表
--isMonster(true:是怪物,false:不是怪物)
--返回值(士兵列表,个数)
function BattleData:getSortSomeSoldierList(soldierlist1,soldierlist2,isMonster)
	local list1Count = self:getSoldierCount(soldierlist1,isMonster)
	local list2Count = self:getSoldierCount(soldierlist2,isMonster)
	local count = list1Count + list2Count
	local soldierList = {}
	if list1Count > list2Count then
		for i=1,list2Count do
			table.insert(soldierlist1,soldierlist2[i])
		end
		return soldierlist1,count
	else
		for i=1,list1Count do
			table.insert(soldierlist2,soldierlist1[i])
		end
		return soldierlist2,count
	end
end

--获取士兵列表
--soldierlist 士兵列表
--soldierType 士兵类型
--返回值(某种类型的士兵列表)
function BattleData:getSoldierList(soldierlist,soldierType)
	local someSoldiers = {}
	if soldierlist == nil then
		return someSoldiers
	end

	for k,v in pairs(soldierlist) do
		local soldierConfigInfo = ArmsAttributeConfig:getInstance():getArmyTemplatebySubType(v.type)
		if soldierConfigInfo ~= nil then
			local type = soldierConfigInfo.aa_subtype
			if type == soldierType then
				v.soldierType = soldierType
				table.insert(someSoldiers,v)
			end
		end
	end

	-- for k,v in pairs(soldierlist) do
	-- 	local soldierConfigInfo = ArmsAttributeConfig:getInstance():getArmyTemplate(v.type,v.level)
	-- 	if soldierConfigInfo ~= nil then
	-- 		local type = soldierConfigInfo.aa_subtype
	-- 		if type == soldierType then
	-- 			v.soldierType = soldierType
	-- 			table.insert(someSoldiers,v)
	-- 		end
	-- 	end
	-- end
	return someSoldiers
end

--获取士兵类型
--camp 阵营
--job 职业
--index 第几个
--返回值(士兵类型)
function BattleData:getSoldierTypeByJobAndIndex(camp,job,index)
	local info = nil
	if camp == CAMP.ATTER then
		info = self.atterCountInfo[job]
	else
		info = self.deferCountInfo[job]
	end
	if info ~= nil and info.info ~= nil then
		local data = info.info
		for i=1,#data do
			local count = data[i].number
			if index <= count then
				return data[i].soldierType
			end
		end
	end
end

--对士兵列表进行排序
--soldierlist 士兵列表
--soldierCampList 士兵阵营列表
--soldierInfoList 士兵类型表信息
--isMonster(true:是怪物,false:不是怪物)
--返回值(无)
function BattleData:sortSoldierList(soldierlist,soldierCampList,soldierInfoList,isMonster)
	local dunBinList = self:getSoldierList(soldierlist,SOLDIER_TYPE.shieldSoldier)
	local qianbinList = self:getSoldierList(soldierlist,SOLDIER_TYPE.marines)
	soldierInfoList[SOLDIER_TYPE.shieldSoldier].count = self:getSoldierCount(dunBinList,isMonster)
	soldierInfoList[SOLDIER_TYPE.marines].count = self:getSoldierCount(qianbinList,isMonster)
	local bubinList,count = self:getSortSomeSoldierList(dunBinList,qianbinList,isMonster)
	soldierCampList[OCCUPATION.footsoldier].count = count
	soldierCampList[OCCUPATION.footsoldier].info = bubinList
	soldierCampList[OCCUPATION.footsoldier].bin1 = soldierInfoList[SOLDIER_TYPE.shieldSoldier].count
	soldierCampList[OCCUPATION.footsoldier].bin2 = soldierInfoList[SOLDIER_TYPE.marines].count 

	local qishiList = self:getSoldierList(soldierlist,SOLDIER_TYPE.knight)
	local gonqibinList = self:getSoldierList(soldierlist,SOLDIER_TYPE.bowCavalry)
	soldierInfoList[SOLDIER_TYPE.knight].count = self:getSoldierCount(qishiList,isMonster)
	soldierInfoList[SOLDIER_TYPE.bowCavalry].count = self:getSoldierCount(gonqibinList,isMonster)
	local qibinList,count = self:getSortSomeSoldierList(qishiList,gonqibinList,isMonster)
	soldierCampList[OCCUPATION.cavalry].count = count
	soldierCampList[OCCUPATION.cavalry].info = qibinList
	soldierCampList[OCCUPATION.cavalry].bin1 = soldierInfoList[SOLDIER_TYPE.knight].count
	soldierCampList[OCCUPATION.cavalry].bin2 = soldierInfoList[SOLDIER_TYPE.bowCavalry].count

	local gonbinList = self:getSoldierList(soldierlist,SOLDIER_TYPE.archer)
	local lubinList = self:getSoldierList(soldierlist,SOLDIER_TYPE.crossbowmen)
	soldierInfoList[SOLDIER_TYPE.archer].count = self:getSoldierCount(gonbinList,isMonster)
	soldierInfoList[SOLDIER_TYPE.crossbowmen].count = self:getSoldierCount(lubinList,isMonster)
	local gonbingList,count = self:getSortSomeSoldierList(gonbinList,lubinList,isMonster)
	soldierCampList[OCCUPATION.archer].count = count
	soldierCampList[OCCUPATION.archer].info = gonbingList
	soldierCampList[OCCUPATION.archer].bin1 = soldierInfoList[SOLDIER_TYPE.archer].count
	soldierCampList[OCCUPATION.archer].bin2 = soldierInfoList[SOLDIER_TYPE.crossbowmen].count
	
	local choncheList = self:getSoldierList(soldierlist,SOLDIER_TYPE.tank)
	local toushiList = self:getSoldierList(soldierlist,SOLDIER_TYPE.catapult)
	soldierInfoList[SOLDIER_TYPE.tank].count = self:getSoldierCount(choncheList,isMonster)
	soldierInfoList[SOLDIER_TYPE.catapult].count = self:getSoldierCount(toushiList,isMonster)
	local zhanchebinList,count = self:getSortSomeSoldierList(choncheList,toushiList,isMonster)
	soldierCampList[OCCUPATION.tank].count = count
	soldierCampList[OCCUPATION.tank].info = zhanchebinList
	soldierCampList[OCCUPATION.tank].bin1 = soldierInfoList[SOLDIER_TYPE.tank].count 
	soldierCampList[OCCUPATION.tank].bin2 = soldierInfoList[SOLDIER_TYPE.catapult].count

	local fashiList = self:getSoldierList(soldierlist,SOLDIER_TYPE.master)
	local shushiList = self:getSoldierList(soldierlist,SOLDIER_TYPE.warlock)
	soldierInfoList[SOLDIER_TYPE.master].count = self:getSoldierCount(fashiList,isMonster)
	soldierInfoList[SOLDIER_TYPE.warlock].count = self:getSoldierCount(shushiList,isMonster)
	local fashibinList,count = self:getSortSomeSoldierList(fashiList,shushiList,isMonster)
	soldierCampList[OCCUPATION.master].count = count
	soldierCampList[OCCUPATION.master].info = fashibinList
	soldierCampList[OCCUPATION.master].bin1 = soldierInfoList[SOLDIER_TYPE.master].count
	soldierCampList[OCCUPATION.master].bin2 = soldierInfoList[SOLDIER_TYPE.warlock].count
end

--获取英雄数据位置
function BattleData:getHeroInfoByPos(heroList,pos)
	for k,v in pairs(heroList) do
		if v.pos == pos then
			return v
		end
	end
end

--获取防御塔列表
function BattleData:getDefTowerList()
	return self.defTowers
end

function BattleData:getTrapCount()
	if self.traps == nil then
		return 0
	end
	return #self.traps
end

function BattleData:getHeroDataById(heroList,id)
	-- for k,v in pairs(heroList) do
	-- 	if v.heroid.id_h == id.id_h and v.heroid.id_l == id.id_l then
	-- 		return v
	-- 	end
	-- end

	for k,v in pairs(heroList) do
		if v.pos == id then
			return v
		end
	end
end

--攻击数据
function BattleData:atterData(atType,i,heroInfo,attId)
	--攻击
	if atType == BattleSeqType.hero then --技能攻击
		local skillId = self.battleReport[i].skillId
		if skillId == 0 then
			return
		end

		local skillConfig = SkillConfig:getInstance():getSkillTemplateByID(skillId)
		if skillConfig.sl_id <= 2 then
			self.battleReport[i].skillType = SkillsType.HERO_ROCKET
			self.battleReport[i].config = HeroRocketTab
		else
			self.battleReport[i].skillType = SkillsType.BUFF
			self.battleReport[i].config = {}
		end

		if heroInfo ~= nil then
			self.battleReport[i].img = heroInfo.img  --英雄头像
			self.battleReport[i].quality = heroInfo.quality  --英雄品质
			print("英雄头像id=",self.battleReport[i].img)
		end
		print("放英雄技能,技能id=",self.battleReport[i].skillId)
	elseif atType == BattleSeqType.trap then --陷井
		print("放陷井,陷井类型id=",attId)
		if attId == OCCUPATION.fallingRocks then  --落石
			self.battleReport[i].config = FallingRocksTab
			self.battleReport[i].skillType = SkillsType.FALLROCEK
		elseif attId == OCCUPATION.rocket then  --火箭
			self.battleReport[i].config = RocketTab
			self.battleReport[i].skillType = SkillsType.ROCKET
		elseif attId == OCCUPATION.bowling then  --滚木
			self.battleReport[i].config = BowlingTab
			self.battleReport[i].skillType = SkillsType.BOWLING
		end
	else
		if atType == BattleSeqType.common then
			print("普通士兵发动攻击")
		elseif atType == BattleSeqType.tower then
			print("箭塔发动攻击")
		end
	end
end

--受击数据
function BattleData:hurtData(loseArry,i)
	self.battleReport[i].deferData = {}
	for k,v in pairs(loseArry) do
		--受损者ID 士兵subtype,英雄pos
		local lsId = v.lsId
		--受损者类型 1:士兵 2:英雄
		local lsType = v.lsType
		--受损值 士兵为数量，英雄为血量
		local lsNum = v.lsNum	
		if lsType == BattleSeqType.hero then  --受损类型是英雄时
			local info = {}
			info.leftHp = lsNum        	 --剩余血量
			info.loseType = lsType     	 --损失类型
			table.insert(self.battleReport[i].deferData,info)
			print("英雄被打,剩余血量为",info.leftHp)
		elseif lsType == BattleSeqType.common then --受损类型是士兵
			local info = {}
			info.loseSoldierType = lsId 	--受损士兵类型
			info.loseNum = lsNum       		--受损数量
			info.loseType = lsType     		--损失类型
			table.insert(self.battleReport[i].deferData,info)
			print("士兵被打,损失兵力为",info.loseNum)
		else
			print("其它数据类型被打,类型为",lsType)
		end
	end
end

--设置战斗数据
--返回值(无)
function BattleData:setPVPBattleData(data)
	self.atterCountInfo = {}
	for i=1,OCCUPATION.arrowTower do
		self.atterCountInfo[i] = {}
		self.atterCountInfo[i].info = {}
		self.atterCountInfo[i].count = 0
		self.atterCountInfo[i].bin1 = 0
		self.atterCountInfo[i].bin2 = 0
	end
	
	self.deferCountInfo = {}
	for i=1,OCCUPATION.arrowTower do
		self.deferCountInfo[i] = {}
		self.deferCountInfo[i].info = {}
		self.deferCountInfo[i].count = 0
		self.deferCountInfo[i].bin1 = 0
		self.deferCountInfo[i].bin2 = 0
	end

	self.atterSoldierInfo = {}
	for i=1,10 do
		self.atterSoldierInfo[i] = {}
		self.atterSoldierInfo[i].info = {}
		self.atterSoldierInfo[i].count = 0
	end

	self.defSoldierInfo = {}
	for i=1,10 do
		self.defSoldierInfo[i] = {}
		self.defSoldierInfo[i].info = {}
		self.defSoldierInfo[i].count = 0
	end

	local atterArms = data.battleMemInfo.atterArms 	--攻击方士兵列表
	local deferArms = data.battleMemInfo.deferArms    --防守方士兵列表
	local atterHeros = data.battleMemInfo.atterHeros  --攻击方英雄列表
	local deferHeros = data.battleMemInfo.deferHeros  --防守方英雄列表
	self.atterHeroCount = #atterHeros   --攻击方英雄数量
	self.deferheroCount = #deferHeros   --防守方英雄数量
	self.defTowers = data.battleMemInfo.deferTowers    --防御塔
	self.traps = data.battleMemInfo.deferTraps 		--陷井
	print("攻击方数据")
	print("英雄个数=",#atterHeros,"士兵个数=",#atterArms)
	print("防守方数据")
	print("防守方陷井个数=",#self.traps,"防御塔个数=",#self.defTowers,"英雄个数=",#deferHeros,"士兵个数=",#deferArms)

	self:sortSoldierList(atterArms,self.atterCountInfo,self.atterSoldierInfo)
	self:sortSoldierList(deferArms,self.deferCountInfo,self.defSoldierInfo)

	self.oldAtterCountInfo = clone(self.atterCountInfo)
	self.oldDeferCountInfo = clone(self.deferCountInfo)

	self:setSolderTotal()

	self.atterCampName = data.battleResInfo.atterCampName
	self.deferCampName = data.battleResInfo.deferCampName
	self.isWin = data.battleResInfo.isWin
	self.winCamp = data.battleResInfo.winCamp

	self.battleReport = {}
	if data.battle == nil then
		data.battle = {}
	end

	print("开始战斗序列........回合数=",#data.battleSeqInfo)
	for i=1,#data.battleSeqInfo do
		local v = data.battleSeqInfo[i]
		local attId = v.armsId   			--攻击id
		local skillId = v.skillId 			--技能id
		local atType = v.atType   			--攻击类型
		local loseArry = v.lsArray or {} 	--受损数据
		local heroList = {} 				--英雄列表
		self.battleReport[i] = {}
		self.battleReport[i].attType = atType
		self.battleReport[i].skillId = skillId

		print("第",i,"回合")

		--1:攻击 0:防守
		if v.atStatus == 0 then
			print("防守方 打 攻击方")
			-- 受击阵营
			self.battleReport[i].derCamp = CAMP.ATTER
			heroList = deferHeros
		else
			print("攻击方 打 防守方")
			-- 受击阵营
			self.battleReport[i].derCamp = CAMP.DEFER 
			heroList = atterHeros
		end

		--英雄数据
		local heroInfo = self:getHeroInfoByPos(heroList,attId)
		--攻击数据 
		self:atterData(atType,i,heroInfo,attId)
		--受击数据
		self:hurtData(loseArry,i)
	end

	self.curbattleReport = clone(self.battleReport)
end

--设置副本战斗序列
--arms        我方士兵
--heros       我方英雄
--marchArms   我方部队数据
--monsterData 怪物数据
--battleSeq   战斗序列
--copyIndex   副本关卡下标
--isWinBattle 是否胜利
function BattleData:setCopyBattleData(arms,heros,monsterData,battleSeq,copyIndex,isWin)
	self.atterCountInfo = {}
	for i=1,OCCUPATION.arrowTower do
		self.atterCountInfo[i] = {}
		self.atterCountInfo[i].info = {}
		self.atterCountInfo[i].count = 0
		self.atterCountInfo[i].bin1 = 0
		self.atterCountInfo[i].bin2 = 0
	end
	
	self.deferCountInfo = {}
	for i=1,OCCUPATION.arrowTower do
		self.deferCountInfo[i] = {}
		self.deferCountInfo[i].info = {}
		self.deferCountInfo[i].count = 0
		self.deferCountInfo[i].bin1 = 0
		self.deferCountInfo[i].bin2 = 0
	end

	self.atterSoldierInfo = {}
	for i=1,10 do
		self.atterSoldierInfo[i] = {}
		self.atterSoldierInfo[i].info = {}
		self.atterSoldierInfo[i].count = 0
	end

	self.defSoldierInfo = {}
	for i=1,10 do
		self.defSoldierInfo[i] = {}
		self.defSoldierInfo[i].info = {}
		self.defSoldierInfo[i].count = 0
	end

	local atterArms = arms 							  --攻击方士兵列表
	local deferArms = monsterData    				  --防守方怪物
	local atterHeros = heros  						  --攻击方英雄列表
	self.atterHeroCount = #atterHeros   			  --攻击方英雄数量
	self.deferheroCount = 0   						  --防守方英雄数量
	print("攻击方数据")
	print("英雄个数=",#atterHeros,"士兵个数=",#atterArms)
	print("怪物数据")
	print("士兵个数=",#deferArms)

	self:sortSoldierList(atterArms,self.atterCountInfo,self.atterSoldierInfo)
	self:sortSoldierList(deferArms,self.deferCountInfo,self.defSoldierInfo,true)

	self.oldAtterCountInfo = clone(self.atterCountInfo)
	self.oldDeferCountInfo = clone(self.deferCountInfo)

	--计算总兵力
	self:setSolderTotal()

	self.atterCampName = PlayerData:getInstance().name
	self.deferCampName = CommonStr.COPY_MONSTER

	--是否赢得胜利
	if isWin == 1 then
		self.isWin = true
		CopyModel:getInstance():updatePassCount(copyIndex)
	else
		self.isWin = false
	end

	self.battleReport = {}
	if battleSeq == nil then
		battleSeq = {}
	end

	print("开始战斗序列........回合数=",#battleSeq)
	for i=1,#battleSeq do
		local info = battleSeq[i]
		--攻击方状态 0:防守 1:攻击
		local atStatus = info.atStatus
		--技能id
		local skillId = info.skillId
		--攻击类型 1:士兵 2:英雄
		local atType = info.atType
		--攻击者ID 士兵为subtype,英雄为pos
		local attId = info.atId
		--受损兵力值
		local loseArry = info.lossArms or {}
		--英雄列表
		local heroList = {}

		self.battleReport[i] = {}
		self.battleReport[i].attType = atType
		self.battleReport[i].skillId = skillId
		print("第",i,"回合")

		--1:攻击 0:防守
		if atStatus == 0 then
			print("怪物 打 攻击方")
			-- 受击阵营
			self.battleReport[i].derCamp = CAMP.ATTER
			--英雄列表
			heroList = {}
		else
			-- 受击阵营
			self.battleReport[i].derCamp = CAMP.DEFER 	
			--英雄列表
			heroList = atterHeros
			print("攻击方 打 怪物")
		end

		--英雄数据
		local heroInfo = self:getHeroDataById(heroList,attId)
		--攻击数据 
		self:atterData(atType,i,heroInfo,attId)
		--受击数据
		self:hurtData(loseArry,i)
	end

	self.curbattleReport = clone(self.battleReport)
end

--进入战斗
--data 数据
--返回值(无)
function BattleData:goToBattle(data)
	self:setPVPBattleData(data)
	SceneMgr:getInstance():goToBattle()
end

--获取获胜阵营
--返回值(阵营)
function BattleData:getWinCamp()
	return self.winCamp
end

--是否战斗胜利
--返回值(true:是,false:否)
function BattleData:isWinBattle()
	return self.isWin
end

--减少士兵数
--camp 阵营
--soldierType 士兵类型
--minus 减少兵力 
--返回值(剩余兵力)
function BattleData:minusSoldierNumByType(camp,soldierType,minus)
	local soldierList = {}
	if camp == CAMP.ATTER then
		soldierList = self.atterSoldierInfo
	else
		soldierList = self.defSoldierInfo
	end
	for k,v in pairs(soldierList) do
		if k == soldierType then
			v.count = v.count - minus
			if v.count < 0 then
				v.count = 0
			end
			return v.count
		end
	end
	return -1
end

--清理缓存数据
--返回值(无)
function BattleData:clearCachData()
	self.battleReport = {}
end





