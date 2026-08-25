// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 *A storage component to be used on card piles, for use as hands/decks/discard piles. Don't use on something that's not a card pile!
 */
/datum/storage/tcg
	max_specific_storage = WEIGHT_CLASS_TINY
	max_slots = 30
	max_total_storage = WEIGHT_CLASS_TINY * 30

/datum/storage/tcg/New(
	atom/parent,
	max_slots,
	max_specific_storage,
	max_total_storage,
)
	. = ..()
	set_holdable(/obj/item/tcgcard)

/datum/storage/tcg/show_contents(mob/to_show)
	// sometimes, show contents is called when the mob is already seeing the contents of the deck, to refresh the view.
	// to avoid spam, we only show the message if they weren't already seeing the contents.
	var/was_already_seeing = to_show.active_storage == src
	. = ..()
	if(!.)
		return .
	if(!was_already_seeing)
		to_show.visible_message(
			span_notice(LANG("datum.b5f0f232cc5f20b8", list(to_show, parent))),
			span_notice(LANG("datum.17b2f5251281b8c7", list(parent))),
		)
	return .

/datum/storage/tcg/hide_contents(mob/to_hide)
	// see above
	var/was_actually_seeing = to_hide.active_storage == src
	. = ..()
	if(!.)
		return .
	if(QDELING(src))
		return .
	if(was_actually_seeing)
		real_location.visible_message(span_notice(LANG("datum.bf797acc33f95f30", list(parent))))
		real_location.contents = shuffle(real_location.contents)
	return .
