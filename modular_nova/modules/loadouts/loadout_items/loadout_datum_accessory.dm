// LOADOUT ITEM DATUMS FOR THE ACCESSORY SLOT

/datum/loadout_category/accessories
	category_ui_icon = FA_ICON_ID_BADGE
	tab_order = /datum/loadout_category/undersuit::tab_order + 1

/datum/loadout_item/accessory/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, visuals_only = FALSE)
	if(initial(outfit_important_for_life.accessory))
		.. ()
		return TRUE

/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.accessory)
			LAZYADD(outfit.backpack_contents, outfit.accessory)
		outfit.accessory = item_path
	else
		outfit.accessory = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/accessory/chaps
	name = "皮护腿套裤"
	item_path = /obj/item/clothing/accessory/chaps

/datum/loadout_item/accessory/maidcorset_tactical
	name = "女仆围裙 - 战术型"
	item_path = /obj/item/clothing/accessory/maidcorset/syndicate/loadout_corset

/datum/loadout_item/accessory/wetmaker
	name = "星裙水汽蒸发器"
	item_path = /obj/item/clothing/accessory/vaporizer

/*
*	ARMBANDS
*/

/datum/loadout_item/accessory/armband_medblue
	name = "臂章（蓝白）"
	item_path = /obj/item/clothing/accessory/armband/medblue/nonsec

/datum/loadout_item/accessory/armband_cargo
	name = "臂章（棕色）"
	item_path = /obj/item/clothing/accessory/armband/cargo/nonsec

/datum/loadout_item/accessory/armband_engineering
	name = "臂章（橙色）"
	item_path = /obj/item/clothing/accessory/armband/engine/nonsec

/datum/loadout_item/accessory/armband_science
	name = "臂章（紫色）"
	item_path = /obj/item/clothing/accessory/armband/science/nonsec

/datum/loadout_item/accessory/armband_security_nonsec
	name = "臂章（红色）"
	item_path = /obj/item/clothing/accessory/armband/nonsec

/datum/loadout_item/accessory/armband_med
	name = "臂章（白色）"
	item_path = /obj/item/clothing/accessory/armband/med/nonsec

/datum/loadout_item/accessory/armband_security
	name = "臂章 - 安保副手"
	item_path = /obj/item/clothing/accessory/armband/deputy
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/accessory/green_pin
	name = "绿色“新手”徽章"
	item_path = /obj/item/clothing/accessory/green_pin

/datum/loadout_item/accessory/holobadge
	name = "全息徽章"
	item_path = /obj/item/clothing/accessory/badge/holo
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/accessory/holobadge/blue
	name = "全息徽章（蓝色）"
	item_path = /obj/item/clothing/accessory/badge/holo/blue
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/accessory/holobadge/lanyard
	name = "全息徽章（挂绳式）"
	item_path = /obj/item/clothing/accessory/badge/holo/cord
	restricted_roles = list(ALL_JOBS_SEC)

/*
*	ARMOURLESS
*/

/datum/loadout_item/accessory/bone_charm
	name = "传家宝骨制护符"
	item_path = /obj/item/clothing/accessory/talisman/armourless

/datum/loadout_item/accessory/bone_charm/get_item_information()
	. = ..()
	.[FA_ICON_SHIELD_ALT] = TOOLTIP_NO_ARMOR

/datum/loadout_item/accessory/bone_codpiece
	name = "传家宝颅骨护裆"
	item_path = /obj/item/clothing/accessory/skullcodpiece/armourless

/datum/loadout_item/accessory/bone_codpiece/get_item_information()
	. = ..()
	.[FA_ICON_SHIELD_ALT] = TOOLTIP_NO_ARMOR

/datum/loadout_item/accessory/sinew_kilt
	name = "传家宝筋腱短裙"
	item_path = /obj/item/clothing/accessory/skilt/armourless

/datum/loadout_item/accessory/sinew_kilt/get_item_information()
	. = ..()
	.[FA_ICON_SHIELD_ALT] = TOOLTIP_NO_ARMOR

/*
*
* Accessory Medals
*
*/
/datum/loadout_item/accessory/medal
	abstract_type = /datum/loadout_item/accessory/medal
	group = "Medals"

/datum/loadout_item/accessory/medal/dogtags
	name = "狗牌"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/dogtags

/datum/loadout_item/accessory/medal/shield
	name = "勋章 - 盾形"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/shield

/datum/loadout_item/accessory/medal/shield_br
	name = "勋章 - 盾形（横条绶带）"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/shield/bar_ribbon

/datum/loadout_item/accessory/medal/shield_h
	name = "勋章 - 盾形（镂空）"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/shield/hollow

/datum/loadout_item/accessory/medal/bar
	name = "勋章 - 条形"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/bar

/datum/loadout_item/accessory/medal/bar_br
	name = "勋章 - 条形（横条绶带）"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/bar/bar_ribbon

/datum/loadout_item/accessory/medal/bar_h
	name = "勋章 - 条形（镂空）"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/bar/hollow

/datum/loadout_item/accessory/medal/circle
	name = "勋章 - 圆形"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/circle

/datum/loadout_item/accessory/medal/circle_br
	name = "勋章 - 圆形（横条绶带）"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/circle/bar_ribbon

/datum/loadout_item/accessory/medal/circle_alt
	name = "勋章 - 圆形 (变体)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal
	//This is actually the default setup for our medals!

