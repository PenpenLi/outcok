
--[[
	jinyan.zhang
	战斗公用方法
--]]

BattleCommon = class("BattleCommon")
local instance = nil

--构造
--返回值(无)
function BattleCommon:ctor()
	self:init()
end

--初始化
--返回值(无)
function BattleCommon:init()

end

--获取单例
--返回值(单例)
function BattleCommon:getInstance()
	if instance == nil then
		instance = BattleCommon.new()
	end
	return instance
end

-- 计算曲线控制点
--startpoint 起点
--endpoint 结束点
--返回值(控制点)
function BattleCommon:calculatecontrolpoint(startpoint,endpoint)
    local controllength = cc.pGetDistance(startpoint,endpoint)/2
    local offsettingradiansfactor = 2

    if endpoint.x >= startpoint.x then
        -- 第一象限
        if endpoint.y >= startpoint.y then
            local x = endpoint.x - startpoint.x
            local y = endpoint.y - startpoint.y
            local radians
            if x == 0 then
                radians = math.pi / 2
            else
                radians = math.atan(y / x)
            end
            local offsettingradians = (math.pi / 2 - radians) / offsettingradiansfactor
            local finalradians = radians + offsettingradians
            local final_x = controllength * math.cos(finalradians)
            local final_y = controllength * math.sin(finalradians)

            return cc.p(final_x + startpoint.x , final_y + startpoint.y)
        -- 第二象限
        else
            local x = endpoint.x - startpoint.x
            local y = startpoint.y - endpoint.y
            local radians
            if x == 0 then
                radians = math.pi / 2
            else
                radians = math.atan(y / x)
            end
            local offsettingradians = (math.pi / 2 - radians) / offsettingradiansfactor
            local finalradians = radians - offsettingradians
            local final_x = controllength * math.cos(finalradians)
            local final_y = -controllength * math.sin(finalradians)
            
            return cc.p(final_x + startpoint.x , final_y + startpoint.y)
        end
    else
        -- 第三象限
        if endpoint.y < startpoint.y then
            local x = startpoint.x - endpoint.x
            local y = startpoint.y - endpoint.y
            local radians
            if x == 0 then
                radians = math.pi / 2
            else
                radians = math.atan(y / x)
            end
            local offsettingradians = (math.pi / 2 - radians) / offsettingradiansfactor
            local finalradians = radians - offsettingradians
            local final_x = -controllength * math.cos(finalradians)
            local final_y = -controllength * math.sin(finalradians)

            return cc.p(final_x + startpoint.x , final_y + startpoint.y)
        -- 第四象限
        else
            local x = startpoint.x - endpoint.x
            local y = endpoint.y - startpoint.y
            local radians
            if x == 0 then
                radians = math.pi / 2
            else
                radians = math.atan(y / x)
            end
            local offsettingradians = (math.pi / 2 - radians) / offsettingradiansfactor
            local finalradians = radians + offsettingradians
            local final_x = -controllength * math.cos(finalradians)
            local final_y = controllength * math.sin(finalradians)

            return cc.p(final_x + startpoint.x , final_y + startpoint.y)
        end
    end
end

-- 计算子弹飞行的时间
--startpoint 超始点
--endpoint   结束点
--speed 速度
--返回值(时间)
function BattleCommon:calculateBulletFlyTime (startpoint,endpoint,speed)
    local realworldis_x = math.abs(endpoint.x - startpoint.x)
    local realworldis_y = math.abs(endpoint.y - startpoint.y) / math.sin(45 / 180 * math.pi)
    local realworldis = math.sqrt(realworldis_x * realworldis_x + realworldis_y * realworldis_y)
    return realworldis / speed
end

