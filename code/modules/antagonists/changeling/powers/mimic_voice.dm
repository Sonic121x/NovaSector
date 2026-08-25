// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/changeling/mimicvoice
	name = "Mimic Voice"
	desc = "We shape our vocal glands to sound like a desired voice. Maintaining this power slows chemical production."
	button_icon_state = "mimic_voice"
	helptext = "Will turn our voice into the name that we enter. We must constantly expend chemicals to maintain our form like this."
	category = "stealth"
	chemical_cost = 0//constant chemical drain hardcoded
	dna_cost = 1
	req_human = TRUE

// Fake Voice
/datum/action/changeling/mimicvoice/sting_action(mob/living/carbon/human/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(user.override_voice)
		changeling.chem_recharge_slowdown -= 0.25
		user.override_voice = ""
		to_chat(user, span_notice(LANG("datum.67a9ab0bdbdba831", null)))
		return

	var/mimic_voice = sanitize_name(tgui_input_text(user, LANG("datum.8ab945b213527ab5", null), LANG("datum.6bc9723c0959d97f", null), max_length = MAX_NAME_LEN))
	if(!mimic_voice)
		return
	..()
	changeling.chem_recharge_slowdown += 0.25
	user.override_voice = mimic_voice
	to_chat(user, span_notice(LANG("datum.f298c79e5cf28e24", list(mimic_voice))))
	to_chat(user, span_notice(LANG("datum.fdb6871d3c065d23", null)))
	return TRUE

/datum/action/changeling/mimicvoice/Remove(mob/living/carbon/human/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(user.override_voice)
		changeling?.chem_recharge_slowdown = max(0, changeling.chem_recharge_slowdown - 0.25)
		user.override_voice = ""
		to_chat(user, span_notice(LANG("datum.ff065c2de03663b4", null)))
	. = ..()
