/obj/item/clothing/under/rank/security/armadyne
	name = "阿玛戴恩公司制服"
	desc = "阿玛戴恩公司人员穿着的时尚制服。其金属红色的皮带扣制成了阿玛戴恩标志的形状。"
	icon_state = "armadyne_shirt"
	worn_icon_state = "armadyne_shirt"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/centcom.dmi'	//This can probably be moved to centcom.dm when the suits are sorted
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/centcom.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/centcom_digi.dmi'

/obj/item/clothing/under/rank/security/armadyne/tactical
	name = "阿玛戴恩战术制服"
	desc = "阿玛戴恩公司人员穿着的坚固战术制服。"
	icon_state = "armadyne_tac"
	worn_icon_state = "armadyne_tac"

/obj/item/clothing/head/beret/sec/armadyne
	name = "阿玛戴恩公司贝雷帽"
	desc = "阿玛戴恩公司人员佩戴的舒适而坚固的贝雷帽。"
	icon_state = "/obj/item/clothing/head/beret/sec/armadyne"
	post_init_icon_state = "beret_badge_fancy_diagonal"
	greyscale_config = /datum/greyscale_config/beret_badge_fancy
	greyscale_config_worn = /datum/greyscale_config/beret_badge_fancy/worn
	greyscale_colors = "#3F3C40#5B2423#491716"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/hos/trenchcoat/armadyne
	name = "阿玛戴恩风衣"
	desc = "富有的高层人士穿着的宽大而温暖的阿玛戴恩红色风衣。其一半的温暖感——以及体积感——实际上来自其下方的聚合物装甲板。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "armadyne_trench"

/obj/item/clothing/suit/armor/vest/armadyne
	name = "阿玛戴恩夹克"
	desc = "一件阿玛戴恩品牌的运动夹克，内部有薄纳米碳衬里用于防护目的。由阿玛戴恩公司人员或富有的支持者穿着。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "armadyne_jacket"
	worn_icon_state = "armadyne_jacket"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/vest/armadyne/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "zipper")

/obj/item/clothing/suit/armor/vest/armadyne/armor
	name = "阿玛戴恩装甲背心"
	desc = "一件纳米碳和高级聚合物背心，背面印有磨损红色的阿玛戴恩标志。供阿玛戴恩公司人员在需要应急装甲时使用。"
	icon_state = "armadyne_armor"
	worn_icon_state = "armadyne_armor"

/obj/item/clothing/glasses/hud/security/sunglasses/armadyne
	name = "阿玛戴恩平视显示器眼镜"
	icon_state = "armadyne_glasses"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/eyes.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/glasses.dmi'

/obj/item/clothing/gloves/combat/armadyne
	name = "阿玛戴恩战斗手套"
	desc = "战术且时尚。由阿玛戴恩代表佩戴。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "armadyne_gloves"
	worn_icon_state = "armadyne_gloves"
	cut_type = null

/obj/item/clothing/gloves/color/black/security/armadyne
	name = "阿玛戴恩手套"
	desc = "战术风格，流线型设计。由阿玛戴恩代表佩戴。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "armadyne_gloves"
	worn_icon_state = "armadyne_gloves"
	cut_type = null

/obj/item/clothing/shoes/jackboots/armadyne
	name = "阿玛戴恩作战靴"
	desc = "战术风格，流线型设计。由阿玛戴恩代表佩戴。"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	icon_state = "armadyne_boots"
	inhand_icon_state = "jackboots"
	worn_icon_state = "armadyne_boots"

/obj/item/storage/belt/security/armadyne
	name = "阿玛戴恩腰带"
	desc = "可容纳安保装备，如手铐和闪光弹。配有手枪枪套。"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "armadyne_belt"
	worn_icon_state = "armadyne_belt"

/obj/item/storage/belt/security/armadyne/setup_reskins()
	return

/obj/item/storage/belt/security/webbing/armadyne
	name = "阿玛戴恩战术织带"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "red_webbing"
	worn_icon_state = "red_webbing"

/obj/item/storage/belt/security/webbing/armadyne/setup_reskins()
	return

/datum/outfit/armadyne_rep
	name = "阿玛戴恩企业代表"

	suit_store = /obj/item/modular_computer/pda/security
	ears = /obj/item/radio/headset/headset_cent/commander
	uniform = /obj/item/clothing/under/rank/security/armadyne
	gloves = /obj/item/clothing/gloves/combat/armadyne
	head =  /obj/item/clothing/head/beret/sec/armadyne
	neck = /obj/item/clothing/neck/tie/black
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/armadyne
	suit = /obj/item/clothing/suit/armor/vest/armadyne
	shoes = /obj/item/clothing/shoes/jackboots/armadyne
	belt = /obj/item/storage/belt/security/armadyne
	r_pocket = /obj/item/assembly/flash/handheld
	backpack_contents = list(
		/obj/item/melee/baton/telescopic,
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/skild,
	)
	back = /obj/item/storage/backpack/satchel/leather
	box = /obj/item/storage/box/survival/security
	l_pocket = /obj/item/megaphone/command
	id = /obj/item/card/id/advanced/armadyne/agent


