/obj/item/melee/chainofcommand
	name = "指挥链"
	desc = "伟人用来安抚暴动群众的工具。可通过右键点击来加速盟友。"
	icon = 'icons/obj/weapons/whip.dmi'
	icon_state = "chain"
	inhand_icon_state = "chain"
	worn_icon_state = "whip"
	icon_angle = -90
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 10
	throwforce = 7
	demolition_mod = 0.25
	wound_bonus = 15
	exposed_wound_bonus = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("flogs", "whips", "lashes", "disciplines")
	attack_verb_simple = list("flog", "whip", "lash", "discipline")
	hitsound = 'sound/items/weapons/chainhit.ogg'
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/melee/chainofcommand/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/melee/chainofcommand/add_item_context(obj/item/source, list/context, atom/target, mob/living/user)
	. = NONE
	if(isliving(target))
		context[SCREENTIP_CONTEXT_RMB] = "Hasten"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/melee/chainofcommand/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正用[src]勒住[user.p_them()]自己！看起来[user.p_theyre()]试图自杀！"))
	return OXYLOSS

/obj/item/melee/chainofcommand/attack_secondary(mob/living/victim, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()

	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(victim == user)
		to_chat(user, span_warning("你考虑鞭打自己，但一想到会有多疼就犹豫了。"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.do_attack_animation(victim)
	playsound(victim, 'sound/items/weapons/whip.ogg', 50, TRUE, -1)
	victim.apply_status_effect(/datum/status_effect/speed_boost/commanded)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/datum/status_effect/speed_boost/commanded
	id = "commanded"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/commanded
	move_datum = /datum/movespeed_modifier/status_speed_boost/commanded
	duration = 7 SECONDS

/datum/movespeed_modifier/status_speed_boost/commanded
	multiplicative_slowdown = -0.20

/datum/actionspeed_modifier/commanded
	multiplicative_slowdown = -0.65

/atom/movable/screen/alert/status_effect/commanded
	name = "受命"
	desc = "你被激励着更快地做事！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "commanded"

/obj/item/melee/chainofcommand/tailwhip
	name = "蜥蜴九尾鞭"
	desc = "用蜥蜴断尾制成的鞭子。"
	icon_state = "tailwhip"
	inhand_icon_state = "tailwhip"
	item_flags = NONE
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.1)

/obj/item/melee/chainofcommand/tailwhip/kitty
	name = "猫九尾鞭"
	desc = "用猫断尾制成的鞭子。"
	icon_state = "catwhip"
	inhand_icon_state = "catwhip"
