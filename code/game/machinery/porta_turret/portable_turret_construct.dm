// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define PTURRET_UNSECURED  0
#define PTURRET_BOLTED  1
#define PTURRET_START_INTERNAL_ARMOUR  2
#define PTURRET_INTERNAL_ARMOUR_ON  3
#define PTURRET_GUN_EQUIPPED  4
#define PTURRET_SENSORS_ON  5
#define PTURRET_CLOSED  6
#define PTURRET_START_EXTERNAL_ARMOUR  7
#define PTURRET_EXTERNAL_ARMOUR_ON  8

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/weapons/turrets.dmi'
	icon_state = "turret_frame"
	desc = "An unfinished covered turret frame."
	anchored = FALSE
	density = TRUE
	obj_flags = UNIQUE_RENAME | RENAME_NO_DESC
	use_power = NO_POWER_USE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
	var/build_step = PTURRET_UNSECURED //the current step in the building process
	var/finish_name = "turret" //the name applied to the product turret
	var/obj/item/gun/installed_gun = null

/obj/machinery/porta_turret_construct/examine(mob/user)
	. = ..()
	switch(build_step)
		if(PTURRET_UNSECURED)
			. += span_notice(LANG("obj.a84cc4810875c88e", null))
		if(PTURRET_BOLTED)
			. += span_notice(LANG("obj.2470ea4426377025", null))
		if(PTURRET_START_INTERNAL_ARMOUR)
			. += span_notice(LANG("obj.6e7d0497afc8b04a", null))
		if(PTURRET_INTERNAL_ARMOUR_ON)
			. += span_notice(LANG("obj.8b2585d8cb342cfc", null))
		if(PTURRET_GUN_EQUIPPED)
			. += span_notice(LANG("obj.96cd04824962f8a5", null))
		if(PTURRET_SENSORS_ON)
			. += span_notice(LANG("obj.df8ffaef8988522c", null))
		if(PTURRET_CLOSED)
			. += span_notice(LANG("obj.fba70fe5a698d9d0", null))
		if(PTURRET_START_EXTERNAL_ARMOUR)
			. += span_notice(LANG("obj.fe8219597ab66426", null))

/obj/machinery/porta_turret_construct/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(PTURRET_BOLTED)
			if(!istype(tool, /obj/item/stack/sheet/iron))
				return NONE
			var/obj/item/stack/sheet/iron/sheet = tool
			if(!sheet.use(2))
				to_chat(user, span_warning(LANG("obj.04b62eca8f816390", null)))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice(LANG("obj.4851aacec1ef2028", null)))
			build_step = PTURRET_START_INTERNAL_ARMOUR
			icon_state = "turret_frame2"
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_INTERNAL_ARMOUR_ON)
			if(!istype(tool, /obj/item/gun/energy)) //the gun installation part
				return NONE
			var/obj/item/gun/energy/egun = tool
			if(egun.gun_flags & TURRET_INCOMPATIBLE)
				to_chat(user, span_notice(LANG("obj.778e73ad822e886a", list(tool))))
				return ITEM_INTERACT_BLOCKING
			if(!user.transferItemToLoc(egun, src))
				return ITEM_INTERACT_BLOCKING
			installed_gun = egun
			to_chat(user, span_notice(LANG("obj.8d75ca3c3aef8898", list(tool))))
			build_step = PTURRET_GUN_EQUIPPED
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_GUN_EQUIPPED)
			if(!isprox(tool))
				return NONE
			build_step = PTURRET_SENSORS_ON
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice(LANG("obj.9155598b4b6c26e7", null)))
			qdel(tool)
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_CLOSED)
			if(!istype(tool, /obj/item/stack/sheet/iron))
				return NONE
			var/obj/item/stack/sheet/iron/sheet = tool
			if(!sheet.use(2))
				to_chat(user, span_warning(LANG("obj.04b62eca8f816390", null)))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice(LANG("obj.79e65025a4b15291", null)))
			build_step = PTURRET_START_EXTERNAL_ARMOUR
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/machinery/porta_turret_construct/wrench_act(mob/living/user, obj/item/tool)
	switch(build_step)
		if(PTURRET_UNSECURED)
			tool.play_tool_sound(src, 100)
			to_chat(user, span_notice(LANG("obj.f7528b3f08c30430", null)))
			set_anchored(TRUE)
			build_step = PTURRET_BOLTED
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_BOLTED)
			tool.play_tool_sound(src, 75)
			to_chat(user, span_notice(LANG("obj.bcca06ea9f06193f", null)))
			set_anchored(FALSE)
			build_step = PTURRET_UNSECURED
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_START_INTERNAL_ARMOUR)
			tool.play_tool_sound(src, 100)
			to_chat(user, span_notice(LANG("obj.aba62bc7e842e72c", null)))
			build_step = PTURRET_INTERNAL_ARMOUR_ON
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_INTERNAL_ARMOUR_ON)
			tool.play_tool_sound(src, 100)
			to_chat(user, span_notice(LANG("obj.c4d29f8148edda98", null)))
			build_step = PTURRET_START_INTERNAL_ARMOUR
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_SKIP_TO_ATTACK

