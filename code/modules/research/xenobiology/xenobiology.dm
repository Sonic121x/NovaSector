// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Slime Extracts ///

/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "grey-core"
	force = 0
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	///Can this extract still be grinded
	var/can_grind = TRUE
	///uses before it goes inert
	var/extract_uses = 1
	///deletion timer, for delayed reactions
	var/qdel_timer = null
	///Which type of crossbred
	var/crossbreed_modification
	///Reagents required for activation
	var/recurring = FALSE

/obj/item/slime_extract/grind_results()
	return can_grind ? list(/datum/reagent/toxin/slimejelly = 20) : list()

/obj/item/slime_extract/examine(mob/user)
	. = ..()
	if(extract_uses > 1)
		. += LANG("obj.bfb90e09acea4869", list(extract_uses))

/obj/item/slime_extract/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/slimepotion/enhancer))
		return NONE
	if(extract_uses >= 5 || recurring)
		to_chat(user, span_warning(LANG("obj.51da4542e084b4cd", null)))
		return ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/slimepotion/enhancer/max))
		to_chat(user, span_notice(LANG("obj.73974d7a7b601b64", null)))
		extract_uses = 5
	else
		to_chat(user, span_notice(LANG("obj.66d81fdfc8fff60f", null)))
		extract_uses++
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/slime_extract/Initialize(mapload)
	. = ..()
	create_reagents(100, INJECTABLE | DRAWABLE | SEALED_CONTAINER)

/**
* Effect when activated by a Luminescent.
*
* This proc is called whenever a Luminescent consumes a slime extract. Each one is separated into major and minor effects depending on the extract. Cooldown is measured in deciseconds.
*
* * arg1 - The mob absorbing the slime extract.
* * arg2 - The valid species for the absorbtion. Should always be a Luminescent unless something very major has changed.
* * arg3 - Whether or not the activation is major or minor. Major activations have large, complex effects, minor are simple.
*/
/obj/item/slime_extract/proc/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	to_chat(user, span_warning(LANG("obj.8957f01958212414", null)))
	return FALSE

/**
* Core-crossing: Feeding adult slimes extracts to obtain a much more powerful, single extract.
*
* By using a valid core on a living adult slime, then feeding it nine more of the same type, you can mutate it into more useful items. Not every slime type has an implemented core cross.
*/
/obj/item/slime_extract/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/basic/slime/target_slime = interacting_with
	if(!istype(target_slime))
		return NONE

	if(IS_UNCONSCIOUS_OR_CRIT(target_slime))
		to_chat(user, span_warning(LANG("obj.8820e38743f5c40f", null)))
		return ITEM_INTERACT_BLOCKING
	if(target_slime.life_stage != SLIME_LIFE_STAGE_ADULT)
		to_chat(user, span_warning(LANG("obj.4218b046544a0edf", null)))
		return ITEM_INTERACT_BLOCKING
	if(target_slime.crossbreed_modification && target_slime.crossbreed_modification != crossbreed_modification)
		to_chat(user, span_warning(LANG("obj.80afde9c9a812cdd", null)))
		return ITEM_INTERACT_BLOCKING

	if(!target_slime.crossbreed_modification)
		target_slime.crossbreed_modification = crossbreed_modification

	target_slime.applied_crossbreed_amount++
	qdel(src)
	to_chat(user, span_notice(LANG("obj.956b8ba861b91e0f", list(src, target_slime.applied_crossbreed_amount == 1 ? "starting to mutate its core." : "further mutating its core."))))
	playsound(target_slime, 'sound/effects/blob/attackblob.ogg', 50, TRUE)

	if(target_slime.applied_crossbreed_amount >= SLIME_EXTRACT_CROSSING_REQUIRED)
		target_slime.spawn_corecross()
	return ITEM_INTERACT_SUCCESS

/**
* Effect when activated by selfsustaining crossbreed or rainbow slime
*
* * arg1 - The reaction being triggered. If null, a random reaction is picked
*/
/obj/item/slime_extract/proc/auto_activate_reaction(datum/chemical_reaction/slime/slime_reaction = null)
	if(QDELETED(src))
		return

	if(isnull(slime_reaction))
		var/list/slime_reactions = GLOB.slime_extract_auto_activate_reactions[type]
		if(isnull(slime_reactions))
			return
		slime_reaction = pick(slime_reactions)

	var/list/required_reagents = slime_reaction.required_reagents
	for(var/datum/reagent/chem as anything in required_reagents)
		reagents.add_reagent(chem, required_reagents[chem])

/// An assoc list of slime extracts to their allowed recipes
GLOBAL_LIST_INIT(slime_extract_auto_activate_reactions, init_slime_auto_activate_reaction_list())

/proc/init_slime_auto_activate_reaction_list()
	var/list/recipe_list = list()

	// Only reactions with these reagent requirements are allowed to auto_activate
	var/list/auto_activate_reagent_whistlist = list(
		/datum/reagent/toxin/plasma,
		/datum/reagent/water,
		/datum/reagent/blood,
		/datum/reagent/water/holywater,
		/datum/reagent/uranium,
		/datum/reagent/uranium/radium,
		/datum/reagent/toxin/slimejelly
	)

	var/list/slime_extract_paths = subtypesof(/obj/item/slime_extract)
	for(var/datum/chemical_reaction/slime/slime_reaction as anything in subtypesof(/datum/chemical_reaction/slime))
		var/recipe_extract_type = slime_reaction.required_container
		if(!(recipe_extract_type in slime_extract_paths))
			continue

		var/skip = FALSE
		for(var/datum/reagent/chem as anything in slime_reaction.required_reagents)
			if(!(chem in auto_activate_reagent_whistlist))
				skip = TRUE
				break
		if(skip)
			continue

		var/list/recipes = recipe_list[recipe_extract_type]
		if(!recipes)
			recipes = list()
			recipe_list[recipe_extract_type] = recipes
		recipes.Add(new slime_reaction())

	return recipe_list


