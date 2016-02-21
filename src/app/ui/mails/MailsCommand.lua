--[[
    jinyan.zhang
    邮件界面
--]]

MailsCommand = class("MailsCommand")
local instance = nil

--邮件类型
MAILType =
{
    PVPBATTLE = 0,  --PVP战斗回放
    LOOK = 1,       --侦察
    OTHER_LOOK = 2,  --其它人侦察你
}

--构造
--返回值(无)
function MailsCommand:ctor()
    
end

--uiType UI类型
--data 数据
--返回值(无)
function MailsCommand:open(uiType,data)
    self.view = MailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
    MailsService:getInstance():sendGetMailListReq()
end 

--关闭登录界面
--返回值(无)
function MailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function MailsCommand:getInstance()
    if instance == nil then
        instance = MailsCommand.new()
    end
    return instance
end

--更新邮件列表
function MailsCommand:updateMailList()
    if self.view ~= nil then
        self.view:createList()
    end
end

--更新邮件战斗结果UI
function MailsCommand:updateBattleResUI(data)
    if self.view ~= nil then
        if data.subType == MailSubType.battle then   --战斗结果
            self.view.battleResultView:updateUI(data)
        end
    end
end

--更新侦察UI
function MailsCommand:updateWatchUI(data)
    if self.view ~= nil then
        self.view.watchMailsView:updateUI(data)
    end
end

--更新报告列表UI
function MailsCommand:updateReportListUI()
    if self.view ~= nil then
        self.view:updateReportListUI()
    end
end







