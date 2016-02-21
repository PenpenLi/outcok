
--骑士配置

require("app.config.battleConfig.AnimationConfig")

KnightTab = {}
KnightTab.moveSpeed = 100   --移动速度
KnightTab.beRecSize = cc.size(70,74)  --受击区大小
KnightTab.attack_distance = 70   --攻击距离

KnightTab.idle = {}
KnightTab.idle[ANMATION_DIR.UP] = "tuoer_idle_1_"
KnightTab.idle[ANMATION_DIR.RIGHT_UP] = "tuoer_idle_2_"
KnightTab.idle[ANMATION_DIR.RIGHT] = "tuoer_idle_3_"
KnightTab.idle[ANMATION_DIR.RIGHT_DOWN] = "tuoer_idle_4_"
KnightTab.idle[ANMATION_DIR.DOWN] = "tuoer_idle_5_"
KnightTab.idle.begin = 0
KnightTab.idle.count = 10
KnightTab.idle.time = 1
KnightTab.idle.defaultFileName = "00000.png"

KnightTab.move = {}
KnightTab.move[ANMATION_DIR.UP] = "tuoer_run_1_"
KnightTab.move[ANMATION_DIR.RIGHT_UP] = "tuoer_run_2_"
KnightTab.move[ANMATION_DIR.RIGHT] = "tuoer_run_3_"
KnightTab.move[ANMATION_DIR.RIGHT_DOWN] = "tuoer_run_4_"
KnightTab.move[ANMATION_DIR.DOWN] = "tuoer_run_5_"
KnightTab.move.begin = 0
KnightTab.move.count = 10
KnightTab.move.time = 1
KnightTab.move.defaultFileName = "00000.png"

KnightTab.hurt = {}
KnightTab.hurt[ANMATION_DIR.UP] = "tuoer_hit_1_"
KnightTab.hurt[ANMATION_DIR.RIGHT_UP] = "tuoer_hit_2_"
KnightTab.hurt[ANMATION_DIR.RIGHT] = "tuoer_hit_3_"
KnightTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "tuoer_hit_4_"
KnightTab.hurt[ANMATION_DIR.DOWN] = "tuoer_hit_5_"
KnightTab.hurt.begin = 0
KnightTab.hurt.count = 6
KnightTab.hurt.time = 0.5
KnightTab.hurt.defaultFileName = "00000.png"

KnightTab.death = {}
KnightTab.death[ANMATION_DIR.UP] = "tuoer_die_1_"
KnightTab.death[ANMATION_DIR.RIGHT_UP] = "tuoer_die_2_"
KnightTab.death[ANMATION_DIR.RIGHT] = "tuoer_die_3_"
KnightTab.death[ANMATION_DIR.RIGHT_DOWN] = "tuoer_die_4_"
KnightTab.death[ANMATION_DIR.DOWN] = "tuoer_die_5_"
KnightTab.death.begin = 0
KnightTab.death.count = 8
KnightTab.death.time = 0.4
KnightTab.death.defaultFileName = "00000.png"

KnightTab.att1 = {}
KnightTab.att1[ANMATION_DIR.UP] = "tuoer_attack1_1_"
KnightTab.att1[ANMATION_DIR.RIGHT_UP] = "tuoer_attack1_2_"
KnightTab.att1[ANMATION_DIR.RIGHT] = "tuoer_attack1_3_"
KnightTab.att1[ANMATION_DIR.RIGHT_DOWN] = "tuoer_attack1_4_"
KnightTab.att1[ANMATION_DIR.DOWN] = "tuoer_attack1_5_"
KnightTab.att1.begin = 0
KnightTab.att1.count = 9
KnightTab.att1.time = 2
KnightTab.att1.delayAttCheckTime = 0.5
KnightTab.att1.cdTime = 2
KnightTab.att1.defaultFileName = "00000.png"
KnightTab.att1.worldMap_time = 1 

KnightTab.att2 = {}
KnightTab.att2[ANMATION_DIR.UP] = "tuoer_attack2_1_"
KnightTab.att2[ANMATION_DIR.RIGHT_UP] = "tuoer_attack2_2_"
KnightTab.att2[ANMATION_DIR.RIGHT] = "tuoer_attack2_3_"
KnightTab.att2[ANMATION_DIR.RIGHT_DOWN] = "tuoer_attack2_4_"
KnightTab.att2[ANMATION_DIR.DOWN] = "tuoer_attack2_5_"
KnightTab.att2.begin = 0
KnightTab.att2.count = 11
KnightTab.att2.time = 2
KnightTab.att2.delayAttCheckTime = 0.5
KnightTab.att2.cdTime = 2
KnightTab.att2.defaultFileName = "00000.png"
KnightTab.att2.worldMap_time = 1 

KnightTab.effect = {}
KnightTab.effect.att1 = {}
KnightTab.effect.att1[ANMATION_DIR.UP] = "e_tuoer_attack1_1_"
KnightTab.effect.att1[ANMATION_DIR.RIGHT_UP] = "e_tuoer_attack1_2_"
KnightTab.effect.att1[ANMATION_DIR.RIGHT] = "e_tuoer_attack1_3_"
KnightTab.effect.att1[ANMATION_DIR.RIGHT_DOWN] = "e_tuoer_attack1_4_"
KnightTab.effect.att1[ANMATION_DIR.DOWN] = "e_tuoer_attack1_5_"
KnightTab.effect.att1.begin = 0
KnightTab.effect.att1.count = 12
KnightTab.effect.att1.time = 2
KnightTab.effect.att1.delayPlayEffectTime = 0
KnightTab.effect.att1.size = {}
KnightTab.effect.att1.size.width = 15
KnightTab.effect.att1.size.height = 20
KnightTab.effect.att1.defaultFileName = "00000.png"
KnightTab.effect.att1.worldMap_time = 1  

KnightTab.effect.att2 = {}
KnightTab.effect.att2[ANMATION_DIR.UP] = "e_tuoer_attack2_1_"
KnightTab.effect.att2[ANMATION_DIR.RIGHT_UP] = "e_tuoer_attack2_2_"
KnightTab.effect.att2[ANMATION_DIR.RIGHT] = "e_tuoer_attack2_3_"
KnightTab.effect.att2[ANMATION_DIR.RIGHT_DOWN] = "e_tuoer_attack2_4_"
KnightTab.effect.att2[ANMATION_DIR.DOWN] = "e_tuoer_attack2_5_"
KnightTab.effect.att2.begin = 0
KnightTab.effect.att2.count = 11
KnightTab.effect.att2.time = 2
KnightTab.effect.att2.delayPlayEffectTime = 0
KnightTab.effect.att2.size = {}
KnightTab.effect.att2.size.width = 15
KnightTab.effect.att2.size.height = 20
KnightTab.effect.att2.defaultFileName = "00000.png"
KnightTab.effect.att2.worldMap_time = 1  

KnightTab.effect.hurt1 = {}
KnightTab.effect.hurt1.path = "et_magichero_lv1_hit_"
KnightTab.effect.hurt1.begin = 0
KnightTab.effect.hurt1.count = 6
KnightTab.effect.hurt1.time = 0.5
KnightTab.effect.hurt1.defaultFileName = "00000.png"

