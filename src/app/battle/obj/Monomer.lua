
--[[
	jinyan.zhang
	对象基类
--]]

Monomer = class("Monomer", function()
	return display.newLayer()
end)

local _id = 0

--构造
--params 参数
--dir 人物朝向
--soldierType 士兵类型
--camp 阵营(true攻者方,false:防守方)
--color 颜色
--返回值(无)
function Monomer:ctor(params,dir,soldierType,camp)
	self:setNodeEventEnabled(true)

	self.params = params
    self.pause = false
	self.dir = dir
	self.soldierType = soldierType
    self.job = ArmsData:getInstance():soldierTypeToOccupation(soldierType)
	self.camp = camp
    if self.camp == CAMP.ATTER then
        self.enemyCamp = CAMP.DEFER
    elseif self.camp == CAMP.DEFER then
        self.enemyCamp = CAMP.ATTER
    end

	self.id = self:createId()

    if params ~= nil then
        self.attack_distance = params.attack_distance
        self.moveSpeed = params.moveSpeed
        self.beRectSize = params.beRecSize
    end

	self.moveInfo = {
		targetPos = nil,
		handle = nil,
	}
    self.attMeEnemy = {}
    self.isRushing = true  --冲刺中
    self.skillCDTime = 0     --技能CD时间

    self:clearChaseTypeTab()

	self:init()
end

--设置颜色
--color 颜色 
--返回值(无)
function Monomer:setMyColor(color)
    self.color = color
    if self.monor ~= nil then
        self.monor:setMyColor(self.color)
    end
end

--设置暂停
--isPause(true:暂停,false:不暂停)
--返回值(无)
function Monomer:setPuase(isPause)
    self.pause = isPause
end

--创建头顶上的血条
--hpSize 血条大小
--返回值(无)
function Monomer:createHeadHp(hpSize)
    local size = hpSize
    self.hpBg = display.newScale9Sprite("battle/hpbox.png", 0, 0, size)
    self:addChild(self.hpBg)
    self.hpBg:setPosition(0,30)

    local sprite = display.newSprite("battle/hp.png")
    self.hp = cc.ProgressTimer:create(sprite)
    self.hp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.hp:setMidpoint(cc.p(0, 0))
    self.hp:setBarChangeRate(cc.p(1, 0))
    self.hp:setPercentage(100)
    self.hp:setPosition(0,30)
    self:addChild(self.hp)
    self.hp:setScaleX(size.width/sprite:getContentSize().width)
end

--设置移动速度
--speed 移动速度
--返回值(无)
function Monomer:setSpeed(speed)
    self.moveSpeed = speed
end

--创建一个id
--返回值(id)
function Monomer:createId()
    _id = _id + 1
    if _id > 99999 then
        _id = 0
    end
    return _id
end

function Monomer:showFigure()
	self.monor = AnimationFigure.new(self.params,self.dir,self.soldierType,self)
	self.monor:setAnchorPoint(0,0)
	self:addChild(self.monor)
	self.monor:setScale(BATTLE_CONFIG.SCALE)
	self:setContentSize(self.monor:getBoundingBox())

	self:setStateAndDir(AI_STATE.IDLE,self.dir)

    self.monor:setMyColor(self.color)

    --test
    ----[[
    local label = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 20,
        color = cc.c3b(255, 0, 0), -- 使用纯红色
    })
    local name = ArmsData:getInstance():getSoldierName(self.soldierType)
    label:setString(name)
    self:addChild(label)
    --]]
end

function Monomer:idle()
    self:setStateAndDir(AI_STATE.IDLE,self.dir)
end

--初始化
--返回值(无)
function Monomer:init()
	--MyLog("Monomer init...")
end

