
--[[
	jinyan.zhang
	公用接口
--]]

Common=class("Common")
local fileUtil = cc.FileUtils:getInstance()


--添加公用目录的搜索路径
--path 路径
--返回值(无)
function Common:addLuaSearchPath(path)
    fileUtil:addSearchPath(path)
end

--设置语言类型
--languageType 语言类型(中文，英语)
--返回值(无)
function Common:setLanguageType(languageType)
	local preType = self:getLanguageType()
	LANGUAGE_TYPE = languageType
	self:setLanguageSearchPath(preType,languageType)
    local path = self:getLanguageSearchPath(languageType)
    CONFIG_SRC_PRE_PATH = path.scripts
end

--获取语言类型
--返回值(语言类型)
function Common:getLanguageType()
	return LANGUAGE_TYPE
end

--设置语言包搜索路径
--preType 之前的语言类型
--type 当前的语言类型
--返回值(无)
function Common:setLanguageSearchPath(preType,type)
    local removePath = self:getLanguageSearchPath(preType)
    if fileUtil:isDirectoryExist(removePath.scripts) and preType ==  type then
    	return
    end

    local scrpFullPath = cc.FileUtils:getInstance():fullPathForFilename(removePath.scripts)
    local resFullPath = cc.FileUtils:getInstance():fullPathForFilename(removePath.res)
    local searchPaths = fileUtil:getSearchPaths()
    self:removeSearchPath(searchPaths,scrpFullPath)
    self:removeSearchPath(searchPaths,resFullPath)
    fileUtil:setSearchPaths(searchPaths)

    local addPath = self:getLanguageSearchPath(type)
    fileUtil:addSearchPath(addPath.scripts)
    fileUtil:addSearchPath(addPath.res)
end

--删除搜索路径
--searchPaths 路径列表
--fullPath 要删除的路径
--返回值(无)
function Common:removeSearchPath(searchPaths,fullPath)
	if fullPath == nil then
		return
	end

	for k,v in pairs(searchPaths) do
		if v == fullPath then
			table.remove(searchPaths,k)
			break
		end
	end
end

--获取语言包搜索路径
--languageType 语言类型
--返回值(语言包搜索路径)
function Common:getLanguageSearchPath(languageType)
	local paths = {}
	if languageType == ENUM_LANGUAGE.Chinese then
		paths.scripts = "app/config/language/chinese/"
        paths.res     = "res/chinese/"
    elseif languageType == ENUM_LANGUAGE.English then
    	paths.scripts = "app/config/language/english/"
        paths.res     = "res/english/"
    end
    return paths
end

--设置是否打开自动更新
--isUpdate 自动更新开启标志 (true:开启，false:关闭)
--返回值(无)
function Common:setAutoUpdate(isUpdate)
	OpenAutoUpdate = isUpdate
end

--是否开启自动更新
--返回值(true:打开自动更新,false:不打开自动更新)
function Common:isOpenAutoUpdate()
	return OpenAutoUpdate
end

--设置打开调试日志开关
--isOpen 打开调试 (true:打开 ,false:关闭)
--返回值(无)
function Common:setOpenLog(isOpen)
	LogDebug = isOpen
end

--是否打开调试日志功能
--返回值(true:打开调试，false:关闭调试)
function Common:isOpenLog()
	return LogDebug
end

--设置打开新手引导开关
--isOpen 打开标志 (true:打开,false:不打开)
--返回值(无)
function Common:setOpenGuide(isOpen)
	OpenGuide = isOpen
end

--是否打开新手引导功能
--返回值(true:打开，false:不打开)
function Common:isOpenGuide()
	return OpenGuide
end

--设置是否打开非强制性新手引导
--isOpen 打开标志(true:打开，false:不打开)
--返回值(无)
function Common:setOpenLimitGuide(isOpen)
	OpenLimitGuide = isOpen
end

--是否打开非强制性新手引导
--返回值 (true:是, false:否)
function Common:isOpenLimitGuide()
	return OpenLimitGuide
