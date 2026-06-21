/obj/item/straight_razor
	name = "直剃刀"
	desc = "一把非常锋利的刀片，主要用于刮脸..."
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "straight_razor"
	force = 12
	throw_speed = 3
	throw_range = 9
	w_class = WEIGHT_CLASS_TINY
	attack_verb_simple = list("cut", "stabbed", "chebbed")
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	wound_bonus = 10
	exposed_wound_bonus = 15
	tool_behaviour = TOOL_KNIFE
	// How long do we take to shave someone's facial hair?
	var/shaving_time = 10 SECONDS

/obj/item/straight_razor/proc/shave(mob/living/carbon/human/target_human)
	target_human.facial_hairstyle = "Shaved"
	target_human.update_body_parts()
	playsound(loc, 'sound/items/unsheath.ogg', 20, TRUE)

/obj/item/straight_razor/attack(mob/attacked_mob, mob/living/user)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/target_human = attacked_mob
		var/location = user.zone_selected
		if(!(location in list(BODY_ZONE_PRECISE_MOUTH)) && !user.combat_mode)
			to_chat(user, span_warning("你停下来，低头看了看手里拿的东西，心里琢磨着，“这大概是用来刮他们胡子的。”"))
			return
		if(location == BODY_ZONE_PRECISE_MOUTH && !target_human.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("[target_human] 没有头！"))
			return
		if(location == BODY_ZONE_PRECISE_MOUTH)
			var/obj/item/bodypart/head/noggin = target_human.get_bodypart(BODY_ZONE_HEAD)
			if(!(noggin.head_flags & HEAD_FACIAL_HAIR))
				to_chat(user, span_warning("没有胡子可刮！"))
				return
			var/covering = target_human.is_mouth_covered()
			if(covering)
				to_chat(user, span_warning("[covering] 挡着呢！"))
				return
			if(target_human.facial_hairstyle == "Shaved")
				to_chat(user, span_warning("已经刮干净了！"))
				return

			var/self_shaving = target_human == user // Shaving yourself?
			user.visible_message(span_notice("[user]开始用[self_shaving ? user.p_their() : "[target_human]'s"]刮[src]面部毛发。"), \
				span_notice("你花了一点时间用[self_shaving ? "your" : "[target_human]'s" ]刮[src]面部毛发……"))
			if(do_after(user, shaving_time, target = target_human))
				user.visible_message(span_notice("[user] 用 [self_shaving ? user.p_their() : "[target_human]'s"] 将 [src] 的面部毛发刮得干干净净。"), \
					span_notice("你用 [self_shaving ? "" : " [target_human]'s facial hair"] 刮完了[src]。又快又干净！"))
				shave(target_human)

		else
			..()
	else
		..()
