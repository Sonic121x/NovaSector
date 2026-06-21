//Bot Construction

/obj/item/bot_assembly
	icon = 'icons/mob/silicon/aibots.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 3
	throw_speed = 2
	throw_range = 5
	obj_flags = UNIQUE_RENAME | RENAME_NO_DESC
	var/created_name
	var/build_step = ASSEMBLY_FIRST_STEP
	var/robot_arm = /obj/item/bodypart/arm/right/robot

/obj/item/bot_assembly/nameformat(input, user)
	created_name = input
	return input

/obj/item/bot_assembly/rename_reset()
	created_name = initial(created_name)

/**
 * Checks if the user can finish constructing a bot with a given item.
 *
 * Arguments:
 * * tool - Item to be used
 * * user - Mob doing the construction
 * * drop_item - Whether or no the item should be dropped; defaults to 1. Should be set to 0 if the item is a tool, stack, or otherwise doesn't need to be dropped. If not set to 0, item must be deleted afterwards.
 */
/obj/item/bot_assembly/proc/can_finish_build(obj/item/tool, mob/user, drop_item = 1)
	if(istype(loc, /obj/item/storage/backpack))
		to_chat(user, span_warning("你必须先将[src]从[loc]中取出！"))
		return FALSE
	if(!tool || !user || (drop_item && !user.temporarilyRemoveItemFromInventory(tool)))
		return FALSE
	return TRUE

// Cleanbot assembly
/obj/item/bot_assembly/cleanbot
	desc = "这是一个装有传感器的桶。"
	name = "不完整的清洁机器人组装件"
	icon_state = "cleanbot_assembly"
	throwforce = 5
	created_name = "Cleanbot"
	var/obj/item/reagent_containers/cup/bucket/bucket_obj

/obj/item/bot_assembly/cleanbot/Initialize(mapload, obj/item/reagent_containers/cup/bucket/new_bucket)
	if(!new_bucket)
		new_bucket = new()
	new_bucket.forceMove(src)
	return ..()

/obj/item/bot_assembly/cleanbot/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(istype(arrived, /obj/item/reagent_containers/cup/bucket))
		if(bucket_obj && bucket_obj != arrived)
			qdel(bucket_obj)
		bucket_obj = arrived
	return ..()

/obj/item/bot_assembly/cleanbot/Exited(atom/movable/gone, direction)
	if(gone == bucket_obj)
		bucket_obj = null
	return ..()


/obj/item/bot_assembly/cleanbot/Destroy(force)
	QDEL_NULL(bucket_obj)
	return ..()


/obj/item/bot_assembly/cleanbot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/bodypart/arm/left/robot) && !istype(tool, /obj/item/bodypart/arm/right/robot))
		return NONE

	if(!can_finish_build(tool, user))
		return ITEM_INTERACT_BLOCKING

	var/mob/living/basic/bot/cleanbot/bot = new(drop_location())
	bucket_obj.forceMove(bot)
	bot.name = created_name
	bot.robot_arm = tool.type
	to_chat(user, span_notice("You add [tool] to [src]. Beep boop!"))
	qdel(tool)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

// Edbot Assembly
/obj/item/bot_assembly/ed209
	name = "不完整的 ED-209 组件"
	desc = "某种奇特的集合。"
	icon_state = "ed209_frame"
	inhand_icon_state = null
	created_name = "ED-209 Security Robot" //To preserve the name if it's a unique securitron I guess
	var/lasercolor = ""
	var/vest_type = /obj/item/clothing/suit/armor/vest