end

--设置服务器地址
--url 服务器地址
--返回值(无)
function Common:setServerUrl(url)
	SERVER_URL = url
end

--获取服务器地址
--返回值(返回服务器地址)
function Common:getServerUrl()
	return SERVER_URL
end

--获取sdk平台
--返回值(返回SDK平台)
function Common:getSdkPlatform()
	return SDK_PLAMCODE
end

--比较两个数的大小，取出最小的那一个
--返回值(返回最小的那一个数)
function Common:min(a,b)
	if a < b then
		return a
	else
		return b
	end
end

--比较两个数的大小，取出最大的那一个
--返回值(返回最大的那一个数)
function Common:max(a,b)
	if a > b then
		return a
	else
		return b
	end
end

--获取目标结点的坐标值
--node 目标结点
--返回值(目录结点坐标值)
function Common:getPosition(node)
	return cc.p(node:getPositionX(),node:getPositionY())
end

--异步加载png图片
--pngName png图片路径
--fun 加载完成后的回调函数
--返回值(无)
function Common:loadImageAsync(pngName,fun)
	 display.addImageAsync(pngName, fun)
end

--加载UI编辑器导出来的JSON文件
--path 文件路径
--返回值(UI根结点)
function Common:loadUIJson(path)
	return ccs.GUIReader:getInstance():widgetFromJsonFile(path)
end

--根据根结点和名字查找UI中的控件
--root UI根结点
--name 要查找的控件名字
--返回值(UI控件)
function Common:seekNodeByName(root,name)
	return ccui.Helper:seekWidgetByName(root, name)
end

--保存XML数据到缓存中
--key 要保存的索引名
--value 对应的字符串数值
--返回值(无)
function Common:writeDataToXmlCache(key,value)
	cc.UserDefault:getInstance():setStringForKey(key,value)
end

--保存XML数据到缓存中
--key 索引
--value bool型数值(true or false)
--返回值(无)
function Common:writeBoolDataToXmlCache(key,value)
	cc.UserDefault:getInstance():setBoolForKey(key,value)
end

--把缓存中的XML数据写入文件
--返回值(无)
function Common:flushXmlCache()
	cc.UserDefault:getInstance():flush()
end

--通过KEY获取XML文件中保存的数据
--返回值(字符串数据)
function Common:getStringForKey(key)
	return cc.UserDefault:getInstance():getStringForKey(key,"")
end

--通过KEY获取XML文件中保存的数据
--返回值(bool数据,true or false)
function Common:getBoolForKey(key)
	return cc.UserDefault:getInstance():getBoolForKey(key,false)
end

--获取登录账号
--返回值(登录账号)
function Common:getLoginAccount()
	return self:getStringForKey("account")
end

--获取登录密码
--返回值(登录密码)
function Common:getLoginPwd()
	return self:getStringForKey("pwd")
end

--获取登录复选框状态(是否要保存当前登录的账号)
--返回值(是否要记录当前登录的账号信息,true:是，false:否)
function Common:getLoginRecordFlgState()
	return self:getBoolForKey("loginRecordFlg")
end

--连接HTTP服务器
--account 账号
--pwd 密码
--返回值(无)
function Common:loginHttpServer(account,pwd)
	NetWorkMgr:getInstance():connectHttpServer(account,pwd)
    UICommon:getInstance():loadProcessText(CommonStr.CONNECT_HTTP_SERVER)
end

--开关触摸功能
--node 触摸结点
--able 使用触摸开关(true:打开,false:关闭)
--返回值(无)
function Common:setTouchEnabled(node,able)
	node:setTouchEnabled(able)
end

--触摸是否可以向下传递
--node 触摸结点
--able 向下传递开关(true:可以向下传递,false:不可以)
--返回值(无)
function Common:setSwallowTouches(node,able)
	node:setSwallowTouches(able)
end

