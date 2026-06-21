/obj/item/storage/backpack/head_of_personnel
	name = "人事主管背包"
	desc = "一款专为纳米传讯最优秀的二把手颁发的独家背包。"
	icon = 'modular_nova/master_files/icons/obj/clothing/backpacks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_righthand.dmi'
	icon_state = "backpack_hop"
	inhand_icon_state = "backpack_hop"

/obj/item/storage/backpack/satchel/head_of_personnel
	name = "人事主管挎包"
	desc = "一款专为纳米传讯最优秀的二把手颁发的独家挎包。"
	icon = 'modular_nova/master_files/icons/obj/clothing/backpacks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_righthand.dmi'
	icon_state = "satchel_hop"
	inhand_icon_state = "satchel_hop"

/obj/item/storage/backpack/duffelbag/head_of_personnel
	name = "人事主管旅行袋"
	desc = "一款专为纳米传讯最优秀的二把手颁发的坚固旅行袋。"
	icon = 'modular_nova/master_files/icons/obj/clothing/backpacks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_righthand.dmi'
	icon_state = "duffel_hop"
	inhand_icon_state = "duffel_hop"

/obj/item/radio/headset/heads/hop/alt
	name = "\proper 人事主管的鲍曼式耳机"
	desc = "二把手的耳机。保护耳朵免受闪光弹影响。"
	icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/hop/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
