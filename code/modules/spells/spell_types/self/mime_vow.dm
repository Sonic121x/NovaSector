// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/vow_of_silence
	name = "Break Vow"
	desc = "Break your vow of silence. Permanently."
	background_icon_state = "bg_mime"
	overlay_icon_state = "bg_mime_border"
	button_icon = 'icons/mob/actions/actions_mime.dmi'
	button_icon_state = "mime_speech"

	school = SCHOOL_MIME
	//MMI mimes should be able to break their vow
	spell_requirements = SPELL_CASTABLE_AS_BRAIN

	spell_max_level = 1

/datum/action/cooldown/spell/vow_of_silence/Grant(mob/grant_to)
	. = ..()
	ADD_TRAIT(grant_to, TRAIT_MIMING, "[type]")

/datum/action/cooldown/spell/vow_of_silence/Remove(mob/living/remove_from)
	. = ..()
	REMOVE_TRAIT(remove_from, TRAIT_MIMING, "[type]")

/datum/action/cooldown/spell/vow_of_silence/before_cast(atom/cast_on)
	if(tgui_alert(usr, LANG("datum.86d9c12b6222b573", null), LANG("datum.5865789161944402", null), list("I'm Sure", "Abort")) != "I'm Sure")
		return SPELL_CANCEL_CAST
	return ..()

/datum/action/cooldown/spell/vow_of_silence/cast(mob/living/carbon/human/cast_on)
	. = ..()
	to_chat(cast_on, span_notice(LANG("datum.ad27cffc46597c02", null)))
	cast_on.log_message("broke [cast_on.p_their()] vow of silence.", LOG_GAME)
	cast_on.add_mood_event("vow", /datum/mood_event/broken_vow)
	REMOVE_TRAIT(cast_on, TRAIT_MIMING, "[type]")
	var/datum/job/mime/mime_job = SSjob.get_job(JOB_MIME)
	mime_job.total_positions += 1
	qdel(src)
