
--[[
	jinyan.zhang
	解锁区域
--]]

UnLockArea = class("UnLockArea")

local areaConfig = {}
areaConfig[1] = {path="citybuilding/lock-trees1.png",pos=cc.p(2774,1394),index=1}
areaConfig[2] = {path="citybuilding/lock-trees2.png",pos=cc.p(2822,784),index=2}
areaConfig[3] = {path="citybuilding/lock-trees3.png",pos=cc.p(2622,500),index=3}
areaConfig[4] = {path="citybuilding/lock-trees4.png",pos=cc.p(1600,530),index=4}

function UnLockArea:ctor(parent)
	self.parent = parent
	self:init()
end

function UnLockArea:init()
	self.data = {}
	for i=1,4 do
		self.data[i] = {}
		self.data[i].areaImg = nil
	end	
	self:updateUI()
end

function UnLockArea:updateUI()
	local list = UnLockAreaModel:getInstance():getUnLockList()
	for k,v in pairs(list) do
		local config = areaConfig[k]
		if not v.unLock then
			self:createArea(config.path,config.pos,config.index)
			self:setFloorVis(config.index,false)
		else
			self:delAreaImg(config.index)
			self:setFloorVis(config.index,true)
		end
	end
end

function UnLockArea:setFloorVis(index,vis)
	local list = LandUnLockConfig:getInstance():getUnLockAreaByIndex(index)	
	for k,v in pairs(list) do
		for k,floor in pairs(self.parent.floorList) do
			if floor:getTag() == v then
				floor:setVisible(vis)
				break
			end
		end
	end
end

--删除解锁区域图片
function UnLockArea:delAreaImg(index)
	if self.data[index].areaImg ~= nil then
		self.data[index].areaImg:removeFromParent()
		self.data[index].areaImg = nil
	end
end

--创建解锁区域图片
function UnLockArea:createArea(path,pos,index)
	if self.data[index].areaImg ~= nil then
		return
	end

	local area = display.newSprite(path)
	self.parent:addChild(area)
	area:setPosition(pos)
	self.data[index].areaImg = area

	local size = area:getContentSize()
	size.width = size.width*0.7
	size.height = size.height*0.7
	local checkRect = {x=area:getContentSize().width/2-size.width/2,y=area:getContentSize().height/2-size.height/2,wide=size.width,high=size.height}
	local size = cc.size(checkRect.wide,checkRect.high)
	local checkRectLayer = display.newCutomColorLayer(cc.c4b(255,255,0,0),size.width,size.height)
	checkRectLayer:setContentSize(size)
	area:addChild(checkRectLayer)
	checkRectLayer:setTag(index)
	checkRectLayer:setPosition(checkRect.x, checkRect.y)
	self:setTouchAble(true,checkRectLayer)
end

--使能/禁止触摸
--able 使能(true:使能,false:禁止)
--node 目标结点
--返回值(无)
function UnLockArea:setTouchAble(able,node)
	node:setTouchEnabled(able)
	if able == true then
		node:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
		node:setTouchSwallowEnabled(false)
	    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	        if event.name == "began" then
	        	self:touchBegin(event,node)
	        	self.isCanClick = true
	        elseif event.name == "moved" then
	           self:touchMove(event,node)
	        elseif event.name == "ended" then
	        	if self.isCanClick then
	        		self:touchEnd(event,node)
	        		self.isCanClick = false
	        	end
	        end
	        return true
	    end)
	end
end

--开始触摸
--event 事件
--node 目标结点
--返回值(无)
function UnLockArea:touchBegin(event,node)
	self.beginPos = cc.p(event.x,event.y)
end

--触摸拖动
--event 事件
--node 目标结点
--返回值(无)
function UnLockArea:touchMove(event,node)
end

--触摸结点
--event 事件
--node 目标结点
--返回值(无)
function UnLockArea:touchEnd(event,node)
	local cityMap = MapMgr:getInstance():getCity()
	if cityMap ~= nil and cityMap:isDrapMap() then
		return
	end
	
	local areaIndex = node:getTag()
	MyLog("点击到未解锁区域..areaIndex=",areaIndex)
	if not UnLockAreaModel:getInstance():isCanUnLockArea(areaIndex) then
		local level = UnLockAreaModel:getInstance():getUnLockLevel(areaIndex)
		Lan:hintClient(1,"解锁该区域需要城堡达到{}级",{level})
		return
	end

	self.unLockAreaIndex = areaIndex	
	local castInfo = CastleEffectConfig:getInstance():getConfigByArea(areaIndex)
	if castInfo == nil then
		return
	end

	local text = Lan:lanText(10,"花费粮食:{}, 木材:{}可以解锁该区域，以便建造更多的建筑",{castInfo.ce_needgrain,castInfo.ce_needwood})
	UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.SIGINAL_BTN,text=text,
			callback=handler(self, self.sendUnLockReq)})
end

--发送解锁区域请求
function UnLockArea:sendUnLockReq()
	local castInfo = CastleEffectConfig:getInstance():getConfigByArea(self.unLockAreaIndex)
	local playerData = PlayerData:getInstance()
    --粮食判断
    if castInfo.ce_needgrain > playerData:getFood() then
    	Lan:hintClient(8,"粮食不够,无法解锁")
        return
    end
    --木头判断
    if castInfo.ce_needwood > playerData.wood then
    	Lan:hintClient(9,"木材不够,无法解锁")
        return
    end
	UnLockAreaService:getInstance():sndUnLockAreaReq(self.unLockAreaIndex)
end





