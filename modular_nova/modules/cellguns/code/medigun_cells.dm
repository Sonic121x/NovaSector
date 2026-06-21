#define UPGRADED_MEDICELL_PASSFLAGS PASSTABLE | PASSGLASS | PASSGRILLE
#define MINIMUM_TEMP_DIFFERENCE 25
#define TEMP_PER_SHOT 30

/obj/item/ammo_casing/energy/medical
	projectile_type = /obj/projectile/energy/medical/oxygen
	select_name = "oxygen"
	fire_sound = 'sound/effects/stealthoff.ogg'
	e_cost = LASER_SHOTS(8, STANDARD_CELL_CHARGE)
	delay = 8
	harmful = FALSE
	select_color = "#00d9ffff"

/obj/projectile/energy/medical
	name = "医疗治疗射线"
	icon_state = "blue_laser"
	damage = 0
	var/healing_threshold = 20
	var/base_disgust = 1

/*
*	PROCS
*/

/// Applies additional digust based on how much nutrition they're missing under certain thresholds, increasingly multiplying it each stage beyond hungry they are.
/obj/projectile/energy/medical/proc/nutrition_disgust(mob/living/target, base_disgust)
	if(target.nutrition < NUTRITION_LEVEL_STARVING)
		target.adjust_disgust(base_disgust * 4)
	else if(target.nutrition >= NUTRITION_LEVEL_STARVING && target.nutrition <= NUTRITION_LEVEL_VERY_HUNGRY)
		target.adjust_disgust(base_disgust * 3)
	else if(target.nutrition > NUTRITION_LEVEL_VERY_HUNGRY && target.nutrition < NUTRITION_LEVEL_HUNGRY)
		target.adjust_disgust(base_disgust * 2)
	else
		return

/// Checks to see if the patient is living and organic.
/obj/projectile/energy/medical/proc/is_living_human(mob/living/target)
	if(!istype(target, /mob/living/carbon/human))
		return FALSE
	if(issynthetic(target))
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	else
		return TRUE

/// Checks for non-medicine reagents in the bloodstream, used for the toxin medicell.
/obj/projectile/energy/medical/proc/check_reagents(mob/living/target)
	var/non_medicine_chems = 0 //Keeps track of how many chemicals in the bloodstream aren't medicine.

	for(var/reagent in target.reagents.reagent_list)
		if(istype(reagent, /datum/reagent/medicine))
			continue
		non_medicine_chems += 1

	return non_medicine_chems

/// Heals Oxygen with no threshold, make them gain disgust.
/obj/projectile/energy/medical/proc/heal_oxy(mob/living/target, amount_healed, base_disgust, healing_threshold)
	if(!is_living_human(target))
		return FALSE

	target.adjust_disgust(base_disgust)
	nutrition_disgust(target, base_disgust)
	target.adjust_nutrition(base_disgust * -2)
	target.adjust_oxy_loss(-amount_healed)

/// Heals Brute if it's at the threshold or less, make them gain disgust.
/obj/projectile/energy/medical/proc/heal_brute(mob/living/target, amount_healed, base_disgust, healing_threshold)
	if(!is_living_human(target))
		return FALSE

	if(target.get_brute_loss() > healing_threshold)
		return FALSE

	target.adjust_disgust(base_disgust)
	nutrition_disgust(target, base_disgust)
	target.adjust_nutrition(base_disgust * -2)
	target.adjust_brute_loss(-amount_healed)

/// Heals Burn if it's at the threshold or less, make them gain disgust.
/obj/projectile/energy/medical/proc/heal_burn(mob/living/target, amount_healed, base_disgust, healing_threshold)
	if(!is_living_human(target))
		return FALSE

	if(target.get_fire_loss() > healing_threshold)
		return FALSE

	target.adjust_disgust(base_disgust)
	nutrition_disgust(target, base_disgust)
	target.adjust_nutrition(base_disgust * -2)
	target.adjust_fire_loss(-amount_healed)

