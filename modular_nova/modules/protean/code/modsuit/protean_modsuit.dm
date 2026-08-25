/obj/item/mod/control/pre_equipped/protean
	name = "modsuit"
	desc = "The modsuit unit of a Protean, allowing them to retract into it, or to deploy a suit that protects against various environments."
	theme = /datum/mod_theme/protean

	applied_core = /obj/item/mod/core/protean
	applied_cell = null
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/protean_servo,
	)
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	/// Whether or not the wearer can undeploy parts.
	var/modlocked = FALSE
	/// Reference to an assimilated modsuit stored inside this one
	var/obj/item/mod/control/stored_modsuit
	/// Modules cached during assimilation that need to be restored on unassimilate
	var/list/cached_modules
	/// The original theme stored before assimilating another suit's theme
	var/datum/mod_theme/stored_theme

/datum/mod_theme/protean
	name = "protean"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/mod/control/pre_equipped/protean/Initialize(mapload, datum/mod_theme/new_theme, new_skin, obj/item/mod/core/new_core)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "protean")
	AddElement(/datum/element/strippable/protean, GLOB.strippable_human_items, TYPE_PROC_REF(/mob/living/carbon/human/, should_strip))

/// Shows or hides the blinking distress antenna overlay on the suit. Used to signal to
/// nearby players that the protean inside has retreated and is awaiting repair.
/obj/item/mod/control/pre_equipped/protean/proc/set_distress_signal(enabled)
	cut_overlay(mutable_appearance('modular_nova/modules/protean/icons/mob/species/protean/distress_light.dmi', "distress"))
	if(enabled)
		add_overlay(mutable_appearance('modular_nova/modules/protean/icons/mob/species/protean/distress_light.dmi', "distress"))

/obj/item/mod/control/pre_equipped/protean/Destroy(force)
	var/obj/item/mod/core/protean/protean_core = core
	var/mob/living/carbon/human/protean_mob = protean_core?.linked_protean
	if(protean_mob)
		set_protean_modsuit(protean_mob, null)
	if(stored_modsuit)
		for(var/obj/item/mod/module/modules in cached_modules)
			if(!modules.removable)
				qdel(modules)
				continue
			modules.forceMove(get_turf(src))
		LAZYNULL(cached_modules)
		stored_modsuit.forceMove(get_turf(src))
	stored_modsuit = null
	stored_theme = null
	return ..()

/obj/item/mod/control/pre_equipped/protean/wrench_act(mob/living/user, obj/item/wrench)
	to_chat(user, span_warning(LANG("obj.8c354e86c418f09a", list(src))))
	return FALSE

/obj/item/mod/control/pre_equipped/protean/emag_act(mob/user, obj/item/card/emag/emag_card)
	to_chat(user, span_warning(LANG("obj.ed6f4f2183556b03", list(src, emag_card))))
	return FALSE

/obj/item/mod/control/pre_equipped/protean/canStrip(mob/who)
	return TRUE

/obj/item/mod/control/pre_equipped/protean/doStrip(mob/stripper, mob/owner)
	if(!isprotean(wearer))
		REMOVE_TRAIT(src, TRAIT_NODROP, "protean")
		return ..()
	var/obj/item/mod/module/storage/inventory = locate() in src.modules
	if(!isnull(inventory))
		src.atom_storage.remove_all()
		to_chat(stripper, span_notice(LANG("obj.1db650e9fa88d7ac", null)))
		stripper.balloon_alert(stripper, LANG("obj.12f3de48921d2632", null))
		return TRUE

	to_chat(stripper, span_warning(LANG("obj.f60764d2b85634da", null)))
	stripper.balloon_alert(stripper, LANG("obj.9744cd8382578a11", null))
	return ..()

/obj/item/mod/control/pre_equipped/protean/proc/drop_suit()
	if(wearer)
		if(HAS_TRAIT(src, TRAIT_NODROP))
			REMOVE_TRAIT(src, TRAIT_NODROP, "protean")
		wearer.dropItemToGround(src, TRUE, TRUE, TRUE)

/// Proteans can lock themselves on people.
/obj/item/mod/control/pre_equipped/protean/proc/toggle_lock(forced = FALSE)
	if(modlocked && !forced && !isprotean(wearer))
		REMOVE_TRAIT(src, TRAIT_NODROP, "protean")
	modlocked = !modlocked

