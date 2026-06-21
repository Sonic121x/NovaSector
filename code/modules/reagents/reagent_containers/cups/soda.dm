
//////////////////////////soda_cans//
//These are in their own group to be used as IED's in /obj/item/grenade/ghettobomb.dm
/// How much fizziness is added to the can of soda by throwing it, in percentage points
#define SODA_FIZZINESS_THROWN 15
/// How much fizziness is added to the can of soda by shaking it, in percentage points
#define SODA_FIZZINESS_SHAKE 5
/// At what atmospheric pressure do we burst a soda can? Empirical evidance (one googled experiment video) states that ~67.458 kPa is where a can bursts.
#define SODA_EXPLOSION_PRESSURE 67.458

/obj/item/reagent_containers/cup/soda_cans
	name = "饮料罐"
	icon = 'icons/obj/drinks/soda.dmi'
	icon_state = "cola"
	icon_state_preview = "cola"
	abstract_type = /obj/item/reagent_containers/cup/soda_cans
	initial_reagent_flags = NONE
	custom_price = PAYCHECK_CREW * 0.9
	obj_flags = CAN_BE_HIT
	possible_transfer_amounts = list(5, 10, 15, 25, 30)
	volume = 30
	throwforce = 12 // set to 0 upon being opened. Have you ever been domed by a soda can? Those things fucking hurt
	/// If the can hasn't been opened yet, this is the measure of how fizzed up it is from being shaken or thrown around. When opened, this is rolled as a percentage chance to burst
	var/fizziness = 0
	/// Have we been sealed with tape? And if so, what color is it?
	var/tape_color = null
	/// Color of our fuse, if any
	var/fuse_color = null
	/// Timer for our explosion
	var/fuse_timer = null

/obj/item/reagent_containers/cup/soda_cans/Initialize(mapload, vol)
	. = ..()
	AddElement(/datum/element/slapcrafting, string_list(list(/datum/crafting_recipe/improv_explosive)))
	AddElement(/datum/element/atmos_sensitive, mapload) //Enables soda cans to explode in vaccuum.

