/obj/item/eyesnatcher
	name = "便携式眼球提取器"
	desc = "一个过于复杂的装置，如果施加足够的蛮力，可以刺穿目标的头骨并提取其眼球。"
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "eyesnatcher"
	base_icon_state = "eyesnatcher"
	inhand_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	///Whether it's been used to steal a pair of eyes already.
	var/used = FALSE

/obj/item/eyesnatcher/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][used ? "-used" : ""]"

/obj/item/eyesnatcher/attack(mob/living/carbon/human/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(used || !istype(target) || !target.Adjacent(user)) //Works only once, no TK use
		return ..()

	var/obj/item/organ/eyes/eyeballies = target.get_organ_slot(ORGAN_SLOT_EYES)
	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)

	if(!head || !eyeballies || target.is_eyes_covered())
		return ..()
	var/eye_snatch_enthusiasm = 5 SECONDS
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID))
		eye_snatch_enthusiasm *= 0.7
	user.do_attack_animation(target, used_item = src)
	target.visible_message(
		span_warning("[user]将[src]按在[target]的头骨上！"),
		span_userdanger("[user]将[src]按在你的头骨上！"))
	if(!do_after(user, eye_snatch_enthusiasm, target = target, extra_checks = CALLBACK(src, PROC_REF(eyeballs_exist), eyeballies, head, target)))
		return

	to_chat(target, span_userdanger("你感觉到有什么东西正强行钻入你的头骨！"))
	balloon_alert(user, "施加压力中...")
	if(!do_after(user, eye_snatch_enthusiasm, target = target, extra_checks = CALLBACK(src, PROC_REF(eyeballs_exist), eyeballies, head, target)))
		return

	var/min_wound = head.get_wound_threshold_of_wound_type(WOUND_BLUNT, WOUND_SEVERITY_SEVERE, return_value_if_no_wound = 30, wound_source = src)
	var/max_wound = head.get_wound_threshold_of_wound_type(WOUND_BLUNT, WOUND_SEVERITY_CRITICAL, return_value_if_no_wound = 50, wound_source = src)

	target.apply_damage(20, BRUTE, BODY_ZONE_HEAD, wound_bonus = rand(min_wound, max_wound + 10), attacking_item = src)
	target.visible_message(
		span_danger("[src]刺穿了[target]的头骨，严重损毁了他们的眼睛！"),
		span_userdanger("有什么东西刺穿了你的头骨，严重损毁了你的眼睛！我操！"),
		span_hear("你听到金属刺穿血肉的恶心声响！")
	)
	eyeballies.apply_organ_damage(eyeballies.maxHealth)
	target.emote("scream")
	playsound(target, 'sound/effects/wounds/crackandbleed.ogg', 100)
	log_combat(user, target, "cracked the skull of (eye snatching)", src)

	if(!do_after(user, eye_snatch_enthusiasm, target = target, extra_checks = CALLBACK(src, PROC_REF(eyeballs_exist), eyeballies, head, target)))
		return

	if(!target.is_blind())
		to_chat(target, span_userdanger("你突然失明了！"))
	if(prob(1))
		to_chat(target, span_notice("至少你因此获得了一副新的海盗造型..."))
		var/obj/item/clothing/glasses/eyepatch/new_patch = new(target.loc)
		target.equip_to_slot_if_possible(new_patch, ITEM_SLOT_EYES, disable_warning = TRUE)

	to_chat(user, span_notice("你成功取出了[target]的眼球。"))
	playsound(target, 'sound/items/handling/surgery/retractor2.ogg', 100, TRUE)
	playsound(target, 'sound/effects/pop.ogg', 100, TRAIT_MUTE)
	eyeballies.Remove(target)
	eyeballies.forceMove(get_turf(target))
	notify_ghosts(
		"[target.real_name] has just had their eyes snatched!",
		source = target,
		header = "Ouch!",
	)
	target.emote("scream")
	if(prob(20))
		target.emote("cry")
	used = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/eyesnatcher/examine(mob/user)
	. = ..()
	if(used)
		. += span_notice("它已被用尽。")

/obj/item/eyesnatcher/proc/eyeballs_exist(obj/item/organ/eyes/eyeballies, obj/item/bodypart/head/head, mob/living/carbon/human/target)
	if(!eyeballies || QDELETED(eyeballies))
		return FALSE
	if(!head || QDELETED(head))
		return FALSE

	if(eyeballies.owner != target)
		return FALSE
	var/obj/item/organ/eyes/eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	//got different eyes or doesn't own the head... somehow
	if(head.owner != target || eyes != eyeballies)
		return FALSE

	return TRUE
