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
	examine_list += span_notice("如果你能想到什么有趣的东西，你可以用次要攻击在一些墙壁上雕刻。")

///signal called on parent being used to right click attack something
/datum/element/wall_engraver/proc/on_item_pre_attack_secondary(datum/source, atom/target, mob/living/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(try_chisel), source, target, user)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/wall_engraver/proc/try_chisel(obj/item/item, turf/closed/wall, mob/living/user)
	if(!istype(wall) || !user.mind)
		return
	if(HAS_TRAIT_FROM(wall, TRAIT_NOT_ENGRAVABLE, ENGRAVED_TRAIT))
		user.balloon_alert(user, "墙壁已被雕刻过！")
		return
	if(HAS_TRAIT(wall, TRAIT_NOT_ENGRAVABLE))
		user.balloon_alert(user, "墙壁无法雕刻！")
		return
	if(!length(user.mind?.memories))
		user.balloon_alert(user, "没什么值得铭记的东西可刻！")
		return
	var/datum/memory/memory_to_engrave = user.mind.select_memory("engrave")
	if(!memory_to_engrave)
		return
	if(!user.Adjacent(wall))
		return
	item.add_fingerprint(user)
	playsound(item, item.hitsound, 30, TRUE, -1)
	user.do_attack_animation(wall)
	user.balloon_alert(user, "正在雕刻墙壁...")
	if(!do_after(user, 5 SECONDS, target = wall))
		return
	user.balloon_alert(user, "墙壁已雕刻")
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