--加入到舞台后会调用这个接口
--返回值(无)
function Monomer:onEnter()
	--MyLog("Monomer onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function Monomer:onExit()
	--MyLog("Monomer onExit()")
    TimeMgr:getInstance():removeInfo(TimeType.BATTLE_SKILL_CD)
end

--从内存释放后会调用这个接口
--返回值(无)
function Monomer:onDestroy()
	--MyLog("Monomer onDestroy()")
end 

--清空移动信息
--返回值(无)
function Monomer:clearMoveInfo()
	self.moveInfo = {}
end

-- 获取当前角色坐标
--返回值(当前坐标)
function Monomer:getCurPoint()
    local x,y = self:getPosition()
    return cc.p(x, y)
end

--设置人物状态和方向
--state 状态
--dir 方向
--返回值(无)
function Monomer:setStateAndDir(state, dir)
    local oldState = self.state
    local oldDirection = self.dir

    if state ~= nil then
        self.state = state
    end
    
    if dir ~= nil then
        self.dir = dir
    end

    if oldState == self:getState() and oldDirection == self:getDir() then
        return
    end

    if self.monor then
       self.monor:setStateAndDir(state,dir)
    end
end

--获取人物状态
--返回值(状态)
function Monomer:getState()
	return self.state 
end

--获取人物方向
--返回值(方向)
function Monomer:getDir()
	return self.dir
end

--更新位置
--dt 时间
--返回值(无)
function Monomer:updatePos(dt)
	local curPos = self:getCurPoint()
	local dis = cc.pGetDistance(curPos,self.moveInfo.targetPos)
    if dis <= 5 then
        self.isRushing = false
        self.moveInfo.handler(self)
        self:clearMoveInfo()
        return
    end

    local angle =  BattleCommon:getInstance():getTwoPosAngle(curPos,self.moveInfo.targetPos)

    local dir = BattleCommon:getInstance():getDirection(angle)
    self:setStateAndDir(AI_STATE.MOVE, dir)

    -- 刷新位置
    local perframeoffset = self.moveSpeed * dt
    local perframeoffset_x = perframeoffset * math.cos(angle / 180 * math.pi)
    local perframeoffset_y = perframeoffset * math.sin(angle / 180 * math.pi)
    local offsetpos = cc.p(perframeoffset_x , perframeoffset_y)
    local targetpos = cc.pAdd(curPos , offsetpos)

    self:setPosition(targetpos)

    --[[
    if self.isRushing then
        if targetpos.x == self.moveInfo.targetPos.x and
            targetPos.y == self.moveInfo.targetPos.y then
            self.isRushing = false
        end
    end
    --]]

    -- 刷新Z轴
    --self:updateZ()
end

--更新Z轴计时器回调函数
--返回值(无)
function Monomer:updateZ()
    local curPos = self:getCurPoint()
    local value = -curPos.y
    self:setLocalZOrder(value)
end

--设置目标点信息
--targetPos 目标位置
--fun 回调接口
--返回值(无)
function Monomer:walkToDest(targetPos,fun)
    self.moveInfo.targetPos = targetPos

    if fun == nil then
        self.moveInfo.handler = self.endToRun
    else
        self.moveInfo.handler = fun
    end
end

--结束移动
--返回值(无)
function Monomer:endToRun()
    if self:getState() == AI_STATE.DEATH then
        return
    end

    self:clearMoveInfo()
    self:setStateAndDir(AI_STATE.IDLE, self:getDir())

    local target = self:getAttackMajor()
    if target == nil or target.id == nil then
        return
    end

    if self.m_chaseDir ~= nil and self:isCurChaseDir(self.m_chaseDir) then
        self:setChaseDirValue(self.m_chaseDir , FULL , true , self)
    end
end

--设置攻击目标
--返回值(无)
function Monomer:setAttackMajor(AttackMajor)
    if self.m_AttackMajor ~= nil and self.m_AttackMajor ~= AttackMajor then
        if self.m_AttackMajor.removeAgainstMe then
            self.m_AttackMajor:removeAgainstMe(self)
        end
    end
    self.m_AttackMajor = AttackMajor
end

--获取攻击对象
--返回值(攻击目标)
function Monomer:getAttackMajor()
    return self.m_AttackMajor
end

--获取自己的攻击距离
--返回值(攻击距离)
function Monomer:getAttackDis()
  	return self.attack_distance
end

--获取距离
--返回值(距离)
function Monomer:getDistance(monomer)
    local startx, starty = self:getPosition()
    local endx, endy = monomer:getPosition()
    local x = startx - endx
    local y = starty - endy
    return math.sqrt( x * x + y * y )
end

--敌人在攻击范围内
--返回值(true:是,false:否)
function Monomer:isInTheAttackRange(monomer)
    local attackRange = self:getAttackDis()

    local dis = self:getDistance(monomer)
    dis = math.floor(dis)
    
    if dis > attackRange then
        return false
    end

    return true
end

--普攻攻击敌人
--useSkillIndex 使用第几个技能
--返回值(无)
function Monomer:normalattackEnemy(useSkillIndex)
    if not self.m_AttackMajor or not useSkillIndex then
        return
    end

    self:clearMoveInfo()
    self:stopAllActions()

    local lenghtX = self.m_AttackMajor:getPositionX() - self:getPositionX()
    local lenghtY = (self.m_AttackMajor:getPositionY() - self:getPositionY()) * math.sqrt(2)
    local lenght = math.sqrt(lenghtX * lenghtX + lenghtY * lenghtY)
    local pointX = lenghtX / lenght
    local pointY = lenghtY / lenght
        
    local angle_X = math.acos(pointX) * 180 / math.pi
    local angle_Y = math.acos(pointY) * 180 / math.pi
    
    local angle = angle_X
    if (angle_Y > 90) then
        angle = 360 - angle_X
    end
        
    local dir = BattleCommon:getInstance():getDirection(angle)
    self:setStateAndDir(AI_STATE.ATTACT,dir)

    --使用技能
    local skill = nil
    if self.job == OCCUPATION.cavalry or self.job == OCCUPATION.footsoldier then
        skill = SkillMgr:getInstance():createSkill(SkillsType.REGION,self,useSkillIndex)
    elseif self.job == OCCUPATION.arrowTower or self.job == OCCUPATION.turret 
        or self.job == OCCUPATION.magicPagoda then
        skill = SkillMgr:getInstance():createSkill(SkillsType.FLG,self,useSkillIndex)
    else
        skill = SkillMgr:getInstance():createSkill(SkillsType.FLG,self,useSkillIndex)
    end

    if skill ~= nil then
        self:addChild(skill)
        self:setSkillCDTime(useSkillIndex)
    end
end

--获取技能CD时间
--useSkillIndex 使用第几个技能
--返回值(技能CD时间)
function Monomer:getSkillCDTime(useSkillIndex)
    return BattleCommon:getInstance():getAttCDTime(self,useSkillIndex)
end

--设置技能CD时间
--useSkillIndex 使用第几个技能
--返回值(无)
function Monomer:setSkillCDTime(useSkillIndex)
    local skillLastTime = BattleCommon:getInstance():getAttAnimationLastTime(self,useSkillIndex)
    self.skillCDTime = self:getSkillCDTime(useSkillIndex) + skillLastTime

    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.BATTLE_SKILL_CD,useSkillIndex,self.id)
    if not timeInfo then
        local info = {}
        info.index = useSkillIndex
        TimeMgr:getInstance():addInfo(TimeType.BATTLE_SKILL_CD, info, self.id,self.updateSkillTime, self)
    else
        timeInfo.pause = false
    end
