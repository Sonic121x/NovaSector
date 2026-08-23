// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Used to set up a basic AI controller on a mob for admin ease of use
/datum/admin_ai_template
	/// What do admins see when selecting this option?
	var/name = ""
	/// What AI controller do we apply?
	var/controller_type
	/// Should we be active even if the target has an active client?
	var/override_client
	/// Do we apply the hostile faction?
	var/make_hostile
	/// How likely is it that we move when not busy?
	var/idle_chance
	/// When do we stop targeting mobs?
	var/minimum_stat

/// Actually perform the process
/datum/admin_ai_template/proc/apply(mob/living/target, client/user)
	if (QDELETED(target) || !isliving(target))
		to_chat(user, span_warning(LANG("datum.69f93880c3d0339e", null)))
		return
	if (gather_information(target, user))
		apply_controller(target, user)

/// Set up any stored variables before we actually apply the controller
/datum/admin_ai_template/proc/gather_information(mob/living/target, client/user)
	override_client = tgui_alert(user, LANG("datum.f30c3159261c4038", null), LANG("datum.f4191ee1f287acd8", null), list("Yes", "No"))
	if (isnull(override_client))
		return FALSE
	override_client = override_client == "Yes"

	idle_chance = tgui_input_number(user, LANG("datum.93e5b6b46520d83b", null), LANG("datum.f8820a5325d201fd", null), max_value = 100, min_value = 0)
	if (isnull(idle_chance))
		return FALSE

	if (isnull(make_hostile))
		make_hostile = tgui_alert(user, LANG("datum.a4351e97bc4cf6a7", null), LANG("datum.83d61e9d1bccf409", null), list("Yes", "No"))
		if (isnull(make_hostile))
			return FALSE
		make_hostile = make_hostile == "Yes"

	if (isnull(minimum_stat))
		var/static/list/stat_types = list(
			"Stable" = STABLE,
			"Soft Crit" = SOFT_CRIT,
			"Hard Crit" = HARD_CRIT,
			"Dead (will probably get stuck punching a corpse forever)" = DEAD,
		)
		var/selected_stat = tgui_input_list(user, LANG("datum.ec321bd002289bf1", null), LANG("datum.038f382e8dd22ee7", null), stat_types, "Soft Crit")
		if (isnull(selected_stat))
			return FALSE
		minimum_stat = stat_types[selected_stat]

	return TRUE

/datum/admin_ai_template/proc/apply_controller(mob/living/target, client/user)
	if (QDELETED(target))
		to_chat(user, span_warning(LANG("datum.3421511434a5cc1d", null)))
		return

	QDEL_NULL(target.ai_controller)
	target.ai_controller = new controller_type(target)

	if (make_hostile)
		target.set_faction(list(FACTION_HOSTILE))
		target.set_allies(list(REF(target)))

	var/datum/ai_controller/controller = target.ai_controller
	controller.set_blackboard_key(BB_BASIC_MOB_IDLE_WALK_CHANCE, idle_chance)
	controller.set_blackboard_key(BB_TARGET_MINIMUM_STAT, minimum_stat)
	if (override_client)
		controller.continue_processing_when_client = TRUE
		controller.reset_ai_status()

/// Walks at a guy and attacks
/datum/admin_ai_template/hostile
	name = "Hostile Melee"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles

/// Walks away from a guy and attacks
/datum/admin_ai_template/hostile_ranged
	name = "Hostile Ranged"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_ranged
	/// When should we retreat?
	var/min_range
	/// When should we advance?
	var/max_range
	/// What projectile do we fire?
	var/projectile_type
	/// What's the time between shots?
	var/fire_cooldown
	/// How many projectiles per shot?
	var/burst_shots
	/// What's the delay between projectiles in a burst?
	var/burst_interval
	/// What sound do we make?
	var/projectile_sound

/datum/admin_ai_template/hostile_ranged/gather_information(mob/living/target, client/user)
	. = ..()
	if (!.)
		return FALSE

	if (!setup_ranged_attacks(target, user))
		return FALSE

	return decide_min_max_range(target, user)

