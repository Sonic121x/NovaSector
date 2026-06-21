/obj/item/grenade/antigravity
	name = "反重力手榴弹"
	icon_state = "emp"
	inhand_icon_state = "emp"

	var/range = 7
	var/forced_value = 0
	var/duration = 300

/obj/item/grenade/antigravity/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()

	for(var/turf/lanced_turf in view(range, src))
		lanced_turf.AddElement(/datum/element/forced_gravity, forced_value)
		addtimer(CALLBACK(lanced_turf, TYPE_PROC_REF(/datum/, _RemoveElement), list(/datum/element/forced_gravity, forced_value)), duration)

	qdel(src)
