// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/bounty/item
	///How many items have to be shipped to complete the bounty
	var/required_count = 1
	///How many items have been shipped for the bounty so far
	var/shipped_count = 0
	///Types accepted|denied by the bounty. (including all subtypes, unless include_subtypes is set to FALSE)
	var/list/wanted_types
	///Set to FALSE to make the bounty not accept subtypes of the wanted_types
	var/include_subtypes = TRUE

/datum/bounty/item/New()
	..()
	wanted_types = string_assoc_list(zebra_typecacheof(wanted_types, only_root_path = !include_subtypes))

/datum/bounty/item/print_required()
	return "[shipped_count]/[required_count]"

/datum/bounty/item/can_claim()
	return shipped_count >= required_count

/datum/bounty/item/applies_to(obj/shipped)
	if(!is_type_in_typecache(shipped, wanted_types))
		return FALSE
	if(shipped.flags_1 & HOLOGRAM_1)
		return FALSE
	return shipped_count < required_count

/datum/bounty/item/ship(obj/shipped)
	if(!applies_to(shipped))
		return FALSE
	if(istype(shipped,/obj/item/stack))
		var/obj/item/stack/shipped_is_a_stack = shipped
		shipped_count += shipped_is_a_stack.amount
	else
		shipped_count += 1
	return TRUE

/datum/bounty/item/get_total()
	return shipped_count

/datum/bounty/item/get_max()
	return required_count


/**
 * Debug item because it took less time to code this than it did to roll ONE toolbox bounty.
 */
/obj/item/bounty_voucher
	name = "bounty voucher"
	desc = "A certificate for ONE FREE BOUNTY of your choice! Wow!"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "paperslip_words"

/obj/item/bounty_voucher/attack_self(mob/user, modifiers)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	var/obj/item/card/id/id = living_user.get_idcard()
	if(!id?.registered_account)
		return
	var/choice = tgui_input_list(living_user, LANG("obj.65586d144c5c1081", null), LANG("obj.24bf5f879c52bac9", null), subtypesof(/datum/bounty))
	var/datum/bounty/new_chore = text2path("[choice]")
	id.registered_account.set_bounty(new new_chore, id)
	balloon_alert(user, LANG("obj.bd697b4b92b1d690", null))
	playsound(src, 'sound/effects/coin2.ogg', 30, TRUE)
	qdel(src)

/// As above, but it spawns a global bounty for testing.
/obj/item/bounty_voucher/stationwide
	name = "stationwide bounty voucher"
	desc = "A certificate for ONE FREE BOUNTY of your choice! For everyone! Wowzers!"
	color = "#ff8800"

/obj/item/bounty_voucher/stationwide/attack_self(mob/user, modifiers)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	var/choice = tgui_input_list(living_user, LANG("obj.65586d144c5c1081", null), LANG("obj.24bf5f879c52bac9", null), subtypesof(/datum/bounty))
	var/datum/bounty/new_chore = text2path("[choice]")
	if(new_chore.global_exempt)
		to_chat(user, span_warning(LANG("obj.3615f26292bb8618", null)))
		return
	GLOB.shared_crew_bounties += new_chore
	balloon_alert(user, LANG("obj.5ea5fde6d54ee5ba", null))
	playsound(src, 'sound/effects/coin2.ogg', 30, TRUE)
	qdel(src)
