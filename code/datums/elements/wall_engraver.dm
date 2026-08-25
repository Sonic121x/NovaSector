// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// An element that lets you engrave walls when right click is used
/datum/element/wall_engraver

/datum/element/wall_engraver/Attach(datum/target)
	. = ..()

	if (!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ITEM_PRE_ATTACK_SECONDARY, PROC_REF(on_item_pre_attack_secondary))

/datum/element/wall_engraver/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_EXAMINE)
	UnregisterSignal(source, COMSIG_ITEM_PRE_ATTACK_SECONDARY)

///signal called on parent being examined
/datum/element/wall_engraver/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice(LANG("datum.34e73833244404d2", null))

///signal called on parent being used to right click attack something
/datum/element/wall_engraver/proc/on_item_pre_attack_secondary(datum/source, atom/target, mob/living/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(try_chisel), source, target, user)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/wall_engraver/proc/try_chisel(obj/item/item, turf/closed/wall, mob/living/user)
	if(!istype(wall) || !user.mind)
		return
	if(HAS_TRAIT_FROM(wall, TRAIT_NOT_ENGRAVABLE, ENGRAVED_TRAIT))
		user.balloon_alert(user, LANG("datum.a8695848b4a66492", null))
		return
	if(HAS_TRAIT(wall, TRAIT_NOT_ENGRAVABLE))
		user.balloon_alert(user, LANG("datum.a5e0ccfb53375250", null))
		return
	if(!length(user.mind?.memories))
		user.balloon_alert(user, LANG("datum.97a6810681133cce", null))
		return
	var/datum/memory/memory_to_engrave = user.mind.select_memory("engrave")
	if(!memory_to_engrave)
		return
	if(!user.Adjacent(wall))
		return
	item.add_fingerprint(user)
	playsound(item, item.hitsound, 30, TRUE, -1)
	user.do_attack_animation(wall)
	user.balloon_alert(user, LANG("datum.b6cd9c0693b715de", null))
	if(!do_after(user, 5 SECONDS, target = wall))
		return
	user.balloon_alert(user, LANG("datum.06dc20afe8288da2", null))
	user.do_attack_animation(wall)

	var/do_persistent_save = !(memory_to_engrave.memory_flags & MEMORY_FLAG_NOPERSISTENCE)
	var/engraved_story = memory_to_engrave.generate_story(STORY_ENGRAVING, STORY_FLAG_DATED)

	if(!engraved_story)
		CRASH("Tried to submit a memory with an invalid story [memory_to_engrave]")

	wall.AddComponent(/datum/component/engraved, engraved_story, persistent_save = do_persistent_save, story_value = memory_to_engrave.story_value)
	memory_to_engrave.memory_flags |= MEMORY_FLAG_ALREADY_USED
	//while someone just engraved a story "worth engraving" we should add this to SSpersistence for a possible prison tattoo

	if(do_persistent_save)
		var/list/tattoo_entry = list()

		var/tattoo_story = memory_to_engrave.generate_story(STORY_TATTOO)

		if(!tattoo_story)
			CRASH("Tried to submit a memory with an invalid story [memory_to_engrave]")

		tattoo_entry["story"] = tattoo_story
		SSpersistence.prison_tattoos_to_save += list(tattoo_entry)