--获取屏幕大小
--返回值(屏幕大小)
function Common:getScreenSize()
	--[[
	local sharedDirector  = cc.Director:getInstance()
	local glview = sharedDirector:getOpenGLView()
	return glview:getFrameSize()
	--]]
	return cc.size(display.width,display.height)
end

--是否点击在目标上
--pos 坐标点
--target 目标点
--返回值(true:是,false:否)
function Common:isClickTarget(pos,target)
	local pos = target:convertToNodeSpace(pos)
	return self:isClickRect(pos,target:getBoundingBox())
end

--是否点击在某个区域上
--pos 坐标点
--rect 矩形区域
--返回值(true:是，false:否)
function Common:isClickRect(pos,rect)
	return cc.rectContainsPoint(rect,pos)
end

--获取相对父结点的世界坐标
--node 目标结点
--返回值(世界坐标)
function Common:converToWorldPos(node)
	local pos = self:getPosition(node)
	return node:getParent():convertToWorldSpace(pos)
end

--获取放大后的大小
--size 原始大小
--scale 放大倍数
--返回值(放大后的大小)
function Common:getAfterScaleSize(size,scale)
	return cc.size(size.width*scale,size.height*scale)
end

--创建spine动画
--jsonName json文件名
--atlasName altas文件名
--scale 播放速度
--返回(spine动画)
function Common:createSpienAnmation(jsonName,atlasName,scale)
	MyLog("jsonName=",jsonName,"atlasName=",atlasName,"scale=",scale)
	return sp.SkeletonAnimation:create(jsonName, atlasName, scale)
end

--播放spine动画
--skeletonNode 骨格结点
--name 动画名
--loop 是否循环
--返回值(无)
function Common:playSpineAnmation(skeletonNode,name,loop)
	skeletonNode:setAnimation(0, name, loop)
end

--骨格动画设置混合(两个动作连接起来效果更好)
--skeletonNode 骨格结点
--from 从什么动画
--to 到什么动画
--time 时间
--返回值(无)
function Common:setSpineMix(skeletonNode,from,to,time)
	skeletonNode:setMix(from, to, time)
end

--添加spine动画
--skeletonNode 骨格结点
--name 动画名
--loop 是否循环
--delayTime --延迟时间
--返回值(无)
function Common:addSpineAnimation(skeletonNode,name,loop,delayTime)
	if delayTime == nil then
		skeletonNode:addAnimation(0, name, loop)
	else
		skeletonNode:addAnimation(0, name, loop, delayTime)
	end
end

--获取时间戳
--返回值(时间戳)
function Common:getOSTime()
	return os.time()
end

--获取经过的时间
--startTime 开始时间
--返回值(经过时间)
function Common:getPassTime(startTime)
    local curTime = os.time()
    return (curTime - startTime)
end

--获取时间字符串
--sec 秒
--返回值(时间)
function Common:getChangeTimeFormat(sec)
    local h = math.modf(sec/3600)
    local min = math.modf((sec-h*3600)/60)
    local tempS = sec-h*3600
    local s = math.mod(tempS,60)
    local tableTime
    if h == 0 then
        tableTime = {min, s}
    else
        tableTime = {h, min, s}
    end

    local time = ""
    for i=1,#tableTime do
        if tableTime[i] < 10 then
            time = time.."0"..tableTime[i]
        else
            time = time..tableTime[i]
        end
        if i ~= #tableTime then
            time = time..":"
        end
    end
    return time
end

--获取天
--second 秒
--返回值(天)
function Common:getDayf(second)
    return (second/(3600*24))
end

--获取天
--second 秒
--返回值(天)
function Common:getDay(second)
    return math.modf(second/(3600*24))
end

--获取小时
--second 秒
--返回值(小时)
function Common:getHour(second)
    local min = self:getMin(second)
    if min < 60 then
        return math.floor(second%(3600*24)/3600)
    else
        return math.ceil(second%(3600*24)/3600)
    end
end

