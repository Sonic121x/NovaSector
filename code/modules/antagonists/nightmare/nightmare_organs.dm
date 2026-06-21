/// How many life ticks are required for the nightmare's heart to revive the nightmare.
#define HEART_RESPAWN_THRESHHOLD (80 SECONDS)
/// A special flag value used to make a nightmare heart not grant a light eater. Appears to be unused.
#define HEART_SPECIAL_SHADOWIFY 2

/obj/item/organ/brain/shadow/nightmare
	name = "肿瘤块"
	desc = "从噩梦的头骨中挖出的肉质生长物。"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "brain-x-d"
	shade_color = "black, somehow"

	///Our associated shadow jaunt spell, for all nightmares
	var/datum/action/cooldown/spell/jaunt/shadow_walk/our_jaunt
	///Our associated terrorize spell, for antagonist nightmares
	var/datum/action/cooldown/spell/pointed/terrorize/terrorize_spell

/obj/item/organ/brain/shadow/nightmare/on_mob_insert(mob/living/carbon/brain_owner)
	. = ..()

	if(brain_owner.dna.species.id != SPECIES_NIGHTMARE)
		brain_owner.set_species(/datum/species/shadow/nightmare, replace_missing = FALSE)
		visible_message(span_warning("[brain_owner] thrashes as [src] takes root in [brain_owner.p_their()] body!"))

	our_jaunt = new(brain_owner)
	our_jaunt.Grant(brain_owner)

	if(brain_owner.mind?.has_antag_datum(/datum/antagonist/nightmare)) //Only a TRUE NIGHTMARE is worthy of using this ability
		terrorize_spell = new(src)
		terrorize_spell.Grant(brain_owner)

/obj/item/organ/brain/shadow/nightmare/on_mob_remove(mob/living/carbon/brain_owner)
	. = ..()
	QDEL_NULL(our_jaunt)
	QDEL_NULL(terrorize_spell)

/obj/item/organ/brain/shadow/nightmare/on_life(seconds_per_tick)
	. = ..()

	var/turf/owner_turf = owner.loc
	if(!isturf(owner_turf))
		return
	var/light_amount = owner_turf.get_lumcount()

	if (light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD) //dodge in the dark
		owner.apply_status_effect(/datum/status_effect/shadow/nightmare)

/datum/status_effect/shadow/nightmare
	id = "nightmare"
	alert_type = /atom/movable/screen/alert/status_effect/shadow_regeneration/nightmare

/datum/status_effect/shadow/nightmare/on_apply()
	. = ..()
	if (!.)
		return FALSE
	RegisterSignal(owner, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(dodge_bullets))
	return TRUE

/datum/status_effect/shadow/nightmare/on_remove()
	UnregisterSignal(owner, COMSIG_ATOM_PRE_BULLET_ACT)
	return ..()

/datum/status_effect/shadow/nightmare/proc/dodge_bullets(mob/living/carbon/human/source, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER
	source.visible_message(
		span_danger("[source] dances in the shadows, evading [hitting_projectile]!"),
		span_danger("你利用黑暗的掩护躲开了 [hitting_projectile]！"),
	)
	playsound(source, SFX_BULLET_MISS, 75, TRUE)
	return COMPONENT_BULLET_PIERCED

/atom/movable/screen/alert/status_effect/shadow_regeneration/nightmare
	name = "无光领域"
	desc = "Bathed in soothing darkness you will slowly regenerate, even past the point of death. \
		Heightened reflexes will allow you to dodge projectile weapons."

/obj/item/organ/heart/nightmare
	name = "黑暗之心"
	desc = "一个异形器官。当受到光照时，它会扭曲蠕动。"
	visual = TRUE
	icon = 'icons/obj/medical/organs/shadow_organs.dmi'
	icon_state = "dark_heart-on"
	base_icon_state = "dark_heart"

	beat_noise = "the writhing pulses of a fear given form" // evil schmeevil
	decay_factor = 0
	// No love is to be found in a heart so twisted.
	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)
	// In case you want to drink light as well as eat it
	organ_traits = list(TRAIT_LIGHT_DRINKER)
	/// How many life ticks in the dark the owner has been dead for. Used for nightmare respawns.
	var/respawn_progress = 0
	/// The armblade granted to the host of this heart.
	var/obj/item/light_eater/blade

