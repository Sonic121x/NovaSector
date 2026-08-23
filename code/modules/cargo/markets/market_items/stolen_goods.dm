// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
///A special category for goods stolen by spies for their bounties.
/datum/market_item/stolen_good
	category = "Fenced Goods"
	abstract_path = /datum/market_item/stolen_good
	stock = 1
	availability_prob = 100
	restockable = FALSE

/datum/market_item/stolen_good/New(atom/movable/thing, thing_price)
	..()
	set_item(thing)
	name = "Stolen [thing.name]"
	desc = LANG("datum.62dd97f8b598c7c9", list(thing.name))
	price = thing_price
