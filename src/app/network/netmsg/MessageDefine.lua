
--[[
	jinayn.zhang
	消息类型定义
--]]

MESSAGE_TYPE =
{
	P_CMD_CTL_LOGIN = 1, 
    P_CMD_C_LOGIN = 2,				        --登录
    P_CMD_C_LOGOUT = 3,				        --登出
    P_CMD_C_PLAYER_RENAME = 4,
    P_CMD_C_BUILDING_CREATE = 5,		    --创建建筑
    P_CMD_S_BUILDING_CREATE = 6,            --创建建筑结果
    P_CMD_C_BUILDING_REMOVE = 7,   		    --移除建筑
    P_CMD_S_BUILDING_REMOVE = 8,		    --移除建筑结果
    P_CMD_C_BUILDING_UPGRADE = 9,		    --升级建筑   
    P_CMD_S_BUILDING_UPGRADE = 10,          --升级建筑结果
    P_CMD_C_BUILDING_CANCEL_UPGRADE = 11,   --取消升级建筑
    P_CMD_C_ARMS_CREATE = 12,               --造兵
    P_CMD_S_ARMS_CREATE = 13,               --造兵结果
    P_CMD_C_GETARMS_CREATE = 14,            --取兵
    P_CMD_C_MARCHINGGROUP_CREATE = 15,      --行军
    P_CMD_S_MARCHINGGROUP_CREATE = 16,      --行军结果
    P_CMD_S_MARCHINGGROUP_ARRIVED = 17,     --到达城堡
    P_CMD_C_MARCHINGATTACK_CREATE = 18,     --播放战报
    P_CMD_C_DUPLICATE_FIGHT  = 19,          --副本战斗
    P_CMD_C_SEND_MAIL = 20,                 --发送邮件
    P_CMD_C_ENTER_MAIL = 21,                --得到邮件列表
    P_CMD_C_RECEIVE_MAIL = 22,              --接收邮件
    P_CMD_S_SEND_MAIL = 23,                 --收到发送的邮件
    P_CMD_S_NOTIFY_WATCHTOWER = 24,         --通知有人攻打或者侦查你 
    P_CMD_S_NOTIFY_WATCHTOWER_CLEAR = 25,   --已经没人攻打或者侦查你 
    P_CMD_C_ENTER_KINGDOM = 26,             --获取地图上的所有东西
    P_CMD_C_ENTER_WATCHTOWER = 27,          --获取暸望塔列表
    P_CMD_C_ENTER_WATCHTOWER_DETAIL = 28,   --获取暸望塔详细信息
    P_CMD_S_DEFENSE_REPORT = 29,             --同步士兵数据
    P_CMD_C_PLAYER_BEATHEART = 30,          --心跳包
}

-- 物品列表
P_CMD_C_ITEMS_LIST = 45
P_CMD_C_WOUNDEDSOLIDER_LIST = 41 --伤兵列表
P_CMD_C_WALL_EFFECT_INFO = 71 --获取城墙效果数据
--进入训练场
P_CMD_S_TRAINHERO_ENTER = 81
-- 城堡拥有的增益效果列表
P_CMD_C_CASTLE_EFFECT_LIST = 86
-- 进入领主天赋界面
P_CMD_C_ENTER_TALENT  = 98
-- 获得领主技能列表
P_CMD_C_LORD_SKILL_LIST  = 102
-- 进入科技界面
P_CMD_C_ENTER_COLLEGE = 91
--获取野外建筑列表
P_CMD_C_PLAYER_WILDBUILDING_LIST = 116
--获取城外守军列表
P_CMD_C_PLAYER_GARRISON_LIST = 118

