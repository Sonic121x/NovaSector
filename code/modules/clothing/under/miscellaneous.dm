/obj/item/clothing/under/misc
	icon = 'icons/obj/clothing/under/misc.dmi'
	worn_icon = 'icons/mob/clothing/under/misc.dmi'
	abstract_type = /obj/item/clothing/under/misc

/obj/item/clothing/under/misc/pj
	name = "\improper 睡衣"
	desc = "一套舒适的睡衣，用来偷懒小睡而不是工作。"
	can_adjust = FALSE
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/misc/pj/red
	icon_state = "red_pyjamas"

/obj/item/clothing/under/misc/pj/blue
	icon_state = "blue_pyjamas"

/obj/item/clothing/under/misc/patriotsuit
	name = "爱国套装"
	desc = "摩托车不包括在内。"
	icon_state = "ek"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/misc/mailman
	name = "邮差连身衣"
	desc = "<i>'你快递到了!'</i>"
	icon_state = "mailman"
	inhand_icon_state = "b_suit"
	clothing_traits = list(TRAIT_HATED_BY_DOGS)
	custom_premium_price = PAYCHECK_CREW

/obj/item/clothing/under/misc/psyche
	name = "迷幻连身衣"
	desc = "我大了！"
	icon_state = "psyche"
	inhand_icon_state = "p_suit"

/obj/item/clothing/under/misc/psyche/get_general_color(icon/base_icon)
	return "#3f3f3f"

/obj/item/clothing/under/misc/vice_officer
	name = "代理警官连身衣"
	desc = "这是标准的帅哥装扮，就像辛迪加午逼TV里播放的那样。"
	icon_state = "vice"
	inhand_icon_state = "gy_suit"
	can_adjust = FALSE

/obj/item/clothing/under/misc/adminsuit
	name = "管理员电子连身衣"
	icon = 'icons/obj/clothing/under/syndicate.dmi'
	icon_state = "syndicate"
	inhand_icon_state = "bl_suit"
	worn_icon = 'icons/mob/clothing/under/syndicate.dmi'
	desc = "一种用于执行管理任务的控制论强化连身衣。"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/clothing_under/adminsuit
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	can_adjust = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/under/misc/adminsuit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -25)

/datum/armor/clothing_under/adminsuit
	melee = 100
	bullet = 100
	laser = 100
	energy = 100
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
	wound = 100

/obj/item/clothing/under/misc/burial
	name = "葬礼服"
	desc = "22世纪早期的传统丧服。"
	icon_state = "burial"
	inhand_icon_state = null
	can_adjust = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/misc/overalls
	name = "工人服"
	desc = "工作服：为完成工作而穿的一套耐穿工作服"
	icon_state = "overalls"
	inhand_icon_state = "lb_suit"
	can_adjust = FALSE
	custom_price = PAYCHECK_CREW

/obj/item/clothing/under/misc/assistantformal
	name = "助手的正装制服"
	desc = "助手的正装。助手为什么需要正装还不得而知。"
	icon_state = "assistant_formal"
	inhand_icon_state = "gy_suit"
	can_adjust = FALSE

/obj/item/clothing/under/misc/durathread
	name = "杜拉棉连身衣"
	desc = "一件由杜拉棉制成的连身衣，它的弹性纤维为穿着者提供了一些保护。"
	icon_state = "durathread"
	inhand_icon_state = null
	can_adjust = FALSE
	armor_type = /datum/armor/clothing_under/durathread

/datum/armor/clothing_under/durathread
	melee = 10
	laser = 10
	fire = 40
	acid = 10
	bomb = 5
	wound = 10

/obj/item/clothing/under/misc/bouncer
	name = "保安制服"
	desc = "一件由更耐磨的纤维制成的制服，会让你看起来很酷。"
	icon_state = "bouncer"
	inhand_icon_state = null
	can_adjust = FALSE
	armor_type = /datum/armor/clothing_under/bouncer

/datum/armor/clothing_under/bouncer
	melee = 5
	fire = 30
	acid = 30

/obj/item/clothing/under/misc/coordinator
	name = "协调人连身衣"
	desc = "派对爱好者设计，派对爱好者制造，为派对爱好者准备的连身衣。"
	icon = 'icons/obj/clothing/under/captain.dmi'
	worn_icon = 'icons/mob/clothing/under/captain.dmi'
	icon_state = "captain_parade"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/misc/syndicate_souvenir
	name = "辛迪加纪念T恤"
	desc = "我被辛迪加特工绑架了，结果只得到这件破T恤！"
	icon = 'icons/obj/clothing/under/syndicate_souvenir.dmi'
	worn_icon = 'icons/mob/clothing/under/syndicate_souvenir.dmi'
	icon_state = "syndicate_souvenir"
	inhand_icon_state = "syndicate_souvenir"
	random_sensor = FALSE
	sensor_mode = NO_SENSORS
	can_adjust = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