end

--更新流逝的技能时间
--info 技能信息
--返回值(无)
function Monomer:updateSkillTime(info)
    self.skillCDTime = self.skillCDTime - 1 
    if self.skillCDTime < 0 then
        self.skillCDTime = 0
        TimeMgr:getInstance():pauseTimeTypeInfoByIndex(TimeType.BATTLE_SKILL_CD,info.index,self.id)
    end
end

--获取技能
--返回值(技能)
function Monomer:getSkillIndex()
    local skillIndex = 1
    if self.skillCDTime == 0 then
        return skillIndex
    end
end

--查找正攻击我的敌人
--hero 敌人
--返回值(true:找到,false:未找到)
function Monomer:findAttMeEnemy(hero)
    for k,v in pairs(self.attMeEnemy) do
        if v.hero == hero then
            return true
        end
    end
    return false
end

--删除攻击我的敌人
--hero 敌人
--返回值(无)
function Monomer:removeAttMeEnemy(hero)
    for k,v in pairs(self.attMeEnemy) do
        if v.hero == hero then
            table.remove(self.attMeEnemy,k)
            break
        end
    end
end

--添加攻击我的敌人
--hero 敌人
--返回值(无)
function Monomer:addAttMeEnemy(hero)
    if not self:findAttMeEnemy(atter) then
        table.insert(self.attMeEnemy,atter)
    end
end

--受击
--atter 攻击者
--返回值(无)
function Monomer:hurt(atter)
    self:addAttMeEnemy(atter)
end

--死亡
--atter 攻击者
--返回值(无)
function Monomer:death(atter)
    self:clearData()
    
    local deathLastTime = self.monor:getDeathAnimationLastTime()
    local sequence = transition.sequence({
    cc.DelayTime:create(deathLastTime),
    cc.CallFunc:create(function()
        HeroMgr:getInstance():delSolider(self)
    end),
    })
    self:runAction(sequence)
