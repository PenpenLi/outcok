
--[[
	jinyan.zhang
	初始搜索路径	
--]]

require("app.config.GameConfig")
require("app.common.Define")
require("app.common.Common")

local function addSearchPath()
	Common:addLuaSearchPath("res")
	Common:addLuaSearchPath("res/common")
    Common:setLanguageType(LANGUAGE_TYPE)
end

addSearchPath()
