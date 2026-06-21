#define CHEMICALS_PER_UNIT 2
#define CHEMICAL_SECOND_DIVISOR (5 SECONDS)
#define OUT_OF_HOST_EGG_COST 50
#define BLOOD_CHEM_OBJECTIVE 3

// Parent of all borer actions
/datum/action/cooldown/borer
	button_icon = 'modular_nova/modules/cortical_borer/icons/actions.dmi'
	cooldown_time = 0
	/// How many chemicals this costs
	var/chemical_cost = 0
	/// How many chem evo points are needed to use this ability
	var/chemical_evo_points = 0
	/// How many stat evo points are needed to use this ability
	var/stat_evo_points = 0

/datum/action/cooldown/borer/New(Target, original)
	. = ..()
	var/compiled_string = ""
	if(chemical_cost)
		compiled_string += "([chemical_cost] chemical[chemical_cost == 1 ? "" : "s"])"
	if(chemical_evo_points)
		compiled_string += " ([chemical_evo_points] chemical point[chemical_evo_points == 1 ? "" : "s"])"
	if(stat_evo_points)
		compiled_string += " ([stat_evo_points] stat point[stat_evo_points == 1 ? "" : "s"])"
	name = "[initial(name)][compiled_string]"

/datum/action/cooldown/borer/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	if(!iscorticalborer(owner))
		to_chat(owner, span_warning("你必须是一个皮质钻孔虫才能使用此动作！"))
		return FALSE
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(owner.stat == DEAD)
		return FALSE
	if(cortical_owner.chemical_storage < chemical_cost)
		cortical_owner.balloon_alert(cortical_owner, "需要 [chemical_cost] 化学物质")
		return FALSE
	if(cortical_owner.chemical_evolution < chemical_evo_points)
		cortical_owner.balloon_alert(cortical_owner, "需要 [chemical_evo_points] 化学点数")
		return FALSE
	if(cortical_owner.stat_evolution < stat_evo_points)
		cortical_owner.balloon_alert(cortical_owner, "需要 [stat_evo_points] 属性点数")
		return FALSE

	return . == FALSE ? FALSE : TRUE //. can be null, true, or false. There's a difference between null and false here

//inject chemicals into your host
/datum/action/cooldown/borer/inject_chemical
	name = "打开化学注射器"
	button_icon_state = "chemical"

/datum/action/cooldown/borer/inject_chemical/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.human_host)
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	ui_interact(owner)

/datum/action/cooldown/borer/inject_chemical/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorerChem", name)
		ui.open()

/datum/action/cooldown/borer/inject_chemical/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	data["amount"] = cortical_owner.injection_rate_current
	data["energy"] = cortical_owner.chemical_storage / CHEMICALS_PER_UNIT
	data["maxEnergy"] = cortical_owner.max_chemical_storage / CHEMICALS_PER_UNIT
	data["borerTransferAmounts"] = cortical_owner.injection_rates_unlocked
	data["onCooldown"] = !COOLDOWN_FINISHED(cortical_owner, injection_cooldown)
	data["notEnoughChemicals"] = ((cortical_owner.injection_rate_current * CHEMICALS_PER_UNIT) > cortical_owner.chemical_storage) ? TRUE : FALSE

	var/chemicals[0]
	for(var/reagent in cortical_owner.known_chemicals)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[reagent]
		if(temp)
			var/chemname = temp.name
			chemicals.Add(list(list("title" = chemname, "id" = ckey(temp.name))))
	data["chemicals"] = chemicals

	return data

/datum/action/cooldown/borer/inject_chemical/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	switch(action)
		if("amount")
			var/target = text2num(params["target"])
			if(target in cortical_owner.injection_rates)
				cortical_owner.injection_rate_current = target
				. = TRUE
		if("inject")
			if(!iscorticalborer(usr) || !COOLDOWN_FINISHED(cortical_owner, injection_cooldown))
				return
			if(cortical_owner.host_sugar())
				owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
				return
			var/reagent_name = params["reagent"]
			var/reagent = GLOB.name2reagent[reagent_name]
			if(!(reagent in cortical_owner.known_chemicals))
				return

			cortical_owner.reagent_holder.reagents.add_reagent(reagent, cortical_owner.injection_rate_current, added_purity = 1)
			cortical_owner.reagent_holder.reagents.trans_to(cortical_owner.human_host, cortical_owner.injection_rate_current, methods = INGEST)

			to_chat(cortical_owner.human_host, span_warning("你感到体内一阵冰凉，头部隐隐作痛！"))
			cortical_owner.chemical_storage -= cortical_owner.injection_rate_current * CHEMICALS_PER_UNIT
			COOLDOWN_START(cortical_owner, injection_cooldown, (cortical_owner.injection_rate_current / CHEMICAL_SECOND_DIVISOR))

			var/turf/human_turf = get_turf(cortical_owner.human_host)
			var/logging_text = "[key_name(cortical_owner)] injected [key_name(cortical_owner.human_host)] with [reagent_name] at [loc_name(human_turf)]"
			cortical_owner.log_message(logging_text, LOG_GAME)
			cortical_owner.human_host.log_message(logging_text, LOG_GAME)
			. = TRUE

