/datum/action/changeling/mimicvoice
	name = "模仿声音"
	desc = "使我们依据要求自由改变我们的音色到任何形式. 保持此状态将减缓化学点的回复"
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
		to_chat(user, span_notice("我们将声腺恢复到了原始位置。"))
		return

	var/mimic_voice = sanitize_name(tgui_input_text(user, "输入要模仿的名字", "模仿声音", max_length = MAX_NAME_LEN))
	if(!mimic_voice)
		return
	..()
	changeling.chem_recharge_slowdown += 0.25
	user.override_voice = mimic_voice
	to_chat(user, span_notice("我们重塑声腺以模仿<b>[mimic_voice]</b>的声音，激活时会减缓化学物质再生速度。"))
	to_chat(user, span_notice("再次使用此能力可恢复原声并使化学物质生产回归正常水平。"))
	return TRUE

/datum/action/changeling/mimicvoice/Remove(mob/living/carbon/human/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(user.override_voice)
		changeling?.chem_recharge_slowdown = max(0, changeling.chem_recharge_slowdown - 0.25)
		user.override_voice = ""
		to_chat(user, span_notice("我们的声腺回到了原始位置。"))
	. = ..()