/// Give target a gun
/datum/admin_ai_template/hostile_ranged/proc/setup_ranged_attacks(mob/living/target, client/user)
	if (target.GetComponent(/datum/component/ranged_attacks))
		return TRUE

	var/static/list/all_projectiles = subtypesof(/obj/projectile)
	// These don't really browsable user-friendly names because there's a lot of duplicates, sorry admins
	projectile_type = tgui_input_list(user, LANG("datum.f8a1452fe0e9c73c", null), LANG("datum.989903c8270a520e", null), all_projectiles)
	if (isnull(projectile_type))
		return FALSE

	fire_cooldown = tgui_input_number(user, LANG("datum.9b10adc8d9e99573", null), LANG("datum.9edf8f9842c87394", null), round_value = FALSE, max_value = 10, min_value = 0.2, default = 1)
	if (isnull(fire_cooldown))
		return FALSE
	fire_cooldown = fire_cooldown SECONDS

	burst_shots = tgui_input_number(user, LANG("datum.22e9587f4e7c309a", null), LANG("datum.911d476fba2d7ede", null), max_value = 100, min_value = 1, default = 1)
	if (isnull(burst_shots))
		return FALSE
	if (burst_shots > 1)
		burst_interval = tgui_input_number(user, LANG("datum.6331f117899608a4", null), LANG("datum.bd7ccc08d99e8be5", null), round_value = FALSE, max_value = 2, min_value = 0.1, default = 0.2)
		if (isnull(burst_interval))
			return FALSE
		burst_interval = burst_interval SECONDS

	var/pick_sound = tgui_alert(user, LANG("datum.401c664c0babfa9f", null), LANG("datum.08da9daf79e2e7dc", null), list("Yes", "No"))
	if (isnull(pick_sound))
		return FALSE
	if (pick_sound == "Yes")
		projectile_sound = input("", LANG("datum.69f8d024eb7617a0", null),) as null|sound

	return TRUE

/// Decide our movement details
/datum/admin_ai_template/hostile_ranged/proc/decide_min_max_range(mob/living/target, client/user)
	min_range = tgui_input_number(user, LANG("datum.619385dd76dc75f5", null), LANG("datum.30292e8c6e2e8b4c", null), max_value = 9, min_value = 0, default = 2)
	if (isnull(min_range))
		return FALSE

	max_range = tgui_input_number(user, LANG("datum.546d55b78f877034", null), LANG("datum.dff79737ba376b81", null), max_value = 9, min_value = 1, default = 6)
	if (isnull(max_range))
		return FALSE

	return TRUE

/datum/admin_ai_template/hostile_ranged/apply_controller(mob/living/target, client/user)
	. = ..()

	var/datum/ai_controller/controller = target.ai_controller
	controller.set_blackboard_key(BB_RANGED_SKIRMISH_MIN_DISTANCE, min_range)
	controller.set_blackboard_key(BB_RANGED_SKIRMISH_MAX_DISTANCE, max_range)

	if (!projectile_type)
		return

	target.AddComponent(\
		/datum/component/ranged_attacks,\
		cooldown_time = fire_cooldown,\
		projectile_type = projectile_type,\
		projectile_sound = projectile_sound,\
		burst_shots = burst_shots,\
		burst_intervals = burst_interval,\
	)

	if (fire_cooldown <= 1 SECONDS)
		target.AddComponent(/datum/component/ranged_mob_full_auto)

/// Walks at a guy while shooting and attacks
/datum/admin_ai_template/hostile_ranged/and_melee
	name = "Hostile Ranged/Melee"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_skirmisher

/datum/admin_ai_template/hostile_ranged/and_melee/decide_min_max_range(mob/living/target, client/user)
	return TRUE

/// Maintain distance from a guy and use an ability on cooldown
/datum/admin_ai_template/ability
	name = "Hostile Ability User"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_ability
	/// What is our ability?
	var/ability_type
	/// When should we retreat?
	var/min_range
	/// When should we advance?
	var/max_range

/datum/admin_ai_template/ability/gather_information(mob/living/target, client/user)
	. = ..()
	if (!.)
		return FALSE

	// We'll limit it to mob actions because they're mostly set up for random mobs already, and spells take some extra finagling for wizard clothing etc
	var/static/list/all_mob_actions = sort_list(subtypesof(/datum/action/cooldown/mob_cooldown), GLOBAL_PROC_REF(cmp_typepaths_asc))
	var/static/list/actions_by_name = list()
	if (!length(actions_by_name))
		for (var/datum/action/cooldown/mob_cooldown as anything in all_mob_actions)
			actions_by_name["[initial(mob_cooldown.name)] ([mob_cooldown])"] = mob_cooldown

	ability_type = tgui_input_list(user, LANG("datum.8b352ce8581c8f13", null), LANG("datum.2e3c8a5ca7002ff6", null), actions_by_name)
	if (isnull(ability_type))
		return FALSE

	ability_type = actions_by_name[ability_type]
	return decide_min_max_range(target, user)

/// Decide our movement details, some copy/paste here unfortunately
/datum/admin_ai_template/ability/proc/decide_min_max_range(mob/living/target, client/user)
	min_range = tgui_input_number(user, LANG("datum.619385dd76dc75f5", null), LANG("datum.30292e8c6e2e8b4c", null), max_value = 9, min_value = 0, default = 2)
	if (isnull(min_range))
		return FALSE

	max_range = tgui_input_number(user, LANG("datum.546d55b78f877034", null), LANG("datum.dff79737ba376b81", null), max_value = 9, min_value = 1, default = 6)
	if (isnull(max_range))
		return FALSE

	return TRUE