--获取分钟
--second 秒
--返回值(分钟)
function Common:getMin(second)
    if second == 0 then
        return 0
    end
    return math.ceil(second/60)
end

--获取时间串
--second 秒
--返回值(时间串)
function Common:getFormatTime(second)
	local h = math.modf(second/3600)
    local min = math.modf((second-h*3600)/60)
    local tempS = second-h*3600
    local s = math.mod(tempS,60)
    if h < 10 then
        h = "0" .. h
    end
    if min < 10 then
        min = "0" .. min
    end
    if s < 10 then
        s = "0" .. s
    end

    local time = "" .. h .. ":" .. min .. ":" .. s
    return time
end

--获取时间串
--beginTime 开始时间
--返回值(时间串)
function Common:getFormatTime2(beginTime)
    local second = os.time() - beginTime
    if second < 0 then
        second = 1
    end

    local str = ""
    if beginText ~= nil then
        str = str .. beginText
    end
    local day = 0
    local hour = 0
    local min = 0
    day = getDay(second)
    hour = getHour(second)
    min = getMin(second)
    if day ~= 0 then
        str = str .. day .. "天"
    elseif day == 0 and hour ~= 0 then
        str = str .. hour .. "小时"
    elseif day == 0 and hour == 0 and min ~= 0 then
        str = str .. min .. "分钟"
    elseif day == 0 and hour == 0 and min == 0 and second ~= 0 then
        str = str .. second .. "秒"
    end
    str = str .. "前"
    if endText ~= nil then
        str = str .. endText
    end
    return str
end

--添加plist大图到缓存
--返回值(无)
function Common:addSpriteFrames(fileName)
    display.addSpriteFrames(fileName .. ".plist",fileName .. ".png")
end

--士兵类型转职业类型
--soldierType 士兵类型
--返回值(职业类型)
function Common:soldierTypeToOccupation(soldierType)
    if soldierType == SOLDIER_TYPE.shieldSoldier or soldierType == SOLDIER_TYPE.marines then
        return OCCUPATION.footsoldier
    elseif soldierType == SOLDIER_TYPE.knight or soldierType == SOLDIER_TYPE.bowCavalry then
        return OCCUPATION.cavalry
    elseif soldierType == SOLDIER_TYPE.archer or soldierType == SOLDIER_TYPE.crossbowmen then
        return OCCUPATION.archer
    elseif soldierType == SOLDIER_TYPE.tank or soldierType == SOLDIER_TYPE.catapult then
        return OCCUPATION.tank
    elseif soldierType == SOLDIER_TYPE.master or soldierType == SOLDIER_TYPE.warlock then
        return OCCUPATION.master
    end
end

--获取行数
--index 下标
--返回值(行，列)
function Common:getRowCountByCount(count,maxCol)
    local row,yu = math.modf(count/maxCol)
    if row == 0 then
        row = 1
    elseif yu ~= 0 then
        row = row + 1
    end
    return row
end

--根据角度获取位置坐标
--perframeoffset 偏移值
--degree 角度值
--返回值(获取坐标)
function Common:getPosByAngle(perframeoffset,degree)
    local perframeoffset_x = perframeoffset * math.cos(degree)
    local perframeoffset_y = perframeoffset * math.sin(degree)
    return cc.p(perframeoffset_x , perframeoffset_y)
end

--获取画线点集合
--beginPos 起点坐标
--endPos 结束点坐标
--返回值(点的集合)
function Common:getPoints(beginPos,endPos)
    local pointlist = {}
    local angle = BattleCommon:getInstance():getTwoPosAngle(beginPos,endPos)
    local degree = angle / 180 * math.pi
    local dis = cc.pGetDistance(beginPos,endPos)
    local perframeoffset = GREEN_LINE_OFFSET
    local count = dis/perframeoffset
    perframeoffset = 0
    for i=1,count do
        perframeoffset = perframeoffset + GREEN_LINE_OFFSET
        local offsetpos = self:getPosByAngle(perframeoffset,degree)
        local pos = cc.pAdd(offsetpos,beginPos)
        pointlist[i] = {}
        pointlist[i].pos = pos
        pointlist[i].degree = angle
    end
    return pointlist
