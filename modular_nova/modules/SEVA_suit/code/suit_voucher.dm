//the suit voucher
/obj/item/suit_voucher
	name = "防护服兑换券"
	desc = "一张用于兑换新防护服的代币。在采矿设备贩卖机上使用它。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY


/datum/voucher_set/mining_suits/seva
	name = "SEVA防护服"
	description = "包含一套全新的矿工入门装备，供一名船员使用，内含：一把原型动能加速器、一把生存刀、一个手电筒、一套勘探服、一副透视眼镜、一个自动矿物扫描仪、一个矿工背包、一个防毒面具、一把矿工无线电钥匙以及一张带有基础矿工权限的特殊ID卡。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	icon_state = "seva"
	set_items = list(
		/obj/item/clothing/suit/hooded/seva,
		/obj/item/clothing/mask/gas/seva,
	)

/datum/voucher_set/mining_suits/explorer
	name = "探索者防护服"
	description = "包含一套全新的矿工入门装备，供一名船员使用，内含：一把原型动能加速器、一把生存刀、一个手电筒、一套勘探服、一副透视眼镜、一个自动矿物扫描仪、一个矿工背包、一个防毒面具、一把矿工无线电钥匙以及一张带有基础矿工权限的特殊ID卡。"
	icon = 'icons/obj/clothing/suits/utility.dmi'
	icon_state = "explorer"
	set_items = list(
		/obj/item/clothing/suit/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
	)

/obj/machinery/computer/order_console/mining/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/voucher_redeemer, /obj/item/suit_voucher, /datum/voucher_set/mining_suits)
