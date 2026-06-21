/obj/item/organ/empowered_borer_egg
	name = "奇怪的蛋"
	desc = "全是黏糊糊的恶心东西。"
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
	to_chat(finder, span_warning("你在[owner]的[zone]里发现了一枚未知的蛋！"))

/obj/item/organ/empowered_borer_egg/Initialize(mapload)
	. = ..()
	if(iscarbon(loc))
		Insert(loc)

/obj/item/organ/empowered_borer_egg/on_mob_insert(mob/living/carbon/M, special = FALSE, movement_flags = DELETE_IF_REPLACED)
	..()
	addtimer(CALLBACK(src, PROC_REF(try_burst)), burst_time)

/obj/item/organ/empowered_borer_egg/on_mob_remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	visible_message(span_warning(span_italics("当[src]从[M]体内被切出时，它迅速振动并碎裂，只留下一些粘液！")))
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
		owner.visible_message(span_danger("一枚蛋从[owner]的胸口爆裂而出，血肉碎块四处飞溅！"), span_danger("一枚蛋从你的胸口爆裂而出，内脏碎块四处飞溅！"))
		return
	var/mob/dead/observer/new_borer = pick(candidates)
	var/mob/living/basic/cortical_borer/empowered/spawned_cb = new(get_turf(owner))
	var/obj/item/bodypart/chest/chest = owner.get_bodypart(BODY_ZONE_CHEST)
	chest.dismember()
	owner.visible_message(span_danger("[spawned_cb]从[owner]的胸口爆裂而出，血肉碎块四处飞溅！"), span_danger("[spawned_cb]从你的胸口爆裂而出，内脏碎块四处飞溅！"))
	spawned_cb.generation = generation
	spawned_cb.ckey = new_borer.ckey
	spawned_cb.mind.add_antag_datum(/datum/antagonist/cortical_borer)
