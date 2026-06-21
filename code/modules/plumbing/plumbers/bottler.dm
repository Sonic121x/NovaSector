/obj/machinery/plumbing/bottler
	name = "化学品分装机"
	desc = "它会将试剂放入容器中，比如瓶状容器和烧杯之类的，放置在朝向绿色指示灯的区域。如果容器装满后，它们就会从红色指示灯处排出。"
	icon_state = "bottler"
	reagents = /datum/reagents
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	reagent_flags = /obj/machinery/plumbing::reagent_flags | DRAINABLE
	buffer = 100

	///how much do we fill
	var/wanted_amount = 10
	///where things are sent
	var/turf/goodspot = null
	///where things are taken
	var/turf/inputspot = null
	///where beakers that are already full will be sent
	var/turf/badspot = null
	///Does the plumbing machine have a correct tile setup
	var/valid_output_configuration = FALSE

/obj/machinery/plumbing/bottler/Initialize(mapload, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand, layer, distinct_reagent_cap = 3)
	setDir(dir)

/obj/machinery/plumbing/bottler/examine(mob/user)
	. = ..()
	. += span_notice("一个小屏幕显示它将填充 [wanted_amount]u。")
	if(!valid_output_configuration)
		. += span_warning("屏幕上闪烁着一则通知：“输出位置错误！”")

///changes the tile array
/obj/machinery/plumbing/bottler/setDir(newdir)
	. = ..()
	var/turf/target_turf = get_turf(src)
	switch(dir)
		if(NORTH)
			goodspot = get_step(target_turf, NORTH)
			inputspot = get_step(target_turf, SOUTH)
			badspot = get_step(target_turf, EAST)
		if(SOUTH)
			goodspot = get_step(target_turf, SOUTH)
			inputspot = get_step(target_turf, NORTH)
			badspot = get_step(target_turf, WEST)
		if(WEST)
			goodspot = get_step(target_turf, WEST)
			inputspot = get_step(target_turf, EAST)
			badspot = get_step(target_turf, NORTH)
		if(EAST)
			goodspot = get_step(target_turf, EAST)
			inputspot = get_step(target_turf, WEST)
			badspot = get_step(target_turf, SOUTH)

	//If by some miracle
	if( ( !valid_output_configuration ) && ( goodspot != null && inputspot != null && badspot != null ) )
		valid_output_configuration = TRUE
		begin_processing()

///changing input ammount with a window
/obj/machinery/plumbing/bottler/interact(mob/user)
	. = ..()
	if(!valid_output_configuration)
		to_chat(user, span_warning("屏幕上闪烁着一则通知：“输出位置错误！”"))
		return .
	var/new_amount = tgui_input_number(user, "设置填充量", "期望量", max_value = reagents.maximum_volume, round_value = TRUE)
	if(!new_amount || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return .
	wanted_amount = new_amount
	to_chat(user, span_notice("该 [src] 现在将填充 [wanted_amount]u。"))

/obj/machinery/plumbing/bottler/process(seconds_per_tick)
	if(!is_operational)
		return
	// Sanity check the result locations and stop processing if they don't exist
	if(goodspot == null || badspot == null || inputspot == null)
		valid_output_configuration = FALSE
		return PROCESS_KILL

	///see if machine has enough to fill, is anchored down and has any inputspot objects to pick from
	if(reagents.total_volume >= wanted_amount && anchored && length(inputspot.contents))
		use_energy(active_power_usage * seconds_per_tick)
		var/obj/AM = pick(inputspot.contents)///pick a reagent_container that could be used
		//allowed containers
		var/static/list/allowed_containers = list(
			/obj/item/reagent_containers/cup,
			/obj/item/ammo_casing/shotgun/dart,
		)
		if(is_type_in_list(AM, allowed_containers))
			var/obj/item/B = AM
			///see if it would overflow else inject
			if((B.reagents.total_volume + wanted_amount) <= B.reagents.maximum_volume)
				reagents.trans_to(B, wanted_amount)
				B.forceMove(goodspot)
				return
			///glass was full so we move it away
			AM.forceMove(badspot)
		else if(istype(AM, /obj/item/slime_extract)) ///slime extracts need inject
			AM.forceMove(goodspot)
			reagents.trans_to(AM, wanted_amount, methods = INJECT)
		else if(istype(AM, /obj/item/slimecross/industrial)) ///no need to move slimecross industrial things
			reagents.trans_to(AM, wanted_amount, methods = INJECT)
