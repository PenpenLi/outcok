--[[
    jinyan.zhang
    迁城
--]]

MoveCastleAniView = class("MoveCastleAniView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function MoveCastleAniView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
end

--初始化
--返回值(无)
function MoveCastleAniView:init()
    UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.DIS_CONNECT,text=CommonStr.SURE_MOVE_CASTLE,
            callback=handler(self, self.sureMoveCastle),sureBtnText=CommonStr.YES
    })
end

--确定迁城
function MoveCastleAniView:sureMoveCastle()
    WallService:getInstance():getWallEffectDataReq()
    SceneMgr:getInstance():goToWorld()
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function MoveCastleAniView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function MoveCastleAniView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function MoveCastleAniView:onDestroy()
end


