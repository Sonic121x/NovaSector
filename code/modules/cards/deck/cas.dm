// CARDS AGAINST SPESS
// This is a parody of Cards Against Humanity (https://en.wikipedia.org/wiki/Cards_Against_Humanity)
// which is licensed under CC BY-NC-SA 2.0, the full text of which can be found at the following URL:
// https://creativecommons.org/licenses/by-nc-sa/2.0/legalcode
// Original code by Zuhayr, Polaris Station, ported with modifications
/obj/item/toy/cards/deck/cas
	name = "\improper CAS牌组（白色）"
	desc = "一套《太空大冒险》卡牌，这款游戏历经数百年依然流行。警告：可能包含打破第四面墙的内容。这是白色牌组。"
	cardgame_desc = "Cards Against Spess game"
	icon_state = "deck_white_full"
	deckstyle = "white"
	has_unique_card_icons = FALSE
	decksize = 150
	can_play_52_card_pickup = FALSE

/obj/item/toy/cards/deck/cas/black
	name = "\improper CAS牌组（黑色）"
	desc = "一套《太空大冒险》卡牌，这款游戏历经数百年依然流行。警告：可能包含打破第四面墙的内容。这是黑色牌组。"
	icon_state = "deck_black_full"
	deckstyle = "black"
	decksize = 50

GLOBAL_LIST_INIT(card_decks, list(
	black = world.file2list("strings/cas_black.txt"),
	white = world.file2list("strings/cas_white.txt")
))

/obj/item/toy/cards/deck/cas/initialize_cards()
	var/list/cards_against_space = GLOB.card_decks[deckstyle]
	var/list/possible_cards = cards_against_space.Copy()

	for(var/i in 1 to decksize)
		initial_cards += pick_n_take(possible_cards)
