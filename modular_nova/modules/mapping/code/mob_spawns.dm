//SPAWNERS//

/obj/effect/mob_spawn/ghost_role/human/ash_walker/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	if(SSmapping.level_trait(spawned_mob.z, ZTRAIT_ICE_RUINS_UNDERGROUND) || SSmapping.level_trait(spawned_mob.z, ZTRAIT_ICE_RUINS_UNDERGROUND))
		ADD_TRAIT(spawned_mob, TRAIT_NOBREATH, ROUNDSTART_TRAIT)
		ADD_TRAIT(spawned_mob, TRAIT_RESISTCOLD, ROUNDSTART_TRAIT)

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.grant_language(/datum/language/common, source = LANGUAGE_SPAWNER)

#define BM_TRADER_MIN_CASH 500
#define BM_TRADER_MAX_CASH 2000

/obj/effect/mob_spawn/ghost_role/human/blackmarket
	name = "黑市商人"
	prompt_name = "一名黑市商人"
	desc = "一个嗡嗡作响的低温舱。机器正试图唤醒其内的乘员。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你是一名黑市商人，在纳米传讯太空区域开设了店铺。"
	flavour_text = "FTU, Independent.. whatever, whoever you are. It doesn't matter out here. \
	You've set up shop in a slightly shady, yet functional little asteroid for your dealings. \
	Explore space, setup shop and find valuable artifacts and nice loot - and pawn it off to those stooges at NT. \
	Or perhaps more exotic customers are in local space...?"
	important_text = "你不是反派角色。"
	outfit = /datum/outfit/black_market
	spawner_job_path = /datum/job/blackmarket
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	loadout_enabled = TRUE

/datum/outfit/black_market
	name = "黑市商人"
	uniform = /obj/item/clothing/under/rank/cargo/tech
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/advanced/chameleon/elite/black/blackmarket
	l_pocket = /obj/item/shuttle_remote/bmd

/datum/outfit/black_market/post_equip(mob/living/carbon/human/shady, visualsOnly)
	handlebank(shady)
	if(shady.wear_id)
		var/obj/item/card/id/id_card = shady.wear_id
		if(id_card.registered_account)
			var/datum/bank_account/bank_account = id_card.registered_account
			bank_account.adjust_money((rand(BM_TRADER_MIN_CASH, BM_TRADER_MAX_CASH)))

	. = ..()

	var/obj/item/shuttle_remote/bmd/remote = shady.get_item_by_slot(ITEM_SLOT_LPOCKET)
	if(!remote)
		return
	// we boldly assume only one Burst was spawned. Checking by Z-level defeats the purpose of this remote being used by latejoining BMD to retrieve stolen shuttle.
	var/list/consoles = SSmachines.get_machines_by_type(/obj/machinery/computer/shuttle/caravan/blackmarket_burst)
	var/obj/machinery/computer/shuttle/caravan/blackmarket_burst/console = pick(consoles)
	if(!console || console?.remote_ref)
		return
	console.remote_ref = WEAKREF(remote)
	remote.computer_ref = WEAKREF(console)

/obj/item/gun/energy/laser/cybersun/black_market_trader
	desc = "一种主要由辛迪加安保人员使用的激光枪。它能快速发射低功率等离子光束。这把枪的撞针似乎被更换过。"
	pin = /obj/item/firing_pin

/obj/effect/spawner/random/weapon/black_market_trader
	name = "黑市商人武器生成器"
	icon_state = "pistol"
	loot = list(
		/obj/item/gun/energy/laser/cybersun/black_market_trader = 80,
		/obj/item/gun/energy/e_gun/old = 50,
		/obj/item/gun/ballistic/shotgun/automatic/combat = 50,
		/obj/item/gun/ballistic/automatic/pistol/contraband = 30,
		/obj/item/gun/ballistic/automatic/sol_rifle/evil  = 20,
		/obj/item/gun/ballistic/automatic/sol_smg/evil = 20,
		/obj/item/gun/ballistic/shotgun/bulldog/unrestricted,
	)

#undef BM_TRADER_MIN_CASH
#undef BM_TRADER_MAX_CASH

