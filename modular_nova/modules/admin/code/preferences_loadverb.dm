ADMIN_VERB(import_preferences, R_ADMIN, "导入偏好设置", "Upload a character preferences JSON file to the server.", ADMIN_CATEGORY_MAIN)
	var/player_key = tgui_input_text(user, LANG("datum.0043cff07ac6ab77", null), LANG("datum.8cc1c53b7e2a0809", null))
	if(!length(player_key))
		return

	player_key = ckey(player_key)

	// Prevent empty ckey after whitespace was stripped
	if(!length(player_key))
		return

	// Prevent spelling mistakes
	var/confirmation = tgui_alert(user, LANG("datum.e93c3b9cce7c9933", list(player_key)), LANG("datum.8cc1c53b7e2a0809", null), list("Confirm", "Cancel"))
	if(confirmation != "Confirm")
		return

	var/folder_path = "data/player_saves/[player_key[1]]/[player_key]"
	var/savefile_path = "[folder_path]/preferences.json"
	var/save_exists = fexists(savefile_path)

	// Prevent accidental overwriting
	if(save_exists)
		var/overwrite_confirmation = tgui_alert(user, LANG("datum.8e589fb05fa96679", list(player_key)), LANG("datum.8cc1c53b7e2a0809", null), list("Overwrite", "Cancel"))
		if(overwrite_confirmation != "Overwrite")
			return
	// Prevent accidental typos
	else
		var/creation_confirmation = tgui_alert(user, LANG("datum.d808a3d19e79529f", list(player_key)), LANG("datum.8cc1c53b7e2a0809", null), list("Create", "Cancel"))
		if(creation_confirmation != "Create")
			return

	// Upload the new JSON file
	var/uploaded_file = input(user, LANG("datum.eb3708b59e6f21f3", null), LANG("datum.8cc1c53b7e2a0809", null)) as null|file
	// Reject non-files, nulls, or blank files
	if(!isfile(uploaded_file) || !length(uploaded_file))
		return

	// Prevent simple mistakes
	if(!findtext("[uploaded_file]", ".json", -5))
		to_chat(user, span_warning(LANG("datum.93cb4c73ba470007", list(uploaded_file))), confidential = TRUE)
		return

	// Enforce filesize limit
	var/filesize = length(uploaded_file)
	var/filesize_limit = CONFIG_GET(number/savefile_upload_limit) * 1024
	if(filesize > filesize_limit)
		to_chat(user, span_warning(LANG("datum.e63a46893be25bc2", list(filesize, filesize_limit))), confidential = TRUE)
		return

	// Pre-parse the uploaded file to ensure valid JSON syntax
	var/new_save = file2text(uploaded_file)
	if(length(new_save) == 0)
		to_chat(user, span_warning(LANG("datum.1e25c7f283b0a4be", list(uploaded_file))), confidential = TRUE)
		return
	var/list/json_tree
	try
		json_tree = json_decode(new_save)
	catch(var/exception/err)
		log_admin("Failed to parse json savefile: [err]")
		log_runtime("Failed to parse json savefile: [err]")
		to_chat(user, span_warning(LANG("datum.0a568ea73afbbe45", list(err))))
		return

	if(isnull(json_tree) || !islist(json_tree) || !length(json_tree))
		log_admin("Failed to parse json savefile: File empty")
		to_chat(user, span_warning(LANG("datum.94ce119a7663582d", null)))
		return

	// Duck typecheck to ensure the JSON is a tgstation save file
	if(!json_tree.Find("version"))
		log_admin("Failed to parse json savefile: Version property is missing")
		to_chat(user, span_warning(LANG("datum.92ef83a0324f3924", null)))
		return

	// Enforce minimum savefile version
	if(user.prefs.check_savedata_version(json_tree) == SAVE_DATA_OBSOLETE)
		var/savefile_version = json_tree["version"]
		log_admin("Failed to parse json savefile: Version ([savefile_version]) is below minimum")
		to_chat(user, span_warning(LANG("datum.d6c0a87670a777a5", list(savefile_version))))
		return

	// Backup and delete the existing savefile if it exists
	if(save_exists)
		var/backup_limit = CONFIG_GET(number/savefile_backup_limit)
		if(backup_limit > 0)
			var/importbac_path = "[savefile_path].importbac"
			var/list/backup_files = flist(importbac_path)
			var/total_backups = length(backup_files)
			if(total_backups >= backup_limit)
				to_chat(user, span_warning(LANG("datum.a912c0a992b21a77", list(player_key))), confidential = TRUE)
				return
			if(total_backups > 0)
				importbac_path = "[importbac_path]-[total_backups + 1]"
			fcopy(savefile_path, importbac_path)
		// Delete the existing savefile
		fdel(savefile_path)
		// Delete migration backup saveile
		// Avoids an edge case where load_preferences() reverts to a stale backup file
		fdel("[savefile_path].updatebac")

	// Save the new file as text
	text2file(json_encode(json_tree), file(savefile_path))

	// Reset existing datum so it gets reloaded from the new file
	if(!isnull(GLOB.preferences_datums[player_key]))
		GLOB.preferences_datums[player_key] = null

	to_chat(user, span_danger(LANG("datum.238837da117805e5", list(player_key))), confidential = TRUE)
	log_admin("[key_name_admin(user)] has successfully imported new preferences for player [player_key].")
	message_admins("[key_name_admin(user)] has successfully imported new preferences for player [player_key].")

	// Find client of the target ckey so we can disconnect them
	var/client/target_client = GLOB.directory[player_key]
	if(!target_client)
		return

	// Disconnect the affected client to reset any prefs data cached in TGUI
	to_chat(target_client, span_danger(LANG("datum.76803e7578657304", null)), confidential = TRUE)
	log_admin("Kicked [player_key] to complete preference file importing.")
	message_admins("Kicked [player_key] to complete preference file importing.")
	// Delayed kick to give chat messages time to be delivered
	QDEL_IN(target_client, 2)