/datum/action/cooldown/borer/inject_chemical/ui_state(mob/user)
	return GLOB.always_state

/datum/action/cooldown/borer/inject_chemical/ui_status(mob/user, datum/ui_state/state)
	if(!iscorticalborer(user))
		return UI_CLOSE

	var/mob/living/basic/cortical_borer/borer = user

	if(!borer.human_host)
		return UI_CLOSE
	return ..()

/datum/action/cooldown/borer/evolution_tree
	name = "打开进化树"
	button_icon_state = "newability"

/datum/action/cooldown/borer/evolution_tree/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	ui_interact(owner)

/datum/action/cooldown/borer/evolution_tree/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorerEvolution", name)
		ui.open()

/datum/action/cooldown/borer/evolution_tree/ui_data(mob/user)
	var/list/data = list()

	var/static/list/path_to_color = list(
		BORER_EVOLUTION_DIVEWORM = "red",
		BORER_EVOLUTION_HIVELORD = "purple",
		BORER_EVOLUTION_SYMBIOTE = "green",
		BORER_EVOLUTION_GENERAL = "label",
	)

	var/mob/living/basic/cortical_borer/cortical_owner = owner

	data["evolution_points"] = cortical_owner.stat_evolution

	for(var/datum/borer_evolution/evolution as anything in cortical_owner.get_possible_evolutions())
		if(evolution in cortical_owner.past_evolutions)
			continue

		var/list/evo_data = list()

		evo_data["path"] = evolution
		evo_data["name"] = initial(evolution.name)
		evo_data["desc"] = initial(evolution.desc)
		evo_data["gainFlavor"] = initial(evolution.gain_text)
		evo_data["cost"] = initial(evolution.evo_cost)
		evo_data["disabled"] = ((initial(evolution.evo_cost) > cortical_owner.stat_evolution) || (initial(evolution.mutually_exclusive) && cortical_owner.genome_locked))
		evo_data["evoPath"] = initial(evolution.evo_type)
		evo_data["color"] = path_to_color[initial(evolution.evo_type)] || "grey"
		evo_data["tier"] = initial(evolution.tier)
		evo_data["exclusive"] = initial(evolution.mutually_exclusive)

		data["learnableEvolution"] += list(evo_data)

	for(var/path in cortical_owner.past_evolutions)
		var/list/evo_data = list()
		var/datum/borer_evolution/found_evolution = cortical_owner.past_evolutions[path]

		evo_data["name"] = found_evolution.name
		evo_data["desc"] = found_evolution.desc
		evo_data["gainFlavor"] = found_evolution.gain_text
		evo_data["cost"] = found_evolution.evo_cost
		evo_data["evoPath"] = found_evolution.evo_type
		evo_data["color"] = path_to_color[found_evolution.evo_type] || "grey"
		evo_data["tier"] = found_evolution.tier

		data["learnedEvolution"] += list(evo_data)
	return data

/datum/action/cooldown/borer/evolution_tree/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	switch(action)
		if("evolve")
			var/datum/borer_evolution/to_evolve_path = text2path(params["path"])
			if(!ispath(to_evolve_path))
				CRASH("Cortical borer attempted to evolve with a non-evolution path! (Got: [to_evolve_path])")

			if(initial(to_evolve_path.evo_cost) > cortical_owner.stat_evolution)
				return
			if(initial(to_evolve_path.mutually_exclusive) && cortical_owner.genome_locked)
				return
			if(!cortical_owner.do_evolution(to_evolve_path))
				return

			log_borer_evolution("[key_name(owner)] gained knowledge: [initial(to_evolve_path.name)]")
			cortical_owner.stat_evolution -= initial(to_evolve_path.evo_cost)
			return TRUE

