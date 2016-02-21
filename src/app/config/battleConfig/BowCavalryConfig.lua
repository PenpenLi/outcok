
--弓骑兵配置

require("app.config.battleConfig.AnimationConfig")

BowCavalryTab = {}
BowCavalryTab.moveSpeed = 50   --移动速度
BowCavalryTab.beRecSize = cc.size(70,74)  --受击区大小
BowCavalryTab.attack_distance = 400   --攻击距离

BowCavalryTab.idle = {}
BowCavalryTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
BowCavalryTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
BowCavalryTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
BowCavalryTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
BowCavalryTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
BowCavalryTab.idle.begin = 0
BowCavalryTab.idle.count = 10
BowCavalryTab.idle.time = 1
BowCavalryTab.idle.defaultFileName = "00000.png"

BowCavalryTab.move = {}
BowCavalryTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
BowCavalryTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
BowCavalryTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
BowCavalryTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
BowCavalryTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
BowCavalryTab.move.begin = 0
BowCavalryTab.move.count = 10
BowCavalryTab.move.time = 1
BowCavalryTab.move.defaultFileName = "00000.png"

BowCavalryTab.hurt = {}
BowCavalryTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
BowCavalryTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
BowCavalryTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
BowCavalryTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
BowCavalryTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
BowCavalryTab.hurt.begin = 0
BowCavalryTab.hurt.count = 6
BowCavalryTab.hurt.time = 0.5
BowCavalryTab.hurt.defaultFileName = "00000.png"

BowCavalryTab.death = {}
BowCavalryTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
BowCavalryTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
BowCavalryTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
BowCavalryTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
BowCavalryTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
BowCavalryTab.death.begin = 0
BowCavalryTab.death.count = 9
BowCavalryTab.death.time = 0.4
BowCavalryTab.death.defaultFileName = "00000.png"

BowCavalryTab.att1 = {}
BowCavalryTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
BowCavalryTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
BowCavalryTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
BowCavalryTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
BowCavalryTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
BowCavalryTab.att1.begin = 0
BowCavalryTab.att1.count = 9
BowCavalryTab.att1.time = 2
BowCavalryTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
BowCavalryTab.att1.flySpeed = 400
BowCavalryTab.att1.cdTime = 2
BowCavalryTab.att1.defaultFileName = "00000.png"
BowCavalryTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
BowCavalryTab.att1.WorldMap_flySpeed = 400

BowCavalryTab.att2 = {}
BowCavalryTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
BowCavalryTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
BowCavalryTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
BowCavalryTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
BowCavalryTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
BowCavalryTab.att2.begin = 0
BowCavalryTab.att2.count = 9
BowCavalryTab.att2.time = 2
BowCavalryTab.att2.delayAttCheckTime = 0.5  
BowCavalryTab.att2.flySpeed = 200
BowCavalryTab.att2.cdTime = 3
BowCavalryTab.att2.defaultFileName = "00000.png"
BowCavalryTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
BowCavalryTab.att2.WorldMap_flySpeed = 400

BowCavalryTab.effect = {}
BowCavalryTab.effect.att1 = {}
BowCavalryTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
BowCavalryTab.effect.att1.begin = 0
BowCavalryTab.effect.att1.count = 4
BowCavalryTab.effect.att1.time = 1
BowCavalryTab.effect.att1.delayPlayEffectTime = 0.8
BowCavalryTab.effect.att1.size = {}
BowCavalryTab.effect.att1.size.width = 15
BowCavalryTab.effect.att1.size.height = 20
BowCavalryTab.effect.att1.defaultFileName = "00000.png"
BowCavalryTab.effect.att1.worldMap_time = 1  

BowCavalryTab.effect.att2 = {}
BowCavalryTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
BowCavalryTab.effect.att2.begin = 0
BowCavalryTab.effect.att2.count = 5
BowCavalryTab.effect.att2.time = 1
BowCavalryTab.effect.att2.delayPlayEffectTime = 0.3
BowCavalryTab.effect.att2.size = {}
BowCavalryTab.effect.att2.size.width = 15
BowCavalryTab.effect.att2.size.height = 20
BowCavalryTab.effect.att2.defaultFileName = "00000.png"
BowCavalryTab.effect.att2.worldMap_time = 1  

BowCavalryTab.effect.hurt1 = {}
BowCavalryTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
BowCavalryTab.effect.hurt1.begin = 0
BowCavalryTab.effect.hurt1.count = 4
BowCavalryTab.effect.hurt1.time = 0.5
BowCavalryTab.effect.hurt1.defaultFileName = "00000.png"

BowCavalryTab.effect.hurt2 = {}
BowCavalryTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
BowCavalryTab.effect.hurt2.begin = 0
BowCavalryTab.effect.hurt2.count = 4
BowCavalryTab.effect.hurt2.time = 0.5
BowCavalryTab.effect.hurt2.defaultFileName = "00000.png"



