/*
Slimecrossing Armor
	Armor added by the slimecrossing system.
	Collected here for clarity.
*/

//Rebreather mask - Chilling Blue
/obj/item/clothing/mask/nobreath
	name = "自呼吸面罩"
	desc = "一种透明面罩，类似于传统的呼吸面罩，由蓝色粘液制成，但似乎没有空气供应管。"
	icon_state = "slime"
	inhand_icon_state = "b_mask"
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_SMALL
	clothing_traits = list(TRAIT_NOBREATH)
	armor_type = /datum/armor/mask_nobreath
	flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE
	interaction_flags_mouse_drop = NEED_HANDS

/datum/armor/mask_nobreath
	bio = 50

/obj/item/clothing/mask/nobreath/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_MASK)
		user.failed_last_breath = FALSE
		user.clear_alert(ALERT_NOT_ENOUGH_OXYGEN)
		user.apply_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/mask/nobreath/dropped(mob/living/carbon/human/user)
	..()
	user.remove_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/glasses/prism_glasses
	name = "棱镜眼镜"
	desc = "这些镜片似乎微微发亮，并将光线反射成绚丽多彩的色彩。"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "prismglasses"
	actions_types = list(/datum/action/item_action/change_prism_colour, /datum/action/item_action/place_light_prism)

	forced_glass_color = TRUE
	var/glasses_color = COLOR_WHITE

/obj/item/clothing/glasses/prism_glasses/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/wearable_client_colour, /datum/client_colour/glass_colour, ITEM_SLOT_EYES, GLASSES_TRAIT, glasses_color, forced_glass_color)

/obj/structure/light_prism
	name = "光棱镜"
	desc = "一颗闪耀着半固态光芒的晶莹宝石。看起来很脆弱。"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "lightprism"
	density = FALSE
	anchored = TRUE
	max_integrity = 10

/obj/structure/light_prism/Initialize(mapload, newcolor)
	. = ..()
	if(newcolor)
		color = newcolor
		set_light_color(newcolor)
	set_light(5)

/obj/structure/light_prism/attack_hand(mob/user, list/modifiers)
	to_chat(user, span_notice("你驱散了[src]。"))
	qdel(src)

/datum/action/item_action/change_prism_colour
	name = "调整棱镜镜头"
	button_icon = 'icons/obj/science/slimecrossing.dmi'
	button_icon_state = "prismcolor"

/datum/action/item_action/change_prism_colour/do_effect(trigger_flags)
	var/obj/item/clothing/glasses/prism_glasses/glasses = target
	var/new_color = tgui_color_picker(owner, "Choose the lens color:", "Color change",glasses.glasses_color)
	if(!new_color)
		return
	RemoveElement(/datum/element/wearable_client_colour, /datum/client_colour/glass_colour, ITEM_SLOT_EYES, GLASSES_TRAIT, glasses.glasses_color, glasses.forced_glass_color)
	glasses.glasses_color = new_color
	AddElement(/datum/element/wearable_client_colour, /datum/client_colour/glass_colour, ITEM_SLOT_EYES, GLASSES_TRAIT, new_color, glasses.forced_glass_color)

/datum/action/item_action/place_light_prism
	name = "制造光棱镜"
	button_icon = 'icons/obj/science/slimecrossing.dmi'
	button_icon_state = "lightprism"

/datum/action/item_action/place_light_prism/do_effect(trigger_flags)
	var/obj/item/clothing/glasses/prism_glasses/glasses = target
	if(locate(/obj/structure/light_prism) in get_turf(owner))
		to_chat(owner, span_warning("这里的环境能量不足以制造另一个光棱。"))
		return
	if(istype(glasses))
		if(!glasses.glasses_color)
			to_chat(owner, span_warning("镜片异常地不透明..."))
			return
		to_chat(owner, span_notice("你将附近的光线汇聚成一个发光的、空灵的棱镜。"))
		new /obj/structure/light_prism(get_turf(owner), glasses.glasses_color)

/obj/item/clothing/head/peaceflower
	name = "女英雄花苞"
	desc = "一种极具诱惑力的花朵，散发着宁静的魔力。"
	icon = 'icons/obj/science/slimecrossing.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "peaceflower"
	inhand_icon_state = null
	slot_flags = ITEM_SLOT_HEAD
	clothing_traits = list(TRAIT_PACIFISM)
	body_parts_covered = NONE
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/clothing/head/peaceflower/can_mob_unequip(mob/user)
	if(user.get_item_by_slot(slot_flags) == src)
		to_chat(user, span_warning("你感到平静。<b style='color:pink'>为什么你还想要别的呢？</b>"))
		return FALSE
	return ..()

/obj/item/clothing/suit/armor/heavy/adamantine
	name = "精金盔甲"
	desc = "一套完整的精金甲胄。其抗损能力令人惊叹，但重量却与你的体重相当。"
	icon_state = "adamsuit"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	inhand_icon_state = null
	flags_inv = NONE
	item_flags = IMMUTABLE_SLOW
	slowdown = 4
	var/hit_reflect_chance = 40

/obj/item/clothing/suit/armor/heavy/adamantine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/suit/armor/heavy/adamantine/IsReflect(def_zone)
	if((def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)) && prob(hit_reflect_chance))
		return TRUE
	else
		return FALSE