/datum/action/cooldown/borer/evolution_tree/ui_state(mob/user)
	return GLOB.always_state

/datum/action/cooldown/borer/learn_focus
	name = "学习专精"
	button_icon_state = "getfocus"

/datum/action/cooldown/borer/learn_focus/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	if(!length(cortical_owner.possible_focuses))
		owner.balloon_alert(owner, "已学会所有专精")
		return
	var/list/fancy_list = list()
	for(var/datum/borer_focus/foci as anything in cortical_owner.possible_focuses)
		if(foci in cortical_owner.body_focuses)
			continue
		fancy_list["[foci.name] ([foci.cost] points)"] = foci
	var/focus_choice = tgui_input_list(cortical_owner, "学习一个专精！", "专精选择", fancy_list)
	if(!focus_choice)
		owner.balloon_alert(owner, "未选择专精")
		return
	var/datum/borer_focus/picked_focus = fancy_list[focus_choice]
	if(cortical_owner.stat_evolution < picked_focus.cost)
		owner.balloon_alert(owner, "需要 [picked_focus.cost] 点")
		return
	cortical_owner.stat_evolution -= picked_focus.cost
	cortical_owner.body_focuses += picked_focus
	picked_focus.on_add(cortical_owner.human_host, owner)
	owner.balloon_alert(owner, "专注力学习成功")
	StartCooldown()

/datum/action/cooldown/borer/learn_bloodchemical
	name = "从血液中学习化学物质"
	button_icon_state = "bloodchem"
	chemical_evo_points = 5

/datum/action/cooldown/borer/learn_bloodchemical/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	if(length(cortical_owner.human_host.reagents.reagent_list) <= 0)
		owner.balloon_alert(owner, "宿主体内无试剂")
		return
	var/datum/reagent/reagent_choice = tgui_input_list(cortical_owner, "选择要学习的化学物质。", "化学物质选择", cortical_owner.human_host.reagents.reagent_list)
	if(!reagent_choice)
		owner.balloon_alert(owner, "未选择化学物质")
		return
	if(locate(reagent_choice) in cortical_owner.known_chemicals)
		owner.balloon_alert(owner, "化学物质已掌握")
		return
	if(locate(reagent_choice) in cortical_owner.blacklisted_chemicals)
		owner.balloon_alert(owner, "化学物质被列入黑名单")
		return
	if(!(reagent_choice.chemical_flags & REAGENT_CAN_BE_SYNTHESIZED))
		owner.balloon_alert(owner, "无法学习 [initial(reagent_choice.name)]")
		return
	cortical_owner.chemical_evolution -= chemical_evo_points
	cortical_owner.known_chemicals += reagent_choice.type
	cortical_owner.blood_chems_learned++
	var/obj/item/organ/brain/victim_brain = cortical_owner.human_host.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(victim_brain)
		cortical_owner.human_host.adjust_organ_loss(ORGAN_SLOT_BRAIN, 5 * cortical_owner.host_harm_multiplier)
	if(cortical_owner.blood_chems_learned == BLOOD_CHEM_OBJECTIVE)
		GLOB.successful_blood_chem += 1
	owner.balloon_alert(owner, "已学会 [initial(reagent_choice.name)]")
	if(!HAS_TRAIT(cortical_owner.human_host, TRAIT_AGEUSIA))
		to_chat(cortical_owner.human_host, span_notice("你尝到一股奇怪的[initial(reagent_choice.taste_description)]余味！"))
	StartCooldown()

//become stronger by learning new chemicals
/datum/action/cooldown/borer/upgrade_chemical
	name = "学习新化学物质"
	button_icon_state = "bloodlevel"
	chemical_evo_points = 1

