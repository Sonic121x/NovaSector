//Port Tarkon, 8 people trapped in a revamped charlie-station like ghost role. Survive the aliens and threats, Fix the port and/or finish construction

/obj/effect/mob_spawn/ghost_role/human/tarkon
	name = "塔尔孔港船员"
	prompt_name = "一名港口甲板工人"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	you_are_text = "你是Tarkon工业的一名成员，最近被指派到一个新近回收的资产——Tarkon港。你的上级是少尉和站点主管。"
	flavour_text = "在新近回收的Tarkon港上，你的任务是协助完成建设，并执行站点主管下达的任何任务。最好先看看你部门的记事板。"
	important_text = "你不得擅自离开塔尔康港。检查其他休眠舱以寻找替代工作。听从站点主管和少尉的指示。"
	outfit = /datum/outfit/tarkon
	faction = list(FACTION_TARKON)
	spawner_job_path = /datum/job/tarkon
	loadout_enabled = TRUE
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	computer_area = /area/ruin/space/has_grav/port_tarkon

/datum/outfit/tarkon
	name = "默认港口塔尔孔制服"
	uniform = /obj/item/clothing/under/tarkon/general
	head = /obj/item/clothing/head/utility/welding/hat
	shoes = /obj/item/clothing/shoes/winterboots
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/advanced/tarkon
	id_trim = /datum/id_trim/away/tarkon
	ears = /obj/item/radio/headset/tarkon
	backpack_contents = list(
		/obj/item/crowbar = 1
		)
	var/backpack = /obj/item/storage/backpack/tarkon //Replaces "back" item with provided backpack based on preference on role spawn. Will be used further in project Colony Echo
	/// Replaces "back" item with provided satchel
	var/satchel = /obj/item/storage/backpack/satchel/tarkon
	/// Replaces "back" item with provided duffelbag
	var/duffelbag = /obj/item/storage/backpack/duffelbag/tarkon
	/// Replaces "back" item with provided messenger bag.
	var/messenger = /obj/item/storage/backpack/messenger/tarkon

/datum/outfit/tarkon/pre_equip(mob/living/carbon/human/tarkon, visuals_only = FALSE)
	if(ispath(back, /obj/item/storage/backpack)) //we just steal this from the job outfit datum.
		switch(tarkon.backpack)
			if(GBACKPACK)
				back = /obj/item/storage/backpack //Grey backpack
			if(GSATCHEL)
				back = /obj/item/storage/backpack/satchel //Grey satchel
			if(GDUFFELBAG)
				back = /obj/item/storage/backpack/duffelbag //Grey Duffel bag
			if(LSATCHEL)
				back = /obj/item/storage/backpack/satchel/leather //Leather Satchel
			if(GMESSENGER)
				back = /obj/item/storage/backpack/messenger //Grey messenger bag
			if(DBACKPACK)
				back = backpack //faction backpack
			if(DSATCHEL)
				back = satchel //faction satchel
			if(DMESSENGER)
				back = messenger //faction messenger bag
			if(DDUFFELBAG)
				back = duffelbag //faction duffel bag
			if(TPACKB)
				back = /obj/item/storage/backpack/tinypakb //tiny packs, because they kinda drippin
			if(TPACKA)
				back = /obj/item/storage/backpack/tinypaka
			if(TPACKC)
				back = /obj/item/storage/backpack/tinypakc
			if(UDCPACK)
				back = /obj/item/storage/backpack/udc //No guncase option as of yet.
			else
				back = backpack //faction backpack fallback incase bag pref shits bed

	var/client/client = GLOB.directory[ckey(tarkon.mind?.key)]

	if(isplasmaman(tarkon))
		uniform = /obj/item/clothing/under/plasmaman
		gloves = /obj/item/clothing/gloves/color/plasmaman
		head = /obj/item/clothing/head/helmet/space/plasmaman
		r_hand = /obj/item/tank/internals/plasmaman/belt/full
		internals_slot = ITEM_SLOT_HANDS
	if(isvox(tarkon) || isvoxprimalis(tarkon))
		r_hand = /obj/item/tank/internals/nitrogen/belt/full
		mask = /obj/item/clothing/mask/breath/vox
		internals_slot = ITEM_SLOT_HANDS

	if(client?.is_veteran() && client?.prefs.read_preference(/datum/preference/toggle/playtime_reward_cloak))
		neck = /obj/item/clothing/neck/cloak/skill_reward/playing

