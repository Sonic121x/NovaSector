/// Lavaland Hermit

/obj/effect/mob_spawn/ghost_role/human/hermit
	quirks_enabled = TRUE // ghost role quirks
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE // ghost role prefs

/// Maintsroom lost

/obj/effect/mob_spawn/ghost_role/human/maintsroom
	name = "查梅诺斯"
	prompt_name = "一个卡在两个空间之间的存在"
	you_are_text = "你醒来了。你的藏身处完好无损，里面有你昨天收集的东西，你在自己的藏身处很安全。也许你应该去探索一下，但要小心那些红色的灯光。"
	flavour_text = "你被困在维护管道里的时间已经久到记不清了，这个地方改变了你。是疯狂、精神错乱，还是感染？或者你是一个古老的存在，一个在此地诞生/创造/显现的怪物？生存将充满挑战，维护管道是非常恶劣的环境，所以任何能在此生存的东西都应该有一个可信的理由。"
	important_text = "你并非敌对角色，不应随意杀害人员/船员，除非你有管理员许可或充分的IC理由。"
	loadout_enabled = TRUE
	quirks_enabled = TRUE // ghost role quirks
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE // ghost role prefs
	deletes_on_zero_uses_left = TRUE

/obj/effect/mob_spawn/ghost_role/human/heretic //specifically staying here for nova so the admins can spawn this if they want, tell me to delete this if you dont want this.
	name = "安保特工"
	prompt_name = "成为神秘特工？"
	you_are_text = "你是一个神秘秘密组织的特工，你工作的设施最近被疏散了，你被告知不要进入并阻止其他人进入，你很清楚最好不要惹恼你的老板。"
	flavour_text = "你的任务是维护设施的安全以及仍留在内部的人员。你不允许任何人进入，但要维持度假村的外观，告诉他们海滩已关闭，同时尽力像度假村一样为人们提供服务。"
	important_text = "如果有人试图越过木质路障和安保屏障，你可以并且应该杀死他们；然而，如果你抓住他们时他们已经越过了安保屏障，那么你应该自杀。如果你杀了任何人，你必须处理他们的尸体，让他们的死亡看起来像一场意外，然后将他们扔回传送门。在任何情况下都不要复活他人或隐藏他们的尸体，也不要掠夺他人，即使在激烈的战斗中那是他们的武器。进入这个幽灵角色时，请抱着你是一个NPC的心态。"
	loadout_enabled = TRUE
	quirks_enabled = TRUE // ghost role quirks
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE // ghost role prefs
	deletes_on_zero_uses_left = TRUE

/// Beach Dome

/obj/effect/mob_spawn/ghost_role/human/beach
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/// Space Bar

/obj/effect/mob_spawn/ghost_role/human/bartender
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/// Preserved Terrarium

/obj/effect/mob_spawn/ghost_role/human/seed_vault
	restricted_species = list(/datum/species/pod)
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/// Ashwalker Camp

/obj/effect/mob_spawn/ghost_role/human/ash_walker
	restricted_species = list(/datum/species/lizard/ashwalker)
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/ash_walker/special(mob/living/carbon/human/spawned_human, mob/mob_possessor, apply_prefs)
	spawned_human.fully_replace_character_name(null, spawned_human.generate_random_mob_name(TRUE))
	quirks_enabled = TRUE // ghost role quirks
	. = ..()

/// Listening Outpost

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/space
	outfit = /datum/outfit/lavaland_syndicate/comms/space
	loadout_enabled = TRUE
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

// OUTFITS

/datum/outfit/lavaland_syndicate/comms
	uniform = /obj/item/clothing/under/rank/security/nova/utility/syndicate
	ears = /obj/item/radio/headset/interdyne/comms

/datum/outfit/lavaland_syndicate/comms/space
	ears = /obj/item/radio/headset/syndicate/alt

/// Interdyne Planetary Base(s)

