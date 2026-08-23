// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
///This element allows the item it's attached to be bound to oneself's arm with a pair of handcuffs (sold separately). Borgs need not to apply
/datum/element/cuffable_item

/datum/element/cuffable_item/Attach(datum/target)
	. = ..()

	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))
	RegisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION_SECONDARY, PROC_REF(item_interaction))

	var/atom/atom_target = target
	atom_target.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
	RegisterSignal(atom_target, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(on_requesting_context_from_item))

///Tell the player about the interaction if they examine the item twice.
/datum/element/cuffable_item/proc/on_examine_more(obj/item/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(length(user.held_items) < 0 || iscyborg(user) || source.anchored)
		return
	examine_list += span_smallnotice(LANG("datum.aa33c12466cc1e41", list(source.p_them())))

///Give context to players holding a pair of handcuffs when hovering the item
/datum/element/cuffable_item/proc/on_requesting_context_from_item(datum/source, list/context, obj/item/held_item, mob/user)
	SIGNAL_HANDLER

	if (!istype(held_item, /obj/item/restraints/handcuffs))
		return NONE
	var/obj/item/restraints/handcuffs/cuffs = held_item
	if(!cuffs.used)
		context[SCREENTIP_CONTEXT_RMB] = "Cuff to your wrist"
		return CONTEXTUAL_SCREENTIP_SET

/datum/element/cuffable_item/proc/item_interaction(obj/item/source, mob/living/user, obj/item/tool, modifiers)
	SIGNAL_HANDLER

	if(!istype(tool, /obj/item/restraints/handcuffs) || iscyborg(user) || source.anchored || !source.IsReachableBy(user))
		return NONE

	INVOKE_ASYNC(src, PROC_REF(apply_cuffs), source, user, tool)
	return ITEM_INTERACT_SUCCESS

///The proc responsible for adding the status effect to the player and all...
/datum/element/cuffable_item/proc/apply_cuffs(obj/item/source, mob/living/user, obj/item/restraints/handcuffs/cuffs)
	if(cuffs.used || DOING_INTERACTION_WITH_TARGET(user, source))
		return

	for(var/datum/status_effect/cuffed_item/effect in user.status_effects)
		if(effect.cuffed == source)
			to_chat(user, span_warning(LANG("datum.b8be3198a6b41bbf", list(source))))
			return
		if(effect.cuffed_to == user.get_inactive_hand())
			to_chat(user, span_warning(LANG("datum.f8f880598c917a1b", null)))
			return

	if(!user.get_inactive_hand())
		to_chat(user, span_warning(LANG("datum.586de32e15b27397", list(source))))
		return

	if(cuffs.handcuffs_clumsiness_check(user))
		return

	if(SEND_SIGNAL(source, COMSIG_ITEM_PRE_CUFFED_TO_MOB, user, cuffs) & BLOCK_ITEM_CUFF)
		return

	source.balloon_alert(user, LANG("datum.0640e813446265d8", null))
	playsound(source, cuffs.cuffsound, 30, TRUE, -2)
	if(!do_after(user, cuffs.get_handcuff_time(user), source))
		return

	playsound(source, cuffs.cuffsuccesssound, 30, TRUE, -2)

	if(user.apply_status_effect(/datum/status_effect/cuffed_item, source, cuffs))
		source.balloon_alert(user, LANG("datum.4e3e479ae8ff7933", null))
		return

	source.balloon_alert(user, LANG("datum.6eb873609791eb08", null))
	return