/obj/effect/mob_spawn/ghost_role/human/ds2
	name = "DS2 人员"
	use_outfit_name = TRUE
	prompt_name = "DS2 personnel"
	you_are_text = "你是一名辛迪加特工，受雇于一个研发生物武器的绝密研究设施。"
	flavour_text = "不幸的是，你们憎恨的敌人纳米传讯已开始在这个星区采矿。尽你所能继续运作，并尽量保持低调。"
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	computer_area = /area/ruin/space/has_grav/nova/des_two/service/dorms
	spawner_job_path = /datum/job/ds2

/obj/effect/mob_spawn/ghost_role/human/ds2/prisoner
	name = "辛迪加囚犯"
	prompt_name = "一名辛迪加囚犯"
	you_are_text = "你是一艘未知飞船上的辛迪加囚犯。"
	flavour_text = "你不知道自己身在何处，只知道自己是囚犯。塑钛合金应该能让你猜到抓你的人是谁……至于你为什么在这里？那是你该知道的，也是我们要弄清楚的。"
	important_text = "你仍需遵守标准囚犯政策，在敌对 DS2 前必须向管理员求助。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	computer_area = /area/ruin/space/has_grav/nova/des_two/security/prison
	outfit = /datum/outfit/ds2/prisoner
	spawner_job_path = /datum/job/ds2/prisoner
	allow_mechanical_loadout_items = FALSE

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate
	name = "辛迪加特工"
	prompt_name = "一名辛迪加特工"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	you_are_text = "你是一名辛迪加特工，因个人原因受雇于深空 2 号前哨基地。"
	flavour_text = "The Syndicate has found it fit to send a forward operating base to Sector 13 to monitor NT's operations. Your orders are maintaining the ship's integrity and keeping a low profile as well as possible."
	important_text = "你不是敌对角色。在对抗空间站船员之前，请先向管理员求助。"
	outfit = /datum/outfit/ds2/syndicate
	computer_area = /area/ruin/space/has_grav/nova/des_two/halls
	spawner_job_path = /datum/job/ds2
	loadout_enabled = TRUE
	allow_mechanical_loadout_items = TRUE

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate_command
	name = "辛迪加指挥特工"
	prompt_name = "一位辛迪加指挥官"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	you_are_text = "你是一名辛迪加指挥特工，受雇于深空2号前沿作战基地，负责引导其实现目标。"
	flavour_text = "辛迪加认为有必要派遣你前往第13扇区协助指挥前沿作战基地。你的任务是指挥DS-2的船员，同时尽可能保持低调。"
	important_text = "请遵守与指挥政策相同的标准。你不是敌对角色，在对抗空间站船员之前必须向管理员求助。"
	outfit = /datum/outfit/ds2/syndicate_command
	computer_area = /area/ruin/space/has_grav/nova/des_two/halls
	spawner_job_path = /datum/job/ds2/command
	loadout_enabled = TRUE
	allow_mechanical_loadout_items = TRUE

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.grant_language(/datum/language/codespeak, source = LANGUAGE_SPAWNER)

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate_command/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.grant_language(/datum/language/codespeak, source = LANGUAGE_SPAWNER)

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/service
	outfit = /datum/outfit/ds2/syndicate/service

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/miner
	outfit = /datum/outfit/ds2/syndicate/miner

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/enginetech
	outfit = /datum/outfit/ds2/syndicate/enginetech
	spawner_job_path = /datum/job/ds2/engineer

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/researcher
	outfit = /datum/outfit/ds2/syndicate/researcher
	spawner_job_path = /datum/job/ds2/science

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/stationmed
	outfit = /datum/outfit/ds2/syndicate/stationmed

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate/brigoff
	outfit = /datum/outfit/ds2/syndicate/brigoff
	spawner_job_path = /datum/job/ds2/enforce

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate_command/masteratarms
	outfit = /datum/outfit/ds2/syndicate_command/masteratarms

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate_command/corporateliaison
	outfit = /datum/outfit/ds2/syndicate_command/corporateliaison

/obj/effect/mob_spawn/ghost_role/human/ds2/syndicate_command/admiral
	outfit = /datum/outfit/ds2/syndicate_command/admiral

