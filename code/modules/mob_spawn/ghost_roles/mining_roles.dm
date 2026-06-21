
//lava hermit

//Malfunctioning cryostasis sleepers: Spawns in makeshift shelters in lavaland. Ghosts become hermits with knowledge of how they got to where they are now.
/obj/effect/mob_spawn/ghost_role/human/hermit
	name = "故障的低温停滞休眠舱"
	desc = "一个嗡嗡作响的休眠舱，内有轮廓模糊的居住者。其停滞功能已损坏，很可能被当作床铺使用。"
	prompt_name = "一名被困的隐士"
	icon = 'icons/obj/mining_zones/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/hermit
	you_are_text = "你被困在这个如监狱般无神的星球上，时间久到你自己都记不清了。"
	flavour_text = "Each day you barely scrape by, and between the terrible conditions of your makeshift shelter, \
	the hostile creatures, and the ash drakes swooping down from the cloudless skies, all you can wish for is the feel of soft grass between your toes and \
	the fresh air of Earth. These thoughts are dispelled by yet another recollection of how you got here... "
	spawner_job_path = /datum/job/hermit
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/hermit/Initialize(mapload)
	. = ..()
	outfit = new outfit //who cares equip outfit works with outfit as a path or an instance
	var/arrpee = rand(1,4)
	switch(arrpee)
		if(1)
			flavour_text += "you were a [pick("arms dealer", "shipwright", "docking manager")]'s assistant on a small trading station several sectors from here. Raiders attacked, and there was \
			only one pod left when you got to the escape bay. You took it and launched it alone, and the crowd of terrified faces crowding at the airlock door as your pod's engines burst to \
			life and sent you to this hell are forever branded into your memory."
			outfit.uniform = /obj/item/clothing/under/misc/assistantformal
		if(2)
			flavour_text += "you're an exile from the Tiger Cooperative. Their technological fanaticism drove you to question the power and beliefs of the Exolitics, and they saw you as a \
			heretic and subjected you to hours of horrible torture. You were hours away from execution when a high-ranking friend of yours in the Cooperative managed to secure you a pod, \
			scrambled its destination's coordinates, and launched it. You awoke from stasis when you landed and have been surviving - barely - ever since."
			outfit.uniform = /obj/item/clothing/under/rank/prisoner
			outfit.shoes = /obj/item/clothing/shoes/sneakers/orange
		if(3)
			flavour_text += "you were a doctor on one of Nanotrasen's space stations, but you left behind that damn corporation's tyranny and everything it stood for. From a metaphorical hell \
			to a literal one, you find yourself nonetheless missing the recycled air and warm floors of what you left behind... but you'd still rather be here than there."
			outfit.uniform = /obj/item/clothing/under/rank/medical/doctor
			outfit.suit = /obj/item/clothing/suit/toggle/labcoat
			outfit.back = /obj/item/storage/backpack/medic
		if(4)
			flavour_text += "you were always joked about by your friends for \"not playing with a full deck\", as they so kindly put it. It seems that they were right when you, on a tour \
			at one of Nanotrasen's state-of-the-art research facilities, were in one of the escape pods alone and saw the red button. It was big and shiny, and it caught your eye. You pressed \
			it, and after a terrifying and fast ride for days, you landed here. You've had time to wisen up since then, and you think that your old friends wouldn't be laughing now."

/obj/effect/mob_spawn/ghost_role/human/hermit/Destroy()
	new/obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()

/datum/outfit/hermit
	name = "熔岩地隐士"
	uniform = /obj/item/clothing/under/color/grey/ancient
	back = /obj/item/storage/backpack
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/tank/internals/emergency_oxygen
	r_pocket = /obj/item/flashlight/glowstick

//Icebox version of hermit
/obj/effect/mob_spawn/ghost_role/human/hermit/icemoon
	name = "低温停滞床铺"
	desc = "一个嗡嗡作响的休眠舱，内有轮廓模糊的居住者。其停滞功能已损坏，很可能被当作床铺使用。"
	prompt_name = "一个脾气暴躁的老头"
	icon = 'icons/obj/mining_zones/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	outfit = /datum/outfit/hermit
	you_are_text = "你猎杀北极熊已经40年了！这些'纳米传讯'新来者想要什么？"
	flavour_text = "You were fine hunting polar bears and taming wolves out here on your own, \
		but now that there are corporate stooges around, you need to watch your step. "
	spawner_job_path = /datum/job/hermit

