// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/item_action/zipper
	name = "Unzip Duffel"
	desc = "Unzip your equipped duffelbag so you can access its contents."

/datum/action/item_action/zipper/New(Target)
	. = ..()
	RegisterSignal(target, COMSIG_DUFFEL_ZIP_CHANGE, PROC_REF(on_zip_change))
	var/obj/item/storage/backpack/duffelbag/duffle_target = target
	on_zip_change(target, duffle_target.zipped_up)

/datum/action/item_action/zipper/proc/on_zip_change(datum/source, new_zip)
	SIGNAL_HANDLER
	if(new_zip)
		name = "Unzip" 
		desc = LANG("datum.508af225578e6d0e", null)
	else
		name = "Zip"
		desc = LANG("datum.fa82961bc9ab83c7", null)
	build_all_button_icons(UPDATE_BUTTON_NAME)
