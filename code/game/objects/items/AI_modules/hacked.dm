// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/ai_module/law/syndicate // This one doesn't inherit from ion boards because it doesn't call ..() in transmitInstructions. ~Miauw
	name = "Hacked AI Module"
	desc = "An AI Module for hacking additional laws to an AI. This board bypasses all access restrictions on the upload console."
	laws = list("")

/obj/item/ai_module/law/syndicate/configure(mob/user)
	. = TRUE
	var/targName = tgui_input_text(user, LANG("obj.a105864b", null), LANG("obj.f2d27273", null), laws[1], max_length = CONFIG_GET(number/max_law_len), multiline = TRUE)
	if(!targName || !user.is_holding(src))
		return
	if(is_ic_filtered(targName)) // not even the syndicate can uwu
		to_chat(user, span_warning(LANG("obj.b74e9614", null)))
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,LANG("obj.785540fc", list(soft_filter_result[CHAT_FILTER_INDEX_WORD], soft_filter_result[CHAT_FILTER_INDEX_REASON])), LANG("obj.b0fe106c", null), list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[targName]\"")
	laws[1] = targName

/obj/item/ai_module/law/syndicate/apply_to_combined_lawset(datum/ai_laws/combined_lawset)
	combined_lawset.add_hacked_law(laws[1])

/// Makes the AI Malf, as well as give it syndicate laws.
/obj/item/malf_board
	name = "Infected AI Module"
	desc = "A virus-infected AI Module."

	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "std_mod"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'

	obj_flags = CONDUCTS_ELECTRICITY
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT * 0.5)

	///Is this upload board unused?
	var/functional = TRUE

/obj/item/malf_board/examine(mob/user)
	. = ..()
	if(IS_TRAITOR(user) && isliving(user) && functional)
		. += span_alert(LANG("obj.93f46afa", null))
		. += span_alert(LANG("obj.50c272d3", null))

/obj/item/malf_board/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/blocking = ismachinery(interacting_with) || issilicon(interacting_with)
	if(!IS_TRAITOR(user))
		if(blocking)
			to_chat(user, span_warning(LANG("obj.0606e04b", null)))
			return ITEM_INTERACT_BLOCKING
		return NONE
	if(!functional)
		if(blocking)
			to_chat(user, span_warning(LANG("obj.85a2faec", null)))
			return ITEM_INTERACT_BLOCKING
		return NONE

	var/mob/living/silicon/ai/target_ai = interacting_with
	if(istype(interacting_with, /obj/machinery/ai_law_rack/base/core))
		var/obj/machinery/ai_law_rack/base/core/rack = interacting_with
		// find the first non-malf ai linked, but also allow a malf ai to be selected if it's the only one
		for(var/mob/living/silicon/ai/linked_ai in assoc_to_values(rack.linked_mobs))
			if(!target_ai?.mind?.has_antag_datum(/datum/antagonist/malf_ai))
				break
			target_ai = linked_ai
			continue

	if(!isAI(target_ai))
		to_chat(user, span_warning(LANG("obj.6e87e0df", null)))
		return ITEM_INTERACT_BLOCKING
	if(target_ai.mind?.has_antag_datum(/datum/antagonist/malf_ai))
		to_chat(user, span_warning(LANG("obj.abac3274", null)))
		return ITEM_INTERACT_BLOCKING

	var/datum/antagonist/malf_ai/infected/malf_datum = new (give_objectives = TRUE, new_boss = user.mind)
	target_ai.mind.add_antag_datum(malf_datum)
	target_ai.malf_picker.processing_time += 50
	to_chat(target_ai, span_notice(LANG("obj.678effae", null)))
	to_chat(user, span_notice(LANG("obj.405d503e", list(target_ai))))

	functional = FALSE
	update_appearance()
	return ITEM_INTERACT_BLOCKING

/obj/item/malf_board/update_name(updates)
	. = ..()
	if(!functional)
		name = "Broken AI Module"

/obj/item/malf_board/update_desc(updates)
	. = ..()
	if(!functional)
		desc = LANG("obj.de08e708", null)

/obj/item/malf_board/update_overlays()
	. = ..()
	if(!functional)
		. += "damaged"