/obj/item/mod/control/pre_equipped/protean/equipped(mob/user, slot, initial)
	. = ..()

	if(isprotean(user) && slot == ITEM_SLOT_BACK)
		var/mob/living/carbon/human/human_user = user
		set_protean_modsuit(human_user, src)
		var/obj/item/mod/core/protean/protean_core = core
		if(protean_core)
			protean_core.linked_protean = human_user
		return
	if(slot == ITEM_SLOT_BACK && user)
		if(modlocked)
			ADD_TRAIT(src, TRAIT_NODROP, "protean")
			to_chat(user, span_warning(LANG("obj.d5636231f341f730", null)))

/obj/item/mod/control/pre_equipped/protean/choose_deploy(mob/user)
	if(!isprotean(user) && modlocked && active)
		balloon_alert(user, LANG("obj.3eff7f7959981ea3", null))
		return FALSE
	return ..()

/obj/item/mod/control/pre_equipped/protean/toggle_activate(mob/user, force_deactivate)
	if(!force_deactivate && modlocked && !isprotean(user) && active)
		balloon_alert(user, LANG("obj.8c6a7ea27649a608", null))
		return FALSE
	if(!active && user.has_status_effect(/datum/status_effect/protean_low_power_mode))
		balloon_alert(user, LANG("obj.06b54e8fb44190d1", null))
		playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		return FALSE
	return ..()

/obj/item/mod/control/pre_equipped/protean/quick_deploy(mob/user)
	if(!isprotean(user) && modlocked && active)
		balloon_alert(user, LANG("obj.86c3d0c61d4ec065", null))
		return FALSE
	return ..()

/obj/item/mod/control/pre_equipped/protean/retract(mob/user, obj/item/part, instant)
	if(!isprotean(user) && modlocked && active && !instant)
		balloon_alert(user, LANG("obj.cf8597767400e338", null))
		return FALSE
	return ..()

/// Protean Revival

/obj/item/mod/control/pre_equipped/protean/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	var/obj/item/mod/core/protean/protean_core = core
	var/mob/living/carbon/human/protean_in_suit = protean_core?.linked_protean
	if(isnull(protean_in_suit))
		return
	var/obj/item/organ/brain/protean/brain = protean_in_suit.get_organ_slot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/stomach/protean/refactory = protean_in_suit.get_organ_slot(ORGAN_SLOT_STOMACH)

	if(brain?.dead && open && istype(tool, /obj/item/organ/stomach/protean) && !refactory)
		if(HAS_TRAIT(protean_in_suit, TRAIT_DNR) || HAS_TRAIT(protean_in_suit, TRAIT_SUICIDED))
			balloon_alert(user, LANG("obj.7f56981e925ff91c", null))
			return ITEM_INTERACT_BLOCKING
		if(!do_after(user, 10 SECONDS))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/organ/stomach = tool
		stomach.Insert(protean_in_suit, TRUE, DELETE_IF_REPLACED)
		balloon_alert(user, LANG("obj.863baa0b9898fd21", null))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE, SILENCED_SOUND_EXTRARANGE)
		brain.revive_timer()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/mod/construction/plating))
		var/obj/item/mod/construction/plating/plates = tool
		var/datum/mod_theme/candidate_theme = GLOB.mod_themes[plates.theme]
		if(!(candidate_theme?.slot_flags & ITEM_SLOT_BACK))
			balloon_alert(user, LANG("obj.fbc9e3cdde5b4ae2", null))
			return ITEM_INTERACT_BLOCKING
		if(stored_modsuit)
			balloon_alert(user, LANG("obj.62599c8506a49e8d", null))
			return ITEM_INTERACT_BLOCKING
		if(active)
			balloon_alert(user, LANG("obj.837cbcec3c1f7d5e", null))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice(LANG("obj.1134c6abc473b597", list(tool))))
		if(!do_after(user, 4 SECONDS))
			return ITEM_INTERACT_BLOCKING
		assimilate_theme(user, tool)
		qdel(tool)
		playsound(src, 'sound/machines/click.ogg', 50, TRUE, SILENCED_SOUND_EXTRARANGE)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/mod/control))
		if(active)
			balloon_alert(user, LANG("obj.837cbcec3c1f7d5e", null))
			return ITEM_INTERACT_BLOCKING

		if(istype(tool, /obj/item/mod/control/pre_equipped/protean) || !(tool.slot_flags & ITEM_SLOT_BACK))
			balloon_alert(user, LANG("obj.fbc9e3cdde5b4ae2", null))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.09af2cc2e0613094", list(tool))))
		if(!do_after(user, 4 SECONDS))
			return ITEM_INTERACT_BLOCKING
		assimilate_modsuit(user, tool)
		playsound(src, 'sound/machines/click.ogg', 50, TRUE, SILENCED_SOUND_EXTRARANGE)
		return ITEM_INTERACT_SUCCESS