/datum/outfit/tarkon/post_equip(mob/living/carbon/human/tarkon, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = tarkon.wear_id
	if(istype(id_card))
		id_card.registered_name = tarkon.real_name
		id_card.update_label()
		id_card.update_icon()
	var/obj/item/radio/target_radio = tarkon.ears
	target_radio.set_frequency(FREQ_TARKON)
	target_radio.recalculateChannels()

	handlebank(tarkon)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/tarkon/cargo
	prompt_name = "一名港口打捞技术员"
	outfit = /datum/outfit/tarkon/cargo

/datum/outfit/tarkon/cargo
	name = "塔康港货运制服"
	uniform = /obj/item/clothing/under/tarkon
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/advanced/tarkon/cargo
	id_trim = /datum/id_trim/away/tarkon/cargo
	l_pocket = /obj/item/mining_voucher

/obj/effect/mob_spawn/ghost_role/human/tarkon/sci
	prompt_name = "一名港口研究员"
	outfit = /datum/outfit/tarkon/sci

/datum/outfit/tarkon/sci
	name = "塔康港科研制服"
	uniform = /obj/item/clothing/under/tarkon/sci
	glasses = /obj/item/clothing/glasses/hud/diagnostic
	id = /obj/item/card/id/advanced/tarkon/sci
	id_trim = /datum/id_trim/away/tarkon/sci
	r_pocket = /obj/item/stock_parts/power_store/cell/high
	l_pocket = /obj/item/card/id/away/tarkonrobo

/obj/effect/mob_spawn/ghost_role/human/tarkon/med
	prompt_name = "一名港口创伤急救员"
	outfit = /datum/outfit/tarkon/med

/datum/outfit/tarkon/med
	name = "塔康港医疗制服"
	uniform = /obj/item/clothing/under/tarkon/med
	glasses = /obj/item/clothing/glasses/hud/health
	id = /obj/item/card/id/advanced/tarkon/med
	id_trim = /datum/id_trim/away/tarkon/med
	neck = /obj/item/clothing/neck/stethoscope
	l_pocket = /obj/item/healthanalyzer
	r_pocket = /obj/item/stack/medical/suture/medicated

/obj/effect/mob_spawn/ghost_role/human/tarkon/engi
	prompt_name = "一名港口维护工程师"
	outfit = /datum/outfit/tarkon/engi

/datum/outfit/tarkon/engi
	name = "塔康港工程制服"
	uniform = /obj/item/clothing/under/tarkon/eng
	glasses = /obj/item/clothing/glasses/meson/engine/tray
	id = /obj/item/card/id/advanced/tarkon/engi
	id_trim = /datum/id_trim/away/tarkon/eng
	neck = /obj/item/clothing/neck/security_cape/tarkon
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	r_pocket = /obj/item/stack/cable_coil
	backpack_contents = list(
		/obj/item/crowbar = 1,
		/obj/item/inducer = 1
		)

/obj/effect/mob_spawn/ghost_role/human/tarkon/sec
	prompt_name = "一名港口安保成员"
	outfit = /datum/outfit/tarkon/sec

/datum/outfit/tarkon/sec
	name = "塔康港安保制服"
	uniform = /obj/item/clothing/under/tarkon/sec
	glasses = /obj/item/clothing/glasses/hud/security
	gloves = /obj/item/clothing/gloves/tackler/combat
	neck = /obj/item/clothing/neck/security_cape/tarkon
	id = /obj/item/card/id/advanced/tarkon/sec
	id_trim = /datum/id_trim/away/tarkon/sec
	l_pocket = /obj/item/melee/baton/telescopic
	r_pocket = /obj/item/grenade/barrier

/obj/effect/mob_spawn/ghost_role/human/tarkon/ensign
	name = "塔康港少尉"
	prompt_name = "一名被遗弃的少尉"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper-o"
	you_are_text = "你被塔尔康工业派往塔尔康港担任低级指挥成员。你的上级是站点主管。"
	flavour_text = "作为二把手，你通常负责带领其他塔尔康成员执行外部任务，而站点主管则留守港口。"
	important_text = "这不是为非塔尔康专属角色设计的职位。你不得无故离开塔尔康港。你可以在可用的Z层级内以及前往空间站旅行，并获准组织探索队。"
	outfit = /datum/outfit/tarkon/ensign
	spawner_job_path = /datum/job/tarkon

/datum/outfit/tarkon/ensign //jack of all trades, master of none, spent all his credits, every last one
	name = "塔康港少尉制服"
	uniform = /obj/item/clothing/under/tarkon/com
	ears = /obj/item/radio/headset/tarkon/command
	id = /obj/item/card/id/advanced/tarkon/ensign
	id_trim = /datum/id_trim/away/tarkon/ensign
	neck = /obj/item/clothing/neck/security_cape/tarkon

/obj/effect/mob_spawn/ghost_role/human/tarkon/director
	name = "塔康港站点主管"
	prompt_name = "一名港口站点主管"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	you_are_text = "你是新近任命的塔尔康港站点主管。除了你自己和塔尔康工业的意志，你没有其他上级。"
	flavour_text = "在最近收复的塔康港，你的任务是监督船员并维持港口的正常运转。"
	important_text = "此职位并非为非塔康港特定角色设计。你不得离开塔康港。请检查其他休眠舱以寻找替代工作。"
	outfit = /datum/outfit/tarkon/director
	spawner_job_path = /datum/job/tarkon/command
	loadout_enabled = TRUE
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/datum/outfit/tarkon/director //Look at me, I'm the director now.
	name = "塔康港主管制服"
	uniform = /obj/item/clothing/under/tarkon/com
	ears = /obj/item/radio/headset/tarkon/command
	id = /obj/item/card/id/advanced/tarkon/director
	id_trim = /datum/id_trim/away/tarkon/director
	neck = /obj/item/clothing/neck/security_cape/tarkon
	r_pocket = /obj/item/card/id/away/tarkonrobo

////////////////////// Corpse/Mob Spawners Below

/datum/outfit/tarkon/loot
	name = "阵亡塔康港少尉制服"
	uniform = /obj/item/clothing/under/tarkon/com
	ears = /obj/item/radio/headset/tarkon/command
	id = /obj/item/card/id/advanced/tarkon/ensign
	id_trim = /datum/id_trim/away/tarkon/ensign
	neck = /obj/item/clothing/neck/security_cape/tarkon
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/mod/control/pre_equipped/tarkon
	backpack_contents = list(/obj/item/trench_tool)

/obj/effect/mob_spawn/corpse/human/tarkon
	icon_state = "corpseminer"
	outfit = /datum/outfit/tarkon/loot

#define ROLE_TARKALIEN "Xenomorph Hive T-35"

/obj/structure/spawner/tarkon_xenos
	name = "受侵染的巢穴"
	desc = "一条深不见底的隧道，任何光线都无法触及深处。洞内传来遥远的咆哮声……"
	icon_state = "hole"
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	max_integrity = 500
	max_mobs = 4
	spawn_time = 30 SECONDS
	mob_types = list(
		/mob/living/basic/alien,
		/mob/living/basic/alien/drone,
		/mob/living/basic/alien/sentinel
	)
	spawn_text = "crawls out of"
	faction = list(ROLE_TARKALIEN)
	var/boss_mob = /mob/living/basic/alien/queen/large
	var/loot_drop = /obj/effect/mob_spawn/corpse/human/tarkon

/obj/structure/spawner/tarkon_xenos/atom_deconstruct(disassembled)
	new /obj/effect/nest_break(loc, loot_drop, boss_mob)
	return ..()

/obj/effect/nest_break
	name = "坍塌中的受侵染巢穴"
	desc = "别站着，快离开！"
	layer = TABLE_LAYER
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "hole"
	anchored = TRUE
	density = TRUE
	var/boss_mob //Boss mob that spawns after nest breaking
	var/loot_drop //Reward for breaking nest

/obj/effect/nest_break/proc/rustle()
	for(var/mob/shooken in range(7,src))
		shake_camera(shooken, 15, 1)
	playsound(get_turf(src),'sound/effects/explosion/explosionfar.ogg', 200, TRUE)
	visible_message(span_boldannounce("巢穴入口开始崩塌，有什么东西正冲出来！"))
	var/mob/living/basic/boss_baby = new boss_mob(loc)
	boss_baby.set_faction(faction)
	new loot_drop(loc)
	qdel(src)

/obj/effect/nest_break/Initialize(mapload, loot_drop, boss_mob)
	. = ..()
	src.loot_drop = loot_drop
	src.boss_mob = boss_mob
	visible_message(span_boldannounce("巢穴剧烈震动，入口开始破裂崩解！"))
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, FALSE, 50, TRUE, TRUE)
	addtimer(CALLBACK(src, PROC_REF(rustle)), 5 SECONDS, TIMER_DELETE_ME)
	do_jiggle_nova()

