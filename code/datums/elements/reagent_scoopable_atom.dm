// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/element/reagent_scoopable_atom
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2
	var/datum/reagent/reagent_to_extract

/datum/element/reagent_scoopable_atom/Attach(datum/target, reagent_to_extract)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(!reagent_to_extract)
		CRASH("[type] added to [target] without any reagent specified.")
	src.reagent_to_extract = reagent_to_extract
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))

/datum/element/reagent_scoopable_atom/Detach(datum/source, ...)
	UnregisterSignal(source, list(COMSIG_ATOM_EXAMINE, COMSIG_ATOM_ITEM_INTERACTION))
	return ..()

/datum/element/reagent_scoopable_atom/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_info(LANG("datum.7515092e6af2b328", list(reagent_to_extract::name)))

/datum/element/reagent_scoopable_atom/proc/on_item_interaction(atom/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER

	if(tool.is_open_container())
		return extract_reagents(source, tool, user)

/datum/element/reagent_scoopable_atom/proc/extract_reagents(atom/source, obj/item/container, mob/living/user)
	if(!reagent_to_extract)
		return ITEM_INTERACT_BLOCKING
	if(!container.reagents.add_reagent(reagent_to_extract, rand(5, 10)))
		to_chat(user, span_warning(LANG("datum.8e2d390ca03cb226", list(container))))
	user.visible_message(span_notice(LANG("datum.14a5f54418403ce8", list(user, LOWER_TEXT(reagent_to_extract::name), source, container))), span_notice(LANG("datum.c775c2bb75f6b433", list(LOWER_TEXT(reagent_to_extract::name), source, container))))
	return ITEM_INTERACT_SUCCESS