/obj/item/mod/control/pre_equipped/protean/ui_status(mob/user, datum/ui_state/state)
	var/obj/item/mod/core/protean/protean_core = core
	var/mob/living/carbon/human/protean_mob = protean_core?.linked_protean
	if(isprotean(protean_mob) && protean_mob == user && user.loc == src)
		return 2
	return ..()

/obj/item/mod/control/pre_equipped/protean/proc/assimilate_theme(mob/user, plating)
	var/obj/item/mod/construction/plating/plates = plating
	var/datum/mod_theme/the_theme = GLOB.mod_themes[plates.theme]

	name = initial(name)
	desc = initial(desc)

	for(var/obj/item/part as anything in get_parts())
		part.name = initial(name)
		part.desc = initial(desc)
		if(part.loc == src)
			continue
		retract(null, part, instant = TRUE)

	for(var/obj/item/mod/module/existing_module in modules)
		existing_module.on_uninstall()
	theme = the_theme
	the_theme.set_up_parts(src, the_theme.default_skin)
	for(var/obj/item/mod/module/existing_module in modules)
		existing_module.on_install()
	enforce_complexity_limit(user)
	update_static_data_for_all_viewers()

/obj/item/mod/control/pre_equipped/protean/proc/unassimilate_theme()
	if(stored_modsuit)
		balloon_alert(wearer, LANG("obj.760a846ddf908f88", null))
		return
	if(active)
		balloon_alert(wearer, LANG("obj.849313777b0d6adb", null))
		return
	for(var/obj/item/part as anything in get_parts())
		if(part.loc == src)
			continue
		retract(null, part, instant = TRUE)
	var/datum/mod_theme/default_theme = GLOB.mod_themes[initial(theme)]
	theme = default_theme
	default_theme.set_up_parts(src, default_theme.default_skin)
	name = initial(name)
	desc = initial(desc)
	enforce_complexity_limit(wearer)
	update_static_data_for_all_viewers()
	balloon_alert(wearer, LANG("obj.2c490ed9e6f48485", null))

/obj/item/mod/control/pre_equipped/protean/proc/assimilate_modsuit(mob/user, modsuit, forced)
	var/obj/item/mod/control/to_assimilate = modsuit
	if(stored_modsuit)
		to_chat(user, span_warning(LANG("obj.23e9192000fc2532", null)))
		if(forced)
			stack_trace("assimilate_modsuit: Tried to assimilate modsuit while there's already a stored modsuit. stored_modsuit: [stored_modsuit], new_modsuit: [to_assimilate]")
		return
	if(!user?.transferItemToLoc(to_assimilate, src, forced))
		balloon_alert(user, LANG("obj.bf05b7e9f7b3f3ad", null))
		return
	if(!forced)
		for(var/obj/item/part as anything in get_parts())
			if(part.loc == src)
				continue
			retract(null, part, instant = TRUE)
	stored_modsuit = to_assimilate
	stored_theme = theme
	// Unbind modules from old parts before theme swap creates new ones
	for(var/obj/item/mod/module/existing_module in modules)
		existing_module.on_uninstall()
	theme = to_assimilate.theme
	skin = to_assimilate.skin
	theme.set_up_parts(src, skin)
	// Rebind modules to the new parts
	for(var/obj/item/mod/module/existing_module in modules)
		existing_module.on_install()
	name = to_assimilate.name
	desc = to_assimilate.desc
	extended_desc = to_assimilate.extended_desc
	// Cache the protean servo module before transferring absorbed suit's modules
	var/obj/item/mod/module/protean_servo/servo = locate() in modules
	if(servo)
		LAZYADD(cached_modules, servo)
		uninstall(servo)
	// Copy the list since we're modifying it during iteration
	var/list/modules_to_transfer = to_assimilate.modules.Copy()
	for(var/obj/item/mod/module/module in modules_to_transfer)
		if(istype(module, /obj/item/mod/module/storage))
			var/obj/item/mod/module/storage/existing_storage = locate() in modules
			if(existing_storage)
				LAZYADD(cached_modules, existing_storage)
				to_chat(user, span_notice(LANG("obj.5ab48dfa56ec22ef", list(existing_storage))))
				uninstall(existing_storage)
		to_assimilate.uninstall(module)
		install(module)
		if(module in modules)
			continue
		if(!module.removable)
			qdel(module)
			continue
		var/turf/drop_turf = get_turf(src)
		if(drop_turf)
			module.forceMove(drop_turf)
			to_chat(user, span_warning(LANG("obj.d7b150302dc11ef2", list(module))))
		else
			qdel(module)
	// Re-install the protean servo on the new configuration
	if(servo)
		install(servo)
		if(servo in modules)
			LAZYREMOVE(cached_modules, servo)
	enforce_complexity_limit(user)
	update_static_data_for_all_viewers()

