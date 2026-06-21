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
	name = "失窃的[thing.name]"
	desc = "一个[thing.name]，从空间站的某个地方偷来的。它的主人看到它在这里大概不会高兴。"
	price = thing_price