/// Heals Toxins if it's at the threshold or less, make them gain disgust.
/obj/projectile/energy/medical/proc/heal_tox(mob/living/target, amount_healed, base_disgust, healing_threshold)
	if(!is_living_human(target))
		return FALSE

	if(target.get_tox_loss() > healing_threshold)
		return FALSE

	var/healing_multiplier = 1.5
	var/non_meds = check_reagents(target)
	healing_multiplier = healing_multiplier - (non_meds / 4)

	if(healing_multiplier < 0.25)
		healing_multiplier = 0.25

	target.adjust_disgust(base_disgust)
	nutrition_disgust(target, base_disgust)
	target.adjust_nutrition(base_disgust * -2)
	target.adjust_tox_loss(-(amount_healed * healing_multiplier))

/*
*	HEALING PROJECTILES
*/

/*
*	TIER ONE
*/

//Basic Brute Heal Projectile
/obj/item/ammo_casing/energy/medical/brute1
	projectile_type = /obj/projectile/energy/medical/brute
	select_name = "brute"
	select_color = "#ff0000ff"

/obj/projectile/energy/medical/brute
	name = "创伤治疗射线"
	icon_state = "red_laser"
	var/amount_healed = 7.5

/obj/projectile/energy/medical/brute/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	heal_brute(target, amount_healed, base_disgust, healing_threshold)

//Basic Burn Heal Projectile
/obj/item/ammo_casing/energy/medical/burn1
	projectile_type = /obj/projectile/energy/medical/burn
	select_name = "burn"
	select_color = "#ffae00ff"

/obj/projectile/energy/medical/burn
	name = "烧伤治疗射线"
	icon_state = "yellow_laser"
	var/amount_healed = 7.5

/obj/projectile/energy/medical/burn/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	heal_burn(target, amount_healed, base_disgust, healing_threshold)

//Basic Oxygen Heal Projectile. Doesn't get a casing because the base medical projectile is already oxygen.
/obj/projectile/energy/medical/oxygen
	name = "氧气治疗射线"
	var/amount_healed = 10

/obj/projectile/energy/medical/oxygen/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	heal_oxy(target, amount_healed, base_disgust)

//Basic Toxin Heal Projectile
/obj/item/ammo_casing/energy/medical/toxin1
	projectile_type = /obj/projectile/energy/medical/toxin
	select_name = "toxin"
	select_color = "#15ff00ff"

/obj/projectile/energy/medical/toxin
	name = "毒素治疗射线"
	icon_state = "green_laser"
	var/amount_healed = 5

/obj/projectile/energy/medical/toxin/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	heal_tox(target, amount_healed, base_disgust, healing_threshold)

/*
*	TIER TWO
*/

//Tier II Brute Projectile
/obj/item/ammo_casing/energy/medical/brute2
	projectile_type = /obj/projectile/energy/medical/brute/better
	select_name = "brute II"
	select_color = "#ff0000ff"

/obj/projectile/energy/medical/brute/better
	name = "强力创伤治疗射线"
	pass_flags =  UPGRADED_MEDICELL_PASSFLAGS
	amount_healed = 11.25
	base_disgust = 2
	healing_threshold = 30

//Tier II Burn Projectile
/obj/item/ammo_casing/energy/medical/burn2
	projectile_type = /obj/projectile/energy/medical/burn/better
	select_name = "burn II"
	select_color = "#ffae00ff"

/obj/projectile/energy/medical/burn/better
	name = "强力烧伤治疗射线"
	pass_flags =  UPGRADED_MEDICELL_PASSFLAGS
	amount_healed = 11.25
	base_disgust = 2
	healing_threshold = 30

//Tier II Oxygen Projectile
/obj/item/ammo_casing/energy/medical/oxy2
	projectile_type = /obj/projectile/energy/medical/oxygen/better
	select_name = "oxygen II"
	select_color = "#00d9ffff"

/obj/projectile/energy/medical/oxygen/better
	name = "强力氧气治疗射线"
	pass_flags =  UPGRADED_MEDICELL_PASSFLAGS
	amount_healed = 20
	base_disgust = 2

//Tier II Toxin Projectile
/obj/item/ammo_casing/energy/medical/toxin2
	projectile_type = /obj/projectile/energy/medical/toxin/better
	select_name = "toxin II"
	select_color = "#15ff00ff"