/// Sheds modules that exceed the suit's current complexity_max. Drops removable ones
/// to the floor and skips non-removable ones. Used after theme swaps that shrink the budget.
/obj/item/mod/control/pre_equipped/protean/proc/enforce_complexity_limit(mob/user)
	if(complexity <= complexity_max)
		return
	// Walk a copy so uninstall() can mutate `modules` safely; protect protean-essential modules.
	for(var/obj/item/mod/module/over as anything in modules.Copy())
		if(complexity <= complexity_max)
			break
		if(istype(over, /obj/item/mod/module/protean_servo))
			continue
		if(istype(over, /obj/item/mod/module/storage))
			continue
		uninstall(over)
		if(!over.removable)
			continue
		var/turf/drop_turf = get_turf(src)
		if(drop_turf)
			over.forceMove(drop_turf)
			if(user)
				to_chat(user, span_warning(LANG("obj.23a3ce5b32d12988", list(over))))
		else
			qdel(over)

/obj/item/mod/control/pre_equipped/protean/proc/unassimilate_modsuit(mob/living/user, forced = FALSE)
	if(!stored_modsuit)
		to_chat(user, span_warning(LANG("obj.5c82e355ef9bdd13", null)))
		return
	if(active && !forced)
		balloon_alert(user, LANG("obj.b90af0ffcf8418af", null))
		return
	if(!(user?.has_active_hand()) && !forced)
		balloon_alert(user, LANG("obj.7cd067c519465753", null))
		return

	if(!forced)
		to_chat(user, span_notice(LANG("obj.8668d1e66f7b2bf8", null)))
		if(!do_after(user, 4 SECONDS))
			return

	for(var/obj/item/part as anything in get_parts())
		if(part.loc == src)
			continue
		retract(null, part, instant = TRUE)

	complexity_max = initial(complexity_max)
	// Cache the protean servo so it stays on the protean suit
	var/obj/item/mod/module/protean_servo/servo = locate() in modules
	if(servo)
		LAZYADD(cached_modules, servo)
		uninstall(servo)
	// Copy list since we modify it during iteration
	var/list/modules_to_return = modules.Copy()
	for(var/obj/item/mod/module in modules_to_return)
		uninstall(module)
		stored_modsuit.install(module)
		if(module in stored_modsuit.modules)
			continue
		to_chat(user, span_notice(LANG("obj.505699e93ed7a7be", list(module))))
		module.forceMove(get_turf(src))

	var/list/cached_to_restore = LAZYLISTDUPLICATE(cached_modules)
	for(var/obj/item/mod/module/cached in cached_to_restore)
		install(cached)
		if(cached in modules)
			LAZYREMOVE(cached_modules, cached)
			continue
		to_chat(user, span_warning(LANG("obj.6ba9c13030a76d9c", list(cached))))
		stack_trace("Modsuit Unassimilate: cached module [cached] failed to return to original modsuit! [src]")
		LAZYREMOVE(cached_modules, cached)

	theme = stored_theme
	stored_theme = null
	skin = initial(skin)
	theme.set_up_parts(src, skin)
	name = initial(name)
	desc = initial(desc)
	extended_desc = initial(extended_desc)
	if(user?.can_put_in_hand(stored_modsuit, user.active_hand_index))
		user.put_in_hand(stored_modsuit, user.active_hand_index)
	else
		stored_modsuit.forceMove(get_turf(src))
	stored_modsuit = null
	enforce_complexity_limit(user)
	update_static_data_for_all_viewers()


