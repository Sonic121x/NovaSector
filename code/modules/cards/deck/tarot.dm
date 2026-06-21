#define TAROT_GHOST_TIMER (666 SECONDS) // this translates into 11 mins and 6 seconds

//These cards certainly won't tell the future, but you can play some nice games with them.
/obj/item/toy/cards/deck/tarot
	name = "塔罗牌游戏套牌"
	desc = "一套完整的 78 张的塔罗牌游戏牌组。其中包括 4 组各 14 张的牌组，以及一套完整的王牌牌组。"
	cardgame_desc = "tarot card reading"
	icon_state = "deck_tarot_full"
	deckstyle = "tarot"

/obj/item/toy/cards/deck/tarot/initialize_cards()
	for(var/suit in list("Hearts", "Pikes", "Clovers", "Tiles"))
		for(var/i in 1 to 10)
			initial_cards += "[i] of [suit]"
		for(var/person in list("Valet", "Chevalier", "Dame", "Roi"))
			initial_cards += "[person] of [suit]"
	for(var/trump in list("The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lover", "The Chariot", "Justice", "The Hermit", "The Wheel of Fortune", "Strength", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World", "The Fool"))
		initial_cards += trump

/obj/item/toy/cards/deck/tarot/draw(mob/user)
	. = ..()
	if(prob(50))
		var/obj/item/toy/singlecard/card = .
		if(!card)
			return FALSE

		var/matrix/M = matrix()
		M.Turn(180)
		card.transform = M

/obj/item/toy/cards/deck/tarot/pick_card(mob/living/user, list/obj/item/toy/singlecard/cards)
	// If the user is cursed they have increase chance of drawing Death or The Tower
	if(!HAS_TRAIT(user, TRAIT_CURSED))
		return ..()

	var/total_card = length(cards)
	// give a boosted chance if they're using the full deck
	var/chance_modifier = total_card >= 56 ? 24 : 4
	if(!prob(min(33, chance_modifier / total_card * 100)))
		return ..()

	for(var/obj/item/toy/singlecard/card as anything in cards)
		if(card.cardname == "Death" || card.cardname == "The Tower")
			return card

	return ..()

/obj/item/toy/cards/deck/tarot/haunted
	name = "闹鬼塔罗牌游戏牌组"
	desc = "一副看起来很诡异的塔罗牌。你能感觉到牌面上似乎蕴含着某种超自然的力量……"
	/// ghost notification cooldown
	COOLDOWN_DECLARE(ghost_alert_cooldown)

/obj/item/toy/cards/deck/tarot/haunted/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/two_handed, \
		attacksound = 'sound/items/cards/cardflip.ogg', \
		wield_callback = CALLBACK(src, PROC_REF(on_wield)), \
		unwield_callback = CALLBACK(src, PROC_REF(on_unwield)), \
	)

/obj/item/toy/cards/deck/tarot/haunted/proc/on_wield(obj/item/source, mob/living/carbon/user)
	ADD_TRAIT(user, TRAIT_SIXTHSENSE, MAGIC_TRAIT)
	to_chat(user, span_notice("通往冥界的帷幕被打开了。你能感觉到亡魂在呼唤……"))

	if(!COOLDOWN_FINISHED(src, ghost_alert_cooldown))
		return

	COOLDOWN_START(src, ghost_alert_cooldown, TAROT_GHOST_TIMER)
	notify_ghosts(
		"Someone has begun playing with a [name] in [get_area(src)]!",
		source = src,
		header = "Haunted Tarot Deck",
		ghost_sound = 'sound/effects/ghost2.ogg',
		notify_volume = 75,
	)

/obj/item/toy/cards/deck/tarot/haunted/proc/on_unwield(obj/item/source, mob/living/carbon/user)
	REMOVE_TRAIT(user, TRAIT_SIXTHSENSE, MAGIC_TRAIT)
	to_chat(user, span_notice("通往冥界的帷幕关闭了。你感觉自己的知觉恢复了正常。"))

#undef TAROT_GHOST_TIMER
