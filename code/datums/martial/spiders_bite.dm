// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/martial_art/spiders_bite
	name = "Spider's Bite"
	id = MARTIALART_SPIDERSBITE
	help_verb = "Recall Teachings"
	grab_damage_modifier = 10
	grab_escape_chance_modifier = -20
	/// REF() to the last mob we kicked
	var/last_hit_ref
	/// Counts the number of sequential kicks the user has landed on a target
	var/last_hit_count = 0
	/// Reference to the tackling component applied
	var/datum/component/tackler/tackle_comp

/datum/martial_art/spiders_bite/activate_style(mob/living/new_holder)
	. = ..()
	RegisterSignal(new_holder, COMSIG_HUMAN_PUNCHED, PROC_REF(kick_disarm))
	tackle_comp = new_holder.AddComponent(/datum/component/tackler, \
		stamina_cost = 20, \
		base_knockdown = 0.2 SECONDS, \
		range = 5, \
		speed = 1.5, \
		skill_mod = 6, \
		min_distance = 1, \
		silent_gain = TRUE, \
	)

/datum/martial_art/spiders_bite/deactivate_style(mob/living/old_holder)
	. = ..()
	UnregisterSignal(old_holder, COMSIG_HUMAN_PUNCHED)
	QDEL_NULL(tackle_comp)

/datum/martial_art/spiders_bite/proc/kick_disarm(mob/living/source, mob/living/target, damage, attack_type, atk_effect, obj/item/bodypart/affecting, final_armor_block, limb_sharpness)
	SIGNAL_HANDLER

	if(atk_effect != ATTACK_EFFECT_KICK)
		last_hit_ref = null
		return
	var/new_hit_ref = REF(target)
	if(last_hit_ref == new_hit_ref)
		last_hit_count++
	else
		last_hit_count = 1
		last_hit_ref = new_hit_ref

	if(!prob(33 * last_hit_count))
		return

	var/obj/item/weapon = target.get_active_held_item()
	if(isnull(weapon) || !target.dropItemToGround(weapon))
		return
	source.visible_message(
		span_warning(LANG("datum.95d37bb3330c5a04", list(source, target, weapon.name, target.p_their()))),
		span_notice(LANG("datum.52361481e6577c51", list(target, weapon.name, target.p_their()))),
		span_hear(LANG("datum.1fd40cabf4548522", null)),
	)

/datum/martial_art/spiders_bite/get_prefered_attacking_limb(mob/living/martial_artist, mob/living/target)
	if(!target.has_status_effect(/datum/status_effect/staggered))
		return null

	return IS_LEFT_INDEX(martial_artist.active_hand_index) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG

/datum/martial_art/spiders_bite/get_style_help()
	. = list()

	. += span_info(LANG("datum.e213fc4910821760", null))
	return .
