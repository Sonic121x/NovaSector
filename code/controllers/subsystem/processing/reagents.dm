//Used for active reactions in reagents/equilibrium datums

PROCESSING_SUBSYSTEM_DEF(reagents)
	name = "Reagents"
	priority = FIRE_PRIORITY_REAGENTS
	wait = 0.25 SECONDS //You might think that rate_up_lim has to be set to half, but since everything is normalised around seconds_per_tick, it automatically adjusts it to be per second. Magic!
	ss_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_stage = INITSTAGE_EARLY
	///What time was it when we last ticked
	var/previous_world_time = 0

/datum/controller/subsystem/processing/reagents/Initialize()
	//So our first step isn't insane
	previous_world_time = world.time
	//Build GLOB lists - see holder.dm
	build_chemical_reactions_lists()
	// NOVA EDIT ADDITION START
	if(CONFIG_GET(flag/disable_erp_preferences))
		for(var/reaction_path in GLOB.chemical_reactions_list)
			var/datum/chemical_reaction/reaction_datum = GLOB.chemical_reactions_list[reaction_path]
			if(!reaction_datum.erp_reaction)
				continue
			GLOB.chemical_reactions_list -= reaction_path
			for(var/reaction in reaction_datum.required_reagents)
				var/list/reaction_list = GLOB.chemical_reactions_list_reactant_index[reaction]
				if(reaction_list)
					reaction_list -= reaction_datum
	// NOVA EDIT ADDITION END
	// ZH EDIT ADDITION START - i18n - 母版试剂表（GLOB.chemical_reagents_list）是 GLOBAL_LIST_INIT，
	// 早于 i18n_cache（modular 文件在 .dme 靠后）→ /datum/reagent/New() 的反查在母版实例上空转（名字
	// 留英文），而游戏中期创建的实例是中文 → 分配器按钮单词名英文/烧杯内容中文的割裂。SS Init 期补一遍
	//（与气体 SSair 反查 meta_gas_info 同款；lang_reverse_text 幂等，已译过的原样跳过）。
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		for(var/reagent_type in GLOB.chemical_reagents_list)
			var/datum/reagent/master_reagent = GLOB.chemical_reagents_list[reagent_type]
			if(!istype(master_reagent))
				continue
			master_reagent.name = lang_reverse_text(master_reagent.name)
			master_reagent.description = lang_reverse_text(master_reagent.description)
			master_reagent.taste_description = lang_reverse_text(master_reagent.taste_description)
	// ZH EDIT ADDITION END
	return SS_INIT_SUCCESS

/datum/controller/subsystem/processing/reagents/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	//Attempt to realtime reactions in a way that doesn't make them overtly dangerous
	var/delta_realtime = (world.time - previous_world_time)/10 //normalise to s from ds
	previous_world_time = world.time

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			stack_trace("Found qdeleted thing in [type], in the current_run list.")
			processing -= thing
		else if(thing.process(delta_realtime) == PROCESS_KILL) //we are realtime
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return
