// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// how long it takes to infuse
#define INFUSING_TIME 4 SECONDS
/// we throw in a scream along the way.
#define SCREAM_TIME 3 SECONDS

/obj/machinery/dna_infuser
	name = "\improper DNA infuser"
	desc = "A defunct genetics machine for merging foreign DNA with a subject's own."
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "infuser"
	base_icon_state = "infuser"
	density = TRUE
	obj_flags = BLOCKS_CONSTRUCTION // Becomes undense when the door is open
	interaction_flags_mouse_drop = NEED_HANDS | NEED_DEXTERITY
	circuit = /obj/item/circuitboard/machine/dna_infuser

	/// maximum tier this will infuse
	var/max_tier_allowed = DNA_MUTANT_TIER_ONE
	///currently infusing a vict- subject
	var/infusing = FALSE
	///what we're infusing with
	var/atom/movable/infusing_from
	///what we're turning into
	var/datum/infuser_entry/infusing_into
	///a message for relaying that the machine is locked if someone tries to leave while it's active
	COOLDOWN_DECLARE(message_cooldown)

/obj/machinery/dna_infuser/Initialize(mapload)
	. = ..()
	occupant_typecache = typecacheof(/mob/living/carbon/human)

/obj/machinery/dna_infuser/Destroy()
	. = ..()
	//dump_inventory_contents called by parent, emptying infusing_from
	infusing_into = null

/obj/machinery/dna_infuser/examine(mob/user)
	. = ..()
	if(!occupant)
		. += span_notice(LANG("obj.a7e55fd2396c6eb6", list(span_bold("a subject"))))
	else
		. += span_notice(LANG("obj.c2d7ad78283c76e9", list(span_bold(occupant.name))))
	if(!infusing_from)
		. += span_notice(LANG("obj.e0901b5abc75ceef", list(span_bold("an infusion source"))))
	else
		. += span_notice(LANG("obj.3d53b2849fa7b725", list(span_bold(infusing_from.name))))
	. += span_notice(LANG("obj.dbab3ff742190ca2", null))
	. += span_notice(LANG("obj.0035f6bb8e61e93c", null))
	. += span_notice(LANG("obj.a27ef7d497d8243c", null))
	if(max_tier_allowed < DNA_INFUSER_MAX_TIER)
		. += span_boldnotice(LANG("obj.0c0a731fb3e918af", list(max_tier_allowed)))
	else
		. += span_boldnotice(LANG("obj.e3a13a51ea93389d", null))
	. += span_notice(LANG("obj.f175bafd27ce0f7b", null))

/obj/machinery/dna_infuser/examine_more(mob/user)
	. = ..()
	. += span_notice(LANG("obj.f26d4aba6b2e144b", list(DNA_MUTANT_TIER_ONE)))
	. += span_notice(LANG("obj.2d5aae1410e61906", list(DNA_INFUSER_MAX_TIER)))

/obj/machinery/dna_infuser/interact(mob/user)
	if(user == occupant)
		toggle_open(user)
		return
	if(infusing)
		balloon_alert(user, LANG("obj.90237552689cd5dc", null))
		return
	if(occupant && infusing_from)
		if(!occupant.can_infuse(user))
			playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 35, vary = TRUE)
			return
		balloon_alert(user, LANG("obj.3652f95f69588a7c", null))
		start_infuse()
		return
	toggle_open(user)

/obj/machinery/dna_infuser/proc/start_infuse()
	var/mob/living/carbon/human/human_occupant = occupant
	infusing = TRUE
	visible_message(span_notice(LANG("obj.f68ccdc8a4627a43", list(src))))

	infusing_into = infusing_from.get_infusion_entry()
	var/fail_title = ""
	var/fail_explanation = ""
	if(istype(infusing_into, /datum/infuser_entry/fly))
		fail_title = "Unknown DNA"
		fail_explanation = "Unknown DNA. Consult the \"DNA infusion book\"."
	if(infusing_into.tier > max_tier_allowed)
		infusing_into = GLOB.infuser_entries[/datum/infuser_entry/fly]
		fail_title = "Overcomplexity"
		fail_explanation = "DNA too complicated to infuse. The machine needs to infuse simpler DNA first."
	playsound(src, 'sound/machines/blender.ogg', 50, vary = TRUE)
	to_chat(human_occupant, span_danger(LANG("obj.a635165cfc7a4853", null)))
	human_occupant.take_overall_damage(10)
	human_occupant.add_mob_memory(/datum/memory/dna_infusion, protagonist = human_occupant, deuteragonist = infusing_from, mutantlike = infusing_into.infusion_desc)
	Shake(duration = INFUSING_TIME)
	addtimer(CALLBACK(human_occupant, TYPE_PROC_REF(/mob, emote), "scream"), INFUSING_TIME - 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end_infuse), fail_explanation, fail_title), INFUSING_TIME)
	update_appearance()

