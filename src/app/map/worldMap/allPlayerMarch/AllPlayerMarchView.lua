

--[[
	jinyan.zhang
	自己的部队行军 
--]]

AllPlayerMarchView = class("AllPlayerMarchView")
local instance = nil

--构造
--返回值(无)
function AllPlayerMarchView:ctor()
	self:init()
end

--初始化
--返回值(无)
function AllPlayerMarchView:init()

end

--获取单例
--返回值(单例)
function AllPlayerMarchView:getInstance()
	if instance == nil then
		instance = AllPlayerMarchView.new()
	end
	return instance
end

--增加行军部队
--data 行军数据
--isLook(true:侦察,false:不是侦察)
--返回值(无)
function AllPlayerMarchView:addMarchArms(data,isLook)
    --计算行军开始位置和结束位置
    local worldMap = MapMgr:getInstance():getWorldMap()
    local marchBeginPos = worldMap:worldGridPosToScreenPos(data.startPos)
    local marchLineTargetPos = worldMap:worldGridPosToScreenPos(data.endPos)
    --移动到目标位置前100像素
    local tmp,newTargetPos = Common:getNextMidPos(100,marchBeginPos,marchLineTargetPos)
    local passTime = Common:getOSTime() - data.leftTime
    passTime = 0
    data.leftTime = data.leftTime - passTime

    --创建行军部队
    if not isLook then
        self:createMarchArms(data,marchBeginPos,newTargetPos,false,marchLineTargetPos,isLook)
    else
        self:createMarchArms(data,marchBeginPos,marchLineTargetPos,false,marchLineTargetPos,isLook)
    end
end

--创建行军部队
--行军数据
--marchBeginPos 开始位置
--marchTargetPos 目标位置
--isReturnCastle 返回城堡标记(true:是返回城堡,false:不是)
--marchLineTargetPos 行军路线目标位置(画行军路线用的)
--isLook(true:侦察,false:不是侦察)
--返回值(无)
function AllPlayerMarchView:createMarchArms(data,marchBeginPos,marchTargetPos,isReturnCastle,marchLineTargetPos,isLook)
    local marchTotalTime = self:calMarchTimeTotalTime(data)

    local dis = cc.pGetDistance(marchTargetPos,marchBeginPos)
    local moveSpeed = dis/marchTotalTime
 
    --计算当前行军部队所在的位置
    local marchPassTime = marchTotalTime - data.leftTime
    local armsCurPos = Common:calPlayerPosByTime(marchBeginPos,marchTargetPos,marchPassTime,moveSpeed)

    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:createArms(marchBeginPos,marchTargetPos,moveSpeed,data.arms,data.id_h,data.id_l,armsCurPos,data.endPos,isReturnCastle,marchLineTargetPos,isLook,true)
end

--部队行军返回
--data 行军数据
--isLook(true:侦察,false:不是侦察)
--返回值(无)
function AllPlayerMarchView:AllPlayerMarchViewReturn(data,isLook)
    --删除行军UI表现
    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:removeMarchUI(data.id_h,data.id_l)

    local marchBeginPos = worldMap:worldGridPosToScreenPos(data.endPos)
    local marchTargetPos = worldMap:worldGridPosToScreenPos(data.startPos)
    self:createMarchArms(data,marchBeginPos,marchTargetPos,true,marchTargetPos,isLook)
end

--播放行军攻击动画
--data 行军数据
--返回值(无)
function AllPlayerMarchView:playMarchAttAnimation(data)
    --计算行军攻击动画播放时间
    local playAttTime = 0
    local leftMarchTime = data.leftTime
    if leftMarchTime <= 0 then
        playAttTime = 0
    elseif leftMarchTime <= 3 then
        playAttTime = 1
    elseif leftMarchTime >= 10 then
        playAttTime = 5
    elseif leftMarchTime > 3 and leftMarchTime <= 5 then
        playAttTime = 2
    else
        playAttTime = 3
    end

    --删除行军
    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:removeMarchLine(data.id_h,data.id_l)

    data.leftTime = self:calMarchTimeTotalTime(data) - playAttTime

    --行军返回剩余时间为0,就不放攻击动画了
    if playAttTime <= 0 then
        self:AllPlayerMarchViewReturn(data,false)
        return
    end

    --播放攻击动画一段时间后，部队返回到城堡
    local sequence = transition.sequence({
        cc.DelayTime:create(playAttTime),
        cc.CallFunc:create(function()
            self:AllPlayerMarchViewReturn(data,false)
        end),
    })
    local layer = SceneMgr:getInstance():getUILayer()
    layer:runAction(sequence)
