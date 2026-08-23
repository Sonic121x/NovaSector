// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Ignites matches swiped over it.
/datum/element/ignites_matches

/datum/element/ignites_matches/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_interact))

/datum/element/ignites_matches/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ATOM_ITEM_INTERACTION)
	return ..()

/datum/element/ignites_matches/proc/on_interact(atom/source, mob/living/user, obj/item/match/match, ...)
	SIGNAL_HANDLER
	if(!istype(match) || match.lit || match.burnt || match.broken)
		return NONE
	if(SHOULD_SKIP_INTERACTION(source, match, user))
		return NONE
	var/over_what_tp = source.loc == user ? "[user.p_their()] [source.name]" : source
	var/over_what_fp = source.loc == user ? "your [source.name]" : source
	if(prob(10))
		user.visible_message(
			span_warning(LANG("datum.dde3c58cdf17f802", list(user, match, over_what_tp))),
			span_warning(LANG("datum.9e98a47f4ccbe314", list(match, over_what_fp))),
		)
		return ITEM_INTERACT_SUCCESS
	if(prob((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_HULK)) ? 33 : 2))
		user.visible_message(
			span_warning(LANG("datum.1224197f78dcacd2", list(user, match, over_what_tp))),
			span_warning(LANG("datum.4d62968389c5df0f", list(match, over_what_fp))),
		)
		match.snap()
		return ITEM_INTERACT_SUCCESS

	user.visible_message(
		span_rose(LANG("datum.92661cb0ad348ce7", list(user, match, over_what_tp))),
		span_rose(LANG("datum.8a18a4e7f607d7a6", list(match, over_what_fp))),
	)
	match.matchignite()
	return ITEM_INTERACT_SUCCESS