end

--删除自己
--返回值(无)
function Monomer:remove()
    self:clearData()
    HeroMgr:getInstance():delSolider(self)
end

--清理数据
--返回值(无)
function Monomer:clearData()
    self:clearChasetDir()
    self:clearMoveInfo()
    self:setAttackMajor(nil)

    --攻击目标是我的，目标全清空，因为我死了
    local soldierList = HeroMgr:getInstance():getSoldierList(self.enemyCamp)
    for k,v in pairs(soldierList) do
        if v.hero and v.hero:getState() ~= AI_STATE.DEATH and v.hero:getAttackMajor() == self then
            v.hero:setAttackMajor(nil)
            v.hero.isRushing = false
            v.hero:clearMoveInfo()
            v.hero:setStateAndDir(AI_STATE.IDLE, self:getDir())
        end
    end

    local soldierList = HeroMgr:getInstance():getSoldierList(self.camp)
    for k,v in pairs(soldierList) do
        if v.hero and v.hero:getState() ~= AI_STATE.DEATH and v.hero:getAttackMajor() == self then
            v.hero:setAttackMajor(nil)
            v.hero.isRushing = false
            v.hero:clearMoveInfo()
            v.hero:setStateAndDir(AI_STATE.IDLE, self:getDir())
        end
    end

    self.attMeEnemy = {}
    self:clearChaseTypeTab()

    self:setStateAndDir(AI_STATE.DEATH, self:getDir())
    EffectMgr:getInstance():removeEffect(self)
    SkillMgr:getInstance():removeAllSkill(self)
    TimeMgr:getInstance():removeInfo(TimeType.BATTLE_SKILL_CD,self.id)
end

--清空追击类型表
--返回值(无)
function Monomer:clearChaseTypeTab()
    self.m_chaseType = {}
    self.m_chaseType[CHASE_DIR_LEFTDOWN] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_RIGHTDOWN] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_LEFTUP] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_RIGHTUP] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_DOWN] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_UP] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_LEFT] = {result = EMPTY, arrTarget = false, attacker = nil}
    self.m_chaseType[CHASE_DIR_RIGHT] = {result = EMPTY, arrTarget = false, attacker = nil}
end

--获取已经用掉的追击空位个数
--chaseTarget 追击目标
--返回值(用掉的空位个数)
function Monomer:getUseingChaseEmptyCount(chaseTarget)
    if chaseTarget == nil then
        return 8
    end

    local count = 0
    for k,v in pairs(chaseTarget.m_chaseType) do
        if v.result == FULL then
            count = count + 1
        end
    end
    return count
end

--------------------------------------------------------------------------------------
--------------------                  角色追击站位部分                  --------------------
--------------------------------------------------------------------------------------

--设置追击方向
function Monomer:setChaseDirValue(chaseDir , value , haveArrive , attacker)
    self.m_AttackMajor.m_chaseType[chaseDir].attacker = attacker
    self.m_AttackMajor.m_chaseType[chaseDir].arrTarget = haveArrive
    self.m_AttackMajor.m_chaseType[chaseDir].result = value
end