/datum/action/cooldown/borer/upgrade_chemical/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	if(!length(cortical_owner.potential_chemicals))
		owner.balloon_alert(owner, "已学会所有化学物质")
		return
	var/datum/reagent/reagent_choice = tgui_input_list(cortical_owner, "选择要学习的化学物质。", "化学物质选择", cortical_owner.potential_chemicals)
	if(!reagent_choice)
		owner.balloon_alert(owner, "未选择化学物质")
		return
	cortical_owner.chemical_evolution -= chemical_evo_points
	cortical_owner.known_chemicals += reagent_choice
	cortical_owner.potential_chemicals -= reagent_choice
	var/obj/item/organ/brain/victim_brain = cortical_owner.human_host.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(victim_brain)
		cortical_owner.human_host.adjust_organ_loss(ORGAN_SLOT_BRAIN, 5 * cortical_owner.host_harm_multiplier)
	owner.balloon_alert(owner, "[initial(reagent_choice.name)] 已学会")
	if(!HAS_TRAIT(cortical_owner.human_host, TRAIT_AGEUSIA))
		to_chat(cortical_owner.human_host, span_notice("你尝到一股奇怪的[initial(reagent_choice.taste_description)]余味！"))
	StartCooldown()

//become stronger by affecting the stats
/datum/action/cooldown/borer/upgrade_stat
	name = "变得更强"
	button_icon_state = "level"
	stat_evo_points = 1

/datum/action/cooldown/borer/upgrade_stat/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	cortical_owner.stat_evolution -= stat_evo_points
	cortical_owner.maxHealth += cortical_owner.health_per_level
	cortical_owner.health_regen += cortical_owner.health_regen_per_level
	cortical_owner.max_chemical_storage += cortical_owner.chem_storage_per_level
	cortical_owner.chemical_regen += cortical_owner.chem_regen_per_level
	cortical_owner.level += 1
	var/obj/item/organ/brain/victim_brain = cortical_owner.human_host.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(victim_brain)
		cortical_owner.human_host.adjust_organ_loss(ORGAN_SLOT_BRAIN, 10 * cortical_owner.host_harm_multiplier)
	cortical_owner.human_host.adjust_eye_blur(6 SECONDS * cortical_owner.host_harm_multiplier) //about 12 seconds' worth by default
	to_chat(cortical_owner, span_notice("你长大了！"))
	to_chat(cortical_owner.human_host, span_warning("你感到头部一阵尖锐的压力！"))
	StartCooldown()

//go between either hiding behind tables or behind mobs
/datum/action/cooldown/borer/toggle_hiding
	name = "切换隐藏"
	button_icon_state = "hide"

/datum/action/cooldown/borer/toggle_hiding/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(HAS_TRAIT(cortical_owner, TRAIT_PRONE))
		SEND_SIGNAL(cortical_owner, COMSIG_MOVABLE_REMOVE_PRONE_STATE)
		cortical_owner.upgrade_flags &= ~BORER_HIDING
		owner.balloon_alert(owner, "停止隐藏")
		StartCooldown()
		return
	cortical_owner.upgrade_flags |= BORER_HIDING
	owner.balloon_alert(owner, "开始隐藏")
	cortical_owner.AddComponent(/datum/component/prone_mob)
	StartCooldown()

//to paralyze people
/datum/action/cooldown/borer/fear_human
	name = "煽动恐惧"
	cooldown_time = 12 SECONDS
	button_icon_state = "fear"

/datum/action/cooldown/borer/fear_human/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	if(cortical_owner.human_host)
		incite_internal_fear()
		StartCooldown()
		return
	var/list/potential_freezers = list()
	for(var/mob/living/carbon/human/listed_human in range(1, cortical_owner))
		if(!ishuman(listed_human)) //no nonhuman hosts
			continue
		if(listed_human.stat == DEAD) //no dead hosts
			continue
		if(considered_afk(listed_human.mind)) //no afk hosts
			continue
		potential_freezers += listed_human
	if(length(potential_freezers) == 1)
		incite_fear(potential_freezers[1])
		return
	var/mob/living/carbon/human/choose_fear = tgui_input_list(cortical_owner, "选择你要恐吓的对象！", "恐吓选择", potential_freezers)
	if(!choose_fear)
		owner.balloon_alert(owner, "未选择目标")
		return
	if(get_dist(choose_fear, cortical_owner) > 1)
		owner.balloon_alert(owner, "所选目标距离过远")
		return
	incite_fear(choose_fear)
	StartCooldown()

/datum/action/cooldown/borer/fear_human/proc/incite_fear(mob/living/carbon/human/singular_fear)
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	to_chat(singular_fear, span_warning("有什么东西正恶狠狠地瞪着你！"))
	singular_fear.Paralyze(7 SECONDS)
	singular_fear.adjust_stamina_loss(50)
	singular_fear.set_confusion_if_lower(9 SECONDS)
	var/turf/human_turf = get_turf(singular_fear)
	var/logging_text = "[key_name(cortical_owner)] feared/paralyzed [key_name(singular_fear)] at [loc_name(human_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	singular_fear.log_message(logging_text, LOG_GAME)

