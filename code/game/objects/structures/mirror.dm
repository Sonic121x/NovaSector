// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

// Normal Mirrors

#define CHANGE_HAIR "Change Hair"
#define CHANGE_BEARD "Change Beard"

// Magic Mirrors!

#define CHANGE_RACE "Change Race"
#define CHANGE_SEX  "Change Sex"
#define CHANGE_NAME "Change Name"
#define CHANGE_EYES "Change Eyes"

#define INERT_MIRROR_OPTIONS list(CHANGE_HAIR, CHANGE_BEARD)
#define PRIDE_MIRROR_OPTIONS list(CHANGE_HAIR, CHANGE_BEARD, CHANGE_RACE, CHANGE_SEX, CHANGE_EYES)
#define MAGIC_MIRROR_OPTIONS list(CHANGE_HAIR, CHANGE_BEARD, CHANGE_RACE, CHANGE_SEX, CHANGE_EYES, CHANGE_NAME)

// Chance for the mirror to be haunted at creation
#define ROUNDSTART_CURSED_CHANCE 0.2

/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	movement_type = FLOATING
	density = FALSE
	anchored = TRUE
	integrity_failure = 0.5
	max_integrity = 200
	custom_materials = /obj/item/wallframe/mirror::custom_materials
	///Can this mirror be removed from walls with tools?
	var/deconstructable = TRUE
	var/list/mirror_options = INERT_MIRROR_OPTIONS
	// Can a revenant be imprisoned in this mirror?
	var/cursable = TRUE
	///Flags this race must have to be selectable with this type of mirror.
	var/race_flags = MIRROR_MAGIC
	///List of all Races that can be chosen, decided by its Initialize.
	var/list/selectable_races = list()

/obj/structure/mirror/Destroy()
	mirror_options = null
	selectable_races = null
	return ..()

/obj/structure/mirror/proc/update_choices()
	for(var/i in mirror_options)
		mirror_options[i] = icon('icons/hud/radial.dmi', i)

/obj/structure/mirror/Initialize(mapload)
	. = ..()
	var/static/list/reflection_filter = alpha_mask_filter(icon = icon('icons/obj/watercloset.dmi', "mirror_mask"))
	var/static/matrix/reflection_matrix = matrix(0.75, 0, 0, 0, 0.75, 0)
	AddComponent(/datum/component/reflection, \
		reflection_filter = reflection_filter, \
		reflection_matrix = reflection_matrix, \
		can_reflect = CALLBACK(src, PROC_REF(can_reflect)), \
		update_signals = list(COMSIG_ATOM_BREAK), \
		check_reflect_signals = list(SIGNAL_ADDTRAIT(TRAIT_NO_MIRROR_REFLECTION), SIGNAL_REMOVETRAIT(TRAIT_NO_MIRROR_REFLECTION)), \
	)
	if(mapload)
		find_and_mount_on_atom()
		if(prob(ROUNDSTART_CURSED_CHANCE) && cursable)
			AddComponent(/datum/component/revenant_prison, create_on_release = TRUE)
	update_choices()
	register_context()

/obj/structure/mirror/proc/can_reflect(atom/movable/target)
	// I'm doing it this way too, because the signal is sent before the broken variable is set to TRUE.
	if(atom_integrity <= integrity_failure * max_integrity || broken)
		return FALSE
	if(!isliving(target) || HAS_TRAIT(target, TRAIT_NO_MIRROR_REFLECTION))
		return FALSE
	return TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/mirror, 28)

/obj/structure/mirror/broken
	icon_state = "mirror_broke"
	cursable = FALSE
	broken = TRUE
	desc = "Oh no, seven years of bad luck!"

/obj/structure/mirror/broken/Initialize(mapload)
	. = ..()

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/mirror/broken, 28)

/obj/structure/mirror/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(. || !ishuman(user) || broken || !istype(src, /obj/structure/mirror/magic)) // NOVA EDIT CHANGE - MUNDANE MIRRORS DON'T LET YOU CHANGE - ORIGINAL: if(. || !ishuman(user) || broken)
		return TRUE

	display_radial_menu(user)
	return TRUE

