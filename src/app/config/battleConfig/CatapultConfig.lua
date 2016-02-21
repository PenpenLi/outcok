
--投石车配置

require("app.config.battleConfig.AnimationConfig")

CatapultTab = {}
CatapultTab.moveSpeed = 50   --移动速度
CatapultTab.beRecSize = cc.size(70,74)  --受击区大小
CatapultTab.attack_distance = 400   --攻击距离

CatapultTab.idle = {}
CatapultTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
CatapultTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
CatapultTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
CatapultTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
CatapultTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
CatapultTab.idle.begin = 0
CatapultTab.idle.count = 10
CatapultTab.idle.time = 1
CatapultTab.idle.defaultFileName = "00000.png"

CatapultTab.move = {}
CatapultTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
CatapultTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
CatapultTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
CatapultTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
CatapultTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
CatapultTab.move.begin = 0
CatapultTab.move.count = 10
CatapultTab.move.time = 1
CatapultTab.move.defaultFileName = "00000.png"

CatapultTab.hurt = {}
CatapultTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
CatapultTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
CatapultTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
CatapultTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
CatapultTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
CatapultTab.hurt.begin = 0
CatapultTab.hurt.count = 6
CatapultTab.hurt.time = 0.5
CatapultTab.hurt.defaultFileName = "00000.png"

CatapultTab.death = {}
CatapultTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
CatapultTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
CatapultTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
CatapultTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
CatapultTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
CatapultTab.death.begin = 0
CatapultTab.death.count = 9
CatapultTab.death.time = 0.4
CatapultTab.death.defaultFileName = "00000.png"

CatapultTab.att1 = {}
CatapultTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
CatapultTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
CatapultTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
CatapultTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
CatapultTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
CatapultTab.att1.begin = 0
CatapultTab.att1.count = 9
CatapultTab.att1.time = 2
CatapultTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
CatapultTab.att1.flySpeed = 400
CatapultTab.att1.cdTime = 2
CatapultTab.att1.defaultFileName = "00000.png"
CatapultTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
CatapultTab.att1.WorldMap_flySpeed = 400

CatapultTab.att2 = {}
CatapultTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
CatapultTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
CatapultTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
CatapultTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
CatapultTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
CatapultTab.att2.begin = 0
CatapultTab.att2.count = 9
CatapultTab.att2.time = 2
CatapultTab.att2.delayAttCheckTime = 0.5  
CatapultTab.att2.flySpeed = 200
CatapultTab.att2.cdTime = 3
CatapultTab.att2.defaultFileName = "00000.png"
CatapultTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
CatapultTab.att2.WorldMap_flySpeed = 400

CatapultTab.effect = {}
CatapultTab.effect.att1 = {}
CatapultTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
CatapultTab.effect.att1.begin = 0
CatapultTab.effect.att1.count = 4
CatapultTab.effect.att1.time = 1
CatapultTab.effect.att1.delayPlayEffectTime = 0.8
CatapultTab.effect.att1.size = {}
CatapultTab.effect.att1.size.width = 15
CatapultTab.effect.att1.size.height = 20
CatapultTab.effect.att1.defaultFileName = "00000.png"
CatapultTab.effect.att1.worldMap_time = 1  

CatapultTab.effect.att2 = {}
CatapultTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
CatapultTab.effect.att2.begin = 0
CatapultTab.effect.att2.count = 5
CatapultTab.effect.att2.time = 1
CatapultTab.effect.att2.delayPlayEffectTime = 0.3
CatapultTab.effect.att2.size = {}
CatapultTab.effect.att2.size.width = 15
CatapultTab.effect.att2.size.height = 20
CatapultTab.effect.att2.defaultFileName = "00000.png"
CatapultTab.effect.att2.worldMap_time = 1  

CatapultTab.effect.hurt1 = {}
CatapultTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
CatapultTab.effect.hurt1.begin = 0
CatapultTab.effect.hurt1.count = 4
CatapultTab.effect.hurt1.time = 0.5
CatapultTab.effect.hurt1.defaultFileName = "00000.png"

CatapultTab.effect.hurt2 = {}
CatapultTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
CatapultTab.effect.hurt2.begin = 0
CatapultTab.effect.hurt2.count = 4
CatapultTab.effect.hurt2.time = 0.5
CatapultTab.effect.hurt2.defaultFileName = "00000.png"



