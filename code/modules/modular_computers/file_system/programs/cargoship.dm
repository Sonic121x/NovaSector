// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/computer_file/program/shipping
	filename = "shipping"
	filedesc = "GrandArk Exporter"
	downloader_category = PROGRAM_CATEGORY_SUPPLY
	program_open_overlay = "shipping"
	extended_desc = "A combination printer/scanner app that enables modular computers to print barcodes for easy scanning and shipping."
	size = 6
	tgui_id = "NtosShipping"
	program_icon = "tags"
	///Account used for creating barcodes.
	var/datum/bank_account/payments_acc
	///The person who tagged this will receive the sale value multiplied by this number.
	var/cut_multiplier = 0.5
	///Maximum value for cut_multiplier.
	var/cut_max = 0.5
	///Minimum value for cut_multiplier.
	var/cut_min = 0.01

/datum/computer_file/program/shipping/ui_data(mob/user)
	var/list/data = list()

	data["has_id_slot"] = !!computer.stored_id
	data["paperamt"] = "[computer.stored_paper] / [computer.max_paper]"
	data["card_owner"] = computer.stored_id || "No Card Inserted."
	data["current_user"] = payments_acc ? payments_acc.account_holder : null
	data["barcode_split"] = cut_multiplier * 100
	return data

/datum/computer_file/program/shipping/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!computer.stored_id) //We need an ID to successfully run
		return FALSE

	switch(action)
		if("ejectid")
			computer.remove_id(usr)
		if("selectid")
			if(!computer.stored_id.registered_account)
				playsound(get_turf(computer.ui_host()), 'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE, -1)
				return TRUE
			payments_acc = computer.stored_id.registered_account
			playsound(get_turf(computer.ui_host()), 'sound/machines/ping.ogg', 50, TRUE, -1)
		if("resetid")
			payments_acc = null
		if("setsplit")
			var/potential_cut = input(LANG("datum.64a2bf7c13540cc7", null),LANG("datum.9464744c35f078e2", list(round(cut_min*100), round(cut_max*100)))) as num|null
			cut_multiplier = potential_cut ? clamp(round(potential_cut/100, cut_min), cut_min, cut_max) : initial(cut_multiplier)
		if("print")
			if(computer.stored_paper <= 0)
				to_chat(usr, span_notice(LANG("datum.8f26e725be4eae5b", null)))
				return TRUE
			if(!payments_acc)
				to_chat(usr, span_notice(LANG("datum.aaf33d07be4be0ae", null)))
				return TRUE
			var/obj/item/barcode/barcode = new /obj/item/barcode(get_turf(computer.ui_host()))
			barcode.payments_acc = payments_acc
			barcode.cut_multiplier = cut_multiplier
			computer.stored_paper--
			to_chat(usr, span_notice(LANG("datum.280b8c1aeb2417e3", null)))