/obj/structure/mirror/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!deconstructable)
		balloon_alert(user, LANG("obj.490a1292", null))
		return NONE
	user.visible_message(span_notice(LANG("obj.ac4b08c7", list(user, src))), span_notice(LANG("obj.4e190a11", list(src))))
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 3 SECONDS))
		user.visible_message(span_notice(LANG("obj.03a71949", list(user, src))), span_notice(LANG("obj.aa18b3fe", list(src))))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct()
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/structure/mirror/proc/display_radial_menu(mob/living/carbon/human/user)
	if(!can_use_mirror(user))
		return

	var/pick = show_radial_menu(user, src, mirror_options, user, radius = 36, require_near = TRUE, tooltips = TRUE)
	if(!pick || !can_use_mirror(user) || !pre_change(user, pick))
		return

	switch(pick)
		if(CHANGE_HAIR)
			change_hair(user)
		if(CHANGE_BEARD)
			change_beard(user)
		if(CHANGE_RACE)
			change_race(user)
		if(CHANGE_SEX) // sex: yes
			change_sex(user)
		if(CHANGE_NAME)
			change_name(user)
		if(CHANGE_EYES)
			change_eyes(user)

	display_radial_menu(user)

/// Ran before we dive into any changes, can be used to block changes by returning FALSE
/obj/structure/mirror/proc/pre_change(mob/living/carbon/human/user, picked)
	return TRUE

/// Checks if the mob can continue to use the mirror
/obj/structure/mirror/proc/can_use_mirror(mob/living/carbon/human/user)
	return !QDELETED(src) && !QDELETED(user) && !broken && user.can_perform_action(src, FORBID_TELEKINESIS_REACH)

/obj/structure/mirror/proc/change_beard(mob/living/carbon/human/beard_dresser)
	if(beard_dresser.physique == FEMALE)
		if(beard_dresser.facial_hairstyle == "Shaved")
			balloon_alert(beard_dresser, LANG("obj.2baa2eba", null))
			return
		var/shave_beard = tgui_alert(beard_dresser, LANG("obj.b9c92f08", null), LANG("obj.62de8b3c", null), list("Yes", "No"))
		if(shave_beard == "Yes" && can_use_mirror(beard_dresser))
			beard_dresser.set_facial_hairstyle("Shaved", update = TRUE)
		return

	var/new_style = tgui_input_list(beard_dresser, LANG("obj.be20145f", null), LANG("obj.62de8b3c", null), SSaccessories.facial_hairstyles_list)

	if(isnull(new_style) || !can_use_mirror(beard_dresser))
		return

	if(HAS_TRAIT(beard_dresser, TRAIT_SHAVED))
		to_chat(beard_dresser, span_notice(LANG("obj.f67f3b8d", null)))
		beard_dresser.add_mood_event("bald_hair_day", /datum/mood_event/bald_reminder)
		return

	beard_dresser.set_facial_hairstyle(new_style, update = TRUE)

/obj/structure/mirror/proc/change_hair(mob/living/carbon/human/hairdresser)
	var/new_style = tgui_input_list(hairdresser, LANG("obj.f24e1bc1", null), LANG("obj.62de8b3c", null), SSaccessories.hairstyles_list)
	if(isnull(new_style) || !can_use_mirror(hairdresser))
		return
	if(HAS_TRAIT(hairdresser, TRAIT_BALD))
		to_chat(hairdresser, span_notice(LANG("obj.e474f3cd", null)))
		hairdresser.add_mood_event("bald_hair_day", /datum/mood_event/bald_reminder)
		return

	hairdresser.set_hairstyle(new_style, update = TRUE)

/obj/structure/mirror/proc/change_name(mob/living/carbon/human/user)
	var/newname = sanitize_name(tgui_input_text(user, LANG("obj.3dc7eef8", null), LANG("obj.b4bf4c54", null), user.name, MAX_NAME_LEN), allow_numbers = TRUE) //It's magic so whatever.
	if(!newname || !can_use_mirror(user))
		return
	user.real_name = newname
	user.name = newname
	if(user.dna)
		user.dna.real_name = newname
	if(user.mind)
		user.mind.name = newname

