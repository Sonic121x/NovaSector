/obj/item/graft
	/// Reagent list of the grafted seed, associative list of reagent types to reagent rate (see /datum/plant_gene/reagent)
	var/list/reagents_add

/obj/structure/flora/ash/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(src, /obj/structure/flora/ash/cacti))
		return ..()

	if(harvested && tool.get_sharpness())
		to_chat(user, span_notice("你开始刮掉[src]下方厚厚的灰烬层..."))
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, 10 SECONDS * skill_modifier, target = src))
			to_chat(user, span_warning("你决定不刮掉[src]下方厚厚的灰烬层了！"))
			return ITEM_INTERACT_BLOCKING

		if(prob(10))
			new /obj/item/food/tree_fruit(get_turf(src))
			to_chat(user, span_notice("你成功切掉了[src]下方的一大块东西，露出了某种树上保存下来的古老果实..."))
			user.mind?.adjust_experience(/datum/skill/primitive, 5)

		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		if(prob(20))
			qdel(src)

		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/item/food/tree_fruit
	name = "树果"
	desc = "一种来自树木、非常普通的果实——你不得不思考它来自哪里。"
	icon = 'modular_nova/modules/ashwalkers/icons/plant.dmi'
	icon_state = "treefruit"
	bite_consumption = 10
	max_volume = 100
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("sugary" = 1, "tart" = 1, "bitter" = 1)
	foodtypes = FRUIT

/// tree stage 1: small seedling
#define TREE_STAGE_ONE 1
/// tree stage 2: medium sapling
#define TREE_STAGE_TWO 2
/// tree stage 3: adult tree
#define TREE_STAGE_THREE 3

/obj/structure/simple_tree
	name = "树"
	desc = "无论是凭借纯粹的运气还是决心，这棵树在这地狱般的环境中幸存了下来——目前如此。这棵树若想生存下去，需要帮助！"
	icon = 'modular_nova/modules/ashwalkers/icons/tree.dmi'
	icon_state = "seedling"

	pixel_x = -32
	anchored = TRUE
	density = TRUE
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE

	/// whether the tree will process
	var/processing_tree = TRUE

	///the atom the farm is attached to
	var/atom/attached_atom

	/// the stage of the tree; at stage three, all functions are available depending on other variables
	var/tree_stage = TREE_STAGE_ONE
	/// the amount of fertilizer that has been applied to the tree, each increasing the chance to upgrade to the next
	var/fertilizer_amount = 0
	/// the cooldown between each processing
	COOLDOWN_DECLARE(process_cooldown)

	/// whether the tree has been tapped
	var/tapped_tree = FALSE
	/// the cooldown for collecting sap from the tree
	COOLDOWN_DECLARE(sap_cooldown)
	/// what the tree will produce from the tap
	var/tapped_reagent = /datum/reagent/consumable/sap

	/// the cooldown for being able to safely remove some branches from the tree for wood
	COOLDOWN_DECLARE(wood_cooldown)

	/// the list of grafts on the tree
	var/list/graft_list = list()
	/// the list of reagents from the grafted plants
	var/list/grafted_reagents = list()
	/// the cooldown for being able to harvest some fruits
	COOLDOWN_DECLARE(harvest_cooldown)

	/// the queen bee (if it exists) that is using this tree as a home
	var/obj/item/queen_bee/tree_bee
	/// the cooldown to collect a honeycomb from the tree/bee
	COOLDOWN_DECLARE(honeycomb_cooldown)

	/// how much maximum health the tree can have
	var/tree_max_health = 100
	/// how much current health the tree has
	var/tree_current_health = 100

/obj/structure/simple_tree/Initialize(mapload, atom/attaching_atom)
	. = ..()
	if(processing_tree)
		START_PROCESSING(SSobj, src)

	if(attaching_atom)
		attached_atom = attaching_atom
		if(!ismovable(attached_atom))
			return

		var/atom/movable/moving_atom = attached_atom
		src.glide_size = moving_atom.glide_size
		RegisterSignal(attached_atom, COMSIG_MOVABLE_MOVED, PROC_REF(move_tree))

/// used when the attached atom somehow moves
/obj/structure/simple_tree/proc/move_tree()
	SIGNAL_HANDLER

	if(QDELETED(attached_atom))
		return

	forceMove(get_turf(attached_atom))

