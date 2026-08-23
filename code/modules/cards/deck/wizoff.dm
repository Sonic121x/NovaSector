// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//It's Wiz-Off, the wizard themed card game! It's modular too, in case you might want to make it Syndie, Sec and Clown themed or something stupid like that.
/obj/item/toy/cards/deck/wizoff
	name = "\improper Wiz-Off deck"
	desc = "A Wiz-Off deck. Fight an arcane battle for the fate of the universe: Draw 5! Play 5! Best of 5! A rules card is attached."
	cardgame_desc = "Wiz-Off game"
	icon_state = "deck_wizoff_full"
	deckstyle = "wizoff"

/obj/item/toy/cards/deck/wizoff/initialize_cards()
	var/card_list = strings("wizoff.json", "wizard")
	initial_cards += new /datum/deck_card/of_type(/obj/item/toy/singlecard/wizoff_ruleset) // ruleset should be the top card
	for(var/card in card_list)
		initial_cards += card

/obj/item/toy/singlecard/wizoff_ruleset
	desc = "A ruleset for the playing card game Wiz-Off."
	cardname = "Wizoff Ruleset"
	deckstyle = "black"
	has_unique_card_icons = FALSE
	icon_state = "singlecard_down_black"

/obj/item/toy/singlecard/wizoff_ruleset/examine(mob/living/carbon/human/user)
	. = ..()
	. += span_notice(LANG("obj.c4985b6316d44fa4", null))
	. += span_info(LANG("obj.6bfbf46cd772c45a", null))
	. += span_info(LANG("obj.99e041eb646b49d9", null))
	. += span_info(LANG("obj.61a5a69efe109008", null))
	. += span_info(LANG("obj.04f065fbaea69bc5", null))
	. += span_info(LANG("obj.d92fdd8ada0fed1b", null))
	. += span_info(LANG("obj.dfb1ebeeb3187ed8", null))
	. += span_info(LANG("obj.7b2547b7680c3c6a", null))
	. += span_notice(LANG("obj.9a77353b9ce103a3", null))
