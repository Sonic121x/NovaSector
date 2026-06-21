/obj/effect/decal/cleanable/food
	icon = 'icons/effects/tomatodecal.dmi'
	gender = NEUTER
	beauty = -100

/obj/effect/decal/cleanable/food/tomato_smudge
	name = "番茄污物"
	desc = "它是红色的。"
	icon_state = "tomato_floor1"
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/decal/cleanable/food/tomato_smudge/can_bloodcrawl_in()
	return TRUE // why? why not.

/obj/effect/decal/cleanable/food/plant_smudge
	name = "植物污物"
	desc = "叶绿素？更像硼叶！"
	icon_state = "smashed_plant"

/obj/effect/decal/cleanable/food/egg_smudge
	name = "碎蛋"
	desc = "这只大概孵不出来了。"
	icon_state = "smashed_egg1"
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/decal/cleanable/food/pie_smudge //honk
	name = "碎馅饼"
	desc = "这是奶油馅饼里的馅饼奶油。"
	icon_state = "smashed_pie"

/obj/effect/decal/cleanable/food/salt
	name = "盐堆"
	desc = "一大堆食盐。一定有人不高兴了。"
	icon_state = "salt_pile"
	var/safepasses = 3 //how many times can this salt pile be passed before dissipating

/obj/effect/decal/cleanable/food/salt/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered)
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/decal/cleanable/food/salt/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(is_species(mover, /datum/species/snail))
		return FALSE

/obj/effect/decal/cleanable/food/salt/Bumped(atom/movable/AM)
	. = ..()
	if(is_species(AM, /datum/species/snail))
		to_chat(AM, span_danger("你的去路被[span_phobia("salt")]阻挡了。"))

/obj/effect/decal/cleanable/food/salt/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(!isliving(AM))
		return

	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(C.move_intent == MOVE_INTENT_WALK)
			return

	safepasses--
	if(safepasses <= 0 && !QDELETED(src))
		qdel(src)

/obj/effect/decal/cleanable/food/flour
	name = "面粉"
	desc = "它依然能吃，四秒原则！"
	icon_state = "flour"

/obj/effect/decal/cleanable/food/squid_ink
	name = "墨迹污渍"
	desc = "某种墨状物质的污渍..."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	color = COLOR_DARK

/obj/effect/decal/cleanable/food/squid_ink/Initialize(mapload, list/datum/disease/diseases)
	icon_state = "floor[rand(1, 7)]"
	return ..()