/obj/item/reagent_containers/cup/soda_cans/random/Initialize(mapload)
	..()
	var/T = pick(subtypesof(/obj/item/reagent_containers/cup/soda_cans) - /obj/item/reagent_containers/cup/soda_cans/random)
	new T(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/reagent_containers/cup/soda_cans/suicide_act(mob/living/carbon/human/H)
	if(!reagents.total_volume)
		H.visible_message(span_warning("[H]正试图从[src]里猛喝一大口……罐子是空的！"))
		return SHAME
	if(!is_drainable())
		open_soda(H)
		sleep(1 SECONDS)
	H.visible_message(span_suicide("[H]从[src]里猛喝了一大口！看起来[H.p_theyre()]想自杀！"))
	playsound(H,'sound/items/drink.ogg', 80, TRUE)
	reagents.trans_to(H, src.reagents.total_volume, transferred_by = H) //a big sip
	sleep(0.5 SECONDS)
	H.say(pick(
		"Now, Outbomb Cuban Pete, THAT was a game.",
		"All these new fangled arcade games are too slow. I prefer the classics.",
		"They don't make 'em like Orion Trail anymore.",
		"You know what they say. Worst day of spess carp fishing is better than the best day at work.",
		"They don't make 'em like good old-fashioned singularity engines anymore.",
	))
	if(H.age >= 30)
		H.Stun(50)
		sleep(5 SECONDS)
		playsound(H,'sound/items/drink.ogg', 80, TRUE)
		H.say(pick(
			"Another day, another dollar.",
			"I wonder if I should hold?",
			"Diversifying is for young'ns.",
			"Yeap, times were good back then.",
		))
		return MANUAL_SUICIDE_NONLETHAL
	sleep(2 SECONDS) //dramatic pause
	return TOXLOSS

/obj/item/reagent_containers/cup/soda_cans/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!iscarbon(target) || reagents.total_volume || !user.combat_mode || user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	if(target == user)
		user.visible_message(
			span_warning("[user]把[src]的罐子砸在[user.p_their()]额头上！"),
			span_notice("你把[src]的罐子砸在自己额头上。"),
		)
	else
		user.visible_message(
			span_warning("[user]把[src]的罐子砸在[target]的额头上！"),
			span_notice("你把[src]的罐子砸在[target]的额头上。"),
		)
	playsound(src, 'sound/items/weapons/pierce.ogg', rand(10, 50), TRUE)
	var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(target.drop_location())
	crushed_can.icon_state = icon_state
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/cup/soda_cans/bullet_act(obj/projectile/proj)
	. = ..()
	if(QDELETED(src))
		return
	if(!proj.damage || proj.damage_type != BRUTE)
		return
	var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(loc)
	crushed_can.icon_state = icon_state
	var/atom/throw_target = get_edge_target_turf(crushed_can, pick(GLOB.alldirs))
	crushed_can.throw_at(throw_target, rand(1,2), 7)
	qdel(src)

/obj/item/reagent_containers/cup/soda_cans/proc/open_soda(mob/user)
	if(tape_color)
		to_chat(user, "你撕掉了盖住[src]洞口的胶带。")
		playsound(user, 'sound/items/duct_tape/duct_tape_rip.ogg', 50, TRUE)
		tape_color = null
		add_container_flags(OPENCONTAINER)
		update_appearance()
		return

	if(prob(fizziness))
		user.visible_message(span_danger("[user]打开了[src]，突然被嘶嘶作响的内容物喷了一身！"), span_danger("你拉开[src]的拉环，突然被一股液体喷了一身！啊！！"))
		burst_soda(user)
		return

	to_chat(user, "你拉开[src]的拉环，发出令人满足的'噗'声。") //Ahhhhhhhh
	add_container_flags(OPENCONTAINER)
	playsound(src, SFX_CAN_OPEN, 50, TRUE)
	throwforce = 0

/**
 * Burst the soda open on someone. Fun! Opens and empties the soda can, but does not crush it.
 *
 * Arguments:
 * * target - Who's getting covered in soda
 * * hide_message - Stops the generic fizzing message, so you can do your own
 */
/obj/item/reagent_containers/cup/soda_cans/proc/burst_soda(atom/target, hide_message = FALSE)
	if(!target)
		return

	if(ismob(target))
		var/mob/living/target_mob = target
		target_mob.add_mood_event("soda_spill", /datum/mood_event/soda_spill, src)
		for(var/mob/living/iter_mob in view(src, 7))
			if(iter_mob != target)
				iter_mob.add_mood_event("observed_soda_spill", /datum/mood_event/observed_soda_spill, target, src)

	playsound(src, 'sound/items/can/can_pop.ogg', 80, TRUE)
	if(!hide_message)
		visible_message(span_danger("[src]喷涌而出，嘶嘶作响的内容物溅了[target]一身！"))
	add_container_flags(OPENCONTAINER)
	reagents.expose(target, TOUCH)
	reagents.clear_reagents()
	throwforce = 0

/obj/item/reagent_containers/cup/soda_cans/wirecutter_act(mob/living/user, obj/item/tool)
	if (!fuse_color)
		return NONE
	to_chat(user, span_notice("你剪掉了[src]的引信。"))
	tool.play_tool_sound(src, 50)
	add_fingerprint(user)
	fuse_color = null
	if (!isnull(fuse_timer))
		deltimer(fuse_timer)
		fuse_timer = null
		log_bomber(user, "has disarmed", src)
	if (heatable)
		AddElement(/datum/element/reagents_item_heatable)
	update_appearance()

/obj/item/reagent_containers/cup/soda_cans/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (istype(tool, /obj/item/stack/cable_coil))
		if (fuse_color)
			to_chat(user, span_warning("[src]已经装上了引信！"))
			return ITEM_INTERACT_BLOCKING

		if (tape_color)
			to_chat(user, span_warning("[src]的洞口被胶带封住了！"))
			return ITEM_INTERACT_BLOCKING

		if (!is_drainable())
			to_chat(user, span_warning("[src] 还没被打开！"))
			return ITEM_INTERACT_BLOCKING

		var/obj/item/stack/cable_coil/coil = tool
		var/coil_color = GLOB.cable_colors[coil.cable_color]
		add_fingerprint(user)
		if (!coil.use(1))
			return ITEM_INTERACT_BLOCKING

		fuse_color = coil_color
		// Heating replaced with lighting the fuse
		RemoveElement(/datum/element/reagents_item_heatable)
		to_chat(user, span_notice("你将一根引信装到了[src]上。"))
		log_bomber(user, "attached a fuse to", src)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if (istype(tool, /obj/item/stack/medical/wrap/sticky_tape))
		if (tape_color)
			to_chat(user, span_warning("[src]的洞已经被胶带封住了！"))
			return ITEM_INTERACT_BLOCKING

		if (!is_drainable())
			to_chat(user, span_warning("[src]还没被打开过！"))
			return ITEM_INTERACT_BLOCKING

		var/obj/item/stack/medical/wrap/sticky_tape/tape = tool
		var/list/tape_colors = SSgreyscale.ParseColorString(tape.greyscale_colors)
		add_fingerprint(user)
		if (!tape.use(1))
			return ITEM_INTERACT_BLOCKING

		tape_color = tape_colors[1]
		to_chat(user, span_notice("你用[src]把[tape]包了起来。"))
		reset_container_flags()
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if (!fuse_color || tool.get_temperature() < FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		return ..()

	if (fuse_timer)
		to_chat(user, span_warning("[src] 已经点燃了！"))
		return ITEM_INTERACT_BLOCKING

	add_fingerprint(user)
	log_bomber(user, "has primed a rigged", src)
	to_chat(user, span_warning("你点燃了[src]的引信！"))
	fuse_timer = addtimer(CALLBACK(src, PROC_REF(try_detonate)), rand(2 SECONDS, 4 SECONDS))
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/cup/soda_cans/proc/try_detonate()
	var/spark_flags = SPARK_ACT_WEAKEN_COMMON
	if (tape_color)
		spark_flags |= SPARK_ACT_ENCLOSED

	playsound(src, 'sound/effects/sparks/sparks1.ogg', 50, TRUE)
	if (reagents.spark_act(0, spark_flags) & SPARK_ACT_DESTRUCTIVE)
		qdel(src)
		return

	// Was a dud
	fuse_color = null
	tape_color = null
	add_container_flags(OPENCONTAINER)
	if (heatable)
		AddElement(/datum/element/reagents_item_heatable)
	update_appearance()

/obj/item/reagent_containers/cup/soda_cans/update_overlays()
	. = ..()
	if (fuse_color)
		var/mutable_appearance/fuse_overlay = mutable_appearance('icons/obj/weapons/grenade.dmi', "improvised_grenade_fuse")
		fuse_overlay.color = fuse_color
		. += fuse_overlay

	if (tape_color)
		var/mutable_appearance/tape_overlay = mutable_appearance('icons/obj/weapons/grenade.dmi', "improvised_grenade_tape")
		tape_overlay.color = tape_color
		. += tape_overlay

	if (fuse_timer)
		. += mutable_appearance('icons/obj/weapons/grenade.dmi', "improvised_grenade_active")

/obj/item/reagent_containers/cup/soda_cans/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. || is_open_container() || !reagents.total_volume || tape_color) // if it was caught, already opened, or has nothing in it
		return

	fizziness += SODA_FIZZINESS_THROWN
	if(!prob(fizziness))
		return

	burst_soda(hit_atom, hide_message = TRUE)
	visible_message(span_danger("[src] 与 [hit_atom] 的撞击导致它破裂，液体洒得到处都是！"))
	var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(loc)
	crushed_can.icon_state = icon_state
	moveToNullspace()
	QDEL_IN(src, 1 SECONDS) // give it a second so it can still be logged for the throw impact

/obj/item/reagent_containers/cup/soda_cans/attack_self(mob/user)
	if(fuse_timer)
		balloon_alert(user, "引信着火了！")
		return

	if(!is_drainable())
		open_soda(user)
		return

	return ..()

/obj/item/reagent_containers/cup/soda_cans/attack_self_secondary(mob/user)
	if(!is_drainable())
		playsound(src, 'sound/items/can/can_shake.ogg', 50, TRUE)
		user.visible_message(span_danger("[user] 摇晃着 [src]！"), span_danger("You shake up [src]!"), vision_distance=2)
		fizziness += SODA_FIZZINESS_SHAKE
		return
	return ..()

/obj/item/reagent_containers/cup/soda_cans/examine_more(mob/user)
	. = ..()
	if(!in_range(user, src))
		return
	if(fizziness > 30 && prob(fizziness * 2))
		. += span_notice("<i>你更仔细地检查了[src]，并注意到以下内容...</i>")
		. += "\t[span_warning("You get a menacing aura of fizziness from it...")]"

/obj/item/reagent_containers/cup/soda_cans/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return ((air.return_pressure() <= SODA_EXPLOSION_PRESSURE) && !(reagents.flags & OPENCONTAINER))

/obj/item/reagent_containers/cup/soda_cans/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(reagents.total_volume && !(reagents.flags & OPENCONTAINER))
		burst_soda(loc)

#undef SODA_FIZZINESS_THROWN
#undef SODA_FIZZINESS_SHAKE
#undef SODA_EXPLOSION_PRESSURE

/obj/item/reagent_containers/cup/soda_cans/cola
	name = "太空可乐"
	desc = "上了太空的可乐。"
	icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/space_cola = 30)
	drink_type = SUGAR