/obj/projectile/energy/medical/toxin/better
	name = "强力毒素治疗射线"
	pass_flags =  UPGRADED_MEDICELL_PASSFLAGS
	amount_healed = 7.5
	base_disgust = 2
	healing_threshold = 30

/*
*	TIER THREE
*/

//Tier III Brute Projectile
/obj/item/ammo_casing/energy/medical/brute3
	projectile_type = /obj/projectile/energy/medical/brute/better/best
	select_name = "brute III"
	select_color = "#ff0000ff"

/obj/projectile/energy/medical/brute/better/best
	name = "高效创伤治疗射线"
	amount_healed = 15
	base_disgust = 3
	healing_threshold = 40

//Tier III Burn Projectile
/obj/item/ammo_casing/energy/medical/burn3
	projectile_type = /obj/projectile/energy/medical/burn/better/best
	select_name = "burn III"
	select_color = "#ffae00ff"

/obj/projectile/energy/medical/burn/better/best
	name = "高效烧伤治疗射线"
	amount_healed = 15
	base_disgust = 3
	healing_threshold = 40

//Tier III Oxygen Projectile
/obj/item/ammo_casing/energy/medical/oxy3
	projectile_type = /obj/projectile/energy/medical/oxygen/better/best
	select_name = "oxygen III"
	select_color = "#00d9ffff"

/obj/projectile/energy/medical/oxygen/better/best
	name = "高效氧气治疗射线"
	amount_healed = 30
	base_disgust = 3

//Tier III Toxin Projectile
/obj/item/ammo_casing/energy/medical/toxin3
	projectile_type = /obj/projectile/energy/medical/toxin/better/best
	select_name = "toxin III"
	select_color = "#15ff00ff"

/obj/projectile/energy/medical/toxin/better/best
	name = "高效毒素治疗射线"
	amount_healed = 10
	base_disgust = 3
	healing_threshold = 40

/*
*	UTILITY CELLS
*/

//Utility basis
/obj/projectile/energy/medical/utility
	name = "医疗功能射线"
	pass_flags =  UPGRADED_MEDICELL_PASSFLAGS

//Clotting
/obj/item/ammo_casing/energy/medical/utility/clotting
	projectile_type = /obj/projectile/energy/medical/utility/clotting
	select_name = "clotting"
	select_color = "#ff00eaff"

/obj/projectile/energy/medical/utility/clotting
	name = "凝血剂射线"

/obj/projectile/energy/medical/utility/clotting/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	if(!is_living_human(target))
		return FALSE

	if(target.reagents.get_reagent_amount(/datum/reagent/medicine/coagulant/fabricated) < 5) //injects the target with a weaker coagulant agent
		target.reagents.add_reagent(/datum/reagent/medicine/coagulant/fabricated, 1)
		target.reagents.add_reagent(/datum/reagent/iron, 2) //adds in iron to help compensate for the relatively weak blood clotting
	else
		return

//Temprature Adjustment
/obj/item/ammo_casing/energy/medical/utility/temperature
	projectile_type = /obj/projectile/energy/medical/utility/temperature
	select_name = "temperature"
	select_color = "#fbff00ff"

/obj/projectile/energy/medical/utility/temperature
	name = "温度调节射线"

/obj/projectile/energy/medical/utility/temperature/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	if(!is_living_human(target))
		return FALSE

	var/ideal_temp = target.get_body_temp_normal(apply_change=FALSE) //Gets the temperature we should be aiming for.
	var/current_temp = target.bodytemperature //Retrieves the targets body temperature
	var/difference = ideal_temp - current_temp

	if(abs(difference) <= MINIMUM_TEMP_DIFFERENCE) //It won't adjust temperature if the difference is too low
		return FALSE

	target.adjust_bodytemperature(difference < 0 ? -TEMP_PER_SHOT : TEMP_PER_SHOT)

//Surgical Gown Medicell.
/obj/item/ammo_casing/energy/medical/utility/gown
	projectile_type = /obj/projectile/energy/medical/utility/gown
	select_name = "gown"
	select_color = "#00ffbf"

/obj/projectile/energy/medical/utility/gown
	name = "硬光手术袍力场"

