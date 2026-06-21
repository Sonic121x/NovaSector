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
	name = "炮塔框架"
	icon = 'icons/obj/weapons/turrets.dmi'
	icon_state = "turret_frame"
	desc = "未完成的有盖炮塔框架"
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
			. += span_notice("外部螺栓<b>未拧紧</b>，框架可以<i>撬开</i>。")
		if(PTURRET_BOLTED)
			. += span_notice("框架需要<b>金属</b>作为内部装甲，外部螺栓已<i>拧紧</i>就位。")
		if(PTURRET_START_INTERNAL_ARMOUR)
			. += span_notice("炮塔装甲需要<b>螺栓固定</b>就位，装甲看起来可以<i>焊接拆除</i>。")
		if(PTURRET_INTERNAL_ARMOUR_ON)
			. += span_notice("炮塔需要一个<b>能量型枪械</b>才能运作，装甲由<i>螺栓</i>固定。")
		if(PTURRET_GUN_EQUIPPED)
			. += span_notice("炮塔需要一个<b>接近传感器</b>才能运行。能量枪可以<i>被拆除</i>。")
		if(PTURRET_SENSORS_ON)
			. += span_notice("炮塔检修口<b>未上螺丝</b>。接近传感器可以<i>被移除</i>。")
		if(PTURRET_CLOSED)
			. += span_notice("炮塔需要<b>金属</b>作为外部装甲，检修口可以<i>拧开螺丝</i>。")
		if(PTURRET_START_EXTERNAL_ARMOUR)
			. += span_notice("炮塔装甲需要<b>焊接</b>固定，装甲看起来可以<i>撬下来</i>。")

/obj/machinery/porta_turret_construct/attackby(obj/item/used, mob/user, list/modifiers, list/attack_modifiers)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(PTURRET_UNSECURED) //first step
			if(used.tool_behaviour == TOOL_WRENCH && !anchored)
				used.play_tool_sound(src, 100)
				to_chat(user, span_notice("你固定好了外部螺栓。"))
				set_anchored(TRUE)
				build_step = PTURRET_BOLTED
				return

			else if(used.tool_behaviour == TOOL_CROWBAR && !anchored)
				used.play_tool_sound(src, 75)
				to_chat(user, span_notice("你拆解了炮塔结构。"))
				new /obj/item/stack/sheet/iron(loc, 5)
				qdel(src)
				return

		if(PTURRET_BOLTED)
			if(istype(used, /obj/item/stack/sheet/iron))
				var/obj/item/stack/sheet/iron/sheet = used
				if(sheet.use(2))
					to_chat(user, span_notice("你为内部框架添加了一些金属装甲。"))
					build_step = PTURRET_START_INTERNAL_ARMOUR
					icon_state = "turret_frame2"
				else
					to_chat(user, span_warning("You need two sheets of iron to continue construction!"))
				return

			else if(used.tool_behaviour == TOOL_WRENCH)
				used.play_tool_sound(src, 75)
				to_chat(user, span_notice("你松开了外部螺栓。"))
				set_anchored(FALSE)
				build_step = PTURRET_UNSECURED
				return


		if(PTURRET_START_INTERNAL_ARMOUR)
			if(used.tool_behaviour == TOOL_WRENCH)
				used.play_tool_sound(src, 100)
				to_chat(user, span_notice("你用螺栓将金属装甲固定到位。"))
				build_step = PTURRET_INTERNAL_ARMOUR_ON
				return

			else if(used.tool_behaviour == TOOL_WELDER)
				if(!used.tool_start_check(user, amount = 5)) //uses up 5 fuel
					return

				to_chat(user, span_notice("你开始移除炮塔的内部金属装甲..."))

				if(used.use_tool(src, user, 20, volume = 50, amount = 5)) //uses up 5 fuel
					build_step = PTURRET_BOLTED
					to_chat(user, span_notice("你移除了炮塔的内部金属装甲。"))
					new /obj/item/stack/sheet/iron(drop_location(), 2)
					return


		if(PTURRET_INTERNAL_ARMOUR_ON)
			if(istype(used, /obj/item/gun/energy)) //the gun installation part
				var/obj/item/gun/energy/egun = used
				if(egun.gun_flags & TURRET_INCOMPATIBLE)
					to_chat(user, span_notice("你觉得把[used]加到炮塔上不太合适"))
					return
				if(!user.transferItemToLoc(egun, src))
					return
				installed_gun = egun
				to_chat(user, span_notice("你将[used]添加到了炮塔上。"))
				build_step = PTURRET_GUN_EQUIPPED
				return
			else if(used.tool_behaviour == TOOL_WRENCH)
				used.play_tool_sound(src, 100)
				to_chat(user, span_notice("你移除了炮塔的金属装甲螺栓。"))
				build_step = PTURRET_START_INTERNAL_ARMOUR
				return

		if(PTURRET_GUN_EQUIPPED)
			if(isprox(used))
				build_step = PTURRET_SENSORS_ON
				if(!user.temporarilyRemoveItemFromInventory(used))
					return
				to_chat(user, span_notice("你将距离传感器添加到炮塔上。"))
				qdel(used)
				return


		if(PTURRET_SENSORS_ON)
			if(used.tool_behaviour == TOOL_SCREWDRIVER)
				used.play_tool_sound(src, 100)
				build_step = PTURRET_CLOSED
				to_chat(user, span_notice("你关闭了内部访问舱口。"))
				return


		if(PTURRET_CLOSED)
			if(istype(used, /obj/item/stack/sheet/iron))
				var/obj/item/stack/sheet/iron/sheet = used
				if(sheet.use(2))
					to_chat(user, span_notice("你将一些金属装甲添加到外部框架上。"))
					build_step = PTURRET_START_EXTERNAL_ARMOUR
				else
					to_chat(user, span_warning("You need two sheets of iron to continue construction!"))
				return

			else if(used.tool_behaviour == TOOL_SCREWDRIVER)
				used.play_tool_sound(src, 100)
				build_step = PTURRET_SENSORS_ON
				to_chat(user, span_notice("你开启了内部访问舱口。"))
				return

		if(PTURRET_START_EXTERNAL_ARMOUR)
			if(used.tool_behaviour == TOOL_WELDER)
				if(!used.tool_start_check(user, amount = 5))
					return

				to_chat(user, span_notice("你开始焊接炮塔的装甲..."))
				if(used.use_tool(src, user, 30, volume = 50, amount = 5))
					build_step = PTURRET_EXTERNAL_ARMOUR_ON
					to_chat(user, span_notice("你焊接了炮塔的装甲。"))

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
					return

			else if(used.tool_behaviour == TOOL_CROWBAR)
				used.play_tool_sound(src, 75)
				to_chat(user, span_notice("你撬开了炮塔的外部装甲。"))
				new /obj/item/stack/sheet/iron(loc, 2)
				build_step = PTURRET_CLOSED
				return

	if(used.get_writing_implement_details()?["interaction_mode"] == MODE_WRITING) //you can rename turrets like bots!
		var/choice = tgui_input_text(user, "输入新的炮塔名称", "炮塔分类", finish_name, max_length = MAX_NAME_LEN)
		if(!choice)
			return
		if(!user.can_perform_action(src))
			return

		finish_name = choice
		return
	return ..()

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
			to_chat(user, span_notice("你从炮塔框架中移除了[installed_gun]。"))
			installed_gun = null

		if(PTURRET_SENSORS_ON)
			to_chat(user, span_notice("你从炮塔框架中移除了距离传感器。"))
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