/datum/admin_ai_template/ability/apply_controller(mob/living/target, client/user)
	. = ..()

	var/datum/action/cooldown/ability = locate(ability_type) in target.actions
	if (isnull(ability))
		ability = new ability_type(target)
		ability.Grant(target)

	var/datum/ai_controller/controller = target.ai_controller
	controller.set_blackboard_key(BB_TARGETED_ACTION, ability)
	controller.set_blackboard_key(BB_RANGED_SKIRMISH_MIN_DISTANCE, min_range)
	controller.set_blackboard_key(BB_RANGED_SKIRMISH_MAX_DISTANCE, max_range)

/// Walks at a guy and uses an ability on that guy
/datum/admin_ai_template/ability/melee
	name = "Hostile Ability User (Melee Attacks)"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_ability_melee

/datum/admin_ai_template/ability/melee/decide_min_max_range(mob/living/target, client/user)
	return TRUE

/// Stays away from a guy and uses an ability on that guy
/datum/admin_ai_template/hostile_ranged/ability
	name = "Hostile Ability User (Ranged Attacks)"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_ability_ranged
	/// What is our ability?
	var/ability_type

/datum/admin_ai_template/hostile_ranged/ability/gather_information(mob/living/target, client/user)
	. = ..()
	if (!.)
		return FALSE

	// Sadly gotta copy/paste this here too
	var/static/list/all_mob_actions = sort_list(subtypesof(/datum/action/cooldown/mob_cooldown), GLOBAL_PROC_REF(cmp_typepaths_asc))
	var/static/list/actions_by_name = list()
	if (!length(actions_by_name))
		for (var/datum/action/cooldown/mob_cooldown as anything in all_mob_actions)
			actions_by_name["[initial(mob_cooldown.name)] ([mob_cooldown])"] = mob_cooldown

	ability_type = tgui_input_list(user, LANG("datum.8b352ce8581c8f13", null), LANG("datum.2e3c8a5ca7002ff6", null), actions_by_name)
	if (isnull(ability_type))
		return FALSE
	ability_type = actions_by_name[ability_type]
	return TRUE

/datum/admin_ai_template/hostile_ranged/ability/apply_controller(mob/living/target, client/user)
	. = ..()

	var/datum/action/cooldown/ability = locate(ability_type) in target.actions
	if (isnull(ability))
		ability = new ability_type(target)
		ability.Grant(target)

	var/datum/ai_controller/controller = target.ai_controller
	controller.set_blackboard_key(BB_TARGETED_ACTION, ability)

/// Chill unless you throw hands
/datum/admin_ai_template/retaliate
	name = "Passive But Fights Back (Melee)"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_retaliate
	make_hostile = FALSE

/datum/admin_ai_template/retaliate/apply_controller(mob/living/target, client/user)
	. = ..()
	if (!HAS_TRAIT_FROM(target, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM, /datum/element/ai_retaliate)) // Not really what this is for but it should work
		target.AddElement(/datum/element/ai_retaliate)

/// Shoots anyone who attacks them
/datum/admin_ai_template/hostile_ranged/ability/retaliate
	name = "Passive But Fights Back (Ranged Attacks)"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_ranged_retaliate
	make_hostile = FALSE

/datum/admin_ai_template/hostile_ranged/ability/retaliate/apply_controller(mob/living/target, client/user)
	. = ..()
	if (!HAS_TRAIT_FROM(target, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM, /datum/element/ai_retaliate)) // Not really what this is for but it should work
		target.AddElement(/datum/element/ai_retaliate)

/// Uses their signature move on anyone who attacks them
/datum/admin_ai_template/ability/retaliate
	name = "Passive But Fights Back (Ability)"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_ability_retaliate
	make_hostile = FALSE

/datum/admin_ai_template/ability/retaliate/apply_controller(mob/living/target, client/user)
	. = ..()
	if (!HAS_TRAIT_FROM(target, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM, /datum/element/ai_retaliate)) // Not really what this is for but it should work
		target.AddElement(/datum/element/ai_retaliate)

/// Who knows what this guy will do, he's a loose cannon
/datum/admin_ai_template/grumpy
	name = "Gets Mad Unpredictably"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_capricious
	make_hostile = FALSE
	/// Chance per second to get pissed off
	var/flipout_chance
	/// Chance per second to stop being pissed off
	var/calm_down_chance

/datum/admin_ai_template/grumpy/gather_information(mob/living/target, client/user)
	. = ..()
	if (!.)
		return FALSE

	flipout_chance = tgui_input_number(user, LANG("datum.5f616817f525bdee", null), LANG("datum.e5535337af1bfc3d", null), round_value = FALSE, max_value = 100, min_value = 0, default = 0.5)
	if (isnull(flipout_chance))
		return FALSE

	calm_down_chance = tgui_input_number(user, LANG("datum.5b609494c27a716e", null), LANG("datum.e0d8289b639e59f8", null), round_value = FALSE, max_value = 100, min_value = 0, default = 10)
	if (isnull(calm_down_chance))
		return FALSE

	return TRUE