// Erm ackshually the proper term is species. Get it right??
/obj/structure/mirror/proc/change_race(mob/living/carbon/human/race_changer)
	var/racechoice = tgui_input_list(race_changer, LANG("obj.d842af96", null), LANG("obj.838e24b8", null), selectable_races)
	if(isnull(racechoice) || !can_use_mirror(race_changer))
		return

	var/new_race_path = selectable_races[racechoice]
	if(!ispath(new_race_path, /datum/species))
		return

	var/datum/species/newrace = GLOB.species_prototypes[new_race_path]
	var/attributes_desc = newrace.get_physical_attributes()

	var/answer = tgui_alert(race_changer, attributes_desc, LANG("obj.cec93002", list(newrace)), list("Yes", "No"))
	if(!answer || !can_use_mirror(race_changer))
		return
	if(answer != "Yes")
		change_race(race_changer) // try again
		return

	on_species_change(race_changer, newrace)
	race_changer.set_species(new_race_path, icon_update = FALSE)
	if(HAS_TRAIT(race_changer, TRAIT_USES_SKINTONES))
		var/new_s_tone = tgui_input_list(race_changer, LANG("obj.affd0a03", null), LANG("obj.838e24b8", null), GLOB.skin_tones)
		if(new_s_tone && can_use_mirror(race_changer))
			race_changer.skin_tone = new_s_tone
			race_changer.dna.update_ui_block(/datum/dna_block/identity/skin_tone)
	else if(HAS_TRAIT(race_changer, TRAIT_MUTANT_COLORS) && !HAS_TRAIT(race_changer, TRAIT_FIXED_MUTANT_COLORS))
		var/new_mutantcolor = tgui_color_picker(race_changer, "Choose your skin color:", "Race change", race_changer.dna.features[FEATURE_MUTANT_COLOR])
		if(new_mutantcolor && can_use_mirror(race_changer))
			var/list/mutant_hsv = rgb2hsv(new_mutantcolor)
			if(mutant_hsv[3] >= 50) // mutantcolors must be bright
				race_changer.dna.features[FEATURE_MUTANT_COLOR] = sanitize_hexcolor(new_mutantcolor)
				race_changer.dna.update_uf_block(/datum/dna_block/feature/mutant_color)
			else
				to_chat(race_changer, span_notice(LANG("obj.8ef8e412", null)))

	race_changer.update_body(is_creating = TRUE)

/// Hook for mirrors to do stuff on species change
/obj/structure/mirror/proc/on_species_change(mob/living/carbon/human/race_changer, datum/species/newrace)
	return

// possible Genders: MALE, FEMALE, PLURAL, NEUTER
// possible Physique: MALE, FEMALE
// saved you a click (many)
/obj/structure/mirror/proc/change_sex(mob/living/carbon/human/sexy)

	var/chosen_sex = tgui_input_list(sexy, LANG("obj.06e45421", null), LANG("obj.15bc27b6", null), list("Warlock", "Witch", "Wizard", "Itzard")) // YOU try coming up with the 'it' version of wizard
	if(!chosen_sex || !can_use_mirror(sexy))
		return

	switch(chosen_sex)
		if("Warlock")
			sexy.gender = MALE
			to_chat(sexy, span_notice(LANG("obj.1acbd57e", null)))
		if("Witch")
			sexy.gender = FEMALE
			to_chat(sexy, span_notice(LANG("obj.bf69e8f9", null)))
		if("Wizard")
			sexy.gender = PLURAL
			to_chat(sexy, span_notice(LANG("obj.eeb46680", null)))
		if("Itzard")
			sexy.gender = NEUTER
			to_chat(sexy, span_notice(LANG("obj.d933fcaa", null)))

	var/chosen_physique = tgui_input_list(sexy, LANG("obj.1403ad51", null), LANG("obj.15bc27b6", null), list("Warlock Physique", "Witch Physique", "Wizards Don't Need Gender"))

	if(chosen_physique && chosen_physique != "Wizards Don't Need Gender" && can_use_mirror(sexy))
		sexy.physique = (chosen_physique == "Warlock Physique") ? MALE : FEMALE

	sexy.dna.update_ui_block(/datum/dna_block/identity/gender)
	sexy.update_body(is_creating = TRUE) // or else physique won't change properly
	sexy.update_clothing(ITEM_SLOT_ICLOTHING) // update gender shaped clothing

