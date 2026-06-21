// medicine used for self surgery, it removes the need for a heart or liver
/obj/item/storage/pill_bottle/cordiolis_hepatico
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/cordiolis_hepatico

/obj/item/reagent_containers/applicator/pill/cordiolis_hepatico
	name = "心肝宁药片"
	desc = "一种高度先进且机密的化学制剂，能暂时消除对功能性心脏或肝脏的需求。他们宁愿你对此知之甚少。"
	icon_state = "pill21"
	list_reagents = list(
		/datum/reagent/medicine/cordiolis_hepatico = 10,
		/datum/reagent/consumable/sugar = 5,
	)
