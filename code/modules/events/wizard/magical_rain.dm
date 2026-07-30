// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/round_event_control/wizard/magical_rain
	name = "Magical Rain"
	weight = 3
	typepath = /datum/round_event/wizard/magical_rain
	max_occurrences = 5
	earliest_start = 0 MINUTES
	description = "A magical thunderstorm rains down below, drenching anyone caught in it with mysterious rain."
	min_wizard_trigger_potency = 2
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/magical_rain
	end_when = 0
	var/started = FALSE

/datum/round_event/wizard/magical_rain/start()
	for(var/mob/living/wizard in GLOB.alive_mob_list)
		// give it to all wizards even if there are multiple
		if(IS_WIZARD(wizard) && !HAS_TRAIT_FROM(wizard, TRAIT_RAINSTORM_IMMUNE, MAGIC_TRAIT))
			ADD_TRAIT(wizard, TRAIT_RAINSTORM_IMMUNE, MAGIC_TRAIT)
			to_chat(wizard, span_reallybig(span_hypnophrase(LANG("datum.d92aecee", null))))

	if(!started)
		started = TRUE
		SSweather.run_weather(/datum/weather/particle/rain_storm/wizard)

/datum/round_event/wizard/magical_rain/end()
	for(var/mob/living/wizard in GLOB.alive_mob_list)
		if(IS_WIZARD(wizard) && HAS_TRAIT_FROM(wizard, TRAIT_RAINSTORM_IMMUNE, MAGIC_TRAIT))
			REMOVE_TRAIT(wizard, TRAIT_RAINSTORM_IMMUNE, MAGIC_TRAIT)
			to_chat(wizard, span_notice(LANG("datum.63834779", null)))
