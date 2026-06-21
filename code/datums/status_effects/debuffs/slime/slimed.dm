/// The minimum amount of water stacks needed to start washing off the slime.
#define MIN_WATER_STACKS 5
/// The minimum amount of health a mob has to have before the status effect is removed.
#define MIN_HEALTH 10

/atom/movable/screen/alert/status_effect/slimed
	name = "被史莱姆覆盖"
	desc = "你被史莱姆覆盖，它正在侵蚀你！点击开始清理，或寻找更快的冲洗方法！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "slimed"
	clickable_glow = TRUE

/atom/movable/screen/alert/status_effect/slimed/Click()
	. = ..()
	if (!.)
		return FALSE
	if (!can_wash())
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(remove_slime))
	return TRUE

/// Confirm that we are capable of washing off slime
/atom/movable/screen/alert/status_effect/slimed/proc/can_wash()
	var/mob/living/living_owner = owner
	if (!living_owner.can_resist())
		return FALSE
	if (DOING_INTERACTION_WITH_TARGET(owner, owner))
		return FALSE
	if (locate(/datum/status_effect/fire_handler/wet_stacks) in living_owner.status_effects)
		return FALSE // Don't double dip with washing
	return TRUE

/// Try to get rid of it
/atom/movable/screen/alert/status_effect/slimed/proc/remove_slime()
	owner.balloon_alert(owner, "正在清理史莱姆……")
	var/datum/status_effect/slimed/slime_effect = owner.has_status_effect(/datum/status_effect/slimed)
	while (!QDELETED(src) && !isnull(slime_effect))
		if (!can_wash())
			return
		var/clean_interval = HAS_TRAIT(owner, TRAIT_WOUND_LICKER) ? 1.2 SECONDS : 1.5 SECONDS
		owner.Shake(2, 0, duration = clean_interval * 0.8, shake_interval = 0.05 SECONDS)
		if (!do_after(owner, clean_interval, owner))
			return
		slime_effect.remove_stacks()

/datum/status_effect/slimed
	id = "slimed"
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/slimed
	remove_on_fullheal = TRUE

	/// The amount of slime stacks that were applied, reduced by showering yourself under water.
	var/slime_stacks = 10 // ~10 seconds of standing under a shower
	/// Slime color, used for particles.
	var/slime_color
	/// Changes particle colors to rainbow, this overrides `slime_color`.
	var/rainbow

/datum/status_effect/slimed/on_creation(mob/living/new_owner, slime_color = COLOR_SLIME_GREY, rainbow = FALSE)
	src.slime_color = slime_color
	src.rainbow = rainbow
	return ..()

/datum/status_effect/slimed/on_apply()
	if(owner.get_organic_health() <= MIN_HEALTH)
		return FALSE
	to_chat(owner, span_userdanger("你被一层厚厚的史莱姆覆盖了！想办法冲洗掉它！"))
	return ..()

/datum/status_effect/slimed/on_remove()
	owner.remove_shared_particles(rainbow ? "slimed_rainbow" : "slimed_[slime_color]")

/datum/status_effect/slimed/update_particles()
	var/obj/effect/abstract/shared_particle_holder/holder = owner.add_shared_particles(rainbow ? /particles/slime/rainbow : /particles/slime, rainbow ? "slimed_rainbow" : "slimed_[slime_color]")
	if (!rainbow)
		holder.particles.color = "[slime_color]a0"

/datum/status_effect/slimed/proc/remove_stacks(stacks_to_remove = 1)
	slime_stacks -= stacks_to_remove // lose 1 stack per second
	if(slime_stacks <= 0)
		to_chat(owner, span_notice("你设法完全冲洗掉了史莱姆层。"))
		qdel(src)
		return

	if(prob(10))
		to_chat(owner,span_warning("史莱姆层正慢慢变薄。"))

/datum/status_effect/slimed/tick(seconds_between_ticks)
	// remove from the mob once we have dealt enough damage
	if(owner.get_organic_health() <= MIN_HEALTH)
		to_chat(owner, span_warning("你感觉到史莱姆层正从你虚弱的身体上爬离。"))
		qdel(src)
		return

	// handle washing slime off
	var/datum/status_effect/fire_handler/wet_stacks/wetness = locate() in owner.status_effects
	if(istype(wetness) && wetness.stacks > (MIN_WATER_STACKS * seconds_between_ticks))
		wetness.adjust_stacks(-5 * seconds_between_ticks)
		remove_stacks(seconds_between_ticks) // 1 per second
		if(slime_stacks <= 0)
			return

	// otherwise deal brute damage
	owner.apply_damage(rand(2,4) * seconds_between_ticks, damagetype = BRUTE)

	if(SPT_PROB(10, seconds_between_ticks))
		var/feedback_text = pick(list(
			"Your entire body screams with pain",
			"Your skin feels like it's coming off",
			"Your body feels like it's melting together"
		))
		to_chat(owner, span_userdanger("[feedback_text]，因为史莱姆层正在侵蚀你！"))

/datum/status_effect/slimed/get_examine_text()
	return span_warning("[owner.p_They()] [owner.p_are()] 覆盖着冒泡的史莱姆！")

#undef MIN_HEALTH
#undef MIN_WATER_STACKS
