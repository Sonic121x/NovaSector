/datum/species/Moorman
	name = "\improper Moorman"
	id = SPECIES_MOORMAN

	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	skinned_type = /obj/item/stack/sheet/animalhide/human
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.0

	mutanttongue = /obj/item/organ/tongue/moorman
	bodypart_overrides = list(
	BODY_ZONE_HEAD = /obj/item/bodypart/head/Moorman,
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/Moorman,
	BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/Moorman,
	BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/Moorman,
	BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/Moorman,
	BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/Moorman,
	)

/obj/item/organ/tongue/moorman
	liked_foodtypes = MEAT | RAW | ALCOHOL
	disliked_foodtypes = FRIED | JUNKFOOD | GROSS

/datum/species/Moorman/create_pref_temperature_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "running",
		SPECIES_PERK_NAME = "全身而进",
		SPECIES_PERK_DESC = "Moorman可以无视伤痛，全速前进",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "fist-raised",
		SPECIES_PERK_NAME = "双臂有力",
		SPECIES_PERK_DESC = "Moorman有着强壮的双臂和双脚，拳击和踢踹能造成更大的外伤",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "skull-crossbones",
		SPECIES_PERK_NAME = "心力衰竭",
		SPECIES_PERK_DESC = "Moorman受到足以濒死的伤害会直接死亡，没有抢救的机会",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "bone",
		SPECIES_PERK_NAME = "四肢脆弱",
		SPECIES_PERK_DESC = "Moorman的四肢的肌肉组织比较特殊，容易被外力撕裂",
	))

	return to_add

/datum/species/Moorman/prepare_human_for_preview(mob/living/carbon/human/Moorman)
	var/base_color = "#C0C0C0"

	Moorman.dna.features["mcolor"] = base_color
	Moorman.set_haircolor("#333333", update = FALSE)
	Moorman.set_hairstyle("Ponytail (Fringe)", update = TRUE)
	Moorman.update_body(TRUE)

/datum/species/Moorman/get_species_description()
	return "他们的故乡在与Lavalran十分相似的Wasteland星，\
	星球的残酷环境让他们进化出了将身体机能运作到极限的能力，以及粗糙且坚固的皮肤"

//种族初始化
/datum/species/Moorman/on_species_gain(mob/living/carbon/human/new_Moorman, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	new_Moorman.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	RegisterSignal(new_Moorman, COMSIG_MOB_STATCHANGE , PROC_REF(stat_change))
	RegisterSignal(new_Moorman, COMSIG_MOVABLE_MOVED , PROC_REF(moving))

//移除信号
datum/species/Moorman/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_STATCHANGE)
	UnregisterSignal(C, COMSIG_MOVABLE_MOVED)
	C.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

datum/species/Moorman/proc/stat_change(datum/source, new_stat, old_stat)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = source
	if(new_stat == SOFT_CRIT || new_stat == HARD_CRIT && old_stat != DEAD)
		H.death()

datum/species/Moorman/proc/moving(atom/movable/moved, atom/oldloc, direction, forced)
	SIGNAL_HANDLER
	//是否用双腿走路
	if(forced || CHECK_MOVE_LOOP_FLAGS(moved, MOVEMENT_LOOP_OUTSIDE_CONTROL))
		return
	if(isliving(moved))
		var/mob/living/living_moved = moved
		if (living_moved.incapacitated || (living_moved.body_position == LYING_DOWN && !HAS_TRAIT(living_moved, TRAIT_FLOPPING)))
			return
		//是否处于重伤状态
		if(living_moved.maxHealth - living_moved.health > 40)
			// 获取腿部器官
			var/obj/item/bodypart/left_leg = living_moved.get_bodypart(BODY_ZONE_L_LEG)
			var/obj/item/bodypart/right_leg = living_moved.get_bodypart(BODY_ZONE_R_LEG)

			//左腿损伤
			if(left_leg && (left_leg.limb_id != SPECIES_MOORMAN))
				left_leg.receive_damage(
					brute = 1,
					wound_bonus = CANT_WOUND,
				)

			//右腿损伤
			if(right_leg && (right_leg.limb_id != SPECIES_MOORMAN))
				right_leg.receive_damage(
					brute = 1,
					wound_bonus = CANT_WOUND,
				)