/obj/effect/mob_spawn/ghost_role/robot/ds2
	name = "\improper 辛迪加机器人存储"
	desc = "一个可疑的特制容器，标有'机械人存储'。"
	prompt_name = "一位辛迪加深空机器人"
	deletes_on_zero_uses_left = TRUE
	icon = 'modular_nova/modules/ghostcafe/icons/robot_storage.dmi'
	icon_state = "syndi_robostor"
	anchored = TRUE
	density = TRUE
	uses = 1
	you_are_text = "你是一名DS-2机械人！"
	flavour_text = "你是一艘深空飞船上的机械人……这到底是什么鬼地方？"
	important_text = "请遵守与硅基政策相同的标准。你不是敌对角色。在对抗空间站船员之前，请先向管理员求助。"
	loadout_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	spawner_job_path = /datum/job/ds2
	mob_type = /mob/living/silicon/robot/model/ds2

/obj/effect/mob_spawn/ghost_role/robot/ds2/special(mob/living/silicon/robot/spawned_robot, mob/mob_possessor, apply_prefs)
	. = ..()
	if(spawned_robot.client)
		spawned_robot.custom_name = null
		spawned_robot.updatename(spawned_robot.client)
		spawned_robot.transfer_silicon_prefs(spawned_robot.client)
		spawned_robot.set_gender(spawned_robot.client)

/mob/living/silicon/robot/model/ds2
	faction = list(ROLE_SYNDICATE, ROLE_DS2)
	bubble_icon = "syndibot"
	req_access = list(ACCESS_SYNDICATE)
	lawupdate = FALSE
	scrambledcodes = TRUE
	radio = /obj/item/radio/borg/syndicate/ghost_role

/obj/item/radio/borg/syndicate/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_SYNDICATE)

/mob/living/silicon/robot/model/ds2/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/power_store/cell/hyper(src)
	//This part is because the camera stays in the list, so we'll just do a check
	if(!QDELETED(builtInCamera))
		QDEL_NULL(builtInCamera)

/mob/living/silicon/robot/model/ds2/make_laws()
	laws = new /datum/ai_laws/syndicate_override_ds2()
	laws.associate(src)

/obj/effect/mob_spawn/ghost_role/robot/interdyne
	name = "\improper Interdyne机器人存储"
	desc = "一个标有'机械人存储'的特制容器，上面印有Interdyne Pharmaceuticals的徽标。"
	prompt_name = "一位英特戴恩制药机器人"
	deletes_on_zero_uses_left = TRUE
	icon = 'modular_nova/modules/ghostcafe/icons/robot_storage.dmi'
	icon_state = "dyne_robostorage"
	anchored = TRUE
	density = TRUE
	uses = 1
	you_are_text = "你是一名英特戴恩制药机械人！"
	flavour_text = "你是由英特戴恩制药公司生产并使用的机械人。"
	important_text = "请遵守与硅基政策相同的标准。你不是反派。在对抗空间站船员前，请先向管理员求助。"
	loadout_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	spawner_job_path = /datum/job/ds2
	mob_type = /mob/living/silicon/robot/model/interdyne

/obj/effect/mob_spawn/ghost_role/robot/interdyne/special(mob/living/silicon/robot/spawned_robot, mob/mob_possessor, apply_prefs)
	. = ..()
	if(spawned_robot.client)
		spawned_robot.custom_name = null
		spawned_robot.updatename(spawned_robot.client)
		spawned_robot.transfer_silicon_prefs(spawned_robot.client)
		spawned_robot.set_gender(spawned_robot.client)

/mob/living/silicon/robot/model/interdyne
	faction = list("Syndicate", ROLE_INTERDYNE_PLANETARY_BASE)
	req_access = list(ACCESS_SYNDICATE)
	lawupdate = FALSE
	scrambledcodes = TRUE
	radio = /obj/item/radio/borg/syndicate/ghost_role

/obj/item/radio/borg/syndicate/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_SYNDICATE)

/mob/living/silicon/robot/model/interdyne/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/power_store/cell/hyper(src)
	//This part is because the camera stays in the list, so we'll just do a check
	if(!QDELETED(builtInCamera))
		QDEL_NULL(builtInCamera)

/mob/living/silicon/robot/model/interdyne/make_laws()
	laws = new /datum/ai_laws/syndicate_override_interdyne()
	laws.associate(src)


/obj/effect/mob_spawn/ghost_role/human/hotel_staff
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	quirks_enabled = TRUE
	loadout_enabled = TRUE

