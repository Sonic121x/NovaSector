// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
///Maximum amount of times a clock can be repaired until it's destroyed beyond repair.
#define MAX_CLOCK_REPAIRS 2

/obj/item/table_clock
	name = "table clock"
	desc = "An annoying clock that keeps you sane through tireless nights."
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
		. += span_info(LANG("obj.8887d34c118371f1", null))
	else
		. += span_info(LANG("obj.e61b3194fa2c7c76", list(server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour)))))
		if(user.is_literate())
			. += span_info(LANG("obj.f5c79a87073cc118", list(round_timestamp())))

/obj/item/table_clock/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(attacking_item.force < 5 || broken)
		return
	if(break_clock(break_sound = 'sound/effects/magic/clockwork/ark_activation.ogg'))
		user.visible_message(
			span_warning(LANG("obj.9269ffbf4fde983c", list(user, src))),
			span_bolddanger(LANG("obj.d00b3664ffb856f2", null)),
			span_notice(LANG("obj.ed8c165e04d8f37f", null)),
		)

/obj/item/table_clock/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first, datum/callback/callback, force, gentle, quickstart, throw_type_path = /datum/thrownthing)
	. = ..()
	if(!.)
		return
	break_clock(break_sound = 'sound/effects/footstep/glass_step.ogg')

/obj/item/table_clock/interact(mob/user)
	. = ..()
	if(!broken)
		to_chat(user, span_warning(LANG("obj.d7466fc29c30905f", null)))
		return
	if(times_broken > MAX_CLOCK_REPAIRS)
		user.balloon_alert(user, LANG("obj.414324aaa5e6b00f", null))
		return
	user.balloon_alert(user, LANG("obj.6007692b409a9b92", null))
	if(!do_after(user, 10 SECONDS, src))
		return
	user.balloon_alert(user, LANG("obj.c296b9e51a558a1f", null))
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
