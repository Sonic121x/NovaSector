
#define TAPE_REQUIRED_TO_FIX 2
#define INFLATABLE_DOOR_OPENED FALSE
#define INFLATABLE_DOOR_CLOSED TRUE
#define BOX_DOOR_AMOUNT 7
#define BOX_WALL_AMOUNT 14

/obj/structure/inflatable
	name = "充气墙"
	desc = "一个充气的塑料薄膜。请勿刺破。"
	layer = CLOSED_TURF_LAYER
	can_atmos_pass = ATMOS_PASS_DENSITY
	opacity = TRUE
	density = TRUE
	anchored = TRUE
	max_integrity = 40
	icon = 'modular_nova/modules/inflatables/icons/inflatable.dmi'
	icon_state = "wall"
	flags_1 = PREVENT_CLICK_UNDER_1
	bullet_impact_sound = NONE
	flags_ricochet = NONE
	armor_type = /datum/armor/none
	/// The type we drop when damaged.
	var/torn_type = /obj/item/inflatable/torn
	/// The type we drop when deflated.
	var/deflated_type = /obj/item/inflatable
	/// The hitsound made when we're... hit...
	var/hit_sound = 'sound/items/basketball_bounce.ogg'
	/// How quickly we deflate when manually deflated.
	var/manual_deflation_time = 3 SECONDS
	/// Whether or not the inflatable has been deflated
	var/has_been_deflated = FALSE
	/// Limits how much damage from environmental fire we can take per second
	COOLDOWN_DECLARE(burn_damage_cd)

/obj/structure/inflatable/Initialize(mapload)
	. = ..()
	register_context()
	air_update_turf(TRUE, !density)
	var/static/list/adjacent_loc_connections = list(
		COMSIG_TURF_EXPOSE = PROC_REF(check_melt),
	)
	AddComponent(/datum/component/connect_range, tracked = src, connections = adjacent_loc_connections, range = 1, works_in_containers = FALSE)

/obj/structure/inflatable/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Deflate"
	return CONTEXTUAL_SCREENTIP_SET

/// Do damage ticks to structure's integrity if the air is warmer than the minimum of fire, we only care about heat
/obj/structure/inflatable/proc/check_melt(turf/source, datum/gas_mixture/air, temperature)
	SIGNAL_HANDLER
	if(QDELETED(src))
		return
	if(temperature < FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		return
	if(!COOLDOWN_FINISHED(src, burn_damage_cd))
		return

	COOLDOWN_START(src, burn_damage_cd, 1 SECONDS)

	var/percent_damage_taken = clamp(0.2 * (temperature / (FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 2.5)), 0.05, 0.25)
	take_damage(max_integrity * percent_damage_taken, BURN, FIRE, sound_effect = FALSE)

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			qdel(src)
			return
		if(EXPLODE_HEAVY)
			deflate()
			return
		if(EXPLODE_LIGHT)
			if(prob(50))
				deflate()
				return

/obj/structure/inflatable/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir)
	. = ..()
	if((damage_flag == BULLET || damage_flag == LASER) && damage_amount >= 5)
		atom_destruction(damage_flag)

/obj/structure/inflatable/atom_destruction(damage_flag)
	visible_message(span_warning("[src] pop\s ！"))
	deflate()
	return ..()

/obj/structure/inflatable/attacked_by(obj/item/item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(item.get_sharpness())
		LAZYSET(attack_modifiers, SILENCE_DEFAULT_MESSAGES, TRUE)
		visible_message(span_danger("<b>[user] 用 [item] 刺穿了 [src]！</b>"))
		deflate()
	return ..()

/obj/structure/inflatable/click_ctrl_shift(mob/user)
	deflate(TRUE)
	return CLICK_ACTION_SUCCESS

/obj/structure/inflatable/play_attack_sound(damage_amount, damage_type, damage_flag)
	playsound(src, hit_sound, 75, TRUE)

// Deflates the airbag and drops a deflated airbag item. If violent, drops a broken item instantly.
/obj/structure/inflatable/proc/deflate(manually = FALSE)
	if(has_been_deflated) // We do not ever want to deflate more than once.
		return
	has_been_deflated = TRUE
	if(manually)
		playsound(src, 'sound/machines/hiss.ogg', 50)
		balloon_alert_to_viewers("slowly deflates!")
		addtimer(CALLBACK(src, PROC_REF(slow_deflate_finish)), manual_deflation_time)
		return
	if(torn_type)
		new torn_type(get_turf(src))
	else
		new /obj/effect/decal/cleanable/plastic(get_turf(src))
	playsound(src, 'sound/items/balloon_pop.ogg', 100)
	qdel(src)

// Called when the airbag is calmly deflated, drops a non-broken item.
/obj/structure/inflatable/proc/slow_deflate_finish()
	if(deflated_type)
		new deflated_type(get_turf(src))
	qdel(src)

/obj/structure/inflatable/door
	name = "充气门"
	can_atmos_pass = ATMOS_PASS_DENSITY
	icon = 'modular_nova/modules/inflatables/icons/inflatable.dmi'
	icon_state = "door_closed"
	base_icon_state = "door"
	torn_type = /obj/item/inflatable/door/torn
	deflated_type = /obj/item/inflatable/door
	/// Are we open(FALSE), or are we closed(TRUE)?
	var/door_state = INFLATABLE_DOOR_CLOSED

/obj/structure/inflatable/door/Initialize(mapload)
	. = ..()
	density = door_state

/obj/structure/inflatable/door/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!user.can_interact_with(src))
		return
	toggle_door()
	to_chat(user, span_notice("你[door_state ? "close" : "open"] [src]了！"))

