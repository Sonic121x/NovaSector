/*
 *	GENETICIST (TO-DO)
 *  Add geneticist icons!!!
 */

/*
/obj/item/clothing/under/rank/rnd/geneticist/nova/utility
	name = "genetics utility uniform"
	desc = "A utility uniform worn by NT-certified Genetics staff."
	icon_state = "util_gene"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	can_adjust = FALSE

/obj/item/clothing/under/rank/rnd/geneticist/nova/utility/syndicate
	desc = "A utility uniform worn by Genetics staff."
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS
*/

/*
 *	SCIENTIST
 */
/obj/item/clothing/under/rank/rnd/scientist/nova/utility
	name = "科研部门实用制服"
	desc = "纳米传讯认证的科研部门人员穿着的实用制服。"
	icon_state = "util_sci"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/scientist/nova/utility/syndicate
	desc = "科研部门人员穿着的实用制服。"
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/rnd/scientist/nova/hlscience
	name = "科研团队制服"
	desc = "一套简单的半正式制服，包括一件灰蓝色衬衫和米白色长裤，搭配一条可笑但强制要求的领带。"
	icon_state = "hl_scientist"
	can_adjust = FALSE

/obj/item/clothing/under/rank/rnd/scientist/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/rnd.dmi'
	icon_state = null //debug item

/*
 *	ROBOTICIST
 */
/obj/item/clothing/under/rank/rnd/roboticist/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/rnd.dmi'
	icon_state = null //debug item

/*
 *	RESEARCH DIRECTOR
 */
/obj/item/clothing/under/imperial/rd
	desc = "一件米白色海军上衣配黑色长裤，带有表示内部科学部门军官的军衔徽章。这是平静的生活。"
	name = "研究主管的海军连体服"
	icon_state = "/obj/item/clothing/under/imperial/rd"
	greyscale_colors = "#ededed#39393f#7e1980#373741#FFFFFF#a80100#fac719"
	flags_1 = NONE

/obj/item/clothing/under/imperialskirt/rd
	desc = "一件米白色海军裙装，带有表示内部科学部门军官的军衔徽章。这是平静的生活。"
	name = "研究主管的海军裙装"
	icon_state = "/obj/item/clothing/under/imperialskirt/rd"
	greyscale_colors = "#ededed#7e1980#373741#FFFFFF#a80100#fac719"
	flags_1 = NONE


/obj/item/clothing/under/rank/rnd/research_director/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/rnd.dmi'
	icon_state = null //debug item

/obj/item/clothing/under/rank/rnd/research_director/alt
	greyscale_config_worn_digi = /datum/greyscale_config/buttondown_slacks/worn/digi

/obj/item/clothing/under/rank/rnd
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/rnd_digi.dmi'
