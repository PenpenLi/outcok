--[[
    jinyan.zhang
    功能:注册LUA接口供C++调用
--]]

InvokeC = class("InvokeC")

--构造
--返回值(无)
function InvokeC:ctor()

end

--初始化
--返回值(无)
function InvokeC:initialize()
    local invokeLuaMgr = InvokeLuaMgr:getInstance()
    invokeLuaMgr:setConnectFailLuaHandle(NetWorkMgr.connectFail)
    invokeLuaMgr:setConnectSccuLuaHandle(NetWorkMgr.connectSccu)
    invokeLuaMgr:setRecvDataLuaHandle(NetWorkMgr.recvData)
end
