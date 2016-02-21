
--[[
	jinyan.zhang
	城外界面
--]]

CityOutView = class("CityOutView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function CityOutView:ctor(uiType,data)
	self.data = data
    self.maxMarchArmsCount = 5  --最大行军队伍数
    self.marchProcessList = {}      --行军进度列表
	self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function CityOutView:init()
    self.root = Common:loadUIJson(CITYOUT_HEAD)
    self:addChild(self.root)
    --pan1
    self.pan1 = Common:seekNodeByName(self.root,"Panel_1")
    --头像
    self.handBtn = Common:seekNodeByName(self.root,"handBtn")
    self.handBtn:addTouchEventListener(handler(self,CityOutView.onhandBtn))

    --等级
    self.gradeLab = Common:seekNodeByName(self.root,"gradeLab")
    self.gradeLab:setString(PlayerData:getInstance().level)

    --木
    self.woodLab = Common:seekNodeByName(self.root,"woodLab")
    self.woodLab:setString(Common:getCompany(PlayerData:getInstance().wood))

    --粮
    self.foodLab = Common:seekNodeByName(self.root,"foodLab")
    self.foodLab:setString(Common:getCompany(PlayerData:getInstance():getFood()))

    --矿石
    self.ironLab = Common:seekNodeByName(self.root,"ironLab")
    self.ironLab:setString(Common:getCompany(PlayerData:getInstance().iron))

    --秘银
    self.mithrilLab = Common:seekNodeByName(self.root,"silverLab")
    self.mithrilLab:setString(Common:getCompany(PlayerData:getInstance().mithril))

    --战力
    self.aggressivityLab = Common:seekNodeByName(self.root,"aggressivityLab")
    self.aggressivityLab:setString(PlayerData:getInstance().fightforce)

    --物品
    self.goodsBtn = Common:seekNodeByName(self.root,"goodsBtn")
    self.goodsBtn:addTouchEventListener(handler(self,CityView.onGoodsBtn))

    --金币
    self.moneyBtn = Common:seekNodeByName(self.root,"moneyBtn")
    self.moneyBtn:addTouchEventListener(handler(self,CityOutView.onMoneyBtn))

    self.moneyLab = Common:seekNodeByName(self.root,"moneyLab")
    self.moneyLab:setString(PlayerData:getInstance().gold)

    --技能
    self.btn_skill = Common:seekNodeByName(self.root,"btn_skill")
    self.btn_skill:addTouchEventListener(handler(self,self.onSkill))

    --领地
    self.btnTerritory = Common:seekNodeByName(self.root,"btn_resources")
    self.btnTerritory:addTouchEventListener(handler(self,self.onTerritory))

   	--进入城内按钮
    self.cityBtn = Common:seekNodeByName(self.root,"mapBtn")
    self.cityBtn:addTouchEventListener(handler(self,self.enterCityCallback))

    --选择坐标按钮
    self.coordinateBtn = Common:seekNodeByName(self.root,"coordinateBtn")
    self.coordinateBtn:addTouchEventListener(handler(self,self.coordinateBtnCallback))

    --前往按钮
    self.DetermineBtn = Common:seekNodeByName(self.root,"DetermineBtn")
    self.DetermineBtn:addTouchEventListener(handler(self,self.DetermineBtnCallback))

    --前往坐标
    self.Coordinate = Common:seekNodeByName(self.root,"Panel_2")

    --左侧行军面板
    self.marchPan = Common:seekNodeByName(self.root,"Panel_3")
    self.marchPan:setTouchEnabled(false)
    self.marchPan:setVisible(true)

    self.marchProcessNameList = {}
    for i=1,self.maxMarchArmsCount do
        self.marchProcessNameList[i] = {}
        self.marchProcessNameList[i].panBgName = "img_ui" .. i
        self.marchProcessNameList[i].processName = "ProgressBar" .. i
        self.marchProcessNameList[i].coorderName = "coordinateLab" .. i
        self.marchProcessNameList[i].timeName = "timeLab" .. i
        self.marchProcessNameList[i].speedBtnName = "accelerationBtn" .. i
        self.marchProcessNameList[i].isEmpty = true
        self.marchProcessNameList[i].index = i
        local panBgImg = Common:seekNodeByName(self.root,self.marchProcessNameList[i].panBgName)
        panBgImg:setVisible(false)
    end

    --行军列表
    local marchList = PlayerMarchModel:getInstance():getData()
    for k,v in pairs(marchList) do
        if v.status == MarchState.marching then --行军
            self:updateMarchProcess(v)
            if v.type == MarchOperationType.reconnaissance then
                self:addMarchArms(v,true)
            else
                self:addMarchArms(v,false)
            end
        elseif v.status == MarchState.back then --行军返回
            self:updateMarchProcess(v)
            if v.type == MarchOperationType.reconnaissance then
                self:armsMarchReturn(v,true)
            else
                self:armsMarchReturn(v,false)
            end
        elseif v.status == MarchState.stationed then  --驻扎
            self:addStatedArms(v)
        elseif v.status == MarchState.together then --集结
            --todo
        end
    end

    --邮件
    self.mailBtn = Common:seekNodeByName(self.root,"mailBtn")
    self.mailBtn:addTouchEventListener(handler(self,self.onMailBtn))
    --邮件数量
    self.mailNumLab = Common:seekNodeByName(self.root,"mailnumlab")
end

--领地按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:onTerritory(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.TERRITORY)
    end
end

--更新战斗力
function CityOutView:updateBattlePower()
    self.aggressivityLab:setString("" .. PlayerData:getInstance().fightforce)
end

--更新UI
function CityOutView:updateUI()
    self.woodLab:setString(Common:getCompany(PlayerData:getInstance().wood))
    self.foodLab:setString(Common:getCompany(PlayerData:getInstance():getFood()))
    self.ironLab:setString(Common:getCompany(PlayerData:getInstance().iron))
    self.mithrilLab:setString(Common:getCompany(PlayerData:getInstance().mithril))
    self.aggressivityLab:setString("" .. PlayerData:getInstance().fightforce)
    self.moneyLab:setString(Common:getCompany(PlayerData:getInstance().gold))
end

--更新粮食UI
function CityOutView:updateFoodUI()
    self.foodLab:setString(Common:getCompany(PlayerData:getInstance():getFood()))
end

--头像按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:onhandBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.LORD)
    end
