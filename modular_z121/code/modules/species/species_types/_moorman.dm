/datum/species/moorman
	name = "\improper Moorman"
	id = SPECIES_MOORMAN

	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	skinned_type = /obj/item/stack/sheet/animalhide/moorman
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.0

	mutanttongue = /obj/item/organ/tongue/moorman
	mutantlungs = /obj/item/organ/lungs/moorman

	outfit_important_for_life = /datum/outfit/moorman

	bodypart_overrides = list(
	BODY_ZONE_HEAD = /obj/item/bodypart/head/moorman,
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/moorman,
	BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/moorman,
	BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/moorman,
	BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/moorman,
	BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/moorman,
	)

	bodytemp_heat_damage_limit = BODYTEMP_HEAT_DAMAGE_LIMIT + 30
	bodytemp_cold_damage_limit = BODYTEMP_COLD_DAMAGE_LIMIT - 10

/obj/item/organ/tongue/moorman
	liked_foodtypes = MEAT | RAW | ALCOHOL
	disliked_foodtypes = FRIED | JUNKFOOD | GROSS

//Moorman专属的突变肺
/obj/item/organ/lungs/moorman
	name = "高原肺"
	desc = "这双肺的主人生活在缺氧的恶劣环境，有着强大的呼吸能力。不过在富氧环境，会发生醉氧反应，肺的主人会因此陷入昏迷，最后死于氧中毒"
	safe_oxygen_max = 15
	safe_oxygen_min = 3
	safe_co2_max = 20
	safe_plasma_max = 1

	oxy_breath_dam_min = MIN_TOXIC_GAS_DAMAGE * 10
	oxy_breath_dam_max = MAX_TOXIC_GAS_DAMAGE * 10

	oxy_damage_type = TOX

	cold_level_1_threshold = 180
	cold_level_2_threshold = 100
	cold_level_3_threshold = 60

	heat_level_1_threshold = 420
	heat_level_2_threshold = 500
	heat_level_3_threshold = 1200

	//醉氧层数，超过最大可承受醉氧层数，角色会直接昏厥，并且造成伤害
	var/drunk_oxygen = 0
	//最大可承受醉氧层数，超过这个层数角色会昏迷
	var/drunk_oxygen_max = 5
	//警告层数，醉氧层数到达一定值就会在聊天框内警告
	var/warn = 0

//突变肺氧过量反应
/obj/item/organ/lungs/moorman/too_much_oxygen(mob/living/carbon/breather, datum/gas_mixture/breath, o2_pp, old_o2_pp)
	if(o2_pp <= safe_oxygen_max)
		if(old_o2_pp > safe_oxygen_max)
			return BREATH_LOST
		return

	if(!HAS_TRAIT(breather, TRAIT_ANOSMIA))
		breather.throw_alert(ALERT_TOO_MUCH_OXYGEN, /atom/movable/screen/alert/too_much_oxy)

	if(!(o2_pp > safe_oxygen_max))
		return

	drunk_oxygen += 1

	if(drunk_oxygen >= drunk_oxygen_max)
		breather.Unconscious(10 SECONDS)
		if(drunk_oxygen > drunk_oxygen_max)
			var/ratio = (breath.gases[/datum/gas/oxygen][MOLES] / safe_oxygen_max) * 10
			breather.apply_damage(clamp(ratio, oxy_breath_dam_min, oxy_breath_dam_max), oxy_damage_type, spread_damage = TRUE)

	else
		if(drunk_oxygen > drunk_oxygen_max * 0.25 && warn == 0)
			to_chat(breather, span_warning("你觉得自己有点迷糊"))
			warn = 1
			return
		if(drunk_oxygen > drunk_oxygen_max * 0.5 && warn == 1)
			to_chat(breather, span_boldwarning("你开始觉得自己昏昏欲睡…"))
			warn = 2
			return
		if(drunk_oxygen > drunk_oxygen_max * 0.75 && warn == 2)
			to_chat(breather, span_userdanger("你觉得自己快昏迷了………"))
			warn = 3
			return

