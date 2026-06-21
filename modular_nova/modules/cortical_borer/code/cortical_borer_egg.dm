/obj/effect/mob_spawn/ghost_role/borer_egg
	name = "钻虫卵"
	desc = "一种已知会爬进你体内的生物的卵，请小心。"
	icon = 'modular_nova/modules/cortical_borer/icons/animal.dmi'
	icon_state = "brainegg"
	layer = BELOW_MOB_LAYER
	density = FALSE
	mob_name = "cortical borer"
	///Type of mob that will be spawned
	mob_type = /mob/living/basic/cortical_borer
	role_ban = ROLE_ALIEN
	show_flavor = FALSE
	prompt_name = "皮层钻孔虫"
	you_are_text = "你是一只皮层钻孔虫。"
	flavour_text = "You are a cortical borer! You can fear someone to make them stop moving, but make sure to inhabit them! \
					You only grow/heal/talk when inside a host!"
	important_text = "As a borer, you have the option to be friendly or not. \
					Note that how you act will determine how a host responds. \
					Do not wordlessly resort to mechanics within a host. \
					You can talk to other borers using ; and your host by just speaking normally. \
					You are unable to speak outside of a host, but are able to emote."
	///what the generation of the borer egg is
	var/generation = 1
	///the egg that is attached to this mob spawn
	var/obj/item/borer_egg/host_egg = /obj/item/borer_egg

/obj/effect/mob_spawn/ghost_role/borer_egg/Destroy()
	host_egg = null
	return ..()

/obj/effect/mob_spawn/ghost_role/borer_egg/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.mind.add_antag_datum(/datum/antagonist/cortical_borer)
	spawned_mob.name = "脑皮层钻虫 ([generation]-[rand(100,999)])"
	QDEL_NULL(host_egg)

/obj/effect/mob_spawn/ghost_role/borer_egg/Initialize(mapload, datum/team/cortical_borers/borer_team)
	. = ..()
	host_egg = new host_egg(get_turf(src))
	host_egg.host_spawner = src
	forceMove(host_egg)
	var/area/src_area = get_area(src)
	if(src_area)
		notify_ghosts("A cortical borer egg has been laid in \the [src_area.name].",
			source = src,
			notify_flags = NOTIFY_CATEGORY_NOFLASH & ~GHOST_NOTIFY_NOTIFY_SUICIDERS,
			click_interact = TRUE,
			ignore_key = POLL_IGNORE_DRONE,
		)

/obj/item/borer_egg
	name = "钻虫卵"
	desc = "一种已知会爬进你体内的生物的卵，请小心。"
	icon = 'modular_nova/modules/cortical_borer/icons/animal.dmi'
	icon_state = "brainegg"
	layer = BELOW_MOB_LAYER
	///the spawner that is attached to this item
	var/obj/effect/mob_spawn/ghost_role/borer_egg/host_spawner

/obj/item/borer_egg/attack_ghost(mob/user)
	if(host_spawner)
		host_spawner.attack_ghost(user)
	return ..()

/obj/item/borer_egg/attack_self(mob/user, modifiers)
	to_chat(user, span_notice("你将[src]在手中捏碎。"))
	new /obj/effect/decal/cleanable/food/egg_smudge(get_turf(user))
	if(host_spawner)
		QDEL_NULL(host_spawner)
	qdel(src)

/obj/item/borer_egg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)
	QDEL_NULL(host_spawner)
	qdel(src)

/obj/item/borer_egg/empowered
	name = "强化脑蛭卵"
	icon_state = "empowered_brainegg"

/obj/effect/mob_spawn/ghost_role/borer_egg/traitor
	prompt_name = "皮层钻孔虫（叛徒生成）"

/obj/effect/mob_spawn/ghost_role/borer_egg/opfor
	prompt_name = "皮层钻孔虫（敌对势力生成）"

/obj/effect/mob_spawn/ghost_role/borer_egg/empowered
	name = "强化脑蛭卵"
	desc = "一种从人体内爬出而非爬入的生物的卵。"
	mob_type = /mob/living/basic/cortical_borer/empowered
	host_egg = /obj/item/borer_egg/empowered
