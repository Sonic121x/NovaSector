//Nearsightedness restricts your vision by several tiles.
/datum/mutation/nearsight
	name = "近视"
	desc = "此突变的持有者视力不佳。"
	instability = NEGATIVE_STABILITY_MODERATE
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("你看不太清楚。")

/datum/mutation/nearsight/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	owner.become_nearsighted(GENETIC_MUTATION)

/datum/mutation/nearsight/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_nearsighted(GENETIC_MUTATION)

///Blind makes you blind. Who knew?
/datum/mutation/blind
	name = "失明"
	desc = "使受试者完全失明。"
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = span_danger("你似乎什么都看不见了。")

/datum/mutation/blind/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	owner.become_blind(GENETIC_MUTATION)

/datum/mutation/blind/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_blind(GENETIC_MUTATION)

///Thermal Vision lets you see mobs through walls
/datum/mutation/thermal
	name = "热视觉"
	desc = "此基因组的用户能够视觉感知到独特的人类热信号。"
	quality = POSITIVE
	difficulty = 18
	text_gain_indication = span_notice("你能看到热量从皮肤上升起……")
	text_lose_indication = span_notice("你再也看不到热量从皮肤上升起了……")
	instability = POSITIVE_INSTABILITY_MAJOR // thermals aren't station equipment
	synchronizer_coeff = 1
	power_coeff = 1
	energy_coeff = 1
	power_path = /datum/action/cooldown/spell/thermal_vision

/datum/mutation/thermal/on_losing(mob/living/carbon/human/owner)
	if(..())
		return

	// Something went wront and we still have the thermal vision from our power, no cheating.
	if(HAS_TRAIT_FROM(owner, TRAIT_THERMAL_VISION, GENETIC_MUTATION))
		REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
		owner.update_sight()

/datum/mutation/thermal/setup()
	. = ..()
	var/datum/action/cooldown/spell/thermal_vision/to_modify = .
	if(!istype(to_modify)) // null or invalid
		return

	to_modify.eye_damage = /datum/action/cooldown/spell/thermal_vision::eye_damage * GET_MUTATION_SYNCHRONIZER(src) * GET_MUTATION_POWER(src)
	to_modify.thermal_duration = /datum/action/cooldown/spell/thermal_vision::thermal_duration * GET_MUTATION_POWER(src)

/datum/action/cooldown/spell/thermal_vision
	name = "激活热视觉"
	desc = "你可以看到热信号，但代价是你的视力。"
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "augmented_eyesight"

	cooldown_time = 60 SECONDS
	spell_requirements = NONE

	/// How much eye damage is given on cast
	var/eye_damage = 7.5
	/// The duration of the thermal vision
	var/thermal_duration = 30 SECONDS

/datum/action/cooldown/spell/thermal_vision/Remove(mob/living/remove_from)
	REMOVE_TRAIT(remove_from, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
	remove_from.update_sight()
	return ..()

/datum/action/cooldown/spell/thermal_vision/is_valid_target(atom/cast_on)
	return isliving(cast_on) && !HAS_TRAIT(cast_on, TRAIT_THERMAL_VISION)

/datum/action/cooldown/spell/thermal_vision/cast(mob/living/cast_on)
	. = ..()
	ADD_TRAIT(cast_on, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
	cast_on.update_sight()
	to_chat(cast_on, span_info("你集中精神凝视，视野中充满了热信号。"))
	addtimer(CALLBACK(src, PROC_REF(deactivate), cast_on), thermal_duration)

/datum/action/cooldown/spell/thermal_vision/proc/deactivate(mob/living/cast_on)
	if(QDELETED(cast_on) || !HAS_TRAIT_FROM(cast_on, TRAIT_THERMAL_VISION, GENETIC_MUTATION))
		return

	REMOVE_TRAIT(cast_on, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
	cast_on.update_sight()
	to_chat(cast_on, span_info("你眨了眨眼，视力恢复正常，眼中传来一阵钝痛。"))

	if(iscarbon(cast_on))
		var/mob/living/carbon/carbon_cast_on = cast_on
		carbon_cast_on.adjust_organ_loss(ORGAN_SLOT_EYES, eye_damage)

///X-ray Vision lets you see through walls.
/datum/mutation/xray
	name = "X射线视觉"
	desc = "一种奇怪的基因组，允许用户看穿墙壁之间的空隙。" //actual x-ray would mean you'd constantly be blasting rads, which might be fun for later //hmb
	text_gain_indication = span_notice("墙壁突然消失了！")
	instability = POSITIVE_INSTABILITY_MAJOR
	locked = TRUE

/datum/mutation/xray/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_XRAY_VISION, GENETIC_MUTATION)
	owner.update_sight()

/datum/mutation/xray/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_XRAY_VISION, GENETIC_MUTATION)
	owner.update_sight()


///Laser Eyes lets you shoot lasers from your eyes!
/datum/mutation/laser_eyes
	name = "激光眼"
	desc = "将汇聚的光线从眼中反射回去。"
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = span_notice("你感到眼球后方有压力在积聚。")
	layer_used = FRONT_MUTATIONS_LAYER
	limb_req = BODY_ZONE_HEAD

/datum/mutation/laser_eyes/New(datum/mutation/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', "lasereyes", -FRONT_MUTATIONS_LAYER))

/datum/mutation/laser_eyes/on_acquiring(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	RegisterSignal(H, COMSIG_MOB_ATTACK_RANGED, PROC_REF(on_ranged_attack))

/datum/mutation/laser_eyes/on_losing(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	UnregisterSignal(H, COMSIG_MOB_ATTACK_RANGED)

/datum/mutation/laser_eyes/get_visual_indicator()
	return visual_indicators[type][1]

///Triggers on COMSIG_MOB_ATTACK_RANGED. Does the projectile shooting.
/datum/mutation/laser_eyes/proc/on_ranged_attack(mob/living/carbon/human/source, atom/target, modifiers)
	SIGNAL_HANDLER

	if(!source.combat_mode)
		return
	to_chat(source, span_warning("你用激光眼射击！"))
	source.changeNext_move(CLICK_CD_RANGE)
	source.newtonian_move(get_angle(source, target))
	var/obj/projectile/beam/laser/laser_eyes/LE = new(source.loc)
	LE.firer = source
	LE.def_zone = ran_zone(source.zone_selected)
	LE.aim_projectile(target, source, modifiers)
	INVOKE_ASYNC(LE, TYPE_PROC_REF(/obj/projectile, fire))
	playsound(source, 'sound/items/weapons/taser2.ogg', 75, TRUE)

///Projectile type used by laser eyes
/obj/projectile/beam/laser/laser_eyes
	name = "光束"
	icon = 'icons/mob/effects/genetics.dmi'
	icon_state = "eyelasers"

/datum/mutation/illiterate
	name = "文盲"
	desc = "导致严重的失语症，使人无法读写。"
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = span_danger("你感到无法阅读或书写。")
	text_lose_indication = span_danger("你感到又能阅读和书写了。")

/datum/mutation/illiterate/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_ILLITERATE, GENETIC_MUTATION)

/datum/mutation/illiterate/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_ILLITERATE, GENETIC_MUTATION)
