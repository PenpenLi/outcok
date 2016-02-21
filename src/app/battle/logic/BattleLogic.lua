
--[[
	jinyan.zhang
	战斗逻辑
--]]

BattleLogic = class("BattleLogic",function()
    return display.newLayer()
end)

local instance = nil

local scheduler = require("framework.scheduler")

--播放状态
local PlaylState = {
	none = 0,    --没有在播放
	playing = 1, --播放中
	finish = 2,  --完成播放
}

--构造
--返回值(无)
function BattleLogic:ctor()
	self:setNodeEventEnabled(true)
	self:setAnchorPoint(0,0)
	self:setPosition(0, 0)

	--触摸层
	self.touchLayer = TouchLayer.new("battle/battleBg.jpg")
	self:addChild(self.touchLayer)
	local bgMap = self.touchLayer:getBgMap()
	self.bgMap = bgMap
	self.bgMap:setPositionY(-500)

	--士兵层
	self.soldierLayer = display.newLayer()
	self.soldierLayer:setAnchorPoint(0,0)
	self.soldierLayer:setPosition(0, 0)
	bgMap:addChild(self.soldierLayer,1)

	--特效层
	self.effectLayer = display.newLayer()
	self.effectLayer:setAnchorPoint(0,0)
	self.effectLayer:setPosition(0, 0)
	bgMap:addChild(self.effectLayer,1)

	local size = bgMap:getContentSize()
	size.height = 2
    local beRectLayer = display.newCutomColorLayer(cc.c4b(255,0,0,150),size.width,size.height)
    beRectLayer:setContentSize(size)
    bgMap:addChild(beRectLayer,100,201)
    beRectLayer:setPosition(0,bgMap:getContentSize().height/2-50)

	self:init()
end

--初始化
--返回值(无)
function BattleLogic:init()
	self.index = 1
	self.playState = PlaylState.none
	self:createStancePos()
	self:initMemInfo()
	self:createArrowTower()
end

--设置战斗类型
--battleType 战斗类型
--返回值(无)
function BattleLogic:setBattleType(battleType)
	self.battleType = battleType
end

--加入到舞台后会调用这个接口
--返回值(无)
function BattleLogic:onEnter()
	local sequence = transition.sequence({
		cc.DelayTime:create(1),
    	cc.CallFunc:create(function()
    		self:openTime()
    	end),
	})
	self:runAction(sequence)
end 

--离开舞台后会调用这个接口
--返回值(无)
function BattleLogic:onExit()
	self:stopTime()
	Shake:endShake()
	instance = nil
end

--从内存释放后会调用这个接口
--返回值(无)
function BattleLogic:onDestroy()
end 

--获取单例
--返回值(单例)
function BattleLogic:getInstance()
	if instance == nil then
		instance = BattleLogic.new()
	end
	return instance
end

--创建站位
function BattleLogic:createStancePos()
	local high = self.bgMap:getContentSize().height
	local wide = self.bgMap:getContentSize().width
	self.attStance = {}  --攻击方站位
	local y = high/2-400
	--步兵
	self.attStance[OCCUPATION.footsoldier] = cc.p(340,y)
	--骑兵
	self.attStance[OCCUPATION.cavalry] = cc.p(540,y-200)
	--法师
	self.attStance[OCCUPATION.master] = cc.p(100,y-400)
	--弓兵
	self.attStance[OCCUPATION.archer] = cc.p(540,y-400)
	--战车兵
	self.attStance[OCCUPATION.tank] = cc.p(100,y-200)

	local y = high/2 + 100
	self.defStance = {}  --防守方站位
	--步兵
	self.defStance[OCCUPATION.footsoldier] = cc.p(340,y)
	--骑兵
	self.defStance[OCCUPATION.cavalry] = cc.p(540,y+200)
	--法师
	self.defStance[OCCUPATION.master] = cc.p(100,y+200)
	--弓兵
	self.defStance[OCCUPATION.archer] = cc.p(540,y+400)
	--战车兵
	self.defStance[OCCUPATION.tank] = cc.p(100,y+400)
