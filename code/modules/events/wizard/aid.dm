// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Various events that directly aid the wizard.
// This is the "lets entice the wizard to use summon events!" file.

/datum/round_event_control/wizard/robelesscasting //EI NUDTH!
	name = "Robeless Casting"
	weight = 2
	typepath = /datum/round_event/wizard/robelesscasting
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "Wizard no longer needs robes to cast spells."
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/robelesscasting/start()

	// Hey, if a corgi has magic missle, he should get the same benefit as anyone
	for(var/mob/living/caster as anything in GLOB.mob_living_list)
		if(!length(caster.actions))
			continue

		var/spell_improved = FALSE
		for(var/datum/action/cooldown/spell/spell in caster.actions)
			if(spell.spell_requirements & SPELL_REQUIRES_WIZARD_GARB)
				spell.spell_requirements &= ~SPELL_REQUIRES_WIZARD_GARB
				spell_improved = TRUE

		if(spell_improved)
			to_chat(caster, span_notice(LANG("datum.e30f3a84", null)))

//--//

/datum/round_event_control/wizard/improvedcasting //blink x5 disintergrate x5 here I come!
	name = "Improved Casting"
	weight = 3
	typepath = /datum/round_event/wizard/improvedcasting
	max_occurrences = 4 //because that'd be max level spells
	earliest_start = 0 MINUTES
	description = "Levels up the wizard's spells."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/improvedcasting/start()
	for(var/mob/living/caster as anything in GLOB.mob_living_list)
		if(!length(caster.actions))
			continue

		var/upgraded_a_spell = FALSE
		for(var/datum/action/cooldown/spell/spell in caster.actions)
			// If improved casting has already boosted this spell further beyond, go no further
			if(spell.spell_level >= spell.spell_max_level + 1)
				continue
			upgraded_a_spell = spell.level_spell(TRUE)

		if(upgraded_a_spell)
			to_chat(caster, span_notice(LANG("datum.54e61a32", null)))