/obj/item/bot_assembly/ed209/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP, ASSEMBLY_SECOND_STEP)
			if(!istype(tool, /obj/item/bodypart/leg/left/robot) && !istype(tool, /obj/item/bodypart/leg/right/robot))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("You add [tool] to [src]."))
			qdel(tool)
			name = "腿部/框架组件"
			if(build_step == ASSEMBLY_FIRST_STEP)
				inhand_icon_state = "ed209_leg"
				icon_state = "ed209_leg"
			else
				inhand_icon_state = "ed209_legs"
				icon_state = "ed209_legs"
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_THIRD_STEP)
			if(!istype(tool, /obj/item/clothing/suit/armor/vest))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("You add [tool] to [src]."))
			qdel(tool)
			name = "主体/腿件/框架组件"
			inhand_icon_state = "ed209_shell"
			icon_state = "ed209_shell"
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_FOURTH_STEP)
			if(tool.tool_behaviour != TOOL_WELDER)
				return NONE
			if(!tool.use_tool(src, user, 0, volume=40))
				return ITEM_INTERACT_BLOCKING
			name = "防护框架组件"
			to_chat(user, span_notice("你将防弹背心焊接到[src]。"))
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_FIFTH_STEP)
			if(!istype(tool, /obj/item/clothing/head/helmet/sec))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("You add [tool] to [src]."))
			qdel(tool)
			name = "覆盖并防护的框架组件"
			inhand_icon_state = "ed209_hat"
			icon_state = "ed209_hat"
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SIXTH_STEP)
			if(!isprox(tool))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			build_step++
			to_chat(user, span_notice("You add [tool] to [src]."))
			qdel(tool)
			name = "覆盖、防护及感应装置的框架组件"
			inhand_icon_state = "ed209_prox"
			icon_state = "ed209_prox"
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SEVENTH_STEP)
			if(!istype(tool, /obj/item/stack/cable_coil))
				return NONE
			var/obj/item/stack/cable_coil/coil = tool
			if(coil.get_amount() < 1)
				to_chat(user, span_warning("你需要一根电缆来给ED-209接线！"))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("你开始给[src]接线..."))
			if(!do_after(user, 4 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING
			if(coil.get_amount() < 1 || build_step != ASSEMBLY_SEVENTH_STEP)
				return ITEM_INTERACT_BLOCKING
			coil.use(1)
			to_chat(user, span_notice("你给[src]接好了线。"))
			name = "有线 ED-209 组件"
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_EIGHTH_STEP)
			if(!istype(tool, /obj/item/gun/energy/disabler))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			name = "[tool.name] ED-209 assembly"
			to_chat(user, span_notice("You add [tool] to [src]."))
			inhand_icon_state = "ed209_taser"
			icon_state = "ed209_taser"
			qdel(tool)
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_NINTH_STEP)
			if(tool.tool_behaviour != TOOL_SCREWDRIVER)
				return NONE
			to_chat(user, span_notice("你开始将枪械安装到框架上..."))
			if(!tool.use_tool(src, user, 40, volume=100))
				return ITEM_INTERACT_BLOCKING
			var/mob/living/basic/bot/secbot/ed209/new_bot = new(drop_location())
			new_bot.name = created_name
			to_chat(user, span_notice("你完成了ED-209。"))
			qdel(src)
			return ITEM_INTERACT_SUCCESS

// Repairbot assemblies
/obj/item/bot_assembly/repairbot
	name = "维修机器人底盘"
	desc = "这是一个顶部伸出瓷砖的工具箱。"
	icon_state = "repairbot_box"
	throwforce = 10
	created_name = "Repairbot"
	///the toolbox our repairbot is made of
	var/toolbox = /obj/item/storage/toolbox/mechanical
	///the color of our toolbox
	var/toolbox_color = ""

/obj/item/bot_assembly/repairbot/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/bot_assembly/repairbot/proc/set_color(new_color)
	add_atom_colour(new_color, FIXED_COLOUR_PRIORITY)
	toolbox_color = new_color

/obj/item/bot_assembly/repairbot/update_desc()
	. = ..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			desc = "这是一个顶部伸出巨大显示器的工具箱！"
		else
			desc = initial(desc)

