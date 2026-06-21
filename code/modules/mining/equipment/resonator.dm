/**********************Resonator**********************/

/obj/item/resonator
	name = "谐振器"
	icon = 'icons/obj/mining.dmi'
	icon_state = "resonator"
	inhand_icon_state = "resonator"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	desc = "一种手持式设备，能够产生微小的能量场，这些能量场相互共振直至爆炸，从而破碎岩石。在低压力环境下，其破坏力会增强。该设备有两种模式：自动触发模式和手动触发模式。"
	w_class = WEIGHT_CLASS_NORMAL
	force = 15
	throwforce = 10
	slot_flags = ITEM_SLOT_BELT

	/// the mode of the resonator; has three modes: auto (1), manual (2), and matrix (3)
	var/mode = RESONATOR_MODE_AUTO
	/// How efficient it is in manual mode. Yes, we lower the damage cuz it's gonna be used for mobhunt
	var/quick_burst_mod = 0.8
	/// the number of fields the resonator is allowed to have at once
	var/fieldlimit = 4
	/// the list of currently active fields from this resonator
	var/list/fields = list()
	/// the number that is added to the failure_prob, which is the probability of whether it will spread or not
	var/adding_failure = 50

/obj/item/resonator/attack_self(mob/user)
	if(mode == RESONATOR_MODE_AUTO)
		to_chat(user, span_info("你将谐振器的力场设置为仅在击中目标后引爆。"))
		mode = RESONATOR_MODE_MANUAL
	else
		to_chat(user, span_info("你将谐振器的力场设置为2秒后自动引爆。"))
		mode = RESONATOR_MODE_AUTO

/obj/item/resonator/proc/create_resonance(target, mob/user)
	var/turf/target_turf = get_turf(target)
	var/obj/effect/temp_visual/resonance/resonance_field = locate(/obj/effect/temp_visual/resonance) in target_turf
	if(resonance_field)
		resonance_field.damage_multiplier = quick_burst_mod
		resonance_field.burst()
		return
	if(LAZYLEN(fields) < fieldlimit)
		new /obj/effect/temp_visual/resonance(target_turf, user, src, mode, adding_failure)
		user.changeNext_move(CLICK_CD_MELEE)

/obj/item/resonator/pre_attack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(check_allowed_items(target, not_inside = TRUE))
		create_resonance(target, user)
	return ..()

//resonance field, crushes rock, damages mobs
/obj/effect/temp_visual/resonance
	name = "谐振场"
	desc = "一片谐振场，当谐振场破裂时会显著损坏内部的任何东西.在低压环境中更具破坏力."
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	duration = 60 SECONDS
	/// the amount of damage living beings will take whilst inside the field during its burst
	var/resonance_damage = 20
	/// the modifier to resonance_damage; affected by the quick_burst_mod from the resonator
	var/damage_multiplier = 1
	/// the parent creator (user) of this field
	var/mob/creator
	/// the parent resonator of this field
	var/obj/item/resonator/parent_resonator
	/// whether the field is rupturing currently or not (to prevent recursion)
	var/rupturing = FALSE
	/// the probability that the field will not be able to spread
	var/failure_prob = 0
	/// the number that is added to the failure_prob. Will default to 50
	var/adding_failure

/obj/effect/temp_visual/resonance/Initialize(mapload, set_creator, set_resonator, mode, set_failure = 50)
	if(mode == RESONATOR_MODE_AUTO)
		duration = 2 SECONDS
	if(mode == RESONATOR_MODE_MATRIX)
		icon_state = "shield2"
		name = "共振谐振场"
		RegisterSignal(src, COMSIG_ATOM_ENTERED, PROC_REF(burst))
		var/static/list/loc_connections = list(
			COMSIG_ATOM_ENTERED = PROC_REF(burst),
		)
		AddElement(/datum/element/connect_loc, loc_connections)
	. = ..()
	creator = set_creator
	parent_resonator = set_resonator
	if(parent_resonator)
		parent_resonator.fields += src
	adding_failure = set_failure
	playsound(src,'sound/items/weapons/resonator_fire.ogg',50,TRUE)
	if(mode == RESONATOR_MODE_AUTO)
		transform = matrix()*0.75
		animate(src, transform = matrix()*1.5, time = duration)
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, PROC_REF(burst)), duration, TIMER_STOPPABLE)