/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey-core"
	crossbreed_modification = "reproductive"

/obj/item/slime_extract/grey/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/obj/item/food/monkeycube/M = new
			if(!user.put_in_active_hand(M))
				M.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			to_chat(user, span_notice(LANG("obj.83fde9225704fce8", null)))
			return 120
		if(SLIME_ACTIVATE_MAJOR)
			to_chat(user, span_notice(LANG("obj.e661625498df5774", list(name))))
			if(do_after(user, 4 SECONDS, target = user))
				var/mob/living/basic/slime/new_slime = new(get_turf(user), /datum/slime_type/grey)
				playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
				to_chat(user, span_notice(LANG("obj.90cd020c510a9146", list(new_slime))))
				return 350
			else
				return 0

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold-core"
	crossbreed_modification = "symbiont"



/obj/item/slime_extract/gold/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			user.visible_message(span_warning(LANG("obj.49d50020ac43cddc", list(user))),span_notice(LANG("obj.4730dcedbf51f3c8", list(name))))
			if(do_after(user, 4 SECONDS, target = user))
				var/mob/living/spawned_mob = create_random_mob(user.drop_location(), FRIENDLY_SPAWN)
				spawned_mob.add_faction(FACTION_NEUTRAL)
				playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
				user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, spawned_mob))), span_notice(LANG("obj.ec7d601c2be7898a", list(spawned_mob))))
				return 300

		if(SLIME_ACTIVATE_MAJOR)
			user.visible_message(span_warning(LANG("obj.ff912bfdcc6df5e6", list(user))),span_warning(LANG("obj.35e1d481ba5dba8e", list(name))))
			if(do_after(user, 5 SECONDS, target = user))
				var/mob/living/spawned_mob = create_random_mob(user.drop_location(), HOSTILE_SPAWN)
				if(!user.combat_mode)
					spawned_mob.add_faction(FACTION_NEUTRAL)
				else
					spawned_mob.add_faction(FACTION_SLIME)
				playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
				user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, spawned_mob))), span_warning(LANG("obj.ec7d601c2be7898a", list(spawned_mob))))
				return 600

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver-core"
	crossbreed_modification = "consuming"



/obj/item/slime_extract/silver/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/food_type = get_random_food()
			var/obj/item/food/food_item = new food_type
			ADD_TRAIT(food_item, TRAIT_FOOD_SILVER, INNATE_TRAIT)
			if(!user.put_in_active_hand(food_item))
				food_item.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, food_item))), span_notice(LANG("obj.ec7d601c2be7898a", list(food_item))))
			return 200
		if(SLIME_ACTIVATE_MAJOR)
			var/drink_type = get_random_drink()
			var/obj/O = new drink_type
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 200

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal-core"
	crossbreed_modification = "industrial"

/obj/item/slime_extract/metal/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/obj/item/stack/sheet/glass/O = new(null, 5)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			var/obj/item/stack/sheet/iron/O = new(null, 5)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 200

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple-core"
	crossbreed_modification = "regenerative"

/obj/item/slime_extract/purple/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			user.adjust_nutrition(50)
			user.adjust_blood_volume(50)
			to_chat(user, span_notice(LANG("obj.113fd7a87e9976c5", list(src))))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			to_chat(user, span_notice(LANG("obj.00c8ac9c19f77c24", list(src))))
			user.reagents.add_reagent(/datum/reagent/medicine/regen_jelly,10)
			return 600

/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark-purple-core"
	crossbreed_modification = "self-sustaining"

/obj/item/slime_extract/darkpurple/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/obj/item/stack/sheet/mineral/plasma/O = new(null, 1)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			var/turf/open/T = get_turf(user)
			if(istype(T))
				T.atmos_spawn_air("[GAS_PLASMA]=20")
			to_chat(user, span_warning(LANG("obj.c4ade60c2772343a", list(src))))
			return 900

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange-core"
	crossbreed_modification = "burning"

/obj/item/slime_extract/orange/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_notice(LANG("obj.3a6e56444429db0d", list(src))))
			user.reagents.add_reagent(/datum/reagent/consumable/capsaicin,10)
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			user.reagents.add_reagent(/datum/reagent/phosphorus,5)//
			user.reagents.add_reagent(/datum/reagent/potassium,5) // = smoke, along with any reagents inside mr. slime
			user.reagents.add_reagent(/datum/reagent/consumable/sugar,5)     //
			to_chat(user, span_warning(LANG("obj.c894bb30cf412643", list(src))))
			return 450

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow-core"
	crossbreed_modification = "charged"

/obj/item/slime_extract/yellow/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			if(species.glow_intensity != LUMINESCENT_DEFAULT_GLOW)
				to_chat(user, span_warning(LANG("obj.8f098c0c0f38b271", null)))
				return
			species.update_glow(user, 5)
			addtimer(CALLBACK(species, TYPE_PROC_REF(/datum/species/jelly/luminescent, update_glow), user, LUMINESCENT_DEFAULT_GLOW), 1 MINUTES)
			to_chat(user, span_notice(LANG("obj.13ead7ee191d5751", null)))

		if(SLIME_ACTIVATE_MAJOR)
			user.visible_message(span_warning(LANG("obj.f7c64e44970d1530", list(user))), span_warning(LANG("obj.0492052514797a3c", null)))
			if(do_after(user, 2.5 SECONDS, target = user))
				empulse(user, 1, 2, emp_source = src)
				user.log_message("triggered EMP using [src] in [AREACOORD(src)]", LOG_GAME)
				user.visible_message(span_warning(LANG("obj.ff9e190307d285d1", list(user))), span_warning(LANG("obj.b0988c4761c1bf1b", null)))
				return 600

