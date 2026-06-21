#define RESKIN_CHARCOAL "Charcoal"
#define RESKIN_NT "NT Blue"
#define RESKIN_SYNDIE "Syndicate Red"

/obj/item/clothing/under/syndicate
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/syndicate_digi.dmi'

/obj/item/clothing/under/syndicate/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/syndicate.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/syndicate.dmi'
	//These are pre-set for ease and reference, as syndie under items SHOULDNT have sensors and should have similar stats; also it's better to start with adjust = false
	has_sensor = NO_SENSORS
	can_adjust = FALSE

//Related files:
// modular_nova\modules\syndie_edits\code\syndie_edits.dm (this has the Overalls and non-Uniforms)
// modular_nova\modules\novaya_ert\code\uniform.dm (HC uniform(s))

/*
*	TACTICOOL
*/

//This is an overwrite, not a fully new item, but still fits best here.

/datum/atom_skin/tacticool_turtleneck
	abstract_type = /datum/atom_skin/tacticool_turtleneck

/datum/atom_skin/tacticool_turtleneck/blue
	preview_name = RESKIN_NT
	new_icon_state = "tactifool_blue"

/datum/atom_skin/tacticool_turtleneck/charcoal
	preview_name = RESKIN_CHARCOAL
	new_icon_state = "tactifool"
	new_inhand_icon_state = "bl_suit"

/datum/atom_skin/tacticool_turtleneck/charcoal/apply(atom/apply_to, mob/user)
	. = ..()
	var/obj/item/applying_to = apply_to
	applying_to.desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-." //Default decription of the normal tacticool
	applying_to.update_desc()

/obj/item/clothing/under/syndicate/tacticool //Overwrites the 'fake' one. Zero armor, sensors, and default blue. More Balanced to make station-available.
	name = "战酷高领毛衣"
	desc = "一件合身的高领毛衣，采用华丽的纳米传讯蓝色。光是看着它，你就想买一杯纳米传讯认证的咖啡，走进办公室，然后 -工作-。"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/syndicate.dmi' //Since its an overwrite it needs new icon linking. Woe.
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/syndicate.dmi'
	icon_state = "tactifool_blue"
	inhand_icon_state = "b_suit"
	can_adjust = TRUE
	has_sensor = HAS_SENSORS
	armor_type = /datum/armor/clothing_under
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	resistance_flags = FLAMMABLE

/obj/item/clothing/under/syndicate/tacticool/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/tacticool_turtleneck)

/obj/item/clothing/under/syndicate/tacticool/skirt //Overwrites the 'fake' one. Zero armor, sensors, and default blue. More Balanced to make station-available.
	name = "战酷高领毛衣裙"
	desc = "一件合身的裙式高领衫，采用华丽的纳米传讯蓝色。光是看着它，你就想买一杯纳米传讯认证的咖啡，走进办公室，然后 -工作-。"
	icon_state = "tactifool_blue_skirt"
	gets_cropped_on_taurs = FALSE
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT

/obj/item/clothing/under/syndicate/bloodred/sleepytime/sensors //Halloween-only
	has_sensor = HAS_SENSORS
	armor_type = /datum/armor/clothing_under
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/syndicate/nova/baseball
	name = "辛迪加棒球衫"
	desc = "辛迪加毒蛇队已准备就位，即将打出他们标志性的核弹本垒打！让我们给这些公司狗一点颜色看看。" //NT pitches their plasma/bluespace(something)
	icon_state = "syndicate_baseball"

/obj/item/clothing/under/syndicate/unarmoured
	name = "可疑战术高领衫"
	desc = "一套普通的，看起来有点可疑的高领毛衣和数码迷彩工装裤。"
	icon_state = "syndicate"
	inhand_icon_state = "bl_suit"
	has_sensor = HAS_SENSORS
	armor_type = /datum/armor/clothing_under

/obj/item/clothing/under/syndicate/unarmoured/skirt
	name = "可疑战术裙领衫"
	desc = "一件颜色平淡、略显可疑的高领毛衣。"
	icon_state = "syndicate_skirt"
	gets_cropped_on_taurs = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/syndicate/unarmoured/examine_more(mob/user)
	. = ..()
	. += span_notice("装甲已经从织物上被移除了。")

/obj/item/clothing/under/syndicate/nova/tactical/unarmoured
	name = "可疑战术高领衫"
	desc = "一件贴身的辛迪加红高领衫，搭配炭黑色货运裤。"
	icon_state = "syndicate_red"
	inhand_icon_state = "r_suit"
	has_sensor = HAS_SENSORS
	armor_type = /datum/armor/clothing_under

/obj/item/clothing/under/syndicate/nova/tactical/unarmoured/setup_reskins()
	return

/obj/item/clothing/under/syndicate/nova/tactical/unarmoured/skirt
	name = "可疑战术裙领衫"
	desc = "一条时髦的工装裤，内搭高领衫，这条是裙子款式，很通风。"
	icon_state = "syndicate_red_skirt"
	gets_cropped_on_taurs = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/syndicate/nova/tactical/unarmoured/examine_more(mob/user)
	. = ..()
	. += span_notice("装甲已经从织物上被移除了。")

