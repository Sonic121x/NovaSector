
/datum/action/cooldown/spell/pointed/projectile/flesh_restraints
	name = "血肉束缚"
	desc = "发射以束缚你的猎物。"
	button_icon = 'icons/obj/weapons/restraints.dmi'
	button_icon_state = "flesh_snare"

	cooldown_time = 6 SECONDS
	spell_requirements = NONE

	active_msg = "You prepare to throw a restraint at your target!"
	cast_range = 8
	projectile_type = /obj/projectile/mega_arachnid

/obj/projectile/mega_arachnid
	name = "血肉陷阱"
	icon_state = "tentacle_end"
	damage = 0

/obj/projectile/mega_arachnid/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(!iscarbon(target) || blocked >= 100)
		return
	var/obj/item/restraints/legcuffs/beartrap/mega_arachnid/restraint = new(get_turf(target))
	restraint.spring_trap(target)

/obj/item/restraints/legcuffs/beartrap/mega_arachnid
	name = "血肉束缚"
	desc = "巨型蛛形纲生物用来固定猎物的工具。"
	flags_1 = NONE
	item_flags = DROPDEL
	icon_state = "flesh_snare"
	armed = TRUE

/obj/item/restraints/legcuffs/beartrap/mega_arachnid/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MEGA_ARACHNID, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)


/datum/action/cooldown/mob_cooldown/secrete_acid
	name = "分泌酸液"
	button_icon = 'icons/effects/acid.dmi'
	button_icon_state = "default"
	desc = "分泌一种滑溜溜的酸液！"
	cooldown_time = 15 SECONDS
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/secrete_acid/Activate(atom/target_atom)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(release_acid))
	addtimer(CALLBACK(src, PROC_REF(deactivate_ability)), 3 SECONDS)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/secrete_acid/proc/release_acid()
	SIGNAL_HANDLER

	var/turf/current_turf = owner.loc
	if(locate(/obj/effect/slippery_acid) in current_turf.contents)
		return

	new /obj/effect/slippery_acid(current_turf)

/datum/action/cooldown/mob_cooldown/secrete_acid/proc/deactivate_ability()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

/obj/effect/slippery_acid
	name = "滑溜酸液"
	icon = 'icons/effects/acid.dmi'
	icon_state = "default"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	anchored = TRUE
	/// how long does the acid exist for
	var/duration_time = 5 SECONDS

/obj/effect/slippery_acid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 6 SECONDS)
	QDEL_IN(src, duration_time)