/obj/machinery/porta_turret_construct/crowbar_act(mob/living/user, obj/item/tool)
	switch(build_step)
		if(PTURRET_UNSECURED)
			tool.play_tool_sound(src, 75)
			to_chat(user, span_notice(LANG("obj.3b9141f08c10ee6a", null)))
			new /obj/item/stack/sheet/iron(loc, 5)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_START_EXTERNAL_ARMOUR)
			tool.play_tool_sound(src, 75)
			to_chat(user, span_notice(LANG("obj.9a6d42fe7275a4fa", null)))
			new /obj/item/stack/sheet/iron(loc, 2)
			build_step = PTURRET_CLOSED
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_SKIP_TO_ATTACK

/obj/machinery/porta_turret_construct/welder_act(mob/living/user, obj/item/tool)
	switch(build_step)
		if(PTURRET_START_INTERNAL_ARMOUR)
			if(!tool.tool_start_check(user, amount = 5)) //uses up 5 fuel
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice(LANG("obj.5ed7eef08d006c41", null)))
			if(!tool.use_tool(src, user, 20, volume = 50, amount = 5)) //uses up 5 fuel
				return ITEM_INTERACT_BLOCKING
			build_step = PTURRET_BOLTED
			to_chat(user, span_notice(LANG("obj.30973bfa26bc2a7c", null)))
			new /obj/item/stack/sheet/iron(drop_location(), 2)
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_START_EXTERNAL_ARMOUR)
			if(!tool.tool_start_check(user, amount = 5))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice(LANG("obj.2d1b1711ccd8b6b5", null)))
			if(!tool.use_tool(src, user, 30, volume = 50, amount = 5))
				return ITEM_INTERACT_BLOCKING
			build_step = PTURRET_EXTERNAL_ARMOUR_ON
			to_chat(user, span_notice(LANG("obj.37af307fb41bf5de", null)))

			//The final step: create a full turret

			var/obj/machinery/porta_turret/turret
			//fuck lasertag turrets
			if(istype(installed_gun, /obj/item/gun/energy/laser/bluetag) || istype(installed_gun, /obj/item/gun/energy/laser/redtag))
				turret = new/obj/machinery/porta_turret/lasertag(loc)
			else
				turret = new/obj/machinery/porta_turret(loc)
			turret.name = finish_name
			turret.installation = installed_gun.type
			turret.setup(installed_gun)
			turret.locked = FALSE
			qdel(src)
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_SKIP_TO_ATTACK

/obj/machinery/porta_turret_construct/screwdriver_act(mob/living/user, obj/item/tool)
	switch(build_step)
		if(PTURRET_SENSORS_ON)
			tool.play_tool_sound(src, 100)
			build_step = PTURRET_CLOSED
			to_chat(user, span_notice(LANG("obj.37f20c651b02c340", null)))
			return ITEM_INTERACT_SUCCESS

		if(PTURRET_CLOSED)
			tool.play_tool_sound(src, 100)
			build_step = PTURRET_SENSORS_ON
			to_chat(user, span_notice(LANG("obj.18593ec271714b18", null)))
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_SKIP_TO_ATTACK

/obj/machinery/porta_turret_construct/nameformat(input, user)
	finish_name = input
	return input

/obj/machinery/porta_turret_construct/rename_reset()
	finish_name = initial(finish_name)

/obj/machinery/porta_turret_construct/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	switch(build_step)
		if(PTURRET_GUN_EQUIPPED)
			build_step = PTURRET_INTERNAL_ARMOUR_ON

			installed_gun.forceMove(loc)
			to_chat(user, span_notice(LANG("obj.4c752c2be748bd24", list(installed_gun))))
			installed_gun = null

		if(PTURRET_SENSORS_ON)
			to_chat(user, span_notice(LANG("obj.dc8d81b4b4e5dae5", null)))
			new /obj/item/assembly/prox_sensor(loc)
			build_step = PTURRET_GUN_EQUIPPED

/obj/machinery/porta_turret_construct/attack_ai()
	return

#undef PTURRET_BOLTED
#undef PTURRET_CLOSED
#undef PTURRET_EXTERNAL_ARMOUR_ON
#undef PTURRET_GUN_EQUIPPED
#undef PTURRET_INTERNAL_ARMOUR_ON
#undef PTURRET_SENSORS_ON
#undef PTURRET_START_EXTERNAL_ARMOUR
#undef PTURRET_START_INTERNAL_ARMOUR
#undef PTURRET_UNSECURED
