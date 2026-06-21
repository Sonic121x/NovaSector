/**
 * An event which decreases the station target temporarily, causing the inflation var to increase heavily.
 *
 * Done by decreasing the station_target by a high value per crew member, resulting in the station total being much higher than the target, and causing artificial inflation.
 */
/datum/round_event_control/market_crash
	name = "市场崩溃"
	typepath = /datum/round_event/market_crash
	weight = 10
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "暂时提高自动售货机的价格。"

/datum/round_event/market_crash
	/// This counts the number of ticks that the market crash event has been processing, so that we don't call vendor price updates every tick, but we still iterate for other mechanics that use inflation.
	var/tick_counter = 1

/datum/round_event/market_crash/setup()
	start_when = 1
	end_when = rand(100, 50)
	announce_when = 2

/datum/round_event/market_crash/announce(fake)
	var/list/poss_reasons = list("the alignment of the moon and the sun",\
		"some risky housing market outcomes",\
		"the B.E.P.I.S. team's untimely downfall",\
		"speculative SolFed grants backfiring",  /*NOVA EDIT CHANGE; original was "speculative Terragov grants backfiring"*/\
		"greatly exaggerated reports of Nanotrasen accountancy personnel being \"laid off\"",\
		"a \"great investment\" into \"non-fungible tokens\" by a \"moron\"",\
		"a number of raids from Tiger Cooperative agents",\
		"supply chain shortages",\
		"the \"Nanotrasen+\" social media network's untimely downfall",\
		"the \"Nanotrasen+\" social media network's unfortunate success",\
		"uhh, bad luck, we guess"
	)
	var/reason = pick(poss_reasons)
	priority_announce("由于[reason]，空间站内自动售货机的价格将在短期内上涨。", "纳米传讯会计部")

/datum/round_event/market_crash/start()
	. = ..()
	SSeconomy.update_vending_prices()
	SSeconomy.price_update()
	ADD_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)

/datum/round_event/market_crash/end()
	. = ..()
	REMOVE_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)
	SSeconomy.price_update()
	SSeconomy.update_vending_prices()
	priority_announce("空间站内自动售货机的价格现已稳定。", "纳米传讯会计部")

/datum/round_event/market_crash/tick()
	. = ..()
	tick_counter = tick_counter++
	SSeconomy.inflation_value = 5.5*(log(activeFor+1))
	if(tick_counter == 5)
		tick_counter = 1
		SSeconomy.update_vending_prices()