--初始化曲线
--Startpos --起点
--Targetpos --终点
--speed 速度
--parent 父结点
--返回值(曲线Action)
function BattleCommon:initBezierTo(startpos,targetpos,speed,parent)
    local controlpoint1 = self:calculatecontrolpoint(cc.p(startpos.x, startpos.y) , cc.p(targetpos.x , targetpos.y))
    local controlpoint2 = self:calculatecontrolpoint(cc.p(targetpos.x , targetpos.y) , cc.p(startpos.x, startpos.y))

    ----[[
    if parent ~= nil then
        local testSpr = display.newSprite("test/img_guide_frame.png")
        parent:addChild(testSpr,999)
        testSpr:setPosition(controlpoint1)

        local ctrolSpr1 = display.newSprite("test/Icon.png")
        parent:addChild(ctrolSpr1,999)
        ctrolSpr1:setPosition(controlpoint2)

        local ctrolSpr2 = display.newSprite("test/loading_juhua.png")
        parent:addChild(ctrolSpr2,999)
        ctrolSpr2:setPosition(targetpos)  
    end
    --]]

    return cc.BezierTo:create(self:calculateBulletFlyTime(startpos , targetpos,speed) , {controlpoint1 , controlpoint2 , targetpos})
end

--获取两个位置间的相对关系
--atterPos 攻击方位置
--deferPOS --防守方位置
--返回值(deferIsAtLeft true:防守者在左边,deferIsAtUp true:防守者在上方)
function BattleCommon:getTwoPosRelationShip(atterPos,deferPos)
    local deferIsAtLeft = false
    local xdis = atterPos.x - deferPos.x
    if xdis >= 0 then
        deferIsAtLeft = true
    end

    local deferIsAtUp = false
    local ydis = atterPos.y - deferPos.y
    if ydis <= 0 then
        deferIsAtUp = true
    end
    return deferIsAtLeft,deferIsAtUp
end

--根据指定角度获取方向
--fAngle 角度
--返回值(方向)
function BattleCommon:getDirection(fAngle)
    local dir = nil
    local nType = math.floor(((math.floor(fAngle + 22.5)) % 360 ) / 45.0)

    if nType == 2 then
        return ANMATION_DIR.UP
    end

    if nType == 6 then
        return ANMATION_DIR.DOWN
    end

    if nType == 0 then
        return ANMATION_DIR.RIGHT
    end

    if nType == 4 then
        return ANMATION_DIR.LEFT
    end

    if nType == 1 or nType == 2 then
        dir = ANMATION_DIR.RIGHT_UP
    elseif nType == 3 then
        dir = ANMATION_DIR.LEFT_UP
    elseif nType == 4 or nType == 5 or nType == 6 then
        dir = ANMATION_DIR.LEFT_DOWN
    elseif nType == 0 or nType == 7 then
        dir = ANMATION_DIR.RIGHT_DOWN
    else
       dir = ANMATION_DIR.RIGHT_DOWN
    end

    return dir
end

--获取两点间的角度
--startPos 起始位置
--targetPos 目标位置
function BattleCommon:getTwoPosAngle(startPos,targetPos)
    local lenghtX = targetPos.x - startPos.x
    local lenghtY = targetPos.y - startPos.y
    local lenght = math.sqrt(lenghtX * lenghtX + lenghtY * lenghtY)

    local pointX = lenghtX / lenght
    local pointY = lenghtY / lenght

    local angle_X = math.acos(pointX) * 180 / math.pi
    local angle_Y = math.acos(pointY) * 180 / math.pi

    local angle = angle_X
    if (angle_Y > 90) then
        angle = 360 - angle_X
    end
    return angle
end

--获取攻击动画持续时间
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(持续时间)
function BattleCommon:getAttAnimationLastTime(hero,atkAnimationIndex)
    local figure = hero.monor
    local lastTime = 0
    if atkAnimationIndex == 1 then
        lastTime = figure:getAtt1AnmationLastTime(figure:getAnimationDir())
    elseif atkAnimationIndex == 2 then
        lastTime = figure:getAtt2AnmationLastTime(figure:getAnimationDir())
    end
    return lastTime
end

--获取攻击特效延迟时间
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(延迟时间)
function BattleCommon:getAttEffectDelayTime(hero,atkAnimationIndex)
    local figure = hero.monor
    local attEffectDelayTime = 0
    if atkAnimationIndex == 1 then
        attEffectDelayTime = figure:getPlayAtt1EffectDelayTime()
    elseif atkAnimationIndex == 2 then
        attEffectDelayTime = figure:getPlayAtt2EffectDelayTime()
    end
    return attEffectDelayTime
