///Maximum amount of times a clock can be repaired until it's destroyed beyond repair.
#define MAX_CLOCK_REPAIRS 2

/obj/item/table_clock
	name = "台钟"
	desc = "一个恼人的时钟，在无尽的长夜中保持你的理智。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "table_clock"
	inhand_icon_state = "table_clock"
	base_icon_state = "table_clock"
	w_class = WEIGHT_CLASS_TINY

	///Soundloop we use of a clock ticking.
	var/datum/looping_sound/clock/soundloop
	///Boolean on whether the clock has been destroyed.
	var/broken = FALSE
	///Amount of times the clock has been destroyed. It becomes unrepairable the third time.
	var/times_broken

/obj/item/table_clock/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)
	AddElement(/datum/element/beauty, 200)

/obj/item/table_clock/Destroy(force)
	soundloop.stop()
	return ..()

/obj/item/table_clock/examine(mob/user)
	. = ..()
	if(broken)
		. += span_info("它目前似乎是坏的。你可以拿在手上修理它。")
	else
		. += span_info("The current NST (local) time is: [server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))].")
		if(user.is_literate())
			. += span_info("That means it is currently [round_timestamp()] into the shift.")

/obj/item/table_clock/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(attacking_item.force < 5 || broken)
		return
	if(break_clock(break_sound = 'sound/effects/magic/clockwork/ark_activation.ogg'))
		user.visible_message(
			span_warning("[user] smashes \the [src] so hard it stops breaking!"),
			span_bolddanger("我再也受不了这台愚蠢的机器了！快闭嘴！"),
			span_notice("你听到反复的砸击声！"),
		)

/obj/item/table_clock/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first, datum/callback/callback, force, gentle, quickstart, throw_type_path = /datum/thrownthing)
	. = ..()
	if(!.)
		return
	break_clock(break_sound = 'sound/effects/footstep/glass_step.ogg')

/obj/item/table_clock/interact(mob/user)
	. = ..()
	if(!broken)
		to_chat(user, span_warning("碰这个钟？冒着弄坏它的风险？你疯了吗？？"))
		return
	if(times_broken > MAX_CLOCK_REPAIRS)
		user.balloon_alert(user, "时钟无法修复！")
		return
	user.balloon_alert(user, "正在修复时钟...")
	if(!do_after(user, 10 SECONDS, src))
		return
	user.balloon_alert(user, "时钟已修复！")
	broken = FALSE
	soundloop.start()
	update_appearance(UPDATE_ICON)

/obj/item/table_clock/update_icon_state()
	icon_state = "[base_icon_state][broken ? "_broken" : null]"
	return ..()

/**
 * Breaks the clock, turning off the soundloop.
 * Returns TRUE if it successfully breaks, FALSE otherwise.
 */
/obj/item/table_clock/proc/break_clock(break_sound)
	if(broken)
		return FALSE

	broken = TRUE
	soundloop.stop()
	playsound(src, break_sound, 40, FALSE)
	times_broken++
	update_appearance(UPDATE_ICON)
	return TRUE

#undef MAX_CLOCK_REPAIRS
