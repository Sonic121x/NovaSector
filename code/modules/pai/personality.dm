// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
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
		to_chat(usr, span_warning(LANG("datum.efaa03cf869ae3df", null)))
		return FALSE
	var/savefile/F = new /savefile(src.savefile_path(user))
	WRITE_FILE(F["name"], name)
	WRITE_FILE(F["description"], description)
	WRITE_FILE(F["comments"], comments)
	WRITE_FILE(F["version"], 1)
	to_chat(usr, span_boldnotice(LANG("datum.e9e46543895228be", null)))
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
			tgui_alert(user, LANG("datum.49fb47f71d97fb39", null))
		return FALSE

	F["name"] >> src.name
	F["description"] >> src.description
	F["comments"] >> src.comments
	return TRUE
