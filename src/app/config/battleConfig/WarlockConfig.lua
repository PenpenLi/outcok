
--术士配置

require("app.config.battleConfig.AnimationConfig")

WarlockTab = {}
WarlockTab.moveSpeed = 50   --移动速度
WarlockTab.beRecSize = cc.size(70,74)  --受击区大小
WarlockTab.attack_distance = 400   --攻击距离

WarlockTab.idle = {}
WarlockTab.idle[ANMATION_DIR.UP] = "idle/gongshou_idle_1_"
WarlockTab.idle[ANMATION_DIR.RIGHT_UP] = "idle/gongshou_idle_2_"
WarlockTab.idle[ANMATION_DIR.RIGHT] = "idle/gongshou_idle_3_"
WarlockTab.idle[ANMATION_DIR.RIGHT_DOWN] = "idle/gongshou_idle_4_"
WarlockTab.idle[ANMATION_DIR.DOWN] = "idle/gongshou_idle_5_"
WarlockTab.idle.begin = 0
WarlockTab.idle.count = 10
WarlockTab.idle.time = 1
WarlockTab.idle.defaultFileName = "00000.png"

WarlockTab.move = {}
WarlockTab.move[ANMATION_DIR.UP] = "move/gongshou_run_1_"
WarlockTab.move[ANMATION_DIR.RIGHT_UP] = "move/gongshou_run_2_"
WarlockTab.move[ANMATION_DIR.RIGHT] = "move/gongshou_run_3_"
WarlockTab.move[ANMATION_DIR.RIGHT_DOWN] = "move/gongshou_run_4_"
WarlockTab.move[ANMATION_DIR.DOWN] = "move/gongshou_run_5_"
WarlockTab.move.begin = 0
WarlockTab.move.count = 10
WarlockTab.move.time = 1
WarlockTab.move.defaultFileName = "00000.png"

WarlockTab.hurt = {}
WarlockTab.hurt[ANMATION_DIR.UP] = "hurt/gongshou_hit_1_"
WarlockTab.hurt[ANMATION_DIR.RIGHT_UP] = "hurt/gongshou_hit_2_"
WarlockTab.hurt[ANMATION_DIR.RIGHT] = "hurt/gongshou_hit_3_"
WarlockTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "hurt/gongshou_hit_4_"
WarlockTab.hurt[ANMATION_DIR.DOWN] = "hurt/gongshou_hit_5_"
WarlockTab.hurt.begin = 0
WarlockTab.hurt.count = 6
WarlockTab.hurt.time = 0.5
WarlockTab.hurt.defaultFileName = "00000.png"

WarlockTab.death = {}
WarlockTab.death[ANMATION_DIR.UP] = "death/gongshou_die_1_"
WarlockTab.death[ANMATION_DIR.RIGHT_UP] = "death/gongshou_die_2_"
WarlockTab.death[ANMATION_DIR.RIGHT] = "death/gongshou_die_3_"
WarlockTab.death[ANMATION_DIR.RIGHT_DOWN] = "death/gongshou_die_4_"
WarlockTab.death[ANMATION_DIR.DOWN] = "death/gongshou_die_5_"
WarlockTab.death.begin = 0
WarlockTab.death.count = 9
WarlockTab.death.time = 0.4
WarlockTab.death.defaultFileName = "00000.png"

WarlockTab.att1 = {}
WarlockTab.att1[ANMATION_DIR.UP] = "att1/gongshou_attack1_1_"
WarlockTab.att1[ANMATION_DIR.RIGHT_UP] = "att1/gongshou_attack1_2_"
WarlockTab.att1[ANMATION_DIR.RIGHT] = "att1/gongshou_attack1_3_"
WarlockTab.att1[ANMATION_DIR.RIGHT_DOWN] = "att1/gongshou_attack1_4_"
WarlockTab.att1[ANMATION_DIR.DOWN] = "att1/gongshou_attack1_5_"
WarlockTab.att1.begin = 0
WarlockTab.att1.count = 9
WarlockTab.att1.time = 2
WarlockTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
WarlockTab.att1.flySpeed = 400
WarlockTab.att1.cdTime = 2
WarlockTab.att1.defaultFileName = "00000.png"
WarlockTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
WarlockTab.att1.WorldMap_flySpeed = 400

WarlockTab.att2 = {}
WarlockTab.att2[ANMATION_DIR.UP] = "att2/gongshou_attack2_1_"
WarlockTab.att2[ANMATION_DIR.RIGHT_UP] = "att2/gongshou_attack2_2_"
WarlockTab.att2[ANMATION_DIR.RIGHT] = "att2/gongshou_attack2_3_"
WarlockTab.att2[ANMATION_DIR.RIGHT_DOWN] = "att2/gongshou_attack2_4_"
WarlockTab.att2[ANMATION_DIR.DOWN] = "att2/gongshou_attack2_5_"
WarlockTab.att2.begin = 0
WarlockTab.att2.count = 9
WarlockTab.att2.time = 2
WarlockTab.att2.delayAttCheckTime = 0.5  
WarlockTab.att2.flySpeed = 200
WarlockTab.att2.cdTime = 3
WarlockTab.att2.defaultFileName = "00000.png"
WarlockTab.att2.worldMap_time = 1   --地图上的AI攻击时间配置
WarlockTab.att2.WorldMap_flySpeed = 400

WarlockTab.effect = {}
WarlockTab.effect.att1 = {}
WarlockTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
WarlockTab.effect.att1.begin = 0
WarlockTab.effect.att1.count = 4
WarlockTab.effect.att1.time = 1
WarlockTab.effect.att1.delayPlayEffectTime = 0.8
WarlockTab.effect.att1.size = {}
WarlockTab.effect.att1.size.width = 15
WarlockTab.effect.att1.size.height = 20
WarlockTab.effect.att1.defaultFileName = "00000.png"
WarlockTab.effect.att1.worldMap_time = 1  

WarlockTab.effect.att2 = {}
WarlockTab.effect.att2.path = "effect/skill/e_gongshou_flyer_2_"
WarlockTab.effect.att2.begin = 0
WarlockTab.effect.att2.count = 5
WarlockTab.effect.att2.time = 1
WarlockTab.effect.att2.delayPlayEffectTime = 0.3
WarlockTab.effect.att2.size = {}
WarlockTab.effect.att2.size.width = 15
WarlockTab.effect.att2.size.height = 20
WarlockTab.effect.att2.defaultFileName = "00000.png"
WarlockTab.effect.att2.worldMap_time = 1  

WarlockTab.effect.hurt1 = {}
WarlockTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
WarlockTab.effect.hurt1.begin = 0
WarlockTab.effect.hurt1.count = 4
WarlockTab.effect.hurt1.time = 0.5
WarlockTab.effect.hurt1.defaultFileName = "00000.png"

WarlockTab.effect.hurt2 = {}
WarlockTab.effect.hurt2.path = "effect/skillhurt/e_gongshou_hit_2_"
WarlockTab.effect.hurt2.begin = 0
WarlockTab.effect.hurt2.count = 4
WarlockTab.effect.hurt2.time = 0.5
WarlockTab.effect.hurt2.defaultFileName = "00000.png"