end

--获取攻击特效持续时间
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(持续时间)
function BattleCommon:getAttEffectLastTime(hero,atkAnimationIndex)
    local figure = hero.monor
    local attEffectLastTime = 0
    if atkAnimationIndex == 1 then
        attEffectLastTime = figure:getAtt1EffectLastTime()
    elseif atkAnimationIndex == 2 then
        attEffectLastTime = figure:getAtt2EffectLastTime()
    end
    return attEffectLastTime
end

--创建攻击特效动画
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(攻击特效)
function BattleCommon:createAttEffectAnimation(hero,atkAnimationIndex)
    local figure = hero.monor
    local attEffect = nil
    if atkAnimationIndex == 1 then
        attEffect = figure:createAtt1EffectAnmation(figure:getAnimationDir())
    elseif atkAnimationIndex == 2 then
        attEffect = figure:createAtt2EffectAnmation(figure:getAnimationDir())
    end
    return attEffect
end

--获取碰撞检测延迟时间
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(延迟时间)
function BattleCommon:getCheckDelayTime(hero,atkAnimationIndex)
    local figure = hero.monor
    local attCheckDelayTime = 0
    if atkAnimationIndex == 1 then
        attCheckDelayTime = figure:getAtt1DelayCheckTime()
    elseif atkAnimationIndex == 2 then
        attCheckDelayTime = figure:getAtt2DelayCheckTime()
    end
    return attCheckDelayTime
end

--创建弓箭动画特效
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(弓箭动画物效)
function BattleCommon:createArrowAnimationEffect(hero,atkAnimationIndex)
    local figure = hero.monor
    local arrowSprite = nil
    if atkAnimationIndex == 1 then
        arrowSprite = figure:createGongJian1EffectAnmation()
    elseif atkAnimationIndex == 2 then
        arrowSprite = figure:createGongJian2EffectAnmation()
    end
    return arrowSprite
end

--创建受击动画特效
--hero 士兵
--atkAnimationIndex 动画下标
--soldInfoConfig 士兵配置信息
--返回值(受击动画物效)
function BattleCommon:createHurtEffectAnimation(hero,atkAnimationIndex,soldInfoConfig)
    local figure = hero.monor
    local hurtEffect = nil
    if atkAnimationIndex == 1 then
        hurtEffect = figure:createHurt1EffectAnmation(soldInfoConfig.effect)
    elseif atkAnimationIndex == 2 then
        hurtEffect = figure:createHurt2EffectAnmation(soldInfoConfig.effect)
    end
    return hurtEffect
end

--获取受击特效动画持续时间
--hero 士兵
--atkAnimationIndex 动画下标
--soldInfoConfig 士兵配置信息
--返回值(持续时间)
function BattleCommon:getHurtEffectAnimationLastTime(hero,atkAnimationIndex,soldInfoConfig)
    local figure = hero.monor
    local lastTime = 0
    if atkAnimationIndex == 1 then
        lastTime = figure:getHurtEffect1AnimatonLastTime(soldInfoConfig.effect)
    elseif atkAnimationIndex == 2 then
        lastTime = figure:getHurtEffect2AnimatonLastTime(soldInfoConfig.effect)
    end
    return lastTime
end

--获取攻击特效动画大小
--hero 士兵
--返回值(特效大小)
function BattleCommon:getAttEffectAnimationSize(hero,atkAnimationIndex)
    local figure = hero.monor
    local attEffectSize = nil
    if atkAnimationIndex == 1 then
        attEffectSize = figure:getAtt1EffectAnimationSize()
    elseif atkAnimationIndex == 2 then
        attEffectSize = figure:getAtt2EffectAnimationSize()
    end
    return attEffectSize
end

--获取子弹运行速度
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(延迟时间)
function BattleCommon:getFlySpeed(hero,atkAnimationIndex)
    local figure = hero.monor
    local flySpeed = 0
    if atkAnimationIndex == 1 then
        flySpeed = figure:getFlySpped1()
    elseif atkAnimationIndex == 2 then
        flySpeed = figure:getFlySpped2()
    end
    return flySpeed
end