--获取追击方向
function Monomer:getChasetDir(target)
    local function getChaseDir(chaseDirs)
        for i = 1 , #chaseDirs do
            if self:isCanChaseThisDir(chaseDirs[i],target) then
                return chaseDirs[i]
            end
        end
    end

    local targetX = target:getPositionX()
    local targetY = target:getPositionY()
    local x = self:getPositionX()
    local y = self:getPositionY()

    local atLeft = false
    local atRight = false
    if x < targetX then
        atLeft = true
        atRight = false
    else
        atLeft = false
        atRight = true
    end

    local atUp = false
    local atDown = false
    if y > targetY then
        atUp = true
        atDown = false
    else
        atUp = false
        atDown = true
    end

    local chasetDirs = {}
    
    if atUp then
        if self:isCanChaseThisDir(CHASE_DIR_UP,target) then
            return CHASE_DIR_UP
        end

        if atLeft then
            table.insert(chasetDirs,CHASE_DIR_LEFTUP)
            table.insert(chasetDirs,CHASE_DIR_LEFT)
            table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
            table.insert(chasetDirs,CHASE_DIR_RIGHT)
            table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
            table.insert(chasetDirs,CHASE_DIR_DOWN)
            table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
        elseif atRight then
            table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
            table.insert(chasetDirs,CHASE_DIR_RIGHT)
            table.insert(chasetDirs,CHASE_DIR_LEFTUP)
            table.insert(chasetDirs,CHASE_DIR_LEFT)
            table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
            table.insert(chasetDirs,CHASE_DIR_DOWN)
            table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
        end
        return getChaseDir(chasetDirs)
    elseif atDown then
        if self:isCanChaseThisDir(CHASE_DIR_DOWN,target) then
            return CHASE_DIR_DOWN
        end

        if atLeft then
            table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
            table.insert(chasetDirs,CHASE_DIR_LEFT)
            table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
            table.insert(chasetDirs,CHASE_DIR_RIGHT)
            table.insert(chasetDirs,CHASE_DIR_LEFTUP)
            table.insert(chasetDirs,CHASE_DIR_UP)
            table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
        elseif atRight then
            table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
            table.insert(chasetDirs,CHASE_DIR_RIGHT)
            table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
            table.insert(chasetDirs,CHASE_DIR_LEFT)
            table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
            table.insert(chasetDirs,CHASE_DIR_UP)
            table.insert(chasetDirs,CHASE_DIR_LEFTUP)
        end
        return getChaseDir(chasetDirs)
    end

    if atLeft and atUp then
        if self:isCanChaseThisDir(CHASE_DIR_LEFTUP,target) then
            return CHASE_DIR_LEFTUP
        end 

        table.insert(chasetDirs,CHASE_DIR_UP)
        table.insert(chasetDirs,CHASE_DIR_LEFT)
        table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
        table.insert(chasetDirs,CHASE_DIR_RIGHT)
        table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
        table.insert(chasetDirs,CHASE_DIR_DOWN)
        table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
        return getChaseDir(chasetDirs)
    end

    if atLeft and atDown then
        if self:isCanChaseThisDir(CHASE_DIR_LEFTDOWN,target) then
            return CHASE_DIR_LEFTDOWN
        end 

        table.insert(chasetDirs,CHASE_DIR_DOWN)
        table.insert(chasetDirs,CHASE_DIR_LEFT)
        table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
        table.insert(chasetDirs,CHASE_DIR_RIGHT)
        table.insert(chasetDirs,CHASE_DIR_LEFTUP)
        table.insert(chasetDirs,CHASE_DIR_UP)
        table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
        return getChaseDir(chasetDirs)
    end

    if atRight and atUp then
        if self:isCanChaseThisDir(CHASE_DIR_RIGHTUP,target) then
            return CHASE_DIR_RIGHTUP
        end 

        table.insert(chasetDirs,CHASE_DIR_UP)
        table.insert(chasetDirs,CHASE_DIR_RIGHT)
        table.insert(chasetDirs,CHASE_DIR_LEFTUP)
        table.insert(chasetDirs,CHASE_DIR_LEFT)
        table.insert(chasetDirs,CHASE_DIR_RIGHTDOWN)
        table.insert(chasetDirs,CHASE_DIR_DOWN)
        table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
        return getChaseDir(chasetDirs)
    end

    if atRight and atDown then
        if self:isCanChaseThisDir(CHASE_DIR_RIGHTDOWN,target) then
            return CHASE_DIR_RIGHTDOWN
        end 

        table.insert(chasetDirs,CHASE_DIR_DOWN)
        table.insert(chasetDirs,CHASE_DIR_RIGHT)
        table.insert(chasetDirs,CHASE_DIR_LEFTDOWN)
        table.insert(chasetDirs,CHASE_DIR_LEFT)
        table.insert(chasetDirs,CHASE_DIR_RIGHTUP)
        table.insert(chasetDirs,CHASE_DIR_UP)
        table.insert(chasetDirs,CHASE_DIR_LEFTUP)
        return getChaseDir(chasetDirs)
    end
end

--是否可以追击这个位置(边界检测)
--targetPos 追击位置
--chaseTarget 追击目标
--返回值(true:可以,false:不可以)
function Monomer:isCanChaseThisPos(targetPos,chaseTarget)
    if targetPos == nil then
        return false
    end

    local offsetX = 50
    local offsetY = 50
    if targetPos.x <= offsetX or targetPos.x >= display.width - offsetX then
        return false
    end

    if targetPos.y <= offsetY or targetPos.y >= display.height - offsetY then
        return false
    end

    return true
end

