// revenant antag datum is given on login, so this should be fine
/datum/antagonist/revenant/on_gain()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(pick_name), owner.current)

/datum/antagonist/revenant/proc/pick_name(mob/living/basic/revenant/revenant)
	if(!istype(revenant))
		CRASH("Somehow a non-revenant got a revenant antag datum?")
	var/new_name = sanitize_name(reject_bad_text(tgui_input_text(revenant, LANG("datum.0f258ce68e6b8739", null), LANG("datum.56e37694314cc43a", null), revenant.name, MAX_NAME_LEN, encode = FALSE)), allow_numbers = TRUE)
	if(!new_name || new_name == revenant.name)
		if(tgui_alert(revenant, LANG("datum.f2f206a7831df176", list(revenant.name)), LANG("datum.56e37694314cc43a", null), list("Yes", "No")) == "Yes")
			return

	new_name = sanitize_name(reject_bad_text(tgui_input_text(revenant, LANG("datum.9f6184ffe83955cb", null), LANG("datum.56e37694314cc43a", null), revenant.name, MAX_NAME_LEN, encode = FALSE)), allow_numbers = TRUE)
	if(!new_name)
		return

	revenant.log_message("set their revenant name to [new_name]", LOG_OWNERSHIP)
	revenant.fully_replace_character_name(null, new_name)
	to_chat(revenant, span_revennotice(LANG("datum.6038a64d9969bcfe", list(span_name(new_name)))), type = MESSAGE_TYPE_INFO)
	return