/obj/structure/simple_tree/Destroy(force)
	QDEL_NULL(tree_bee)
	graft_list.Cut()
	attached_atom = null
	if(processing_tree)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/simple_tree/update_overlays()
	. = ..()
	cut_overlays()
	if(tree_stage < TREE_STAGE_THREE)
		return

	if(COOLDOWN_FINISHED(src, wood_cooldown))
		add_overlay("branch")

	if(COOLDOWN_FINISHED(src, harvest_cooldown))
		add_overlay("fruit")

	if(tapped_tree)
		add_overlay("sap")

		if(COOLDOWN_FINISHED(src, sap_cooldown))
			add_overlay("sapready")

	if(tree_bee)
		add_overlay("honey")

		if(COOLDOWN_FINISHED(src, honeycomb_cooldown))
			add_overlay("honeyready")

	for(var/graft_iterate in 1 to length(graft_list))
		add_overlay("grafted[graft_iterate]")

/obj/structure/simple_tree/update_icon_state()
	switch(tree_stage)
		if(TREE_STAGE_ONE)
			icon_state = "seedling"

		if(TREE_STAGE_TWO)
			icon_state = "sapling"

		if(TREE_STAGE_THREE)
			icon_state = "tree"

	return ..()

/obj/structure/simple_tree/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, process_cooldown))
		return

	COOLDOWN_START(src, process_cooldown, 30 SECONDS)
	if(tree_stage < TREE_STAGE_THREE)
		attempt_upgrade()
		adjust_health(-5)
		return

	if(prob(10) && !tree_bee)
		tree_bee = new /obj/item/queen_bee/bought(src)

	update_appearance(UPDATE_OVERLAYS)

/obj/structure/simple_tree/examine(mob/user)
	. = ..()
	switch(tree_stage)
		if(TREE_STAGE_ONE)
			. += span_notice("非常小！这棵树仍然是一株幼苗。")

		if(TREE_STAGE_TWO)
			. += span_notice("正在长大！这棵树现在确实是一株幼树了。")

		if(TREE_STAGE_THREE)
			. += span_notice("万岁！这棵树经受住了考验，已经完全长大了。")
			if(COOLDOWN_FINISHED(src, harvest_cooldown))
				. += span_notice("有些果实看起来已经可以采摘了。")

			if(COOLDOWN_FINISHED(src, wood_cooldown))
				. += span_notice("有些树枝看起来可以用锋利的东西砍下来。")

			if(length(graft_list) < 3)
				. += span_notice("你可以将其他植物的样本嫁接到这棵树上。")

			for(var/obj/item/graft/grafted_item in graft_list)
				. += span_notice("一个[grafted_item.plant_dna.plantname]的样本被嫁接在上面。")

			if(tree_bee)
				. += span_notice("可以看到一只巨大的蜂后在树周围飞舞。")
				if(COOLDOWN_FINISHED(src, honeycomb_cooldown))
					. += span_notice("蜂巢看起来可以收获了。使用一些切割器或刀具。")

			if(tapped_tree)
				. += span_notice("有一根导管从树的侧面伸出来。")
				if(COOLDOWN_FINISHED(src, sap_cooldown))
					. += span_notice("一些树液正从导管中渗出——收集它！")

			else
				. += span_notice("你可以用螺丝刀给这棵树安装导管。")

