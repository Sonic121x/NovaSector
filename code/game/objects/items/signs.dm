/obj/item/picket_sign
	icon = 'icons/obj/signs.dmi'
	icon_state = "picket"
	inhand_icon_state = "picket"
	name = "空白抗议标语牌"
	desc = "它是空白的。"
	force = 5
	obj_flags = UNIQUE_RENAME | RENAME_NO_DESC
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("bashes", "smacks")
	attack_verb_simple = list("bash", "smack")
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT * 2, /datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	var/label = ""
	COOLDOWN_DECLARE(picket_sign_cooldown)

/obj/item/picket_sign/cyborg
	name = "金属纳米标语牌"
	desc = "一种硅基生命使用的高科技抗议标语牌，可以随意重新编程其表面。被打到可能也很疼。"
	force = 13
	resistance_flags = NONE
	actions_types = list(/datum/action/item_action/nano_picket_sign)

/obj/item/picket_sign/nameformat(input, user)
	playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	label = input
	AddComponent(/datum/component/rename, name, "It reads: [input]")
	return "[input] sign"

/obj/item/picket_sign/rename_reset()
	label = initial(label)

/obj/item/picket_sign/attack_self(mob/living/carbon/human/user)
	if(!COOLDOWN_FINISHED(src, picket_sign_cooldown))
		return
	COOLDOWN_START(src, picket_sign_cooldown, 5 SECONDS)
	if(label)
		user.manual_emote("waves around \the \"[label]\" sign.")
	else
		user.manual_emote("waves around a blank sign.")
	var/direction = prob(50) ? -1 : 1
	if(NSCOMPONENT(user.dir)) //So signs are waved horizontally relative to what way the player waving it is facing.
		animate(user, pixel_w = (1 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
		animate(pixel_w = (-2 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
		animate(pixel_w = (2 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
		animate(pixel_w = (-2 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
		animate(pixel_w = (1 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
	else
		animate(user, pixel_z = (1 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
		animate(pixel_z = (-2 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
		animate(pixel_z = (2 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
		animate(pixel_z = (-2 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
		animate(pixel_z = (1 * direction), time = 0.1 SECONDS, easing = SINE_EASING, flags = ANIMATION_RELATIVE)
	user.changeNext_move(CLICK_CD_MELEE)

/datum/action/item_action/nano_picket_sign
	name = "重设纳米抗议标语牌文本"

/datum/action/item_action/nano_picket_sign/do_effect(trigger_flags)
	if(!istype(target, /obj/item/picket_sign))
		return FALSE
	var/obj/item/picket_sign/sign = target
	var/input = tgui_input_text(owner, "你想在牌子上写什么？", "标牌标签", max_length = 30)
	if(input && owner.can_perform_action(sign))
		sign.label = input
		sign.AddComponent(/datum/component/rename, "[input] sign", "It reads: [input]")
	return TRUE

/datum/crafting_recipe/picket_sign
	name = "抗议标语牌"
	result = /obj/item/picket_sign
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/cardboard = 2)
	time = 8 SECONDS
	category = CAT_ENTERTAINMENT
