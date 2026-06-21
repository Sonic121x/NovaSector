/// Handles logic for ghost spawning code, visible object in game is handled by /obj/structure/alien/resin/flower_bud
/obj/effect/mob_spawn/ghost_role/venus_human_trap
	name = "花苞"
	desc = "一个巨大的跳动着的植物体……"
	icon = 'icons/mob/spacevines.dmi'
	icon_state = "bud0"
	mob_type = /mob/living/basic/venus_human_trap
	density = FALSE
	prompt_name = "维纳斯捕人草"
	you_are_text = "你是一株维纳斯捕人草。"
	flavour_text = "你是一株维纳斯捕人草！不惜一切代价保护野葛，并吞噬那些与你为敌的家伙！"
	faction = list(FACTION_HOSTILE,FACTION_VINES,FACTION_PLANTS)
	spawner_job_path = /datum/job/venus_human_trap
	invisibility = INVISIBILITY_ABSTRACT //The flower bud structure is our visible component, we just handle logic.
	/// Physical structure housing the spawner
	var/obj/structure/alien/resin/flower_bud/flower_bud
	/// Used to determine when to notify ghosts
	var/ready = FALSE

/obj/effect/mob_spawn/ghost_role/venus_human_trap/Destroy()
	if(flower_bud) // anti harddel checks
		if(!QDELETED(flower_bud))
			qdel(flower_bud)
		flower_bud = null
	return ..()

/obj/effect/mob_spawn/ghost_role/venus_human_trap/equip(mob/living/basic/venus_human_trap/spawned_human_trap)
	if(spawned_human_trap && flower_bud)
		if(flower_bud.trait_flags & SPACEVINE_HEAT_RESISTANT)
			spawned_human_trap.unsuitable_heat_damage = 0
		if(flower_bud.trait_flags & SPACEVINE_COLD_RESISTANT)
			spawned_human_trap.unsuitable_cold_damage = 0

/obj/effect/mob_spawn/ghost_role/venus_human_trap/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.mind.add_antag_datum(/datum/antagonist/venus_human_trap)

/// Called when the attached flower bud has borne fruit (ie. is ready)
/obj/effect/mob_spawn/ghost_role/venus_human_trap/proc/bear_fruit()
	ready = TRUE
	notify_ghosts(
		"[src] has borne fruit!",
		source = src,
		header = "Venus Human Trap",
		click_interact = TRUE,
		ignore_key = POLL_IGNORE_VENUSHUMANTRAP,
	)

/obj/effect/mob_spawn/ghost_role/venus_human_trap/allow_spawn(mob/user, silent = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!ready)
		if(!silent)
			to_chat(user, span_warning("\The [src]还没有结出果实！"))
		return FALSE
	return TRUE
