
--[[
	jinyan.zhang
	联盟报告列表
--]]

AlianceReportListView = class("AlianceReportListView",MailInfoListBase)

function AlianceReportListView:ctor(parent)
	self.parent = parent
	self.super.ctor(self,parent)
end

--更新UI
function AlianceReportListView:updateUI()
	self:setTitle(Lan:lanText(42, "联盟"))
	self:createList()
end

--选中回调
function AlianceReportListView:onSel(index)
	print("联盟 index=",index)
end

