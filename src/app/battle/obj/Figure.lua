
--[[
	jinyan.zhang
	spine形象
--]]

Figure = class("Figure")

--构造
--返回值(无)
function Figure:ctor()
	self:init()
end

--初始化
--返回值(无)
function Figure:init()
end

--加入到舞台后会调用这个接口
--返回值(无)
function Figure:onEnter()
	--MyLog("Figure onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function Figure:onExit()
	--MyLog("Figure onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function Figure:onDestroy()
	--MyLog("Figure onDestroy()")
end



