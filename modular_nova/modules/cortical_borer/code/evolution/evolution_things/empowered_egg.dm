/obj/item/organ/empowered_borer_egg
	name = "strange egg"
	desc = "All slimy and yuck."
	icon_state = "innards" // not like you'll be seeing this anyway
	visual = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_PARASITE_EGG
	/// How long it takes to burst from a corpse
	var/burst_time = 3 MINUTES
	/// What generation the egg will be
	var/generation = 1

/obj/item/organ/empowered_borer_egg/on_find(mob/living/finder)
	..()
	to_chat(finder, span_warning(LANG("obj.6cf60afdabad2645", list(owner, zone))))

/obj/item/organ/empowered_borer_egg/Initialize(mapload)
	. = ..()
	if(iscarbon(loc))
		Insert(loc)

/obj/item/organ/empowered_borer_egg/on_mob_insert(mob/living/carbon/M, special = FALSE, movement_flags = DELETE_IF_REPLACED)
	..()
	addtimer(CALLBACK(src, PROC_REF(try_burst)), burst_time)

/obj/item/organ/empowered_borer_egg/on_mob_remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	visible_message(span_warning(span_italics(LANG("obj.424d6b545e992936", list(src, M)))))
	new/obj/effect/decal/cleanable/food/egg_smudge(get_turf(src))
	qdel(src)

/obj/item/organ/empowered_borer_egg/proc/try_burst()
	if(!owner)
		qdel(src)
		return
	if(owner.stat != DEAD)
		qdel(src)
		return
	var/list/candidates = SSpolling.poll_ghost_candidates(
		"Do you want to spawn as an empowered Cortical Borer bursting from [owner]?",
		role = ROLE_PAI,
		check_jobban = FALSE,
		poll_time = 10 SECONDS,
		ignore_category = POLL_IGNORE_CORTICAL_BORER,
		alert_pic = /obj/item/borer_egg/empowered,
		role_name_text = "empowered cortical borer",
	)
	if(!length(candidates))
		var/obj/effect/mob_spawn/ghost_role/borer_egg/empowered/borer_egg = new(get_turf(owner))
		borer_egg.generation = generation
		var/obj/item/bodypart/chest/chest = owner.get_bodypart(BODY_ZONE_CHEST)
		chest.dismember()
		owner.visible_message(span_danger(LANG("obj.f5cdf564c42a18d3", list(owner))), span_danger(LANG("obj.f39b677b76c56445", null)))
		return
	var/mob/dead/observer/new_borer = pick(candidates)
	var/mob/living/basic/cortical_borer/empowered/spawned_cb = new(get_turf(owner))
	var/obj/item/bodypart/chest/chest = owner.get_bodypart(BODY_ZONE_CHEST)
	chest.dismember()
	owner.visible_message(span_danger(LANG("obj.15bcddc60c34f370", list(spawned_cb, owner))), span_danger(LANG("obj.702a03c7d23e13e3", list(spawned_cb))))
	spawned_cb.generation = generation
	spawned_cb.ckey = new_borer.ckey
	spawned_cb.mind.add_antag_datum(/datum/antagonist/cortical_borer)
