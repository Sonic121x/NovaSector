/obj/item/clothing/mask/breath
	desc = "一种可以与气罐相连的高贴合面罩。"
	name = "呼吸面罩"
	icon_state = "breath"
	inhand_icon_state = "m_mask"
	body_parts_covered = 0
	clothing_flags = MASKINTERNALS
	visor_flags = MASKINTERNALS
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/mask_breath
	actions_types = list(/datum/action/item_action/adjust)
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING
	/// Can this mask be adjusted?
	var/adjustable = TRUE

/datum/armor/mask_breath
	bio = 50

/obj/item/clothing/mask/breath/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]正把\the [src]的管子绕在[user.p_their()]脖子上！看起来[user.p_theyre()]想自杀！"))
	return OXYLOSS

/obj/item/clothing/mask/breath/attack_self(mob/user)
	if(adjustable)
		adjust_visor(user)

/obj/item/clothing/mask/breath/click_alt(mob/user)
	if(!adjustable)
		return
	adjust_visor(user)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/mask/breath/examine(mob/user)
	. = ..()
	if(adjustable)
		. += span_notice("Alt-点击[src]来调整它。")

/obj/item/clothing/mask/breath/medical
	desc = "一种紧密贴合的无菌口罩，可以连接到空气供应设备上。"
	name = "医用面具"
	icon_state = "medical"
	inhand_icon_state = "m_mask"
	armor_type = /datum/armor/breath_medical
	equip_delay_other = 1 SECONDS

/datum/armor/breath_medical
	bio = 90

/obj/item/clothing/mask/breath/muzzle
	name = "手术口罩"
	desc = "在让那些烦人的病人昏过去之前，先让他们闭嘴。"
	icon_state = "breathmuzzle"
	inhand_icon_state = "breathmuzzle"
	lefthand_file = 'icons/mob/inhands/clothing/masks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/masks_righthand.dmi'
	body_parts_covered = NONE
	flags_cover = NONE
	actions_types = null
	armor_type = /datum/armor/breath_muzzle
	equip_delay_other = 2.5 SECONDS // my sprite has 4 straps, a-la a head harness. takes a while to equip, longer than a muzzle
	adjustable = FALSE

/obj/item/clothing/mask/breath/muzzle/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/muffles_speech)

/obj/item/clothing/mask/breath/muzzle/attack_paw(mob/user, list/modifiers)
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(src == carbon_user.wear_mask)
			to_chat(user, span_warning("你需要帮忙才能取下这个！"))
			return
	return ..()

/obj/item/clothing/mask/breath/muzzle/examine_tags(mob/user)
	. = ..()
	.["surgical"] = "Does not block surgery on covered bodyparts."

/datum/armor/breath_muzzle
	bio = 100
