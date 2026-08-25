// Hey listen! Imgur doesn't actually work, it's been tested.

/datum/preference/text/headshot
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "headshot"
	maximum_value_length = MAX_MESSAGE_LEN
	///How much time between the informational chat messages?
	var/cooldown_duration = 1 MINUTES
	///Handles the informational chat message timer.
	var/cooldown_timer = 0
	///Assoc list of ckeys and their links, used to cut down on chat spam
	var/list/stored_links = list()
	var/static/link_regex = regex(@"i\.gyazo\.com|[a-z]\.l3n\.co|images2\.imgbox\.com|thumbs2\.imgbox\.com|files\.byondhome\.com")
	var/static/list/valid_extensions = list("jpg", "png", "jpeg") // Regex works fine, if you know how it works

/datum/preference/text/headshot/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target?.dna.features[EXAMINE_DNA_HEADSHOT] = value

/datum/preference/text/headshot/is_valid(value)
	if(!length(value))
		return TRUE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		to_chat(usr, span_warning(LANG("datum.6cfbbbe41b947cfa", null)))
		return

	if(!findtext(value, "."))
		to_chat(usr, span_warning(LANG("datum.620fcc9e96920cb0", null)))
		return
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		to_chat(usr, span_warning(LANG("datum.9e53f7a45613ecc6", list(lang_english_list(valid_extensions)))))
		return

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		to_chat(usr, span_warning(LANG("datum.67638ce02f21c239", null)))
		return

	if(stored_links[usr.ckey] && stored_links[usr.ckey][type] != value && cooldown_timer <= world.time)
		cooldown_timer = cooldown_duration + world.time
		to_chat(usr, span_notice(LANG("datum.7da2af25f60c5607", list(span_bold("do not use a real life photo or use any image that is less than serious.")))))
		to_chat(usr, span_notice(LANG("datum.0d698fa08acf3202", null)))
		to_chat(usr, span_notice(LANG("datum.a013fc59600c1141", null)))
		log_game("[usr] has set their Headshot image to '[value]'.")

	apply_headshot(value)
	return TRUE

/datum/preference/text/headshot/proc/apply_headshot(value)
	if(isnull(stored_links[usr?.ckey]))
		stored_links[usr?.ckey] = list()
	stored_links[usr?.ckey][type] = value
	return TRUE

/datum/preference/text/headshot/silicon
	savefile_key = "silicon_headshot"

/datum/preference/text/headshot/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/// Whether we see other people's headshots in the chat when we examine them.
/datum/preference/toggle/show_headshot_on_examine
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "show_headshot_on_examine"
	savefile_identifier = PREFERENCE_PLAYER