/datum/action/cooldown/borer/fear_human/proc/incite_internal_fear()
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	owner.balloon_alert(owner, "已将恐惧注入宿主")
	cortical_owner.human_host.Paralyze(10 SECONDS)
	cortical_owner.human_host.adjust_stamina_loss(100)
	cortical_owner.human_host.set_confusion_if_lower(15 SECONDS)
	to_chat(cortical_owner.human_host, span_warning("有什么东西在你体内剧烈移动！"))
	var/turf/human_turf = get_turf(cortical_owner.human_host)
	var/logging_text = "[key_name(cortical_owner)] feared/paralyzed [key_name(cortical_owner.human_host)] (internal) at [loc_name(human_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	cortical_owner.human_host.log_message(logging_text, LOG_GAME)

//to check the health of the human
/datum/action/cooldown/borer/check_blood
	name = "检查血液"
	cooldown_time = 5 SECONDS
	button_icon_state = "blood"

/datum/action/cooldown/borer/check_blood/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内含糖时无法运作")
		return
	if(!cortical_owner.human_host)
		owner.balloon_alert(owner, "需要宿主")
		return
	healthscan(owner, cortical_owner.human_host, advanced = TRUE) // :thinking:
	chemscan(owner, cortical_owner.human_host)
	StartCooldown()

//to either get inside, or out, of a host
/datum/action/cooldown/borer/choosing_host
	name = "寄居/脱离宿主"
	cooldown_time = 10 SECONDS
	button_icon_state = "host"

/datum/action/cooldown/borer/choosing_host/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner

	//having a host means we need to leave them then
	if(cortical_owner.human_host)
		if(cortical_owner.host_sugar())
			owner.balloon_alert(owner, "宿主体内含糖时无法运作")
			return
		owner.balloon_alert(owner, "已脱离宿主")
		if(!(cortical_owner.upgrade_flags & BORER_STEALTH_MODE))
			to_chat(cortical_owner.human_host, span_notice("有什么东西小心地搔弄着你的内耳..."))
		var/obj/item/organ/borer_body/borer_organ = locate() in cortical_owner.human_host.organs
		//log the interaction
		var/turf/human_turfone = get_turf(cortical_owner.human_host)
		var/logging_text = "[key_name(cortical_owner)] left [key_name(cortical_owner.human_host)] at [loc_name(human_turfone)]"
		cortical_owner.log_message(logging_text, LOG_GAME)
		cortical_owner.human_host.log_message(logging_text, LOG_GAME)
		if(borer_organ)
			borer_organ.Remove(cortical_owner.human_host)
		cortical_owner.forceMove(human_turfone)
		cortical_owner.human_host = null
		if(HAS_TRAIT_FROM(cortical_owner, TRAIT_WEATHER_IMMUNE, "borer_in_host"))
			REMOVE_TRAIT(cortical_owner, TRAIT_WEATHER_IMMUNE, "borer_in_host")
		StartCooldown()
		return

	//we dont have a host so lets inhabit one
	var/list/usable_hosts = list()
	for(var/mob/living/carbon/human/listed_human in range(1, cortical_owner))
		// no non-human hosts
		if(!ishuman(listed_human) || ismonkey(listed_human))
			continue
		// cannot have multiple borers (for now)
		if(listed_human.has_borer())
			continue
		// hosts need to be organic
		if(!(listed_human.dna.species.inherent_biotypes & MOB_ORGANIC) && cortical_owner.organic_restricted)
			continue
		// hosts need to be organic
		if(!(listed_human.mob_biotypes & MOB_ORGANIC) && cortical_owner.organic_restricted)
			continue
		//hosts cannot be changelings
		if(listed_human.mind)
			var/datum/antagonist/changeling/changeling = listed_human.mind.has_antag_datum(/datum/antagonist/changeling)
			if(changeling && cortical_owner.changeling_restricted)
				continue
		usable_hosts += listed_human

	//if the list of possible hosts is one, just go straight in, no choosing
	if(length(usable_hosts) == 1)
		enter_host(usable_hosts[1])
		return

	//if the list of possible host is more than one, allow choosing a host
	var/choose_host = tgui_input_list(cortical_owner, "选择你的宿主！", "宿主选择", usable_hosts)
	if(!choose_host)
		owner.balloon_alert(owner, "未选择目标")
		return
	enter_host(choose_host)

