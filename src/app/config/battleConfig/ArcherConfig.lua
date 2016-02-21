
--弓兵配置

require("app.config.battleConfig.AnimationConfig")

ArcherConfigTab = {}
ArcherConfigTab.moveSpeed = 50   --移动速度
ArcherConfigTab.beRecSize = cc.size(70,74)  --受击区大小
ArcherConfigTab.attack_distance = 400   --攻击距离

ArcherConfigTab.idle = {}
ArcherConfigTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
ArcherConfigTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
ArcherConfigTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
ArcherConfigTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
ArcherConfigTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
ArcherConfigTab.idle.begin = 0
ArcherConfigTab.idle.count = 10
ArcherConfigTab.idle.time = 1
ArcherConfigTab.idle.defaultFileName = "00000.png"

ArcherConfigTab.move = {}
ArcherConfigTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
ArcherConfigTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
ArcherConfigTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
ArcherConfigTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
ArcherConfigTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
ArcherConfigTab.move.begin = 0
ArcherConfigTab.move.count = 10
ArcherConfigTab.move.time = 1
ArcherConfigTab.move.defaultFileName = "00000.png"

ArcherConfigTab.hurt = {}
ArcherConfigTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
ArcherConfigTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
ArcherConfigTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
ArcherConfigTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
ArcherConfigTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
ArcherConfigTab.hurt.begin = 0
ArcherConfigTab.hurt.count = 6
ArcherConfigTab.hurt.time = 0.5
ArcherConfigTab.hurt.defaultFileName = "00000.png"

ArcherConfigTab.death = {}
ArcherConfigTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
ArcherConfigTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
ArcherConfigTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
ArcherConfigTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
ArcherConfigTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
ArcherConfigTab.death.begin = 0
ArcherConfigTab.death.count = 9
ArcherConfigTab.death.time = 0.4
ArcherConfigTab.death.defaultFileName = "00000.png"

ArcherConfigTab.att1 = {}
ArcherConfigTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
ArcherConfigTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
ArcherConfigTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
ArcherConfigTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
ArcherConfigTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
ArcherConfigTab.att1.begin = 0
ArcherConfigTab.att1.count = 9
ArcherConfigTab.att1.time = 2
ArcherConfigTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
ArcherConfigTab.att1.flySpeed = 400
ArcherConfigTab.att1.cdTime = 2
ArcherConfigTab.att1.defaultFileName = "00000.png"
ArcherConfigTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
ArcherConfigTab.att1.WorldMap_flySpeed = 400

ArcherConfigTab.att2 = {}
ArcherConfigTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
ArcherConfigTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
ArcherConfigTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
ArcherConfigTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
ArcherConfigTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
ArcherConfigTab.att2.begin = 0
ArcherConfigTab.att2.count = 9
ArcherConfigTab.att2.time = 2
ArcherConfigTab.att2.delayAttCheckTime = 0.5  
ArcherConfigTab.att2.flySpeed = 200
ArcherConfigTab.att2.cdTime = 3
ArcherConfigTab.att2.defaultFileName = "00000.png"
ArcherConfigTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
ArcherConfigTab.att2.WorldMap_flySpeed = 400

ArcherConfigTab.effect = {}
ArcherConfigTab.effect.att1 = {}
ArcherConfigTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
ArcherConfigTab.effect.att1.begin = 0
ArcherConfigTab.effect.att1.count = 4
ArcherConfigTab.effect.att1.time = 1
ArcherConfigTab.effect.att1.delayPlayEffectTime = 0.8
ArcherConfigTab.effect.att1.size = {}
ArcherConfigTab.effect.att1.size.width = 15
ArcherConfigTab.effect.att1.size.height = 20
ArcherConfigTab.effect.att1.defaultFileName = "00000.png"
ArcherConfigTab.effect.att1.worldMap_time = 1  

ArcherConfigTab.effect.att2 = {}
ArcherConfigTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
ArcherConfigTab.effect.att2.begin = 0
ArcherConfigTab.effect.att2.count = 5
ArcherConfigTab.effect.att2.time = 1
ArcherConfigTab.effect.att2.delayPlayEffectTime = 0.3
ArcherConfigTab.effect.att2.size = {}
ArcherConfigTab.effect.att2.size.width = 15
ArcherConfigTab.effect.att2.size.height = 20
ArcherConfigTab.effect.att2.defaultFileName = "00000.png"
ArcherConfigTab.effect.att2.worldMap_time = 1  

ArcherConfigTab.effect.hurt1 = {}
ArcherConfigTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
ArcherConfigTab.effect.hurt1.begin = 0
ArcherConfigTab.effect.hurt1.count = 4
ArcherConfigTab.effect.hurt1.time = 0.5
ArcherConfigTab.effect.hurt1.defaultFileName = "00000.png"

ArcherConfigTab.effect.hurt2 = {}
ArcherConfigTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
ArcherConfigTab.effect.hurt2.begin = 0
ArcherConfigTab.effect.hurt2.count = 4
ArcherConfigTab.effect.hurt2.time = 0.5
ArcherConfigTab.effect.hurt2.defaultFileName = "00000.png"



