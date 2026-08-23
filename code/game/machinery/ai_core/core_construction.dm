// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define AI_CORE_BRAIN(X) X.braintype == "Android" ? "brain" : "MMI"
#define UPDATE_STATE(new_state) state = new_state; update_appearance(UPDATE_ICON_STATE)
#define CHECK_STATE_CALLBACK(maintained_state) CALLBACK(src, PROC_REF(check_state), maintained_state)

/obj/structure/ai_core/welder_act(mob/living/user, obj/item/tool)
	if(state != CORE_STATE_EMPTY)
		balloon_alert(user, LANG("obj.1bcdbedc82e6fef2", null))
		return ITEM_INTERACT_BLOCKING

	if(!tool.tool_start_check(user, 1))
		return ITEM_INTERACT_BLOCKING

	if(!tool.use_tool(src, user, 2 SECONDS, 1, 50, CHECK_STATE_CALLBACK(CORE_STATE_EMPTY)))
		return ITEM_INTERACT_BLOCKING

	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/ai_core/can_be_unfasten_wrench(mob/user, silent)
	if(state >= CORE_STATE_FINISHED)
		if(!silent)
			balloon_alert(user, LANG("obj.3cf01833b680d6f9", null))
		return FAILED_UNFASTEN

	return ..()

/obj/structure/ai_core/wrench_act(mob/living/user, obj/item/tool)
	switch(default_unfasten_wrench(user, tool))
		if(FAILED_UNFASTEN)
			return ITEM_INTERACT_BLOCKING
		if(SUCCESSFUL_UNFASTEN)
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/ai_core/screwdriver_act(mob/living/user, obj/item/tool)
	switch(state)
		if(CORE_STATE_EMPTY)
			balloon_alert(user, LANG("obj.cc83c63c573208d9", null))
			return ITEM_INTERACT_BLOCKING
		if(CORE_STATE_CIRCUIT)
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_CIRCUIT)))
				return ITEM_INTERACT_BLOCKING
			balloon_alert(user, LANG("obj.e9892414e92fdb86", null))
			UPDATE_STATE(CORE_STATE_SCREWED)
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_SCREWED)
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_SCREWED)))
				return ITEM_INTERACT_BLOCKING
			balloon_alert(user, LANG("obj.8b7c5fd2cbb8244b", null))
			UPDATE_STATE(CORE_STATE_CIRCUIT)
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_CABLED)
			balloon_alert(user, LANG("obj.3385262060a8097c", null))
			return ITEM_INTERACT_BLOCKING
		if(CORE_STATE_GLASSED)
			if(!anchored)
				balloon_alert(user, LANG("obj.25a662c1c38c29af", null))
				return ITEM_INTERACT_BLOCKING
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_GLASSED)))
				return ITEM_INTERACT_BLOCKING
			if(suicide_check())
				balloon_alert(user, LANG("obj.469f07671ae7f65e", null))
				return ITEM_INTERACT_BLOCKING

			var/atom/movable/alert_source = src
			if(core_mmi.brainmob?.mind)
				alert_source = ai_structure_to_mob() || alert_source
			else
				UPDATE_STATE(CORE_STATE_FINISHED)
			alert_source.balloon_alert(user, LANG("obj.a783a38a6a91f82a", list(core_mmi?.brainmob?.mind ? " and neural network" : "")))
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_FINISHED)
			if(!core_mmi?.brainmob?.mind || suicide_check())
				balloon_alert(user, LANG("obj.1a71685b0d6b92a9", null))
				return ITEM_INTERACT_BLOCKING

			if(!anchored)
				balloon_alert(user, LANG("obj.c16d48e2e8f5ec29", null))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.f1bc28cc5c2dc4a1", null))
			if(!tool.use_tool(src, user, 10 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_FINISHED)))
				return ITEM_INTERACT_BLOCKING

			var/atom/movable/alert_source = ai_structure_to_mob()
			if(!alert_source)
				balloon_alert(user, LANG("obj.1a71685b0d6b92a9", null))
				return ITEM_INTERACT_BLOCKING

			alert_source.balloon_alert(user, LANG("obj.af254d1065d16aa9", null))
			return ITEM_INTERACT_SUCCESS

/obj/structure/ai_core/crowbar_act(mob/living/user, obj/item/tool)
	switch(state)
		if(CORE_STATE_EMPTY)
			balloon_alert(user, LANG("obj.2fa9bc2978ea2276", null))
			return ITEM_INTERACT_BLOCKING
		if(CORE_STATE_CIRCUIT)
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_CIRCUIT)))
				return ITEM_INTERACT_BLOCKING

			circuit.forceMove(drop_location())
			UPDATE_STATE(CORE_STATE_EMPTY)
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_SCREWED)
			balloon_alert(user, LANG("obj.13d012373762eeb1", null))
			return ITEM_INTERACT_BLOCKING
		if(CORE_STATE_CABLED)
			if(!core_mmi)
				balloon_alert(user, LANG("obj.2fa9bc2978ea2276", null))
				return ITEM_INTERACT_BLOCKING
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_CABLED)) || !core_mmi)
				return ITEM_INTERACT_BLOCKING

			core_mmi.forceMove(drop_location())
			UPDATE_STATE(CORE_STATE_CABLED)
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_GLASSED)
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_GLASSED)))
				return ITEM_INTERACT_BLOCKING

			new /obj/item/stack/sheet/rglass(drop_location(), 2)
			UPDATE_STATE(CORE_STATE_CABLED)
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_FINISHED)
			balloon_alert(user, LANG("obj.1f67c8910a3de4aa", null))
			return ITEM_INTERACT_SUCCESS