// SPAWNERS

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base
	name = "英特戴恩科学家"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "一名英特戴恩科学家"
	computer_area = /area/ruin/interdyne_planetary_base/main
	you_are_text = "你是一名受雇于英特戴恩研究设施的科研技术员，该设施正在开发生物武器。"
	flavour_text = "英特戴恩中层管理人员已通报，纳米传讯正在该星区积极采矿。与辛迪加的协议仍然有效。一艘货运渡轮停靠在你们飞船的后部，可用于与这两个派系进行贸易。尽你所能继续你的研究，并尽量远离麻烦。"
	outfit = /datum/outfit/interdyne_planetary_base
	spawner_job_path = /datum/job/interdyne_planetary_base
	loadout_enabled = TRUE
	allow_mechanical_loadout_items = TRUE
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.grant_language(/datum/language/codespeak, source = LANGUAGE_SPAWNER)

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/ice
	outfit = /datum/outfit/interdyne_planetary_base/ice
	computer_area = /area/ruin/interdyne_planetary_base/main/dorms
	flavour_text = "英特戴恩中层管理人员已通报，纳米传讯正在该星区积极采矿。与辛迪加的协议仍然有效，但他们的星际飞船已离开该系统，使我们的量子传送板失去了用途。尽你所能继续你的研究，并尽量远离麻烦。"
	spawner_job_path = /datum/job/interdyne_planetary_base_icebox

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/shaftminer
	name = "英特戴恩矿工"
	prompt_name = "一名英特戴恩矿井矿工"
	you_are_text = "你是一名矿井矿工，受雇于英特戴恩研究设施，该设施正在开发生物武器。"
	outfit = /datum/outfit/interdyne_planetary_base/shaftminer
	spawner_job_path = /datum/job/interdyne_planetary_base/mining

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/shaftminer/ice
	outfit = /datum/outfit/interdyne_planetary_base/shaftminer/ice
	computer_area = /area/ruin/interdyne_planetary_base/main/dorms
	flavour_text = "因特戴恩中层管理已转达，纳米传讯正在此星区积极采矿。与辛迪加的协议仍然有效，但他们的星舰已离开本星系，使我们的量子传送板失去了用途。尽你所能继续研究，并尽量别惹麻烦。"
	spawner_job_path = /datum/job/interdyne_planetary_base_icebox/mining

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/deck_officer
	name = "英特戴恩甲板军官"
	prompt_name = "一名因特戴恩甲板军官"
	you_are_text = "你是一名甲板军官，受雇于一家开发生物武器的因特戴恩研究设施。"
	outfit = /datum/outfit/interdyne_planetary_base/shaftminer/deckofficer
	spawner_job_path = /datum/job/interdyne_planetary_base/command

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/deck_officer/ice
	computer_area = /area/ruin/interdyne_planetary_base/main/dorms
	flavour_text = "因特戴恩中层管理已转达，纳米传讯正在此星区积极采矿。与辛迪加的协议仍然有效，但他们的星舰已离开本星系，使我们的量子传送板失去了用途。尽你所能继续研究，并尽量别惹麻烦。"
	spawner_job_path = /datum/job/interdyne_planetary_base_icebox/command





/datum/outfit/lavaland_syndicate/shaftminer/deckofficer
	name = "英特戴恩甲板军官"
	uniform = /obj/item/clothing/under/syndicate/nova/interdyne/deckofficer
	head = /obj/item/clothing/head/hats/syndicate/interdyne_deckofficer_black
	suit = /obj/item/clothing/suit/armor/hos/deckofficer
	ears = /obj/item/radio/headset/interdyne/command
	id = /obj/item/card/id/advanced/silver/generic
	id_trim = /datum/id_trim/syndicom/nova/interdyne/deckofficer

/obj/item/radio/headset/interdyne/green
	name = "英特戴恩品牌耳机"
	desc = "A bowman headset in interdyne green, has a small 'IP' written on the earpiece. Protects the ears from flashbangs."
	icon_state = "headset_ip"
	worn_icon_state = "headset_ip"
	icon = 'modular_nova/modules/mapping/icons/obj/headset.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/ears.dmi'


// OUTFITS

/datum/outfit/interdyne_planetary_base
	name = "英特戴恩科学家"
	id = /obj/item/card/id/advanced/chameleon/elite
	id_trim = /datum/id_trim/syndicom/nova/interdyne
	uniform = /obj/item/clothing/under/syndicate/nova/interdyne
	suit = /obj/item/clothing/suit/toggle/labcoat/nova/interdyne_labcoat/white
	head = /obj/item/clothing/head/beret/medical/nova/interdyne
	back = /obj/item/storage/backpack/interdyne
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne=1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/healthanalyzer/simple/disease=1,
	)
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/interdyne/green
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_hand = /obj/item/storage/toolbox/guncase/nova/carwo_large_case/sindano/evil
	implants = list(/obj/item/implant/weapons_auth)
	var/jobtype = /datum/job/interdyne_planetary_base

/datum/outfit/interdyne_planetary_base/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	syndicate.add_faction(ROLE_INTERDYNE_PLANETARY_BASE)

	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()

	handlebank(syndicate)
	return ..()