end

--初始化战斗成员信息
--返回值(无)
function BattleLogic:initMemInfo()
	for i=1,5 do
		local pos = self.attStance[i]
		local soldierPosInfo = BattleData:getInstance():getSoldierPosInfoByType(i,CAMP.ATTER)
		if soldierPosInfo ~= nil then
			soldierPosInfo.beginPos = pos
			self:createSolider(soldierPosInfo,self.soldierLayer,i,ANMATION_DIR.LEFT_UP,CAMP.ATTER)
		end
	end

	for i=1,5 do
		local pos = self.defStance[i]
		local soldierPosInfo = BattleData:getInstance():getSoldierPosInfoByType(i,CAMP.DEFER)
		if soldierPosInfo ~= nil then
			soldierPosInfo.beginPos = pos
			self:createSolider(soldierPosInfo,self.soldierLayer,i,ANMATION_DIR.RIGHT_DOWN,CAMP.DEFER)
		end
	end
end

--创建箭塔
function BattleLogic:createArrowTower()
	local function createTower(towerType,pos)
		local tower = ArrowTower.new(BATTLE_CONFIG[towerType],ANMATION_DIR.UP,towerType,CAMP.DEFER)
		tower:setPosition(pos)
		self.soldierLayer:addChild(tower)
		HeroMgr:getInstance():addSoldier(tower,towerType,CAMP.DEFER)
	end

	local defTowerList = BattleData:getInstance():getDefTowerList()
	if defTowerList == nil or #defTowerList <= 0 then
		return
	end

	local high = self.bgMap:getContentSize().height
	local wide = self.bgMap:getContentSize().width
	local y = high - 500
	wide = display.width
	local midX = wide/2
	local leftX = 150

	local posArry = {}
	local towerCount = #defTowerList
	if towerCount == 1 then
		local pos = cc.p(midX,y)
		table.insert(posArry,pos)
	elseif towerCount == 2 then
		local pos1 = cc.p(leftX,y)
		table.insert(posArry,pos1)
		local pos2 = cc.p(wide-leftX,y)
		table.insert(posArry,pos2)
	elseif towerCount == 3 then
		local pos1 = cc.p(leftX,y)
		table.insert(posArry,pos1)
		local pos2 = cc.p(midX,y)
		table.insert(posArry,pos2)
		local pos3 = cc.p(wide-leftX,y)
		table.insert(posArry,pos3)
	end

	for i=1,towerCount do
		local pos = posArry[i]
		local towerInfo = defTowerList[i]
		if towerInfo.type == BuildType.arrowTower then
			createTower(SOLDIER_TYPE.arrowTower,pos)			
		elseif towerInfo.type == BuildType.turret then
			createTower(SOLDIER_TYPE.turretTower,pos)	
		elseif towerInfo.type == BuildType.magicTower then
			createTower(SOLDIER_TYPE.magicTower,pos)	
		end
	end
end

--创建士兵
--posInfo 位置信息 
--parent 父结点
--job 职业
--dir 动画方向 
--camp 阵营
--返回值(无)
function BattleLogic:createSolider(posInfo,parent,job,dir,camp)
	if posInfo == nil then
		return
	end

	local index = 1
	for row=1,posInfo.row do
		for col=1,posInfo.maxColCount do
			local soldierType = BattleData:getInstance():getSoldierTypeByJobAndIndex(camp,job,index)
			if soldierType == nil then
				return
			end
			local hero = Hero.new(BATTLE_CONFIG[soldierType],dir,soldierType,camp)
			if camp == CAMP.DEFER then
				hero:setPosition((col-1)*30+posInfo.beginPos.x, 30+(row-1)*30+posInfo.beginPos.y)
			else
				hero:setPosition((col-1)*30+posInfo.beginPos.x, 160-(row-1)*30+posInfo.beginPos.y)
				hero:setMyColor(cc.c3b(255, 0, 255))
			end
		    parent:addChild(hero)
		    HeroMgr:getInstance():addSoldier(hero,soldierType,camp,row,col)
			if row == posInfo.row and col == posInfo.col then
				return
			end
			index = index + 1
		end
	end
