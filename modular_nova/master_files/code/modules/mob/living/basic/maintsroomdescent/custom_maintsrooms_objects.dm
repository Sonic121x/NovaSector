/obj/structure/curtain/cloth/fancy/mechanical/start_closed/maints_finale
	name = "各位，今天就到这里吧！"
	desc = "你感觉仿佛刚刚结束了一场盛大的终幕演出，而现在帷幕正在落下。"

/turf/closed/indestructible/oldshuttle/pure_white
	name = "纯白"
	desc = "你感觉自己正望向一片广阔得不可思议的地平线，远处可以看到排列整齐、样式规整的白色大理石柱，它们向上延伸，不断向上，直到你必须几乎垂直抬头才能看到离你最近的那些柱子。顺着走廊望去，你能看到的距离远超一个凡人所想。"

/obj/machinery/porta_turret/syndicate/shuttle/bar_defense
	faction = list("neutral","Deathsquad")
	max_integrity = 1000
	name = "酒吧防御炮塔"

/obj/item/storage/backpack/industrial/frontier_colonist/military_grade_backpack
	name = "军用背包"
	desc = "一种常被定居者和探险者使用的耐用背包。它是防火的，这个上面有军队徽章。"
	storage_type = /datum/storage/duffel

/mob/living/basic/trooper/nanotrasen/ranged/elite/seargent_crowlie
	name = "克劳利中士"
	desc = "他站在那里，望着这个人工穹顶海滩的水面，他完全静止不动——直到他听到你的声音，便立刻摆出战斗姿态并开始开火。"
	health = 2000
	maxHealth = 2000
	loot = list(/obj/item/keycard/crowlie)

/obj/machinery/door/poddoor/shutters/window/indestructible/maints_armory
	name = "军械库"
	desc = "一扇带有厚实透明聚碳酸酯窗户的百叶窗，你觉得闯入这里不会值得你花时间。"

/obj/structure/showcase/mecha/marauder/fakeout
	name = "战斗机甲"
	desc = "一架近乎完好、傲然挺立的战斗机甲，这会是绝妙的兜风工具……如果你能打开这些百叶窗的话。"

/obj/structure/showcase/mecha/marauder/fakeout/command
	name = "指挥型战斗机甲"
	icon_state = "seraph"

/obj/machinery/porta_turret/syndicate/hc_police/ancient_milsim/garrison_turret
	name = "反人员炮塔"
	desc = "一种改装的点防御炮塔，通常用于拦截射向小型飞船的重型射弹或大型导弹——想象一下它对你会有何效果。"
	faction = list("hostile","cult")

/mob/living/basic/trooper/syndicate/ranged/smg/pilot/super_american
	name = "超级美国人"
	health = 400
	maxHealth = 400
	environment_smash = 0
	desc = "美国，操他妈的耶，再次前来拯救这操蛋的一天！美国操他妈的耶！自由是唯一的道路！恐怖分子你们的游戏结束了，因为现在你们必须向——美国，操他妈的耶！——交代！"

/mob/living/basic/trooper/syndicate/ranged/smg/anthro/ambush_moth
	name = "伏击蛾"

/obj/item/shield/buckler/reagent_weapon/pavise/stalwart_defense
	name = "坚毅防御"
	slowdown = 4
	block_chance = 65
	max_integrity = 2000

/obj/item/paper/carbon/rare_pepe
	name = "怪异拟人青蛙海报"
	desc = "一张画着奇怪青蛙的海报，它正咧嘴笑着。"
	icon = 'modular_nova/modules/clock_cult/icons/clockwork_objects.dmi'
	icon_state = "rare_pepe"
