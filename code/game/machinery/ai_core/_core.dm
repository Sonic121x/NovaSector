#define AI_CORE_BRAIN(X) X.braintype == "Android" ? "brain" : "MMI"

/obj/structure/ai_core
	name = "\improper AI核心"
	desc = "人工智能核心的框架。"
	icon = 'icons/mob/silicon/ai.dmi'
	icon_state = "build_0"
	base_icon_state = "build_"
	density = TRUE
	anchored = FALSE
	max_integrity = 500
	custom_materials = list(/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 4)
	var/state = CORE_STATE_EMPTY
	var/datum/ai_laws/laws
	var/obj/item/circuitboard/aicore/circuit
	var/obj/item/mmi/core_mmi

/obj/structure/ai_core/Initialize(mapload, state = src.state, obj/item/mmi/core_mmi = null)
	. = ..()
	laws = new
	laws.set_laws_config()

	if(core_mmi && state < CORE_STATE_CABLED)
		stack_trace("supplied a core_mmi as constructor argument, but core state wouldn't have accepted it!")
		state = CORE_STATE_FINISHED // just in case...
	src.state = state
	if(state >= CORE_STATE_CIRCUIT)
		circuit = new(src)
	if(state >= CORE_STATE_CABLED)
		if(!core_mmi)
			core_mmi = new /obj/item/mmi(src)
			core_mmi.brain = new(core_mmi)
			core_mmi.brain.organ_flags |= ORGAN_FROZEN
			core_mmi.set_brainmob(new /mob/living/brain())
			core_mmi.brainmob.container = core_mmi
			core_mmi.update_appearance()
		core_mmi.forceMove(src)
		src.core_mmi = core_mmi
		set_anchored(TRUE)

	update_appearance(UPDATE_ICON_STATE)

/obj/structure/ai_core/update_icon_state()
	cut_overlays()

	if(state != CORE_STATE_FINISHED)
		icon_state = "[base_icon_state][state]"
		if(state == CORE_STATE_CABLED && core_mmi)
			icon_state += "b"
	else

		icon_state = "ai-core"

		var/mutable_appearance/screen = mutable_appearance(icon, "ai-empty")
		screen.layer = FLOAT_LAYER
		screen.appearance_flags = RESET_COLOR | KEEP_APART

		add_overlay(screen)

		add_overlay(emissive_appearance(icon, "ai-empty", src, alpha = 255))

		set_light(0.2, 0.2, LIGHT_COLOR_FAINT_CYAN)

	return ..()

/obj/structure/ai_core/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == circuit)
		circuit = null
		if((state != CORE_STATE_GLASSED) && (state != CORE_STATE_FINISHED))
			state = CORE_STATE_EMPTY
			update_appearance()
	if(gone == core_mmi)
		core_mmi = null
		update_appearance()

/obj/structure/ai_core/atom_deconstruct(disassembled = TRUE)
	if(state >= CORE_STATE_GLASSED)
		new /obj/item/stack/sheet/rglass(drop_location(), 2)
	if(state >= CORE_STATE_CABLED)
		new /obj/item/stack/cable_coil(drop_location(), 5)
	core_mmi?.forceMove(drop_location())
	circuit?.forceMove(drop_location())
	new /obj/item/stack/sheet/plasteel(drop_location(), 4)

/obj/structure/ai_core/Destroy()
	QDEL_NULL(circuit)
	QDEL_NULL(core_mmi)
	QDEL_NULL(laws)
	return ..()

