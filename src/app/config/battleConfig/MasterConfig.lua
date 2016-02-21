
--法师配置

require("app.config.battleConfig.AnimationConfig")

MasterTab = {}
MasterTab.moveSpeed = 50   --移动速度
MasterTab.beRecSize = cc.size(70,74)  --受击区大小
MasterTab.attack_distance = 400   --攻击距离

MasterTab.idle = {}
MasterTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
MasterTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
MasterTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
MasterTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
MasterTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
MasterTab.idle.begin = 0
MasterTab.idle.count = 10
MasterTab.idle.time = 1
MasterTab.idle.defaultFileName = "00000.png"

MasterTab.move = {}
MasterTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
MasterTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
MasterTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
MasterTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
MasterTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
MasterTab.move.begin = 0
MasterTab.move.count = 10
MasterTab.move.time = 1
MasterTab.move.defaultFileName = "00000.png"

MasterTab.hurt = {}
MasterTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
MasterTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
MasterTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
MasterTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
MasterTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
MasterTab.hurt.begin = 0
MasterTab.hurt.count = 6
MasterTab.hurt.time = 0.5
MasterTab.hurt.defaultFileName = "00000.png"

MasterTab.death = {}
MasterTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
MasterTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
MasterTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
MasterTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
MasterTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
MasterTab.death.begin = 0
MasterTab.death.count = 9
MasterTab.death.time = 0.4
MasterTab.death.defaultFileName = "00000.png"

MasterTab.att1 = {}
MasterTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
MasterTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
MasterTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
MasterTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
MasterTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
MasterTab.att1.begin = 0
MasterTab.att1.count = 9
MasterTab.att1.time = 2
MasterTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
MasterTab.att1.flySpeed = 400
MasterTab.att1.cdTime = 2
MasterTab.att1.defaultFileName = "00000.png"
MasterTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
MasterTab.att1.WorldMap_flySpeed = 400

MasterTab.att2 = {}
MasterTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
MasterTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
MasterTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
MasterTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
MasterTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
MasterTab.att2.begin = 0
MasterTab.att2.count = 9
MasterTab.att2.time = 2
MasterTab.att2.delayAttCheckTime = 0.5  
MasterTab.att2.flySpeed = 200
MasterTab.att2.cdTime = 3
MasterTab.att2.defaultFileName = "00000.png"
MasterTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
MasterTab.att2.WorldMap_flySpeed = 400

MasterTab.effect = {}
MasterTab.effect.att1 = {}
MasterTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
MasterTab.effect.att1.begin = 0
MasterTab.effect.att1.count = 4
MasterTab.effect.att1.time = 1
MasterTab.effect.att1.delayPlayEffectTime = 0.8
MasterTab.effect.att1.size = {}
MasterTab.effect.att1.size.width = 15
MasterTab.effect.att1.size.height = 20
MasterTab.effect.att1.defaultFileName = "00000.png"
MasterTab.effect.att1.worldMap_time = 1  

MasterTab.effect.att2 = {}
MasterTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
MasterTab.effect.att2.begin = 0
MasterTab.effect.att2.count = 5
MasterTab.effect.att2.time = 1
MasterTab.effect.att2.delayPlayEffectTime = 0.3
MasterTab.effect.att2.size = {}
MasterTab.effect.att2.size.width = 15
MasterTab.effect.att2.size.height = 20
MasterTab.effect.att2.defaultFileName = "00000.png"
MasterTab.effect.att2.worldMap_time = 1  

MasterTab.effect.hurt1 = {}
MasterTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
MasterTab.effect.hurt1.begin = 0
MasterTab.effect.hurt1.count = 4
MasterTab.effect.hurt1.time = 0.5
MasterTab.effect.hurt1.defaultFileName = "00000.png"

MasterTab.effect.hurt2 = {}
MasterTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
MasterTab.effect.hurt2.begin = 0
MasterTab.effect.hurt2.count = 4
MasterTab.effect.hurt2.time = 0.5
MasterTab.effect.hurt2.defaultFileName = "00000.png"