/obj/projectile/energy/medical/utility/gown/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()
	if(!istype(target, /mob/living/carbon/human)) //Dead check isn't fully needed, since it'd be reasonable for this to work on corpses.
		return

	var/mob/living/carbon/wearer = target
	var/obj/item/clothing/gown = new /obj/item/clothing/suit/toggle/labcoat/nova/surgical_gown/hardlight

	if(wearer.equip_to_slot_if_possible(gown, ITEM_SLOT_OCLOTHING, 1, 1, 1))
		wearer.visible_message(span_notice("[gown]覆盖了[wearer]的身体。"), span_notice("[gown]缠绕在你的身体上，将你覆盖。"))
		return
	else
		wearer.visible_message(span_warning("[gown]无法适配[wearer]，瞬间消散了！"), span_warning("[gown]无法穿戴在你身上，瞬间化为乌有！"))
		return FALSE

//Salve Medicell
/obj/item/ammo_casing/energy/medical/utility/salve
	projectile_type = /obj/projectile/energy/medical/utility/salve
	select_name = "salve"
	select_color = "#00af57"

/obj/projectile/energy/medical/utility/salve
	name = "药膏球"
	icon_state = "glob_projectile"
	shrapnel_type = /obj/item/mending_globule/hardlight
	embed_type = /datum/embedding/salve_globule/hardlight
	damage = 0

/datum/embedding/salve_globule
	embed_chance = 100
	ignore_throwspeed_threshold = TRUE
	pain_mult = 0
	jostle_pain_mult = 0
	fall_chance = 0

/obj/projectile/energy/medical/utility/salve/on_hit(mob/living/target, blocked = 0, pierce_hit, item_impact_zone, hit_zone)
	if(!is_living_human(target)) //No using this on the dead or synths.
		return FALSE
	return ..()

/datum/embedding/salve_globule/hardlight/remove_embedding()
	var/obj/item/mending_globule/globule = parent
	owner.visible_message(span_warning("[globule]的硬光场在从[owner]身上移除时瓦解，连同剩余的药膏一起嘶嘶作响地化为虚无！"))
	qdel(globule)
	return ..()

//Hardlight Rollerbed Medicell
/obj/item/ammo_casing/energy/medical/utility/bed
	projectile_type = /obj/projectile/energy/medical/utility/bed
	select_name = "rollerbed"
	select_color = "#00fff2"

/obj/projectile/energy/medical/utility/bed
	name = "硬光病床力场"

/obj/projectile/energy/medical/utility/bed/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()

	if(!istype(target, /mob/living/carbon/human)) //Only checks if they are human, it would make sense for this to work on the dead.
		return FALSE

	for(var/obj/structure/bed/medical/medigun in target.loc) //Prevents multiple beds from being spawned on the same turf
		return FALSE

	if(HAS_TRAIT(target, TRAIT_FLOORED) || target.resting) //Is the person already on the floor to begin with? Mostly a measure to prevent spamming.
		var /obj/structure/bed/medical/medigun/created_bed = new /obj/structure/bed/medical/medigun(target.loc)

		if(!target.stat == CONSCIOUS)
			created_bed.buckle_mob(target)
		return TRUE
	else
		return FALSE

/obj/item/ammo_casing/energy/medical/utility/body_teleporter
	projectile_type = /obj/projectile/energy/medical/utility/body_teleporter
	select_name = "teleporter"
	select_color = "#4400ff"
	delay = 12 //This is a powerful cell, It'd be good for this to have a bit of a delay

/obj/projectile/energy/medical/utility/body_teleporter
	name = "蓝空传送力场"

/obj/projectile/energy/medical/utility/body_teleporter/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()

	if(!ishuman(target) || (target.stat != DEAD && !HAS_TRAIT(target, TRAIT_DEATHCOMA)))
		return FALSE

	var/mob/living/carbon/body = target

	teleport_effect(body.loc)
	body.forceMove(firer.loc)
	teleport_effect(body.loc)

	body.visible_message(span_notice("[body]的身体传送到了[firer]处！"))

/obj/projectile/energy/medical/utility/body_teleporter/proc/teleport_effect(location)
	do_sparks(5, TRUE, get_turf(location), spark_type = /datum/effect_system/basic/spark_spread/quantum) //uses the teleport effect from quantum pads