/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red-core"
	crossbreed_modification = "sanguine"

/obj/item/slime_extract/red/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_notice(LANG("obj.aa4e9a70ccb10a30", list(src))))
			user.reagents.add_reagent(/datum/reagent/medicine/ephedrine,5)
			return 450

		if(SLIME_ACTIVATE_MAJOR)
			user.visible_message(span_warning(LANG("obj.98e1c4fd5a2574e4", list(user))), span_warning(LANG("obj.c38edd12a5fedd47", null)))
			for(var/mob/living/basic/slime/slime in viewers(get_turf(user), null))
				slime.ai_controller?.set_blackboard_key(BB_SLIME_RABID, TRUE)
				slime.visible_message(span_danger(LANG("obj.f05e3bad08ab0ae4", list(slime))))
			return 600

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue-core"
	crossbreed_modification = "stabilized"

/obj/item/slime_extract/blue/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_notice(LANG("obj.b639d34884ec041f", list(src))))
			user.reagents.add_reagent(/datum/reagent/medicine/mutadone, 10)
			user.reagents.add_reagent(/datum/reagent/medicine/potass_iodide, 10)
			return 250

		if(SLIME_ACTIVATE_MAJOR)
			user.reagents.create_foam(/datum/effect_system/fluid_spread/foam, 20, log = TRUE)
			user.visible_message(span_danger(LANG("obj.27c97c9b04f48572", list(user))), span_warning(LANG("obj.65e640a70d731c8d", list(src))))
			return 600

/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark-blue-core"
	crossbreed_modification = "chilling"

/obj/item/slime_extract/darkblue/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_notice(LANG("obj.f7de864deebe3f43", list(src))))
			user.extinguish_mob()
			user.adjust_wet_stacks(20)
			user.reagents.add_reagent(/datum/reagent/consumable/frostoil,6)
			user.reagents.add_reagent(/datum/reagent/medicine/regen_jelly,7)
			return 100

		if(SLIME_ACTIVATE_MAJOR)
			var/turf/open/T = get_turf(user)
			if(istype(T))
				T.atmos_spawn_air("[GAS_N2]=40;[TURF_TEMPERATURE(2.7)]")
			to_chat(user, span_warning(LANG("obj.17713ae7e946d1f4", list(src))))
			return 900

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink-core"
	crossbreed_modification = "gentle"

/obj/item/slime_extract/pink/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			if(user.gender != MALE && user.gender != FEMALE)
				to_chat(user, span_warning(LANG("obj.ec46f52a6fe97bb1", null)))
				return

			if(user.gender == MALE)
				user.gender = FEMALE
				user.visible_message(span_boldnotice(LANG("obj.4ee216c94c71e861", list(user))), span_boldwarning(LANG("obj.42e37fc74da0ffcd", null)))
			else
				user.gender = MALE
				user.visible_message(span_boldnotice(LANG("obj.7aa664c14bc6ce68", list(user))), span_boldwarning(LANG("obj.47ec09034113768b", null)))
			return 100

		if(SLIME_ACTIVATE_MAJOR)
			user.visible_message(span_warning(LANG("obj.5ed6dbe83c8638a4", list(user))), span_notice(LANG("obj.88e6f0506e5dc40d", null)))
			for(var/mob/living/carbon/C in viewers(user, null))
				if(C != user)
					C.reagents.add_reagent(/datum/reagent/pax,2)
			return 600

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green-core"
	crossbreed_modification = "mutative"

/obj/item/slime_extract/green/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_warning(LANG("obj.1e52ec7e8963b41e", null)))
			if(do_after(user, 12 SECONDS, target = user))
				to_chat(user, span_warning(LANG("obj.e759ff1543dc4529", null)))
				user.set_species(/datum/species/human)
				return
			to_chat(user, span_notice(LANG("obj.ce7ee5bf76aa42d0", null)))

		if(SLIME_ACTIVATE_MAJOR)
			to_chat(user, span_warning(LANG("obj.91b7242759839053", null)))
			if(do_after(user, 12 SECONDS, target = user))
				to_chat(user, span_warning(LANG("obj.f080466d0deb4de5", null)))
				user.set_species(pick(/datum/species/jelly/slime, /datum/species/jelly/stargazer))
				return
			to_chat(user, span_notice(LANG("obj.ce7ee5bf76aa42d0", null)))

/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light-pink-core"
	crossbreed_modification = "loyal"

/obj/item/slime_extract/lightpink/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/obj/item/slimepotion/renaming/O = new(null, 1)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			var/obj/item/slimepotion/sentience/O = new(null, 1)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 450

/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black-core"
	crossbreed_modification = "transformative"