/obj/item/organ/lungs/moorman/safe_oxygen(mob/living/carbon/breather, datum/gas_mixture/breath, old_o2_pp)
	. = ..()
	drunk_oxygen = 0
	warn = 0

/datum/species/moorman/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	give_important_for_life(equipping)

/datum/species/moorman/create_pref_temperature_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "running",
		SPECIES_PERK_NAME = "全身而进",
		SPECIES_PERK_DESC = "Moorman可以无视伤痛，全速前进！",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "fist-raised",
		SPECIES_PERK_NAME = "强壮",
		SPECIES_PERK_DESC = "Moorman有着强壮的双臂和双脚，拳击和踢踹能造成更大的外伤",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "fa-lungs",
		SPECIES_PERK_NAME = "突变肺",
		SPECIES_PERK_DESC = "Moorman有着特殊的突变肺，允许在氧气稀薄和寒冷的地方正常呼吸，注意！他们的肺在富氧地区会产生醉氧反应，如果长时间呼吸高纯度氧气会陷入昏迷，之后因为氧中毒而死！",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "skull-crossbones",
		SPECIES_PERK_NAME = "致死",
		SPECIES_PERK_DESC = "Moorman在受到致命伤会导致急性多器官衰竭，死亡速度几乎是一瞬间，抢救是不可能的！",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "bone",
		SPECIES_PERK_NAME = "四肢脆弱",
		SPECIES_PERK_DESC = "Moorman的四肢的肌肉组织比较特殊，容易被外力撕裂。顺带一提，他们很害怕被等离子切割机切成人棍",
	))

	return to_add

/datum/species/moorman/prepare_human_for_preview(mob/living/carbon/human/Moorman)
	var/base_color = "#C0C0C0"

	Moorman.dna.features["mcolor"] = base_color
	Moorman.set_haircolor("#333333", update = FALSE)
	Moorman.set_hairstyle("Ponytail (Fringe)", update = TRUE)
	Moorman.update_body(TRUE)

/datum/species/moorman/get_species_description()
	return "他们的故乡在与Lavalran十分相似的Wasteland星，\
	星球的残酷环境让他们进化出了将身体机能运作到极限的能力，以及粗糙且坚固的皮肤"

//种族初始化
/datum/species/moorman/on_species_gain(mob/living/carbon/human/new_Moorman, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	new_Moorman.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	RegisterSignal(new_Moorman, COMSIG_MOB_STATCHANGE , PROC_REF(stat_change))
	RegisterSignal(new_Moorman, COMSIG_MOVABLE_MOVED , PROC_REF(moving))

//移除信号
/datum/species/moorman/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_STATCHANGE)
	UnregisterSignal(C, COMSIG_MOVABLE_MOVED)
	C.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)

/datum/species/moorman/proc/stat_change(datum/source, new_stat, old_stat)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = source
	if(new_stat == SOFT_CRIT || new_stat == HARD_CRIT && old_stat != DEAD)
		H.death()

/datum/species/moorman/proc/moving(atom/movable/moved, atom/oldloc, direction, forced)
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

//开局自带装备
/datum/outfit/moorman
	r_hand = /obj/item/tank/internals/emergency_oxygen/moorman
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_HANDS

//moorman特有的低气压氧气瓶
/obj/item/tank/internals/emergency_oxygen/moorman
	name = "低压氧气瓶"
	desc = "一瓶气压被降低的氧气瓶，貌似是为某个种族准备的"
	icon = 'modular_z121/icons/obj/canisters.dmi'
	icon_state = "moorman_oxygen"
	distribute_pressure = 3

//特殊的GIB产物
/obj/item/stack/sheet/animalhide/moorman
	name = "moorman皮肤"
	desc = "一块粗糙且坚硬的皮肤"
	singular_name = "moorman皮肤块"
	icon = 'modular_z121/icons/obj/stack_objects.dmi'
	icon_state = "sheet-moorman"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/moorman

/obj/item/stack/sheet/animalhide/moorman/five
	amount = 5
