// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/pointed/swap
	name = "Swap"
	desc = "This spell allows you to swap locations with any living being. \
		RMB: Mark a secondary swap target. This secondary swap target will be discarded once you swap, \
		or else you can click yourself with the RMB to discard your secondary target."
	button_icon_state = "swap"
	ranged_mousepointer = 'icons/effects/mouse_pointers/swap_target.dmi'
	active_overlay_icon_state = "bg_spell_border_active_blue"

	school = SCHOOL_TRANSLOCATION
	cooldown_time = 25 SECONDS
	cooldown_reduction_per_rank = 10 SECONDS
	spell_max_level = 3
	cast_range = 9
	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_STATION
	active_msg = "You prepare to swap locations with a target..."

	smoke_type = /datum/effect_system/fluid_spread/smoke
	smoke_amt = 0

	/// A variable for holding the second selected target with right click.
	var/mob/living/second_target

/datum/action/cooldown/spell/pointed/swap/Destroy()
	second_target = null
	return ..()

/datum/action/cooldown/spell/pointed/swap/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(cast_on))
		to_chat(owner, span_warning(LANG("datum.5e952fb64d8aabfe", null)))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/swap/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!LAZYACCESS(params2list(params), RIGHT_CLICK))
		return ..()

	if(!IsAvailable(feedback = TRUE))
		return FALSE
	if(!target)
		return FALSE
	if(!isliving(target) || isturf(target))
		// Find any living being in the list. We aren't picky, it's aim assist after all
		target = locate(/mob/living) in target
		if(!target)
			to_chat(owner, span_warning(LANG("datum.326b711c5c7deb59", null)))
			return FALSE
	if(target == owner)
		if(!isnull(second_target))
			to_chat(owner, span_notice(LANG("datum.288da901187de221", null)))
			second_target = null
		else
			to_chat(owner, span_warning(LANG("datum.3ba115af77ee1139", null)))
		return FALSE
	second_target = target
	to_chat(owner, span_notice(LANG("datum.5c2c1d6444636d37", list(target.name))))
	return FALSE

/datum/action/cooldown/spell/pointed/swap/cast(mob/living/carbon/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(owner, span_warning(LANG("datum.2ce7047e239a5e7e", null)))
		to_chat(cast_on, span_warning(LANG("datum.a65c3a88bdd57a4f", null)))
		return FALSE

	to_chat(cast_on, span_userdanger(LANG("datum.6ee16896a35ceade", null)))
	if(ispath(smoke_type, /datum/effect_system/fluid_spread/smoke))
		do_smoke(smoke_amt, owner, get_turf(owner), smoke_type = smoke_type)

	var/turf/target_location = get_turf(cast_on)
	if(!isnull(second_target) && get_dist(owner, second_target) <= cast_range && !(cast_on == second_target))
		to_chat(second_target, span_userdanger(LANG("datum.6ee16896a35ceade", null)))
		if(ispath(smoke_type, /datum/effect_system/fluid_spread/smoke))
			do_smoke(smoke_amt, owner, get_turf(second_target))
		var/turf/second_location = get_turf(second_target)
		do_teleport(second_target, owner.loc, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		do_teleport(cast_on, second_location, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		do_teleport(owner, target_location, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		second_target.playsound_local(get_turf(second_target), 'sound/effects/magic/swap.ogg', 50, 1)
		cast_on.playsound_local(get_turf(cast_on), 'sound/effects/magic/swap.ogg', 50, 1)
		owner.playsound_local(get_turf(owner), 'sound/effects/magic/swap.ogg', 50, 1)
	else
		do_teleport(cast_on, owner.loc, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		do_teleport(owner, target_location, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		cast_on.playsound_local(get_turf(cast_on), 'sound/effects/magic/swap.ogg', 50, 1)
		owner.playsound_local(get_turf(owner), 'sound/effects/magic/swap.ogg', 50, 1)
	second_target = null
