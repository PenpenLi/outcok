
--[[
	jinyan.zhang
	消息头文件
--]]

require("app/network/netmsg/handle/NetworkHandler_SyncArmsData")

--注册pb
Protobuf.register_file(pbPath .. "msg_login_login.pb")
Protobuf.register_file(pbPath .. "msg_agent_login.pb")
--Protobuf.register_file(pbPath .. "client_data_packet.pb")
Protobuf.register_file(pbPath .. "data_packet.pb")

Protobuf.register_file(pbPath .. "msg_object_id.pb")
Protobuf.register_file(pbPath .. "msg_builder.pb")
Protobuf.register_file(pbPath .. "msg_building.pb")
Protobuf.register_file(pbPath .. "msg_cancel_upgrade_building.pb")
Protobuf.register_file(pbPath .. "msg_create_building.pb")
Protobuf.register_file(pbPath .. "msg_remove_building.pb")
Protobuf.register_file(pbPath .. "msg_upgrade_building.pb")
Protobuf.register_file(pbPath .. "msg_timeout.pb")
Protobuf.register_file(pbPath .. "msg_arms.pb")
Protobuf.register_file(pbPath .. "msg_create_arms.pb")
Protobuf.register_file(pbPath .. "msg_soldierInfo.pb")
Protobuf.register_file(pbPath .. "msg_marching_arms.pb")
Protobuf.register_file(pbPath .. "msg_return_marching_group.pb")
Protobuf.register_file(pbPath .. "msg_marching_group.pb")
Protobuf.register_file(pbPath .. "msg_equip.pb") -- 装备
Protobuf.register_file(pbPath .. "msg_shift_equip.pb") -- 装备穿或脱
Protobuf.register_file(pbPath .. "msg_equip_list.pb") --装备列表
Protobuf.register_file(pbPath .. "msg_items.pb")-- 物品协议
Protobuf.register_file(pbPath .. "msg_items_list.pb")-- 物品列表协议
Protobuf.register_file(pbPath .. "msg_buy_items.pb") -- 购买物品协议
Protobuf.register_file(pbPath .. "msg_use_items.pb") -- 使用物品协议
Protobuf.register_file(pbPath .. "msg_skill.pb")-- 技能
Protobuf.register_file(pbPath .. "msg_hero.pb")-- 英雄协议
Protobuf.register_file(pbPath .. "msg_move_kingdom.pb")
Protobuf.register_file(pbPath .. "msg_point.pb")
Protobuf.register_file(pbPath .. "msg_kingdom_object.pb")
Protobuf.register_file(pbPath .. "msg_kingdom_range.pb")
Protobuf.register_file(pbPath .. "msg_enter_kingdom.pb")
Protobuf.register_file(pbPath .. "msg_notify_mail.pb")
Protobuf.register_file(pbPath .. "msg_enter_mail.pb")
Protobuf.register_file(pbPath .. "msg_receive_mail.pb")
Protobuf.register_file(pbPath .. "msg_send_mail.pb")
Protobuf.register_file(pbPath .. "msg_watchtower_report.pb")
Protobuf.register_file(pbPath .. "msg_quick_building.pb")
Protobuf.register_file(pbPath .. "msg_resource_collect.pb")
Protobuf.register_file(pbPath .. "msg_cancel_remove_building.pb")
Protobuf.register_file(pbPath .. "msg_resource.pb")
Protobuf.register_file(pbPath .. "msg_quick_resource.pb")
Protobuf.register_file(pbPath .. "msg_cancel_train_arms.pb")
Protobuf.register_file(pbPath .. "msg_quick_arms.pb")
Protobuf.register_file(pbPath .. "msg_fire_arms.pb")
Protobuf.register_file(pbPath .. "msg_playerattr_packet.pb")
Protobuf.register_file(pbPath .. "msg_player_packet.pb") -- 玩家数据协议
Protobuf.register_file(pbPath .. "msg_quick_treate.pb")
Protobuf.register_file(pbPath .. "msg_treatement_arms.pb")
Protobuf.register_file(pbPath .. "msg_inn_hero.pb") -- 酒吧英雄结构
Protobuf.register_file(pbPath .. "msg_attrib_sync.pb") --（推送消息）玩家资源属性同步。
Protobuf.register_file(pbPath .. "msg_tavern_panel.pb") -- 酒吧面板协议
Protobuf.register_file(pbPath .. "msg_leave_tavern.pb") -- 离开酒吧面板协议
Protobuf.register_file(pbPath .. "msg_enter_tavern.pb") -- 进入酒吧协议
Protobuf.register_file(pbPath .. "msg_hire_hero.pb") -- 雇佣英雄协议
Protobuf.register_file(pbPath .. "msg_dismiss_hero.pb") -- 解雇英雄协议
Protobuf.register_file(pbPath .. "msg_refresh_tavern.pb") -- 刷新酒吧英雄列表协议
Protobuf.register_file(pbPath .. "msg_wall_effect.pb") --城墙效果数据
Protobuf.register_file(pbPath .. "msg_wall_hero.pb") --城墙英雄操作数据
Protobuf.register_file(pbPath .. "msg_train_hero.pb") --训练英雄状态数据
Protobuf.register_file(pbPath .. "msg_create_trainhero.pb") --训练英雄进入与取消数据
Protobuf.register_file(pbPath .. "msg_quick_train_hero.pb") --训练英雄加速数据
Protobuf.register_file(pbPath .. "msg_wall_sync.pb")
Protobuf.register_file(pbPath .. "msg_castle_effect.pb")--使用增益道具
Protobuf.register_file(pbPath .. "msg_castle_effect_list.pb")--增益列表
Protobuf.register_file(pbPath .. "msg_castle_effect_finish.pb")--使用增益道具结束通知
Protobuf.register_file(pbPath .. "msg_refresh_skill.pb")--技能刷新
Protobuf.register_file(pbPath .. "msg_change_skill.pb")--替换技能
Protobuf.register_file(pbPath .. "msg_unlock_area.pb")--技能刷新
Protobuf.register_file(pbPath .. "msg_tech.pb")--科技包
Protobuf.register_file(pbPath .. "msg_enter_college.pb")--进入科技
Protobuf.register_file(pbPath .. "msg_upgrade_tech.pb")--升级科技
Protobuf.register_file(pbPath .. "msg_quick_tech.pb")--加速升级科技
Protobuf.register_file(pbPath .. "msg_monster.pb")
Protobuf.register_file(pbPath .. "msg_create_marching_group.pb")
Protobuf.register_file(pbPath .. "msg_defend_report.pb")     --同步士兵数据
Protobuf.register_file(pbPath .. "msg_battle_sequence.pb")   --战斗序列
Protobuf.register_file(pbPath .. "msg_duplicate_squence.pb") 
Protobuf.register_file(pbPath .. "msg_duplicate_create.pb")  --副本战斗
Protobuf.register_file(pbPath .. "msg_pvp_battle.pb")       
Protobuf.register_file(pbPath .. "msg_delete_mail.pb")    --删除邮件
Protobuf.register_file(pbPath .. "msg_burning_food.pb")    --士兵消耗粮食
Protobuf.register_file(pbPath .. "msg_player_rename.pb")    --玩家重命名
Protobuf.register_file(pbPath .. "msg_reset_talent.pb")    --重置天赋
Protobuf.register_file(pbPath .. "msg_player_chg_avatar.pb")    --修改形象
Protobuf.register_file(pbPath .. "msg_lord_skill.pb")    --领主技能
Protobuf.register_file(pbPath .. "msg_lord_skill_list.pb")    --领主技能列表
Protobuf.register_file(pbPath .. "msg_talent.pb")    --天赋
Protobuf.register_file(pbPath .. "msg_type_attrib.pb")    --属性
Protobuf.register_file(pbPath .. "msg_use_lord_skill.pb")    --使用领主技能消息
Protobuf.register_file(pbPath .. "msg_upgrade_talent.pb")    --升级领主天赋
Protobuf.register_file(pbPath .. "msg_enter_talent.pb")    --进入领主天赋列表
Protobuf.register_file(pbPath .. "msg_wildbuilding.pb")    --野外建筑实例
Protobuf.register_file(pbPath .. "msg_upgrade_wildbuilding.pb") --升级野外建筑
Protobuf.register_file(pbPath .. "msg_quick_wildbuilding.pb") 	--快速完成野外建筑
Protobuf.register_file(pbPath .. "msg_placement_wildbuilding.pb") 	--放置野外建筑
Protobuf.register_file(pbPath .. "msg_takeback_wildbuilding.pb") 	--收回野外建筑

    










