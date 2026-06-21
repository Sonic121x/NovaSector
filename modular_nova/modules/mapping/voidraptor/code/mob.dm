/mob/living/basic/lizard/tegu
	name = "泰加蜥"
	desc = "那是一只泰加蜥。"
	icon = 'modular_nova/master_files/icons/mob/pets.dmi'
	icon_state = "tegu"
	icon_living = "tegu"
	icon_dead = "tegu_dead"
	health = 20
	maxHealth = 20
	melee_damage_lower = 16 //They do have a nasty bite
	melee_damage_upper = 16
	pass_flags = PASSTABLE

/mob/living/basic/lizard/tegu/gus
	name = "格斯"
	real_name = "Gus"
	desc = "研究部门心爱的宠物泰加蜥。"
	gender = MALE
	gold_core_spawnable = NO_SPAWN

/mob/living/basic/crab/shuffle
	name = "沙弗尔"
	real_name = "Shuffle"
	desc = "哦不，是他！"
	color = "#ff0000"
	gender = MALE
	gold_core_spawnable = NO_SPAWN

/mob/living/basic/crab/shuffle/Initialize(mapload)
	. = ..()
	update_transform(0.5)

/mob/living/basic/carp/mega/shorki
	name = "肖尔基"
	desc = "一种并非那么凶猛、长着尖牙、形似鲨鱼的生物。这只看起来对于它的水箱来说有点太大了。"
	faction = list(FACTION_NEUTRAL)
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/carp/pet

/mob/living/basic/carp/mega/shorki/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/pet_bonus, "bloops happily!")
	name = initial(name)
	real_name = initial(name)

/mob/living/basic/pet/gondola/funky
	name = "芬奇"
	real_name = "Funky"
	desc = "冈多拉是沉默的行者。没有双手的他体现了道家的无为原则，而他微笑的面部表情则显示了他对世界现状的完全接纳。它的皮毛极其珍贵。这只看起来有点瘦，并且依恋着剧院。"
	loot = list(/obj/effect/decal/cleanable/blood/gibs)

/mob/living/basic/pet/dog/dobermann/walter
	name = "沃尔特"
	real_name = "Walter"
	desc = "这是沃尔特，它咬罪犯和咬幼儿一样在行。"

/mob/living/basic/rabbit/daisy
	name = "黛西"
	real_name = "Daisy"
	desc = "馆长的宠物兔兔。"
	gender = FEMALE

/mob/living/basic/bear/wojtek
	name = "沃伊泰克"
	real_name = "Wojtek"
	desc = "蓝空火炮的承载者。"
	faction = list(FACTION_NEUTRAL)
	gender = MALE

/mob/living/basic/chicken/teshari
	name = "特沙里"
	real_name = "Teshari"
	desc = "永恒的经典。"
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = 30000
