// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/hallucination/telepathy
	random_hallucination_weight = 4
	hallucination_tier = HALLUCINATION_TIER_COMMON

/datum/hallucination/telepathy/start()
	var/datum/action/cooldown/spell/list_target/telepathy/mimiced_type = pick(typesof(/datum/action/cooldown/spell/list_target/telepathy))
	hallucinator.balloon_alert(hallucinator, LANG("datum.d955e9509c93251b", null))
	to_chat(hallucinator, LANG("datum.ff930a6510f9fa1c", list(initial(mimiced_type.bold_telepathy_span), initial(mimiced_type.telepathy_span), get_telepath_message())))
	return TRUE

/datum/hallucination/telepathy/proc/get_telepath_message()
	if(prob(0.001))
		return "horse"

	var/memo = pick(
		pick_list_replacements(HALLUCINATION_FILE, "advice"),
		pick_list_replacements(HALLUCINATION_FILE, "aggressive"),
		pick_list_replacements(HALLUCINATION_FILE, "conversation"),
		pick_list_replacements(HALLUCINATION_FILE, "didyouhearthat"),
		pick_list_replacements(HALLUCINATION_FILE, "doubt"),
		pick_list_replacements(HALLUCINATION_FILE, "escape"),
		pick_list_replacements(HALLUCINATION_FILE, "getout"),
		pick_list_replacements(HALLUCINATION_FILE, "greetings"),
		pick_list_replacements(HALLUCINATION_FILE, "suspicion"),
	)
	var/names = pick(
		first_name(hallucinator.name),
		last_name(hallucinator.name),
		first_name(hallucinator.real_name),
		last_name(hallucinator.real_name),
	)

	return replacetext(memo, "%TARGETNAME%", names)