--是否可以追击这个方向
--返回值(true:可以,false:不可以)
function Monomer:isCanChaseThisDir(chaseDir , chaseTarget)
    if chaseTarget.m_chaseType[chaseDir].result == EMPTY then
        local chasePos = self:getChasePos(chaseTarget , chaseDir)
        return self:isCanChaseThisPos(chasePos , chaseTarget)
    end
end

--是否到达追击点
--返回值(true:是,false:否)
function Monomer:isHaveArryChasePos(chaseDir)
    if chaseDir ~= nil then
        return self.m_AttackMajor.m_chaseType[chaseDir].arrTarget
    end
end

--是否是当前的追击方向
--返回值(无)
function Monomer:isCurChaseDir(chaseDir)
    return self.m_AttackMajor.m_chaseType[chaseDir].result == FULL
end

--获取追击坐标
--返回值(无)
function Monomer:getChasePos(target , chaseDir)
    local targetPos = cc.p(target:getPositionX(),target:getPositionY())
    local curPos = Common:getPosition(self)
    local dis = cc.pGetDistance(targetPos,curPos)
    local localpos = self:getChasePosByDir(dis,chaseDir)
	return cc.pAdd(localpos,targetPos)
end

--清空追击方向
--返回值(无)
function Monomer:clearChasetDir()
    local target = self:getAttackMajor()
    if target ~= nil and target.id ~= nil and self.m_chaseDir ~= nil then
        self:setChaseDirValue(self.m_chaseDir , EMPTY , false , nil)
    end
    self.m_chaseDir = nil
end

--获取追击坐标
--attDis 攻击距离
--chaseDir 追击方向
--返回值(追击坐标)
function Monomer:getChasePosByDir(attDis,chaseDir)
    local angle = 45 / 180 * math.pi
    if attDis and attDis < 20 then
        attDis = 20
    end
    if attDis and attDis > self:getAttackDis() then
        attDis = nil
    end

    local chasepointradius = attDis or (self:getAttackDis() - 4)
    local y = math.sin(angle) * chasepointradius
    local x = math.sqrt((chasepointradius * chasepointradius - y * y))
    local chasePos = nil
    if chaseDir == CHASE_DIR_LEFTDOWN then
        chasePos = cc.p(-x,-y)
    elseif chaseDir == CHASE_DIR_RIGHTDOWN then
        chasePos = cc.p(x,-y)
    elseif chaseDir == CHASE_DIR_LEFTUP then
        chasePos = cc.p(-x,y)
    elseif chaseDir == CHASE_DIR_RIGHTUP then
        chasePos = cc.p(x,y)
    elseif chaseDir == CHASE_DIR_DOWN then
        chasePos = cc.p(0,-chasepointradius)
    elseif chaseDir == CHASE_DIR_UP then
        chasePos = cc.p(0,chasepointradius)
    elseif chaseDir == CHASE_DIR_LEFT then
        chasePos = cc.p(-x,0)
    elseif chaseDir == CHASE_DIR_RIGHT then
        chasePos = cc.p(x,0)
    end
    return chasePos
end

--获取受击区
--返回值(受击区)
function Monomer:getBeRect()
    local dir = self:getDir()
    local x,y = self:getPosition()
    local size = self.beRectSize
    local beRect = cc.rect(0,0,size.width,size.height)

    if dir == ANMATION_DIR.LEFT_DOWN then
        beRect.x = x - beRect.width/2
        beRect.y = y
    elseif dir == ANMATION_DIR.RIGHT_DOWN then
        beRect.x = x - beRect.width/2
        beRect.y = y 
    elseif dir == ANMATION_DIR.LEFT_UP then
        beRect.x = x - beRect.width/2
        beRect.y = y
    elseif dir == ANMATION_DIR.RIGHT_UP then
        beRect.x = x - beRect.width/2
        beRect.y = y 
    elseif dir == ANMATION_DIR.UP then
        beRect.x = x - beRect.width/2
        beRect.y = y
    elseif dir == ANMATION_DIR.DOWN then
        beRect.x = x - beRect.width/2
        beRect.y = y 
    elseif dir == ANMATION_DIR.LEFT then
        beRect.x = x - beRect.width/2
        beRect.y = y
    elseif dir == ANMATION_DIR.RIGHT then
        beRect.x = x - beRect.width/2
        beRect.y = y 
    end
    beRect.y = beRect.y - beRect.height/2

    return beRect
end