/obj/item/slime_extract/black/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_userdanger(LANG("obj.4b777fea2737678a", null)))
			user.ForceContractDisease(new /datum/disease/transformation/slime(), FALSE, TRUE)
			return 100

		if(SLIME_ACTIVATE_MAJOR)
			to_chat(user, span_warning(LANG("obj.7f9dd1e0bf076294", null)))
			if(do_after(user, 12 SECONDS, target = user))
				to_chat(user, span_warning(LANG("obj.47f520dfc2281b02", null)))
				user.set_species(pick(/datum/species/shadow))
				return
			to_chat(user, span_notice(LANG("obj.d9e927491b1e1b85", list(src))))

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil-core"
	crossbreed_modification = "detonating"

/obj/item/slime_extract/oil/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_warning(LANG("obj.ef49238ab8fa66a8", null)))
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			new /obj/effect/decal/cleanable/blood/oil/slippery(get_turf(user))
			return 450

		if(SLIME_ACTIVATE_MAJOR)
			user.visible_message(span_warning(LANG("obj.7381a34a5a17f9ed", list(user))), span_userdanger(LANG("obj.5123d0ff035183c9", null)))
			if(do_after(user, 6 SECONDS, target = user))
				to_chat(user, span_userdanger(LANG("obj.7e08d4c4b2633dbe", null)))
				explosion(user, devastation_range = 1, heavy_impact_range = 3, light_impact_range = 6, explosion_cause = src)
				user.investigate_log("has been gibbed by an oil slime extract explosion.", INVESTIGATE_DEATHS)
				user.gib(DROP_ALL_REMAINS)
				return
			to_chat(user, span_notice(LANG("obj.1a5a712da603b865", list(src))))

/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine-core"
	crossbreed_modification = "crystalline"

/obj/item/slime_extract/adamantine/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			if(HAS_TRAIT(user, TRAIT_ADAMANTINE_EXTRACT_ARMOR))
				to_chat(user, span_warning(LANG("obj.297c3374ec9e4e1a", null)))
				return
			ADD_TRAIT(user, TRAIT_ADAMANTINE_EXTRACT_ARMOR, ADAMANTINE_EXTRACT_TRAIT)
			to_chat(user, span_notice(LANG("obj.02924b70baef8c96", null)))
			user.physiology.damage_resistance += 25
			addtimer(CALLBACK(src, PROC_REF(reset_armor), user), 120 SECONDS)
			return 450

		if(SLIME_ACTIVATE_MAJOR)
			to_chat(user, span_warning(LANG("obj.3af3c7c62edb046a", null)))
			if(do_after(user, 12 SECONDS, target = user))
				to_chat(user, span_warning(LANG("obj.22b4a5f58ac65887", null)))
				user.set_species(/datum/species/golem)
				return
			to_chat(user, span_notice(LANG("obj.f04d1d11ca64900d", list(src))))

/obj/item/slime_extract/adamantine/proc/reset_armor(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_ADAMANTINE_EXTRACT_ARMOR, ADAMANTINE_EXTRACT_TRAIT)
	user.physiology.damage_resistance -= 25

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace-core"
	crossbreed_modification = "warping"
	var/teleport_ready = FALSE
	var/teleport_x = 0
	var/teleport_y = 0
	var/teleport_z = 0

