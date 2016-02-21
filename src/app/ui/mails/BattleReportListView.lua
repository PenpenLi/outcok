
--[[
	jinyan.zhang
	战斗报告列表
--]]

BattleReportListView = class("BattleReportListView",MailInfoListBase)

function BattleReportListView:ctor(parent)
	self.parent = parent
	self.super.ctor(self,parent)
end

--更新UI
function BattleReportListView:updateUI()
	self:setTitle(Lan:lanText(43, "战斗"))

	-- --假数据
	-- local data = {}
	-- local info = {}
	-- info.icon = "ui_wood.png"
	-- info.title = "胜利"
	-- info.content = "我方损失500兵力,战斗失败"
	-- info.time = "1天前"
	-- info.gift = "ui_wood.png"
	-- info.callback = self.onSel
	-- info.mailId = 23
	-- table.insert(data,info)

	-- local info = {}
	-- info.icon = "ui_wood.png"
	-- info.title = "胜利"
	-- info.content = "我方损失500兵力,战斗失败"
	-- info.time = "1天前"
	-- info.gift = "ui_wood.png"
	-- info.callback = self.onSel
	-- info.mailId = 23
	-- table.insert(data,info)

	-- local info = {}
	-- info.icon = "ui_wood.png"
	-- info.title = "胜利"
	-- info.content = "我方损失500兵力,战斗失败"
	-- info.time = "1天前"
	-- info.gift = "ui_wood.png"
	-- info.callback = self.onSel
	-- info.mailId = 23
	-- table.insert(data,info)

	self.data = clone(MailsModel:getInstance():getListByType(MailType.battle))
	for k,v in pairs(self.data) do
		v.callback = self.onSel
		if v.subType == MailSubType.battle then --战斗结果
			v.icon = "mail_pic_flag_14.png"
		else
			v.icon = "mail_pic_flag_8.png"
		end
	end

	self:createList(self.data)
end

--选中回调
function BattleReportListView:onSel(index,data)
	print("战斗 index=",index,"data=",data)

	self:hide()
	if data.subType == MailSubType.battle then  --战斗结果
		self.parent.battleResultView:show()
	elseif data.subType == MailSubType.watch or data.subType == MailSubType.beWatch then --侦察结果
		self.parent.watchMailsView:show()
	end
	
	local info = clone(MailsModel:getInstance():getMailDetailsById(data.id))
	if info == nil then
		MailsService:getInstance():sendGetMailDetailsReq(data.id)
	else
		if info.subType == MailSubType.battle then  --战斗结果
			self.parent.battleResultView:updateUI(info)
		elseif data.subType == MailSubType.watch or data.subType == MailSubType.beWatch then --侦察结果
			self.parent.watchMailsView:updateUI(info)
		end
	end
end