/obj/item/mod/control/pre_equipped/protean/examine(mob/user)
	. = ..()
	var/obj/item/mod/core/protean/protean_core = core
	var/mob/living/carbon/human/protean_in_suit = protean_core?.linked_protean
	if(isnull(protean_in_suit))
		return
	var/obj/item/organ/brain/protean/brain = protean_in_suit.get_organ_slot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/stomach/protean/refactory = protean_in_suit.get_organ_slot(ORGAN_SLOT_STOMACH)
	var/t_He = protean_in_suit.p_They()
	var/t_him = protean_in_suit.p_them()
	var/t_has = protean_in_suit.p_have()
	var/t_is = protean_in_suit.p_are()
	if(!isnull(brain) || istype(brain))
		. += span_notice(LANG("obj.4f1eaa5d4a683a16", null))
		if(brain.dead)
			if(!open)
				. += isnull(refactory) ? span_warning("This Protean requires critical repairs! <b>Screwdriver them open.</b>") : span_notice("<b>Repairing systems...</b>")
			else
				. += isnull(refactory) ? span_warning("<b>Insert a new refactory</b>") : span_notice("<b>Refactory Installed! Repairing systems...</b>")
		if(protean_in_suit.key && !protean_in_suit.client)
			. += span_deadsay(LANG("obj.d46d2e4daeeac3d2", list(t_He, t_has, t_has, round(((world.time - protean_in_suit.lastclienttime) / (1 MINUTES)),1), t_He)))
		else if(!protean_in_suit.key && protean_in_suit.mind && !HAS_TRAIT(protean_in_suit, TRAIT_DNR) && !HAS_TRAIT(protean_in_suit, TRAIT_SUICIDED))
			. += span_deadsay(LANG("obj.ca39ea560d10bf65", list(t_He, t_is, t_him)))
		else if(!protean_in_suit.key)
			. += span_deadsay(LANG("obj.cb9d47585758c7e9", list(t_He, t_is, t_him)))

/**
 * Protean stripping while they're in the suit.
 */
/datum/element/strippable/protean

/datum/element/strippable/protean/Attach(datum/target, list/items, should_strip_proc_path)
	. = ..()
	RegisterSignal(target, COMSIG_CLICK_CTRL_SHIFT, PROC_REF(click_control_shift))

/datum/element/strippable/protean/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_CLICK_CTRL_SHIFT)

/datum/element/strippable/protean/proc/click_control_shift(datum/source, mob/user)
	SIGNAL_HANDLER

	var/obj/item/mod/control/pre_equipped/protean/suit = source
	if(!istype(suit))
		return
	var/obj/item/mod/core/protean/core = suit.core
	var/mob/living/carbon/human/protean_mob = core?.linked_protean
	if(isnull(protean_mob))
		return
	if(protean_mob == user)
		return
	if(suit.wearer == source)
		return
	if(!isnull(should_strip_proc_path) && !call(protean_mob, should_strip_proc_path)(user))
		return
	suit.balloon_alert_to_viewers(LANG("datum.6fa300449dbc4853", null))
	user.visible_message(span_warning(LANG("datum.55f50183f3499d2b", list(user, source))))
	ASYNC
		var/datum/strip_menu/protean/strip_menu = LAZYACCESS(strip_menus, protean_mob)
		if(isnull(strip_menu))
			strip_menu = new(protean_mob, src)
			LAZYSET(strip_menus, protean_mob, strip_menu)
		strip_menu.ui_interact(user)

/datum/strip_menu/protean

/datum/strip_menu/protean/ui_status(mob/user, datum/ui_state/state)
	// Use the suit's turf for adjacency, since the protean mob is located inside the suit object
	var/atom/adjacency_target = owner.loc?.loc ? owner.loc : owner
	return min(
		ui_status_only_living(user, owner),
		ui_status_user_has_free_hands(user, owner),
		ui_status_user_is_adjacent(user, adjacency_target, allow_tk = FALSE),
		HAS_TRAIT(user, TRAIT_CAN_STRIP) ? UI_INTERACTIVE : UI_UPDATE,
		max(
			ui_status_user_is_conscious_and_lying_down(user),
			ui_status_user_is_abled(user, owner),
		),
	)