end

--创建直线带动画
--beginPos 起始点坐标
--endPos 结束点坐标
--armsid_h 行军部队id
--armsid_l 行军部队id
--parent 父结点
--lineMgr 行军路线管理器
--isOther (true:其它人向你行军,false:自己在行军)
--返回值(无)
function Common:createLineAnimation(beginPos,endPos,armsid_h,armsid_l,parent,lineMgr,isOther)
    local pointList = self:getPoints(beginPos,endPos)
    for i=1,#pointList do
        local line = nil
        if isOther then
            line = display.newSprite("#1move0001.png")
        else
            line = display.newSprite("#move0001.png")
        end

        parent:addChild(line,WORLDE_MAP_ZORDER.MARCH_LINE)
        line:setPosition(pointList[i].pos)
        line:setRotation(-pointList[i].degree)

        if isOther then
            local anmation = AnmationHelp:getInstance():createAnmation("1move",1,10,0.25,"%04d.png")
            AnmationHelp:getInstance():playAnmationForver(anmation,line)
        else
            local anmation = AnmationHelp:getInstance():createAnmation("move",1,10,0.25,"%04d.png")
            AnmationHelp:getInstance():playAnmationForver(anmation,line)
        end

        info = {}
        info.sprite = line
        info.armsid_h = armsid_h
        info.armsid_l = armsid_l
        table.insert(lineMgr,info)
    end
end

--通过时间计算玩家当前位置
--curPos 当前位置
--targetPos 目标位置
--passTime 经过时间
--moveSpeed 玩家移动速度
--返回值(玩家位置)
function Common:calPlayerPosByTime(curPos,targetPos,passTime,moveSpeed)
    local angle =  BattleCommon:getInstance():getTwoPosAngle(curPos,targetPos)
    -- 刷新位置
    local perframeoffset = moveSpeed * passTime
    local perframeoffset_x = perframeoffset * math.cos(angle / 180 * math.pi)
    local perframeoffset_y = perframeoffset * math.sin(angle / 180 * math.pi)
    local offsetpos = cc.p(perframeoffset_x , perframeoffset_y)
    return cc.pAdd(curPos , offsetpos)
end

--获取起始位置偏下的点
--angle 角度
--r 半径
--beginPos 起始位置
--atTargetLeft 在目标位置左边(true:是,false:否)
--atTargetDown 在目标位置下边(true:是,false:否)
--返回值(坐标点)
function Common:getStartPosOffDownPos(angle,r,beginPos,atTargetLeft,atTargetDown)
    local degree = math.rad(angle)
    local x = r*math.sin(degree)
    local y = math.sqrt(r*r-x*x)
    if atTargetLeft then
        x = beginPos.x + x
    else
        x = beginPos.x - x
    end

    if atTargetDown then
        y = beginPos.y - y
    else
        y = beginPos.y + y
    end
    return cc.p(x,y)
end

--获取起始位置偏上的点
--angle 角度
--r 半径
--beginPos 起始位置
--atTargetLeft 在目标位置左边(true:是,false:否)
--atTargetDown 在目标位置下边(true:是,false:否)
--返回值(坐标点)
function Common:getStartPosOffUpPos(angle,r,beginPos,atTargetLeft,atTargetDown)
    local degree = math.rad(angle)
    local x = r*math.cos(degree)
    local y = math.sqrt(r*r-x*x)
    if atTargetLeft then
        x = beginPos.x - x
    else
        x = beginPos.x + x
    end

    if atTargetDown then
        y = beginPos.y + y
    else
        y = beginPos.y - y
    end

    return cc.p(x,y)
end