//Objects Used by medicells.
/obj/item/clothing/suit/toggle/labcoat/nova/surgical_gown/hardlight
	name = "硬光手术袍"
	desc = "一件由硬光制成的病号服。你几乎感觉不到它在你身上，尤其是在所有麻醉剂的作用下。"
	icon_state = "lgown"
	item_flags = parent_type::item_flags | DROPDEL

/obj/item/clothing/suit/toggle/labcoat/nova/surgical_gown/hardlight/dropped(mob/user)
	user.update_held_items()
	if(!QDELETED(src))
		user.visible_message(span_warning("[src]在被移除后消失了！"))
	return ..()

//Salve Globule
/obj/item/mending_globule/hardlight
	name = "药膏球"
	desc = "一团再生的合成植物物质，被包裹在一个柔软的硬光场内。"
	embed_type = /datum/embedding/salve_globule/hardlight
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/misc.dmi'
	icon_state = "globule"
	heals_left = 40 //This means it'll be heaing 10 damage per type max.

//Ensures that you can't stack multiple globules on the same limb
/datum/embedding/salve_globule/hardlight/on_successful_embed(mob/living/carbon/target, obj/item/bodypart/target_limb)
	. = ..()
	for(var/obj/item/mending_globule/hardlight/existing in target_limb.embedded_objects)
		if ((existing != parent))
			target.visible_message(span_warning("[parent]从[target]的[target_limb.plaintext_zone]滑落，那里已经附着了一个药膏球！"))
			qdel(parent)
			return
		else
			continue

/datum/embedding/salve_globule/hardlight/process(seconds_per_tick)
	. = ..()
	var/obj/item/mending_globule/hardlight/globule = parent
	owner_limb.heal_damage(0.25 * seconds_per_tick, 0.25 * seconds_per_tick) //Reduced healing rate over original
	globule.heals_left--
	if(globule.heals_left <= 0)
		qdel(globule)

//Hardlight Emergency Bed.
/obj/structure/bed/medical/medigun
	name = "硬光医疗床"
	desc = "一张由硬光制成的医疗床。"
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/misc.dmi'
	icon_state = "hardlight_down"
	base_icon_state = "hardlight"
	max_integrity = 1
	build_stack_type = null //It would not be good if people could use this to farm materials.
	var/deploy_time = 20 SECONDS //How long the roller beds lasts for without someone buckled to it.

/obj/structure/bed/medical/medigun/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_bed)), deploy_time)
	AddElement(/datum/element/tool_blocker, TOOL_WRENCH, TOOL_ACT_SECONDARY)

/obj/structure/bed/medical/medigun/proc/check_bed() //Checks to see if anyone is buckled to the bed, if not the bed will qdel itself.
	if(!has_buckled_mobs())
		qdel(src) //Deletes the roller bed, mostly meant to prevent stockpiling and clutter
		return TRUE //There is nothing on the bed.
	else
		return FALSE //There is something on the bed.

/obj/structure/bed/medical/medigun/post_unbuckle_mob(mob/living/M)
	. = ..()
	qdel(src)

/obj/structure/bed/medical/medigun/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(over == user && Adjacent(user))
		if(!ishuman(user) || !user.can_perform_action(src))
			return FALSE

		if(has_buckled_mobs())
			return FALSE

		user.visible_message(span_notice("[user] 关闭了 \the [src]。"), span_notice("你关闭了 \the [src]。"))
		qdel(src)

//Oppressive Force Relocation
/obj/item/ammo_casing/energy/medical/utility/relocation
	projectile_type = /obj/projectile/energy/medical/utility/relocation
	select_name = "relocation"
	select_color = "#140085"

//The version that the normal medicells use
/obj/item/ammo_casing/energy/medical/utility/relocation/standard
	projectile_type = /obj/projectile/energy/medical/utility/relocation/standard
	delay = 12

