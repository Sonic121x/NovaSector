/obj/item/toy/cards/deck/blank
	name = "自定义牌组"
	desc = "一套可以进行个性化书写装饰的扑克牌。"
	cardgame_desc = "custom card game"
	icon_state = "deck_white_full"
	deckstyle = "white"
	has_unique_card_icons = FALSE
	decksize = 25
	can_play_52_card_pickup = FALSE

/obj/item/toy/cards/deck/blank/black
	icon_state = "deck_black_full"
	deckstyle = "black"

/obj/item/toy/cards/deck/blank/initialize_cards()
	for(var/_ in 1 to decksize)
		initial_cards += /datum/deck_card/blank

/datum/deck_card/blank
	name = "空白卡牌"

/datum/deck_card/blank/update_card(obj/item/toy/singlecard/card)
	card.blank = TRUE
