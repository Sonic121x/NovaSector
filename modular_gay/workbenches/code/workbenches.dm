/// How many planks of wood are required to complete a weapon?
#define WEAPON_COMPLETION_WOOD_AMOUNT 2

/// The number of hits you are set back when a bad hit is made
#define BAD_HIT_PENALTY 3

/obj/structure/reagent_crafting_bench/tinker
	name = "tinker's workbench"
	desc = "A crafting bench fitted with tools, securing mechanisms, and a steady surface for gunsmithing."
	icon = 'modular_gay/workbenches/icon/workbenches.dmi'
	icon_state = "tinkerbench"

	light_range = 3
	light_power = 1.5
	anchored = TRUE
	density = TRUE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)
	in_use = FALSE
	current_hits_to_completion = 0
	finishes_forging_weapons = FALSE
	var/list/obj/structure/fillers = list()
	allowed_choices = list(
		/datum/crafting_bench_recipe/grip_rubber,
		/datum/crafting_bench_recipe/grip_wood,
		/datum/crafting_bench_recipe/grip_black,
		/datum/crafting_bench_recipe/mechanism_pistol,
		/datum/crafting_bench_recipe/mechanism_smg,
		/datum/crafting_bench_recipe/mechanism_boltaction,
		/datum/crafting_bench_recipe/mechanism_autorifle,
		/datum/crafting_bench_recipe/mechanism_shotgun,
		/datum/crafting_bench_recipe/barrel_short,
		/datum/crafting_bench_recipe/barrel_long,
		/datum/crafting_bench_recipe/barrel_silent,
		/datum/crafting_bench_recipe/barrel_amr,
		/datum/crafting_bench_recipe/gun_parts,
		/datum/crafting_bench_recipe/spring,
		/datum/crafting_bench_recipe/c9mm,
		/datum/crafting_bench_recipe/c22,
		/datum/crafting_bench_recipe/c308,
		/datum/crafting_bench_recipe/c7758,
		/datum/crafting_bench_recipe/birdshot,
		/datum/crafting_bench_recipe/c22p,
		/datum/crafting_bench_recipe/c22smg,
		/datum/crafting_bench_recipe/c308clip,
		/datum/crafting_bench_recipe/C96,
		/datum/crafting_bench_recipe/arisaka,
	)
	var/list/construction_sounds = list(
		'sound/items/tools/wirecutter.ogg',
		'sound/items/tools/welder2.ogg',
		'sound/items/tools/welder.ogg',
		'sound/items/trayhit/trayhit2.ogg',
		'sound/items/trayhit/trayhit1.ogg',
		'sound/items/sheath.ogg',
		'sound/items/tools/screwdriver2.ogg',
		'sound/items/tools/screwdriver.ogg',
		'sound/items/tools/ratchet.ogg',
		'sound/items/tools/jaws_pry.ogg',
		'sound/items/tools/jaws_cut.ogg',
		'sound/items/hammering_wood.ogg',
		'sound/items/foodcanopen.ogg',
		'sound/items/electronic_assembly_emptying.ogg',
		'sound/items/duct_tape/duct_tape_rip.ogg',
		'sound/items/tools/drill_use.ogg',
		'sound/items/tools/drill_hit.ogg',
		'sound/items/tools/crowbar_prying.ogg',
		'sound/items/tools/change_jaws.ogg',
		'sound/items/tools/change_drill.ogg',
		'sound/items/ceramic_break.ogg',
		'sound/items/car_engine_start.ogg',
		'sound/items/boxcutter_activate.ogg',
		'sound/items/box_cut.ogg',
		'sound/items/ampoule_snap.ogg',
	)

/obj/structure/reagent_crafting_bench/tinker/Initialize(mapload)
	. = ..()
	populate_radial_choice_list()

/obj/structure/reagent_crafting_bench/tinker/Initialize(mapload)
	//TODO: Replace this,bsa and gravgen with some big machinery datum
	var/list/occupied = list()
	for(var/direct in list(EAST))
		occupied += get_step(src,direct)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F
	return ..()

/obj/structure/reagent_crafting_bench/tinker/Destroy()
	for(var/obj/structure/filler/filler as anything in fillers)
		filler.parent = null
		qdel(filler)
	return ..()

/obj/structure/reagent_crafting_bench/tinker/wrench_act(mob/living/user, obj/item/tool)
	user.balloon_alert_to_viewers("disassembling...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 100))
		return

	deconstruct(disassembled = TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/reagent_crafting_bench/tinker/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 5)

/obj/structure/reagent_crafting_bench/tinker/screwdriver_act(mob/living/user, obj/item/tool)
	playsound(src, pick(construction_sounds),  50, TRUE)
	if(length(contents))
		if(!istype(contents[1], /obj/item/forging/complete))
			balloon_alert(user, "invalid item")
			return ITEM_INTERACT_SUCCESS

		var/obj/item/forging/complete/weapon_to_finish = contents[1]

		if(!weapon_to_finish.spawning_item)
			balloon_alert(user, "[weapon_to_finish] cannot be completed")
			return ITEM_INTERACT_SUCCESS

		var/list/wood_required_for_weapons = list(
			/obj/item/stack/sheet/mineral/wood = WEAPON_COMPLETION_WOOD_AMOUNT,
		)

		if(!can_we_craft_this(wood_required_for_weapons))
			balloon_alert(user, "not enough wood")
			return ITEM_INTERACT_SUCCESS

		var/list/things_to_use = can_we_craft_this(wood_required_for_weapons, TRUE)
		var/obj/thing_just_made = create_thing_from_requirements(things_to_use, user = user, skill_to_grant = /datum/skill/smithing, skill_amount = 30, completing_a_weapon = TRUE)

		if(!thing_just_made)
			message_admins("[src] just tried to finish a weapon but somehow created nothing! This is not working as intended!")
			return ITEM_INTERACT_SUCCESS

		balloon_alert_to_viewers("[thing_just_made] created")
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(!selected_recipe)
		balloon_alert(user, "no recipe selected")
		return ITEM_INTERACT_SUCCESS

	if(!can_we_craft_this(selected_recipe.recipe_requirements))
		balloon_alert(user, "missing ingredients")
		return ITEM_INTERACT_SUCCESS

	var/skill_modifier = user.mind.get_skill_modifier(selected_recipe.relevant_skill, SKILL_SPEED_MODIFIER) * 1 SECONDS

	if(!COOLDOWN_FINISHED(src, hit_cooldown)) // If you hit it before the cooldown is done, you get a bad hit, setting you back three good hits
		current_hits_to_completion -= BAD_HIT_PENALTY

		if(current_hits_to_completion <= -(selected_recipe.required_good_hits))
			balloon_alert_to_viewers("recipe failed")
			clear_recipe()
			return ITEM_INTERACT_SUCCESS

		balloon_alert(user, "bad hit")
		return ITEM_INTERACT_SUCCESS

	COOLDOWN_START(src, hit_cooldown, skill_modifier)

	if((current_hits_to_completion >= selected_recipe.required_good_hits) && !length(contents))
		var/list/things_to_use = can_we_craft_this(selected_recipe.recipe_requirements, TRUE)

		create_thing_from_requirements(things_to_use, selected_recipe, user, selected_recipe.relevant_skill, selected_recipe.relevant_skill_reward)
		return ITEM_INTERACT_SUCCESS

	current_hits_to_completion++
	balloon_alert(user, "good hit")
	user.mind.adjust_experience(selected_recipe.relevant_skill, selected_recipe.relevant_skill_reward / 15) // Good hits towards the current item grants experience in that skill
	return ITEM_INTERACT_SUCCESS