--获取目标位置偏下的点
--angle 角度
--r 半径
--beginPos 起始位置
--atTargetLeft 在目标位置左边(true:是,false:否)
--atTargetDown 在目标位置下边(true:是,false:否)
--返回值(坐标点)
function Common:getTargetPosOffDownPos(angle,r,beginPos,atTargetLeft,atTargetDown)
    local degree = math.rad(angle)
    local x = r*math.cos(degree)
    local y = math.sqrt(r*r-x*x)
    if atTargetLeft then
        x = beginPos.x + x
    else
        x = beginPos.x - x
    end

    if atTargetDown then
        y = beginPos.y + y
    else
        y = beginPos.y - y
    end

    return cc.p(x,y)
end

--获取目标位置偏上的点
--angle 角度
--r 半径
--beginPos 起始位置
--atTargetLeft 在目标位置左边(true:是,false:否)
--atTargetDown 在目标位置下边(true:是,false:否)
--返回值(坐标点)
function Common:getTargetPosOffUpPos(angle,r,beginPos,atTargetLeft,atTargetDown)
    local degree = math.rad(angle)
    local x = r*math.sin(degree)
    local y = math.sqrt(r*r-x*x)
    if atTargetLeft then
        x = beginPos.x + x
    else
        x = beginPos.x - x
    end

    if atTargetDown then
        y = beginPos.y + y
    else
        y = beginPos.y - y
    end

    return cc.p(x,y)
end

--获取下一排的中间点位置
--ydis 下一排和上一排中点间的距离
--lastMidPos 上一个中点起始位置
--lastMidTargetPos 上一个中点的目标位置
--返回值(中间点坐标和目标点位置)
function Common:getNextMidPos(ydis,lastMidPos,lastMidTargetPos)
    local atTargetLeft = false
    if lastMidPos.x < lastMidTargetPos.x then
        atTargetLeft = true
    end

    local atTargetDown = false
    if lastMidPos.y < lastMidTargetPos.y then
        atTargetDown = true
    end

    local dis = cc.pGetDistance(lastMidPos,lastMidTargetPos)
    local value = math.abs(lastMidPos.x-lastMidTargetPos.x)/dis
    local degree = math.acos(value)

    local x = ydis*math.cos(degree)
    local y = math.sqrt(ydis*ydis-x*x)
    if atTargetLeft then
        x = lastMidPos.x - x
    else
        x = lastMidPos.x + x
    end

    if atTargetDown then
        y = lastMidPos.y - y
    else
        y = lastMidPos.y + y
    end

    local midPos = cc.p(x,y)
    local midTargetPos = self:getMideTargetPos(degree,dis,midPos,atTargetLeft,atTargetDown)

    return midPos,midTargetPos
end

--获取中间点的目标点坐标
--degree 孤度
--r 半径
--midPos 中点坐标
--atTargetLeft 在目标左边(true:是，false:否)
--atTargetDown 在目标下边(true:是，false:否)
--返回值(目标点位置)
function Common:getMideTargetPos(degree,r,midPos,atTargetLeft,atTargetDown)
    local x = r*math.cos(degree)
    local y = math.sqrt(r*r-x*x)
    if atTargetLeft then
        x = midPos.x + x
    else
        x = midPos.x - x
    end

    if atTargetDown then
        y = midPos.y + y
    else
        y = midPos.y - y
    end
    return cc.p(x,y)
end