/obj/structure/mirror/proc/change_eyes(mob/living/carbon/human/user)
	var/new_eye_color = tgui_color_picker(user, "Choose your eye color", "Eye Color", user.eye_color_left)
	if(isnull(new_eye_color) || !can_use_mirror(user))
		return
	user.set_eye_color(sanitize_hexcolor(new_eye_color))
	user.dna.update_ui_block(/datum/dna_block/identity/eye_colors)
	user.update_eyes()
	to_chat(user, span_notice(LANG("obj.b6775531", null)))

/obj/structure/mirror/examine(mob/user)
	. = ..()
	if(deconstructable)
		. += span_notice(LANG("obj.407e40ef", null))

/obj/structure/mirror/examine_status(mob/living/carbon/human/user)
	if(broken)
		return list()// no message spam
	return ..()

/obj/structure/mirror/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Open Customize Radial"
		return CONTEXTUAL_SCREENTIP_SET
	if(held_item.tool_behaviour == TOOL_WRENCH && deconstructable)
		context[SCREENTIP_CONTEXT_RMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET
	return .

/obj/structure/mirror/attacked_by(obj/item/I, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(broken || . <= 0) // breaking a mirror truly gets you bad luck!
		return
	to_chat(user, span_warning(LANG("obj.f2986fd5", list(src))))
	user.AddComponent(/datum/component/omen, incidents_left = 7)

/obj/structure/mirror/bullet_act(obj/projectile/proj)
	if(broken || !isliving(proj.firer) || !proj.damage)
		return ..()

	. = ..()
	if(broken) // breaking a mirror truly gets you bad luck!
		var/mob/living/unlucky_dude = proj.firer
		to_chat(unlucky_dude, span_warning(LANG("obj.f2986fd5", list(src))))
		unlucky_dude.AddComponent(/datum/component/omen, incidents_left = 7)

/obj/structure/mirror/atom_break(damage_flag)
	. = ..()
	if(broken)
		return
	icon_state = "mirror_broke"
	playsound(src, SFX_SHATTER, 70, TRUE)
	if(desc == initial(desc))
		desc = LANG("obj.70489aa0", null)
	broken = TRUE

/obj/structure/mirror/atom_deconstruct(disassembled = TRUE)
	if(!disassembled)
		new /obj/item/shard(loc)
	else if(broken)
		new /obj/item/wallframe/mirror/broken(loc)
	else
		new /obj/item/wallframe/mirror(loc)

/obj/structure/mirror/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.combat_mode)
		return FALSE

	if(!broken)
		return TRUE

	if(!I.tool_start_check(user, amount=1))
		return TRUE

	balloon_alert(user, LANG("obj.b52342a8", null))
	if(I.use_tool(src, user, 10, volume = 50))
		balloon_alert(user, LANG("obj.65ced1e8", null))
		broken = FALSE
		icon_state = initial(icon_state)
		desc = initial(desc)

	return TRUE

/obj/structure/mirror/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
		if(BURN)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)

/obj/item/wallframe/mirror
	name = "mirror"
	desc = "An unmounted mirror. Attach it to a wall for use."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 2)
	result_path = /obj/structure/mirror
	pixel_shift = 28

/obj/item/wallframe/mirror/heretic
	name = /obj/structure/mirror/magic/lesser/heretic::name
	desc = /obj/structure/mirror/magic/lesser/heretic::desc
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "magic_mirror"
	result_path = /obj/structure/mirror/magic/lesser/heretic

/obj/item/wallframe/mirror/broken
	name = "broken mirror"
	desc = "An unmounted and broken mirror. Attach it to a wall for decor."
	icon_state = "mirror_broke"
	result_path = /obj/structure/mirror/broken

/obj/structure/mirror/magic
	name = "magic mirror"
	desc = "Turn and face the strange... face."
	icon_state = "magic_mirror"
	mirror_options = MAGIC_MIRROR_OPTIONS
	deconstructable = FALSE
	cursable = FALSE