/datum/loadout_item/accessory/medal/circle_h
	name = "勋章 - 圆形 (空心)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/circle/hollow

/datum/loadout_item/accessory/medal/circle_h_br
	name = "勋章 - 圆形 (空心, 条带绶带)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/circle/hollow/bar_ribbon

/datum/loadout_item/accessory/medal/heart
	name = "勋章 - 心形"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/heart

/datum/loadout_item/accessory/medal/heart_br
	name = "勋章 - 心形 (条带绶带)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/heart/bar_ribbon

/datum/loadout_item/accessory/medal/heart_s
	name = "勋章 - 心形 (特殊)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/heart/special

/datum/loadout_item/accessory/medal/heart_s_br
	name = "勋章 - 心形 (特殊, 条带绶带)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/heart/special/bar_ribbon

/datum/loadout_item/accessory/medal/crown
	name = "勋章 - 王冠"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/crown

/datum/loadout_item/accessory/medal/crown_br
	name = "勋章 - 王冠 (条带绶带)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/crown/bar_ribbon

/datum/loadout_item/accessory/medal/crown_h
	name = "勋章 - 王冠 (空心)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/crown/hollow

/datum/loadout_item/accessory/medal/crown_h_br
	name = "勋章 - 王冠 (空心, 条带绶带)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/crown/hollow/bar_ribbon

/datum/loadout_item/accessory/medal/glow_crystal
	name = "发光水晶项链"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/glowcrystal
	reskin_datum = /datum/atom_skin/glow_crystal_necklace

/datum/loadout_item/accessory/medal/rankpin_star
	name = "军衔徽章 (星形)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/rankpin

/datum/loadout_item/accessory/medal/rankpin_bar
	name = "军衔徽章 (条形)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/rankpin/bar

/datum/loadout_item/accessory/medal/rankpin_twobar
	name = "军衔徽章 (双条形)"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/rankpin/two_bar

/*
* Special Pins
*/

/datum/loadout_item/accessory/medal/cc_pin
	name = "颈针 - 中央司令部"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/neckpin/centcom
	restricted_roles = list(JOB_CAPTAIN, ALL_JOBS_CC)

/datum/loadout_item/accessory/medal/nt_pin
	name = "颈针 - 纳米传讯"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/neckpin

/datum/loadout_item/accessory/medal/pt_pin
	name = "颈针 - 塔尔孔港"
	item_path = /obj/item/clothing/accessory/nova/acc_medal/neckpin/porttarkon

/*
* Ribbons
*/

/datum/loadout_item/accessory/medal/ribbon_mil
	name = "绶带 - 军事 (单色)"
	item_path = /obj/item/clothing/accessory/nova/military_ribbon

/datum/loadout_item/accessory/medal/ribbon_mil_2
	name = "绶带 - 军事 (双色)"
	item_path = /obj/item/clothing/accessory/nova/military_ribbon/two

/datum/loadout_item/accessory/medal/ribbon_mil_3
	name = "绶带 - 军事（三色）"
	item_path = /obj/item/clothing/accessory/nova/military_ribbon/three

/datum/loadout_item/accessory/medal/ribbon
	name = "绶带（下箭头）"
	item_path = /obj/item/clothing/accessory/nova/ribbon

/datum/loadout_item/accessory/medal/ribbon2
	name = "绶带（斜杠）"
	item_path = /obj/item/clothing/accessory/nova/ribbon/ribbon_slash

/datum/loadout_item/accessory/medal/ribbon3
	name = "绶带（上箭头）"
	item_path = /obj/item/clothing/accessory/nova/ribbon/ribbon_arrup

/datum/loadout_item/accessory/medal/ribbon4
	name = "绶带（线条）"
	item_path = /obj/item/clothing/accessory/nova/ribbon/ribbon_line

/datum/loadout_item/accessory/medal/ribbon5
	name = "绶带（双色）"
	item_path = /obj/item/clothing/accessory/nova/ribbon/ribbon_dual

/datum/loadout_item/accessory/medal/ribbon6
	name = "绶带（扁平）"
	item_path = /obj/item/clothing/accessory/nova/ribbon/ribbon_flat

/datum/loadout_item/accessory/medal/ribbon7
	name = "绶带（双色调）"
	item_path = /obj/item/clothing/accessory/nova/ribbon/ribbon_twotone

/*
* Webbings
*/

/datum/loadout_item/accessory/webbing
	name = "战术背带 - 基础型"
	item_path = /obj/item/clothing/accessory/webbing

/datum/loadout_item/accessory/colonial_webbing
	name = "战术背带 - 殖民型"
	item_path = /obj/item/clothing/accessory/webbing/colonial

/datum/loadout_item/accessory/webbing_vest
	name = "战术背带 - 背心型"
	item_path = /obj/item/clothing/accessory/webbing/vest
	reskin_datum = /datum/atom_skin/webbing_vest

/datum/loadout_item/accessory/webbing_pouch
	name = "战术背带 - 垂挂包型"
	item_path = /obj/item/clothing/accessory/webbing/pouch
	reskin_datum = /datum/atom_skin/drop_pouches

/datum/loadout_item/accessory/webbing_pilot
	name = "战术背带 - 索具型"
	item_path = /obj/item/clothing/accessory/webbing/pilot
	reskin_datum = /datum/atom_skin/storage_rigging