/datum/action/cooldown/borer/choosing_host/proc/enter_host(mob/living/carbon/human/singular_host)
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(check_for_bio_protection(singular_host))
		owner.balloon_alert(owner, "目标头部防护过强！")
		return
	if(singular_host.has_borer())
		owner.balloon_alert(owner, "目标已被占据")
		return
	if(!do_after(cortical_owner, (((cortical_owner.upgrade_flags & BORER_FAST_BORING) && !(cortical_owner.upgrade_flags & BORER_HIDING)) ? 3 SECONDS : 6 SECONDS), target = singular_host))
		owner.balloon_alert(owner, "你和目标都必须保持静止")
		return
	if(get_dist(singular_host, cortical_owner) > 1)
		owner.balloon_alert(owner, "目标距离过远")
		return
	cortical_owner.human_host = singular_host
	cortical_owner.forceMove(cortical_owner.human_host)
	if(!(cortical_owner.upgrade_flags & BORER_STEALTH_MODE))
		to_chat(cortical_owner.human_host, span_notice("一股寒意顺着你的脊柱蔓延而下……"))
	cortical_owner.copy_languages(cortical_owner.human_host)
	var/obj/item/organ/borer_body/borer_organ = new(cortical_owner.human_host)
	borer_organ.borer = owner
	borer_organ.Insert(cortical_owner.human_host)
	var/turf/human_turftwo = get_turf(cortical_owner.human_host)
	var/logging_text = "[key_name(cortical_owner)] went into [key_name(cortical_owner.human_host)] at [loc_name(human_turftwo)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	cortical_owner.human_host.log_message(logging_text, LOG_GAME)
	if(!HAS_TRAIT_FROM(cortical_owner, TRAIT_WEATHER_IMMUNE, "borer_in_host")) // if somehow we didn't get a borer organ?
		ADD_TRAIT(cortical_owner, TRAIT_WEATHER_IMMUNE, "borer_in_host")
	StartCooldown()

/// Checks if the target's head is bio protected, returns true if this is the case
/datum/action/cooldown/borer/choosing_host/proc/check_for_bio_protection(mob/living/carbon/human/target)
	if(isobj(target.head))
		if(target.head.get_armor_rating(BIO) >= 100)
			return TRUE
	if(isobj(target.wear_mask))
		if(target.wear_mask.get_armor_rating(BIO) >= 100)
			return TRUE
	if(isobj(target.wear_neck))
		if(target.wear_neck.get_armor_rating(BIO) >= 100)
			return TRUE
	return FALSE

//you can force your host to speak... dont abuse this
/datum/action/cooldown/borer/force_speak
	name = "强制宿主发言"
	cooldown_time = 30 SECONDS
	button_icon_state = "speak"

/datum/action/cooldown/borer/force_speak/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主体内有糖分时无法运作")
		return
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "必须在宿主体内")
		return
	var/borer_message = input(cortical_owner, "你想强迫宿主说什么？", "强制发言") as message|null
	if(!borer_message)
		owner.balloon_alert(owner, "未提供消息")
		return
	borer_message = sanitize(borer_message)
	var/mob/living/carbon/human/cortical_host = cortical_owner.human_host
	to_chat(cortical_host, span_boldwarning("你的声音不受控制地发出了声响！"))
	var/obj/item/organ/brain/victim_brain = cortical_owner.human_host.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(victim_brain)
		cortical_owner.human_host.adjust_organ_loss(ORGAN_SLOT_BRAIN, 2 * cortical_owner.host_harm_multiplier)
	cortical_host.say(message = borer_message, forced = TRUE)
	var/turf/human_turf = get_turf(cortical_owner.human_host)
	var/logging_text = "[key_name(cortical_owner)] forced [key_name(cortical_owner.human_host)] to say [borer_message] at [loc_name(human_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	cortical_owner.human_host.log_message(logging_text, LOG_GAME)
	StartCooldown()

//we need a way to produce offspring
/datum/action/cooldown/borer/produce_offspring
	name = "繁衍后代"
	cooldown_time = 1 MINUTES
	button_icon_state = "reproduce"
	chemical_cost = 100