--获取三个坐标点以及目标位置
--xdis 两个人横向之间的距离
--midPos 中间位置
--midTargetPos 中点的目标位置
--toTargetDis 到目标点的距离
--返回值(三个坐标点集合)
function Common:getThreePosAndTargetPos(xdis,midPos,midTargetPos,toTargetDis)
    local atTargetLeft = false
    if midPos.x < midTargetPos.x then
        atTargetLeft = true
    end

    local atTargetDown = false
    if midPos.y < midTargetPos.y then
        atTargetDown = true
    end

    local dis = cc.pGetDistance(midPos,midTargetPos)
    local value = math.abs(midPos.x-midTargetPos.x)/dis
    local degree = math.acos(value)
    local angle = math.deg(degree)

    local startDownPos = self:getStartPosOffDownPos(angle,xdis,midPos,atTargetLeft,atTargetDown)
    local startUpPos = self:getStartPosOffUpPos(90-angle,xdis,midPos,atTargetLeft,atTargetDown)

    toTargetDis = dis
    if toTargetDis < 0 then
        toTargetDis = 0
    end

    local targetDownPos = self:getTargetPosOffDownPos(angle,toTargetDis,startDownPos,atTargetLeft,atTargetDown)
    local targetUpPos = self:getTargetPosOffUpPos(90-angle,toTargetDis,startUpPos,atTargetLeft,atTargetDown)

    local tab = {}
    tab[1] = {}
    tab[1].pos = startUpPos
    tab[1].targetPos = targetUpPos
    tab[2] = {}
    tab[2].pos = midPos
    tab[2].targetPos = midTargetPos
    tab[3] = {}
    tab[3].pos = startDownPos
    tab[3].targetPos = targetDownPos

    return tab
end

--获取两个坐标点以及目标位置
--xdis 两个人横向之间的距离
--midPos 中间位置
--midTargetPos 中点的目标位置
--toTargetDis 到目标点的距离
--返回值(两个坐标点集合)
function Common:getTwoPosAndTargetPos(xdis,midPos,midTargetPos,toTargetDis)
    local tab = self:getThreePosAndTargetPos(xdis,midPos,midTargetPos,toTargetDis)
    local newTab = {}
    newTab[1] = tab[1]
    newTab[2] = tab[3]

    return newTab
end

--获取五个坐标点以及目标位置
--xdis 两个人横向之间的距离
--midPos 中间位置
--midTargetPos 中点的目标位置
--toTargetDis 到目标点的距离
--返回值(四个坐标点集合)
function Common:getFivePosAndTargetPos(xdis,midPos,midTargetPos,toTargetDis)
    local atTargetLeft = false
    if midPos.x < midTargetPos.x then
        atTargetLeft = true
    end

    local atTargetDown = false
    if midPos.y < midTargetPos.y then
        atTargetDown = true
    end

    local dis = cc.pGetDistance(midPos,midTargetPos)
    local value = math.abs(midPos.x-midTargetPos.x)/dis
    local degree = math.acos(value)
    local angle = math.deg(degree)

    local startDown1Pos = self:getStartPosOffDownPos(angle,xdis,midPos,atTargetLeft,atTargetDown)
    local startDown2Pos = self:getStartPosOffDownPos(angle,2*xdis,midPos,atTargetLeft,atTargetDown)
    local startUp1Pos = self:getStartPosOffUpPos(90-angle,xdis,midPos,atTargetLeft,atTargetDown)
    local startUp2Pos = self:getStartPosOffUpPos(90-angle,2*xdis,midPos,atTargetLeft,atTargetDown)

    toTargetDis = dis
    if toTargetDis < 0 then
        toTargetDis = 0
    end

    local targetDown1Pos = self:getTargetPosOffDownPos(angle,toTargetDis,startDown1Pos,atTargetLeft,atTargetDown)
    local targetDown2Pos = self:getTargetPosOffDownPos(angle,toTargetDis,startDown2Pos,atTargetLeft,atTargetDown)
    local targetUp1Pos = self:getTargetPosOffUpPos(90-angle,toTargetDis,startUp1Pos,atTargetLeft,atTargetDown)
    local targetUp2Pos = self:getTargetPosOffUpPos(90-angle,toTargetDis,startUp2Pos,atTargetLeft,atTargetDown)

    local tab = {}
    tab[1] = {}
    tab[1].pos = startUp1Pos
    tab[1].targetPos = targetUp1Pos
    tab[2] = {}
    tab[2].pos = startUp2Pos
    tab[2].targetPos = targetUp2Pos
    tab[3] = {}
    tab[3].pos = midPos
    tab[3].targetPos = midTargetPos
    tab[4] = {}
    tab[4].pos = startDown1Pos
    tab[4].targetPos = targetDown1Pos
    tab[5] = {}
    tab[5].pos = startDown2Pos
    tab[5].targetPos = targetDown2Pos

    return tab