/obj/effect/temp_visual/resonance/Destroy()
	if(parent_resonator)
		parent_resonator.fields -= src
		parent_resonator = null
	creator = null
	. = ..()

/obj/effect/temp_visual/resonance/proc/check_pressure(turf/proj_turf)
	if(!proj_turf)
		proj_turf = get_turf(src)
	resonance_damage = initial(resonance_damage)
	if(lavaland_equipment_pressure_check(proj_turf))
		name = "强[initial(name)]"
		resonance_damage *= 3
	else
		name = initial(name)
	resonance_damage *= damage_multiplier

/obj/effect/temp_visual/resonance/proc/burst()
	SIGNAL_HANDLER
	if(rupturing)
		return
	rupturing = TRUE
	var/turf/src_turf = get_turf(src)
	new /obj/effect/temp_visual/resonance_crush(src_turf)
	if(ismineralturf(src_turf))
		var/turf/closed/mineral/mineral_turf = src_turf
		mineral_turf.gets_drilled(creator)
	check_pressure(src_turf)
	playsound(src_turf, 'sound/items/weapons/resonator_blast.ogg', 50, TRUE)
	for(var/mob/living/attacked_living in src_turf)
		if(creator)
			log_combat(creator, attacked_living, "used a resonator field on", "resonator")
			SEND_SIGNAL(creator, COMSIG_LIVING_RESONATOR_BURST, creator, attacked_living)
		to_chat(attacked_living, span_userdanger("[src] 在你身处其中时破裂了！"))
		attacked_living.apply_damage(resonance_damage, BRUTE)
		if(!QDELETED(attacked_living))
			attacked_living.add_movespeed_modifier(/datum/movespeed_modifier/resonance)
			addtimer(CALLBACK(attacked_living, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/resonance), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	for(var/obj/effect/temp_visual/resonance/field in orange(1, src))
		if(field.rupturing)
			continue
		field.burst()
	if(!prob(failure_prob) && parent_resonator)
		for(var/turf/closed/mineral/mineral_spread in orange(1, src))
			if(locate(/obj/effect/temp_visual/resonance) in mineral_spread)
				continue
			var/obj/effect/temp_visual/resonance/new_field = new(mineral_spread, creator, parent_resonator, parent_resonator.mode)
			new_field.failure_prob = failure_prob + adding_failure
	qdel(src)

/obj/effect/temp_visual/resonance_crush
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	duration = 4

/obj/effect/temp_visual/resonance_crush/Initialize(mapload)
	. = ..()
	transform = matrix() * 1.5
	animate(src, transform = matrix() * 0.1, alpha = 50, time = 4)

/obj/item/resonator/upgraded
	name = "高级谐振器"
	desc = "谐振器的升级版，每次可以产生更多的谐振场，并且不会因为提前引爆谐振场而受到伤害。它还能设置“谐振矩阵”，当有人(或某物)走过它时自行引爆."
	icon_state = "resonator_u"
	inhand_icon_state = "resonator_u"
	fieldlimit = 6
	quick_burst_mod = 1
	adding_failure = 30

/obj/item/resonator/upgraded/attack_self(mob/user)
	if(mode == RESONATOR_MODE_AUTO)
		to_chat(user, span_info("你将谐振器的力场设置为仅在击中目标后引爆。"))
		mode = RESONATOR_MODE_MANUAL
	else if(mode == RESONATOR_MODE_MANUAL)
		to_chat(user, span_info("你将谐振器的力场设置为矩阵陷阱模式。"))
		mode = RESONATOR_MODE_MATRIX
	else
		to_chat(user, span_info("你将谐振器的力场设置为2秒后自动引爆。"))
		mode = RESONATOR_MODE_AUTO