/obj/effect/mob_spawn/ghost_role/human/hotel_staff/manager
	name = "员工经理休眠舱"
	outfit = /datum/outfit/hotelstaff/manager
	you_are_text = "你是一家顶级太空酒店的经理！"
	flavour_text = "你是一家顶级太空酒店的经理！确保照顾好客人，宣传好酒店，并且你的员工没有偷懒！"

/obj/effect/mob_spawn/corpse/human/damaged/ashwalker
	mob_type = /mob/living/carbon/human/species/lizard/ashwalker;
	outfit = /datum/outfit/consumed_ashwalker

//OUTFITS//
/datum/outfit/syndicatespace/syndicrew
	ears = /obj/item/radio/headset/cybersun
	id_trim = /datum/id_trim/syndicom/nova/crew

/datum/outfit/syndicatespace/syndicaptain
	ears = /obj/item/radio/headset/cybersun/captain
	id_trim = /datum/id_trim/syndicom/nova/captain

/datum/outfit/ds2
	name = "默认ds2套装"

/datum/outfit/ds2/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(syndicate)
	return ..()

//DS-2 Hostage
/datum/outfit/ds2/prisoner
	name = "辛迪加囚犯"
	uniform = /obj/item/clothing/under/rank/prisoner/syndicate
	shoes = /obj/item/clothing/shoes/sneakers/crimson
	id = /obj/item/card/id/advanced/prisoner/ds2
	id_trim = /datum/id_trim/syndicom/nova/ds2/prisoner

//DS-2 Crew
/datum/outfit/ds2/syndicate
	name = "DS-2特工"
	uniform = /obj/item/clothing/under/syndicate/nova/tactical
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset/interdyne
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/crowbar = 1,
		)
	id = /obj/item/card/id/advanced/black
	implants = list(/obj/item/implant/weapons_auth)
	id_trim = /datum/id_trim/syndicom/nova/ds2

/datum/outfit/ds2/syndicate/miner
	name = "DS-2采矿官"
	uniform = /obj/item/clothing/under/syndicate/nova/overalls
	belt = /obj/item/storage/bag/ore
	back = /obj/item/storage/backpack/satchel/explorer
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/crowbar = 1,
		/obj/item/knife/combat/survival = 1,
		/obj/item/t_scanner/adv_mining_scanner/lesser = 1,
		/obj/item/gun/energy/recharge/kinetic_accelerator = 1,
		)
	id_trim = /datum/id_trim/syndicom/nova/ds2/miner
	l_pocket = /obj/item/card/mining_point_card
	r_pocket = /obj/item/mining_voucher
	head = /obj/item/clothing/head/soft/black

/datum/outfit/ds2/syndicate/service
	name = "DS-2普通职员"
	uniform = /obj/item/clothing/under/syndicate/nova/tactical
	id_trim = /datum/id_trim/syndicom/nova/ds2/syndicatestaff
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
	)
	suit = /obj/item/clothing/suit/apron/chef
	head = /obj/item/clothing/head/soft/mime

/datum/outfit/ds2/syndicate/enginetech
	name = "DS-2引擎技术员"
	uniform = /obj/item/clothing/under/syndicate/nova/overalls
	head = /obj/item/clothing/head/soft/sec/syndicate
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		)
	id_trim = /datum/id_trim/syndicom/nova/ds2/enginetechnician
	glasses = /obj/item/clothing/glasses/welding/up
	belt = /obj/item/storage/belt/utility/syndicate
	gloves = /obj/item/clothing/gloves/combat

/datum/outfit/ds2/syndicate/researcher
	name = "DS-2研究员"
	uniform = /obj/item/clothing/under/rank/rnd/scientist/nova/utility/syndicate
	id_trim = /datum/id_trim/syndicom/nova/ds2/researcher
	suit = /obj/item/clothing/suit/toggle/labcoat/science
	glasses = /obj/item/clothing/glasses/sunglasses/chemical
	gloves = /obj/item/clothing/gloves/color/black
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
	)

