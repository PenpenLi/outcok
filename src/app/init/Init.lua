
--[[
    jinyan.zhang
    初始化相关模块
--]]

--初始化相关模块
local function start()
	require("app.mobdebug").start()
    InvokeC:initialize()
    SpriteCache:getInstance():init()
    AnmationCache:getInstance():init()
end

start()