/obj/item/bot_assembly/repairbot/update_overlays()
	. = ..()
	if(build_step >= ASSEMBLY_FIRST_STEP)
		. += mutable_appearance(icon, "repairbot_base_sensor", appearance_flags = RESET_COLOR|KEEP_APART)
	if(build_step >= ASSEMBLY_SECOND_STEP)
		. += mutable_appearance(icon, "repairbot_base_arms", appearance_flags = RESET_COLOR|KEEP_APART)

/obj/item/bot_assembly/repairbot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(!istype(tool, /obj/item/bodypart/arm/left/robot) && !istype(tool, /obj/item/bodypart/arm/right/robot))
				return NONE
			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING
			build_step++
			to_chat(user, span_notice("You add [tool] to [src]. Boop beep!"))
			qdel(tool)
			update_appearance()
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(!istype(tool, /obj/item/stack/conveyor))
				return NONE
			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING
			var/mob/living/basic/bot/repairbot/repair = new(drop_location())
			repair.name = created_name
			repair.toolbox = toolbox
			repair.set_color(toolbox_color)
			to_chat(user, span_notice("You add [tool] to [src]. Boop beep!"))
			var/obj/item/stack/crafting_stack = tool
			crafting_stack.use(1)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

// Medbot Assembly
/obj/item/bot_assembly/medbot
	name = "未完成的医疗机器人组装"
	desc = "一个配备有永久性安装手臂的急救包。"
	icon_state = "medbot_assembly_generic"
	base_icon_state = "medbot_assembly"
	created_name = "Medibot" //To preserve the name if it's a unique medbot I guess
	var/skin = null //Same as medbot, set to tox or ointment for the respective kits.
	var/healthanalyzer = /obj/item/healthanalyzer
	var/medkit_type = /obj/item/storage/medkit

/obj/item/bot_assembly/medbot/proc/set_skin(skin)
	src.skin = skin
	if(skin)
		icon_state = "[base_icon_state]_[skin]"

/obj/item/bot_assembly/medbot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(!istype(tool, /obj/item/healthanalyzer))
				return NONE
			// NOVA EDIT ADDITION BEGIN -- EXTRA ROBOTICS HEALTH ANALYZERS
			var/obj/item/healthanalyzer/analyzer = tool
			if (!analyzer.can_be_used_in_medibot())
				user?.balloon_alert(user, "没有附件接口！")
				return
			// NOVA EDIT ADDITION END
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			healthanalyzer = tool.type
			to_chat(user, span_notice("You add [tool] to [src]."))
			qdel(tool)
			name = "急救包/机械臂/健康分析仪组装件"
			add_overlay("[base_icon_state]_analyzer")
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(!isprox(tool))
				return NONE
			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING
			qdel(tool)
			var/mob/living/basic/bot/medbot/medbot = new(drop_location(), skin)
			to_chat(user, span_notice("你完成了医疗机器人。哔哔！"))
			medbot.name = created_name
			medbot.medkit_type = medkit_type
			medbot.robot_arm = robot_arm
			medbot.health_analyzer = healthanalyzer
			var/obj/item/storage/medkit/medkit = medkit_type
			medbot.damage_type_healer = initial(medkit.damagetype_healed) ? initial(medkit.damagetype_healed) : BRUTE
			qdel(src)
			return ITEM_INTERACT_SUCCESS


// Honkbot Assembly
/obj/item/bot_assembly/honkbot
	name = "不完整的honkbot组件"
	desc = "这个小丑又在搞坏事了"
	icon_state = "honkbot_arm"
	created_name = "Honkbot"

/obj/item/bot_assembly/honkbot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(!isprox(tool))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("You add the [tool] to [src]!"))
			icon_state = "honkbot_proxy"
			name = "不完整的honkbot组件"
			qdel(tool)
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(!istype(tool, /obj/item/bikehorn))
				return NONE
			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("You add the [tool] to [src]! Honk!"))
			var/mob/living/basic/bot/secbot/honkbot/new_honkbot = new(drop_location())
			new_honkbot.name = created_name
			playsound(new_honkbot, 'sound/machines/ping.ogg', 50, TRUE, -1)
			qdel(tool)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

