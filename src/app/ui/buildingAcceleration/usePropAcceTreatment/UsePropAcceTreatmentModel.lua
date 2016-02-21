
--[[
    jinyan.zhang
    使用道具加速治疗
--]]

UsePropAcceTreatmentModel = class("UsePropAcceTreatmentModel")

local instance = nil

--构造
--返回值(无)
function UsePropAcceTreatmentModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function UsePropAcceTreatmentModel:init()

end

--获取单例
--返回值(单例)
function UsePropAcceTreatmentModel:getInstance()
    if instance == nil then
        instance = UsePropAcceTreatmentModel.new()
    end
    return instance
end

--使用道具加速治疗结果
--data 数据
function UsePropAcceTreatmentModel:acceRes(data)
    local items = data.items
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
        cityBuildingListCtrl:updateTreatmentTime()
    end
end

--获取加速道具数量
function UsePropAcceTreatmentModel:getPropNum()
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.treatment or v.speedType == ItemSpeedType.all then
            total = total + v.number
        end
    end
    return total
end


--清理缓存数据
--返回值(无)
function UsePropAcceTreatmentModel:clearCache()
    self:init()
end



