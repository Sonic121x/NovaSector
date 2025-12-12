/obj/item/reagent_containers/hypospray/medipen/deforest/caramel
	name = "焦糖注射笔"
	desc = "一支焦糖注射笔，内置了15u的焦糖，可随时充饥和变胖，某只蜥蜴的最爱"
	icon = 'modular_z121/icons/obj/hypospray/caramel.dmi'
	icon_state = "caramel"
	base_icon_state = "caramel"
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/consumable/caramel = 15)

/obj/item/storage/box/caramel_medipen
	name = "一盒焦糖注射笔"
	desc = "里面装了一些焦糖注射笔，千万不要被某只蜥蜴拿到，要不然整个空间站没一个是瘦子"
	icon = 'modular_z121/icons/obj/hypospray/caramel.dmi'
	icon_state = "box"
	illustration = "caramel_lizard"

/obj/item/storage/box/caramel_medipen/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen/deforest/caramel(src)