--获取攻击CD时间
--hero 士兵
--atkAnimationIndex 动画下标
--返回值(CD时间)
function BattleCommon:getAttCDTime(hero,atkAnimationIndex)
    local figure = hero.monor
    local cdTime = 0
    if atkAnimationIndex == 1 then
        cdTime = figure:getAtt1CDTime()
    elseif atkAnimationIndex == 2 then
        cdTime = figure:getAtt2CDTime()
    end
    return cdTime
end

--获取子弹特效的角度
--dir 方向
--返回值(角度)
function BattleCommon:getFlyEffectDegree(dir)
    local degree = 0
    if dir == ANMATION_DIR.LEFT_DOWN then
        degree = 135
    elseif dir == ANMATION_DIR.RIGHT_DOWN then
        degree = 45
    elseif dir == ANMATION_DIR.LEFT_UP then
        degree = -135
    elseif dir == ANMATION_DIR.RIGHT_UP then
        degree = -45
    elseif dir == ANMATION_DIR.UP then
        degree = -90
    elseif dir == ANMATION_DIR.DOWN then
        degree = 90
    elseif dir == ANMATION_DIR.LEFT then
        degree = 180
    elseif dir == ANMATION_DIR.RIGHT then
        degree = 0
    end
    return degree
end

--碰撞检测
--atker 攻击方
--atkRect 攻击区
--hurtCamp 受击方阵营
--animationIndex 动画下标
--soldInfoConfig 士兵配置信息
--返回值(无)
function BattleCommon:checkCollision(atker,atkRect,hurtCamp,animationIndex,soldInfoConfig)
    --[[
    local size = cc.size(atkRect.width,atkRect.height)
    local atkLayer = display.newCutomColorLayer(cc.c4b(0,255,0,150),size.width,size.height)
    atkLayer:setContentSize(size)
    local layer = BattleLogic:getInstance():getSoldierLayer()
    layer:addChild(atkLayer,100,200)
    atkLayer:setPosition(atkRect.x, atkRect.y)
    --]]
    local soldierList = HeroMgr:getInstance():getSoldierList(hurtCamp)
    for k,v in pairs(soldierList) do
        if v.hero:getState() ~= AI_STATE.DEATH then
            local beRect = v.hero:getBeRect()
            --[[
            local size = cc.size(beRect.width,beRect.height)
            local beRectLayer = display.newCutomColorLayer(cc.c4b(255,0,0,150),size.width,size.height)
            beRectLayer:setContentSize(size)
            layer:addChild(beRectLayer,100,201)
            beRectLayer:setPosition(beRect.x, beRect.y)
            --]]
            --被击中
            if cc.rectIntersectsRect(atkRect,beRect) then
                --播放受击动画
                if v.hero.soldierType == SOLDIER_TYPE.CASTLE then
                    --todo  城堡受击着火表现
                    return
                end

                if not SceneMgr:isAtCopyMap() then
                    --v.hero:setStateAndDir(AI_STATE.HURT, v.hero:getDir())
                end

                --播放受击特效
                local hurtEffect = self:createHurtEffectAnimation(v.hero,animationIndex,soldInfoConfig)
                v.hero:addChild(hurtEffect)
                hurtEffect:setPosition(0, 0)
                hurtEffect:setScale(BATTLE_CONFIG.SCALE)
                local lastTime =  self:getHurtEffectAnimationLastTime(v.hero,animationIndex,soldInfoConfig)
                local sequence = transition.sequence({
                    cc.DelayTime:create(lastTime),
                    cc.CallFunc:create(function()
                        hurtEffect:removeFromParent()
                        --切回空闲状态
                        if v.hero:getState() ~= AI_STATE.DEATH and not SceneMgr:isAtCopyMap() then
                            v.hero:setStateAndDir(AI_STATE.IDLE, v.hero:getDir())
                        end
                    end),
                })
                hurtEffect:runAction(sequence)
                v.hero:hurt(atker)
                break
            end
        end
    end
end

--设置播放速度
--speed 播放速度
--返回值(无)
function BattleCommon:setSpeed(speed)
    cc.Director:getInstance():getScheduler():setTimeScale(speed)
end