end

--金币按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:onMoneyBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("金币")
    end
end

--开关按钮触摸
--able(true:开启,false:关闭)
function CityOutView:setBtnTouchAble(able)
    self.cityBtn:setTouchEnabled(able)
    self.coordinateBtn:setTouchEnabled(able)
    self.DetermineBtn:setTouchEnabled(able)
    self.mailBtn:setTouchEnabled(able)
end

--邮件按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:onMailBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("邮件")
        UIMgr:getInstance():openUI(UITYPE.CITY_BUILD_MAIL)
    end
end

--物品按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:onGoodsBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BAG)
    end
end

--更新邮件数量
--num 数量
--返回值(无)
function CityOutView:updateMailNum(num)
    if num == 0 then
        self.mailNumLab:setString("")
    else
        self.mailNumLab:setString("" .. num)
    end
end

--技能按钮回调函数
--返回值(无)
function CityOutView:onSkill(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 科技界面
        self.lordSkillView = LordSkillView.new()
        -- 添加
        self:addChild(self.lordSkillView)
    end
end

--添加驻扎队伍
--data 部队数据
--返回值(无)
function CityOutView:addStatedArms(data)
    --todo
end

--时间到了，删除行军进条面板
--id_h
--id_l
--返回值(无)
function CityOutView:removeMarchProcess(id_h,id_l)
    for k,v in pairs(self.marchProcessList) do
        if id_h == v.id_h and id_l == v.id_l then
            v.marchPanBg:setVisible(false)
            self.marchProcessNameList[v.processIndex].isEmpty = true
            table.remove(self.marchProcessList,k)
            break
        end
    end
end

--行军返回
--data 数据
--marchArmsInfo 行军中的部队信息
--返回值(无)
function CityOutView:marchReturnResult(marchArmsInfo)
    --行军到达目地后的UI表现
    if marchArmsInfo.status == MarchState.back then  --行军返回中
        self:updateMarchProcess(marchArmsInfo)
        if marchArmsInfo.type == MarchOperationType.attack then --行军到达目的后执行一下攻击动作
            --todo 播放攻击动画
            self:playMarchAttAnimation(marchArmsInfo)
        elseif marchArmsInfo.type == MarchOperationType.reconnaissance then --行军到达目的后执行侦察动作
            --todo
            self:armsMarchReturn(marchArmsInfo,true)
        elseif marchArmsInfo.type == MarchOperationType.collection then  --行军到达目的地后采集资源
            --todo
        end
    elseif marchArmsInfo.status == MarchState.stationed then  --驻扎
        self:removeMarchProcess(marchArmsInfo.marchArmsId.id_h,marchArmsInfo.marchArmsId.id_l)
    elseif marchArmsInfo.status == MarchState.together then --集结
        --todo
    end
end

--更新行军进度信息
--data 数据
--返回值(无)
function CityOutView:updateMarchProcess(data)
    --计算行军剩余时间
    local info = {}
    info.index = data.id_h
    info.data = data
    info.marchTimeInfo = TimeInfoData:getInstance():getTimeInfoById(data.timeoutid_h,data.timeoutid_l)
    info.leftMarchTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(info.marchTimeInfo.start_time,info.marchTimeInfo.interval)

    --更新行军进度条
    local processInfo = self:getEmptyProcessInfo(data.processIndex)
    processInfo.isEmpty = false
    data.processIndex = processInfo.index
    info.processIndex = processInfo.index
    info.marchPanBg = Common:seekNodeByName(self.root,processInfo.panBgName)
    info.marchPanBg:setVisible(true)
    info.processCtrl = Common:seekNodeByName(self.root,processInfo.processName)
    info.timeLab = Common:seekNodeByName(self.root,processInfo.timeName)
    info.coorderLab = Common:seekNodeByName(self.root,processInfo.coorderName)
    info.speedBtn = Common:seekNodeByName(self.root,processInfo.speedBtnName)
    self:updateProcess(info)

    --把部队行军定时信息加入定时器中计时
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.MARCH,info.index,data.id_l)
    TimeMgr:getInstance():addInfo(TimeType.MARCH, info, data.id_l,self.marchTimeHandler, self)

    --保存行军进度数据
    for k,v in pairs(self.marchProcessList) do
        if data.id_h == v.id_h and data.id_l == v.id_l then
            table.remove(self.marchProcessList,k)
            break
        end
    end
    info.id_h = data.id_h
    info.id_l = data.id_l
    table.insert(self.marchProcessList,info)

    --UI更新行军目标位置
    if data.status == MarchState.back then  --行军返回
        info.coorderLab:setVisible(false)
        info.speedBtn:setTitleText(CommonStr.RETURN)
    elseif data.status == MarchState.marching then --行军中
        info.coorderLab:setVisible(true)
        info.speedBtn:setTitleText(CommonStr.ACC_SPEED)
        local marchTargetPos = MapMgr:getInstance():getWorldMap():worldGridPosToScreenPos(cc.p(data.posx,data.posy))
        info.coorderLab:setString(CommonStr.DAO .. " x:" .. data.posx .. " y:" .. data.posy)
    end