/obj/item/slime_extract/bluespace/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			to_chat(user, span_warning(LANG("obj.89acf0deab031b78", null)))
			if(do_after(user, 2.5 SECONDS, target = user))
				to_chat(user, span_warning(LANG("obj.345b68577c233b37", null)))
				do_teleport(user, get_turf(user), 6, asoundin = 'sound/items/weapons/emitter2.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
				return 300

		if(SLIME_ACTIVATE_MAJOR)
			if(!teleport_ready)
				to_chat(user, span_notice(LANG("obj.b0b8c12054d3d06a", null)))
				var/turf/T = get_turf(user)
				teleport_x = T.x
				teleport_y = T.y
				teleport_z = T.z
				teleport_ready = TRUE
			else
				teleport_ready = FALSE
				if(teleport_x && teleport_y && teleport_z)
					var/turf/T = locate(teleport_x, teleport_y, teleport_z)
					to_chat(user, span_notice(LANG("obj.49af2e40fe7e33ef", null)))
					do_teleport(user, T,  asoundin = 'sound/items/weapons/emitter2.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
					return 450


/obj/item/slime_extract/pyrite
	name = "pyrite slime extract"
	icon_state = "pyrite-core"
	crossbreed_modification = "prismatic"

/obj/item/slime_extract/pyrite/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/chosen = pick(difflist(subtypesof(/obj/item/toy/crayon),typesof(/obj/item/toy/crayon/spraycan)))
			var/obj/item/O = new chosen(null)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			var/blacklisted_cans = list(/obj/item/toy/crayon/spraycan/borg, /obj/item/toy/crayon/spraycan/infinite)
			var/chosen = pick(subtypesof(/obj/item/toy/crayon/spraycan) - blacklisted_cans)
			var/obj/item/O = new chosen(null)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 250

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean-core"
	crossbreed_modification = "recurring"

/obj/item/slime_extract/cerulean/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			user.reagents.add_reagent(/datum/reagent/medicine/salbutamol,15)
			to_chat(user, span_notice(LANG("obj.2dd94d5e07ffda33", null)))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			var/turf/open/T = get_turf(user)
			if(istype(T))
				T.atmos_spawn_air("[GAS_O2]=11;[GAS_N2]=41;[TURF_TEMPERATURE(T20C)]")
				to_chat(user, span_warning(LANG("obj.313bf37526c4126e", list(src))))
				return 600

/obj/item/slime_extract/sepia
	name = "sepia slime extract"
	icon_state = "sepia-core"
	crossbreed_modification = "lengthened"

/obj/item/slime_extract/sepia/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			var/obj/item/camera/O = new(null, 1)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 150

		if(SLIME_ACTIVATE_MAJOR)
			to_chat(user, span_warning(LANG("obj.1bb380e36976d348", null)))
			if(do_after(user, 3 SECONDS, target = user))
				new /obj/effect/timestop(get_turf(user), 2, 50, list(user))
				return 900

/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow-core"
	crossbreed_modification = "hyperchromatic"

/obj/item/slime_extract/rainbow/activate(mob/living/carbon/human/user, datum/species/jelly/luminescent/species, activation_type)
	switch(activation_type)
		if(SLIME_ACTIVATE_MINOR)
			user.dna.features[FEATURE_MUTANT_COLOR] = "#[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"
			user.dna.update_uf_block(/datum/dna_block/feature/mutant_color)
			user.updateappearance(mutcolor_update=1)
			species.update_glow(user)
			to_chat(user, span_notice(LANG("obj.2c1d4eab17201d7f", null)))
			return 100

		if(SLIME_ACTIVATE_MAJOR)
			var/chosen = pick(subtypesof(/obj/item/slime_extract))
			var/obj/item/O = new chosen(null)
			if(!user.put_in_active_hand(O))
				O.forceMove(user.drop_location())
			playsound(user, 'sound/effects/splat.ogg', 50, TRUE)
			user.visible_message(span_warning(LANG("obj.684bde9746657399", list(user, O))), span_notice(LANG("obj.ec7d601c2be7898a", list(O))))
			return 150

////Slime-derived potions///

/**
* #Slime potions
*
* Feed slimes potions either by hand or using the slime console.
*
* Slime potions either augment the slime's behavior, its extract output, or its intelligence. These all come either from extract effects or cross cores.
* A few of the more powerful ones can modify someone's equipment or gender.
* New ones should probably be accessible only through cross cores as all the normal core types already have uses. Rule of thumb is 'stronger effects go in cross cores'.
*/

/obj/item/slimepotion
	name = "slime potion"
	desc = "A hard yet gelatinous capsule excreted by a slime, containing mysterious substances."
	icon = 'icons/obj/medical/chemical.dmi'
	w_class = WEIGHT_CLASS_TINY

/obj/item/slimepotion/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(is_reagent_container(interacting_with))
		to_chat(user, span_warning(LANG("obj.b6c905d9cc9bca11", list(src, interacting_with))) )
		return ITEM_INTERACT_BLOCKING
	return NONE

/obj/item/slimepotion/slime/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(isslime(interacting_with))
		return interact_with_slime(interacting_with, user, modifiers)
	else
		to_chat(user, span_warning(LANG("obj.95b6440ec10dc92f", list(src))))
		return NONE

/obj/item/slimepotion/slime/proc/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	return

/obj/item/slimepotion/slime/docility
	name = "docility potion"
	desc = "A potent chemical mix that nullifies a slime's hunger, causing it to become docile and tame."
	icon_state = "potsilver"

/obj/item/slimepotion/slime/docility/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	if(IS_UNCONSCIOUS_OR_CRIT(interacting_slime))
		to_chat(user, span_warning(LANG("obj.8820e38743f5c40f", null)))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.ai_controller?.clear_blackboard_key(BB_SLIME_RABID)) //Stops being rabid, but doesn't become truly docile.
		to_chat(interacting_slime, span_warning(LANG("obj.6b08ceb397e8a04d", null)))
		to_chat(user, span_notice(LANG("obj.e688eeb7a65b5773", null)))
		interacting_slime.set_default_behaviour()
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	interacting_slime.set_pacified_behaviour()
	to_chat(interacting_slime, span_warning(LANG("obj.f148d43b793f078a", null)))
	to_chat(user, span_notice(LANG("obj.e4d938d615766394", null)))
	var/newname = sanitize_name(tgui_input_text(user, LANG("obj.1354cabd30a035a8", null), LANG("obj.f428d0a3eb8ed8ce", null), "Pet Slime", MAX_NAME_LEN))

	if (!newname)
		newname = "Pet Slime"
	interacting_slime.name = newname
	interacting_slime.real_name = newname
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/sentience
	name = "intelligence potion"
	desc = "A miraculous chemical mix that grants human like intelligence to living beings."
	icon_state = "potpink"
	/// Are we being offered to a mob, and therefore is a ghost poll currently in progress for the sentient mob?
	var/being_used = FALSE
	var/sentience_type = SENTIENCE_ORGANIC
	/// Reason for offering potion. This will be displayed in the poll alert to ghosts.
	var/potion_reason

/obj/item/slimepotion/sentience/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.40e3611d335761f0", list(potion_reason ? "Current reason: [span_warning(potion_reason)]" : null)))

/obj/item/slimepotion/sentience/Initialize(mapload)
	register_context()
	return ..()

/obj/item/slimepotion/sentience/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Set potion offer reason"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/slimepotion/sentience/click_alt(mob/living/user)
	potion_reason = tgui_input_text(user, LANG("obj.010edc1611d5953f", null), LANG("obj.c46d696676160eb8", null), potion_reason, max_length = MAX_MESSAGE_LEN, multiline = TRUE)
	return CLICK_ACTION_SUCCESS

/obj/item/slimepotion/sentience/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/dumb_mob = interacting_with
	if(being_used)
		return ITEM_INTERACT_BLOCKING
	if(dumb_mob.ckey) //only works on animals that aren't player controlled
		balloon_alert(user, LANG("obj.40c2b08ee59794f1", null))
		return ITEM_INTERACT_BLOCKING
	if(IS_UNCONSCIOUS_OR_CRIT(dumb_mob))
		balloon_alert(user, LANG("obj.5f159f3d51512a3c", null))
		return ITEM_INTERACT_BLOCKING
	if(!dumb_mob.compare_sentience_type(sentience_type)) // Will also return false if not a basic or simple mob, which are the only two we want anyway
		balloon_alert(user, LANG("obj.1c85036c03c3d01e", null))
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, LANG("obj.abfba5438ce05c12", null))
	being_used = TRUE
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target(
		question = "[span_danger(user.name)] is offering [span_notice(dumb_mob.name)] an intelligence potion![potion_reason ? " Reason: [span_boldnotice(potion_reason)]" : ""]",
		check_jobban = ROLE_SENTIENCE,
		poll_time = 20 SECONDS,
		checked_target = dumb_mob,
		ignore_category = POLL_IGNORE_SENTIENCE_POTION,
		alert_pic = dumb_mob,
		role_name_text = "intelligence potion",
		chat_text_border_icon = src,
	)
	on_poll_concluded(user, dumb_mob, chosen_one)
	return ITEM_INTERACT_SUCCESS

