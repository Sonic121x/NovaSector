// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GLOBAL_LIST_EMPTY(custom_outfits) //Admin created outfits


/datum/admins/proc/save_outfit(mob/admin, datum/outfit/O)
	O.save_to_file(admin)
	SStgui.update_user_uis(admin)

/datum/admins/proc/delete_outfit(mob/admin, datum/outfit/O)
	GLOB.custom_outfits -= O
	qdel(O)
	to_chat(admin,span_notice(LANG("datum.955af2b281f9365c", null)))
	SStgui.update_user_uis(admin)

/datum/admins/proc/load_outfit(mob/admin)
	var/outfit_file = input(LANG("datum.ac56c1abde8bca76", null), LANG("datum.c79013ac2f26ad68", null)) as null|file
	if(!outfit_file)
		return
	var/filedata = file2text(outfit_file)
	var/json = json_decode(filedata)
	if(!json)
		to_chat(admin,span_warning(LANG("datum.af6814d6d7445d8c", null)))
		return
	var/otype = text2path(json["outfit_type"])
	if(!ispath(otype,/datum/outfit))
		to_chat(admin,span_warning(LANG("datum.5140b96275dea228", null)))
		return
	var/datum/outfit/O = new otype
	if(!O.load_from(json))
		to_chat(admin,span_warning(LANG("datum.5140b96275dea228", null)))
		return
	GLOB.custom_outfits += O
	SStgui.update_user_uis(admin)