/obj/structure/simple_tree/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/worm_fertilizer))
		do_fertilizer(user, tool)
		return ITEM_INTERACT_SUCCESS

	if(tool.tool_behaviour == TOOL_KNIFE)
		attempt_honeycomb(user)
		return ITEM_INTERACT_SUCCESS

	if(tool.get_sharpness()) //doing this after the knife because assumedly, knives are sharp!
		attempt_woodmaking(user)
		return ITEM_INTERACT_SUCCESS

	if(tree_stage < TREE_STAGE_THREE)
		return ..()

	if(istype(tool, /obj/item/secateurs))
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, 10 SECONDS * skill_modifier, target = src))
			to_chat(user, span_warning("你决定不取下嫁接物！"))
			return ITEM_INTERACT_BLOCKING

		for(var/obj/item/graft/target_grafts in graft_list)
			target_grafts.forceMove(get_turf(user))
			user.mind?.adjust_experience(/datum/skill/primitive, 5)
			graft_list -= target_grafts

		update_graft_reagents()
		update_appearance(UPDATE_OVERLAYS)
		to_chat(user, span_notice("你决定从[src]上取下嫁接物。"))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/queen_bee))
		if(tree_bee)
			to_chat(user, span_warning("已经有一只蜂后了！"))
			return ITEM_INTERACT_BLOCKING

		tool.forceMove(src)
		tree_bee = tool
		to_chat(user, span_notice("你将[tool]添加到[src]。"))
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS

	if(is_reagent_container(tool))
		if(!COOLDOWN_FINISHED(src, sap_cooldown))
			to_chat(user, span_warning("[src]最近刚被安装了导管！"))
			return ITEM_INTERACT_BLOCKING

		COOLDOWN_START(src, sap_cooldown, 1 MINUTES)
		playsound(get_turf(src), SFX_TREE_CHOP, 50, vary = FALSE)
		var/obj/item/reagent_containers/container_tool = tool
		if(container_tool.is_refillable())
			if(!container_tool.reagents.holder_full())
				container_tool.reagents.add_reagent(tapped_reagent, 10)
				return ITEM_INTERACT_SUCCESS

			to_chat(user, span_warning("[tool]无法再装更多了！"))
			return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/graft))
		var/obj/item/graft/tool_graft = tool
		playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)
		to_chat(user, span_notice("你开始将[tool_graft.plant_dna.plantname]嫁接物嫁接到[src]上。"))
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, 10 SECONDS * skill_modifier, target = src))
			to_chat(user, span_warning("你决定放弃嫁接！"))
			return ITEM_INTERACT_BLOCKING

		playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)

		if(length(graft_list) >= 3)
			to_chat(user, span_warning("[src]已经满是嫁接物了！"))
			return ITEM_INTERACT_BLOCKING

		tool_graft.forceMove(src)
		graft_list += tool_graft
		to_chat(user, span_notice("你成功将[tool_graft.plant_dna.plantname]嫁接物嫁接到了[src]上。"))
		update_graft_reagents()
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/structure/simple_tree/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(tree_stage < TREE_STAGE_THREE)
		return ITEM_INTERACT_BLOCKING

	// if we are fruited, lets pick that first
	if(COOLDOWN_FINISHED(src, harvest_cooldown))
		COOLDOWN_START(src, harvest_cooldown, 30 SECONDS)
		update_appearance(UPDATE_OVERLAYS)
		playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		to_chat(user, span_notice("你从[src]收获了一些果实。"))
		var/turf/user_turf = get_turf(user)
		for(var/iteration in 1 to rand(1, 2))
			var/obj/item/food/tree_fruit/spawned_fruit = new /obj/item/food/tree_fruit(user_turf)
			for(var/adding_reagents in grafted_reagents)
				spawned_fruit.reagents.add_reagent(adding_reagents, 5)

		return

	// if not fruited, lets get the bee out if its there
	if(tree_bee)
		tree_bee.forceMove(get_turf(user))
		to_chat(user, span_warning("你将[tree_bee]从[src]中拉了出来！"))
		playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)
		tree_bee = null
		update_appearance(UPDATE_OVERLAYS)
		return

/obj/structure/simple_tree/wirecutter_act(mob/living/user, obj/item/tool)
	attempt_honeycomb(user)
	return ITEM_INTERACT_SUCCESS

/obj/structure/simple_tree/screwdriver_act(mob/living/user, obj/item/tool)
	if(tapped_tree)
		to_chat(user, span_warning("[src]已经安装过导管了！"))
		return ITEM_INTERACT_BLOCKING

	tap_tree(user, tool)
	return ITEM_INTERACT_SUCCESS

/// tapping the tree, to allow for drainage of sap; who, with what, tapping or untapping, how long, and if forced
/obj/structure/simple_tree/proc/tap_tree(mob/user, obj/item/tool, tapping_direction = TRUE, use_time = 4 SECONDS, forced_tool = FALSE)
	playsound(get_turf(src), SFX_TREE_CHOP, 50, vary = FALSE)
	if(!forced_tool)
		to_chat(user, span_notice("你开始对[src]使用[tool]..."))
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, use_time * tool.toolspeed * skill_modifier, target = src))
			to_chat(user, span_warning("你决定不对[src]使用[tool]！"))
			return

		to_chat(user, span_notice("你完成了对[src]使用[tool]！"))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		tool.forceMove(src)

	playsound(get_turf(src), SFX_TREE_CHOP, 50, vary = FALSE)
	tapped_tree = tapping_direction
	update_appearance(UPDATE_OVERLAYS)

/// applying fertilizer to the tree; who did it, with what, how long, how much use, how much give, and whether you've forced it (bypasses the usage)
/obj/structure/simple_tree/proc/do_fertilizer(mob/user, obj/item/tool, use_time = 2 SECONDS, use_amount = 1, given_amount = 1, forced_fertilizer = FALSE)
	playsound(src, 'sound/effects/shovel_dig.ogg', 50, TRUE)
	if(!forced_fertilizer)
		if(!tool.use(use_amount))
			to_chat(user, span_warning("你决定不对[src]使用[tool]！"))
			return

		to_chat(user, span_notice("你使用了[tool]，它治愈了[src]！"))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)

	adjust_health(5)
	playsound(src, 'sound/effects/shovel_dig.ogg', 50, TRUE)
	fertilizer_amount += given_amount