end

--增加行军部队
--data 行军数据
--isLook(true:侦察,false:不是侦察)
--返回值(无)
function CityOutView:addMarchArms(data,isLook)
    --计算行军开始位置和结束位置
    local worldMap = MapMgr:getInstance():getWorldMap()
    local marchBeginPos = worldMap:getPlayerCastlePos()
    local marchLineTargetPos = worldMap:worldGridPosToScreenPos(cc.p(data.posx,data.posy))
    --移动到目标位置前100像素
    local tmp,newTargetPos = Common:getNextMidPos(100,marchBeginPos,marchLineTargetPos)

    --创建行军部队
    if not isLook then
        self:createMarchArms(data,marchBeginPos,newTargetPos,false,marchLineTargetPos,isLook)
    else
        self:createMarchArms(data,marchBeginPos,marchLineTargetPos,false,marchLineTargetPos,isLook)
    end
end

--部队行军返回
--data 行军数据
--isLook(true:侦察,false:不是侦察)
--返回值(无)
function CityOutView:armsMarchReturn(data,isLook)
    --删除行军UI表现
    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:removeMarchUI(data.id_h,data.id_l)

    local marchBeginPos = worldMap:worldGridPosToScreenPos(cc.p(data.posx,data.posy))
    local marchTargetPos = worldMap:getPlayerCastlePos()
    self:createMarchArms(data,marchBeginPos,marchTargetPos,true,marchTargetPos,isLook)
end

