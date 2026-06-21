/// Turns the user into a puzzgrid
/datum/smite/puzzgrid
	name = "Puzzgrid游戏"

	var/timer
	var/gib_on_loss

/datum/smite/puzzgrid/configure(client/user)
	var/timer = input(user, "其他人应该有多少时间来解谜？0表示无限时间。", "Puzzgrid游戏", 0) as num | null
	if (isnull(timer))
		return FALSE

	var/gib_on_loss = tgui_alert(user, "他们失败时会发生什么？", "Puzzgrid游戏", list("Gib", "New puzzle")) == "Gib"

	src.gib_on_loss = gib_on_loss
	src.timer = timer == 0 ? null : (timer * 1 SECONDS)

	return TRUE

/datum/smite/puzzgrid/effect(client/user, mob/living/target)
	. = ..()

	var/datum/puzzgrid/puzzgrid = create_random_puzzgrid()
	if (isnull(puzzgrid))
		to_chat(user, span_warning("无法创建拼图网格！或许是配置未设置？"))
		return

	var/obj/structure/puzzgrid_effect/puzzgrid_effect = new(target.loc, target, puzzgrid, timer, gib_on_loss)
	target.forceMove(puzzgrid_effect)
	puzzgrid_effect.visible_message(span_warning("[target] 突然变成了一个极其困难的谜题！"))

	playsound(puzzgrid_effect, 'sound/effects/magic.ogg', 70)

/obj/structure/puzzgrid_effect
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"

	var/mob/living/victim
	var/timer
	var/gib_on_loss

/obj/structure/puzzgrid_effect/Initialize(mapload, mob/living/victim, datum/puzzgrid/puzzgrid, timer, gib_on_loss)
	. = ..()

	if (isnull(victim))
		return

	src.victim = victim
	src.timer = timer
	src.gib_on_loss = gib_on_loss

	name = "[victim]的残酷诅咒"

	victim.add_traits(list(TRAIT_HANDS_BLOCKED, TRAIT_IMMOBILIZED), "[type]")

	add_puzzgrid_component(puzzgrid)

/obj/structure/puzzgrid_effect/Destroy()
	QDEL_NULL(victim)
	return ..()

/obj/structure/puzzgrid_effect/proc/add_puzzgrid_component(datum/puzzgrid/puzzgrid)
	AddComponent( \
		/datum/component/puzzgrid, \
		puzzgrid = puzzgrid, \
		timer = timer, \
		on_victory_callback = CALLBACK(src, PROC_REF(on_victory)), \
		on_fail_callback = CALLBACK(src, gib_on_loss ? PROC_REF(loss_gib) : PROC_REF(loss_restart)), \
	)

/obj/structure/puzzgrid_effect/proc/on_victory()
	victim.forceMove(loc)
	victim.Paralyze(5 SECONDS)
	victim.visible_message(
		span_notice("[victim]从他们邪恶的牢笼中被解放了！"),
		span_notice("你从邪恶的牢笼中被解放了！"),
	)

	victim.remove_traits(list(TRAIT_HANDS_BLOCKED, TRAIT_IMMOBILIZED), "[type]")

	victim = null

	qdel(src)

/obj/structure/puzzgrid_effect/proc/loss_gib()
	victim.forceMove(loc)
	victim.visible_message(
		span_bolddanger("你未能将[victim]从他们邪恶的牢笼中解救出来，只留下了一滩肉泥！"),
		span_bolddanger("你的同伴未能将你从邪恶的牢笼中解救出来，只留下了一滩肉泥！"),
	)
	victim.gib(DROP_ALL_REMAINS)
	victim = null

	qdel(src)

/obj/structure/puzzgrid_effect/proc/loss_restart()
	var/datum/puzzgrid/puzzgrid = create_random_puzzgrid()
	if (isnull(puzzgrid))
		victim.forceMove(loc)
		victim.Paralyze(5 SECONDS)
		victim.visible_message(span_bolddanger("尽管完全解谜失败，但凭借难以置信的运气，[victim]还是设法逃脱了！"))
		victim.remove_traits(list(TRAIT_HANDS_BLOCKED, TRAIT_IMMOBILIZED), "[type]")
		qdel(src)
		victim = null
		return

	visible_message(span_danger("这个极其困难的谜题变形为了另一个同样具有挑战性的谜题！"))

	// Defer until after the fail proc finishes, since that will qdel the component.
	addtimer(CALLBACK(src, PROC_REF(add_puzzgrid_component), puzzgrid), 0)
