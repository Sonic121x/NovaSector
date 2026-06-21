/obj/item/clothing/under/syndicate
	name = "战术高领毛衣"
	desc = "A nondescript and slightly suspicious looking turtleneck with digital camouflage cargo pants."
	icon_state = "syndicate"
	inhand_icon_state = "bl_suit"
	has_sensor = NO_SENSORS
	armor_type = /datum/armor/clothing_under/syndicate
	alt_covers_chest = TRUE
	icon = 'icons/obj/clothing/under/syndicate.dmi'
	worn_icon = 'icons/mob/clothing/under/syndicate.dmi'

/datum/armor/clothing_under/syndicate
	melee = 10
	fire = 50
	acid = 40
	wound = 10

/obj/item/clothing/under/syndicate/skirt
	name = "战术高领毛衣裙"
	desc = "A nondescript and slightly suspicious looking skirtleneck."
	icon_state = "syndicate_skirt"
	inhand_icon_state = "bl_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/syndicate/bloodred
	name = "血红紧身衣"
	desc = "如果没有目击证人，也算秘密行动。"
	icon_state = "bloodred_pajamas"
	inhand_icon_state = "bl_suit"
	armor_type = /datum/armor/clothing_under/syndicate_bloodred
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/syndicate/bloodred/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4) //extra-tactical

/datum/armor/clothing_under/syndicate_bloodred
	melee = 10
	bullet = 10
	laser = 10
	energy = 10
	fire = 50
	acid = 40
	wound = 10

/obj/item/clothing/under/syndicate/bloodred/sleepytime
	name = "血红睡衣"
	desc = "核特工会梦见核能羊吗"
	icon_state = "bloodred_pajamas"
	inhand_icon_state = "bl_suit"
	armor_type = /datum/armor/clothing_under/bloodred_sleepytime

/datum/armor/clothing_under/bloodred_sleepytime
	fire = 50
	acid = 40

/obj/item/clothing/under/syndicate/tacticool
	name = "战酷高领毛衣"
	desc = "只是看着它，你就想买一个SKS，走进树林，然后——操作——。"
	icon_state = "tactifool"
	inhand_icon_state = "bl_suit"
	has_sensor = HAS_SENSORS
	armor_type = /datum/armor/clothing_under/syndicate_tacticool
	stubborn_stains = TRUE

/datum/armor/clothing_under/syndicate_tacticool
	fire = 50
	acid = 40

/obj/item/clothing/under/syndicate/tacticool/examine(mob/user)
	. = ..()
	. += "It has a label that says cleaning this 'genuine' Waffle Corp. product with cleaning solutions other than Grime Liberator telelocational podcrystals will void the warranty."
	. += "What on earth is a <font color='red'>tele</font>locational pod<font color='red'>crystal</font>?"

/obj/item/clothing/under/syndicate/tacticool/dye_item(dye_color, dye_key_override)
	if(dye_color == DYE_SYNDICATE)
		if(dying_key == DYE_REGISTRY_JUMPSKIRT)
			special_wash(/obj/item/clothing/under/syndicate/skirt)
		else
			special_wash(/obj/item/clothing/under/syndicate)
		qdel(src)
		return
	return ..()

/obj/item/clothing/under/syndicate/tacticool/proc/special_wash(obj/item/clothing/under/syndicate/our_jumpsuit)
	new our_jumpsuit(loc)

/obj/item/clothing/under/syndicate/tacticool/skirt
	name = "战酷高领毛衣裙"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon_state = "tactifool_skirt"
	inhand_icon_state = "bl_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/syndicate/sniper
	name = "战术高领毛衣套装"
	desc = "A double seamed tactical turtleneck disguised as a civilian-grade silk suit. Intended for the most formal operator. The collar is really sharp."
	icon_state = "tactical_suit"
	inhand_icon_state = "bl_suit"
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/syndicate/camo
	name = "迷彩服"
	desc = "绿色的军用迷彩服。"
	icon_state = "camogreen"
	inhand_icon_state = "g_suit"
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/syndicate/cybersun
	name = "\improper Cybersun businesswear"
	desc = "This black and orange businesswear appears to be made of some kind of protective lightweight material. \
		Perfect for hostile takeovers and budget meetings."
	icon_state = "cybersun_suit"
	inhand_icon_state = "bl_suit"
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/syndicate/floortilecamo
	name = "floortile camouflage fatigues"
	desc = "The newest floortile camouflage fatigues used for hallway warfare. \
		The best breathability, flexibility and comfort. Designed by Camo-J's."
	icon_state = "camofloortile"
	inhand_icon_state = "gy_suit"
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/syndicate/floortilecamo/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5) //tacticool

/obj/item/clothing/under/syndicate/soviet
	name = "Ratnik 5 tracksuit"
	desc = "翻译错误的标签告诉你要用伏特加清洗这件衣服。很适合斯拉夫蹲。"
	icon_state = "trackpants"
	can_adjust = FALSE
	supports_variations_flags = NONE
	armor_type = /datum/armor/clothing_under/syndicate_soviet
	resistance_flags = NONE

/datum/armor/clothing_under/syndicate_soviet
	melee = 10

/obj/item/clothing/under/syndicate/combat
	name = "战斗制服"
	desc = "有了这么多口袋的制服，你就做好了行动的准备了。"
	icon_state = "syndicate_combat"
	can_adjust = FALSE
	supports_variations_flags = NONE

/obj/item/clothing/under/syndicate/rus_army
	name = "高级军用运动服"
	desc = "用于前线蹲姿训练的的军用级别运动服。"
	icon_state = "rus_under"
	can_adjust = FALSE
	supports_variations_flags = NONE
	armor_type = /datum/armor/clothing_under/syndicate_rus_army
	resistance_flags = NONE

/datum/armor/clothing_under/syndicate_rus_army
	melee = 5

/obj/item/clothing/under/syndicate/scrubs
	name = "战术外科手术服"
	desc = "一套深酒红色的医护服，出于战术原因而专门设计。"
	icon = 'icons/obj/clothing/under/medical.dmi'
	worn_icon = 'icons/mob/clothing/under/medical.dmi'
	icon_state = "scrubswine"
	can_adjust = FALSE
	supports_variations_flags = NONE
	armor_type = /datum/armor/clothing_under/syndicate_scrubs

/obj/item/clothing/under/syndicate/scrubs/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //FISH DOCTOR?!

/datum/armor/clothing_under/syndicate_scrubs
	melee = 10
	bio = 50
	fire = 50
	acid = 40

/obj/item/clothing/under/plasmaman/syndicate
	name = "tacticool envirosuit"
	desc = "A sinister looking envirosuit, for the boniest of operatives."
	icon_state = "syndie_envirosuit"
	has_sensor = NO_SENSORS
	resistance_flags = FIRE_PROOF
	inhand_icon_state = null