--创建行军部队
--行军数据
--marchBeginPos 开始位置
--marchTargetPos 目标位置
--isReturnCastle 返回城堡标记(true:是返回城堡,false:不是)
--marchLineTargetPos 行军路线目标位置(画行军路线用的)
--isLook(true:侦察,false:不是侦察)
--返回值(无)
function CityOutView:createMarchArms(data,marchBeginPos,marchTargetPos,isReturnCastle,marchLineTargetPos,isLook)
    local marchTimeInfo = TimeInfoData:getInstance():getTimeInfoById(data.timeoutid_h,data.timeoutid_l)
    local dis = cc.pGetDistance(marchTargetPos,marchBeginPos)
    local moveSpeed = dis/marchTimeInfo.interval
    if not isReturnCastle then
        --print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
        --print("marchTimeInfo totalTime=",marchTimeInfo.interval,"dis=",dis,"speed=",moveSpeed)
        --print("marchBeginPos.x=",marchBeginPos.x,"marchTargetPos.y=",marchTargetPos.y)
    end

    --计算当前行军部队所在的位置
    local leftMarchTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(marchTimeInfo.start_time,marchTimeInfo.interval)
    if leftMarchTime <= 0 then
        leftMarchTime = 1
    end

    local marchPassTime = marchTimeInfo.interval - leftMarchTime
    local armsCurPos = Common:calPlayerPosByTime(marchBeginPos,marchTargetPos,marchPassTime,moveSpeed)

    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:createArms(marchBeginPos,marchTargetPos,moveSpeed,data.arms,data.id_h,data.id_l,armsCurPos,cc.p(data.posx,data.posy),isReturnCastle,marchLineTargetPos,isLook,false)
end

--播放行军攻击动画
--data 行军数据
--返回值(无)
function CityOutView:playMarchAttAnimation(data)
    --计算行军攻击动画播放时间
    local playAttTime = 0
    local marchTimeInfo = TimeInfoData:getInstance():getTimeInfoById(data.timeoutid_h,data.timeoutid_l)
    local leftMarchTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(marchTimeInfo.start_time,marchTimeInfo.interval)
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

    --行军返回剩余时间为0,就不放攻击动画了
    if leftMarchTime <= 1 or not worldMap:isHaveCreateMarchArms(data.id_h,data.id_l) then
        self:armsMarchReturn(data,false)
        return
    end

    --播放攻击动画一段时间后，部队返回到城堡
    local sequence = transition.sequence({
        cc.DelayTime:create(playAttTime),
        cc.CallFunc:create(function()
            self:armsMarchReturn(data,false)
        end),
    })
    self:runAction(sequence)
end

--完成行军结果
--data 数据
--返回值(无)
function CityOutView:finishMarchingResult(data)
    self:removeMarchProcess(data.id_h,data.id_l)
    local worldMap = MapMgr:getInstance():getWorldMap()
    worldMap:removeMarchUI(data.id_h,data.id_l)
end

--获取一个空的进度条信息
--index 下标
--返回值(进度条信息)
function CityOutView:getEmptyProcessInfo(index)
    for k,v in pairs(self.marchProcessNameList) do
        if v.index == index then
            return v
        end
    end

    for i=1,self.maxMarchArmsCount do
        if self.marchProcessNameList[i].isEmpty then
            return self.marchProcessNameList[i]
        end
    end
end

--行军定时器回调(每秒)
--info 行军信息
--返回值(无)
function CityOutView:marchTimeHandler(info)
    info.leftMarchTime = info.leftMarchTime - 1
    if info.leftMarchTime <= 0 then
        info.leftMarchTime = 0
    end
    --todo 刷新进度
    self:updateProcess(info)
end

--刷新进度
--info 信息
--返回值(无)
function CityOutView:updateProcess(info)
    local passTime = Common:getOSTime() - info.marchTimeInfo.start_time
    if passTime > info.marchTimeInfo.interval then
        passTime = info.marchTimeInfo.interval
    end
    local per = (passTime/info.marchTimeInfo.interval)*100
    info.processCtrl:setPercent(per)
    local time = Common:getFormatTime(info.leftMarchTime)
    info.timeLab:setString(time)
end

--坐标按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:coordinateBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Coordinate:setVisible(true)
    end
end

--前往按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:DetermineBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Coordinate:setVisible(false)
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function CityOutView:onEnter()
	--MyLog("CityOutView onEnter...")
    local num = MailsModel:getInstance():getUnReadMailCount()
    self:updateMailNum(num)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function CityOutView:onExit()
	--MyLog("CityOutView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function CityOutView:onDestroy()
	--MyLog("CityOutView:onDestroy")
end

--进入城内按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityOutView:enterCityCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	SceneMgr:getInstance():goToCity()
    end
end