/datum/action/cooldown/borer/produce_offspring/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!(cortical_owner.upgrade_flags & BORER_ALONE_PRODUCTION) && !cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	cortical_owner.chemical_storage -= chemical_cost
	if((cortical_owner.upgrade_flags & BORER_ALONE_PRODUCTION) && !cortical_owner.inside_human())
		no_host_egg()
		StartCooldown()
		return
	produce_egg()
	var/obj/item/organ/brain/victim_brain = cortical_owner.human_host.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(victim_brain)
		cortical_owner.human_host.adjust_organ_loss(ORGAN_SLOT_BRAIN, 25 * cortical_owner.host_harm_multiplier)
		var/eggroll = rand(1,100)
		if(eggroll <= 75)
			switch(eggroll)
				if(1 to 34)
					cortical_owner.human_host.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_BASIC)
				if(35 to 60)
					cortical_owner.human_host.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_SURGERY)
				if(61 to 71)
					cortical_owner.human_host.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_SURGERY)
				if(72 to 75)
					cortical_owner.human_host.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	to_chat(cortical_owner.human_host, span_warning("你的大脑开始隐隐作痛……"))
	var/turf/borer_turf = get_turf(cortical_owner)
	new /obj/effect/decal/cleanable/vomit(borer_turf)
	playsound(borer_turf, 'sound/effects/splat.ogg', 50, TRUE)
	var/logging_text = "[key_name(cortical_owner)] gave birth at [loc_name(borer_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	owner.balloon_alert(owner, "已产卵")
	StartCooldown()

/datum/action/cooldown/borer/produce_offspring/proc/no_host_egg()
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	cortical_owner.health = max(cortical_owner.health, 1, cortical_owner.health -= OUT_OF_HOST_EGG_COST)
	produce_egg()
	var/turf/borer_turf = get_turf(cortical_owner)
	var/obj/effect/decal/cleanable/blood/splatter/new_splatter = new /obj/effect/decal/cleanable/blood/splatter(borer_turf)
	new_splatter.add_mob_blood(cortical_owner)

	playsound(borer_turf, 'sound/effects/splat.ogg', 50, TRUE)
	var/logging_text = "[key_name(cortical_owner)] gave birth alone at [loc_name(borer_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	owner.balloon_alert(owner, "已产卵")

/datum/action/cooldown/borer/produce_offspring/proc/produce_egg()
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	var/turf/borer_turf = get_turf(cortical_owner)
	var/obj/effect/mob_spawn/ghost_role/borer_egg/spawned_egg = new /obj/effect/mob_spawn/ghost_role/borer_egg(borer_turf)
	spawned_egg.generation = (cortical_owner.generation + 1)
	cortical_owner.children_produced++
	if(cortical_owner.children_produced == GLOB.objective_egg_egg_number)
		GLOB.successful_egg_number += 1

//revive your host
/datum/action/cooldown/borer/revive_host
	name = "复活宿主"
	cooldown_time = 2 MINUTES
	button_icon_state = "revive"
	chemical_cost = 200

/datum/action/cooldown/borer/revive_host/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主含糖时无法运作")
		return
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	cortical_owner.chemical_storage -= chemical_cost
	var/need_mob_update
	need_mob_update += cortical_owner.human_host.adjust_brute_loss(-(cortical_owner.human_host.get_brute_loss()*0.5), updating_health = FALSE)
	need_mob_update += cortical_owner.human_host.adjust_tox_loss(-(cortical_owner.human_host.get_tox_loss()*0.5), updating_health = FALSE)
	need_mob_update += cortical_owner.human_host.adjust_fire_loss(-(cortical_owner.human_host.get_fire_loss()*0.5), updating_health = FALSE)
	need_mob_update += cortical_owner.human_host.adjust_oxy_loss(-(cortical_owner.human_host.get_oxy_loss()*0.5), updating_health = FALSE)
	if(need_mob_update)
		cortical_owner.updatehealth()
	if(cortical_owner.human_host.get_blood_volume() < BLOOD_VOLUME_BAD)
		cortical_owner.human_host.set_blood_volume(BLOOD_VOLUME_BAD)
	for(var/obj/item/organ/internal_target in cortical_owner.human_host.organs)
		if(!(internal_target.organ_flags & ORGAN_EXTERNAL))
			internal_target.apply_organ_damage(-internal_target.damage * 0.5)
	cortical_owner.human_host.revive()
	to_chat(cortical_owner.human_host, span_boldwarning("你的心脏猛然跳动起来！"))
	owner.balloon_alert(owner, "宿主已复活")
	var/turf/human_turf = get_turf(cortical_owner.human_host)
	var/logging_text = "[key_name(cortical_owner)] revived [key_name(cortical_owner.human_host)] at [loc_name(human_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	cortical_owner.human_host.log_message(logging_text, LOG_GAME)
	StartCooldown()

