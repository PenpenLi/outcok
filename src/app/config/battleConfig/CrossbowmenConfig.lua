
--弩兵配置

require("app.config.battleConfig.AnimationConfig")

CrossbowmenTab = {}
CrossbowmenTab.moveSpeed = 50   --移动速度
CrossbowmenTab.beRecSize = cc.size(70,74)  --受击区大小
CrossbowmenTab.attack_distance = 400   --攻击距离

CrossbowmenTab.idle = {}
CrossbowmenTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
CrossbowmenTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
CrossbowmenTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
CrossbowmenTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
CrossbowmenTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
CrossbowmenTab.idle.begin = 0
CrossbowmenTab.idle.count = 10
CrossbowmenTab.idle.time = 1
CrossbowmenTab.idle.defaultFileName = "00000.png"

CrossbowmenTab.move = {}
CrossbowmenTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
CrossbowmenTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
CrossbowmenTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
CrossbowmenTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
CrossbowmenTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
CrossbowmenTab.move.begin = 0
CrossbowmenTab.move.count = 10
CrossbowmenTab.move.time = 1
CrossbowmenTab.move.defaultFileName = "00000.png"

CrossbowmenTab.hurt = {}
CrossbowmenTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
CrossbowmenTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
CrossbowmenTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
CrossbowmenTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
CrossbowmenTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
CrossbowmenTab.hurt.begin = 0
CrossbowmenTab.hurt.count = 6
CrossbowmenTab.hurt.time = 0.5
CrossbowmenTab.hurt.defaultFileName = "00000.png"

CrossbowmenTab.death = {}
CrossbowmenTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
CrossbowmenTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
CrossbowmenTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
CrossbowmenTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
CrossbowmenTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
CrossbowmenTab.death.begin = 0
CrossbowmenTab.death.count = 9
CrossbowmenTab.death.time = 0.4
CrossbowmenTab.death.defaultFileName = "00000.png"

CrossbowmenTab.att1 = {}
CrossbowmenTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
CrossbowmenTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
CrossbowmenTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
CrossbowmenTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
CrossbowmenTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
CrossbowmenTab.att1.begin = 0
CrossbowmenTab.att1.count = 9
CrossbowmenTab.att1.time = 2
CrossbowmenTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
CrossbowmenTab.att1.flySpeed = 400
CrossbowmenTab.att1.cdTime = 2
CrossbowmenTab.att1.defaultFileName = "00000.png"
CrossbowmenTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
CrossbowmenTab.att1.WorldMap_flySpeed = 400

CrossbowmenTab.att2 = {}
CrossbowmenTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
CrossbowmenTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
CrossbowmenTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
CrossbowmenTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
CrossbowmenTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
CrossbowmenTab.att2.begin = 0
CrossbowmenTab.att2.count = 9
CrossbowmenTab.att2.time = 2
CrossbowmenTab.att2.delayAttCheckTime = 0.5  
CrossbowmenTab.att2.flySpeed = 200
CrossbowmenTab.att2.cdTime = 3
CrossbowmenTab.att2.defaultFileName = "00000.png"
CrossbowmenTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
CrossbowmenTab.att2.WorldMap_flySpeed = 400

CrossbowmenTab.effect = {}
CrossbowmenTab.effect.att1 = {}
CrossbowmenTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
CrossbowmenTab.effect.att1.begin = 0
CrossbowmenTab.effect.att1.count = 4
CrossbowmenTab.effect.att1.time = 1
CrossbowmenTab.effect.att1.delayPlayEffectTime = 0.8
CrossbowmenTab.effect.att1.size = {}
CrossbowmenTab.effect.att1.size.width = 15
CrossbowmenTab.effect.att1.size.height = 20
CrossbowmenTab.effect.att1.defaultFileName = "00000.png"
CrossbowmenTab.effect.att1.worldMap_time = 1  

CrossbowmenTab.effect.att2 = {}
CrossbowmenTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
CrossbowmenTab.effect.att2.begin = 0
CrossbowmenTab.effect.att2.count = 5
CrossbowmenTab.effect.att2.time = 1
CrossbowmenTab.effect.att2.delayPlayEffectTime = 0.3
CrossbowmenTab.effect.att2.size = {}
CrossbowmenTab.effect.att2.size.width = 15
CrossbowmenTab.effect.att2.size.height = 20
CrossbowmenTab.effect.att2.defaultFileName = "00000.png"
CrossbowmenTab.effect.att2.worldMap_time = 1  

CrossbowmenTab.effect.hurt1 = {}
CrossbowmenTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
CrossbowmenTab.effect.hurt1.begin = 0
CrossbowmenTab.effect.hurt1.count = 4
CrossbowmenTab.effect.hurt1.time = 0.5
CrossbowmenTab.effect.hurt1.defaultFileName = "00000.png"

CrossbowmenTab.effect.hurt2 = {}
CrossbowmenTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
CrossbowmenTab.effect.hurt2.begin = 0
CrossbowmenTab.effect.hurt2.count = 4
CrossbowmenTab.effect.hurt2.time = 0.5
CrossbowmenTab.effect.hurt2.defaultFileName = "00000.png"



