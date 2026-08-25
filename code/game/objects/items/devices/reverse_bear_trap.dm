// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define REVERSE_BEAR_TRAP_COUNTDOWN (60 SECONDS)

/obj/item/reverse_bear_trap
	name = "reverse bear trap"
	desc = "A horrifying set of shut metal jaws, rigged to a kitchen timer and secured by padlock to a head-mounted clamp. To apply, hit someone with it."
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "reverse_bear_trap"
	slot_flags = ITEM_SLOT_HEAD
	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF | UNACIDABLE
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	inhand_icon_state = "reverse_bear_trap"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	///Is the reverse bear trap active?
	var/ticking = FALSE
	///Cooldown for the KILL
	COOLDOWN_DECLARE(kill_countdown)
	///chance per "fiddle" to get the trap off your head
	var/escape_chance = 0
	///Is the target struggling?
	var/struggling = FALSE

	var/time_since_last_beep = 0
	var/datum/looping_sound/reverse_bear_trap/soundloop
	var/datum/looping_sound/reverse_bear_trap_beep/soundloop2

/obj/item/reverse_bear_trap/Initialize(mapload)
	. = ..()
	soundloop = new(src)
	soundloop2 = new(src)

/obj/item/reverse_bear_trap/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(soundloop2)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/reverse_bear_trap/process(seconds_per_tick)
	if(!ticking)
		return
	soundloop2.mid_length = max(0.5, COOLDOWN_TIMELEFT(src, kill_countdown) - 5) //beepbeepbeepbeepbeep
	if (COOLDOWN_FINISHED(src, kill_countdown) || !isliving(loc))
		trigger()

/obj/item/reverse_bear_trap/proc/trigger()
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
	soundloop.stop()
	soundloop2.stop()
	to_chat(loc, span_userdanger(LANG("obj.3d30ee5389409f89", null)))
	addtimer(CALLBACK(src, PROC_REF(snap)), 0.2 SECONDS)
	COOLDOWN_RESET(src, kill_countdown) // reset the countdown in case it wasn't finished

/obj/item/reverse_bear_trap/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!iscarbon(user))
		return
	var/mob/living/carbon/carbon_user = user
	if(carbon_user.get_item_by_slot(ITEM_SLOT_HEAD) != src)
		return
	if(!HAS_TRAIT_FROM(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT) || struggling)
		return

	struggling = TRUE
	var/fear_string
	switch(COOLDOWN_TIMELEFT(src, kill_countdown))
		if(0 SECONDS to 5 SECONDS)
			fear_string = "agonizingly"
		if(5 SECONDS to 20 SECONDS)
			fear_string = "desperately"
		if(20 SECONDS to 40 SECONDS)
			fear_string = "panickedly"
		if(40 SECONDS to 50 SECONDS)
			fear_string = "shakily"

	carbon_user.visible_message(span_danger(LANG("obj.45910ea570347ec7", list(carbon_user, src))), \
		span_danger(LANG("obj.f32392772e696cdf", list(isnull(fear_string) ? "" : " [fear_string]", src))), LANG("obj.3bb492c83a7faac6", null))
	if(!do_after(user, 2 SECONDS, target = src))
		struggling = FALSE
		return
	if(!prob(escape_chance))
		to_chat(user, span_warning(LANG("obj.49f7a530d9c9731a", null)))
		escape_chance++
	else
		user.visible_message(span_warning(LANG("obj.321fa72d4f49177c", list(user, name))), \
		span_userdanger(LANG("obj.f52e22634a937252", null)), LANG("obj.e2559f06650b2ed3", null))
		REMOVE_TRAIT(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT)
	struggling = FALSE

/obj/item/reverse_bear_trap/attack(mob/living/target, mob/living/user)
	if(target.get_item_by_slot(ITEM_SLOT_HEAD))
		to_chat(user, span_warning(LANG("obj.65bcb577c7b77a02", list(target.p_their()))))
		return
	target.visible_message(span_warning(LANG("obj.ba5dd763f2cfd2ac", list(user, src, target))), \
		span_userdanger(LANG("obj.958675a5384e00e5", list(target, src))), LANG("obj.e325c27b21fba1ab", null))
	to_chat(user, span_danger(LANG("obj.6fc8103794c333ca", list(src, target))))

	if(!do_after(user, 3 SECONDS, target = target) || target.get_item_by_slot(ITEM_SLOT_HEAD))
		return
	target.visible_message(span_warning(LANG("obj.b66759c7467b7715", list(user, src, target))), \
		span_userdanger(LANG("obj.99e303ede09d1fb6", list(user, src))), LANG("obj.f8581491dbade22d", null))
	to_chat(user, span_danger(LANG("obj.953c936909c01f86", list(src, target))))

	user.dropItemToGround(src)
	target.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD)
	arm()
	notify_ghosts(
		LANG("obj.b54135c12e1ad41a", list(user.real_name, target.real_name)),
		source = src,
		header = "Reverse bear trap armed",
		notify_flags = NOTIFY_CATEGORY_NOFLASH,
		ghost_sound = 'sound/machines/beep/beep.ogg',
		notify_volume = 75,
	)

/obj/item/reverse_bear_trap/proc/snap()
	reset()
	var/mob/living/carbon/human/victim = loc
	if(!istype(victim) || victim.get_item_by_slot(ITEM_SLOT_HEAD) != src)
		visible_message(span_warning(LANG("obj.bb1d55eb2ae60f86", list(src))))
		playsound(src, 'sound/effects/snap.ogg', 75, TRUE)
	else
		var/mob/living/carbon/human/jill = loc
		jill.visible_message(span_boldwarning(LANG("obj.2978b1c2bcc3f8ea", list(src, jill, jill.p_their()))), span_userdanger(LANG("obj.6588413c69f891c5", list(src))))
		jill.emote("scream")
		playsound(src, 'sound/effects/snap.ogg', 75, TRUE, frequency = 0.5)
		playsound(src, 'sound/effects/splat.ogg', 50, TRUE, frequency = 0.5)
		jill.apply_damage(9999, BRUTE, BODY_ZONE_HEAD)
		jill.investigate_log("has been killed by [src].", INVESTIGATE_DEATHS)
		jill.death() //just in case, for some reason, they're still alive
		flash_color(jill, flash_color = "#FF0000", flash_time = 100)

/obj/item/reverse_bear_trap/proc/reset()
	ticking = FALSE
	update_appearance(UPDATE_OVERLAYS)
	REMOVE_TRAIT(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT)
	soundloop.stop()
	soundloop2.stop()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/reverse_bear_trap/update_overlays()
	. = ..()
	if(ticking != TRUE)
		return
	/// note: this timer overlay increments one frame every second (to simulate a clock ticking). If you want to instead have it do a full cycle in a minute, set the 'delay' of each frame of the icon overlay to 75 rather than 10, and the worn overlay to twice that.
	. += "rbt_ticking"

/obj/item/reverse_bear_trap/proc/arm() //hulen
	ticking = TRUE
	update_appearance(UPDATE_OVERLAYS)
	escape_chance = initial(escape_chance) //we keep these vars until re-arm, for tracking purposes
	COOLDOWN_START(src, kill_countdown, REVERSE_BEAR_TRAP_COUNTDOWN)
	ADD_TRAIT(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT)
	soundloop.start()
	soundloop2.mid_length = initial(soundloop2.mid_length)
	soundloop2.start()
	START_PROCESSING(SSprocessing, src)

#undef REVERSE_BEAR_TRAP_COUNTDOWN