//beach dome

/obj/effect/mob_spawn/ghost_role/human/beach
	prompt_name = "a beach bum"
	name = "海滩流浪汉休眠舱"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	you_are_text = "你，就像，完全是个潮男，兄弟。"
	flavour_text = "Ch'yea. You came here, like, on spring break, hopin' to pick up some bangin' hot chicks, y'knaw?"
	spawner_job_path = /datum/job/beach_bum
	outfit = /datum/outfit/beachbum
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/beach/lifeguard
	you_are_text = "你是个精力充沛的救生员！"
	flavour_text = "确保没人溺水或被鲨鱼之类的东西吃掉，就靠你了。"
	name = "救生员休眠舱"
	outfit = /datum/outfit/beachbum/lifeguard
	allow_custom_character = NONE

/obj/effect/mob_spawn/ghost_role/human/beach/lifeguard/special(mob/living/carbon/human/lifeguard, mob/mob_possessor, apply_prefs)
	. = ..()
	lifeguard.gender = FEMALE
	lifeguard.update_body()

/datum/outfit/beachbum
	name = "海滩流浪汉"
	id = /obj/item/card/id/advanced
	uniform = /obj/item/clothing/under/pants/jeans
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/food/pizzaslice/dank
	r_pocket = /obj/item/storage/wallet/random

/datum/outfit/beachbum/post_equip(mob/living/carbon/human/bum, visuals_only = FALSE)
	. = ..()
	if(visuals_only)
		return
	bum.dna.add_mutation(/datum/mutation/stoner, MUTATION_SOURCE_GHOST_ROLE)

/datum/outfit/beachbum/lifeguard
	name = "沙滩救生员"
	id_trim = /datum/id_trim/lifeguard
	uniform = /obj/item/clothing/under/shorts/red

/obj/effect/mob_spawn/ghost_role/human/bartender
	name = "酒保休眠舱"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一个太空酒保"
	you_are_text = "你是一位太空酒保！"
	flavour_text = "是时候调酒并改变人生了。吸食太空毒品能让你更容易理解顾客们古怪的方言。"
	spawner_job_path = /datum/job/space_bartender
	outfit = /datum/outfit/spacebartender
	allow_custom_character = ALL

/datum/outfit/spacebartender
	name = "太空酒保"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/space_bartender
	neck = /obj/item/clothing/neck/bowtie
	uniform = /obj/item/clothing/under/costume/buttondown/slacks/service
	suit = /obj/item/clothing/suit/armor/vest
	back = /obj/item/storage/backpack
	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/spacebartender/post_equip(mob/living/carbon/human/bartender, visuals_only = FALSE)
	. = ..()
	var/obj/item/card/id/id_card = bartender.wear_id
	if(bartender.age < AGE_MINOR)
		id_card.registered_age = AGE_MINOR
		to_chat(bartender, span_notice("你实际上未达到接触或提供酒精的法定年龄，但你的身份证已被秘密修改，将年龄显示为 [AGE_MINOR]。尽量保守这个秘密！"))

//Preserved terrarium/seed vault: Spawns in seed vault structures in lavaland. Ghosts become plantpeople and are advised to begin growing plants in the room near them.
/obj/effect/mob_spawn/ghost_role/human/seed_vault
	name = "保存完好的玻璃容器"
	desc = "一种古老的机器，似乎用来储存植物。玻璃被藤蔓盖住了。"
	prompt_name = "生命使者"
	icon = 'icons/obj/mining_zones/spawners.dmi'
	icon_state = "terrarium"
	density = TRUE
	mob_species = /datum/species/pod
	you_are_text = "你是一个有知觉的生态系统，是你的创造者所拥有的生命掌控力的典范。"
	flavour_text = "Your masters, benevolent as they were, created uncounted seed vaults and spread them across \
	the universe to every planet they could chart. You are in one such seed vault. \
	Your goal is to protect the vault you are assigned to, cultivate the seeds passed onto you, \
	and eventually bring life to this desolate planet while waiting for contact from your creators. \
	Estimated time of last contact: Deployment, 5000 millennia ago."
	spawner_job_path = /datum/job/lifebringer