/// Assign the chosen ghost to the mob
/obj/item/slimepotion/sentience/proc/on_poll_concluded(mob/user, mob/living/dumb_mob, mob/dead/observer/ghost)
	if(isnull(ghost))
		balloon_alert(user, LANG("obj.5065ea52e1ae9688", null))
		being_used = FALSE
		return

	dumb_mob.PossessByPlayer(ghost.key)
	dumb_mob.mind.enslave_mind_to_creator(user)
	SEND_SIGNAL(dumb_mob, COMSIG_SIMPLEMOB_SENTIENCEPOTION, user)

	if(isanimal(dumb_mob))
		var/mob/living/simple_animal/smart_animal = dumb_mob
		smart_animal.sentience_act()

	dumb_mob.mind.add_antag_datum(/datum/antagonist/sentient_creature)
	balloon_alert(user, LANG("obj.750904155d7ebc7d", null))
	after_success(user, dumb_mob)
	qdel(src)

/obj/item/slimepotion/sentience/proc/after_success(mob/living/user, mob/living/smart_mob)
	return

/obj/item/slimepotion/sentience/nuclear
	name = "syndicate intelligence potion"
	desc = "A miraculous chemical mix that grants human like intelligence to living beings. It has been modified with Syndicate technology to also grant an internal radio implant to the target and authenticate with identification systems."

/obj/item/slimepotion/sentience/nuclear/after_success(mob/living/user, mob/living/smart_mob)
	var/obj/item/implant/radio/syndicate/imp = new(src)
	imp.implant(smart_mob, user)
	smart_mob.AddComponent(/datum/component/simple_access, list(ACCESS_SYNDICATE, ACCESS_MAINT_TUNNELS))
	var/obj/item/implant/implanter = SSwardrobe.provide_type(/obj/item/implant/tacmap/nuclear/cayenne, src)
	implanter.implant(src, null, TRUE)

/obj/item/slimepotion/sentience/nuclear/dangerous_horse
	name = "dangerous pony potion"
	desc = "A miraculous chemical mix that grants human like intelligence to pony beings. It has been modified with Syndicate technology to also grant an internal radio implant to the pony and authenticate with identification systems"
	sentience_type = SENTIENCE_PONY

/obj/item/slimepotion/transference
	name = "consciousness transference potion"
	desc = "A strange slime-based chemical that, when used, allows the user to transfer their consciousness to a lesser being."
	icon_state = "potorange"
	var/prompted = 0
	var/animal_type = SENTIENCE_ORGANIC

/obj/item/slimepotion/transference/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/switchy_mob = interacting_with
	if(prompted)
		return ITEM_INTERACT_BLOCKING
	if(switchy_mob.ckey) //much like sentience, these will not work on something that is already player controlled
		balloon_alert(user, LANG("obj.40c2b08ee59794f1", null))
		return ITEM_INTERACT_BLOCKING
	if(IS_UNCONSCIOUS_OR_CRIT(switchy_mob))
		balloon_alert(user, LANG("obj.5f159f3d51512a3c", null))
		return ITEM_INTERACT_BLOCKING
	if(!switchy_mob.compare_sentience_type(animal_type))
		balloon_alert(user, LANG("obj.1c85036c03c3d01e", null))
		return ITEM_INTERACT_BLOCKING

	var/job_banned = is_banned_from(user.ckey, ROLE_MIND_TRANSFER)
	if(QDELETED(src) || QDELETED(switchy_mob) || QDELETED(user))
		return ITEM_INTERACT_BLOCKING

	if(job_banned)
		balloon_alert(user, LANG("obj.c98f3771ad386d24", null))
		return ITEM_INTERACT_BLOCKING

	user.do_attack_animation(interacting_with)
	prompted = 1
	if(tgui_alert(usr,LANG("obj.0230e6de647220ff", list(switchy_mob)),,list("Yes","No")) != "Yes")
		prompted = 0
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.4d7af7e6b9e603e8", list(switchy_mob))))

	user.mind.transfer_to(switchy_mob)
	SEND_SIGNAL(switchy_mob, COMSIG_SIMPLEMOB_TRANSFERPOTION, user)
	SET_FACTION_AND_ALLIES_FROM( switchy_mob, user)
	switchy_mob.copy_languages(user, LANGUAGE_MIND)
	user.death()
	to_chat(switchy_mob, span_notice(LANG("obj.3f1fe3698b10eb0c", list(switchy_mob))))
	to_chat(switchy_mob, span_warning(LANG("obj.af0f8b56127661cf", list(switchy_mob))))
	switchy_mob.name = "[user.real_name]"
	qdel(src)
	if(isanimal(switchy_mob))
		var/mob/living/simple_animal/switchy_animal= switchy_mob
		switchy_animal.sentience_act()
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/slime/steroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a baby slime to generate more extract."
	icon_state = "potred"

