// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Animated beings of stone. They have increased defenses, and do not need to breathe. They must eat minerals to live, which give additional buffs.
/datum/species/golem
	name = "Golem"
	id = SPECIES_GOLEM
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_LAVA_IMMUNE,
		TRAIT_NEVER_WOUNDED,
		TRAIT_NOBLOOD,
		TRAIT_NOBREATH,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NODISMEMBER,
		TRAIT_NOFAT,
		TRAIT_NOFIRE,
		TRAIT_NOSOFTCRIT,
		TRAIT_NO_AUGMENTS,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_NO_UNDERWEAR,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_SNOWSTORM_IMMUNE, // Shared with plasma river... but I guess if you can survive a plasma river a blizzard isn't a big deal
		TRAIT_UNHUSKABLE,
	)
	mutantheart = null
	mutantlungs = null
	inherent_biotypes = MOB_HUMANOID|MOB_MINERAL
	payday_modifier = 1.0
	siemens_coeff = 0.01
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	sexes = FALSE
	meat = /obj/item/food/meat/slab/human/mutant/golem
	species_language_holder = /datum/language_holder/golem

	bodytemp_heat_damage_limit = BODYTEMP_HEAT_LAVALAND_SAFE
	bodytemp_cold_damage_limit = BODYTEMP_COLD_ICEBOX_SAFE

	mutant_organs = list(/obj/item/organ/adamantine_resonator)
	mutanteyes = /obj/item/organ/eyes/golem
	mutantbrain = /obj/item/organ/brain/golem
	mutanttongue = /obj/item/organ/tongue/golem
	mutantstomach = /obj/item/organ/stomach/golem
	mutantliver = /obj/item/organ/liver/golem
	mutantappendix = /obj/item/organ/appendix/golem
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/golem,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/golem,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/golem,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/golem,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/golem,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/golem,
	)

	/// Have we warned the mob about low nutrition?
	VAR_FINAL/early_warning = FALSE
	/// Have we given the final warning about starvation?
	VAR_FINAL/final_warning = FALSE
	/// Cooldown of warning message so we don't spam it if we flick around the threshold
	COOLDOWN_DECLARE(warning_cd)