end

--获取四个坐标点以及目标位置
--xdis 两个人横向之间的距离
--midPos 中间位置
--midTargetPos 中点的目标位置
--toTargetDis 到目标点的距离
--返回值(四个坐标点集合)
function Common:getFourtPosAndTargetPos(xdis,midPos,midTargetPos,toTargetDis)
    local tab = self:getFivePosAndTargetPos(xdis,midPos,midTargetPos,toTargetDis)
    local newTab = {}
    newTab[1] = tab[1]
    newTab[2] = tab[2]
    newTab[3] = tab[4]
    newTab[4] = tab[5]

    return newTab
end

--获取单位
--num 数量
function Common:getCompany(num)
    if 1 == 1 then
        return tostring(num)
    end

    num = tonumber(num)
    local str = ""
    if num > 999 and num < 1000000 then
        str = string.format("%.1f", (num  / 1000)) .. "K"
        return str
    elseif num > 999999 then
        str = string.format("%.1f", (num  / 1000000)) .. "M"
        return str
    end
    return tostring(num)
end

--获取四舍五入后的数值
--value 数值
--返回值(整体)
function Common:getFourHomesFive(value)
    local v1,v2 = math.modf(value)
    -- print("v1,v2",v1,v2)
    if v2 < 0.5 then
        return v1
    else
       return v1+1
    end
end

--计算消耗的食物
--pos 坐标
--targetPos 目标位置
--targetLv 目标等级
--返回值(消耗的食物)
function Common:calCastFood(pos,targetPos,targetLv)
    local dis = self:calMarchDis(pos,targetPos)
    local castFood = targetLv*100+dis
    return math.floor(castFood)
end

--计算行军距离
function Common:calMarchDis(pos,targetPos)
    return math.sqrt(math.pow(math.sqrt(3.00) * math.abs(pos.x - targetPos.x),2) + math.pow(1.50 * math.abs(pos.y - targetPos.y),2))*100
end

--计算行军时间
--pos 坐标
--targetPos 目标位置
--返回值(行军时间)
function Common:calMarchTime(pos,targetPos)
    local dis = self:calMarchDis(pos,targetPos)
    local speed = ArmsAttributeConfig:getInstance():getMarchMinSpeed()
    local time = dis/speed*100
    return Common:getFourHomesFive(time)
end

--获取建筑升级剩余时间
--beginTime 开始时间戳
--needTime 需要时间
--返回值(建筑升级时间)
function Common:getLeftTime(beginTime,needTime)
    if beginTime == nil or needTime == nil then
        return 0
    end

    local passTime = Common:getOSTime() - beginTime
    local leftTime =  needTime - passTime
    if leftTime < 0 then
        leftTime = 0
    end
    return leftTime
end

--设置是否允许触摸下向传递
--able(true:不允许,false:允许)
--node 目标结点
function Common:setTouchSwallowEnabled(able,node)
    node:setTouchSwallowEnabled(able)
end

-- 获取对应品质的颜色
-- quality 品质
function Common:getQualityColor(quality)
    local myColor = 1
    if quality == QUALITY.white then --白色
        myColor = cc.c4b(255, 255, 255, 255)
    elseif quality == QUALITY.green then --绿色
        myColor = cc.c4b(0, 255, 0, 255)
    elseif quality == QUALITY.blue then --蓝色
        myColor = cc.c4b(0, 0, 255, 255)
    elseif quality == QUALITY.purple then --紫色
        myColor = cc.c4b(160, 32, 240, 255)
    elseif quality == QUALITY.orange then --橙色
        myColor = cc.c4b(255, 165, 0, 255)
    end
    return myColor
end