/obj/item/slimepotion/slime/steroid/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	if(interacting_slime.life_stage == SLIME_LIFE_STAGE_ADULT) //Can't steroidify adults
		to_chat(user, span_warning(LANG("obj.c21fb8c0d4cf9f40", null)))
		return ITEM_INTERACT_BLOCKING
	if(IS_UNCONSCIOUS_OR_CRIT(interacting_slime))
		to_chat(user, span_warning(LANG("obj.8820e38743f5c40f", null)))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.cores >= 5)
		to_chat(user, span_warning(LANG("obj.36ee2a45e628c50b", null)))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.48e4719872735a76", null)))
	interacting_slime.cores++
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/enhancer
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract an additional use."
	icon_state = "potpurple"

/obj/item/slimepotion/slime/stabilizer
	name = "slime stabilizer"
	desc = "A potent chemical mix that will reduce the chance of a slime mutating."
	icon_state = "potcyan"

/obj/item/slimepotion/slime/stabilizer/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	if(IS_UNCONSCIOUS_OR_CRIT(interacting_slime))
		to_chat(user, span_warning(LANG("obj.8820e38743f5c40f", null)))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.mutation_chance == 0)
		to_chat(user, span_warning(LANG("obj.8bb933d2c0fa21da", null)))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.f6463632a8d0d116", null)))
	interacting_slime.mutation_chance = clamp(interacting_slime.mutation_chance-15,0,100)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/slime/mutator
	name = "slime mutator"
	desc = "A potent chemical mix that will increase the chance of a slime mutating."
	icon_state = "potgreen"

/obj/item/slimepotion/slime/mutator/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	if(IS_UNCONSCIOUS_OR_CRIT(interacting_slime))
		to_chat(user, span_warning(LANG("obj.8820e38743f5c40f", null)))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.mutator_used)
		to_chat(user, span_warning(LANG("obj.f9cd8334abd5d04b", null)))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.mutation_chance == 100)
		to_chat(user, span_warning(LANG("obj.c42215e87834e583", null)))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.51335eff3c5ae400", null)))
	interacting_slime.mutation_chance = clamp(interacting_slime.mutation_chance+12,0,100)
	interacting_slime.mutator_used = TRUE
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/speed
	name = "slime speed potion"
	desc = "A potent chemical mix that will remove the slowdown from any item."
	icon_state = "potred"

