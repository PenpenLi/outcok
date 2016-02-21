
--[[
    jinyan.zhang
    使用道具加速制造陷井
--]]

UsePropAcceMakeTrapModel = class("UsePropAcceMakeTrapModel")

local instance = nil

--构造
--返回值(无)
function UsePropAcceMakeTrapModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function UsePropAcceMakeTrapModel:init()

end

--获取单例
--返回值(单例)
function UsePropAcceMakeTrapModel:getInstance()
    if instance == nil then
        instance = UsePropAcceMakeTrapModel.new()
    end
    return instance
end

--使用道具加速造兵结果
--data 数据
function UsePropAcceMakeTrapModel:acceRes(data)
    local items = data.items
    local buildingPos = data.pos
    local config = ItemTemplateConfig:getInstance():getItemTemplateByID(items.templateId)
    local second = config.it_turbotime*60
    local timeInfo = TimeInfoData:getInstance():minusLeftTimeByPos(buildingPos,second)
    BagModel:getInstance():useItem(items)

    UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
    UIMgr:getInstance():closeUI(UITYPE.TRAINING_CITY)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:createFortressTimeUI(buildingPos)
    end
end

--获取加速道具数量
function UsePropAcceMakeTrapModel:getPropNum()
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.trap or v.speedType == ItemSpeedType.all then
            total = total + v.number
        end
    end
    return total
end

--清理缓存数据
--返回值(无)
function UsePropAcceMakeTrapModel:clearCache()
    self:init()
end