// Secbot Assembly
/obj/item/bot_assembly/secbot
	name = "不完整的保卫机器人组件"
	desc = "某种奇特的装置，由一个接近传感器、头盔和信号器组成。"
	icon_state = "helmet_signaler"
	inhand_icon_state = "helmet"
	lefthand_file = 'icons/mob/inhands/clothing/hats_righthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/hats_lefthand.dmi'
	created_name = "Securitron" // To preserve the name if it's a unique securitron I guess
	/// If you're converting it into a grievousbot, how many swords have you attached
	var/swordamt = 0
	/// Honk
	var/toyswordamt = 0

/obj/item/bot_assembly/secbot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/atom/drop_loc = drop_location()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(tool.tool_behaviour == TOOL_WELDER)
				if(!tool.use_tool(src, user, 0, volume=40))
					return ITEM_INTERACT_BLOCKING
				add_overlay("hs_hole")
				to_chat(user, span_notice("你在[src]上焊出了一个洞！"))
				build_step++
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour != TOOL_SCREWDRIVER) //deconstruct
				return NONE

			new /obj/item/assembly/signaler(drop_loc)
			new /obj/item/clothing/head/helmet/sec(drop_loc)
			to_chat(user, span_notice("你将信号器从头盔上拆了下来。"))
			qdel(src)
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(tool))
				if(!user.temporarilyRemoveItemFromInventory(tool))
					return ITEM_INTERACT_BLOCKING
				to_chat(user, span_notice("You add [tool] to [src]!"))
				add_overlay("hs_eye")
				name = "头盔/信号器/接近传感器组装件"
				qdel(tool)
				build_step++
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour != TOOL_WELDER) //deconstruct
				return NONE

			if(!tool.use_tool(src, user, 0, volume=40))
				return ITEM_INTERACT_BLOCKING

			cut_overlay("hs_hole")
			to_chat(user, span_notice("你将[src]上的洞焊死了！"))
			build_step--
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_THIRD_STEP)
			if((istype(tool, /obj/item/bodypart/arm/left/robot)) || (istype(tool, /obj/item/bodypart/arm/right/robot)))
				if(!user.temporarilyRemoveItemFromInventory(tool))
					return ITEM_INTERACT_BLOCKING
				to_chat(user, span_notice("You add [tool] to [src]!"))
				name = "头盔/信号器/接近传感器/机械臂组装件"
				add_overlay("hs_arm")
				robot_arm = tool.type
				qdel(tool)
				build_step++
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour != TOOL_SCREWDRIVER) //deconstruct
				return NONE

			cut_overlay("hs_eye")
			new /obj/item/assembly/prox_sensor(drop_loc)
			to_chat(user, span_notice("你将接近传感器从[src]上拆了下来。"))
			build_step--
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_FOURTH_STEP)
			if(istype(tool, /obj/item/melee/baton/security))
				if(!can_finish_build(tool, user))
					return ITEM_INTERACT_BLOCKING
				to_chat(user, span_notice("你完成了安全机器人！哔哔。"))
				var/mob/living/basic/bot/secbot/new_bot = new(drop_loc)
				new_bot.name = created_name
				new_bot.baton_type = tool.type
				new_bot.robot_arm = robot_arm
				qdel(tool)
				qdel(src)
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("你调整了[src]的武器槽位以安装额外武器。"))
				build_step++
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				cut_overlay("hs_arm")
				var/obj/item/bodypart/dropped_arm = new robot_arm(drop_loc)
				robot_arm = null
				to_chat(user, span_notice("你将[dropped_arm]从[src]上移除了。"))
				build_step--
				if(toyswordamt > 0 || toyswordamt)
					toyswordamt = 0
					icon_state = initial(icon_state)
					to_chat(user, span_notice("将[src]的玩具剑粘在底盘上的强力胶断裂了！"))
					for(var/IS in 1 to toyswordamt)
						new /obj/item/toy/sword(drop_loc)
				return ITEM_INTERACT_SUCCESS

			if(!istype(tool, /obj/item/toy/sword))
				return NONE

			if(toyswordamt < 3 && swordamt <= 0)
				if(!user.temporarilyRemoveItemFromInventory(tool))
					return ITEM_INTERACT_BLOCKING
				created_name = "General Beepsky"
				name = "头盔/信号器/接近传感器/机械臂/玩具剑组装件"
				icon_state = "grievous_assembly"
				to_chat(user, span_notice("You superglue [tool] onto one of [src]'s arm slots."))
				qdel(tool)
				toyswordamt++
				return ITEM_INTERACT_SUCCESS

			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice("你完成了安全机器人！……它看起来好像有点不对劲..？"))
			var/mob/living/basic/bot/secbot/grievous/toy/new_bot = new(drop_loc)
			new_bot.name = created_name
			new_bot.robot_arm = robot_arm
			qdel(tool)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_FIFTH_STEP)
			if(tool.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				build_step--
				swordamt = 0
				icon_state = initial(icon_state)
				to_chat(user, span_notice("你卸下了[src]的能量剑螺栓。"))
				for(var/IS in 1 to swordamt)
					new /obj/item/melee/energy/sword/saber(drop_loc)
				return ITEM_INTERACT_SUCCESS

			if(!istype(tool, /obj/item/melee/energy/sword/saber))
				return NONE

			if(swordamt < 3)
				if(!user.temporarilyRemoveItemFromInventory(tool))
					return ITEM_INTERACT_BLOCKING
				created_name = "General Beepsky"
				name = "头盔/信号器/接近传感器/机械臂/能量剑组装件"
				icon_state = "grievous_assembly"
				to_chat(user, span_notice("You bolt [tool] onto one of [src]'s arm slots."))
				qdel(tool)
				swordamt++
				return ITEM_INTERACT_SUCCESS

			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice("你完成了安全机器人！……它看起来好像有点不对劲..？"))
			var/mob/living/basic/bot/secbot/grievous/new_bot = new(drop_loc)
			new_bot.name = created_name
			new_bot.robot_arm = robot_arm
			qdel(tool)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

