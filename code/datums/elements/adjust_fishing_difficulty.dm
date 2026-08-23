///Influences the difficulty of the minigame when worn or if buckled to.
/datum/element/adjust_fishing_difficulty
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	///The additive numerical modifier to the difficulty of the minigame
	var/modifier
	///For items, in which slot it has to be worn to influence the difficulty of the minigame
	var/slots

/datum/element/adjust_fishing_difficulty/Attach(datum/target, modifier, slots = NONE)
	. = ..()
	if(!ismovable(target) || !modifier)
		return COMPONENT_INCOMPATIBLE

	if(!isitem(target))
		var/atom/movable/movable_target = target
		if(!movable_target.can_buckle)
			return COMPONENT_INCOMPATIBLE

		RegisterSignal(target, COMSIG_MOVABLE_BUCKLE, PROC_REF(on_buckle), override = TRUE)
		RegisterSignal(target, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(on_unbuckle), override = TRUE)
		RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_buckle_examine), override = TRUE)

	else
		RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped), override = TRUE)
		RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped), override = TRUE)
		RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_item_examine), override = TRUE)

	src.modifier = modifier
	src.slots = slots

	update_check(target)

/datum/element/adjust_fishing_difficulty/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(
		COMSIG_ATOM_EXAMINE,
		COMSIG_MOVABLE_BUCKLE,
		COMSIG_MOVABLE_UNBUCKLE,
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
	))

	update_check(source, TRUE)

/datum/element/adjust_fishing_difficulty/proc/update_check(atom/movable/movable_source, removing = FALSE)
	for(var/mob/living/buckled_mob as anything in movable_source.buckled_mobs)
		update_user(buckled_mob, movable_source, removing)
	if(!isitem(movable_source) || !isliving(movable_source.loc))
		return
	var/mob/living/holder = movable_source.loc
	var/obj/item/item = movable_source
	if(holder.get_slot_by_item(movable_source) & (slots || item.slot_flags))
		update_user(holder, movable_source, removing)

/datum/element/adjust_fishing_difficulty/proc/on_item_examine(obj/item/item, mob/user, list/examine_text)
	SIGNAL_HANDLER
	if(!HAS_MIND_TRAIT(user, TRAIT_EXAMINE_FISH))
		return
	// NOVA EDIT CHANGE START - I18N: 原来把「Holding/Wearing + 代词」先拼成 method 再塞进整句，
	// 拼出来的串既不是目录键、语序也钉死成英文的。改为按方式各自一条整句模板。
	var/method_key = ((slots || item.slot_flags) & ITEM_SLOT_HANDS) ? "datum.3f95f43d1f26ed72" : "datum.1ff5eec7f9663d46"
	add_examine_line(user, examine_text, method_key, item.p_them())
	// NOVA EDIT CHANGE END

/datum/element/adjust_fishing_difficulty/proc/on_buckle_examine(atom/movable/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	if(!HAS_MIND_TRAIT(user, TRAIT_EXAMINE_FISH))
		return
	add_examine_line(user, examine_text, "datum.763fc6df520b572c", source.p_them()) // NOVA EDIT - I18N

/datum/element/adjust_fishing_difficulty/proc/add_examine_line(mob/user, list/examine_text, method_key, pronoun) // NOVA EDIT CHANGE - I18N: method 文本 -> 模板 key + 代词实参。ORIGINAL: add_examine_line(mob/user, list/examine_text, method)
	var/percent = HAS_MIND_TRAIT(user, TRAIT_EXAMINE_DEEPER_FISH) ? "[abs(modifier)]% " : ""
	var/text = LANG(method_key, list(pronoun, percent, modifier < 0 ? "easier" : "harder")) // NOVA EDIT - I18N
	if(modifier < 0)
		examine_text += span_nicegreen(text)
	else
		examine_text += span_danger(text)

/datum/element/adjust_fishing_difficulty/proc/on_buckle(atom/movable/source, mob/living/buckled_mob, forced)
	SIGNAL_HANDLER
	update_user(buckled_mob, source)

/datum/element/adjust_fishing_difficulty/proc/on_unbuckle(atom/movable/source, mob/living/buckled_mob, forced)
	SIGNAL_HANDLER
	update_user(buckled_mob, source, TRUE)

/datum/element/adjust_fishing_difficulty/proc/on_equipped(obj/item/source, mob/living/wearer, slot)
	SIGNAL_HANDLER
	if(slot & (slots || source.slot_flags))
		update_user(wearer, source)

/datum/element/adjust_fishing_difficulty/proc/on_dropped(obj/item/source, mob/living/dropper)
	SIGNAL_HANDLER
	update_user(dropper, source, TRUE)

/// Updates the user's tracked current fishing modifiers
/datum/element/adjust_fishing_difficulty/proc/update_user(mob/living/user, obj/source_item, removing = FALSE)
	if(removing)
		LAZYREMOVE(user.fishing_difficulty_mods_by_source, source_item.type)
	else
		LAZYSET(user.fishing_difficulty_mods_by_source, source_item.type, modifier)

	// Are we currently in a fishing challenge? If so, update that challenge as well
	var/datum/fishing_challenge/challenge = GLOB.fishing_challenges_by_user[user]
	if(challenge)
		challenge.update_difficulty()
