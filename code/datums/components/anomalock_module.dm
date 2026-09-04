// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/component/anomaly_locked_module
	var/obj/item/assembly/signaler/anomaly/core
	/// Accepted types of anomaly cores.
	var/list/accepted_anomalies
	/// If the core is removable once socketed.
	var/core_removable
	/// A proc to call before the core is inserted. Returns an ITEM_INTERACT define, which the component will itself return.
	var/pre_insert_callback
	/// A proc to call when the core is inserted.
	var/core_insert_callback
	/// A proc to call when the core is removed.
	var/core_remove_callback

/datum/component/anomaly_locked_module/Initialize(list/anomaly_types, prebuilt = FALSE, removable = TRUE, pre_insert_callback, insert_callback, remove_callback)
	. = ..()
	if(!istype(parent, /obj/item/mod/module))
		return COMPONENT_INCOMPATIBLE
	accepted_anomalies = typecacheof(anomaly_types)
	core_removable = removable
	src.pre_insert_callback = pre_insert_callback
	core_insert_callback = insert_callback
	core_remove_callback = remove_callback
	if(!prebuilt || !length(anomaly_types))
		return
	var/obj/item/assembly/signaler/anomaly/core_type = pick(anomaly_types)
	insert_core(parent, null, new core_type(parent), null)

/datum/component/anomaly_locked_module/Destroy(force)
	QDEL_NULL(core)
	return ..()

/datum/component/anomaly_locked_module/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MODULE_TRIGGERED, PROC_REF(on_module_triggered))
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interact))
	RegisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_SCREWDRIVER), PROC_REF(on_screwdriver_act))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_ICON_STATE, PROC_REF(on_update_icon_state))

/datum/component/anomaly_locked_module/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_MODULE_TRIGGERED,
		COMSIG_ATOM_ITEM_INTERACTION,
		COMSIG_ATOM_TOOL_ACT(TOOL_SCREWDRIVER),
		COMSIG_ATOM_EXAMINE,
		COMSIG_ATOM_UPDATE_ICON_STATE,
		))

/datum/component/anomaly_locked_module/proc/on_module_triggered(obj/item/mod/module/source, mob/living/wearer)
	SIGNAL_HANDLER
	if(!core)
		source.balloon_alert(wearer, LANG("datum.9c96952522f32061", null))
		return MOD_ABORT_USE

/datum/component/anomaly_locked_module/proc/on_item_interact(obj/item/mod/module/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	if(!is_type_in_typecache(tool, accepted_anomalies))
		return 0
	if(core)
		source.balloon_alert(user, LANG("datum.00b328e3912c1db9", null))
		return ITEM_INTERACT_FAILURE
	if(pre_insert_callback)
		var/callback_return
		if(istype(pre_insert_callback, /datum/callback))
			var/datum/callback/pre_insert_callback_datum = pre_insert_callback
			callback_return = pre_insert_callback_datum.Invoke(user, tool, modifiers)
		else
			callback_return = call(source, pre_insert_callback)(user, tool, modifiers)
		if(callback_return)
			return callback_return
	return insert_core(source, user, tool, modifiers)

/datum/component/anomaly_locked_module/proc/insert_core(obj/item/mod/module/source, mob/living/user, obj/item/new_core, list/modifiers)
	if(user && !user.transferItemToLoc(new_core, source))
		return ITEM_INTERACT_FAILURE
	core = new_core
	if(user)
		source.balloon_alert(user, LANG("datum.de575d7bc9109c27", null))
		playsound(source, 'sound/machines/click.ogg', 30, TRUE)
	source.update_appearance(UPDATE_ICON_STATE)
	if(core_insert_callback)
		if(istype(core_insert_callback, /datum/callback))
			var/datum/callback/core_insert_callback_datum = core_insert_callback
			core_insert_callback_datum.Invoke(core, user, modifiers)
		else
			call(source, core_insert_callback)(core, user, modifiers)
	return ITEM_INTERACT_SUCCESS

/datum/component/anomaly_locked_module/proc/on_screwdriver_act(obj/item/mod/module/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	if(!core)
		source.balloon_alert(user, LANG("datum.9c96952522f32061", null))
		return ITEM_INTERACT_FAILURE
	if(!core_removable)
		source.balloon_alert(user, LANG("datum.34c3361cda2041ab", null))
	INVOKE_ASYNC(src, PROC_REF(try_remove_core), source, user, tool)
	return ITEM_INTERACT_SUCCESS

/datum/component/anomaly_locked_module/proc/try_remove_core(obj/item/mod/module/source, mob/living/user, obj/item/tool)
	if(!do_after(user, 3 SECONDS, source))
		source.balloon_alert(user, LANG("datum.c67b5d274d6e724b", null))
		return
	source.balloon_alert(user, LANG("datum.8b10ca6a98faa6f4", null))
	core.forceMove(source.drop_location())
	if(source.Adjacent(user) && !issilicon(user))
		user.put_in_hands(core)
	core = null
	source.update_appearance(UPDATE_ICON_STATE)
	if(core_remove_callback)
		if(istype(core_remove_callback, /datum/callback))
			var/datum/callback/core_remove_callback_datum = core_remove_callback
			core_remove_callback_datum.Invoke(core, user)
		else
			call(source, core_remove_callback)(core, user)

/datum/component/anomaly_locked_module/proc/on_examine(obj/item/mod/module/source, mob/viewer, list/examine_list)
	SIGNAL_HANDLER
	if(!length(accepted_anomalies))
		return
	if(core)
		examine_list += span_notice(LANG("datum.38c48b00c0728b25", list(core.name, core_removable ? "You could remove it with a <b>screwdriver</b>..." : "Unfortunately, due to a design quirk, it's unremovable.")))
		return
	var/list/core_list = list()
	for(var/atom/core_path as anything in accepted_anomalies)
		core_list += initial(core_path.name)
	examine_list += span_notice(LANG("datum.1d9be268809d3921", list(lang_english_list(core_list, and_text = " or "))))
	if(!core_removable)
		examine_list += span_notice(LANG("datum.8a5d1e4d240758fe", null))

/datum/component/anomaly_locked_module/proc/on_update_icon_state(obj/item/mod/module/source)
	SIGNAL_HANDLER
	source.icon_state = source::icon_state + (core ? "-core" : "")