end

--打开定时器
--返回值(无)
function BattleLogic:openTime()
	if self.handle ~= nil then
		return
	end
    self:stopTime()
    --打开AI定时器
    self.handle = scheduler.scheduleGlobal(handler(self, self.update), 0)

    --获取陷井个数
    self.trapCount = BattleData:getInstance():getTrapCount()
    --当有陷井时,AI要停止移动
    if self.trapCount > 0 then
    	self:setIsPauseAI(true)
    	self:doPvpBattleReport()
    else
    	self:setIsPauseAI(false)
    	self:delayOpenBattleTime()
    end

    --math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    -- local skill = SkillMgr:getInstance():createNewSkill(SkillsType.ROCKET,RocketTab,CAMP.ATTER) 
    -- self.effectLayer:addChild(skill) 

    -- local skill = SkillMgr:getInstance():createNewSkill(SkillsType.BOWLING,BowlingTab,CAMP.ATTER) 
    -- self.effectLayer:addChild(skill) 

    -- local skill = SkillMgr:getInstance():createNewSkill(SkillsType.HERO_ROCKET,HeroRocketTab,CAMP.ATTER) 
    -- self.effectLayer:addChild(skill) 
end

--延迟打开计算战斗序列定时器
function BattleLogic:delayOpenBattleTime()
	local sequence = transition.sequence({
		cc.DelayTime:create(4),
    	cc.CallFunc:create(function()
    		self:openBattleSeqTime()
    	end),
	})
	self:runAction(sequence)
end

--设置是否暂停AI
function BattleLogic:setIsPauseAI(isPause)
	local atterList = HeroMgr:getInstance():getSoldierList(CAMP.ATTER)
	for k,v in pairs(atterList) do
		v.hero:setPuase(isPause)
	end

	local deferList = HeroMgr:getInstance():getSoldierList(CAMP.DEFER)
	for k,v in pairs(deferList) do
		v.hero:setPuase(isPause)
	end
end

--停止定时器
--返回值(无)
function BattleLogic:stopTime()
	if self.handle ~= nil then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
	end
	self:stopBattleSeqTime()
end

--打开计算战斗序列定时器
function BattleLogic:openBattleSeqTime()
	self:stopBattleSeqTime()
	self.handleBattlePvp = scheduler.scheduleGlobal(handler(self, self.doPvpBattleReport), 1)
end

--停止计算战斗序列定时器
function BattleLogic:stopBattleSeqTime()
	if self.handleBattlePvp ~= nil then
		scheduler.unscheduleGlobal(self.handleBattlePvp)
		self.handleBattlePvp = nil
	end
end

--每帧更新战斗逻辑
--dt 时间
--返回值(无)
function BattleLogic:update(dt)
	local atterList = HeroMgr:getInstance():getSoldierList(CAMP.ATTER)
	for k,v in pairs(atterList) do
		v.hero:update(dt)
	end

	local deferList = HeroMgr:getInstance():getSoldierList(CAMP.DEFER)
	for k,v in pairs(deferList) do
		v.hero:update(dt)
	end
end

--获取士兵模型个数
--camp 阵营
--soldierType 士兵类型
--返回值(模型个数)
function BattleLogic:getSoldierModeCount(camp,soldierType)
	local count = 0
	local soldierlist = HeroMgr:getInstance():getSoldierList(camp)
	if soldierlist == nil then
		return 0
	end
	for k,v in pairs(soldierlist) do
		if v.hero.soldierType == soldierType then
			count = count + 1
		end
	end
	return count
end

