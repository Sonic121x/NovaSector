/**
 * name
 * key
 * description
 * role
 * comments
 * ready = TRUE
 */

/datum/pai_candidate/proc/savefile_path(mob/user)
	return "data/player_saves/[user.ckey[1]]/[user.ckey]/pai.sav"

/datum/pai_candidate/proc/savefile_save(mob/user)
	if(is_guest_key(user.key))
		to_chat(usr, span_warning("您无法以访客身份保存pAI信息。"))
		return FALSE
	var/savefile/F = new /savefile(src.savefile_path(user))
	WRITE_FILE(F["name"], name)
	WRITE_FILE(F["description"], description)
	WRITE_FILE(F["comments"], comments)
	WRITE_FILE(F["version"], 1)
	to_chat(usr, span_boldnotice("您已将pAI信息保存至本地。"))
	return TRUE

// loads the savefile corresponding to the mob's ckey
// if silent=true, report incompatible savefiles
// returns TRUE if loaded (or file was incompatible)
// returns FALSE if savefile did not exist

/datum/pai_candidate/proc/savefile_load(mob/user, silent = TRUE)
	if (is_guest_key(user.key))
		return FALSE

	var/path = savefile_path(user)

	if (!fexists(path))
		return FALSE

	var/savefile/F = new /savefile(path)

	if(!F)
		return //Not everyone has a pai savefile.

	var/version = null
	F["version"] >> version

	if (isnull(version) || version != 1)
		fdel(path)
		if (!silent)
			tgui_alert(user, "您的存档文件与此版本不兼容，已被删除。")
		return FALSE

	F["name"] >> src.name
	F["description"] >> src.description
	F["comments"] >> src.comments
	return TRUE
