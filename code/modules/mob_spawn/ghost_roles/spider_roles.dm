/obj/structure/spider/eggcluster
	name = "卵簇"
	icon = 'icons/effects/effects.dmi'
	desc = "里面有活物，迟早会找到出路。"
	icon_state = "eggs"
	/// Mob spawner handling the actual spawn of the spider
	var/obj/effect/mob_spawn/ghost_role/spider/spawner

/obj/structure/spider/eggcluster/Initialize(mapload)
	pixel_x = base_pixel_x + rand(3,-3)
	pixel_y = base_pixel_y + rand(3,-3)
	return ..()

/obj/structure/spider/eggcluster/Destroy()
	if(spawner)
		QDEL_NULL(spawner)
	return ..()

/obj/structure/spider/eggcluster/attack_ghost(mob/user)
	if(spawner)
		spawner.attack_ghost(user)
	return ..()

/obj/structure/spider/eggcluster/examine_more(mob/user)
	. = ..()

	if(istype(user, /mob/living/basic/spider/giant/midwife))
		switch(spawner.amount_grown)
			if(0 to 24)
				. += span_info("这些卵看起来萎缩且处于休眠状态。")
			if(25 to 49)
				. += span_info("这些卵已经开始移动，脉动着，孕育着……")
			if(50 to 74)
				. += span_info("这些卵在波动，看不见的生命在其表皮之下蠢动。")
			if(75 to 99)
				. += span_info("这些卵因看不见的生命而膨胀。它们几乎要爆裂了。")
			if(100 to INFINITY)
				. += span_info("这些卵饱满丰盈，充满了生命。随时可能……")

/obj/structure/spider/eggcluster/abnormal
	name = "异常卵簇"
	color = rgb(0, 148, 211)

/obj/structure/spider/eggcluster/enriched
	name = "强化卵簇"
	color = rgb(148, 0, 211)

/obj/structure/spider/eggcluster/bloody
	icon = 'icons/mob/simple/meteor_heart.dmi'
	icon_state = "eggs"
	name = "血腥卵簇"

/obj/structure/spider/eggcluster/midwife
	name = "蛛母卵簇"

/obj/effect/mob_spawn/ghost_role/spider
	name = "卵簇"
	desc = "它们似乎带着一种内在的生命力微微地跳动着。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "eggs"
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	show_flavor = FALSE
	you_are_text = "你是一只蜘蛛。"
	flavour_text = "为了蜂群！选择一种蜘蛛并履行你的职责来接管空间站……当然，前提是这符合你的指令。"
	important_text = "不惜一切代价遵循你的指令。"
	faction = list(FACTION_SPIDER)
	spawner_job_path = /datum/job/spider
	role_ban = ROLE_ALIEN
	prompt_ghost = FALSE
	/// Prevents spawning from this mob_spawn until TRUE, set by the egg growing
	var/ready = FALSE
	/// The amount the egg cluster has grown.  Is able to produce a spider when it hits 100.
	var/amount_grown = 0
	/// The mother's directive at the time the egg was produced.  Passed onto the child.
	var/directive = ""
	///	Type of the cluster that the spawner spawns
	var/cluster_type = /obj/structure/spider/eggcluster
	/// Physical structure housing the spawner
	var/obj/structure/spider/eggcluster/egg
	/// Which antag datum do we grant?
	var/granted_datum = /datum/antagonist/spider
	/// The types of spiders that the spawner can produce
	var/list/potentialspawns = list(
		/mob/living/basic/spider/growing/spiderling/nurse,
		/mob/living/basic/spider/growing/spiderling/hunter,
		/mob/living/basic/spider/growing/spiderling/ambush,
		/mob/living/basic/spider/growing/spiderling/tangle,
		/mob/living/basic/spider/growing/spiderling/guard,
		/mob/living/basic/spider/growing/spiderling/scout,
	)
	/// Do we flash the byond window when this particular egg type is available?
	var/flash_window = FALSE

/obj/effect/mob_spawn/ghost_role/spider/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	potentialspawns = string_list(potentialspawns)
	egg = new cluster_type(get_turf(loc))
	egg.spawner = src
	forceMove(egg)

/obj/effect/mob_spawn/ghost_role/spider/Destroy()
	egg = null
	return ..()

/obj/effect/mob_spawn/ghost_role/spider/process(seconds_per_tick)
	amount_grown += rand(5, 15) * seconds_per_tick
	if(amount_grown >= 100 && !ready)
		ready = TRUE
		var/notify_flags_to_pass = NOTIFY_CATEGORY_NOFLASH
		if(flash_window)
			notify_flags_to_pass &= GHOST_NOTIFY_FLASH_WINDOW
		notify_ghosts(
			"[src] is ready to hatch!",
			source = src,
			header = "Spider Infestation",
			click_interact = TRUE,
			ignore_key = POLL_IGNORE_SPIDER,
			notify_flags = notify_flags_to_pass,
		)
		STOP_PROCESSING(SSobj, src)