/datum/species/golem/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons, replace_missing)
	. = ..()
	RegisterSignal(human_who_gained_species, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(drain_nutrition))
	RegisterSignal(human_who_gained_species, COMSIG_LIVING_UPDATE_NUTRITION, PROC_REF(check_nutrition))
	RegisterSignal(human_who_gained_species, COMSIG_CARBON_DEFIB_HEART_CHECK, PROC_REF(defib_check))
	RegisterSignal(human_who_gained_species, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(rebuild_check))
	RegisterSignal(human_who_gained_species, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(human_who_gained_species, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	// nutrition = health, so give people a head start
	human_who_gained_species.set_nutrition(NUTRITION_LEVEL_WELL_FED)

	MODIFY_PHYSIOLOGY(human_who_gained_species, STAMINA, 0.6)
	MODIFY_PHYSIOLOGY(human_who_gained_species, PHYS_COEFF_STUN, 0.6)
	MODIFY_PHYSIOLOGY(human_who_gained_species, PHYS_COEFF_KNOCKDOWN, 1.2) //this offsets the positive effects of the lowered stun coeff on knockdowns specifically.

/datum/species/golem/on_species_loss(mob/living/carbon/human/human_who_lost_species, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(human_who_lost_species, list(
		COMSIG_MOB_AFTER_APPLY_DAMAGE,
		COMSIG_LIVING_UPDATE_NUTRITION,
		COMSIG_CARBON_DEFIB_HEART_CHECK,
		COMSIG_ATOM_ITEM_INTERACTION,
		COMSIG_ATOM_EXAMINE,
		COMSIG_LIVING_LIFE,
	))

	MODIFY_PHYSIOLOGY(human_who_lost_species, STAMINA, 1 / 0.6)
	MODIFY_PHYSIOLOGY(human_who_lost_species, PHYS_COEFF_STUN, 1 / 0.6)
	MODIFY_PHYSIOLOGY(human_who_lost_species, PHYS_COEFF_KNOCKDOWN, 1/1.2)

/datum/species/golem/proc/on_life(mob/living/carbon/human/source, seconds_per_tick)
	SIGNAL_HANDLER

	if(source.nutrition <= 20)
		// this is "hard crit" for golems
		source.Unconscious(1.5 SECONDS * seconds_per_tick)
	if(source.nutrition <= 100 || source.health < source.crit_threshold)
		// and this is "crit damage" for golems
		var/drain = 1
		if(source.nutrition <= 50)
			drain *= 2
		if(source.health < source.crit_threshold)
			drain *= 2
		source.adjust_nutrition(-1 * drain * seconds_per_tick, forced = TRUE)
	if(source.nutrition > NUTRITION_LEVEL_FAT)
		// nutrition is health so let's keep this sane
		source.set_nutrition(NUTRITION_LEVEL_FAT)

/datum/species/golem/proc/on_examine(mob/living/carbon/human/source, mob/living/examiner, list/examine_text)
	SIGNAL_HANDLER

	if(!IS_DEAD_OR_FAKING(source))
		return

	examine_text += span_warning(LANG("datum.b0dffa55c5b23ee0", null))

/datum/species/golem/proc/rebuild_check(mob/living/carbon/human/source, mob/living/user, obj/item/tool, ...)
	SIGNAL_HANDLER

	if(!IS_DEAD_OR_FAKING(source))
		return NONE

	if(!isstack(tool) || !is_type_in_list(tool, GLOB.golem_stack_food_directory))
		return NONE

	INVOKE_ASYNC(src, PROC_REF(rebuild), source, user, tool)
	return ITEM_INTERACT_SUCCESS

/datum/species/golem/proc/rebuild(mob/living/carbon/human/source, mob/living/user, obj/item/stack/mats)
	source.notify_revival("You are being rebuilt by [user.real_name]!")
	var/brute_ready = source.get_brute_loss() < 50
	var/burn_ready = source.get_fire_loss() < 50
	var/nutrition_ready = source.nutrition > NUTRITION_LEVEL_VERY_HUNGRY

	while(check_rebuild(source, user, mats))
		user.visible_message(
			span_notice(LANG("datum.2a5811ffe898242f", list(user, mats, source))),
			span_notice(LANG("datum.fec0a4020e441c9f", list(mats, source))),
		)

		var/do_after_time = 2 SECONDS
		if(brute_ready && burn_ready && nutrition_ready && source.can_be_revived())
			do_after_time *= 4
			user.show_message(span_notice("[source] looks almost fully rebuilt, this will take a bit longer..."), MSG_VISUAL)
		if(HAS_TRAIT(user, TRAIT_QUICK_BUILD))
			do_after_time *= 0.75

		if(!do_after(user, do_after_time, source, extra_checks = CALLBACK(src, PROC_REF(check_rebuild), source, user, mats) ) )
			return

		// calculated "effective sheet power" based on mats
		// ex. iron sheets will have a power of 1, reinforced glass a power of 1.5
		var/mat_power = 0
		for(var/mat, mat_amt in mats.custom_materials)
			mat_power += mat_amt
		mat_power /= mats.amount // mats per sheet
		mat_power /= SHEET_MATERIAL_AMOUNT // normalize

		mats.use(1)
		source.heal_ordered_damage(mat_power * 5, list(BRUTE, BURN))
		source.adjust_nutrition(mat_power * 20)
		if(!brute_ready)
			if(source.get_brute_loss() < 50)
				user.show_message(span_notice("[source] looks sturdier than ever! It's not long now..."), MSG_VISUAL)
				brute_ready = TRUE
			continue
		if(!burn_ready)
			if(source.get_fire_loss() < 50)
				user.show_message(span_notice("[source] seems to be regaining its integrity! Just a bit more..."), MSG_VISUAL)
				burn_ready = TRUE
			continue
		if(!nutrition_ready)
			if(source.nutrition > NUTRITION_LEVEL_HUNGRY)
				user.show_message(span_notice("[source] seems to be stabilizing its form! Almost there..."), MSG_VISUAL)
				nutrition_ready = TRUE
			continue

		if(source.revive(excess_healing = 10)) // give a bit of organ/tox/oxy healing for free
			source.visible_message(
				span_notice(LANG("datum.488d54441d3d3f8d", list(source))),
				span_boldnotice(LANG("datum.faa33782ca79b5f4", null)),
				visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			)
			source.set_resting(FALSE, silent = TRUE, instant = TRUE)
		return

/datum/species/golem/proc/check_rebuild(mob/living/carbon/human/source, mob/living/user, obj/item/stack/mats)
	if(source.stat != DEAD)
		return FALSE
	if(QDELETED(user))
		return FALSE
	if(QDELETED(mats) || mats.amount < 1)
		return FALSE
	if(!user.is_holding(mats))
		return FALSE
	return TRUE

/datum/species/golem/proc/defib_check(mob/living/carbon/human/source, mob/living/carbon/human/defib_user)
	SIGNAL_HANDLER

	// golems can't be defibrillated, they have no heart and aren't even alive in the traditional sense
	// you gotta rebuild them with materials if they fall apart
	return DEFIB_FAIL_GOLEM

/datum/species/golem/proc/drain_nutrition(mob/living/carbon/human/source, damage_amt, damage_type, ...)
	SIGNAL_HANDLER

	// our brute and burn damage is more than halved by our limbs
	// the other "half" of the damage is converted into nutrition loss (representing loss of rock material)
	if(damage_type != BURN && damage_type != BRUTE)
		return

	source.adjust_nutrition(round(-3 * damage_amt, 0.01), forced = TRUE)

/datum/species/golem/proc/check_nutrition(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	if(source.nutrition < NUTRITION_LEVEL_STARVING)
		if(!early_warning && COOLDOWN_FINISHED(src, warning_cd) && !IS_UNCONSCIOUS(source))
			source.visible_message(
				span_warning(LANG("datum.1ce1bcc7dc5ac8ee", list(source))),
				span_bolddanger(LANG("datum.43d45a669f6dc2ce", null)),
				visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			)
			early_warning = TRUE
			COOLDOWN_START(src, warning_cd, 1 MINUTES)

	else
		early_warning = FALSE

	if(source.nutrition < 50)
		if(!final_warning && COOLDOWN_FINISHED(src, warning_cd) && !IS_UNCONSCIOUS(source))
			source.visible_message(
				span_warning(LANG("datum.8e7fdfa41d5ccddf", list(source))),
				span_userdanger(LANG("datum.471b8267d344da9d", null)),
				visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			)
			final_warning = TRUE
			COOLDOWN_START(src, warning_cd, 1 MINUTES)

	else
		final_warning = FALSE

	if(source.nutrition < 2 && source.stat != DEAD)
		source.visible_message(
			span_warning(LANG("datum.825c12ecc0744853", list(source))),
			span_userdanger(LANG("datum.91b1134184a1ccd8", null)),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		source.investigate_log("starved to death as a golem", INVESTIGATE_DEATHS)
		source.death()

/datum/species/golem/get_physical_attributes()
	return "Golems are hardy creatures made out of stone, which are thus naturally resistant to many dangers, including asphyxiation, fire, radiation, electricity, and viruses.\
		They gain special abilities depending on the type of material consumed, but they need to consume material to keep their body animated."

/datum/species/golem/get_species_description()
	return "Golems are lithoid creatures who eat rocks and minerals to survive and adapt."

/datum/species/golem/get_species_lore()
	return list(
		"While Golems have long been commonly found on frontier worlds, peacefully mining and otherwise living in harmony with the environment, \
		it is believed they were originally constructed in Nanotrasen laboratories as a form of cheap labor. Whatever happened up to this point is unknown, \
		but they have since gained freedom and are now a rare sight in the galaxy.",
	)

/datum/species/golem/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "user-shield",
		SPECIES_PERK_NAME = LANG("datum.39f6bbbdc17e184c", null),
		SPECIES_PERK_DESC = LANG("datum.58ea2eb25635ebfc", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "gem",
		SPECIES_PERK_NAME = LANG("datum.a01e575cc0926db9", null),
		SPECIES_PERK_DESC = LANG("datum.28e6fa6aa948179d", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "tools",
		SPECIES_PERK_NAME = LANG("datum.bb4be19979497f02", null),
		SPECIES_PERK_DESC = LANG("datum.c8228c6afd8e95fa", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "bolt",
		SPECIES_PERK_NAME = LANG("datum.ce6c815d8aa3a7d9", null),
		SPECIES_PERK_DESC = LANG("datum.75555c87fe3ac857", null),
	))

	return to_add
