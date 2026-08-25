// Medical Combitool - combines bonesetter and bloodfilter functionality
// Ported from Bubberstation's modular_skyrat/modules/filtersandsetters

/obj/item/bonesetter/alien
	name = "alien bonesetter"
	desc = "While aliens generally don't have bones, their squishy subjects typically do."
	icon = 'modular_nova/modules/medical_combitool/icons/surgery_tools.dmi'
	icon_state = "bonesetter"
	toolspeed = 0.25
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/bonesetter/alien/get_all_tool_behaviours()
	return list(TOOL_BONESET, TOOL_ALIEN_BONESET)

/datum/wound/item_can_treat(obj/item/potential_treater, mob/user)
	. = ..()
	// check if we have a valid treatable tool
	for(var/behaviour in potential_treater.get_all_tool_behaviours())
		if(behaviour in treatable_tools)
			return TRUE

/datum/wound/blunt/bone/severe
	treatable_tools = list(TOOL_ALIEN_BONESET)

/datum/wound/blunt/bone/severe/treat(obj/item/I, mob/user)
	if(!(TOOL_ALIEN_BONESET in I.get_all_tool_behaviours()))
		return ..()

	var/scanned = HAS_TRAIT(src, TRAIT_WOUND_SCANNED)
	var/self_penalty_mult = user == victim ? 1.5 : 1
	var/scanned_mult = scanned ? 0.5 : 1
	var/treatment_delay = base_treat_time * self_penalty_mult * scanned_mult

	if(victim == user)
		victim.visible_message(span_danger(LANG("datum.dd2df9c6f5352943", list(user, scanned ? "expertly" : "", victim.p_their(), limb.plaintext_zone, I))), span_warning(LANG("datum.8ef9e56e0eb0df18", list(limb.plaintext_zone, I, scanned ? ", keeping the holo-image's indications in mind" : ""))))
	else
		user.visible_message(span_danger(LANG("datum.aa37b89adf2998d2", list(user, scanned ? "expertly" : "", victim, limb.plaintext_zone, I))), span_notice(LANG("datum.33481fc115b91bea", list(victim, limb.plaintext_zone, I, scanned ? ", keeping the holo-image's indications in mind" : ""))))

	if(!do_after(user, treatment_delay, target = victim, extra_checks=CALLBACK(src, PROC_REF(still_exists))))
		return

	if(victim == user)
		limb.receive_damage(brute=25, wound_bonus=CANT_WOUND)
		victim.visible_message(span_danger(LANG("datum.c6239b0218ace581", list(user, victim.p_their(), limb.plaintext_zone))), span_userdanger(LANG("datum.88d9614ce1d15a3a", list(limb.plaintext_zone))))
	else
		limb.receive_damage(brute=20, wound_bonus=CANT_WOUND)
		user.visible_message(span_danger(LANG("datum.8992cbd6c06457d0", list(user, victim, limb.plaintext_zone))), span_nicegreen(LANG("datum.43a90c076f91b44a", list(victim, limb.plaintext_zone))), ignored_mobs=victim)
		to_chat(victim, span_userdanger(LANG("datum.1374a6352b00629f", list(user, limb.plaintext_zone))))

	victim.emote("scream")
	playsound(user, 'sound/effects/wounds/crack1.ogg', 70, TRUE)
	qdel(src)

/datum/wound/blunt/bone/critical
	treatable_tools = list(TOOL_ALIEN_BONESET)