/obj/machinery/dna_infuser/proc/end_infuse(fail_explanation, fail_title)
	var/mob/living/carbon/human/human_occupant = occupant
	if(human_occupant.infuse_organ(infusing_into, infusing_from))
		check_tier_progression(human_occupant)
		to_chat(occupant, span_danger(LANG("obj.e81fd20f74ddcff9", list(infusing_into.infusion_desc))))
	infusing = FALSE
	infusing_into = null
	QDEL_NULL(infusing_from)
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, vary = FALSE)
	if(fail_explanation)
		playsound(src, 'sound/machines/printer.ogg', 100, TRUE)
		visible_message(span_notice(LANG("obj.0fbc5c29ccb0ba89", list(src))))
		var/obj/item/paper/printed_paper = new /obj/item/paper(loc)
		printed_paper.name = "error report - '[fail_title]'"
		printed_paper.add_raw_text(fail_explanation)
		printed_paper.update_appearance()
	toggle_open()
	update_appearance()

/// checks to see if the machine should progress a new tier.
/obj/machinery/dna_infuser/proc/check_tier_progression(mob/living/carbon/human/target)
	if(
		max_tier_allowed != DNA_INFUSER_MAX_TIER \
		&& infusing_into.tier == max_tier_allowed \
		&& target.has_status_effect(infusing_into.status_effect_type) \
	)
		max_tier_allowed++
		playsound(src, 'sound/machines/ding.ogg', 50, TRUE)
		visible_message(span_notice(LANG("obj.a88a9e2416717e8d", list(src))))

/obj/machinery/dna_infuser/update_icon_state()
	//out of order
	if(machine_stat & (NOPOWER | BROKEN))
		icon_state = base_icon_state
		return ..()
	//maintenance
	if((machine_stat & MAINT) || panel_open)
		icon_state = "[base_icon_state]_panel"
		return ..()
	//actively running
	if(infusing)
		icon_state = "[base_icon_state]_on"
		return ..()
	//open or not
	icon_state = "[base_icon_state][state_open ? "_open" : null]"
	return ..()

/obj/machinery/dna_infuser/proc/toggle_open(mob/user)
	if(panel_open)
		if(user)
			balloon_alert(user, LANG("obj.5ddfc4f037e5eca3", null))
		return
	if(state_open)
		close_machine()
		return
	else if(infusing)
		if(user)
			balloon_alert(user, LANG("obj.90237552689cd5dc", null))
		return
	open_machine(drop = FALSE)
	//we set drop to false to manually call it with an allowlist
	dump_inventory_contents(list(occupant))

/obj/machinery/dna_infuser/screwdriver_act(mob/living/user, obj/item/tool)
	return infusing ? NONE : default_deconstruction_screwdriver(user, tool)

/obj/machinery/dna_infuser/crowbar_act(mob/living/user, obj/item/tool)
	return infusing ? NONE : default_pry_open(user, tool, deconstruct_on_fail = TRUE)

/obj/machinery/dna_infuser/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE
	// if the machine already has a infusion target, or the target is not valid then no adding.
	if(!is_valid_infusion(tool, user))
		return ..() //research scanning is so back
	if(!user.transferItemToLoc(tool, src))
		to_chat(user, span_warning(LANG("obj.1dbf8014c030d016", list(tool))))
		return ITEM_INTERACT_BLOCKING
	infusing_from = tool
	return ITEM_INTERACT_SUCCESS

/obj/machinery/dna_infuser/relaymove(mob/living/user, direction)
	if(IS_UNCONSCIOUS_OR_CRIT(user))
		if(COOLDOWN_FINISHED(src, message_cooldown))
			COOLDOWN_START(src, message_cooldown, 4 SECONDS)
			to_chat(user, span_warning(LANG("obj.c4e897cb78099448", list(src))))
		return
	if(infusing)
		if(COOLDOWN_FINISHED(src, message_cooldown))
			COOLDOWN_START(src, message_cooldown, 4 SECONDS)
			to_chat(user, span_danger(LANG("obj.3ec20427e5250d40", list(src))))
		return
	open_machine(drop = FALSE)
	//we set drop to false to manually call it with an allowlist
	dump_inventory_contents(list(occupant))

// mostly good for dead mobs like corpses (drag to add).
/obj/machinery/dna_infuser/mouse_drop_receive(atom/target, mob/user, params)
	// if the machine is closed, already has a infusion target, or the target is not valid then no mouse drop.
	if(!is_valid_infusion(target, user))
		return
	infusing_from = target
	infusing_from.forceMove(src)

/// Verify that the given infusion source/mob is a dead creature.
/obj/machinery/dna_infuser/proc/is_valid_infusion(atom/movable/target, mob/user)
	if(infusing_from)
		balloon_alert(user, LANG("obj.1484b00d35b6bada", null))
		return FALSE
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat != DEAD)
			balloon_alert(user, LANG("obj.eb55d5221f29e673", null))
			return FALSE
	else if(!HAS_TRAIT(target, TRAIT_VALID_DNA_INFUSION))
		balloon_alert(user, LANG("obj.6c151f0ec0c49493", null))
		return FALSE
	return TRUE

/obj/machinery/dna_infuser/click_alt(mob/user)
	if(infusing)
		balloon_alert(user, LANG("obj.90237552689cd5dc", null))
		return CLICK_ACTION_BLOCKING
	if(!infusing_from)
		balloon_alert(user, LANG("obj.e48ae140f0a18f08", null))
		return CLICK_ACTION_BLOCKING
	balloon_alert(user, LANG("obj.42bdd311259f8973", null))
	infusing_from.forceMove(get_turf(src))
	infusing_from = null
	return CLICK_ACTION_SUCCESS

#undef INFUSING_TIME
#undef SCREAM_TIME