//Firebot Assembly
/obj/item/bot_assembly/firebot
	name = "不完整的消防机器人组件"
	desc = "一个带有手臂的灭火器。"
	icon_state = "firebot_arm"
	created_name = "Firebot"

/obj/item/bot_assembly/firebot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(!istype(tool, /obj/item/clothing/head/utility/hardhat/red))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			to_chat(user,span_notice("You add the [tool] to [src]!"))
			icon_state = "firebot_helmet"
			desc = "一个尚未完全组装好的消防机器人，其头部装备有消防头盔。"
			qdel(tool)
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(!isprox(tool))
				return NONE
			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("You add the [tool] to [src]! Beep Boop!"))
			var/mob/living/basic/bot/firebot/firebot = new(drop_location())
			firebot.name = created_name
			qdel(tool)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

//Get cleaned
/obj/item/bot_assembly/hygienebot
	name = "不完整的卫生机器人组件"
	desc = "谁屙这了？!！"
	icon_state = "hygienebot"
	created_name = "Hygienebot"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/bot_assembly/hygienebot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/atom/drop_loc = drop_location()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(tool.tool_behaviour == TOOL_WELDER) //Construct
				if(!tool.use_tool(src, user, 0, volume=40))
					return ITEM_INTERACT_BLOCKING
				to_chat(user, span_notice("你在[src]上焊接了一个进水口！"))
				build_step++
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour != TOOL_WRENCH) //Deconstruct
				return NONE
			if(!tool.use_tool(src, user, 0, volume=40))
				return ITEM_INTERACT_BLOCKING
			new /obj/item/stack/sheet/iron(drop_loc, 2)
			to_chat(user, span_notice("你断开了清洁机器人组件的连接。"))
			qdel(src)
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(tool)) //Construct
				if(!user.temporarilyRemoveItemFromInventory(tool))
					return ITEM_INTERACT_BLOCKING

				build_step++
				to_chat(user, span_notice("You add [tool] to [src]."))
				qdel(tool)
				return ITEM_INTERACT_SUCCESS

			if(tool.tool_behaviour != TOOL_WELDER) //Deconstruct
				return NONE

			if(!tool.use_tool(src, user, 0, volume=30))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice("你焊接封闭了[src]上的进水口！"))
			build_step--
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_THIRD_STEP)
			if(!can_finish_build(tool, user, 0))
				return ITEM_INTERACT_BLOCKING

			if(tool.tool_behaviour == TOOL_SCREWDRIVER) //deconstruct
				new /obj/item/assembly/prox_sensor(drop_loc)
				to_chat(user, span_notice("你从[src]上拆下了接近传感器。"))
				build_step--
				return ITEM_INTERACT_SUCCESS

			if(!istype(tool, /obj/item/stack/ducts)) //Construct
				return NONE

			var/obj/item/stack/ducts/D = tool
			if(D.get_amount() < 1)
				to_chat(user, span_warning("你需要一根流体管道来完成[src]"))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("你开始为[src]铺设管道……"))
			if(!do_after(user, 4 SECONDS, target = src) && D.use(1))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice("你为[src]铺设好了管道。"))
			var/mob/living/basic/bot/hygienebot/new_bot = new(drop_location())
			new_bot.name = created_name
			qdel(src)
			return ITEM_INTERACT_SUCCESS

