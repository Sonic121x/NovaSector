/obj/item/reagent_containers/spray/quantum_hair_dye
	name = "Quantum Hair Dye-量子染发剂"
	desc = "随机改变头发颜色！别忘了阅读标签！"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "hairspraywhite"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 5)
	list_reagents = list(/datum/reagent/hair_dye = 30)
	volume = 50

/obj/item/reagent_containers/spray/baldium
	name = "秃头喷雾"
	desc = "导致秃头，过度使用可能导致顾客不满。"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "hairremoval"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 5)
	list_reagents = list(/datum/reagent/baldium = 30)
	volume = 50

/obj/item/reagent_containers/spray/barbers_aid
	name = "Barber's Aid-生发剂"
	desc = "导致头发和胡须快速生长！"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "hairaccelerator"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 5)
	list_reagents = list(/datum/reagent/barbers_aid = 50)
	volume = 50

/obj/item/reagent_containers/spray/super_barbers_aid
	name = "超级理发师助手"
	desc = "导致超级快速的头发和胡须生长！"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "hairaccelerator"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 5)
	list_reagents = list(/datum/reagent/concentrated_barbers_aid = 30)
	volume = 50
