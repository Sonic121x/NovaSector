/* This file contains standalone items for debug purposes. */
/obj/item/debug
	abstract_type = /obj/item/debug

/obj/item/debug/human_spawner
	name = "人类生成器"
	desc = "瞄准一个地块并点击以生成人类。在手中使用以更改类型。"
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
	..()
	var/choice = input("选择一个物种", "人类生成器", null) in sortTim(GLOB.species_list, GLOBAL_PROC_REF(cmp_text_asc))
	selected_species = GLOB.species_list[choice]

/obj/item/debug/omnitool
	name = "万能工具"
	desc = "最初的超级工具，诞生于所有同类之前。在手中使用以释放其真正力量。"
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
	. += " The mode is: [tool_behaviour]"

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
	name = "生成工具"
	color = COLOR_ADMIN_PINK

/obj/item/debug/omnitool/item_spawner/attack_self(mob/user)
	if(!user || !user.client)
		return
	var/path = text2path(tgui_input_text(user, "输入要生成的物品类型路径", "仅限管理员。胡搞瞎搞，后果自负。"))
	if(!path)
		return
	var/choice = tgui_alert(user, "仅限子类型？",, list("Yes", "No"))
	if(!choice)
		return
	if(!user.client.holder)
		if(!isliving(user))
			return
		var/mob/living/living_user = user
		to_chat(user, span_warning("当你试图使用[src]时，你听到了奇怪的撕裂声，仿佛代码之神正试图亲自伸出手来掐死你。"))
		playsound(src, 'sound/effects/dimensional_rend.ogg')
		sleep(4 SECONDS)
		var/confirmation = tgui_alert(user, "你确定要这么做吗？", "仅限管理员。最后机会。", list("Yes", "No"))
		if(!confirmation || confirmation == ("No"))
			return
		if(!user.client.holder) //safety if the admin readmined to save their ass lol.
			to_chat(user, span_reallybig("你不该那么做的……"))
			playsound(src, 'sound/mobs/non-humanoids/cyborg/borg_deathsound.ogg')
			sleep(3 SECONDS)
			living_user.investigate_log("has been gibbed by [src].", INVESTIGATE_DEATHS)
			living_user.gib(DROP_ALL_REMAINS)
			return
	var/turf/loc_turf = get_turf(src)
	for(var/spawn_atom in (choice == "No" ? typesof(path) : subtypesof(path)))
		new spawn_atom(loc_turf)