--减少兵力
--number 数量 
function BattleLogic:minusPower(number,deathCamp)
	if number > 0 then
		BattleData:getInstance():hurtSoldierNum(deathCamp,number)
		local pvpBattleCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.PVP_BATTLE)
		if pvpBattleCtrl ~= nil then
			local power = BattleData:getInstance():getSoldierTotal(deathCamp)
			pvpBattleCtrl:setPower(deathCamp, power)
		end
		local copyBattleCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.INSTANCE_BATTLE_CITY)
		if copyBattleCommand ~= nil then
			local power = BattleData:getInstance():getSoldierTotal(deathCamp)
			copyBattleCommand:setPower(deathCamp, power)
		end
	end
end

--损失士兵
--deathCamp 死掉的阵营
--deathSoldierType 死掉的士兵类型
--deathCount 死亡个数
function BattleLogic:loseSoldier(deathCamp,deathSoldierType,deathCount)
	if deathCount <= 0 then
		return
	end

	local soldierModeCount = self:getSoldierModeCount(deathCamp,deathSoldierType)
	local leftCount = BattleData:getInstance():minusSoldierNumByType(deathCamp,deathSoldierType,deathCount)
	local soldierlist = HeroMgr:getInstance():getSoldierList(deathCamp)
	if leftCount <= 0 then
		if soldierlist ~= nil and leftCount ~= -1 then
			for k,v in pairs(soldierlist) do
				if v.hero.soldierType == deathSoldierType then
					v.hero:death()
				end
			end
		end  
	else
		local soldierConfig = BattleData:getInstance():getSoldierConfigInfo(deathSoldierType)
		local leftMode = leftCount/soldierConfig.countToModeValue
		leftMode = math.ceil(leftMode)
		local deathModeCount = soldierModeCount - leftMode
		local curDeathModeCount = 0

		if soldierlist ~= nil and deathModeCount > 0 then
			for k,v in pairs(soldierlist) do
				if v.hero.soldierType == deathSoldierType then
					v.hero:death()
					curDeathModeCount = curDeathModeCount + 1
					if curDeathModeCount >= deathModeCount then
						break
					end
				end
			end
		end
	end
	self:minusPower(deathCount,deathCamp)
end

--损失英雄
--leftHp 剩余hp
function BattleLogic:loseHero(leftHp,deathCamp)
	if leftHp <= 0 then
		self:minusPower(1,deathCamp)
	end
end

--损失兵力
--loseData 损失兵力
function BattleLogic:lose(loseData,deathCamp)
	if loseData == nil or #loseData == 0 then
		print("第",self.index,"回合没有产生任何伤害")
		self.index = self.index + 1
		return
	end

	for k,v in pairs(loseData) do
		if v.loseType == BattleSeqType.common then  --损失士兵
			self:loseSoldier(deathCamp,v.loseSoldierType,v.loseNum)
		elseif v.loseType == BattleSeqType.hero then --损失英雄
			self:loseHero(v.leftHp,deathCamp)
		end
	end
	self.index = self.index + 1
end

--完成播放陷井回调
function BattleLogic:finishPlayTrapCallback()
	self.playState = PlaylState.finish
	self:doPvpBattleReport()
	self.trapCount = self.trapCount - 1
	if self.trapCount <= 0 then
		self:setIsPauseAI(false)
		self:delayOpenBattleTime()
	end
end

--完成播放技能回调
function BattleLogic:finishPlaySkillCallback()
	self.playState = PlaylState.finish
	self:doPvpBattleReport()
end

