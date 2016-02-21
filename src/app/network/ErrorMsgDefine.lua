
--[[
	jinyan.zhang
	错误码消息定义
--]]

GameError = 
{
    --未给错误信息的错误
	UNKNOW_ERROR = 0,
    --服务端和客户端的配置版本不一致
    CONFIG_VERSION_NOT_CONSISTENT = -1,
    --找不到玩家实例
    CANNT_FIND_PLAYER = -2,
    --消息报无法解析
    PARSE_PACKAGE_FAIL = -3,
	--没有该建筑模板配置
	BUILDING_CANNT_FIND_TEMPLATE = -4,
	--已经拥有最大数量的某某建筑类型
	BUILDING_MAX_NUM_LIMIT = -5,
	--该位置已经存建筑
	BUILDING_POSITION_OCCUPIED = -6,
	--需要的前置建筑条件没有符合
	BUILDING_NEED_BUILDING_LEVEL = -7,
	--没有足够的食物
	BUILDING_NOT_ENOUGH_FOOD = -8,
	--没有足够的木材
	BUILDING_NOT_ENOUGH_WOOD = -9,
	--没有足够的铁矿
	BUILDING_NOT_ENOUGH_IRON = -10,
	--没有足够的银秘
	BUILDING_NOT_ENOUGH_MITHRIL = -11,
	--创建实例失败
	BUILDING_CREATE_INSTANCE_FAIL = -12,
	--已经存在该建筑列表
	BUILDER_ALREADY_EXIST = -13,
	--没有空闲的建筑列表
	BUILDER_NOT_IDLE = -14,
	--找不到指定的建筑实例
	BUILDING_CANNT_FIND = -15,
	--建筑正在建造中
	BUILDING_BEING_BUILT = -16,
	--建筑没有在建造中
	BUILDING_NOT_BEING_BUILT = -17,
	--建筑不可以再升级
	BUILDING_CANNT_UPGRADE = -18,
	--兵的属性模板配置找不到
	ARMS_CANNT_FIND_ATTR_TEMPLATE = -19,
	--没有足够的食物
	ARMS_NOT_ENOUGH_FOOD = -20,
	--没有足够的木材
	ARMS_NOT_ENOUGH_WOOD = -21,
	--没有足够的铁矿
	ARMS_NOT_ENOUGH_IRON = -22,
	--没有足够的银秘
	ARMS_NOT_ENOUGH_MITHRIL = -23,
	--需要建筑等级
	ARMS_NEED_BUILDING_LEVEL = -24,
	--创建兵实例失败
	ARMS_CREATE_INSTANCE_FAIL = -25,
	--需要建筑等级
	ARMS_NEED_BUILDING_TYPE = -26,
	--建筑非空闲
	ARMS_BUILDING_NOT_IDLE = -27,
	--必须有建造数量
	ARMS_LACK_CREATION_NUMBER = -28,
	--找不到兵实例
	ARMS_CANNT_FIND = -29,
	--没有足够的兵出征
	MARCHING_NOT_ENOUGH_ARMS = -30,
	--创建行军基础数据失败
	MARCHING_BASE_CREATE_INSTANCE_FAIL = -31,
	--创建行军兵种数据失败
	MARCHING_ARMS_CREATE_INSTANCE_FAIL = -32,
	--没有定义该行军类型
	MARCHING_TYPE_NOT_FIND = -33,
	--兵种未完成建造
	ARMS_NOT_FINIESHED = -34,
	--不能有相同的行军目标
	MARCHING_SAME_POS = -35,
	--找不到副本实例
	DUPLICATE_ID_NOT_DINF = -36,
	--副本需要领主等级
	DUPLICATE_NEED_KING_LEVEL = -37,
	--没有足够的体力
	DUPLICATE_NOT_ENOUGH_POWER = -38,
	--找不到邮件
	CANNT_FIND_THE_MAIL = -39,
	--加载王国区域地图数据失败
	LOAD_KINGDOM_OBJECTS_FAIL = -40,
	--找不到行军实例
	MARCHING_ID_NOT_DINF = -41,
	---找不到军情实例
	WATCHTOWER_NOT_DINF = -42,
	--还有待取回的兵
	ARMS_HAS_READY_GET = -43,
	---坐标没有玩家城堡
	MAP_CANNT_FIND_KINGDOM = -44,
	--已有相同的侦查目标
	MARCHING_SAME_INVESTIGATION = -45,
	--已达最大出征上线
	MARCHING_GROUP_MAX = -46,
	--需要兵数量
	MARCHING_ARMS_NUMBER_ZERO = -47,
	--玩家已经登录
	PLAYER_HAS_ONLINE = -48,
	--玩家没有足够的金币
	PLAYER_NOT_ENOUGH_GOLD = -49,
	--建筑未被拆除
	BUILDING_NOT_REMOVED = -50,
	--必须有建造数量
	ARMS_TREATE_NUMBER_ERR = -51,
	--找不到伤兵实例
	WOUNDEDSOLIDER_CANNT_FIND = -52,
	--非资源建筑
	BUILDING_NOT_RESOURCE = -53,
	--资源正在加速
	RESOURCE_WAS_SPEEDUP = -54,
	--找不到资源效果模版
	RESOURCE_CANNT_FIND_EFFECT_TEMPLATE = -55,
	--未通过前置副本
	DUPLICATE_NOT_PASS_PRE = -56,
	--需要急救帐篷
	WOUNDEDSOLIDER_NEED_BUILDING = -57,
	--数量大于拥有数量
	NUMBER_THAN_AMOUNT = -58,
	--必须有数量
	OBJ_LACK_CREATION_NUMBER = -59,
	--找不到玩家属性数据
	PLAYERATTR_CANNT_FING = -60,
	--训练数量大于行军帐篷总训练量
	ARMS_EXCEED_CAMP = -61,
	--加速类型错误
	GOLDQUICK_TYPE_ERR = -62,
	--士兵已完成训练，等待取回
	ARMS_FINISHED_TRAIN = -63,
	--找不到定时器实例
	TIMEOUT_CANNT_FIND = -64,
	--创建建筑实例失败
	RESOURCE_CREATE_INSTANCE_FAIL = -65,
	--找不到资源实例
	RESOURCE_CANNT_FIND = -66,
}
