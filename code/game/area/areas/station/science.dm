/area/station/science
	name = "\improper 科学部"
	icon_state = "science"
	airlock_wires = /datum/wires/airlock/science
	sound_environment = SOUND_AREA_STANDARD_STATION
	tacmap_color = TACMAP_AREA_SCIENCE

/area/station/science/lobby
	name = "\improper 科学部大厅"
	icon_state = "science_lobby"

/area/station/science/lower
	name = "\improper 下层科学部"
	icon_state = "lower_science"

/area/station/science/breakroom
	name = "\improper 科学部休息室"
	icon_state = "science_breakroom"

/area/station/science/lab
	name = "研发实验室"
	icon_state = "research"

/area/station/science/xenobiology
	name = "\improper 异种生物学实验室"
	icon_state = "xenobio"

/area/station/science/xenobiology/hallway
	name = "\improper 异种生物学走廊"
	icon_state = "xenobio_hall"

/area/station/science/cytology
	name = "\improper 细胞学实验室"
	icon_state = "cytology"

/area/station/science/cubicle
	name = "\improper 科学部隔间"
	icon_state = "science"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/science/genetics
	name = "\improper 遗传学实验室"
	icon_state = "geneticssci"

/area/station/science/server
	name = "\improper 研究部服务器机房"
	icon_state = "server"

/area/station/science/circuits
	name = "\improper 电路实验室"
	icon_state = "cir_lab"

/area/station/science/explab
	name = "\improper 实验实验室"
	icon_state = "exp_lab"

/area/station/science/auxlab
	name = "\improper 辅助实验室"
	icon_state = "aux_lab"

/area/station/science/auxlab/firing_range
	name = "\improper 研究射击场"

/area/station/science/robotics
	name = "机器人学"
	icon_state = "robotics"

/area/station/science/robotics/mechbay
	name = "\improper 机甲舱"
	icon_state = "mechbay"

/area/station/science/robotics/lab
	name = "\improper 机器人学实验室"
	icon_state = "ass_line"

/area/station/science/robotics/storage
	name = "\improper 机器人学储藏室"
	icon_state = "ass_line"

/area/station/science/robotics/augments
	name = "\improper 增强手术室"
	icon_state = "robotics"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/station/science/research
	name = "\improper 研究部"
	icon_state = "science"

/area/station/science/research/abandoned
	name = "\improper 废弃研究实验室"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/science/zoo
	name = "\improper 科学公共动物园"
	icon_state = "cytology"

/*
* Ordnance Areas
*/

// Use this for the main lab. If test equipment, storage, etc is also present use this one too.
/area/station/science/ordnance
	name = "\improper 军械实验室"
	icon_state = "ord_main"

/area/station/science/ordnance/office
	name = "\improper 军械办公室"
	icon_state = "ord_office"

/area/station/science/ordnance/storage
	name = "\improper 军械储藏室"
	icon_state = "ord_storage"

/area/station/science/ordnance/burnchamber
	name = "\improper 军械燃烧室"
	icon_state = "ord_burn"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

/area/station/science/ordnance/freezerchamber
	name = "\improper 军械冷冻室"
	icon_state = "ord_freeze"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

// Room for equipments and such
/area/station/science/ordnance/testlab
	name = "\improper 军械测试实验室"
	icon_state = "ord_test"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

/area/station/science/ordnance/bomb
	name = "\improper 军械炸弹试验场"
	icon_state = "ord_boom"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED | NO_GRAVITY
	skip_minimap_rendering = TRUE

/area/station/science/ordnance/bomb/planet
	area_flags = /area/station/science/ordnance/bomb::area_flags & ~NO_GRAVITY
