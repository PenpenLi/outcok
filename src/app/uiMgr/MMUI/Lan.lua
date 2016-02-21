
--读取多语言

Lan = class("Lan")

local HintService = require(CONFIG_SRC_PRE_PATH .. "HintService")

function Lan:ctor()
	self:init()
end

function Lan:init()
	
end

--获取参数个数
function Lan:getCount(id)
	local content = string.gsub(id,"[^{]","")
	return string.len(content)
end

--读取文本
function Lan:getContent(id,content,arry)
	if id == nil then
		return content
	end

	local count = self:getCount(id)
	if count == 0 then
		return id
	end

	if arry == nil then
		arry = {}
	end

	local outText = id
	for i=1,count do
		local value = arry[i]
		if value == nil then
			return outText
		end
		outText = string.gsub(outText,"{*.}",value,1)
	end

	return outText
end

--读取前端提示文本
function Lan:hintClient(id,content,arry,time)
	if id == nil then
		return content
	end

	local text = HintClient:getInstance():getText()
	local outText = self:getContent(text[id],content,arry)
	Prop:getInstance():showMsg(outText,time)
end

--读取文本
function Lan:lanText(id,content,arry)
	if id == nil then
		return content
	end

	local text = LanguageText:getInstance():getText()
	return self:getContent(text[id],content,arry)
end

--读取服务端提示文本
function Lan:hintService(id,content,arry)
	if id == nil then
		return content
	end

	local info = self:getServerTextById(id)
	if info == nil then
		return content
	end

	local text = info.prop
	if SIGNAL then
		text = id .. info.prop
	end

	local outText = self:getContent(text,content,arry)
	Prop:getInstance():showMsg(outText)
end

--获取服务端提示信息
function Lan:getServerTextById(id)
	for k,v in pairs(HintService) do
		if v.number == id then
			return v
		end
	end
end


