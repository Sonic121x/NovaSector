// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Element which influences raptor children upon owner's consumption as food
/datum/element/raptor_food
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Flat damage modifier
	var/attack_modifier = null
	/// Flat health modifier
	var/health_modifier = null
	/// Speed modifier
	var/speed_modifier = null
	/// Primary ability stat modifier
	/// Multiplier equates to 1 + this
	var/ability_modifier = null
	/// Growth rate modifier
	/// Multiplier equates to 1 + this
	var/growth_modifier = null
	/// Personality traits the child may get
	var/list/personality_traits = null
	/// Offspring color probability modifiers
	var/list/color_chances = null

/datum/element/raptor_food/Attach(obj/item/target, attack_modifier, health_modifier, speed_modifier, ability_modifier, growth_modifier, list/personality_traits, list/color_chances)
	. = ..()
	if (!isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.attack_modifier = attack_modifier
	src.health_modifier = health_modifier
	src.speed_modifier = speed_modifier
	src.ability_modifier = ability_modifier
	src.growth_modifier = growth_modifier
	src.personality_traits = personality_traits
	src.color_chances = color_chances
	RegisterSignal(target, COMSIG_ITEM_EATEN_BY_BASIC_MOB, PROC_REF(on_eaten))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))

/datum/element/raptor_food/Detach(datum/source, ...)
	UnregisterSignal(source, list(COMSIG_ITEM_EATEN_BY_BASIC_MOB, COMSIG_ATOM_EXAMINE_MORE))
	return ..()

/datum/element/raptor_food/proc/on_examine_more(obj/item/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	if (!istype(examiner.buckled, /mob/living/basic/raptor))
		return

	// Just to check for priority
	var/strognest_effect = max(attack_modifier, health_modifier, speed_modifier, ability_modifier, growth_modifier, 0)

	// Only personality or color probability effects, or just pure negatives
	if (strognest_effect == 0)
		examine_list += span_notice(LANG("datum.af0f81ed13e8aa2f", null))
		return

	if (strognest_effect == attack_modifier)
		examine_list += span_notice(LANG("datum.f0e0e75cf1997bdb", null))
	else if (strognest_effect == health_modifier)
		examine_list += span_notice(LANG("datum.5dfb4b9e78d5446a", null))
	else if (strognest_effect == speed_modifier)
		examine_list += span_notice(LANG("datum.1f7a2a22cd1cb192", null))
	else if (strognest_effect == ability_modifier)
		examine_list += span_notice(LANG("datum.0330ec84baa94ea7", null))
	else if (strognest_effect == growth_modifier)
		examine_list += span_notice(LANG("datum.74815756ec74f0fa", null))

/datum/element/raptor_food/proc/on_eaten(obj/item/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER

	if (!istype(eater, /mob/living/basic/raptor))
		return

	var/mob/living/basic/raptor/raptor = eater
	var/list/our_food = raptor.inherited_stats.foods_eaten[source.type]
	if (our_food)
		our_food["amount"] += 1
		return

	raptor.inherited_stats.foods_eaten[source.type] = list(
		"amount" = 1,
		"attack" = attack_modifier,
		"health" = health_modifier,
		"speed" = speed_modifier,
		"ability" = ability_modifier,
		"growth" = growth_modifier,
		"traits" = personality_traits?.Copy(),
		"color_chances" = color_chances?.Copy(),
	)