/obj/structure/ai_core/examine(mob/user)
	. = ..()
	. += span_notice("It has some <b>bolts</b> that look [anchored ? "tightened" : "loosened"].")

	switch(state)
		if(CORE_STATE_EMPTY)
			. += span_notice("有一个用于放置电路板的<b>插槽</b>，框架可以<b>熔化</b>回收。")
		if(CORE_STATE_CIRCUIT)
			. += span_notice("电路板可以<b>拧紧</b>固定或<b>撬出</b>。")
		if(CORE_STATE_SCREWED)
			. += span_notice("框架可以<b>接线</b>，电路板可以<b>松开</b>。")
		if(CORE_STATE_CABLED)
			if(!core_mmi)
				. += span_notice("有电线可以连接到<b>MMI或正电子脑</b>，或者<b>切断</b>。")
			else
				var/accept_laws = TRUE
				if(core_mmi.laws.id != DEFAULT_AI_LAWID || !core_mmi.brainmob || !core_mmi.brainmob?.mind)
					accept_laws = FALSE
				. += span_notice("There is a <b>slot</b> for a reinforced glass panel, the [AI_CORE_BRAIN(core_mmi)] could be <b>pried</b> out.[accept_laws ? " A law module can be <b>swiped</b> across." : ""]")
		if(CORE_STATE_GLASSED)
			. += span_notice("The monitor [core_mmi?.brainmob?.mind && !suicide_check() ? "and neural interface " : ""]can be <b>screwed</b> in, the panel can be <b>pried</b> out.")
		if(CORE_STATE_FINISHED)
			. += span_notice("监视器的连接可以<b>切断</b>[core_mmi?.brainmob?.mind && !suicide_check() ? " the neural interface can be <b>screwed</b> in." : "."]")

/obj/structure/ai_core/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(state < CORE_STATE_FINISHED)
		return construction_item_interaction(user, tool, modifiers)

	return NONE

/// Exists to be used for callbacks.
/obj/structure/ai_core/proc/check_state(state_to_check)
	return (state == state_to_check)

/obj/structure/ai_core/latejoin_inactive
	name = "联网AI核心"
	desc = "这个AI核心通过蓝空间发射器连接到NTNet，允许在班次中途动态下载AI人格。"
	anchored = TRUE
	state = CORE_STATE_FINISHED
	var/available = TRUE
	var/safety_checks = TRUE
	var/active = TRUE

/obj/structure/ai_core/latejoin_inactive/Initialize(mapload, state, posibrain)
	. = ..()
	GLOB.latejoin_ai_cores += src

/obj/structure/ai_core/latejoin_inactive/Destroy()
	GLOB.latejoin_ai_cores -= src
	return ..()

/obj/structure/ai_core/latejoin_inactive/examine(mob/user)
	. = ..()
	. += "Its transmitter seems to be <b>[active? "on" : "off"]</b>."
	. += span_notice("你可以用多功能工具[active? "deactivate" : "activate"]它。")

/obj/structure/ai_core/latejoin_inactive/proc/is_available() //If people still manage to use this feature to spawn-kill AI latejoins ahelp them.
	if(!available)
		return FALSE
	if(!safety_checks)
		return TRUE
	if(!active)
		return FALSE
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	if(!(A.area_flags & BLOBS_ALLOWED))
		return FALSE
	if(!A.power_equip)
		return FALSE
	if(!SSmapping.level_trait(T.z,ZTRAIT_STATION))
		return FALSE
	if(!isfloorturf(T))
		return FALSE
	return TRUE

/obj/structure/ai_core/latejoin_inactive/multitool_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE

	if(!tool.use_tool(src, user, 0 SECONDS, 0, 50))
		return ITEM_INTERACT_BLOCKING

	active = !active
	balloon_alert(user, "[active ? "activated" : "deactivated"]发射器")
	return ITEM_INTERACT_SUCCESS

