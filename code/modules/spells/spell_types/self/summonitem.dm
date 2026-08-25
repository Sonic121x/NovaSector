// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/summonitem
	name = "Instant Summons"
	desc = "This spell can be used to recall a previously marked item to your hand from anywhere in the universe."
	button_icon_state = "summons"

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 10 SECONDS

	invocation = "Gar Yok!"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	spell_max_level = 1 //cannot be improved

	///The obj marked for recall
	var/obj/marked_item

/datum/action/cooldown/spell/summonitem/New(Target, original)
	. = ..()
	AddComponent(/datum/component/action_item_overlay, item_callback = CALLBACK(src, PROC_REF(get_marked)))

/datum/action/cooldown/spell/summonitem/Destroy()
	if(!isnull(marked_item))
		unmark_item()
	return ..()

/// For use in callbacks to get the marked item
/datum/action/cooldown/spell/summonitem/proc/get_marked()
	return marked_item

/datum/action/cooldown/spell/summonitem/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/// Set the passed object as our marked item
/datum/action/cooldown/spell/summonitem/proc/mark_item(obj/to_mark)
	marked_item = to_mark
	RegisterSignal(marked_item, COMSIG_QDELETING, PROC_REF(on_marked_item_deleted))

	name = "Recall [marked_item]"
	build_all_button_icons()

/// Unset our current marked item
/datum/action/cooldown/spell/summonitem/proc/unmark_item()
	UnregisterSignal(marked_item, COMSIG_QDELETING)
	marked_item = null

	if(!QDELING(src))
		name = initial(name)
		build_all_button_icons()

/// Signal proc for [COMSIG_QDELETING] on our marked item, unmarks our item if it's deleted
/datum/action/cooldown/spell/summonitem/proc/on_marked_item_deleted(datum/source)
	SIGNAL_HANDLER

	if(owner)
		to_chat(owner, span_boldwarning(LANG("datum.45c73b3d048de3ce", null)))
	unmark_item()

/datum/action/cooldown/spell/summonitem/cast(mob/living/cast_on)
	. = ..()
	if(QDELETED(marked_item))
		try_link_item(cast_on)
		return

	if(marked_item == cast_on.get_active_held_item())
		try_unlink_item(cast_on)
		return

	try_recall_item(cast_on)

/// Checks if the passed item is a valid item that can be marked / linked to summon.
/datum/action/cooldown/spell/summonitem/proc/can_link_to(obj/item/potential_mark, mob/living/caster)
	if(potential_mark.item_flags & ABSTRACT)
		return FALSE
	return TRUE

/// If we don't have a marked item, attempts to mark the caster's held item.
/datum/action/cooldown/spell/summonitem/proc/try_link_item(mob/living/caster)
	var/obj/item/potential_mark = caster.get_active_held_item()
	if(!potential_mark)
		if(caster.get_inactive_held_item())
			to_chat(caster, span_warning(LANG("datum.9a09fa56a92c938d", null)))
		else
			to_chat(caster, span_warning(LANG("datum.43b3622afa0294bb", null)))
		return FALSE

	var/link_message = ""
	if(!can_link_to(potential_mark, caster))
		return FALSE
	if(SEND_SIGNAL(potential_mark, COMSIG_ITEM_MARK_RETRIEVAL, src, caster) & COMPONENT_BLOCK_MARK_RETRIEVAL)
		return FALSE
	if(HAS_TRAIT(potential_mark, TRAIT_NODROP))
		link_message += "Though it feels redundant... "

	link_message += "You mark [potential_mark] for recall."
	to_chat(caster, span_notice(link_message))
	mark_item(potential_mark)
	return TRUE

/// If we have a marked item and it's in our hand, we will try to unlink it
/datum/action/cooldown/spell/summonitem/proc/try_unlink_item(mob/living/caster)
	to_chat(caster, span_notice(LANG("datum.167e7a53eb03cc77", list(marked_item))))
	if(!do_after(caster, 5 SECONDS, marked_item))
		to_chat(caster, span_notice(LANG("datum.a124577186a15055", list(marked_item))))
		return FALSE

	to_chat(caster, span_notice(LANG("datum.b5a59aed54fc0a45", list(marked_item))))
	unmark_item()
	return TRUE