/obj/item/reagent_containers/cup/soda_cans/tonic
	name = "T-Borg通宁水"
	desc = "奎宁尝起来怪怪的，但至少它可以防止得太空疟疾。"
	icon_state = "tonic"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/tonic = 50)
	drink_type = ALCOHOL

/obj/item/reagent_containers/cup/soda_cans/sodawater
	name = "苏打水"
	desc = "一听苏打水。来做一杯威士忌苏打吧？"
	icon_state = "sodawater"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)

/obj/item/reagent_containers/cup/soda_cans/lemon_lime
	name = "橙子苏打水"
	desc = "你想要橙子味，它就给你加了柠檬酸橙。"
	icon_state = "lemon-lime"
	list_reagents = list(/datum/reagent/consumable/lemon_lime = 30)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/soda_cans/lemon_lime/Initialize(mapload)
	. = ..()
	name = "柠檬-酸橙苏打水"

/obj/item/reagent_containers/cup/soda_cans/sol_dry
	name = "Sol Dry-日灼干姜"
	desc = "也许这会让你的小肚子感觉更好，又或许不会。"
	icon_state = "sol_dry"
	list_reagents = list(/datum/reagent/consumable/sol_dry = 30)
	drink_type = SUGAR

/obj/item/reagent_containers/cup/soda_cans/space_up
	name = "空喜！"
	desc = "喝起来就像你嘴里发生了外壳破洞！"
	icon_state = "space-up"
	list_reagents = list(/datum/reagent/consumable/space_up = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/starkist
	name = "星吻"
	desc = "液态星星的味道。还带一点金枪鱼味…？"
	icon_state = "starkist"
	list_reagents = list(/datum/reagent/consumable/space_cola = 15, /datum/reagent/consumable/orangejuice = 15)
	drink_type = SUGAR | FRUIT | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/space_mountain_wind
	name = "太空山风"
	desc = "就像太空风一样吹拂你。"
	icon_state = "space_mountain_wind"
	list_reagents = list(/datum/reagent/consumable/spacemountainwind = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/thirteenloko
	name = "十三乐可"
	desc = "首席医务官已明确告知船员：十三乐可会导致癫痫发作、失明、醉酒，甚至死亡。请适量饮用。"
	icon_state = "thirteen_loko"
	list_reagents = list(/datum/reagent/consumable/ethanol/thirteenloko = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/dr_gibb
	name = "胡言博士"
	desc = "有着42种不同口味的美味混合饮品。"
	icon_state = "dr_gibb"
	list_reagents = list(/datum/reagent/consumable/dr_gibb = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/pwr_game
	name = "泡玩"
	desc = "真正的玩家才喝的“泡玩”饮料。当一个游戏玩家提起游戏燃料时，其实指的是这款饮料。"
	icon_state = "purple_can"
	list_reagents = list(/datum/reagent/consumable/pwr_game = 30)

/obj/item/reagent_containers/cup/soda_cans/shamblers
	name = "空虚果汁"
	desc = "~给我摇起点空虚果汁!~"
	icon_state = "shamblers"
	list_reagents = list(/datum/reagent/consumable/shamblers = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/shamblers/eldritch
	name = "Shambler果汁 古神能量！"
	desc = "~J'I'CE!~"
	icon_state = "shamblerseldritch"
	volume = 40
	list_reagents = list(/datum/reagent/consumable/shamblers = 30, /datum/reagent/eldritch = 5)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/wellcheers
	name = "Wellcheers果汁"
	desc = "一种奇怪的紫色饮料，闻起来有咸水味。在遥远的某处，你听到了海鸥的叫声。"
	icon_state = "wellcheers"
	list_reagents = list(/datum/reagent/consumable/wellcheers = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/grey_bull
	name = "灰牛"
	desc = "喝灰牛，你的手套超乎你想象！"
	icon_state = "energy_drink"
	list_reagents = list(/datum/reagent/consumable/grey_bull = 20)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/monkey_energy
	name = "猴之力量"
	desc = "释放心猿！"
	icon_state = "monkey_energy"
	inhand_icon_state = "monkey_energy"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/monkey_energy = 50)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/volt_energy
	name = "24伏特能量饮料"
	desc = "充电，就用24伏能量！"
	icon_state = "volt_energy"
	list_reagents = list(/datum/reagent/consumable/volt_energy = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/melon_soda
	name = "Kansumi 蜜瓜汽水"
	desc = "日本最受欢迎的蜜瓜苏打，现已推出罐装版！"
	icon_state = "melon_soda"
	list_reagents = list(/datum/reagent/consumable/melon_soda = 30)
	drink_type = SUGAR | JUNKFOOD

/obj/item/reagent_containers/cup/soda_cans/air
	name = "罐装空气"
	desc = "没有空气短缺。别真喝下去了。"
	icon_state = "air"
	list_reagents = list(/datum/reagent/nitrogen = 24, /datum/reagent/oxygen = 6)

/obj/item/reagent_containers/cup/soda_cans/beer
	name = "太空啤酒"
	desc = "罐装啤酒。在太空中。"
	icon_state = "space_beer"
	volume = 40
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 40)
	drink_type = GRAIN

/obj/item/reagent_containers/cup/soda_cans/beer/rice
	name = "米啤酒"
	desc = "一种在火星上流行的清淡、以大米为基础的拉格啤酒。根据1516年的《啤酒纯净法》，这被视为对巴伐利亚人的仇恨犯罪。"
	icon_state = "ebisu"
	list_reagents = list(/datum/reagent/consumable/ethanol/rice_beer = 40)

/obj/item/reagent_containers/cup/soda_cans/beer/rice/Initialize(mapload)
	. = ..()
	var/brand = pick("Ebisu Super Dry", "Shimauma Ichiban", "Moonlabor Malt's")
	name = "[brand]"
	switch(brand)
		if("Ebisu Super Dry")
			icon_state = "ebisu"
			desc = "火星最受欢迎的米啤酒品牌，畅销200年。"
		if("Shimauma Ichiban")
			icon_state = "shimauma"
			desc = "Mars' most middling rice beer brand. Not as popular as Ebisu, but it's comfortable in second place."
		if("Moonlabor Malt's")
			icon_state = "moonlabor"
			desc = "火星的米啤酒黑马品牌。不知为何在黑道中很受欢迎。"