/datum/outfit/ds2/syndicate/stationmed
	name = "DS-2医疗官"
	uniform = /obj/item/clothing/under/syndicate/scrubs
	id_trim = /datum/id_trim/syndicom/nova/ds2/medicalofficer
	suit = /obj/item/clothing/suit/toggle/labcoat/interdyne
	belt = /obj/item/storage/belt/medical/paramedic
	gloves = /obj/item/clothing/gloves/latex/nitrile/ntrauma
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/crowbar = 1,
		/obj/item/storage/medkit/surgery = 1,
		)

/datum/outfit/ds2/syndicate/brigoff
	name = "DS-2监狱官"
	uniform = /obj/item/clothing/under/syndicate/combat
	id_trim = /datum/id_trim/syndicom/nova/ds2/brigofficer
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	suit = /obj/item/clothing/suit/armor/bulletproof/old
	back = /obj/item/storage/backpack/security
	head = /obj/item/clothing/head/helmet/swat/ds
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/gun/ballistic/automatic/pistol/sol/evil = 1,
		/obj/item/ammo_box/magazine/c35sol_pistol = 1,
		)
	r_pocket = /obj/item/flashlight/seclite
	mask = /obj/item/clothing/mask/gas/syndicate
	ears = /obj/item/radio/headset/interdyne

/datum/outfit/ds2/syndicate/post_equip(mob/living/carbon/human/syndicate)
	syndicate.add_faction(ROLE_DS2)
	return ..()

//DS-2 Command
/datum/outfit/ds2/syndicate_command
	name = "DS-2指挥特工"
	uniform = /obj/item/clothing/under/syndicate/nova/tactical
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset/interdyne/command
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/crowbar = 1,
		)
	id = /obj/item/card/id/advanced/black
	implants = list(/obj/item/implant/weapons_auth)
	id_trim = /datum/id_trim/syndicom/nova/ds2

/datum/outfit/ds2/syndicate_command/masteratarms
	name = "DS-2总军士长"
	uniform = /obj/item/clothing/under/syndicate/combat
	id_trim = /datum/id_trim/syndicom/nova/ds2/masteratarms
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	suit = /obj/item/clothing/suit/armor/vest/warden/syndicate
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	back = /obj/item/storage/backpack/satchel/sec
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
	)
	head = /obj/item/clothing/head/hats/hos/beret/syndicate
	r_pocket = /obj/item/flashlight/seclite
	implants = list(
		/obj/item/implant/weapons_auth,
		/obj/item/implant/kaza_ruk
		)

/datum/outfit/ds2/syndicate_command/corporateliaison
	name = "DS-2企业联络员"
	uniform = /obj/item/clothing/under/syndicate/sniper
	head = /obj/item/clothing/head/fedora
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
	)
	id_trim = /datum/id_trim/syndicom/nova/ds2/corporateliasion

/datum/outfit/ds2/syndicate_command/admiral
	name = "DS-2 上将"
	uniform = /obj/item/clothing/under/rank/captain/nova/utility/syndicate
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
	)
	belt = /obj/item/gun/ballistic/automatic/pistol/aps
	head = /obj/item/clothing/head/hats/hos/cap/syndicate
	id = /obj/item/card/id/advanced/gold/generic
	id_trim = /datum/id_trim/syndicom/nova/ds2/stationadmiral

/datum/outfit/ds2/syndicate_command/post_equip(mob/living/carbon/human/syndicate)
	syndicate.add_faction(ROLE_DS2)
	return ..()

/datum/outfit/hotelstaff
	id = /obj/item/card/id/away/hotel

/datum/outfit/hotelstaff/post_equip(mob/living/carbon/human/staff, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = staff.wear_id
	if(istype(id_card))
		id_card.registered_name = staff.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(staff)
	return ..()

/datum/outfit/hotelstaff/manager
	name = "酒店员工经理"
	uniform = /obj/item/clothing/under/suit/red
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/radio/off
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/mindshield, /obj/item/implant/exile/noteleport)
	id = /obj/item/card/id/away/hotel/manager

/datum/outfit/hotelstaff/security
	r_hand = /obj/item/gun/energy/laser/scatter/shotty // NOVA EDIT ADD - SPAWNS IN HAND INSTEAD OF ON MAP
	id = /obj/item/card/id/away/hotel/security

//Lost Space Truckers: Six people stranded in deep space aboard a cargo freighter. They must survive their marooning and cooperate.