/datum/admin_ai_template/grumpy/apply_controller(mob/living/target, client/user)
	. = ..()
	var/datum/ai_controller/controller = target.ai_controller
	controller.set_blackboard_key(BB_RANDOM_AGGRO_CHANCE, flipout_chance)
	controller.set_blackboard_key(BB_RANDOM_DEAGGRO_CHANCE, calm_down_chance)

	if (!HAS_TRAIT_FROM(target, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM, /datum/element/ai_retaliate)) // Not really what this is for but it should work
		target.AddElement(/datum/element/ai_retaliate)

/// Coward
/datum/admin_ai_template/fearful
	name = "Runs Away"
	minimum_stat = STABLE
	make_hostile = FALSE
	controller_type = /datum/ai_controller/basic_controller/simple/simple_fearful

/// Doesn't like violence
/datum/admin_ai_template/skittish
	name = "Runs Away From Attackers"
	minimum_stat = STABLE
	make_hostile = FALSE
	controller_type = /datum/ai_controller/basic_controller/simple/simple_skittish

/datum/admin_ai_template/skittish/apply_controller(mob/living/target, client/user)
	. = ..()
	if (!HAS_TRAIT_FROM(target, TRAIT_SUBTREE_REQUIRED_OPERATIONAL_DATUM, /datum/element/ai_retaliate)) // Not really what this is for but it should work
		target.AddElement(/datum/element/ai_retaliate)

/// You gottit boss
/datum/admin_ai_template/goon
	name = "Obeys Commands"
	controller_type = /datum/ai_controller/basic_controller/simple/simple_goon
	/// Who is really in charge here?
	var/mob/living/da_boss

/datum/admin_ai_template/goon/gather_information(mob/living/target, client/user)
	. = ..()
	if (!.)
		return FALSE

	var/find_a_mob = tgui_alert(user, LANG("datum.04d834f09f182f91", null), LANG("datum.221797d24bfd9af8", null), list("Yes", "No"))
	if (isnull(override_client))
		return FALSE
	find_a_mob = find_a_mob == "Yes"
	if (!find_a_mob)
		return TRUE

	return grab_mob(target, user)

/// Find a mob to make the boss
/datum/admin_ai_template/goon/proc/grab_mob(mob/living/target, client/user)
	var/list/mobs_in_my_tile = list()
	for (var/mob/living/dude in (range(0, user.mob) - target))
		mobs_in_my_tile[dude.real_name] = dude

	if (length(mobs_in_my_tile))
		var/picked = tgui_input_list(user, LANG("datum.3908d0211ba96f40", null), LANG("datum.590e932dbcd4e755", null), mobs_in_my_tile + "Try Again", "Try Again")
		if (isnull(picked))
			return FALSE
		if (picked == "Try Again")
			return grab_mob(target, user)

		da_boss = mobs_in_my_tile[picked]
		return TRUE

	var/find_a_mob = tgui_alert(user, LANG("datum.8a33562588fa358f", null), LANG("datum.1250141c6ea2c0d7", null), list("Yes", "No"))
	if (isnull(find_a_mob))
		return FALSE
	find_a_mob = find_a_mob == "Yes"
	if (!find_a_mob)
		return TRUE
	return grab_mob(target, user)

/datum/admin_ai_template/goon/apply_controller(mob/living/target, client/user)
	. = ..()
	// There's not really much point making this customisable at the moment
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/move,
		/datum/pet_command/attack,
		/datum/pet_command/follow/start_active,
		/datum/pet_command/protect_owner,
	)
	target.AddComponent(/datum/component/obeys_commands, pet_commands)

	if (isnull(da_boss))
		return

	target.befriend(da_boss)

/// Whatever it was doing before we fucked with it (mostly, can't do this with total confidence)
/datum/admin_ai_template/reset
	name = "Reset"

/datum/admin_ai_template/reset/gather_information(mob/living/target, client/user)
	return TRUE

/datum/admin_ai_template/reset/apply_controller(mob/living/target, client/user)
	QDEL_NULL(target.ai_controller)
	var/controller_type = initial(target.ai_controller)
	target.ai_controller = new controller_type(src)

/// Like I'm doing nothing at all, nothing at all
/datum/admin_ai_template/clear
	name = "None"

/datum/admin_ai_template/clear/gather_information(mob/living/target, client/user)
	return TRUE

/datum/admin_ai_template/clear/apply_controller(mob/living/target, client/user)
	QDEL_NULL(target.ai_controller)