/obj/structure/mirror/magic/Initialize(mapload)
	. = ..()

	if(length(selectable_races))
		return
	for(var/datum/species/species_type as anything in subtypesof(/datum/species))
		if(initial(species_type.changesource_flags) & race_flags)
			selectable_races[initial(species_type.name)] = species_type
	selectable_races = sort_list(selectable_races)

/obj/structure/mirror/magic/change_beard(mob/living/carbon/human/beard_dresser) // magical mirrors do nothing but give you the damn beard
	var/new_style = tgui_input_list(beard_dresser, LANG("obj.be20145f", null), LANG("obj.62de8b3c", null), SSaccessories.facial_hairstyles_list)
	if(isnull(new_style) || !can_use_mirror(beard_dresser))
		return

	beard_dresser.set_facial_hairstyle(new_style, update = TRUE)

//Magic mirrors can change hair color as well
/obj/structure/mirror/magic/change_hair(mob/living/carbon/human/user)
	var/hairchoice = tgui_alert(user, LANG("obj.49a85821", null), LANG("obj.1fc0c9f4", null), list("Style", "Color"))
	if(!can_use_mirror(user))
		return
	if(hairchoice == "Style") //So you just want to use a mirror then?
		return ..()

	var/new_hair_color = tgui_color_picker(user, "Choose your hair color", "Hair Color", user.hair_color)
	if(!new_hair_color || !can_use_mirror(user))
		return
	if(new_hair_color)
		user.set_haircolor(sanitize_hexcolor(new_hair_color))
		user.dna.update_ui_block(/datum/dna_block/identity/hair_color)
	if(user.physique == MALE)
		var/new_face_color = tgui_color_picker(user, "Choose your facial hair color", "Hair Color", user.facial_hair_color)
		if(new_face_color && can_use_mirror(user))
			user.set_facial_haircolor(sanitize_hexcolor(new_face_color))
			user.dna.update_ui_block(/datum/dna_block/identity/facial_color)

/// Hook for mirrors to do stuff on species change
/obj/structure/mirror/magic/on_species_change(mob/living/carbon/human/race_changer, datum/species/newrace)
	if(HAS_TRAIT(race_changer, TRAIT_ADVANCEDTOOLUSER) && HAS_TRAIT(race_changer, TRAIT_LITERATE))
		return

	to_chat(race_changer, span_alert(LANG("obj.f23bbfeb", null)))
	// Prevents wizards from being soft locked out of everything
	// If this stays after the species was changed once more, well, the magic mirror did it. It's magic i aint gotta explain shit
	race_changer.add_traits(list(TRAIT_LITERATE, TRAIT_ADVANCEDTOOLUSER), SPECIES_TRAIT)

/obj/structure/mirror/magic/lesser

/obj/structure/mirror/magic/lesser/Initialize(mapload)
	// Roundstart species don't have a flag, so it has to be set on Initialize.
	selectable_races = get_selectable_species().Copy()
	return ..()

/obj/structure/mirror/magic/lesser/heretic
	name = "miraculous mirror"
	desc = "Gazing at your reflection, you feel like you could be better."
	mirror_options = PRIDE_MIRROR_OPTIONS

/obj/structure/mirror/magic/lesser/heretic/on_species_change(mob/living/carbon/human/race_changer, datum/species/newrace)
	. = ..()
	if(race_changer.dna?.species?.type == newrace.type)
		return
	atom_break(null)

/obj/structure/mirror/magic/lesser/heretic/atom_deconstruct(disassembled)
	new /obj/item/shard(loc) // never gives the frame back

/obj/structure/mirror/magic/lesser/heretic/welder_act(mob/living/user, obj/item/I)
	to_chat(user, span_alert(LANG("obj.5535e2df", list(src))))
	return ITEM_INTERACT_BLOCKING

/obj/structure/mirror/magic/lesser/heretic/pre_change(mob/living/carbon/human/user, picked)
	if(IS_HERETIC(user))
		return TRUE

	to_chat(user, span_hypnophrase(LANG("obj.c5875af2", list(src))))
	user.Immobilize(5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(change_something), user, picked), 5 SECONDS)
	return FALSE