/obj/structure/spawner/tarkon_xenos/common
	name = "受侵染的巢穴"
	desc = "一条长满杂草的深隧道，里面似乎有东西在活动……"
	icon_state = "hole"
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	max_integrity = 300
	max_mobs = 2
	spawn_time = 40 SECONDS
	boss_mob = /mob/living/basic/alien/queen
	loot_drop = /obj/effect/spawner/random/astrum/sci_loot/tarkon

/obj/structure/spawner/tarkon_xenos/minor
	name = "受侵染的隧道"
	desc = "一条长满杂草的隧道，深处传来咔哒咔哒的声响……"
	icon_state = "hole"
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	max_integrity = 150
	max_mobs = 1
	spawn_time = 40 SECONDS
	mob_types = list(
		/mob/living/basic/alien,
		/mob/living/basic/alien/drone
	)
	boss_mob = /mob/living/basic/alien/sentinel
	loot_drop = /obj/effect/spawner/random/exotic/technology/tarkon

/obj/effect/spawner/random/astrum/sci_loot/tarkon
	name = "绑架者科学家战利品"
	loot = list(
		/obj/item/circular_saw/alien = 10,
		/obj/item/retractor/alien = 10,
		/obj/item/scalpel/alien = 10,
		/obj/item/hemostat/alien = 10,
		/obj/item/crowbar/abductor = 10,
		/obj/item/screwdriver/abductor = 10,
		/obj/item/wrench/abductor = 10,
		/obj/item/weldingtool/abductor = 10,
		/obj/item/crowbar/abductor = 10,
		/obj/item/wirecutters/abductor = 10,
		/obj/item/multitool/abductor = 10,
	)

/obj/effect/spawner/random/exotic/technology/tarkon
	spawn_loot_count = 1 //we just need one.

/obj/structure/closet/secure_closet/tarkon //This is just so i can get an empty, tarkon-accessed engi closet... Joyous me.
	req_access = list(ACCESS_TARKON)

/obj/structure/closet/secure_closet/tarkon/engi
	name = "电路存储柜"
	icon_state = "eng"

#undef ROLE_TARKALIEN
