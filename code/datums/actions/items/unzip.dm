/datum/action/item_action/zipper
	name = "解开行李袋"
	desc = "解开你装备的行李袋以便访问其内容物。"

/datum/action/item_action/zipper/New(Target)
	. = ..()
	RegisterSignal(target, COMSIG_DUFFEL_ZIP_CHANGE, PROC_REF(on_zip_change))
	var/obj/item/storage/backpack/duffelbag/duffle_target = target
	on_zip_change(target, duffle_target.zipped_up)

/datum/action/item_action/zipper/proc/on_zip_change(datum/source, new_zip)
	SIGNAL_HANDLER
	if(new_zip)
		name = "解开" 
		desc = "解开你装备的行李袋以便访问其内容物。"
	else
		name = "拉上"
		desc = "拉上你装备的行李袋以便更快地移动。"
	build_all_button_icons(UPDATE_BUTTON_NAME)