/obj/structure/mirror/magic/lesser/heretic/proc/change_something(mob/living/carbon/human/user, picked)
	if(QDELETED(src) || QDELETED(user))
		return

	if(!user.Adjacent(src))
		to_chat(user, span_warning(LANG("obj.d19761b4", list(src))))
		return
	if(broken)
		to_chat(user, span_warning(LANG("obj.7a829ebc", list(src))))
		return

	// randomizes your stuff, doesn't affect DNA though so you could easily get genetics to fix you
	switch(picked)
		if(CHANGE_HAIR, CHANGE_BEARD)
			to_chat(user, span_hypnophrase(LANG("obj.8f4e4371", list(pick("it can be improved", "it needs to be changed", "it must be different")))))
			user.set_hairstyle(random_hairstyle(user.gender))
			user.set_facial_hairstyle(random_facial_hairstyle(user.gender))
		if(CHANGE_RACE)
			to_chat(user, span_hypnophrase(LANG("obj.f408e7ef", list(pick("I must become anew", "I need to be different", "I want to be something else")))))
			var/list/options = selectable_races.Copy() - user.dna.species.type
			var/datum/species/newrace = GLOB.species_prototypes[pick(options)]
			on_species_change(user, newrace)
			user.set_species(newrace.type, icon_update = FALSE)
		if(CHANGE_SEX)
			to_chat(user, span_hypnophrase(LANG("obj.c2d773c2", null))) // the wording used here needs to be very deliberate...
			var/list/options = list(MALE, FEMALE, PLURAL, NEUTER) - user.gender
			user.gender = pick(options)
			user.physique = user.gender
		if(CHANGE_EYES)
			to_chat(user, span_hypnophrase(LANG("obj.8e60a070", list(pick("They're simply not right", "they must be replaced", "they are both wrong")))))
			user.set_eye_color(random_eye_color())
		if(CHANGE_NAME) // not enabled by default but for badmin support
			to_chat(user, span_hypnophrase(LANG("obj.62d2d797", list(pick("Something else would be better", "it must be changed", "Something more appropriate would be good")))))
			user.real_name = user.generate_random_mob_name()
			user.update_visible_name()

/obj/structure/mirror/magic/badmin
	race_flags = MIRROR_BADMIN

/obj/structure/mirror/magic/pride
	name = "pride's mirror"
	desc = "Pride cometh before the..."
	race_flags = MIRROR_PRIDE
	mirror_options = PRIDE_MIRROR_OPTIONS
	/// If the last user has altered anything about themselves
	var/changed = FALSE

/obj/structure/mirror/magic/pride/pre_change(mob/living/carbon/human/user, picked)
	. = ..()
	changed = TRUE

/obj/structure/mirror/magic/pride/attack_hand(mob/living/carbon/human/user)
	changed = FALSE
	. = ..()
	if (!changed || QDELETED(user) || !IN_GIVEN_RANGE(user, src, 3)) // 3 range gives a tiny bit of leeway if you try to run away after using it
		return
	user.visible_message(
		span_bolddanger(LANG("obj.8181b64c", list(user, user.p_their()))),
		span_notice(LANG("obj.db85e607", null)),
	)

	var/turf/user_turf = get_turf(user)
	var/list/levels = SSmapping.levels_by_trait(ZTRAIT_SPACE_RUINS)
	var/turf/dest
	if(length(levels))
		dest = locate(user_turf.x, user_turf.y, pick(levels))

	user_turf.ChangeTurf(/turf/open/chasm, flags = CHANGETURF_INHERIT_AIR)
	var/turf/open/chasm/new_chasm = user_turf
	new_chasm.set_target(dest)
	new_chasm.drop(user)

#undef CHANGE_HAIR
#undef CHANGE_BEARD

#undef CHANGE_RACE
#undef CHANGE_SEX
#undef CHANGE_NAME
#undef CHANGE_EYES

#undef INERT_MIRROR_OPTIONS
#undef PRIDE_MIRROR_OPTIONS
#undef MAGIC_MIRROR_OPTIONS

#undef ROUNDSTART_CURSED_CHANCE
