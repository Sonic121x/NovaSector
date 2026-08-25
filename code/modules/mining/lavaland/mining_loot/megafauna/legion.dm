// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Staff of storms

/obj/item/storm_staff
	name = "staff of storms"
	desc = "An ancient staff retrieved from the remains of Legion. The wind stirs as you move it."
	icon_state = "staffofstorms"
	inhand_icon_state = "staffofstorms"
	icon_angle = -45
	icon = 'icons/obj/weapons/guns/magic.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	force = 20
	damtype = BURN
	hitsound = 'sound/items/weapons/taserhit.ogg'
	wound_bonus = -30
	exposed_wound_bonus = 20
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/max_thunder_charges = 3
	var/thunder_charges = 3
	var/thunder_charge_time = 15 SECONDS
	var/static/list/excluded_areas = list(/area/space)
	var/list/targeted_turfs = list()

/obj/item/storm_staff/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.9cdb11b8193784a4", list(thunder_charges)))
	. += span_notice(LANG("obj.b6f677dce22d4402", null))
	. += span_notice(LANG("obj.6ea731f408c3dbe5", null))
	. += span_notice(LANG("obj.7a43f62eee2a1c35", null))

/obj/item/storm_staff/attack_self(mob/user)
	var/area/user_area = get_area(user)
	var/turf/user_turf = get_turf(user)
	if(!user_area || !user_turf || (is_type_in_list(user_area, excluded_areas)))
		to_chat(user, span_warning(LANG("obj.712f1a8ed8142563", null)))
		return
	var/datum/weather/affected_weather
	for(var/datum/weather/weather as anything in SSweather.processing)
		if((user_turf.z in weather.impacted_z_levels) && ispath(user_area.type, weather.area_type))
			affected_weather = weather
			break
	if(!affected_weather)
		return
	if(affected_weather.stage == END_STAGE)
		balloon_alert(user, LANG("obj.f4f6871c5fe3f2f3", null))
		return
	if(affected_weather.stage == WIND_DOWN_STAGE)
		balloon_alert(user, LANG("obj.ebeb3a9df70aef89", null))
		return
	balloon_alert(user, LANG("obj.17c6b8a93d2b9e7b", null))
	if(!do_after(user, 3 SECONDS, target = src))
		balloon_alert(user, LANG("obj.c67b5d274d6e724b", null))
		return
	user.visible_message(span_warning(LANG("obj.db79c540b0033f2a", list(user, src))), \
	span_notice(LANG("obj.ef573bb422b94bde", list(src))))
	playsound(user, 'sound/effects/magic/staff_change.ogg', 200, FALSE)
	var/old_color = user.color
	user.color = list(340/255, 240/255, 0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	var/old_transform = user.transform
	user.transform *= 1.2
	animate(user, color = old_color, transform = old_transform, time = 1 SECONDS)
	affected_weather.wind_down()
	user.log_message("has dispelled a storm at [AREACOORD(user_turf)].", LOG_GAME)

/obj/item/storm_staff/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return thunder_blast(interacting_with, user) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

/obj/item/storm_staff/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	thunder_blast(target, user)

/obj/item/storm_staff/proc/thunder_blast(atom/target, mob/user)
	if(!thunder_charges)
		balloon_alert(user, LANG("obj.9437a7cf4ae0b95e", null))
		return FALSE
	var/turf/target_turf = get_turf(target)
	var/area/target_area = get_area(target)
	if(!target_turf || !target_area || (is_type_in_list(target_area, excluded_areas)))
		balloon_alert(user, LANG("obj.5f68120e23d6e3c1", null))
		return FALSE
	if(target_turf in targeted_turfs)
		balloon_alert(user, LANG("obj.e1360a7870d1d181", null))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		balloon_alert(user, LANG("obj.582b950b2360865e", null))
		return FALSE
	var/power_boosted = FALSE
	for(var/datum/weather/weather as anything in SSweather.processing)
		if(weather.stage != MAIN_STAGE)
			continue
		if((target_turf.z in weather.impacted_z_levels) && ispath(target_area.type, weather.area_type))
			power_boosted = TRUE
			break
	playsound(src, 'sound/effects/magic/lightningshock.ogg', 10, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	targeted_turfs += target_turf
	balloon_alert(user, LANG("obj.16d662a08fa31ac9", list(target_turf)))
	new /obj/effect/temp_visual/telegraphing/circle(target_turf)
	addtimer(CALLBACK(src, PROC_REF(throw_thunderbolt), target_turf, power_boosted), 1.5 SECONDS)
	thunder_charges--
	addtimer(CALLBACK(src, PROC_REF(recharge)), thunder_charge_time)
	user.log_message("fired the staff of storms at [AREACOORD(target_turf)].", LOG_ATTACK)
	return TRUE

/obj/item/storm_staff/proc/recharge(mob/user)
	thunder_charges = min(thunder_charges + 1, max_thunder_charges)
	playsound(src, 'sound/effects/magic/charge.ogg', 10, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)

/obj/item/storm_staff/proc/throw_thunderbolt(turf/target, boosted)
	targeted_turfs -= target
	new /obj/effect/temp_visual/thunderbolt(target)
	var/list/affected_turfs = list(target)
	if(boosted)
		for(var/direction in GLOB.alldirs)
			var/turf_to_add = get_step(target, direction)
			if(!turf_to_add)
				continue
			affected_turfs += turf_to_add
	for(var/turf/turf as anything in affected_turfs)
		new /obj/effect/temp_visual/electricity(turf)
		for(var/mob/living/hit_mob in turf)
			to_chat(hit_mob, span_userdanger(LANG("obj.d028d146d6fe3e90", null)))
			hit_mob.electrocute_act(15 * (isanimal_or_basicmob(hit_mob) ? 3 : 1) * (turf == target ? 2 : 1) * (boosted ? 2 : 1), src, flags = SHOCK_TESLA|SHOCK_NOSTUN)

		for(var/obj/hit_thing in turf)
			hit_thing.take_damage(20, BURN, ENERGY, FALSE)
	playsound(target, 'sound/effects/magic/lightningbolt.ogg', 100, TRUE)
	target.visible_message(span_danger(LANG("obj.5fc332ba91a2092b", list(target))))
	explosion(target, light_impact_range = (boosted ? 1 : 0), flame_range = (boosted ? 2 : 1), silent = TRUE)