/obj/structure/ai_core/wirecutter_act(mob/living/user, obj/item/tool)
	switch(state)
		if(CORE_STATE_EMPTY to CORE_STATE_CIRCUIT)
			balloon_alert(user, LANG("obj.89358e902f552277", null))
			return ITEM_INTERACT_BLOCKING
		if(CORE_STATE_CABLED)
			if(core_mmi)
				balloon_alert(user, LANG("obj.84ae91448df87773", list(AI_CORE_BRAIN(core_mmi))))
				return ITEM_INTERACT_BLOCKING

			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_CABLED)) || core_mmi)
				return ITEM_INTERACT_BLOCKING

			new /obj/item/stack/cable_coil(drop_location(), 5)
			UPDATE_STATE(CORE_STATE_SCREWED)
			return ITEM_INTERACT_SUCCESS
		if(CORE_STATE_GLASSED)
			balloon_alert(user, LANG("obj.ea8b2b383d7a25bb", null))
			return ITEM_INTERACT_BLOCKING
		if(CORE_STATE_FINISHED)
			if(!tool.use_tool(src, user, 0 SECONDS, 0, 50, CHECK_STATE_CALLBACK(CORE_STATE_FINISHED)))
				return ITEM_INTERACT_BLOCKING

			UPDATE_STATE(CORE_STATE_GLASSED)
			return ITEM_INTERACT_SUCCESS

/// Handles the interaction chain the same as item_interaction. Exists to isolate construction behaviour from other item behaviour.
/obj/structure/ai_core/proc/construction_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/circuitboard/aicore))
		return install_board(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/stack/cable_coil))
		return add_cabling(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/mmi))
		return install_mmi(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/stack/sheet/rglass))
		return install_glass(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

	return NONE

/obj/structure/ai_core/proc/install_board(mob/living/user, obj/item/circuitboard/aicore/circuit)
	if(state != CORE_STATE_EMPTY)
		return FALSE
	if(!user.transferItemToLoc(circuit, src))
		return FALSE

	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	src.circuit = circuit
	UPDATE_STATE(CORE_STATE_CIRCUIT)
	return TRUE

/obj/structure/ai_core/proc/add_cabling(mob/living/user, obj/item/stack/cable_coil/cable)
	if(state != CORE_STATE_SCREWED)
		return FALSE

	if(cable.get_amount() < 5)
		balloon_alert(user, LANG("obj.98d23e06e35c4140", list(cable::name)))
		return FALSE

	balloon_alert(user, LANG("obj.8b4be38e1e3a0291", null))
	if(!cable.use_tool(src, user, 2 SECONDS, 5, 50, CHECK_STATE_CALLBACK(CORE_STATE_SCREWED)))
		return FALSE

	UPDATE_STATE(CORE_STATE_CABLED)
	return TRUE

/obj/structure/ai_core/proc/install_mmi(mob/living/user, obj/item/mmi/mmi)
	if(state != CORE_STATE_CABLED)
		return FALSE

	if(!mmi.brain_check(user))
		var/wants_install = (tgui_alert(user, LANG("obj.ea3215982a0ebdbf", list(AI_CORE_BRAIN(mmi))), LANG("obj.a7fbb8a21cb97963", list(AI_CORE_BRAIN(mmi))), list("Yes", "No")) == "Yes")
		if(!wants_install)
			return FALSE
		if(QDELETED(src) || QDELETED(user) || QDELETED(mmi) || !user.is_holding(mmi) || !Adjacent(user))
			return FALSE
		if(mmi.brainmob && HAS_TRAIT(mmi.brainmob, TRAIT_SUICIDED))
			balloon_alert(user, LANG("obj.9b12d35a5419609d", list(AI_CORE_BRAIN(mmi))))
			return FALSE
	else
		var/mob/living/brain/mmi_brainmob = mmi.brainmob
		if(!CONFIG_GET(flag/allow_ai) || (mmi_brainmob && is_banned_from(mmi_brainmob.ckey, JOB_AI)))
			if(!QDELETED(src) && !QDELETED(user) && !QDELETED(mmi) && user.is_holding(mmi) && Adjacent(user))
				balloon_alert(user, LANG("obj.adfcc7cae9ca08fe", list(mmi)))
			return FALSE

	if(state != CORE_STATE_CABLED)
		return FALSE
	if(!user.transferItemToLoc(mmi, src))
		return FALSE

	core_mmi = mmi
	UPDATE_STATE(CORE_STATE_CABLED)
	return TRUE

/obj/structure/ai_core/proc/install_glass(mob/living/user, obj/item/stack/sheet/rglass/glass)
	if(state != CORE_STATE_CABLED)
		return FALSE

	if(!core_mmi)
		balloon_alert(user, LANG("obj.ce48e05bfdf5732b", null))
		return FALSE
	if(glass.get_amount() < 2)
		balloon_alert(user, LANG("obj.98d23e06e35c4140", list(glass::name)))
		return FALSE

	if(!glass.use_tool(src, user, 2 SECONDS, 2, 50, CHECK_STATE_CALLBACK(CORE_STATE_CABLED)) || !core_mmi)
		return FALSE

	UPDATE_STATE(CORE_STATE_GLASSED)
	return TRUE

#undef CHECK_STATE_CALLBACK
#undef UPDATE_STATE
#undef AI_CORE_BRAIN