/obj/item/organ/heart/nightmare/Destroy()
	QDEL_NULL(blade)
	return ..()

/obj/item/organ/heart/nightmare/attack(mob/M, mob/living/carbon/user, obj/target)
	if(M != user)
		return ..()
	user.visible_message(
		span_warning("[user] 将 [src] 举到 [user.p_their()] 嘴边，用 [user.p_their()] 牙齿撕咬它！"),
		span_danger("[src] 在你手中感觉异常冰冷。你将 [src] 举到嘴边并吞噬了它！")
	)
	playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)

	user.visible_message(
		span_warning("鲜血从 [user] 的手臂喷涌而出，它重塑成了一件武器！"),
		span_userdanger("冰冷的血液在你血管中奔涌，你的手臂正在重塑！")
	)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)

/obj/item/organ/heart/nightmare/on_mob_insert(mob/living/carbon/heart_owner, special, movement_flags)
	. = ..()
	if(special == HEART_SPECIAL_SHADOWIFY)
		return
	blade = new /obj/item/light_eater
	heart_owner.put_in_hands(blade)
	RegisterSignal(blade, COMSIG_QDELETING, PROC_REF(on_blade_deleted))

/obj/item/organ/heart/nightmare/on_mob_remove(mob/living/carbon/heart_owner, special, movement_flags)
	. = ..()
	respawn_progress = 0
	if(blade && special != HEART_SPECIAL_SHADOWIFY)
		heart_owner.visible_message(span_warning("\The [blade] 瓦解了！"))
		QDEL_NULL(blade)

/obj/item/organ/heart/nightmare/Stop()
	return FALSE

// Happens if the blade was deleted before we were during mob destruction
/obj/item/organ/heart/nightmare/proc/on_blade_deleted(datum/source)
	SIGNAL_HANDLER
	blade = null

/obj/item/organ/heart/nightmare/on_death(seconds_per_tick)
	if(!owner)
		return
	var/turf/T = get_turf(owner)
	if(istype(T))
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			respawn_progress += seconds_per_tick SECONDS
			playsound(owner, 'sound/effects/singlebeat.ogg', 40, TRUE)
	if(respawn_progress < HEART_RESPAWN_THRESHHOLD)
		return

	owner.revive(HEAL_ALL & ~HEAL_REFRESH_ORGANS)
	if(!(owner.dna.species.id == SPECIES_SHADOW || owner.dna.species.id == SPECIES_NIGHTMARE))
		var/mob/living/carbon/old_owner = owner
		Remove(owner, HEART_SPECIAL_SHADOWIFY)
		old_owner.set_species(/datum/species/shadow)
		Insert(old_owner, HEART_SPECIAL_SHADOWIFY)
		to_chat(owner, span_userdanger("你感到阴影侵入你的皮肤，跃入你的胸膛中央！你活过来了！"))
		SEND_SOUND(owner, sound('sound/effects/ghost.ogg'))
	owner.visible_message(span_warning("[owner] 摇摇晃晃地站[owner.p_their()]起来！"))
	playsound(owner, 'sound/effects/hallucinations/far_noise.ogg', 50, TRUE)
	respawn_progress = 0

/obj/item/organ/heart/nightmare/get_availability(datum/species/owner_species, mob/living/owner_mob)
	if(isnightmare(owner_mob))
		return TRUE
	return ..()

#undef HEART_SPECIAL_SHADOWIFY
#undef HEART_RESPAWN_THRESHHOLD