/datum/wound/blunt/bone/critical/treat(obj/item/I, mob/user)
	if(!(TOOL_ALIEN_BONESET in I.get_all_tool_behaviours()))
		return ..()

	var/scanned = HAS_TRAIT(src, TRAIT_WOUND_SCANNED)
	var/self_penalty_mult = user == victim ? 1.5 : 1
	var/scanned_mult = scanned ? 0.5 : 1
	var/treatment_delay = base_treat_time * self_penalty_mult * scanned_mult

	if(victim == user)
		victim.visible_message(span_danger(LANG("datum.dd2df9c6f5352943", list(user, scanned ? "expertly" : "", victim.p_their(), limb.plaintext_zone, I))), span_warning(LANG("datum.8ef9e56e0eb0df18", list(limb.plaintext_zone, I, scanned ? ", keeping the holo-image's indications in mind" : ""))))
	else
		user.visible_message(span_danger(LANG("datum.aa37b89adf2998d2", list(user, scanned ? "expertly" : "", victim, limb.plaintext_zone, I))), span_notice(LANG("datum.33481fc115b91bea", list(victim, limb.plaintext_zone, I, scanned ? ", keeping the holo-image's indications in mind" : ""))))

	if(!do_after(user, treatment_delay, target = victim, extra_checks=CALLBACK(src, PROC_REF(still_exists))))
		return

	if(victim == user)
		limb.receive_damage(brute=45, wound_bonus=CANT_WOUND)
		victim.visible_message(span_danger(LANG("datum.c6239b0218ace581", list(user, victim.p_their(), limb.plaintext_zone))), span_userdanger(LANG("datum.88d9614ce1d15a3a", list(limb.plaintext_zone))))
	else
		limb.receive_damage(brute=40, wound_bonus=CANT_WOUND)
		user.visible_message(span_danger(LANG("datum.8992cbd6c06457d0", list(user, victim, limb.plaintext_zone))), span_nicegreen(LANG("datum.43a90c076f91b44a", list(victim, limb.plaintext_zone))), ignored_mobs=victim)
		to_chat(victim, span_userdanger(LANG("datum.1374a6352b00629f", list(user, limb.plaintext_zone))))

	victim.emote("scream")
	playsound(user, 'sound/effects/wounds/crack2.ogg', 70, TRUE)
	qdel(src)

/datum/design/alienbonesetter
	name = "Alien Bonesetter"
	desc = "An advanced bonesetter obtained throubh Abductor technology. \
		Theoretically useful for directly treating fractures without surgical intervention. Theoretically."
	build_path = /obj/item/bonesetter/alien
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT,
					/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
					/datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5,
					/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
				)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/blood_filter/alien
	name = "alien blood filter"
	desc = "Do aliens have blood to filter? Probably not. Do aliens have subjects whose blood they filter? It's a distinct possibility."
	icon = 'modular_nova/modules/medical_combitool/icons/surgery_tools.dmi'
	icon_state = "bloodfilter"
	toolspeed = 0.25
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT)

/datum/design/alienbloodfilter
	name = "Alien Blood Filter"
	desc = "An advanced blood filter obtained through Abductor technology."
	build_path = /obj/item/blood_filter/alien
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT,
					/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
					/datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5,
					/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
				)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/blood_filter/advanced
	name = "medical combitool"
	desc = "An unholy combination of bonesetter and bloodfilter."
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6,
							/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
							/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
							/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.5,
						)
	icon = 'modular_nova/modules/medical_combitool/icons/surgery_tools.dmi'
	icon_state = "combitool"
	inhand_icon_state = "adv_retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7

/obj/item/blood_filter/advanced/attack_self_secondary(mob/user)
	ui_interact(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/blood_filter/advanced/BorgCtrlClick(mob/user)
	ui_interact(user)

/obj/item/blood_filter/advanced/get_all_tool_behaviours()
	return list(TOOL_BLOODFILTER, TOOL_BONESET)

/obj/item/blood_filter/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between bonesetter and bloodfilter and gives feedback to the user.
 */
/obj/item/blood_filter/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_BONESET : TOOL_BLOODFILTER)
	balloon_alert(user, LANG("obj.cc5a7618cda4748d", list(active ? "set bones" : "filter blood")))
	playsound(user ? user : src, 'sound/items/tools/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/blood_filter/advanced/examine()
	. = ..()
	. += span_notice(LANG("obj.be45e7c0ab20f4c8", list(tool_behaviour == TOOL_BLOODFILTER ? "blood filter" : "bonesetter")))

/datum/design/combitool
	name = "Medical Combitool"
	desc = "This tool can be either used as a blood filter or bonesetter."
	build_path = /obj/item/blood_filter/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6,
					/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
					/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
					/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.5,
				)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/techweb_node/surgery_tools/New()
	unlocked_designs += list(
		/datum/design/combitool,
	)
	return ..()

/datum/techweb_node/alien/surgery/New()
	unlocked_designs += list(
		/datum/design/alienbloodfilter,
		/datum/design/alienbonesetter,
	)
	return ..()
