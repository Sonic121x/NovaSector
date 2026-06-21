/obj/structure/spawner/lavaland
	/// whether it has a curse attached to it
	var/cursed = FALSE

/obj/structure/spawner/lavaland/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/cursed_dagger))
		playsound(get_turf(src), 'sound/effects/magic/demon_attack1.ogg', 50, TRUE)
		cursed = !cursed
		if(cursed)
			src.add_atom_colour("#41007e", TEMPORARY_COLOUR_PRIORITY)

		else
			src.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#41007e")

		balloon_alert_to_viewers("a curse has been [cursed ? "placed..." : "lifted..."]")
		if(isliving(user))
			var/mob/living/living_user = user
			living_user.adjust_fire_loss(100)

		to_chat(user, span_warning("这把刀灼伤了你的手！"))
		return

	return ..()

/obj/structure/spawner/lavaland/Destroy()
	if(cursed)
		for(var/mob/living/carbon/human/selected_human in range(7))
			if(is_species(selected_human, /datum/species/lizard/ashwalker))
				continue

			selected_human.AddComponent(/datum/component/ash_cursed)

		for(var/mob/select_mob in GLOB.player_list)
			if(!is_species(select_mob, /datum/species/lizard/ashwalker))
				continue

			to_chat(select_mob, span_boldwarning("一根被诅咒的触须已被破坏！目标已被标记，直到他们逃离这片土地！"))

	. = ..()

/datum/component/ash_cursed
	/// the person who is targeted by the curse
	var/mob/living/carbon/human/human_target

/datum/component/ash_cursed/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	human_target = parent
	ADD_TRAIT(human_target, TRAIT_NO_TELEPORT, REF(src))
	human_target.add_movespeed_modifier(/datum/movespeed_modifier/ash_cursed)
	RegisterSignal(human_target, COMSIG_MOVABLE_MOVED, PROC_REF(do_move))
	RegisterSignal(human_target, COMSIG_LIVING_DEATH, PROC_REF(remove_curse))

/datum/component/ash_cursed/Destroy(force)
	. = ..()
	REMOVE_TRAIT(human_target, TRAIT_NO_TELEPORT, REF(src))
	human_target.remove_movespeed_modifier(/datum/movespeed_modifier/ash_cursed)
	UnregisterSignal(human_target, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_DEATH))
	human_target = null

/datum/component/ash_cursed/proc/remove_curse()
	SIGNAL_HANDLER
	for(var/mob/select_mob in GLOB.player_list)
		if(!is_species(select_mob, /datum/species/lizard/ashwalker))
			continue

		to_chat(select_mob, span_boldwarning("目标已死亡，诅咒已被解除！"))

	qdel(src)

/datum/component/ash_cursed/proc/do_move()
	SIGNAL_HANDLER

	var/turf/human_turf = get_turf(human_target)
	if(!is_mining_level(human_turf.z))
		for(var/mob/select_mob in GLOB.player_list)
			if(!is_species(select_mob, /datum/species/lizard/ashwalker))
				continue

			to_chat(select_mob, span_boldwarning("目标已逃离这片土地，诅咒被打破了！"))
		qdel(src)
		return

	if(prob(75))
		return

	var/obj/effect/decal/cleanable/greenglow/ecto/spawned_goo = locate() in human_turf
	if(spawned_goo)
		return

	spawned_goo = new(human_turf)
	addtimer(CALLBACK(spawned_goo, TYPE_PROC_REF(/obj/effect/decal/cleanable/greenglow/ecto, do_qdel)), 5 MINUTES, TIMER_STOPPABLE|TIMER_DELETE_ME)

/obj/effect/decal/cleanable/greenglow/ecto/proc/do_qdel()
	qdel(src)

/datum/movespeed_modifier/ash_cursed
	multiplicative_slowdown = 1.0
