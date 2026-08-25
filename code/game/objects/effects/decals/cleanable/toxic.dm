// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define DISSOLVE_DURATION 45 SECONDS

/obj/effect/decal/cleanable/greenglow/waste
	name = "caustic sludge"
	desc = "A puddle of toxic, industrial waste. Eats through the floor if not cleaned up."
	icon_state = "waste_spill"
	light_power = 1
	beauty = -300
	clean_type = CLEAN_TYPE_ACID
	decal_reagent = /datum/reagent/toxin/acid/industrial_waste
	reagent_amount = 5
	alpha = 0
	color = "#bebebe8e"

	/// audio of the waste bubbling and melting things.
	var/datum/looping_sound/bubbling_audio // It's really just bubbling liquid audio, which is what I need here.
	/// TimerID for the floor melting effect, so we can stop it if it gets cleaned up.
	var/dissolve_timer

/obj/effect/decal/cleanable/greenglow/waste/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	animate(src, alpha = 255, time = 0.5 SECONDS)

	var/mutable_appearance/splash_animation = mutable_appearance('icons/effects/effects.dmi', "splash_hydroponics")
	splash_animation.color = "#15ff00"
	flick_overlay_view(splash_animation, 1.1 SECONDS)

/obj/effect/decal/cleanable/greenglow/waste/Destroy()
	QDEL_NULL(bubbling_audio)
	QDEL_NULL(particles)
	return ..()

/**
 * Sets up our waste to perform dissolve_floor after the timer goes off.
 */
/obj/effect/decal/cleanable/greenglow/waste/proc/pre_dissolve(display_message = TRUE, dissolve_clock = DISSOLVE_DURATION)
	if(display_message)
		visible_message(span_warning(LANG("obj.b3afca6019bfaa0d", list(src, get_turf(src)))))
	color = "#ffffffff"

	playsound(src, 'sound/items/tools/welder.ogg', 50, TRUE)
	bubbling_audio = new /datum/looping_sound/soup/toxic(src)
	bubbling_audio.start()

	dissolve_timer = addtimer(CALLBACK(src, PROC_REF(dissolve_floor)), dissolve_clock, TIMER_STOPPABLE | TIMER_DELETE_ME)
	particles =  new /particles/acid/toxic()

/obj/effect/decal/cleanable/greenglow/waste/proc/dissolve_floor()
	if(QDELETED(src))
		return
	var/atom/splashed_turf = get_turf(src)
	if(!isfloorturf(splashed_turf))
		return
	var/turf/open/splash_floor = splashed_turf
	splash_floor.ScrapeAway(flags = CHANGETURF_IGNORE_AIR) //Eat away the floor
	visible_message(span_warning(LANG("obj.5ba3b23bc6ee5aaa", list(get_turf(src)))))
	animate(src, time = 0.5 SECONDS, color = "#bebebe8e")
	bubbling_audio?.stop()
	QDEL_NULL(particles)

#undef DISSOLVE_DURATION