//to ask if a host is willing
/datum/action/cooldown/borer/willing_host
	name = "自愿宿主"
	cooldown_time = 2 MINUTES
	button_icon_state = "willing"
	chemical_cost = 150

/datum/action/cooldown/borer/willing_host/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主含糖时无法运作")
		return
	for(var/ckey_check in GLOB.willing_hosts)
		if(ckey_check == cortical_owner.human_host.ckey)
			owner.balloon_alert(owner, "宿主已自愿")
			return
	owner.balloon_alert(owner, "询问宿主中...")
	cortical_owner.chemical_storage -= chemical_cost
	var/host_choice = tgui_input_list(cortical_owner.human_host,"你愿意成为自愿宿主吗？", "自愿宿主请求", list("Yes", "No"))
	if(host_choice != "Yes")
		owner.balloon_alert(owner, "宿主不愿意！")
		StartCooldown()
		return
	owner.balloon_alert(owner, "宿主已自愿！")
	to_chat(cortical_owner.human_host, span_notice("你已同意成为自愿宿主！"))
	GLOB.willing_hosts += cortical_owner.human_host.ckey
	StartCooldown()

/datum/action/cooldown/borer/stealth_mode
	name = "潜行模式"
	cooldown_time = 2 MINUTES
	button_icon_state = "hiding"
	chemical_cost = 100

/datum/action/cooldown/borer/stealth_mode/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	var/in_stealth = (cortical_owner.upgrade_flags & BORER_STEALTH_MODE)
	if(in_stealth)
		chemical_cost = 0
	else
		chemical_cost = initial(chemical_cost)
	if(cortical_owner.host_sugar())
		owner.balloon_alert(owner, "宿主含糖时无法运作")
		return
	owner.balloon_alert(owner, "潜行模式 [in_stealth ? "disabled" : "enabled"]")
	cortical_owner.chemical_storage -= chemical_cost
	if(in_stealth)
		cortical_owner.upgrade_flags &= ~BORER_STEALTH_MODE
	else
		cortical_owner.upgrade_flags |= BORER_STEALTH_MODE


	StartCooldown()

/datum/action/cooldown/borer/empowered_offspring
	name = "产下强化子嗣"
	cooldown_time = 1 MINUTES
	button_icon_state = "reproduce"
	chemical_cost = 150

/datum/action/cooldown/borer/empowered_offspring/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/cortical_borer/cortical_owner = owner
	if(!cortical_owner.inside_human())
		owner.balloon_alert(owner, "需要宿主")
		return
	if(cortical_owner.human_host.stat != DEAD)
		owner.balloon_alert(owner, "宿主未死亡")
		return

	cortical_owner.chemical_storage -= chemical_cost
	var/turf/borer_turf = get_turf(cortical_owner)
	var/obj/item/bodypart/chest/chest = cortical_owner.human_host.get_bodypart(BODY_ZONE_CHEST)
	if((!chest || IS_ORGANIC_LIMB(chest)) && !cortical_owner.human_host.get_organ_by_type(/obj/item/organ/empowered_borer_egg))
		var/obj/item/organ/empowered_borer_egg/spawned_egg = new(cortical_owner.human_host)
		spawned_egg.generation = (cortical_owner.generation + 1)

	cortical_owner.children_produced += 1
	if(cortical_owner.children_produced == GLOB.objective_egg_egg_number)
		GLOB.successful_egg_number += 1

	playsound(borer_turf, 'sound/effects/splat.ogg', 50, TRUE)
	var/logging_text = "[key_name(cortical_owner)] gave birth to an empowered borer at [loc_name(borer_turf)]"
	cortical_owner.log_message(logging_text, LOG_GAME)
	cortical_owner.balloon_alert(owner, "已产卵")
	StartCooldown()

#undef CHEMICALS_PER_UNIT
#undef CHEMICAL_SECOND_DIVISOR
#undef OUT_OF_HOST_EGG_COST
#undef BLOOD_CHEM_OBJECTIVE
