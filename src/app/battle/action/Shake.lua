
--[[
	jinyan.zhang
	震动
--]]

Shake = class("Shake", function()
	return display.newLayer()
end)

local scheduler = require("framework.scheduler")

--构造
--返回值(无)
function Shake:ctor()
	self:setNodeEventEnabled(true)
	self:init()
end

--初始化
--返回值(无)
function Shake:init()

end

--加入到舞台后会调用这个接口
--返回值(无)
function Shake:onEnter()
	--MyLog("Shake onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function Shake:onExit()
	--MyLog("Shake onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function Shake:onDestroy()
	--MyLog("Shake onDestroy()")
end  

--震动
--返回值(无)
function Shake:doShake()
	local runningScene = cc.Director:getInstance():getRunningScene()
    math.randomseed(os.time())
    local shakeY = math.floor(math.random()*3+1)*cc.Director:getInstance():getWinSize().height*0.003
    local shakeX = math.floor(math.random()*3+1)*cc.Director:getInstance():getWinSize().width*0.003
    if(runningScene:getPositionY()>=0) then
        shakeY = -shakeY
    end
    if(runningScene:getPositionX()>=0) then
        shakeX = -shakeX
        if shakeX >= 0 then
        	shakeX = 0
        end
    end
    shakeX = 0

    runningScene:setPosition(shakeX,shakeY)
end

--开始震动
--返回值(无)
function Shake:startShake()
	local runningScene = cc.Director:getInstance():getRunningScene()
    if(runningScene:getActionByTag(5678)==nil)then
        local action = schedule(runningScene, handler(self,self.doShake),0.05)
        action:setTag(5678)
    end
end

--结束震动
--返回值(无)
function Shake:endShake()
	local runningScene = cc.Director:getInstance():getRunningScene()
	runningScene:stopActionByTag(5678)
	runningScene:setPosition(0,0)
	--self:removeFromParent()
end