/// Recalls our marked item to the caster. May bring some unexpected things along.
/datum/action/cooldown/spell/summonitem/proc/try_recall_item(mob/living/caster)
	var/obj/item_to_retrieve = marked_item

	if(item_to_retrieve.loc)
		// I don't want to know how someone could put something
		// inside itself but these are wizards so let's be safe
		var/infinite_recursion = 0

		// if it's in something, you get the whole thing.
		while(!isturf(item_to_retrieve.loc) && infinite_recursion < 10)
			if(isitem(item_to_retrieve.loc))
				var/obj/item/mark_loc = item_to_retrieve.loc
				// Being able to summon abstract things because
				// your item happened to get placed there is a no-no
				if(mark_loc.item_flags & ABSTRACT)
					break

			// If its on someone, properly drop it
			if(ismob(item_to_retrieve.loc))
				if(!issilicon(item_to_retrieve.loc))
					break

				// Items in silicons warp the whole silicon
				var/mob/holding_mark = item_to_retrieve.loc
				holding_mark.loc.visible_message(span_warning(LANG("datum.6566516035489fa8", list(holding_mark))))
				holding_mark.forceMove(caster.loc)
				holding_mark.loc.visible_message(span_warning(LANG("datum.4e88a79e68e40f6e", list(holding_mark))))
				SEND_SIGNAL(holding_mark, COMSIG_MAGIC_RECALL, caster, item_to_retrieve)
				playsound(holding_mark, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)
				return

			else if(isobj(item_to_retrieve.loc))
				var/obj/retrieved_item = item_to_retrieve.loc
				// Can't bring anchored things
				if(retrieved_item.anchored)
					break
				// Edge cases for moving certain machinery...
				if(istype(retrieved_item, /obj/machinery/portable_atmospherics))
					var/obj/machinery/portable_atmospherics/atmos_item = retrieved_item
					atmos_item.disconnect()
					atmos_item.update_appearance()

				// Otherwise bring the whole thing with us
				item_to_retrieve = retrieved_item

			infinite_recursion += 1

	if(!item_to_retrieve)
		return

	SEND_SIGNAL(item_to_retrieve, COMSIG_MAGIC_RECALL, caster, item_to_retrieve)

	if (ismob(item_to_retrieve.loc))
		var/mob/holder = item_to_retrieve.loc
		if (!holder.dropItemToGround(item_to_retrieve, force = TRUE))
			return

	item_to_retrieve.loc?.visible_message(span_warning(LANG("datum.6566516035489fa8", list(item_to_retrieve))))

	if(isitem(item_to_retrieve) && caster.put_in_hands(item_to_retrieve))
		item_to_retrieve.loc.visible_message(span_warning(LANG("datum.ff6f288a839fc2b4", list(item_to_retrieve, caster))))
	else
		item_to_retrieve.forceMove(caster.drop_location())
		item_to_retrieve.loc.visible_message(span_warning(LANG("datum.4e88a79e68e40f6e", list(item_to_retrieve))))

	playsound(get_turf(item_to_retrieve), 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)

/datum/action/cooldown/spell/summonitem/abductor
	name =  "Baton Recall"
	desc = "Activating this will trigger your baton's emergency translocation protocol, \
		recalling it to your hand. Takes a long time for the translocation crystals to reset after use."
	sound = 'sound/effects/phasein.ogg'

	school = SCHOOL_UNSET
	cooldown_time = 3.5 MINUTES

	spell_requirements = NONE
	invocation_type = INVOCATION_NONE

	antimagic_flags = MAGIC_RESISTANCE_MIND

/datum/action/cooldown/spell/summonitem/abductor/can_link_to(obj/item/potential_mark, mob/living/caster)
	. = ..()
	if(!.)
		return .

	if(!istype(potential_mark, /obj/item/melee/baton/abductor))
		to_chat(caster, span_warning(LANG("datum.6075ac11b3850c9a", list(potential_mark))))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/summonitem/abductor/try_unlink_item(mob/living/caster)
	to_chat(caster, span_warning(LANG("datum.5df4a889a91d855c", list(marked_item))))
	return FALSE