end

--行军返回
--data 数据
--返回值(无)
function AllPlayerMarchView:marchReturnResult(data)
    --行军到达目地后的UI表现
    if data.state == MarchState.back then  --行军返回中
        if data.type == OTHER_MARCH_OPTION_TYPE.attack then --行军到达目的后执行一下攻击动作
            --todo 播放攻击动画
            self:updateMarchProcess(data)
            self:playMarchAttAnimation(data)
        elseif data.type == OTHER_MARCH_OPTION_TYPE.reconnaissance then --行军到达目的后执行侦察动作
            --todo
            data.leftTime = self:calMarchTimeTotalTime(data)
            self:updateMarchProcess(data)
            self:AllPlayerMarchViewReturn(data,true)
        elseif data.type == OTHER_MARCH_OPTION_TYPE.RESOURCE_HELP then  --行军到达目的地后资源援助
            --todo
        elseif data.type == OTHER_MARCH_OPTION_TYPE.SOLDIER_HELP then  --行军到达目的地后士兵援助
        	--todo
        end
    elseif data.state == MarchState.stationed then  --驻扎
        self:removeMarchProcess(data)
    elseif data.state == MarchState.together then --集结
        --todo
    end
end

--时间到了,删除行军进度
--data 数据
--返回值(无)
function AllPlayerMarchView:removeMarchProcess(data)
	local info = {}
	info.index = data.id_h
	TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.OTHER_PLAYER_MARCH_TIME,info.index,data.id_l)
end

--更新行军进度信息
--data 数据
--返回值(无)
function AllPlayerMarchView:updateMarchProcess(data)
    --计算行军剩余时间
    local info = {}
    info.index = data.id_h
    info.data = data
    info.leftMarchTime = data.leftTime

    --把部队行军定时信息加入定时器中计时
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.OTHER_PLAYER_MARCH_TIME,info.index,data.id_l)
    TimeMgr:getInstance():addInfo(TimeType.OTHER_PLAYER_MARCH_TIME, info, data.id_l,self.marchTimeHandler, self)
end

--计算行军总时间
--data 数据
--返回值(行军总时间)
function AllPlayerMarchView:calMarchTimeTotalTime(data)
    local dis = Common:calMarchDis(data.startPos,data.endPos)
    local time = dis/data.moveSpeed
    return math.floor(time)
end

--行军定时器回调(每秒)
--info 行军信息
--返回值(无)
function AllPlayerMarchView:marchTimeHandler(info)
    info.leftMarchTime = info.leftMarchTime - 1
    if info.leftMarchTime <= 0 then
        info.leftMarchTime = 0
        if info.data.state == MarchState.marching then --行军中
        	info.data.state = MarchState.back
            self:removeMarchProcess(info.data)
            self:marchReturnResult(info.data)
        elseif info.data.state == MarchState.back then --行军返回
        	self:finishMarchingResult(info.data)
        end
    end
end

--完成行军结果
--data 数据
--返回值(无)
function AllPlayerMarchView:finishMarchingResult(data)
    self:removeMarchProcess(data)
    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:removeMarchUI(data.id_h,data.id_l)
end

--更新世界地图上的行军部队
--返回值(无)
function AllPlayerMarchView:updateWorldMapMarchArms()
	local data = AllPlayerMarchModel:getInstance():getData()
	if #data == 0 then
		return
	end

    for k,v in pairs(data) do
        if v.state == MarchState.marching then --行军
            self:updateMarchProcess(v)
            if v.type == OTHER_MARCH_OPTION_TYPE.reconnaissance then
                self:addMarchArms(v,true)
            else
                self:addMarchArms(v,false)
            end
        elseif v.state == MarchState.back then --行军返回
            self:updateMarchProcess(v)
            if v.type == OTHER_MARCH_OPTION_TYPE.reconnaissance then
                self:AllPlayerMarchViewReturn(v,true)
            else
                self:AllPlayerMarchViewReturn(v,false)
            end
        elseif v.state == MarchState.stationed then  --驻扎
        	--todo
        elseif v.state == MarchState.together then --集结
            --todo
        end
    end
end









