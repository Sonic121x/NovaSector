
/obj/item/clothing/head/utility/beekeeper_head
	name = "养蜂人帽"
	desc = "能防止那些讨厌的小飞虫飞进你的眼睛里。"
	icon_state = "beekeeper"
	inhand_icon_state = null
	clothing_flags = THICKMATERIAL | SNUG_FIT
	pickup_sound = null
	drop_sound = null
	equip_sound = null

/obj/item/clothing/suit/utility/beekeeper_suit
	name = "蜂农防护服"
	desc = "能防止那些讨厌的小虫子靠近你的娇嫩部位。"
	icon_state = "beekeeper"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	clothing_flags = THICKMATERIAL
	allowed = list(/obj/item/melee/flyswatter, /obj/item/reagent_containers/spray/plantbgone, /obj/item/plant_analyzer, /obj/item/seeds, /obj/item/reagent_containers/cup/bottle, /obj/item/reagent_containers/cup/beaker, /obj/item/cultivator, /obj/item/reagent_containers/spray/pestspray, /obj/item/hatchet, /obj/item/storage/bag/plants)
