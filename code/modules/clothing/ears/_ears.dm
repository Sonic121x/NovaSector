
//Ears: currently only used for headsets and earmuffs
/obj/item/clothing/ears
	name = "耳朵"
	lefthand_file = 'icons/mob/inhands/clothing/ears_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/ears_righthand.dmi'
	abstract_type = /obj/item/clothing/ears
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_EARS
	resistance_flags = NONE

/obj/item/clothing/ears/earmuffs
	name = "耳罩"
	desc = "既能够隔绝噪音，也能够隔绝微小的声响。"
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "earmuffs"
	inhand_icon_state = "earmuffs"
	clothing_traits = list(TRAIT_DEAF)
	strip_delay = 1.5 SECONDS
	equip_delay_other = 2.5 SECONDS
	resistance_flags = FLAMMABLE
	custom_price = PAYCHECK_COMMAND * 1.5
	flags_cover = EARS_COVERED

/obj/item/clothing/ears/earmuffs/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/earhealing)
	AddComponent(/datum/component/wearertargeting/earprotection)
	AddElement(/datum/element/adjust_fishing_difficulty, -2)

/obj/item/clothing/ears/earmuffs/debug
	name = "调试耳罩"
	desc = "佩戴此物会为播放的每个声音发送聊天消息。强烈建议行走以忽略脚步声。"
	clothing_traits = list(TRAIT_SOUND_DEBUGGED)
