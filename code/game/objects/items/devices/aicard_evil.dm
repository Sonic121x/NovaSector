// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// One use AI card which downloads a ghost as a syndicate AI to put in your MODsuit
/obj/item/aicard/syndie
	name = "syndiCard"
	desc = "A storage device for AIs. Nanotrasen forgot to make the patent, so the Syndicate made their own version!"
	icon = 'icons/obj/aicards.dmi'
	icon_state = "syndicard"
	base_icon_state = "syndicard"
	item_flags = null
	force = 7

/obj/item/aicard/syndie/update_icon_state()
	icon_state = base_icon_state
	return ..()

/obj/item/aicard/syndie/update_overlays()
	..()
	. = list()

	if(!AI)
		return

	var/face_state = "[base_icon_state][AI.stat == DEAD ? "-404" : "-full"]"
	. += mutable_appearance(icon, face_state)
	. += emissive_appearance(icon, face_state, src, alpha = src.alpha)

	var/indicator_state = "[base_icon_state][AI.control_disabled ? "-off" : "-on"]"
	. += mutable_appearance(icon, indicator_state)
	. += emissive_appearance(icon, indicator_state, src, alpha = src.alpha)


/obj/item/aicard/syndie/loaded
	/// Set to true while we're waiting for ghosts to sign up
	var/finding_candidate = FALSE

/obj/item/aicard/syndie/loaded/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.6e1558f1a5274bf2", null))

/obj/item/aicard/syndie/loaded/attack_self(mob/user, modifiers)
	if(!isnull(AI))
		return ..()
	if(finding_candidate)
		balloon_alert(user, LANG("obj.22d731509ecf6915", null))
		return TRUE
	finding_candidate = TRUE
	to_chat(user, span_notice(LANG("obj.eb63c4e958e84112", null)))
	procure_ai(user)
	finding_candidate = FALSE
	return TRUE

/// Sets up the ghost poll
/obj/item/aicard/syndie/loaded/proc/procure_ai(mob/user)
	var/datum/antagonist/nukeop/op_datum = user.mind?.has_antag_datum(/datum/antagonist/nukeop,TRUE)
	if(isnull(op_datum))
		balloon_alert(user, LANG("obj.453cdb2b3af6af42", null))
		return
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target(
		check_jobban = list(ROLE_OPERATIVE, JOB_AI),
		poll_time = 20 SECONDS,
		checked_target = src,
		ignore_category = POLL_IGNORE_SYNDICATE,
		alert_pic = src,
		role_name_text = "Nuclear Operative Modsuit AI",
		chat_text_border_icon = mutable_appearance(icon, "syndicard-full"),
	)
	on_poll_concluded(user, op_datum, chosen_one)

/// Poll has concluded with a ghost, create the AI
/obj/item/aicard/syndie/loaded/proc/on_poll_concluded(mob/user, datum/antagonist/nukeop/op_datum, mob/dead/observer/ghost)
	if(!ismob(ghost))
		to_chat(user, span_warning(LANG("obj.515a382a7ac4c08f", null)))
		return

	// pick ghost, create AI and transfer
	var/mob/living/silicon/ai/weak_syndie/new_ai = new(null, ghost, /datum/ai_laws/syndicate_override)
	// create and apply syndie datum
	var/datum/antagonist/nukeop/nuke_datum = new()
	nuke_datum.send_to_spawnpoint = FALSE
	nuke_datum.give_bonus_tc = FALSE
	new_ai.mind.add_antag_datum(nuke_datum, op_datum.nuke_team)
	LAZYADD(new_ai.mind.special_roles, "Syndicate AI")
	new_ai.add_faction(ROLE_SYNDICATE)

	// Make it look evil!!!
	new_ai.hologram_appearance = mutable_appearance('icons/mob/silicon/ai.dmi',"xeno_queen") //good enough

	new_ai.set_core_display_icon("hades")

	// Hide PDA from messenger
	var/datum/computer_file/program/messenger/msg = locate() in new_ai.modularInterface.stored_files
	if(msg)
		msg.invisible = TRUE

	// Transfer the AI from the core we created into the card, then delete the core
	new_ai.transfer_ai(AI_TRANS_TO_CARD, user, null, src)
	update_appearance()

	var/obj/structure/ai_core/detritus = locate() in get_turf(src)
	qdel(detritus)

	if(AI)
		AI.set_control_disabled(FALSE)
		AI.radio_enabled = TRUE

	do_sparks(4, TRUE, src)
	playsound(src, 'sound/machines/chime.ogg', 25, TRUE)
	return

/obj/item/aicard/syndie/loaded/upload_ai(atom/to_what, mob/living/user)
	. = ..()
	if (!.)
		return
	visible_message(span_warning(LANG("obj.687cea10df0ca4c4", null)))
	do_sparks(3, cardinal_only = FALSE, source = src)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/// Upgrade disk used to increase the range of a syndicate AI
/obj/item/disk/computer/syndie_ai_upgrade
	name = "AI interaction range upgrade"
	desc = "A NT data chip containing information that a syndiCard AI can utilize to improve its wireless interfacing abilities. Simply slap it on top of an intelliCard, MODsuit, or AI core and watch it do its work! It's rumoured that there's something 'pretty awful' in it."
	max_capacity = 1000
	w_class = WEIGHT_CLASS_NORMAL
	sticker_icon_state = "o_syndicate"

/obj/item/disk/computer/syndie_ai_upgrade/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	var/mob/living/silicon/ai/AI
	if(isAI(target))
		AI = target
	else
		AI = locate() in target
	if(!AI || AI.interaction_range == INFINITY)
		playsound(src,'sound/machines/buzz/buzz-sigh.ogg',50,FALSE)
		to_chat(user, span_notice(LANG("obj.4ac1089dfb1c34b3", null)))
		return ..()
	AI.interaction_range += 2
	if(AI.interaction_range > 7)
		AI.interaction_range = INFINITY
	playsound(src,'sound/machines/beep/twobeep.ogg',50,FALSE)
	to_chat(user, span_notice(LANG("obj.a6cfb93eabd67689", list(src, AI))))
	to_chat(AI, span_notice(LANG("obj.96fab1e7d75fb517", list(src, AI.interaction_range))))
	qdel(src)
