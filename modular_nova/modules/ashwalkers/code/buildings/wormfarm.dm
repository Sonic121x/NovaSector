/obj/structure/wormfarm
	name = "蠕虫养殖场"
	desc = "一个绝妙的脏污木桶，蠕虫们可以在里面过上幸福的小日子。"
	icon = 'modular_nova/modules/ashwalkers/icons/structures.dmi'
	icon_state = "wormbarrel"
	density = TRUE
	anchored = FALSE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)
	/// How many worms can the barrel hold
	var/max_worm = 10
	/// How many worms the barrel is currently holding
	var/current_worm = 0
	/// How much food was inserted into the barrel that needs to be composted
	var/current_food = 0
	/// If the barrel is currently being used by someone
	var/in_use = FALSE
	// The cooldown between each worm "breeding"
	COOLDOWN_DECLARE(worm_timer)

/obj/structure/wormfarm/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	COOLDOWN_START(src, worm_timer, 30 SECONDS)

/obj/structure/wormfarm/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

//process is currently only used for making more worms
/obj/structure/wormfarm/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, worm_timer))
		return

	COOLDOWN_START(src, worm_timer, 30 SECONDS)

	if(current_worm >= 2 && current_worm < max_worm)
		current_worm++

	if(current_food > 0 && current_worm > 1)
		current_food--
		new /obj/item/stack/worm_fertilizer(get_turf(src))

/obj/structure/wormfarm/examine(mob/user)
	. = ..()
	. += span_notice("<br>桶里目前有[current_worm]/[max_worm]条蠕虫。")
	if(current_worm < max_worm)
		. += span_notice("你可以往桶里放入更多蠕虫。")
	if(current_worm > 0)
		. += span_notice("你可以通过喂食蠕虫来获取肥料。")

/obj/structure/wormfarm/attack_hand(mob/living/user, list/modifiers)
	if(in_use)
		balloon_alert(user, "当前使用中")
		return ..()

	balloon_alert(user, "正在挖掘蠕虫")
	if(!do_after(user, 2 SECONDS, src))
		balloon_alert(user, "已停止挖掘")
		in_use = FALSE
		return ..()

	if(current_worm <= 0)
		balloon_alert(user, "没有可用的蠕虫")
		in_use = FALSE
		return ..()

	new /obj/item/food/bait/worm(get_turf(src))
	current_worm--
	in_use = FALSE

	return ..()

/obj/structure/wormfarm/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	//we want to check for worms first because they are a type of food as well...
	if(istype(tool, /obj/item/food/bait/worm))
		if(current_worm >= max_worm)
			balloon_alert(user, "桶里的蠕虫太多了")
			return ITEM_INTERACT_BLOCKING

		qdel(tool)
		balloon_alert(user, "蠕虫已放入桶中")
		current_worm++
		return ITEM_INTERACT_BLOCKING

	//if it aint a worm, lets check for any other food items
	if(istype(tool, /obj/item/food))
		if(in_use)
			balloon_alert(user, "正在使用中")
			return ITEM_INTERACT_BLOCKING
		in_use = TRUE

		balloon_alert(user, "正在喂食蠕虫")
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, 1 SECONDS * skill_modifier, src))
			balloon_alert(user, "停止喂食蠕虫")
			in_use = FALSE
			return ITEM_INTERACT_BLOCKING

		// if someone has built multiple worm farms, I want to make sure they can't just use one singular piece of food for more than one barrel
		if(!tool)
			in_use = FALSE
			return ITEM_INTERACT_BLOCKING

		qdel(tool)
		balloon_alert(user, "喂食完成，稍后再来查看")

		current_food++
		user.mind?.adjust_experience(/datum/skill/primitive, 2)
		if(prob(user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
			current_food += 2

		in_use = FALSE
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/storage/bag/plants))
		if(in_use)
			balloon_alert(user, "正在使用中")
			return ITEM_INTERACT_BLOCKING
		in_use = TRUE

		balloon_alert(user, "正在喂食蠕虫")
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		for(var/obj/item/food/selected_food in tool.contents)
			if(!do_after(user, 1 SECONDS * skill_modifier, src))
				in_use = FALSE
				return ITEM_INTERACT_BLOCKING

			qdel(selected_food)
			current_food++
			user.mind?.adjust_experience(/datum/skill/primitive, 2)
			if(prob(user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
				current_food += 2

		in_use = FALSE
		return ITEM_INTERACT_BLOCKING

	//it wasn't a worm, or a piece of food
	return ITEM_INTERACT_SUCCESS

//produced by feeding worms food and can be ground up for plant nutriment or used directly on ash farming
/obj/item/stack/worm_fertilizer
	name = "蠕虫肥料"
	desc = "当你喂养蠕虫时，就该料到这个结果。"
	icon = 'modular_nova/modules/ashwalkers/icons/misc_tools.dmi'
	icon_state = "fertilizer"
	singular_name = "fertilizer"
	merge_type = /obj/item/stack/worm_fertilizer

/obj/item/stack/worm_fertilizer/grind_results()
	return list(/datum/reagent/plantnutriment/eznutriment = 3, /datum/reagent/plantnutriment/left4zednutriment = 3, /datum/reagent/plantnutriment/robustharvestnutriment = 3)
