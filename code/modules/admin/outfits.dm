GLOBAL_LIST_EMPTY(custom_outfits) //Admin created outfits


/datum/admins/proc/save_outfit(mob/admin, datum/outfit/O)
	O.save_to_file(admin)
	SStgui.update_user_uis(admin)

/datum/admins/proc/delete_outfit(mob/admin, datum/outfit/O)
	GLOB.custom_outfits -= O
	qdel(O)
	to_chat(admin,span_notice("套装已删除。"))
	SStgui.update_user_uis(admin)

/datum/admins/proc/load_outfit(mob/admin)
	var/outfit_file = input("选择服装 json 文件：", "文件") as null|file
	if(!outfit_file)
		return
	var/filedata = file2text(outfit_file)
	var/json = json_decode(filedata)
	if(!json)
		to_chat(admin,span_warning("JSON解码错误。"))
		return
	var/otype = text2path(json["outfit_type"])
	if(!ispath(otype,/datum/outfit))
		to_chat(admin,span_warning("文件格式错误/已过时。"))
		return
	var/datum/outfit/O = new otype
	if(!O.load_from(json))
		to_chat(admin,span_warning("文件格式错误/已过时。"))
		return
	GLOB.custom_outfits += O
	SStgui.update_user_uis(admin)

