
--[[
	jinyan.zhang
	信息报告列表
--]]

InfoReportListView = class("InfoReportListView",MailInfoListBase)

function InfoReportListView:ctor(parent)
	self.parent = parent
	self.super.ctor(self,parent)
end

--更新UI
function InfoReportListView:updateUI()
	self:setTitle(Lan:lanText(41, "信息"))
	self:createList()
end

--选中回调
function InfoReportListView:onSel(index)
	print("信息 index=",index)
end