/obj/effect/mob_spawn/ghost_role/human/lostcargo
	name = "货船低温船员舱"
	prompt_name = "一名迷途的货物技术员"
	desc = "一个嗡嗡作响的低温舱。里面有一名货运员。"
	outfit = /datum/outfit/freighter_crew
	spawner_job_path = /datum/job/freighter_crew
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你原本在运送货物，一次普通的货运工作，直到海盗来袭。你和你的船员们勉强逃脱，但引擎被击毁了。你现在被困在太空中，只能齐心协力在这噩梦中生存下去。"
	flavour_text = "你原本在运送货物，一次普通的货运工作，直到海盗来袭。你和你的船员们勉强逃脱，但引擎被击毁了。你现在被困在太空中，只能齐心协力在这噩梦中生存下去。"
	important_text = "Work with your crew and don't abandon them. You are not directly working with NT, you are an independent freighter crew for the ship's Chief. Your job was merely being a deckhand doing freight work and helping with kitchen prep."
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	quirks_enabled = TRUE
	loadout_enabled = TRUE

/datum/outfit/freighter_crew
	name = "货船船员"
	uniform = /obj/item/clothing/under/rank/cargo/tech/nova/casualman
	shoes = /obj/item/clothing/shoes/workboots
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/away/freightcrew

/datum/outfit/freighter_crew/post_equip(mob/living/carbon/human/crewman, visualsOnly)
	var/obj/item/card/id/id_card = crewman.wear_id
	if(istype(id_card))
		id_card.registered_name = crewman.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(crewman)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/lostminer
	name = "货船低温挖掘工舱"
	prompt_name = "一名迷途的矿工"
	desc = "一个嗡嗡作响的低温舱。里面有一名挖掘工人。"
	outfit = /datum/outfit/freighter_excavator
	spawner_job_path = /datum/job/freighter_crew
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你原本在运送货物，一次普通的货运工作，直到海盗来袭。你和你的船员们勉强逃脱，但引擎被击毁了。你现在被困在太空中，只能齐心协力在这噩梦中生存下去。"
	flavour_text = "你原本在跑货运，一份普通的货运工作，直到海盗来袭。你和你的船员们勉强逃过一劫，但引擎被打坏了。你现在被困在太空中，只能齐心协力在这噩梦中生存下去。"
	important_text = "与你的船员合作，不要抛弃他们。你并非直接为NT工作，你是一支独立的货船船员，在船长的领导下工作。你的角色是负责飞船的挖掘和打捞工作。"
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	quirks_enabled = TRUE
	loadout_enabled = TRUE

/datum/outfit/freighter_excavator
	name = "货船挖掘工"
	uniform = /obj/item/clothing/under/rank/cargo/tech/nova/gorka
	shoes = /obj/item/clothing/shoes/workboots/mining
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/flashlight/seclite=1,\
		/obj/item/knife/combat/survival=1,
		/obj/item/mining_voucher=1,
		/obj/item/t_scanner/adv_mining_scanner/lesser=1,
		/obj/item/gun/energy/recharge/kinetic_accelerator=1,\
		/obj/item/stack/marker_beacon/ten=1,
		)
	r_pocket = /obj/item/storage/bag/ore
	id = /obj/item/card/id/away/freightmine

/datum/outfit/freighter_excavator/post_equip(mob/living/carbon/human/crewman, visualsOnly)
	var/obj/item/card/id/id_card = crewman.wear_id
	if(istype(id_card))
		id_card.registered_name = crewman.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(crewman)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/lostcargoqm
	name = "货船低温老板舱"
	prompt_name = "一位失踪的军需官"
	desc = "一个嗡嗡作响的低温舱。你看到里面有个看起来是管事的人。"
	outfit = /datum/outfit/freighter_boss
	spawner_job_path = /datum/job/freighter_crew
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	mob_species = /datum/species/human
	you_are_text = "你和你的船员原本在进行一次普通的货运航行，直到一次海盗袭击摧毁了引擎。你现在能做的只有努力生存，并让你的船员活下去。"
	flavour_text = "你和你的船员原本在进行一次普通的货运航行，直到一次海盗袭击摧毁了引擎。你现在能做的只有努力生存，并让你的船员活下去。"
	important_text = "不要抛弃你的船员，带领他们并与他们合作以求生存。你并非直接为NT工作，你是一支独立的货船船员。你是这艘船的舰长（这艘船是你不久前买下的），负责管理全体船员。"
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	quirks_enabled = TRUE
	loadout_enabled = TRUE