/datum/outfit/interdyne_planetary_base/ice
	uniform = /obj/item/clothing/under/syndicate/nova/interdyne
	suit = /obj/item/clothing/suit/hooded/wintercoat/medical/viro/interdyne
	ears = /obj/item/radio/headset/interdyne/green
	head = /obj/item/clothing/head/beret/medical/nova/interdyne
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne=1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/healthanalyzer/simple/disease=1,
		/obj/item/clothing/suit/toggle/labcoat/nova/interdyne_labcoat/white=1,
	)

/datum/outfit/interdyne_planetary_base/shaftminer
	name = "英特戴恩矿井矿工"
	uniform = /obj/item/clothing/under/syndicate/nova/interdyne/miner
	suit = /obj/item/clothing/suit/syndicate/interdyne_jacket
	r_pocket = /obj/item/storage/bag/ore
	id_trim = /datum/id_trim/syndicom/nova/interdyne/shaftminer
	back = /obj/item/storage/backpack/explorer
	skillchips = list(/obj/item/skillchip/job/miner)
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne=1,
		/obj/item/storage/box/nif_ghost_box/ghost_role=1,
		/obj/item/flashlight/seclite=1,
		/obj/item/knife/combat/survival=1,
		/obj/item/mining_voucher=1,
		/obj/item/t_scanner/adv_mining_scanner/lesser=1,
		/obj/item/gun/energy/recharge/kinetic_accelerator=1,
		/obj/item/stack/marker_beacon/ten=1,\
		/obj/item/card/mining_point_card=1,
	)

/datum/outfit/interdyne_planetary_base/shaftminer/deckofficer
	name = "英特戴恩甲板官员"
	uniform = /obj/item/clothing/under/syndicate/nova/interdyne/deckofficer
	head = /obj/item/clothing/head/hats/syndicate/interdyne_deckofficer_black
	suit = /obj/item/clothing/suit/armor/hos/deckofficer
	ears = /obj/item/radio/headset/interdyne/command
	skillchips = list(/obj/item/skillchip/job/miner)
	id = /obj/item/card/id/advanced/chameleon/elite/black/silver
	id_trim = /datum/id_trim/syndicom/nova/interdyne/deckofficer

/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/deckofficer/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate/captain(get_turf(src))
	return ..()

/datum/outfit/interdyne_planetary_base/shaftminer/ice
	name = "冰月星英特戴恩矿井矿工"
	uniform = /obj/item/clothing/under/syndicate/nova/interdyne/miner
	suit = /obj/item/clothing/suit/syndicate/interdyne_jacket

// ITEMS

/obj/item/radio/headset/interdyne
	name = "\improper 英特戴恩耳机"
	desc = "A bowman headset with a large red cross on the earpiece, has a small 'IP' written on the top strap. Protects the ears from flashbangs."
	icon_state = "syndie_headset"
	inhand_icon_state = null
	radio_talk_sound = 'modular_nova/modules/radiosound/sound/radio/syndie.ogg'
	keyslot = new /obj/item/encryptionkey/headset_syndicate/interdyne

/obj/item/radio/headset/interdyne/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/interdyne/command
	name = "\improper 英特戴恩指挥耳机"
	desc = "A commanding headset to gather your underlings. Protects the ears from flashbangs. It has a large red cross on the earpiece, and a small 'IP' written on the top strap. Protects the ears from flashbangs."
	command = TRUE

/obj/item/radio/headset/interdyne/comms
	keyslot = /obj/item/encryptionkey/headset_syndicate/interdyne

// STRUCTURES

/obj/structure/closet/crate/freezer/sansufentanyl
	name = "三氟芬太尼板条箱"
	desc = "一个冷冻柜。内含冷藏的三氟芬太尼，用于治疗遗传性多重病症。英特戴恩制药公司的产品。"

/obj/structure/closet/crate/freezer/sansufentanyl/PopulateContents()
	. = ..()
	for(var/grabbin_pills in 1 to 10)
		new /obj/item/storage/pill_bottle/sansufentanyl(src)

/obj/structure/closet/l3closet/interdyne
	name = "英特戴恩三级生物危害防护装备柜"

/obj/structure/closet/l3closet/interdyne/PopulateContents()
	new /obj/item/storage/bag/bio(src)
	new /obj/item/clothing/suit/bio_suit/interdyne(src)
	new /obj/item/clothing/head/bio_hood/interdyne(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/reagent_containers/syringe/antiviral(src)
