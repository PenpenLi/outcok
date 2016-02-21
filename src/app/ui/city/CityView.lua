
--[[
	jinyan.zhang
	城内界面
--]]

CityView = class("CityView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function CityView:ctor(uiType,data)
	self.data = data
	self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function CityView:init()
    self.root = Common:loadUIJson(CITY_HEAD)
    self:addChild(self.root)

    --头像
    self.handBtn = Common:seekNodeByName(self.root,"handBtn")
    self.handBtn:addTouchEventListener(handler(self,CityView.onhandBtn))

    --等级
    self.gradeLab = Common:seekNodeByName(self.root,"gradeLab")
    self.gradeLab:setString(PlayerData:getInstance().level)

    --木
    self.woodLab = Common:seekNodeByName(self.root,"woodLab")
    self.woodLab:setString(Common:getCompany(PlayerData:getInstance().wood))
    self.woodImg = Common:seekNodeByName(self.root,"foodImg")

    --粮
    self.foodLab = Common:seekNodeByName(self.root,"foodLab")
    self.foodLab:setString(Common:getCompany(PlayerData:getInstance():getFood()))
    self.foodImg = Common:seekNodeByName(self.root,"woodImg")

    --矿石
    self.ironLab = Common:seekNodeByName(self.root,"ironLab")
    self.ironLab:setString(Common:getCompany(PlayerData:getInstance().iron))
    self.ironImg = Common:seekNodeByName(self.root,"ironImg")

    --秘银
    self.mithrilLab = Common:seekNodeByName(self.root,"mithrilLab")
    self.mithrilLab:setString(Common:getCompany(PlayerData:getInstance().mithril))
    self.mithrilImg = Common:seekNodeByName(self.root,"mithrilImg")

    --战力
    self.aggressivityLab = Common:seekNodeByName(self.root,"aggressivityLab")
    self.aggressivityLab:setString(PlayerData:getInstance().fightforce)

    --金币
    self.moneyBtn = Common:seekNodeByName(self.root,"moneyBtn")
    self.moneyBtn:addTouchEventListener(handler(self,CityView.onMoneyBtn))

    self.moneyLab = Common:seekNodeByName(self.root,"moneyLab")
    self.moneyLab:setString(PlayerData:getInstance().gold)

    --地图
    self.outCityBtn = Common:seekNodeByName(self.root,"mapBtn")
    self.outCityBtn:addTouchEventListener(handler(self,CityView.outCityCallback))

    --任务
    self.taskBtn = Common:seekNodeByName(self.root,"taskBtn")
    self.taskBtn:addTouchEventListener(handler(self,CityView.onTaskBtn))

    --物品
    self.goodsBtn = Common:seekNodeByName(self.root,"goodsBtn")
    self.goodsBtn:addTouchEventListener(handler(self,CityView.onGoodsBtn))

    --邮件
    self.mailBtn = Common:seekNodeByName(self.root,"mailBtn")
    self.mailBtn:addTouchEventListener(handler(self,CityView.onMailBtn))

    --联盟
    self.allianceBtn = Common:seekNodeByName(self.root,"allianceBtn")
    self.allianceBtn:addTouchEventListener(handler(self,CityView.onAllianceBtn))

    --技能
    self.btn_skill = Common:seekNodeByName(self.root,"btn_skill")
    self.btn_skill:addTouchEventListener(handler(self,CityView.onSkill))

    --副本
    self.btn_instance = Common:seekNodeByName(self.root,"btn_instance")
    self.btn_instance:addTouchEventListener(handler(self,CityView.instanceCallback))

    --邮件数量
    self.mailNumLab = Common:seekNodeByName(self.root,"mailnumlab")

    --第一个锤子
    self.firstHammerBtn = Common:seekNodeByName(self.root,"queueBtn")
    self.firstHammerBtn:addTouchEventListener(handler(self,self.firstHammerCallback))
    self.firstBuildingTimeLab = Common:seekNodeByName(self.firstHammerBtn,"queueLab")

    --第二个锤子
    self.secondHammerBtn = Common:seekNodeByName(self.root,"goldQueueBtn")
    self.secondHammerBtn:addTouchEventListener(handler(self,self.secondHammerCallback))
    self.secondBuildingTimeLab = Common:seekNodeByName(self.firstHammerBtn,"goldqueueLab")
end

--第一个锤子点击回调
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:firstHammerCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then

    end
end

--更新第一个锤子的建筑时间
--info 数据
--返回值(无)
function CityView:updateFirstBuildingTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime <= 0 then
        info.leftTime = 0
    end
    self.firstBuildingTimeLab:setVisible(true)
    self.firstBuildingTimeLab:setString(Common:getFormatTime(info.leftTime))
end

--创建第一个锤子的建造时间
--leftTime 剩余建造时间
--返回值(无)
function CityView:createFirstHammerBuildTime(leftTime)
    self:delHammerIdleAnmation()
    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.HAMMER_BUILDING_TIME,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.HAMMER_BUILDING_TIME, info, 1,self.updateFirstBuildingTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--删除第一个锤子的建造时间
--返回值(无)
function CityView:delFirstHammerBuildTime()
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.HAMMER_BUILDING_TIME,1,1)
    self.firstBuildingTimeLab:setVisible(false)
    self:createFirstHammerIdleAnmation()
end