/datum/outfit/freighter_boss
	name = "货船老板"
	uniform = /obj/item/clothing/under/rank/cargo/tech/nova/turtleneck
	shoes = /obj/item/clothing/shoes/workboots
	neck = /obj/item/clothing/neck/cloak/qm
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/megaphone/cargo=1,
		)
	id = /obj/item/card/id/away/silver/freightqm

/datum/outfit/freighter_boss/post_equip(mob/living/carbon/human/crewman, visualsOnly)
	var/obj/item/card/id/id_card = crewman.wear_id
	if(istype(id_card))
		id_card.registered_name = crewman.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(crewman)
	return ..()

/datum/outfit/proc/handlebank(mob/living/carbon/human/owner)
	if(!owner.mind)
		return
	var/datum/bank_account/offstation_bank_account = new(owner.real_name, owner.mind.assigned_role)
	owner.account_id = offstation_bank_account.account_id
	offstation_bank_account.replaceable = FALSE
	owner.add_mob_memory(/datum/memory/key/account, remembered_id = owner.account_id)
	if(owner.wear_id)
		var/obj/item/card/id/id_card = owner.wear_id
		id_card.registered_account = offstation_bank_account
	return

//ITEMS//
/obj/item/radio/headset/cybersun
	keyslot = new /obj/item/encryptionkey/headset_syndicate/cybersun

/obj/item/radio/headset/cybersun/captain
	name = "赛博阳光舰长耳机"
	desc = "老板的耳机。"
	command = TRUE


//OBJECTS//
/obj/structure/showcase/machinery/oldpod/used
	icon = 'modular_nova/modules/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod-open"

//IDS//

/obj/item/card/id/away/silver
	name = "旧银色ID卡"
	desc = "一张完全通用的ID卡。看起来需要加点特色。这张看起来曾属于某个重要人物。"
	wildcard_slots = WILDCARD_LIMIT_SILVER

/obj/item/card/id/advanced/chameleon/elite/black/blackmarket
	name = "磨损的ID卡"
	desc = "一张褪色、磨损的塑料ID卡。你能辨认出“甲板船员”这个职位。"
	trim = /datum/id_trim/away/blackmarket

/datum/id_trim/away/blackmarket
	access = list(ACCESS_AWAY_GENERIC4)
	assignment = "Deck Crewman"

/obj/item/card/id/away/freightcrew
	name = "货船ID卡"
	desc = "一张标有“货运员”职位的ID卡。"
	trim = /datum/id_trim/job/cargo_technician

/obj/item/card/id/away/freightmine
	name = "货船ID卡"
	desc = "一张标有货运飞船挖掘者职级的ID卡。"
	trim = /datum/id_trim/job/shaft_miner

/obj/item/card/id/away/silver/freightqm
	name = "货船甲板主管ID"
	desc = "一张标有货运甲板主管职级的ID卡。"
	trim = /datum/id_trim/job/quartermaster

/obj/item/card/id/away/hotel/manager
	name = "经理ID"
	trim = /datum/id_trim/away/hotel/manager

/datum/id_trim/away/hotel
	assignment = "Hotel Staff"
	access = list(ACCESS_TWIN_NEXUS_STAFF)

/datum/id_trim/away/hotel/manager
	assignment = "Hotel Manager"
	access = list(ACCESS_TWIN_NEXUS_STAFF, ACCESS_TWIN_NEXUS_MANAGER)

/datum/id_trim/away/hotel/security
	assignment = "Hotel Security"
	access = list(ACCESS_TWIN_NEXUS_STAFF, ACCESS_TWIN_NEXUS_MANAGER)

//film studio space ruins, actors and such.
/obj/effect/mob_spawn/ghost_role/human/actor /// Overrides the /TG/ actor pod
	name = "演员的低温休眠舱"
	mob_species = null
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	loadout_enabled = TRUE

/obj/effect/mob_spawn/ghost_role/human/director
	name = "导演的低温休眠舱"
	mob_species = null
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	loadout_enabled = TRUE
