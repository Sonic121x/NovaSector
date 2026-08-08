// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/ghostliness
	name = "Forsake Body"
	desc = "A spell that severs your soul from your body, loosely binding it to the material plane."
	button_icon = 'icons/mob/simple/mob.dmi'
	button_icon_state = "ghost"

	school = SCHOOL_NECROMANCY
	cooldown_time = 1 SECONDS

	invocation = "GHO'AN GHO'AST!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_STATION|SPELL_REQUIRES_MIND
	spell_max_level = 1

/datum/action/cooldown/spell/ghostliness/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	if(!is_valid_target(owner))
		if(feedback)
			owner.balloon_alert(owner, LANG("datum.f686d151", null))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/ghostliness/is_valid_target(atom/cast_on)
	return ishuman(cast_on) && !HAS_TRAIT(owner, TRAIT_NO_SOUL)

/datum/action/cooldown/spell/ghostliness/cast(mob/living/carbon/human/cast_on)
	. = ..()

	if(HAS_TRAIT(cast_on, TRAIT_GHOSTLY_MOB))
		to_chat(cast_on, span_green(LANG("datum.7d9286bd", null)))
	else
		to_chat(cast_on, span_green(LANG("datum.f918b45f", null)))
	if(!do_after(cast_on, 5 SECONDS))
		if(HAS_TRAIT(cast_on, TRAIT_GHOSTLY_MOB))
			to_chat(cast_on, span_warning(LANG("datum.7df38b8b", null)))
		else
			to_chat(cast_on, span_warning(LANG("datum.b3b88428", null)))
		return
	if(HAS_TRAIT(cast_on, TRAIT_GHOSTLY_MOB))
		to_chat(cast_on, span_green(LANG("datum.ae7b212d", null)))
	else
		to_chat(cast_on, span_danger(LANG("datum.61c28d4b", null)))
		var/mob/living/carbon/human/soulless_husk = new(cast_on.drop_location())
		soulless_husk.setDir(cast_on.dir)
		cast_on.dna.copy_dna(soulless_husk.dna, ALL)
		soulless_husk.real_name = cast_on.real_name
		soulless_husk.updateappearance(icon_update = TRUE, mutcolor_update = TRUE, mutations_overlay_update = TRUE)
		soulless_husk.domutcheck()
		ADD_TRAIT(soulless_husk, TRAIT_NO_SOUL, MAGIC_TRAIT)
		ADD_TRAIT(soulless_husk, TRAIT_FLOORED, MAGIC_TRAIT)
	cast_on.set_species(/datum/species/spirit/ghost)
	qdel(src)
