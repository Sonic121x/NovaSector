// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/eyesnatcher
	name = "portable eyeball extractor"
	desc = "An overly complicated device that can pierce target's skull and extract their eyeballs if enough brute force is applied."
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
		span_warning(LANG("obj.ef464dbc9c6e9d4f", list(user, src, target))),
		span_userdanger(LANG("obj.f8df466589d95d8e", list(user, src))))
	if(!do_after(user, eye_snatch_enthusiasm, target = target, extra_checks = CALLBACK(src, PROC_REF(eyeballs_exist), eyeballies, head, target)))
		return

	to_chat(target, span_userdanger(LANG("obj.81379bf5916e9c88", null)))
	balloon_alert(user, LANG("obj.b06612da77bcbb69", null))
	if(!do_after(user, eye_snatch_enthusiasm, target = target, extra_checks = CALLBACK(src, PROC_REF(eyeballs_exist), eyeballies, head, target)))
		return

	var/min_wound = head.get_wound_threshold_of_wound_type(WOUND_BLUNT, WOUND_SEVERITY_SEVERE, return_value_if_no_wound = 30, wound_source = src)
	var/max_wound = head.get_wound_threshold_of_wound_type(WOUND_BLUNT, WOUND_SEVERITY_CRITICAL, return_value_if_no_wound = 50, wound_source = src)

	target.apply_damage(20, BRUTE, BODY_ZONE_HEAD, wound_bonus = rand(min_wound, max_wound + 10), attacking_item = src)
	target.visible_message(
		span_danger(LANG("obj.e51eb72fb9084806", list(src, target))),
		span_userdanger(LANG("obj.76efd3585da51af5", null)),
		span_hear(LANG("obj.eb55cb147c98a7fc", null))
	)
	eyeballies.apply_organ_damage(eyeballies.maxHealth)
	target.emote("scream")
	playsound(target, 'sound/effects/wounds/crackandbleed.ogg', 100)
	log_combat(user, target, "cracked the skull of (eye snatching)", src)

	if(!do_after(user, eye_snatch_enthusiasm, target = target, extra_checks = CALLBACK(src, PROC_REF(eyeballs_exist), eyeballies, head, target)))
		return

	if(!target.is_blind())
		to_chat(target, span_userdanger(LANG("obj.5f6796c6c272e50c", null)))
	if(prob(1))
		to_chat(target, span_notice(LANG("obj.f340b251aa11d560", null)))
		var/obj/item/clothing/glasses/eyepatch/new_patch = new(target.loc)
		target.equip_to_slot_if_possible(new_patch, ITEM_SLOT_EYES, disable_warning = TRUE)

	to_chat(user, span_notice(LANG("obj.8ecf70c48b8ea62d", list(target))))
	playsound(target, 'sound/items/handling/surgery/retractor2.ogg', 100, TRUE)
	playsound(target, 'sound/effects/pop.ogg', 100, TRAIT_MUTE)
	eyeballies.Remove(target)
	eyeballies.forceMove(get_turf(target))
	notify_ghosts(
		LANG("obj.3322fd0b4a5c058a", list(target.real_name)),
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
		. += span_notice(LANG("obj.bebe439333c0e66f", null))

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