/obj/effect/mob_spawn/ghost_role/human/seed_vault/Initialize(mapload)
	. = ..()
	mob_name = pick("Tomato", "Potato", "Broccoli", "Carrot", "Ambrosia", "Pumpkin", "Ivy", "Kudzu", "Banana", "Moss", "Flower", "Bloom", "Root", "Bark", "Glowshroom", "Petal", "Leaf", \
	"Venus", "Sprout","Cocoa", "Strawberry", "Citrus", "Oak", "Cactus", "Pepper", "Juniper")

/obj/effect/mob_spawn/ghost_role/human/seed_vault/Destroy()
	new/obj/structure/fluff/empty_terrarium(get_turf(src))
	return ..()

//Ash walker eggs: Spawns in ash walker dens in lavaland. Ghosts become unbreathing lizards that worship the Necropolis and are advised to retrieve corpses to create more ash walkers.

/obj/structure/ash_walker_eggshell
	name = "灰烬行者蛋"
	desc = "一个和人差不多大的黄色蛋，由某种深不可测的生物孕育而成。一个人形轮廓潜伏在里面。蛋壳看起来耐温，但其他方面很脆。"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF
	max_integrity = 80
	var/obj/effect/mob_spawn/ghost_role/human/ash_walker/egg

/obj/structure/ash_walker_eggshell/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0) //lifted from xeno eggs
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/effects/blob/attackblob.ogg', 100, TRUE)
			else
				playsound(src, 'sound/items/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			if(damage_amount)
				playsound(loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/obj/structure/ash_walker_eggshell/attack_ghost(mob/user) //Pass on ghost clicks to the mob spawner
	if(egg)
		egg.attack_ghost(user)
	. = ..()

/obj/structure/ash_walker_eggshell/Destroy()
	if(!egg)
		return ..()
	var/mob/living/carbon/human/yolk = new(get_turf(src))
	yolk.set_species(/datum/species/lizard/ashwalker)
	yolk.fully_replace_character_name(null, yolk.generate_random_mob_name(TRUE))
	yolk.underwear = "Nude"
	yolk.equipOutfit(/datum/outfit/ashwalker)//this is an authentic mess we're making
	yolk.update_body()
	yolk.gib(DROP_ALL_REMAINS)
	QDEL_NULL(egg)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/ash_walker
	name = "灰烬行者蛋"
	desc = "一个和人差不多大的黄色蛋，由某种深不可测的生物孕育而成。一个人形轮廓潜伏在里面。"
	prompt_name = "灰烬行者大墓地"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	mob_species = /datum/species/lizard/ashwalker
	outfit = /datum/outfit/ashwalker
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	you_are_text = "你是一名灰烬行者。你的部落崇拜着死城。"
	flavour_text = "The wastes are sacred ground, its monsters a blessed bounty. \
	You have seen lights in the distance... they foreshadow the arrival of outsiders that seek to tear apart the Necropolis and its domain. \
	Fresh sacrifices for your nest."
	spawner_job_path = /datum/job/ash_walker
	var/datum/team/ashwalkers/team
	var/obj/structure/ash_walker_eggshell/eggshell

/obj/effect/mob_spawn/ghost_role/human/ash_walker/Destroy()
	eggshell = null
	return ..()

/obj/effect/mob_spawn/ghost_role/human/ash_walker/allow_spawn(mob/user, silent = FALSE)
	if(isnull(team))
		return FALSE
	if(!(user.ckey in team.players_spawned))//one per person unless you get a bonus spawn
		return TRUE
	if(!silent)
		to_chat(user, span_warning("你对死灵城已无利用价值。"))
	return FALSE

/obj/effect/mob_spawn/ghost_role/human/ash_walker/special(mob/living/carbon/human/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_human.fully_replace_character_name(null, spawned_human.generate_random_mob_name(TRUE))
	to_chat(spawned_human, "<b>将人类与野兽的尸体拖回你的巢穴。它将吸收它们以繁衍你的同类。若有必要，可入侵外来者的奇异建筑。切勿造成不必要的破坏，在荒原上散落丑陋的残骸必定不会为你赢得青睐。死灵城万岁！</b>")

	spawned_human.mind.add_antag_datum(/datum/antagonist/ashwalker, team)

	spawned_human.remove_language(/datum/language/common)
	team.players_spawned += (spawned_human.ckey)
	eggshell.egg = null
	QDEL_NULL(eggshell)

/obj/effect/mob_spawn/ghost_role/human/ash_walker/Initialize(mapload, datum/team/ashwalkers/ashteam)
	. = ..()
	var/area/spawner_area = get_area(src)
	team = ashteam
	eggshell = new /obj/structure/ash_walker_eggshell(get_turf(loc))
	eggshell.egg = src
	src.forceMove(eggshell)
	if(spawner_area)
		notify_ghosts(
			"An ash walker egg is ready to hatch in \the [spawner_area.name].",
			source = src,
			header = "Ash Walker Egg",
			click_interact = TRUE,
			ignore_key = POLL_IGNORE_ASHWALKER,
			notify_flags = NOTIFY_CATEGORY_NOFLASH,
		)

/datum/outfit/ashwalker
	name = "灰烬行者"
	head = /obj/item/clothing/head/helmet/gladiator
	uniform = /obj/item/clothing/under/costume/gladiator/ash_walker

/datum/outfit/ashwalker/spear
	name = "灰烬行者 - 长矛"
	back = /obj/item/spear/bonespear

///Syndicate Listening Post

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate
	name = "辛迪加生物武器科学家"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "一名辛迪加科学技术人员"
	you_are_text = "你是一名辛迪加科研技术员，受雇于一个研发生物武器的绝密研究设施。"
	flavour_text = "不幸的是，你们憎恨的敌人——纳米传讯，已开始在这个星区采矿。尽你所能继续你的研究，并尽量保持低调。"
	important_text = "基地已布设炸药，切勿放弃它或让它落入敌手！"
	outfit = /datum/outfit/lavaland_syndicate
	spawner_job_path = /datum/job/lavaland_syndicate
	deletes_on_zero_uses_left = FALSE
	allow_custom_character = ALL

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	new_spawn.grant_language(/datum/language/codespeak, source = LANGUAGE_MIND)

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms
	name = "辛迪加通讯代理"
	prompt_name = "辛迪加通讯特工"
	you_are_text = "你是一名辛迪加通讯特工，受雇于一个研发生物武器的绝密研究设施。"
	flavour_text = "不幸的是，你们憎恨的敌人——纳米传讯，已开始在这个星区采矿。尽你所能监视敌方活动，并尽量保持低调。使用通讯设备为任何外勤特工提供支援，并散布虚假信息以误导纳米传讯，使其无法追踪你们。绝不能让基地落入敌手！"
	important_text = "切勿放弃基地。"
	outfit = /datum/outfit/lavaland_syndicate/comms

/datum/outfit/lavaland_syndicate
	name = "拉瓦兰辛迪加特工"
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/toggle/labcoat
	back = /obj/item/storage/backpack
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/syndicate/alt
	shoes = /obj/item/clothing/shoes/combat
	r_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_hand = /obj/item/gun/ballistic/rifle/sniper_rifle
	belt = /obj/item/storage/belt/utility/full
	glasses = /obj/item/clothing/glasses/welding/up

	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/lavaland_syndicate/post_equip(mob/living/carbon/human/syndicate, visuals_only = FALSE)
	syndicate.add_faction(ROLE_SYNDICATE)

/datum/outfit/lavaland_syndicate/comms
	name = "拉瓦兰 辛迪加通讯代理"
	suit = /obj/item/clothing/suit/armor/vest
	mask = /obj/item/clothing/mask/chameleon/gps
	r_hand = /obj/item/melee/energy/sword/saber
	belt = /obj/item/storage/belt/utility/full
	glasses = /obj/item/clothing/glasses/welding/up

/datum/outfit/lavaland_syndicate/comms/icemoon
	name = "冰月辛迪加通讯特工"
	mask = /obj/item/clothing/mask/chameleon
	shoes = /obj/item/clothing/shoes/winterboots/ice_boots/eva

/obj/item/clothing/mask/chameleon/gps/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, "Encrypted Signal")

///Icemoon Syndicate Comms Agent

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/icemoon
	name = "冰月通讯特工"
	prompt_name = "辛迪加通讯特工"
	you_are_text = "你是一名辛迪加通讯特工，被派往靠近敌方设施的地下秘密监听站。"
	flavour_text = "不幸的是，你憎恨的敌人——纳米传讯，已开始在这个星区采矿。尽你所能监视敌人的活动，并尽量保持低调。使用通讯设备为任何现场特工提供支持，并散布虚假信息以误导纳米传讯，使其无法追踪到你。绝不能让前哨站落入敌手！"
	important_text = "绝不能让前哨站落入敌手"
	outfit = /datum/outfit/lavaland_syndicate/comms/icemoon