/obj/structure/inflatable/door/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[door_state ? "closed" : "open"]"

/obj/structure/inflatable/door/proc/toggle_door()
	if(door_state) // opening
		door_state = INFLATABLE_DOOR_OPENED
		flick("[base_icon_state]_opening", src)
	else // Closing
		door_state = INFLATABLE_DOOR_CLOSED
		flick("[base_icon_state]_closing", src)
	density = door_state
	air_update_turf(TRUE, !density)
	update_appearance()


// The deployable item
/obj/item/inflatable
	name = "充气墙"
	desc = "一种折叠的薄膜，激活后可迅速膨胀成大型立方体形状。"
	icon = 'modular_nova/modules/inflatables/icons/inflatable.dmi'
	icon_state = "folded_wall"
	base_icon_state = "folded_wall"
	w_class = WEIGHT_CLASS_SMALL
	/// The structure we deploy when used.
	var/structure_type = /obj/structure/inflatable
	/// Are we torn?
	var/torn = FALSE

/obj/item/inflatable/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/inflatable/torn
	torn = TRUE

/obj/item/inflatable/attack_self(mob/user)
	. = ..()
	if(torn)
		to_chat(user, span_warning("[src] 损坏过于严重，无法使用！"))
		return
	if(locate(structure_type) in get_turf(user))
		to_chat(user, span_warning("这里已经有一堵墙了！"))
		return
	playsound(loc, 'sound/items/zip/zip.ogg', 75, TRUE)
	to_chat(user, span_notice("你给 [src] 充了气。"))
	if(do_after(user, 1 SECONDS, src))
		new structure_type(get_turf(user))
		qdel(src)

/obj/item/inflatable/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/stack/medical/wrap/sticky_tape))
		return ..()
	if(!torn)
		to_chat(user, span_notice("[src]不需要修理！"))
		return
	var/obj/item/stack/medical/wrap/sticky_tape/attacking_tape = attacking_item
	if(attacking_tape.use(TAPE_REQUIRED_TO_FIX, check = TRUE))
		to_chat(user, span_danger("[attacking_tape]不够！你至少需要[TAPE_REQUIRED_TO_FIX]片！"))
		return
	if(!do_after(user, 2 SECONDS, src))
		return
	playsound(user, 'modular_nova/modules/inflatables/sound/ducttape1.ogg', 50, TRUE)
	to_chat(user, span_notice("你用[attacking_tape]修好了[src]！"))
	attacking_tape.use(TAPE_REQUIRED_TO_FIX)
	torn = FALSE
	update_appearance()

/obj/item/inflatable/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][torn ? "_torn" : ""]"

/obj/item/inflatable/examine(mob/user)
	. = ..()
	if(torn)
		. += span_warning("它被严重撕裂，无法使用！看起来可以用一些<b>胶带</b>修复。")

/obj/item/inflatable/suicide_act(mob/living/user)
	visible_message(user, span_danger("[user]开始把[src]塞进[user.p_their()]屁股里！看起来[user.p_their()]要拉绳子了，哦该死！"))
	playsound(user.loc, 'sound/machines/hiss.ogg', 75, TRUE)
	new structure_type(user.loc)
	user.gib()
	return BRUTELOSS

/obj/item/inflatable/door
	name = "充气门"
	desc = "一种折叠膜，激活后可迅速展开成一扇简易的门。"
	icon = 'modular_nova/modules/inflatables/icons/inflatable.dmi'
	icon_state = "folded_door"
	base_icon_state = "folded_door"
	structure_type = /obj/structure/inflatable/door

/obj/item/inflatable/door/torn
	torn = TRUE


/// The storage for the inflatables box.
/datum/storage/inflatables_box
	max_slots = (BOX_DOOR_AMOUNT + BOX_WALL_AMOUNT)
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = (BOX_DOOR_AMOUNT + BOX_WALL_AMOUNT) * WEIGHT_CLASS_SMALL

/datum/storage/inflatables_box/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(/obj/item/inflatable)

/// The box full of inflatables
/obj/item/storage/inflatable
	icon = 'modular_nova/modules/more_briefcases/icons/briefcases.dmi'
	name = "充气屏障箱"
	desc = "内含充气墙和门。"
	icon_state = "briefcase_inflate"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/inflatables_box

/obj/item/storage/inflatable/PopulateContents()
	for(var/i = 0, i < BOX_DOOR_AMOUNT, i++)
		new /obj/item/inflatable/door(src)
	for(var/i = 0, i < BOX_WALL_AMOUNT, i ++)
		new /obj/item/inflatable(src)

#undef TAPE_REQUIRED_TO_FIX
#undef INFLATABLE_DOOR_OPENED
#undef INFLATABLE_DOOR_CLOSED
#undef BOX_DOOR_AMOUNT
#undef BOX_WALL_AMOUNT