/obj/item/slimepotion/speed/interact_with_atom(obj/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isobj(interacting_with))
		to_chat(user, span_warning(LANG("obj.dff24bafce228f9d", null)))
		return NONE

	if(HAS_TRAIT(interacting_with, TRAIT_SPEED_POTIONED))
		to_chat(user, span_warning(LANG("obj.92ce148fb5cf6ce2", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING

	if(isitem(interacting_with))
		var/obj/item/apply_to = interacting_with
		if(apply_to.slowdown <= 0 || (apply_to.item_flags & IMMUTABLE_SLOW) || HAS_TRAIT(apply_to, TRAIT_NO_SPEED_POTION))
			if(interacting_with.atom_storage)
				return NONE // lets us put the potion in the bag
			to_chat(user, span_warning(LANG("obj.92ce148fb5cf6ce2", list(apply_to))))
			return ITEM_INTERACT_BLOCKING

	if(SEND_SIGNAL(interacting_with, COMSIG_SPEED_POTION_APPLIED, src, user) & SPEED_POTION_STOP)
		return ITEM_INTERACT_SUCCESS

	if(isitem(interacting_with))
		var/obj/item/apply_to = interacting_with
		apply_to.slowdown = 0

	to_chat(user, span_notice(LANG("obj.4dacf75df500cca9", list(interacting_with))))
	interacting_with.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	interacting_with.add_atom_colour(color_transition_filter(COLOR_RED, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	interacting_with.drag_slowdown = 0
	ADD_TRAIT(interacting_with, TRAIT_SPEED_POTIONED, SLIME_POTION_TRAIT)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/fireproof
	name = "slime chill potion"
	desc = "A potent chemical mix that will fireproof any article of clothing. Has three uses."
	icon_state = "potblue"
	resistance_flags = FIRE_PROOF
	var/uses = 3

/obj/item/slimepotion/fireproof/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(uses <= 0)
		qdel(src)
		return ITEM_INTERACT_BLOCKING
	var/obj/item/clothing/clothing = interacting_with
	if(!istype(clothing))
		to_chat(user, span_warning(LANG("obj.a29bdeb8b2122646", null)))
		return NONE
	if(clothing.max_heat_protection_temperature >= FIRE_IMMUNITY_MAX_TEMP_PROTECT)
		to_chat(user, span_warning(LANG("obj.bf84934f4e22caf7", list(clothing))))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.363948bc8551479d", list(clothing))))
	clothing.name = "fireproofed [clothing.name]"
	clothing.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	clothing.add_atom_colour(color_transition_filter(COLOR_NAVY, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	clothing.max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	clothing.heat_protection = clothing.body_parts_covered
	clothing.resistance_flags |= FIRE_PROOF
	uses --
	if(uses <= 0)
		qdel(src)
	return ITEM_INTERACT_BLOCKING

/obj/item/slimepotion/genderchange
	name = "gender change potion"
	desc = "An interesting chemical mix that changes the biological gender of what its applied to. Cannot be used on things that lack gender entirely."
	icon_state = "potrainbow"

/obj/item/slimepotion/genderchange/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/living_mob = interacting_with
	if(living_mob.stat == DEAD)
		to_chat(user, span_warning(LANG("obj.b073beb92149577b", null)))
		return ITEM_INTERACT_BLOCKING

	if(living_mob.gender != MALE && living_mob.gender != FEMALE)
		to_chat(user, span_warning(LANG("obj.01d41de20b631af2", null)))
		return ITEM_INTERACT_BLOCKING

	if(living_mob.mind)
		if (!do_after(user, delay = 5 SECONDS, target = living_mob))
			balloon_alert(user, LANG("obj.c67b5d274d6e724b", null))
			return ITEM_INTERACT_BLOCKING

	if(living_mob.gender == MALE)
		living_mob.gender = FEMALE
		living_mob.visible_message(span_boldnotice(LANG("obj.4ee216c94c71e861", list(living_mob))), span_boldwarning(LANG("obj.42e37fc74da0ffcd", null)))
	else
		living_mob.gender = MALE
		living_mob.visible_message(span_boldnotice(LANG("obj.7aa664c14bc6ce68", list(living_mob))), span_boldwarning(LANG("obj.47ec09034113768b", null)))
	living_mob.regenerate_icons()
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/renaming
	name = "renaming potion"
	desc = "A potion that allows a self-aware being to change what name it subconsciously presents to the world."
	icon_state = "potbrown"

	var/being_used = FALSE

/obj/item/slimepotion/renaming/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/renaming_mob = interacting_with
	if(being_used)
		return ITEM_INTERACT_BLOCKING
	if(!renaming_mob.ckey) //only works on animals that aren't player controlled
		to_chat(user, span_warning(LANG("obj.0c57b8a5b198ec50", list(renaming_mob))))
		return ITEM_INTERACT_BLOCKING

	being_used = TRUE

	to_chat(user, span_notice(LANG("obj.7b2474e5d2e85f81", list(src, user))))

	var/new_name = sanitize_name(tgui_input_text(renaming_mob, LANG("obj.53566b0fa0485f54", null), LANG("obj.e767d1fc1c80c9b7", null), renaming_mob.real_name, MAX_NAME_LEN))

	if(!new_name || QDELETED(src) || QDELETED(renaming_mob) || new_name == renaming_mob.real_name || !renaming_mob.Adjacent(user))
		being_used = FALSE
		return ITEM_INTERACT_BLOCKING

	renaming_mob.visible_message(span_notice(LANG("obj.eb4383de114e65e2", list(span_name("[renaming_mob]"), span_name("[new_name]")))), span_notice(LANG("obj.fa4783b1cc7c4664", list(span_name("[renaming_mob.real_name]"), span_name("[new_name]")))))
	message_admins("[ADMIN_LOOKUPFLW(user)] used [src] on [ADMIN_LOOKUPFLW(renaming_mob)], letting them rename themselves into [new_name].")
	user.log_message("used [src] on [key_name(renaming_mob)], letting them rename themselves into [new_name].", LOG_GAME)

	// pass null as first arg to not update records or ID/PDA
	renaming_mob.fully_replace_character_name(null, new_name, log_new_name = TRUE)

	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/slimeradio
	name = "bluespace radio potion"
	desc = "A strange chemical that grants those who ingest it the ability to broadcast and receive subscape radio waves."
	icon_state = "potbluespace"

/obj/item/slimepotion/slimeradio/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isliving(interacting_with))
		return NONE
	if(!isanimal_or_basicmob(interacting_with))
		to_chat(user, span_warning(LANG("obj.16166502764921e4", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/radio_head = interacting_with
	if(IS_UNCONSCIOUS_OR_CRIT(radio_head))
		to_chat(user, span_warning(LANG("obj.01e50bcef3be90ac", list(radio_head))))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.42d1640eae2b38e9", list(radio_head))))
	to_chat(radio_head, span_notice(LANG("obj.0841618cf41841f2", null)))
	var/obj/item/implant/radio/slime/imp = new(src)
	imp.implant(radio_head, user)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

///Definitions for slime products that don't have anywhere else to go (Floor tiles, blueprints).

/obj/item/stack/tile/bluespace
	name = "stabilized bluespace floor tile"
	singular_name = "floor tile"
	desc = "Through a series of micro-teleports these tiles let people move at incredible speeds."
	icon_state = "tile_bluespace"
	inhand_icon_state = "tile-bluespace"
	w_class = WEIGHT_CLASS_NORMAL
	force = 6
	mats_per_unit = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*5)
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	obj_flags = CONDUCTS_ELECTRICITY
	max_amount = 60
	turf_type = /turf/open/floor/bluespace
	merge_type = /obj/item/stack/tile/bluespace

/obj/item/stack/tile/sepia
	name = "sepia floor tile"
	singular_name = "floor tile"
	desc = "Time seems to flow very slowly around these tiles."
	icon_state = "tile_sepia"
	inhand_icon_state = "tile-sepia"
	w_class = WEIGHT_CLASS_NORMAL
	force = 6
	mats_per_unit = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*5)
	throwforce = 10
	throw_speed = 0.1
	throw_range = 28
	obj_flags = CONDUCTS_ELECTRICITY
	max_amount = 60
	turf_type = /turf/open/floor/sepia
	merge_type = /obj/item/stack/tile/sepia