/obj/projectile/energy/medical/utility/relocation
	name = "蓝空传送力场"
	/// Determines whether or not this works anywhere?
	var/area_locked = FALSE
	/// A list of areas that the effect works in, if area_locked is set to true
	var/list/teleport_areas
	/// Where the target will be teleported to.
	var/destination_area = /area/station/medical/medbay/lobby

	/// Is there a grace period before someone is teleported
	var/grace_period = FALSE
	/// How much time does the target have to leave the area before they end up getting teleported?
	var/time_allowance = 10 SECONDS

	/// Is access required to teleport
	var/access_teleporting = FALSE
	/// if the target doesn't have this access on their ID, they will be teleported
	var/required_access = ACCESS_SURGERY

/obj/projectile/energy/medical/utility/relocation/standard
	area_locked = TRUE
	teleport_areas = list(/area/station/medical/surgery, /area/station/medical/treatment_center, /area/station/medical/storage, /area/station/medical/patients_rooms)
	grace_period = TRUE
	access_teleporting = TRUE

/obj/projectile/energy/medical/utility/relocation/on_hit(mob/living/target, blocked = 0, pierce_hit)
	. = ..()

	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/teleportee = target

	if(area_locked && length(teleport_areas) && !is_type_in_list(get_area(target), teleport_areas))
		return FALSE

	if(access_teleporting && teleportee.wear_id)
		var/target_access = teleportee.wear_id.GetAccess() //Stores the access of the target within a variable
		if(required_access in target_access)
			return FALSE

	if(teleportee.GetComponent(/datum/component/medigun_relocation))
		return FALSE

	if(target.buckled)
		return FALSE

	if(grace_period)
		to_chat(teleportee, span_warning("你有[(time_allowance / 10)]秒的时间离开，如果你在此期间没有离开，将被强制传送出去。"))
		teleportee.AddComponent(/datum/component/medigun_relocation, time_allowance, destination_area, area_locked, teleport_areas)
		return TRUE

	var/list/turf_list

	if(!turf_list)
		turf_list = list()
		for(var/turf/turf_in_area in get_area_turfs(destination_area))
			if(!turf_in_area.is_blocked_turf())
				turf_list += turf_in_area

	teleportee.visible_message(span_notice("[teleportee]被传送走了！"))

	do_teleport(teleportee, pick(turf_list), no_effects = FALSE, channel = TELEPORT_CHANNEL_QUANTUM)

/// Used to handle teleporting if there is a grace period
/datum/component/medigun_relocation
	/// Area that the target is teleported to
	var/area/destination_area
	/// The person that is being teleported
	var/mob/living/carbon/human/teleportee
	/// Is the teleport locked to only specific areas.
	var/area_locked
	/// If area_locked is enabled, people can be teleported while in these areas.
	var/list/teleport_areas

/datum/component/medigun_relocation/Initialize(time_allowance, destination, locked, areas)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	var/atom/parent_atom = parent

	teleport_areas = areas
	teleportee = parent_atom
	area_locked = locked
	destination_area = destination

	addtimer(CALLBACK(src, PROC_REF(dispense_treat)), (time_allowance * 0.95))
	QDEL_IN(src, time_allowance)

/datum/component/medigun_relocation/Destroy()
	if(area_locked && length(teleport_areas) && !is_type_in_list(get_area(teleportee), teleport_areas))
		return ..()

	if(!teleportee.stat == CONSCIOUS) // This is mostly here to stop medical from accidentally teleporting out people they otherwise wouldn't want to.
		return ..()

	var/list/turf_list

	if(!turf_list)
		turf_list = list()
		for(var/turf/turf_in_area in get_area_turfs(destination_area))
			if(!turf_in_area.is_blocked_turf())
				turf_list += turf_in_area

	teleportee.visible_message(span_notice("[teleportee]被传送走了！"))

	do_teleport(teleportee, pick(turf_list), no_effects = FALSE, channel = TELEPORT_CHANNEL_QUANTUM)

	return ..()

/// Puts a treat in the teleportee's hands.
/datum/component/medigun_relocation/proc/dispense_treat()
	var/obj/item/goodbye_treat = new /obj/item/food/lollipop/cyborg(teleportee) // The borg one is being used because it has psicodine instead of omnizine.
	teleportee.put_in_hands(goodbye_treat)

//End of utility
#undef UPGRADED_MEDICELL_PASSFLAGS
#undef MINIMUM_TEMP_DIFFERENCE
#undef TEMP_PER_SHOT