--执行战报逻辑
--返回值(无)
function BattleLogic:doPvpBattleReport()
	local data = BattleData:getInstance():getBattleReportData(self.index)
	if data ~= nil then
		print("第",self.index,"回合序列")
		local deathCamp = data.derCamp   --防守阵营
		local loseData = data.deferData  --伤害数据
		local attType = data.attType 	--攻击方式
		local skillId = data.skillId    --技能id
		if attType == BattleSeqType.trap then  --陷井攻击
			if self.playState == PlaylState.none then   --未在播放中
				local skill = SkillMgr:getInstance():createNewSkill(data.skillType,data.config,CAMP.hurtCamp,self.finishPlayTrapCallback,self) 
				print("skill=",skill,"self.effectLayer=",self.effectLayer,"data.skillType=",data.skillType,"data.config=",data.config)
    			self.effectLayer:addChild(skill)
    			self.playState = PlaylState.playing
    			print("第",self.index,"回合","发动陷井攻击")
			elseif self.playState == PlaylState.finish then  --播放完陷井
				self:lose(loseData,deathCamp)
				self.playState = PlaylState.none
			end
		elseif attType == BattleSeqType.hero then --英雄技能攻击
			if skillId > 0 then  --有技能
				if self.playState == PlaylState.none then   --未在播放中
					local skill = SkillMgr:getInstance():createNewSkill(data.skillType,data.config,data.hurtCamp,self.finishPlaySkillCallback,self,skillId) 
	    			self.effectLayer:addChild(skill)
	    			self.playState = PlaylState.playing
	    			print("第",self.index,"回合","英雄放技能,技能id=",skillId)
				elseif self.playState == PlaylState.finish then  --播放完技能
					self:lose(loseData,deathCamp)
					self.playState = PlaylState.none
				end
			else  --普通攻击不表现
				print("第",self.index,"回合","英雄普通攻击,技能id=",skillId)
				self:lose(loseData,deathCamp)
			end
		else  --士兵攻击,箭塔攻击
			self:lose(loseData,deathCamp)
		end
	else
		print("第",self.index-1,"回合战斗结束")
		self:stopTime()
		--完成战斗
		if self.battleType == BattleType.pvpBattle then -- PVP战斗
			self:finishBattle()
		else
			self:finishCopyBattle()
		end
	end
end

--完成副本战斗
--返回值(无)
function BattleLogic:finishCopyBattle()
	for k,v in pairs(HeroMgr:getInstance():getSoldierList(CAMP.DEFER)) do
		v.hero:idle()
		v.hero:setPuase(true)
	end

	for k,v in pairs(HeroMgr:getInstance():getSoldierList(CAMP.ATTER)) do
		v.hero:idle()
		v.hero:setPuase(true)
	end

	local copyBattleCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.INSTANCE_BATTLE_CITY)
	if copyBattleCommand ~= nil then
		if BattleData:getInstance():isWinBattle() then
			copyBattleCommand:showWinView()
		else
			copyBattleCommand:showFailView()
		end
	end
end

--完成战斗
--返回值(无)
function BattleLogic:finishBattle()
	--todo
	local soldierlist = {}
	local winCamp = BattleData:getInstance():getWinCamp()
	if winCamp == CAMP.ATTER then
		soldierlist = HeroMgr:getInstance():getSoldierList(CAMP.DEFER)
	else
		soldierlist = HeroMgr:getInstance():getSoldierList(CAMP.ATTER)
	end

	for k,v in pairs(HeroMgr:getInstance():getSoldierList(CAMP.DEFER)) do
		v.hero:idle()
		v.hero:setPuase(true)
	end

	for k,v in pairs(HeroMgr:getInstance():getSoldierList(CAMP.ATTER)) do
		v.hero:idle()
		v.hero:setPuase(true)
	end

	if BattleData:getInstance():isWinBattle() then
		UIMgr:getInstance():openUI(UITYPE.PVP_BATTLE_RESULT,{win=true})
	else
		UIMgr:getInstance():openUI(UITYPE.PVP_BATTLE_RESULT,{win=false})
	end
end

--获取特效层
--返回值(特效层)
function BattleLogic:getEffectLayer()
	return self.effectLayer
end

--获取士兵层
--返回值(士兵层)
function BattleLogic:getSoldierLayer()
	return self.soldierLayer
end

function BattleLogic:getBgMapSize()
	return self.bgMap:getBoundingBox()
end







