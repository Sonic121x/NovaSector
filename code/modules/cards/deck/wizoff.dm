//It's Wiz-Off, the wizard themed card game! It's modular too, in case you might want to make it Syndie, Sec and Clown themed or something stupid like that.
/obj/item/toy/cards/deck/wizoff
	name = "\improper Wiz-Off牌组"
	desc = "一副Wiz-Off牌组。为宇宙的命运展开一场奥术对决：抽5张！出5张！五局三胜！附有规则卡。"
	cardgame_desc = "Wiz-Off game"
	icon_state = "deck_wizoff_full"
	deckstyle = "wizoff"

/obj/item/toy/cards/deck/wizoff/initialize_cards()
	var/card_list = strings("wizoff.json", "wizard")
	initial_cards += new /datum/deck_card/of_type(/obj/item/toy/singlecard/wizoff_ruleset) // ruleset should be the top card
	for(var/card in card_list)
		initial_cards += card

/obj/item/toy/singlecard/wizoff_ruleset
	desc = "纸牌游戏Wiz-Off的规则说明。"
	cardname = "Wizoff Ruleset"
	deckstyle = "black"
	has_unique_card_icons = FALSE
	icon_state = "singlecard_down_black"

/obj/item/toy/singlecard/wizoff_ruleset/examine(mob/living/carbon/human/user)
	. = ..()
	. += span_notice("记住Wiz-Off的规则！")
	. += span_info("每位玩家抽5张牌。")
	. += span_info("共进行五轮。每轮，玩家选择一张牌打出，胜者根据以下规则判定：")
	. += span_info("防御牌击败攻击牌！")
	. += span_info("攻击牌克制功能牌！")
	. += span_info("功能牌克制防御牌！")
	. += span_info("如果双方玩家打出相同类型的法术，数字更大的一方获胜！")
	. += span_info("在5轮中赢得最多轮次的玩家获胜！")
	. += span_notice("现在准备好为宇宙的命运而战吧：巫师对决！")