/obj/effect/mob_spawn/ghost_role/spider/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["activate"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)
			attack_ghost(ghost)

/obj/effect/mob_spawn/ghost_role/spider/allow_spawn(mob/user, silent = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!ready)
		if(!silent)
			to_chat(user, span_warning("\The [src] 还没准备好孵化！"))
		return FALSE
	return TRUE

/obj/effect/mob_spawn/ghost_role/spider/special(mob/living/basic/spider/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	if (isspider(spawned_mob))
		spawned_mob.directive = directive
	egg.spawner = null
	QDEL_NULL(egg)
	var/datum/antagonist/spider/spider_antag = new granted_datum(directive)
	spawned_mob.mind.add_antag_datum(spider_antag)

/obj/effect/mob_spawn/ghost_role/spider/abnormal
	name = "异常卵簇"
	color = rgb(0, 148, 211)
	cluster_type = /obj/structure/spider/eggcluster/abnormal
	potentialspawns = list(
		/mob/living/basic/spider/growing/spiderling/tank,
		/mob/living/basic/spider/growing/spiderling/viper,
	)
	flash_window = TRUE

/obj/effect/mob_spawn/ghost_role/spider/enriched
	name = "强化卵簇"
	color = rgb(148, 0, 211)
	you_are_text = "你是一只强化蜘蛛。"
	cluster_type = /obj/structure/spider/eggcluster/enriched
	potentialspawns = list(
		/mob/living/basic/spider/growing/spiderling/tarantula,
		/mob/living/basic/spider/growing/spiderling/breacher,
		/mob/living/basic/spider/growing/spiderling/midwife,
	)
	flash_window = TRUE

/obj/effect/mob_spawn/ghost_role/spider/bloody
	name = "血腥卵簇"
	icon = 'icons/mob/simple/meteor_heart.dmi'
	icon_state = "eggs"
	you_are_text = "你是一只血肉蜘蛛。"
	flavour_text = "一个由异形寄生物种投放到空间站的、自然界的畸形产物。你唯一的目标就是杀戮、制造恐怖并生存下去。"
	faction = null
	directive = null
	cluster_type = /obj/structure/spider/eggcluster/bloody
	potentialspawns = list(
		/mob/living/basic/flesh_spider,
	)
	flash_window = TRUE
	granted_datum = /datum/antagonist/spider/flesh

/obj/effect/mob_spawn/ghost_role/spider/midwife
	name = "蛛母卵簇"
	you_are_text = "你是一只助产蜘蛛。"
	flavour_text = "你是蜘蛛群的核心。你拥有繁殖并创造更多蜘蛛的能力，还能将受害者转化为特殊的蜘蛛卵。"
	directive = "Ensure the survival of the spider species and overtake whatever structure you find yourself in."
	cluster_type = /obj/structure/spider/eggcluster/midwife
	potentialspawns = list(
		/mob/living/basic/spider/growing/spiderling/midwife, // We don't want the event to end instantly because broodmothers got a bad spawn
	)
	flash_window = TRUE

/obj/effect/mob_spawn/ghost_role/spider/pre_ghost_take(mob/dead/observer/user)
	var/chosen_spider = length(potentialspawns) > 1 ? get_radial_choice(user) : potentialspawns[1]
	if(isnull(chosen_spider))
		return FALSE
	mob_type = chosen_spider
	return TRUE

/// Pick a spider type from a radial menu
/obj/effect/mob_spawn/ghost_role/spider/proc/get_radial_choice(mob/user)
	var/list/spider_list = list()
	var/list/display_spiders = list()
	for(var/choice in potentialspawns)
		var/mob/living/basic/spider/growing/spiderling/chosen_spiderling = choice
		var/mob/living/basic/spider/growing/young/young_spider = initial(chosen_spiderling.grow_as)
		var/mob/living/basic/spider/giant/spider = initial(young_spider.grow_as) // God this is so stupid
		spider_list[initial(spider.name)] = chosen_spiderling

		var/datum/radial_menu_choice/option = new
		option.image = image(icon = initial(spider.icon), icon_state = initial(spider.icon_state))

		var/datum/reagent/spider_poison = initial(spider.poison_type)
		var/spider_description = initial(spider.menu_description)
		if(initial(spider.poison_per_bite))
			spider_description += " [initial(spider_poison.name)] injection of [initial(spider.poison_per_bite)]u per bite."
		else
			spider_description += " Does not inject [initial(spider_poison.name)]."
		option.info = span_boldnotice(spider_description)

		display_spiders[initial(spider.name)] = option
	sort_list(display_spiders)

	var/chosen_spider = show_radial_menu(user, egg, display_spiders, radius = 38, require_near = TRUE)
	return spider_list[chosen_spider]
