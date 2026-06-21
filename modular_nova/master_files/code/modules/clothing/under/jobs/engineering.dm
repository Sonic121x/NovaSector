/obj/item/clothing/under/rank/engineering
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/engineering_digi.dmi'

/obj/item/clothing/under/rank/engineering/engineer/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/engineering.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/engineering.dmi'

/obj/item/clothing/under/rank/engineering/chief_engineer/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/engineering.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/engineering.dmi'

/obj/item/clothing/under/rank/engineering/atmospheric_technician/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/engineering.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/engineering.dmi'

/*
*	ENGINEER
*/

/obj/item/clothing/under/rank/engineering/engineer/nova/utility
	name = "工程实用制服"
	desc = "工程部门人员穿着的实用制服。"
	icon_state = "util_eng"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/engineering/engineer/nova/utility/syndicate
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/engineering/engineer/nova/trouser
	name = "工程长裤"
	desc = "一条工程橙色的裤子。其腰带上自豪地展示着一个“防辐射”符号，不过仅靠防辐射裤子的效果仍有待商榷。"
	icon_state = "workpants_orange"
	body_parts_covered = GROIN|LEGS
	can_adjust = FALSE
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS

/obj/item/clothing/under/rank/engineering/engineer/nova/hazard_chem
	name = "化学危害连体服"
	desc = "一套高可见度连体服，对气体和化学危害提供额外防护，但防火性能较差。"
	icon_state = "hazard_green"
	armor_type = /datum/armor/clothing_under/nova_hazard_chem
	resistance_flags = ACID_PROOF
	alt_covers_chest = TRUE

/datum/armor/clothing_under/nova_hazard_chem
	fire = 20
	acid = 60

/obj/item/clothing/under/rank/engineering/engineer/nova/hazard_chem/emt
	name = "化学危害急救员连体服"
	desc = "用于涉及气体和/或化学危害情况的第一响应者的急救员连体服。标签上写着：“非为长时间暴露设计”。"
	icon_state = "hazard_white"
	armor_type = /datum/armor/clothing_under/hazard_chem_emt

/datum/armor/clothing_under/hazard_chem_emt
	fire = 10
	acid = 50

/*
*	CHIEF ENGINEER
*/
/obj/item/clothing/under/imperial/ce
	desc = "一套橄榄褐色的海军制服，配有表示内部工程部门主管的军衔徽章。不附带死亡机器建造指南。"
	name = "首席工程师海军连体服"
	icon_state = "/obj/item/clothing/under/imperial/ce"
	greyscale_colors = "#404429#404429#43443f#373741#ffffff#f48600#5c97e6"
	flags_1 = NONE
	armor_type = /datum/armor/clothing_under/engineering_chief_engineer

/obj/item/clothing/under/imperialskirt/ce
	desc = "一件橄榄褐色的海军裙，配有表示内部工程部军官的军衔徽章。不附带死亡机器建造指南。"
	name = "首席工程师的海军裙"
	icon_state = "/obj/item/clothing/under/imperialskirt/ce"
	greyscale_colors = "#404429#43443f#373741#ffffff#f48600#5c97e6"
	flags_1 = NONE
	armor_type = /datum/armor/clothing_under/engineering_chief_engineer

/*
*	ATMOS TECH
*/
/datum/armor/clothing_under/atmos_adv
	bio = 40
	fire = 70
	acid = 70

/obj/item/clothing/under/rank/engineering/atmospheric_technician/nova/utility/advanced
	name = "高级大气处理制服"
	desc = "高级大气处理人员穿着的连体服。"
	icon_state = "util_atmos"
	armor_type = /datum/armor/clothing_under/atmos_adv
	icon_state = "util_eng"
	can_adjust = FALSE

/*
*	TELECOMMS SPECIALIST
*/

/obj/item/clothing/under/rank/engineering/engineer/nova/utility/telecomm
	desc = "这是一件电信专家穿着的连体服。由防火材料制成。"
	name = "电信连体服"
	icon_state = "telecomm"
	can_adjust = TRUE

/obj/item/clothing/under/rank/engineering/engineer/nova/utility/telecomm/skirt
	desc = "这是一件电信专家穿着的连体裙。由防火材料制成。"
	name = "电信连体裙"
	icon_state = "telecomm_skirt"
	can_adjust = TRUE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	gets_cropped_on_taurs = FALSE
