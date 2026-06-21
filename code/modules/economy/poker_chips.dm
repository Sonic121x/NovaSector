/obj/item/poker_chip
	name = "扑克筹码"
	desc = "一种用于赌博的小塑料筹码。一个巧妙的替代品，让赌徒觉得他的损失不那么真实。"
	icon = 'icons/obj/economy.dmi'
	icon_state = "pokerchip_white_black"
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/plastic = COIN_MATERIAL_AMOUNT)
	///How much credit this chip is worth when redeemed
	var/redeem_value = 0

/obj/item/poker_chip/grind_results()
	return list(/datum/reagent/plastic_polymers = COIN_MATERIAL_AMOUNT * 0.2)

/obj/item/poker_chip/get_item_credit_value()
	return redeem_value

/obj/item/poker_chip/white_black
	name = "1₵扑克筹码"
	redeem_value = 1

/obj/item/poker_chip/white_blue
	name = "10₵扑克筹码"
	icon_state = "pokerchip_white_blue"
	redeem_value = 10

/obj/item/poker_chip/red
	name = "25₵扑克筹码"
	icon_state = "pokerchip_red"
	redeem_value = 25

/obj/item/poker_chip/blue
	name = "100₵扑克筹码"
	icon_state = "pokerchip_blue"
	redeem_value = 100

/obj/item/poker_chip/green
	name = "250₵ 扑克筹码"
	icon_state = "pokerchip_green"
	redeem_value = 250

/obj/item/poker_chip/black
	name = "1000₵ 扑克筹码"
	icon_state = "pokerchip_black"
	redeem_value = 1000