--创建第一个锤子的空闲动画
--返回值(锤子)
function CityView:createFirstHammerIdleAnmation()
    if self.hammerIdleAnm ~= nil then
        self.hammerIdleAnm:setVisible(true)
    else
        local sprite = display.newSprite("test/RadioButtonOn.png")
        -- local sequence = transition.sequence({
        --     cc.MoveBy:create(1,cc.p(50,100))
        --     cc.CallFunc:create(function()
        --     end),
        --     cc.DelayTime:create(2),
        -- })
        -- self:runAction(sequence)
    end
end

--删除锤子空闲动画
--返回值(无)
function CityView:delHammerIdleAnmation()
    if self.hammerIdleAnm ~= nil then
        self.hammerIdleAnm:setVisible(false)
    end
end

--第二个锤子点击回调
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:secondHammerCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        --BuildingAccelerationService:sendTestMsg()
    end
end

--更新UI
function CityView:updateUI()
    self.woodLab:setString(Common:getCompany(PlayerData:getInstance().wood))
    self.foodLab:setString(Common:getCompany(PlayerData:getInstance():getFood()))
    self.ironLab:setString(Common:getCompany(PlayerData:getInstance().iron))
    self.mithrilLab:setString(Common:getCompany(PlayerData:getInstance().mithril))
    self.aggressivityLab:setString("" .. PlayerData:getInstance().fightforce)
    self.moneyLab:setString(Common:getCompany(PlayerData:getInstance().gold))
end

--更新战斗力
function CityView:updateBattlePower()
    self.aggressivityLab:setString("" .. PlayerData:getInstance().fightforce)
end

--更新粮食UI
function CityView:updateFoodUI()
    self.foodLab:setString(Common:getCompany(PlayerData:getInstance():getFood()))
end

--更新物质
--info 配置信息
function CityView:updateBymakeSoldier(info,number)
    local playerData = PlayerData:getInstance()
    --木材
    playerData:setPlayerWood(info.aa_wood * number)
    self.woodLab:setString(Common:getCompany(playerData.wood))
    --粮食
    playerData:setPlayerFood(info.aa_grain * number)
    self.foodLab:setString(Common:getCompany(playerData:getFood()))
    --矿石
    playerData:setPlayerIron(info.aa_iron * number)
    self.ironLab:setString(Common:getCompany(playerData.iron))
    --秘银
    playerData:setPlayerMithril(info.aa_mithril * number)
    self.mithrilLab:setString(Common:getCompany(playerData.mithril))
end

--更新邮件数量
--num 数量
--返回值(无)
function CityView:updateMailNum(num)
    if num == 0 then
        self.mailNumLab:setString("")
    else
        self.mailNumLab:setString("" .. num)
    end
end

--开关按钮触摸
--able(true:开启,false:关闭)
function CityView:setBtnTouchAble(able)
    self.handBtn:setTouchEnabled(able)
    self.moneyBtn:setTouchEnabled(able)
    self.outCityBtn:setTouchEnabled(able)
    self.taskBtn:setTouchEnabled(able)
    self.goodsBtn:setTouchEnabled(able)
    self.mailBtn:setTouchEnabled(able)
    self.allianceBtn:setTouchEnabled(able)
    self.firstHammerBtn:setTouchEnabled(able)
    self.secondHammerBtn:setTouchEnabled(able)
    self.btn_skill:setTouchEnabled(able)
end

--出城按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:outCityCallback(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        MyLog("outCity click...")
        SceneMgr:getInstance():goToWorld()
    end
end

--头像按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:onhandBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.LORD)
    end
end

--金币按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:onMoneyBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("金币")
    end
end

--任务按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:onTaskBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("任务")
        --UIMgr:getInstance():openUI(UITYPE.AGGREGATION_CITY)
    end
end

--物品按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:onGoodsBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BAG)
    end
end

--邮件按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:onMailBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("邮件")
        UIMgr:getInstance():openUI(UITYPE.CITY_BUILD_MAIL)
    end
end

--联盟按钮回调函数
--sender 出地按钮本身
--eventType 事件类型
--返回值(无)
function CityView:onAllianceBtn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("联盟")
        --UIMgr:getInstance():openUI(UITYPE.INSTANCE_BATTLE_CITY)
    end
end

--副本按钮回调
--返回值(无)
function CityView:instanceCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- UIMgr:getInstance():openUI(UITYPE.INSTANCE_CITY, {building=self.data.building})
        -- UIMgr:getInstance():closeUI(self.uiType)
        UIMgr:getInstance():openUI(UITYPE.INSTANCE_CITY)
    end
end

--技能按钮回调函数
--返回值(无)
function CityView:onSkill(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 科技界面
        self.lordSkillView = LordSkillView.new()
        -- 添加
        self:addChild(self.lordSkillView)
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function CityView:onEnter()
	--MyLog("CityView onEnter...")
	self:setTouchAble(false)
    local num = MailsModel:getInstance():getUnReadMailCount()
    self:updateMailNum(num)

    --迁城
    if MoveCastleAniModel:getInstance():isNeedMoveCastle() then
        UIMgr:getInstance():openUI(UITYPE.MOVE_CASTLE)
    end
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function CityView:onExit()
	--MyLog("CityView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function CityView:onDestroy()
	--MyLog("--CityView:onDestroy")
end