/obj/structure/ai_core/proc/ai_structure_to_mob()
	var/mob/living/brain/the_brainmob = core_mmi.brainmob
	if(!the_brainmob.mind || suicide_check())
		return FALSE
	the_brainmob.mind.remove_antags_for_borging()
	if(!the_brainmob.mind.has_ever_been_ai)
		SSblackbox.record_feedback("amount", "ais_created", 1)
	var/mob/living/silicon/ai/ai_mob = null

	if(core_mmi.overrides_aicore_laws)
		ai_mob = new /mob/living/silicon/ai(loc, core_mmi.laws, the_brainmob)
		core_mmi.laws = null //MMI's law datum is being donated, so we need the MMI to let it go or the GC will eat it
	else
		ai_mob = new /mob/living/silicon/ai(loc, laws, the_brainmob)
		laws = null //we're giving the new AI this datum, so let's not delete it when we qdel(src) 5 lines from now

	var/datum/antagonist/malf_ai/malf_datum = IS_MALF_AI(ai_mob)
	if(malf_datum)
		malf_datum.add_law_zero()

	if(!isnull(the_brainmob.client))
		ai_mob.set_gender(the_brainmob.client)
	if(core_mmi.force_replace_ai_name)
		ai_mob.fully_replace_character_name(ai_mob.name, core_mmi.replacement_ai_name())
	ai_mob.posibrain_inside = core_mmi.braintype == "Android"
	deadchat_broadcast("已在<b>[get_area_name(ai_mob, format_text = TRUE)]</b>上线。", span_name("[ai_mob]"), follow_target = ai_mob, message_type = DEADCHAT_ANNOUNCEMENT)
	qdel(src)
	return ai_mob

/// Quick proc to call to see if the brainmob inside of us has suicided. Returns TRUE if we have, FALSE in any other scenario.
/obj/structure/ai_core/proc/suicide_check()
	if(isnull(core_mmi) || isnull(core_mmi.brainmob))
		return FALSE
	return HAS_TRAIT(core_mmi.brainmob, TRAIT_SUICIDED)

/*
This is a good place for AI-related object verbs so I'm sticking it here.
If adding stuff to this, don't forget that an AI need to cancel_camera() whenever it physically moves to a different location.
That prevents a few funky behaviors.
*/
//The type of interaction, the player performing the operation, the AI itself, and the card object, if any.


/atom/proc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	SHOULD_CALL_PARENT(TRUE)
	if(istype(card))
		if(card.flush)
			to_chat(user, span_alert("错误：AI 刷新正在进行中，无法执行传输协议。"))
			return FALSE
	return TRUE

/obj/structure/ai_core/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(state != CORE_STATE_FINISHED || !..())
		return
	if(core_mmi && core_mmi.brainmob)
		if(core_mmi.brainmob.mind)
			to_chat(user, span_warning("[src] 已包含一个活跃的意识！"))
			return
		else if(suicide_check())
			to_chat(user, span_warning("安装在[src]中的[AI_CORE_BRAIN(core_mmi)]完全无用！"))
			return
	//Transferring a carded AI to a core.
	if(interaction == AI_TRANS_FROM_CARD)
		AI.set_control_disabled(FALSE)
		AI.radio_enabled = TRUE
		AI.forceMove(loc) // to replace the terminal.
		to_chat(AI, span_notice("你已被上传至固定终端。远程设备连接已恢复。"))
		to_chat(user, "[span_boldnotice("Transfer successful")]: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
		card.AI = null
		AI.battery = circuit.battery
		AI.posibrain_inside = isnull(core_mmi) || core_mmi.braintype == "Android"
		qdel(src)
	else //If for some reason you use an empty card on an empty AI terminal.
		to_chat(user, span_alert("此终端上没有加载任何 AI。"))

/obj/item/circuitboard/aicore
	name = "AI核心（AI核心主板）" //Well, duh, but best to be consistent
	var/battery = 200 //backup battery for when the AI loses power. Copied to/from AI mobs when carding, and placed here to avoid recharge via deconning the core

/obj/item/circuitboard/aicore/Initialize(mapload)
	. = ..()
	if(mapload && HAS_TRAIT(SSstation, STATION_TRAIT_HUMAN_AI))
		return INITIALIZE_HINT_QDEL

#undef AI_CORE_BRAIN