// Vim Assembly
/obj/item/bot_assembly/vim
	name = "不完整的 vim 组件组装"
	desc = "一个带有腿部部件的太空头盔。看起来如果要变成一件东西的话，还需要再加一条腿。"
	icon_state = "vim_0"
	created_name = "\improper Vim"

/obj/item/bot_assembly/vim/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(!istype(tool, /obj/item/bodypart/leg/left/robot) && !istype(tool, /obj/item/bodypart/leg/right/robot))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_BLOCKING
			balloon_alert(user, "腿部已安装")
			icon_state = "vim_1"
			desc = "某种不完整的装置。看起来缺少了车头灯。"
			qdel(tool)
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_SECOND_STEP)
			if(!istype(tool, /obj/item/flashlight))
				return NONE
			if(!user.temporarilyRemoveItemFromInventory(tool))
				return ITEM_INTERACT_SUCCESS
			balloon_alert(user, "手电筒已添加")
			icon_state = "vim_2"
			desc = "存在某种不完善的机制。手电筒被加装了进去，但并未固定好。"
			qdel(tool)
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_THIRD_STEP)
			if(tool.tool_behaviour != TOOL_SCREWDRIVER)
				return NONE
			balloon_alert(user, "正在固定手电筒...")
			if(!tool.use_tool(src, user, 4 SECONDS, volume=100))
				return ITEM_INTERACT_BLOCKING
			balloon_alert(user, "手电筒已固定")
			icon_state = "vim_3"
			desc = "某种不完整的装置。它看起来差不多已经完成了，只是还需要安装一个语音组件。"
			build_step++
			return ITEM_INTERACT_SUCCESS

		if(ASSEMBLY_FOURTH_STEP)
			if(!istype(tool, /obj/item/assembly/voice))
				return NONE
			if(!can_finish_build(tool, user))
				return ITEM_INTERACT_BLOCKING
			balloon_alert(user, "组装完成")
			var/obj/vehicle/sealed/car/vim/new_vim = new(drop_location())
			new_vim.name = created_name
			qdel(tool)
			qdel(src)
			return ITEM_INTERACT_SUCCESS
