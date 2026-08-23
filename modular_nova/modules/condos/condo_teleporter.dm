/// Essentially a rewritten version of Hilbert's Hotel that supports multiple map templates; and a reference to GMTower's beautiful condo system. You should play it's successor... :3
/obj/machinery/cafe_condo_teleporter
	name = "Matrixed Teleportation Unit"
	desc = "A sub-divided; stable teleportation system with a unseen central processing hub."
	icon = /obj/machinery/teleport/hub::icon
	icon_state = /obj/machinery/teleport/hub::icon_state
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/cafe_condo_teleporter/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.764835b0b62d37ca", null))
	. += span_warning(LANG("obj.0922d32858105be5", null))

/obj/machinery/cafe_condo_teleporter/attack_robot(mob/user)
	if(user.Adjacent(src))
		prompt_and_check_in(user, user)
	return TRUE

/obj/machinery/cafe_condo_teleporter/attack_hand(mob/living/user, list/modifiers)
	prompt_and_check_in(user, user)
	return TRUE

/obj/machinery/cafe_condo_teleporter/attack_tk(mob/user)
	to_chat(user, span_notice(LANG("obj.25a4abc8996cfaaf", list(src))))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// They're adjacent - ask them for their desired room number and, if it's new; what archetype they want.
/obj/machinery/cafe_condo_teleporter/proc/prompt_and_check_in(mob/user, mob/target)
	var/requested_condo = tgui_input_number(target, LANG("obj.9c9c5b330decdca7", null), LANG("obj.ea08ae31fa0c34b6", null), 1, min_value = 1)
	if(!requested_condo)
		return
	if(requested_condo > SHORT_REAL_LIMIT)
		to_chat(target, span_warning(LANG("obj.ea04451db548a24f", list(SHORT_REAL_LIMIT))))
		return
	if((requested_condo < 1) || (requested_condo != round(requested_condo)))
		to_chat(target, span_warning(LANG("obj.3252b69c1716f62d", null)))
		return
	if(!check_target_eligibility(target))
		return

	if(SScondos.active_condos["[requested_condo]"])
		SScondos.enter_active_room(requested_condo, target)

	else
		var/datum/map_template/chosen_condo
		var/map = tgui_input_list(user, LANG("obj.9d6ad98c4c96bcaf", null),LANG("obj.852d3c652232a1a7", null), sort_list(SScondos.condo_templates))
		if(!map || !check_target_eligibility(target))
			return
		// Possible the room became active after we opened this UI - just enter it with a warning.
		if(SScondos.active_condos["[requested_condo]"])
			to_chat(target, span_warning(LANG("obj.9472549d36b31f42", null)))
			SScondos.enter_active_room(requested_condo, target)
			return
		chosen_condo = SScondos.condo_templates[map]
		SScondos.create_and_enter_condo(requested_condo, chosen_condo, user, src)

/// Sanitycheck to prevent exploitation
/obj/machinery/cafe_condo_teleporter/proc/check_target_eligibility(mob/to_be_checked)
	if(!src.Adjacent(to_be_checked))
		to_chat(to_be_checked, span_warning(LANG("obj.d1040cf6054a1f25", list(src))))
		return FALSE
	if(to_be_checked.incapacitated)
		to_chat(to_be_checked, span_warning(LANG("obj.670b79fe9a3f7a34", list(src))))
		return FALSE
	return TRUE