/datum/outfit/armadyne_security
	name = "阿玛戴恩企业安保"

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/armadyne/tactical
	gloves = /obj/item/clothing/gloves/combat/armadyne
	head = /obj/item/clothing/head/helmet
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/armadyne
	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/armor/vest/armadyne/armor
	suit_store = /obj/item/gun/ballistic/automatic/sol_smg
	shoes = /obj/item/clothing/shoes/jackboots/armadyne
	backpack_contents = list(
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/wespe,
		/obj/item/storage/box/handcuffs,
		/obj/item/ammo_box/magazine/c35sol_pistol/stendo,
		/obj/item/modular_computer/pda/security,
	)
	back = /obj/item/storage/backpack/security
	box = /obj/item/storage/box/survival/security
	id = /obj/item/card/id/advanced/armadyne/security


/datum/outfit/armadyne_security/commander
	name = "阿玛戴恩企业安保指挥官"

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/armadyne/tactical
	gloves = /obj/item/clothing/gloves/combat/armadyne
	head =  /obj/item/clothing/head/beret/sec/armadyne
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/armadyne
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit = /obj/item/clothing/suit/armor/vest/armadyne/armor
	suit_store = /obj/item/gun/ballistic/automatic/sol_rifle
	shoes = /obj/item/clothing/shoes/jackboots/armadyne
	belt = /obj/item/storage/belt/security/webbing/armadyne
	backpack_contents = list(
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/wespe,
		/obj/item/storage/box/handcuffs,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard,
		/obj/item/modular_computer/pda/security,
	)
	back = /obj/item/storage/backpack/security
	box = /obj/item/storage/box/survival/security
	l_pocket = /obj/item/megaphone/command
	id = /obj/item/card/id/advanced/armadyne/security


/datum/outfit/armadyne_security/high_alert
	name = "阿玛戴恩企业安保（高度警戒）"
	belt = /obj/item/storage/belt/security/webbing/armadyne
	suit_store = /obj/item/gun/ballistic/automatic/sol_rifle
	backpack_contents = list(
		/obj/item/melee/baton/telescopic,
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/wespe,
		/obj/item/storage/box/handcuffs,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 2,
	)


/datum/outfit/armadyne_security/commander/high_alert
	name = "阿玛戴恩企业安保指挥官（高度警戒）"
	suit_store = /obj/item/gun/ballistic/automatic/sol_rifle
	backpack_contents = list(
		/obj/item/melee/baton/telescopic,
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/skild,
		/obj/item/storage/box/handcuffs,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 2,
	)

/obj/item/card/id/advanced/armadyne
	name = "\improper 阿玛戴恩ID卡"
	desc = "一张阿玛戴恩ID卡。"
	icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	registered_age = null
	trim = /datum/id_trim/centcom/armadyne
	wildcard_slots = WILDCARD_LIMIT_CENTCOM

/datum/id_trim/centcom/armadyne
	assignment = "Armadyne Corporate"
	trim_state = "trim_ert_commander"

/datum/id_trim/centcom/armadyne/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_GENERAL, REGION_CENTCOM)) // They're not with CC so they get fuck-all access on-station

/obj/item/card/id/advanced/armadyne/security
	registered_name = "Armadyne Corpo"
	trim = /datum/id_trim/centcom/armadyne/security

/datum/id_trim/centcom/armadyne/security
	assignment = "Armadyne Corporate Security Detail"
	trim_state = "trim_ert_commander"

/obj/item/card/id/advanced/armadyne/agent
	trim = /datum/id_trim/centcom/armadyne/agent

/datum/id_trim/centcom/armadyne/agent
	assignment = "Armadyne Corporate Directorate"
	trim_state = "trim_ert_commander"

/datum/outfit/armadyne_rep/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
	..()

/obj/item/card/id/armadyne/corpo/security
	assignment = "Armadyne Corporate Security"


/datum/antagonist/ert/armadyne
	name = "阿玛戴恩企业安保"
	outfit = /datum/outfit/armadyne_security
	role = "Security"

/datum/antagonist/ert/armadyne/high_alert
	name = "阿玛戴恩企业安保（高度警戒）"
	outfit = /datum/outfit/armadyne_security/high_alert
	role = "Security"

/datum/antagonist/ert/armadyne/leader
	name = "阿玛戴恩企业安保指挥官"
	outfit = /datum/outfit/armadyne_security/commander
	role = "Commander"

/datum/antagonist/ert/armadyne/leader/high_alert
	name = "阿玛戴恩企业安保指挥官（高度警戒）"
	outfit = /datum/outfit/armadyne_security/commander/high_alert
	role = "Commander"


/datum/ert/armadyne
	roles = list(/datum/antagonist/ert/armadyne)
	leader_role = /datum/antagonist/ert/armadyne/leader
	rename_team = "Armadyne PMC"
	mission = "Assist any Armadyne corporate entities."
	polldesc = "an Armadyne PMC."
	teamsize = 3

/datum/ert/armadyne/high_alert
	roles = list(/datum/antagonist/ert/armadyne/high_alert)
	leader_role = /datum/antagonist/ert/armadyne/leader/high_alert
	rename_team = "Armadyne PMC (High Alert)"