/obj/item/clothing/under/syndicate/nova/overalls/unarmoured
	name = "可疑工装裤高领衫"
	desc = "一条时髦的工装裤，内搭高领衫，适用于工程和植物学工作。"
	icon_state = "syndicate_overalls"
	armor_type = /datum/armor/clothing_under
	has_sensor = HAS_SENSORS
	can_adjust = TRUE

/obj/item/clothing/under/syndicate/nova/overalls/unarmoured/skirt
	name = "可疑工装裤裙领衫"
	desc = "一条时髦的工装裤，内搭高领衫，这条是裙子款式，很通风。"
	icon_state = "syndicate_overallskirt"
	gets_cropped_on_taurs = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/syndicate/nova/overalls/unarmoured/examine_more(mob/user)
	. = ..()
	. += span_notice("装甲已经从织物上被移除了。")

/obj/item/clothing/mask/neck_gaiter/syndicate/tacticool
	name = "战术酷颈套"
	desc = "一款科技风面罩。其低调的设计与锐利的边缘形成对比。配有一个小型呼吸器，可与内部供气系统一起使用。"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/*
*	TACTICAL (Real)
*/
//The red alts, for BLATANTLY syndicate stuff (Like DS2)
// (Multiple non-syndicate things use the base tactical turtleneck, they cant have it red nor reskinnable. OUR version, however, can be.)
/datum/atom_skin/tactical_turtleneck
	abstract_type = /datum/atom_skin/tactical_turtleneck

/datum/atom_skin/tactical_turtleneck/red
	preview_name = RESKIN_SYNDIE
	new_icon_state = "syndicate_red"

/datum/atom_skin/tactical_turtleneck/charcoal
	preview_name = RESKIN_CHARCOAL
	new_icon_state = "syndicate"
	new_inhand_icon_state = "bl_suit"

/datum/atom_skin/tactical_turtleneck/charcoal/apply(atom/apply_to, mob/user)
	. = ..()
	var/obj/item/applying_to = apply_to
	applying_to.desc = "一套普通的，看起来有点可疑的高领毛衣和数码迷彩工装裤。" //(Digital camo? Brown? What?)
	applying_to.update_desc()

/obj/item/clothing/under/syndicate/nova/tactical
	name = "战术高领毛衣"
	desc = "一件贴身的辛迪加红高领衫，搭配炭黑色货运裤。穿着这个还想辩解自己的阵营可不容易。"
	icon_state = "syndicate_red"
	inhand_icon_state = "r_suit"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	armor_type = /datum/armor/clothing_under/syndicate
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/syndicate/nova/tactical/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/tactical_turtleneck)

/datum/atom_skin/tactical_skirtleneck
	abstract_type = /datum/atom_skin/tactical_skirtleneck

/datum/atom_skin/tactical_skirtleneck/red
	preview_name = RESKIN_SYNDIE
	new_icon_state = "syndicate_red_skirt"

/datum/atom_skin/tactical_skirtleneck/charcoal
	preview_name = RESKIN_CHARCOAL
	new_icon_state = "syndicate_skirt"
	new_inhand_icon_state = "bl_suit"

/datum/atom_skin/tactical_skirtleneck/charcoal/apply(atom/apply_to, mob/user)
	. = ..()
	var/obj/item/applying_to = apply_to
	applying_to.desc = "一件颜色平淡、略显可疑的高领毛衣。"
	applying_to.update_desc()

/obj/item/clothing/under/syndicate/nova/tactical/skirt
	name = "战术高领毛衣裙"
	desc = "一件贴身的辛迪加红裙领衫，搭配炭黑色裙子。穿着这个还想辩解自己的阵营可不容易。"
	icon_state = "syndicate_red_skirt"
	inhand_icon_state = "r_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/syndicate/nova/tactical/skirt/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/tactical_skirtleneck)

/obj/item/clothing/under/syndicate/skirt/coldres
	name = "绝缘战术高领裙"
	desc = "一条不起眼且略显可疑的裙领衫。内部填充了特殊绝缘材料，兼具保暖和保护功能。"
	armor_type = /datum/armor/clothing_under/syndicate/coldres
	cold_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT


/*
*	ENCLAVE
*/
/obj/item/clothing/under/syndicate/nova/enclave
	name = "新美国士官制服"
	desc = "在星际间，关于疯狂科学家和愤怒教官的谣言四起；关于身着漆黑如夜盔甲的生物，被穿着这种制服的男女所领导的传说。他们有一个共同点：对美利坚之梦怀有深刻而狂热的民族主义热情。"
	icon_state = "enclave"
	can_adjust = TRUE
	armor_type = /datum/armor/clothing_under

/obj/item/clothing/under/syndicate/nova/enclave/officer
	name = "新美利坚军官制服"
	icon_state = "enclaveo"

/obj/item/clothing/under/syndicate/nova/enclave/real
	armor_type = /datum/armor/clothing_under/syndicate

/obj/item/clothing/under/syndicate/nova/enclave/real/officer
	name = "新美利坚军官制服"
	icon_state = "enclaveo"

#undef RESKIN_CHARCOAL
#undef RESKIN_NT
#undef RESKIN_SYNDIE