/// attempts to spawn a log, or damages it if it cannot
/obj/structure/simple_tree/proc/attempt_woodmaking(mob/user)
	if(!COOLDOWN_FINISHED(src, wood_cooldown) || tree_stage < TREE_STAGE_THREE)
		adjust_health(-50)
		to_chat(user, span_warning("你在试图收获时损坏了[src]！"))
		return

	COOLDOWN_START(src, wood_cooldown, 1 MINUTES)
	update_appearance(UPDATE_OVERLAYS)
	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		to_chat(user, span_warning("你笨拙地处理木材，把它弄成了无用的碎片！"))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		return

	playsound(get_turf(src), SFX_TREE_CHOP, 50, vary = FALSE)
	user.mind?.adjust_experience(/datum/skill/primitive, 10)
	new /obj/item/stack/sheet/mineral/wood(get_turf(user), 4)

/// attempts to spawn a honeycomb
/obj/structure/simple_tree/proc/attempt_honeycomb(mob/user)
	if(tree_stage < TREE_STAGE_THREE)
		adjust_health(-10)
		to_chat(user, span_warning("你在试图收获时损坏了[src]！"))
		return

	playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)
	if(!tree_bee || !COOLDOWN_FINISHED(src, honeycomb_cooldown))
		to_chat(user, span_warning("[src]上没有任何可收获的东西！"))
		return

	COOLDOWN_START(src, honeycomb_cooldown, 90 SECONDS)
	to_chat(user, span_notice("你开始从[src]收获蜂巢..."))
	update_appearance(UPDATE_OVERLAYS)
	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 10 SECONDS * skill_modifier, target = src))
		to_chat(user, span_warning("你不小心弄坏了蜂巢！"))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		return

	playsound(src, SFX_CRUNCHY_BUSH_WHACK, 50, vary = FALSE)
	for(var/iteration in 1 to rand(1, 2))
		var/obj/item/food/honeycomb/new_comb = new(get_turf(user))
		new_comb.set_reagent(tree_bee.queen.beegent.type)
	to_chat(user, span_notice("你成功从[src]收获了蜂巢。"))
	user.mind?.adjust_experience(/datum/skill/primitive, 10)
	return

/// attempts to stage up, which gets closer to having the full functions plus heals
/obj/structure/simple_tree/proc/attempt_upgrade()
	var/probability_chance = 10 + round(fertilizer_amount * 0.25)
	var/plant_present = FALSE
	for(var/obj/structure/simple_farm/found_farms in range(2, src))
		if(!istype(found_farms.planted_seed, /obj/item/seeds/lavaland/fireblossom) && !istype(found_farms.planted_seed, /obj/item/seeds/chili/ice))
			continue

		plant_present = TRUE

	if(locate(/obj/structure/flora/ash/fireblossom) in range(2, src) || locate(/obj/structure/flora/ash/chilly) in range(2, src))
		plant_present = TRUE

	if(plant_present)
		probability_chance += 10

	if(!prob(probability_chance))
		return

	for(var/obj/structure/simple_tree/surrounding_trees in range(2, src))
		if(surrounding_trees == src)
			continue

		if(prob(20))
			balloon_alert_to_viewers("feeling stiffed...")
			return

	fertilizer_amount = 0
	tree_stage = clamp(tree_stage + 1, TREE_STAGE_ONE, TREE_STAGE_THREE)
	update_appearance(UPDATE_ICON)
	tree_current_health = tree_max_health
	playsound(src, SFX_TREE_CHOP, 50, vary = FALSE)

/// updates the reagents that will be inserted into the product
/obj/structure/simple_tree/proc/update_graft_reagents()
	grafted_reagents.Cut() // have to reset it first of course
	for(var/obj/item/graft/grafted_item in graft_list)
		for(var/adding_reagent in grafted_item.reagents_add)
			grafted_reagents.Add(adding_reagent)

/// adjusts the trees health, clamped from 0 to the max health; if 0, will qdel the tree
/obj/structure/simple_tree/proc/adjust_health(damage_number)
	tree_current_health = clamp(tree_current_health + damage_number, 0, tree_max_health)
	playsound(get_turf(src), SFX_TREE_CHOP, 50, vary = FALSE)
	if(tree_current_health == 0)
		new /obj/item/stack/sheet/mineral/wood(get_turf(src), tree_stage * 3)
		qdel(src)

#undef TREE_STAGE_ONE
#undef TREE_STAGE_TWO
#undef TREE_STAGE_THREE
