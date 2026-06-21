/obj/effect/forcefield/wizard/heretic
	name = "迷宫书页"
	desc = "一片在空中飞舞的纸页领域，以不可思议的力量排斥着异教徒。"
	icon_state = "lintel"
	initial_duration = 15 SECONDS

/obj/effect/forcefield/wizard/heretic/CanAllowThrough(atom/movable/mover, border_dir)
	if(istype(mover.throwing?.get_thrower(), /obj/effect/forcefield/wizard/heretic))
		return TRUE
	return ..()

/obj/effect/forcefield/wizard/heretic/Bumped(mob/living/bumpee)
	. = ..()
	if(!istype(bumpee) || IS_HERETIC_OR_MONSTER(bumpee))
		return
	var/throwtarget = get_edge_target_turf(loc, get_dir(loc, get_step_away(bumpee, loc)))
	bumpee.safe_throw_at(throwtarget, 10, 10, src, force = MOVE_FORCE_EXTREMELY_STRONG)
	visible_message(span_danger("[src] 在纸页风暴中击退了 [bumpee]！"))

///A heretic item that spawns a barrier at the clicked turf, 3 uses
/obj/item/heretic_labyrinth_handbook
	name = "迷宫手册"
	desc = "一本记载着封锁迷宫法则与规章的书，书写于未知物质之上。其书页蠕动挣扎，似欲挣脱束缚，破书而出。"
	icon = 'icons/obj/service/library.dmi'
	icon_state = "heretichandbook"
	force = 10
	damtype = BURN
	worn_icon_state = "book"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("bashes", "curses")
	attack_verb_simple = list("bash", "curse")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'
	///what type of barrier do we spawn when used
	var/barrier_type = /obj/effect/forcefield/wizard/heretic
	/// Current charges remaining
	var/charges = 5
	/// Max possible amount of charges
	var/max_charges = 5
	/// List that contains each timer for the charge
	var/list/charge_timers = list()
	/// How long before a charge is restored
	var/charge_time = 15 SECONDS

/obj/item/heretic_labyrinth_handbook/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return
	. += span_hypnophrase("在视线范围内的任意地格上生成一道屏障，只有你能通过。持续8秒。")
	. += span_notice("它还有<b>[charges]</b> charge\s 剩余。")

/obj/item/heretic_labyrinth_handbook/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(HAS_TRAIT(interacting_with, TRAIT_COMBAT_MODE_SKIP_INTERACTION))
		return NONE
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/heretic_labyrinth_handbook/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!IS_HERETIC(user))
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			to_chat(human_user, span_userdanger("当你凝视书卷深处时，你的心智仿佛在燃烧，头痛欲裂，如同大脑着火一般！"))
			human_user.adjust_organ_loss(ORGAN_SLOT_BRAIN, 30, 190)
			human_user.add_mood_event("gates_of_mansus", /datum/mood_event/gates_of_mansus)
			human_user.dropItemToGround(src)
		return ITEM_INTERACT_BLOCKING

	if(charges <= 0)
		balloon_alert(user, "没有充能了！")
		return ITEM_INTERACT_BLOCKING

	var/turf/turf_target = get_turf(interacting_with)
	if(locate(barrier_type) in turf_target)
		user.balloon_alert(user, "已被占用！")
		return ITEM_INTERACT_BLOCKING
	turf_target.visible_message(span_warning("一场纸页风暴凭空显现！"))
	new /obj/effect/temp_visual/paper_scatter(turf_target)
	playsound(turf_target, 'sound/effects/magic/smoke.ogg', 30)
	new barrier_type(turf_target, user)
	charges--
	charge_timers.Add(addtimer(CALLBACK(src, PROC_REF(recharge)), charge_time, TIMER_STOPPABLE))
	return ITEM_INTERACT_SUCCESS

/obj/item/heretic_labyrinth_handbook/proc/recharge()
	charges = min(charges+1, max_charges)
