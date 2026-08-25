// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define OPTION_RENAME "Rename"
#define OPTION_DESCRIPTION "Description"
#define OPTION_RESET "Reset"

/**
 * Renaming tool element
 *
 * When using this tool on an object with UNIQUE_RENAME,
 * lets the user rename/redesc it.
 */
/datum/element/tool_renaming

/datum/element/tool_renaming/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(attempt_rename))

/datum/element/tool_renaming/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_ITEM_INTERACTING_WITH_ATOM)

/datum/element/tool_renaming/proc/attempt_rename(datum/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	if(!isobj(interacting_with))
		return NONE

	var/obj/renamed_obj = interacting_with
	var/obj/item/tool = source

	if(!(renamed_obj.obj_flags & UNIQUE_RENAME) || !user.can_write(tool))
		return NONE
	INVOKE_ASYNC(src, PROC_REF(async_rename), user, renamed_obj, !(renamed_obj.obj_flags & RENAME_NO_DESC))
	return ITEM_INTERACT_SUCCESS

/datum/element/tool_renaming/proc/async_rename(mob/living/user, obj/renamed_obj, description_option)
	if(!renamed_obj.rename_checks(user))
		return
	var/custom_choice = tgui_input_list(user, LANG("datum.7a708639e0f238d9", null), LANG("datum.61e3a16f20d83e5c", null), list(OPTION_RENAME, description_option? OPTION_DESCRIPTION : null, OPTION_RESET))
	if(QDELETED(renamed_obj) || !user.can_perform_action(renamed_obj) || isnull(custom_choice))
		return

	switch(custom_choice)
		if(OPTION_RENAME)
			var/old_name = renamed_obj.name
			var/input = tgui_input_text(user, LANG("datum.4e5fcc1e9cad0e0b", list(renamed_obj)), LANG("datum.b2f87f0e5512f664", null), "[old_name]", MAX_NAME_LEN)
			if(QDELETED(renamed_obj) || !user.can_perform_action(renamed_obj))
				return
			if(input == old_name || !input)
				to_chat(user, span_notice(LANG("datum.faa1c330186fed23", list(renamed_obj, renamed_obj))))
				return
			renamed_obj.AddComponent(/datum/component/rename, renamed_obj.nameformat(input, user), renamed_obj.desc)
			to_chat(user, span_notice(LANG("datum.03914adf6e419e52", list(old_name, renamed_obj))))
			renamed_obj.update_appearance(UPDATE_NAME)

		if(OPTION_DESCRIPTION)
			var/old_desc = renamed_obj.desc
			var/input = tgui_input_text(user, LANG("datum.2603c9f504f9027a", list(renamed_obj)), LANG("datum.495197c1be2f241d", null), "[old_desc]", MAX_DESC_LEN)
			if(QDELETED(renamed_obj) || !user.can_perform_action(renamed_obj))
				return
			if(input == old_desc || !input)
				to_chat(user, span_notice(LANG("datum.37a3f15c349d5193", list(renamed_obj))))
				return
			renamed_obj.AddComponent(/datum/component/rename, renamed_obj.name, renamed_obj.descformat(input, user))
			to_chat(user, span_notice(LANG("datum.cf74bca9028452ac", list(renamed_obj))))
			renamed_obj.update_appearance(UPDATE_DESC)

		if(OPTION_RESET)
			qdel(renamed_obj.GetComponent(/datum/component/rename))
			to_chat(user, span_notice(LANG("datum.11ad748c1ed7de1d", list(renamed_obj, renamed_obj.obj_flags & RENAME_NO_DESC? "." : " and description."))))
			renamed_obj.rename_reset()
			renamed_obj.update_appearance(UPDATE_NAME | UPDATE_DESC)

#undef OPTION_RENAME
#undef OPTION_DESCRIPTION
#undef OPTION_RESET
