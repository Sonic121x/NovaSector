// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/* This file contains standalone items for debug purposes. */
/obj/item/debug
	abstract_type = /obj/item/debug

/obj/item/debug/human_spawner
	name = "human spawner"
	desc = "Spawn a human by aiming at a turf and clicking. Use in hand to change type."
	icon = 'icons/obj/weapons/guns/magic.dmi'
	icon_state = "nothingwand"
	inhand_icon_state = "wand"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/datum/species/selected_species
	var/valid_species = list()

/obj/item/debug/human_spawner/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/debug/human_spawner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isturf(interacting_with))
		var/mob/living/carbon/human/H = new /mob/living/carbon/human(interacting_with)
		if(selected_species)
			H.set_species(selected_species)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/debug/human_spawner/attack_self(mob/user)
	. = ..()
	if(!user.client)
		return
	var/choice = input(LANG("obj.2dc4c8fd", null), LANG("obj.1df368e5", null), null) in sortTim(GLOB.species_list, GLOBAL_PROC_REF(cmp_text_asc))
	selected_species = GLOB.species_list[choice]

/obj/item/debug/omnitool
	name = "omnitool"
	desc = "The original hypertool, born before them all. Use it in hand to unleash its true power."
	icon = 'icons/obj/weapons/club.dmi'
	icon_state = "hypertool"
	inhand_icon_state = "hypertool"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	toolspeed = 0.1
	tool_behaviour = null

/obj/item/debug/omnitool/examine()
	. = ..()
	. += LANG("obj.ddeb8de7", list(tool_behaviour))

/obj/item/debug/omnitool/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/debug/omnitool/get_all_tool_behaviours()
	return GLOB.all_tool_behaviours

/obj/item/debug/omnitool/attack_self(mob/user)
	if(!user)
		return
	var/tool_result = show_radial_menu(user, src, GLOB.tool_to_image, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	tool_behaviour = tool_result

/obj/item/debug/omnitool/item_spawner
	name = "spawntool"
	color = COLOR_ADMIN_PINK

/obj/item/debug/omnitool/item_spawner/attack_self(mob/user)
	if(!user || !user.client)
		return
	var/path = text2path(tgui_input_text(user, LANG("obj.9bed81f6", null), LANG("obj.14b0d4d3", null)))
	if(!path)
		return
	var/choice = tgui_alert(user, LANG("obj.8fd665a9", null),, list("Yes", "No"))
	if(!choice)
		return
	if(!user.client.holder)
		if(!isliving(user))
			return
		var/mob/living/living_user = user
		to_chat(user, span_warning(LANG("obj.241e9faf", list(src))))
		playsound(src, 'sound/effects/dimensional_rend.ogg')
		sleep(4 SECONDS)
		var/confirmation = tgui_alert(user, LANG("obj.436da715", null), LANG("obj.be528354", null), list("Yes", "No"))
		if(!confirmation || confirmation == ("No"))
			return
		if(!user.client.holder) //safety if the admin readmined to save their ass lol.
			to_chat(user, span_reallybig(LANG("obj.df7c67c6", null)))
			playsound(src, 'sound/mobs/non-humanoids/cyborg/borg_deathsound.ogg')
			sleep(3 SECONDS)
			living_user.investigate_log("has been gibbed by [src].", INVESTIGATE_DEATHS)
			living_user.gib(DROP_ALL_REMAINS)
			return
	var/turf/loc_turf = get_turf(src)
	for(var/spawn_atom in (choice == "No" ? typesof(path) : subtypesof(path)))
		new spawn_atom(loc_turf)
