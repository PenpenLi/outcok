
--冲车配置

require("app.config.battleConfig.AnimationConfig")

TankTab = {}
TankTab.moveSpeed = 50   --移动速度
TankTab.beRecSize = cc.size(70,74)  --受击区大小
TankTab.attack_distance = 400   --攻击距离

TankTab.idle = {}
TankTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
TankTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
TankTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
TankTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
TankTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
TankTab.idle.begin = 0
TankTab.idle.count = 10
TankTab.idle.time = 1
TankTab.idle.defaultFileName = "00000.png"

TankTab.move = {}
TankTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
TankTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
TankTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
TankTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
TankTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
TankTab.move.begin = 0
TankTab.move.count = 10
TankTab.move.time = 1
TankTab.move.defaultFileName = "00000.png"

TankTab.hurt = {}
TankTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
TankTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
TankTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
TankTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
TankTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
TankTab.hurt.begin = 0
TankTab.hurt.count = 6
TankTab.hurt.time = 0.5
TankTab.hurt.defaultFileName = "00000.png"

TankTab.death = {}
TankTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
TankTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
TankTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
TankTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
TankTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
TankTab.death.begin = 0
TankTab.death.count = 9
TankTab.death.time = 0.4
TankTab.death.defaultFileName = "00000.png"

TankTab.att1 = {}
TankTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
TankTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
TankTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
TankTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
TankTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
TankTab.att1.begin = 0
TankTab.att1.count = 9
TankTab.att1.time = 2
TankTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
TankTab.att1.flySpeed = 200
TankTab.att1.cdTime = 2
TankTab.att1.defaultFileName = "00000.png"
TankTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
TankTab.att1.WorldMap_flySpeed = 400

TankTab.att2 = {}
TankTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
TankTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
TankTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
TankTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
TankTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
TankTab.att2.begin = 0
TankTab.att2.count = 9
TankTab.att2.time = 2
TankTab.att2.delayAttCheckTime = 0.5  
TankTab.att2.flySpeed = 400
TankTab.att2.cdTime = 3
TankTab.att2.defaultFileName = "00000.png"
TankTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
TankTab.att2.WorldMap_flySpeed = 400

TankTab.effect = {}
TankTab.effect.att1 = {}
TankTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
TankTab.effect.att1.begin = 0
TankTab.effect.att1.count = 4
TankTab.effect.att1.time = 1
TankTab.effect.att1.delayPlayEffectTime = 0.8
TankTab.effect.att1.size = {}
TankTab.effect.att1.size.width = 15
TankTab.effect.att1.size.height = 20
TankTab.effect.att1.defaultFileName = "00000.png"
TankTab.effect.att1.worldMap_time = 1  

TankTab.effect.att2 = {}
TankTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
TankTab.effect.att2.begin = 0
TankTab.effect.att2.count = 5
TankTab.effect.att2.time = 1
TankTab.effect.att2.delayPlayEffectTime = 0.3
TankTab.effect.att2.size = {}
TankTab.effect.att2.size.width = 15
TankTab.effect.att2.size.height = 20
TankTab.effect.att2.defaultFileName = "00000.png"
TankTab.effect.att2.worldMap_time = 1  

TankTab.effect.hurt1 = {}
TankTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
TankTab.effect.hurt1.begin = 0
TankTab.effect.hurt1.count = 4
TankTab.effect.hurt1.time = 0.5
TankTab.effect.hurt1.defaultFileName = "00000.png"

TankTab.effect.hurt2 = {}
TankTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
TankTab.effect.hurt2.begin = 0
TankTab.effect.hurt2.count = 4
TankTab.effect.hurt2.time = 0.5
TankTab.effect.hurt2.defaultFileName = "00000.png"



