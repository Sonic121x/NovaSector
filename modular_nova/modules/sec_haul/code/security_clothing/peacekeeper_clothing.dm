//PEACEKEEPER GLASSES
/obj/item/clothing/glasses/hud/security/sunglasses/peacekeeper
	name = "维和部队平视显示器眼镜"
	icon_state = "peacekeeperglasses"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/eyes.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/glasses.dmi'

//PEACEKEEPER ARMOR
/obj/item/clothing/suit/armor/vest/peacekeeper
	name = "维和部队装甲背心"
	desc = "一款标准制式的维和部队装甲背心，用途广泛、重量轻，最重要的是，价格便宜。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "peacekeeper_white"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/vest/peacekeeper/black
	icon_state = "peacekeeper_black"

/obj/item/clothing/suit/armor/vest/peacekeeper/spacecoat
	name = "维和部队流线型大衣"
	desc = "一件极其时尚厚重的黑色大衣，由合成袋鼠皮革制成，内衬杜拉纤维并填充了凯夫拉。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "peacekeeper_spacecoat"
	worn_icon_state = "peacekeeper_spacecoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

//PEACEKEEPER GLOVES
/obj/item/clothing/gloves/combat/peacekeeper
	name = "维和部队手套"
	desc = "这些战术手套是防火的。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "black_blue_gloves"
	worn_icon_state = "black_blue"
	siemens_coefficient = 0.5
	strip_delay = 20
	cold_protection = 0
	min_cold_protection_temperature = null
	heat_protection = 0
	max_heat_protection_temperature = null
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/none
	cut_type = null

/obj/item/clothing/gloves/tackler/peacekeeper
	name = "维和部队抓握手套"
	desc = "特殊手套，能操纵佩戴者手部的血管，赋予他们一头撞向墙壁的能力。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "black_blue_gripper_gloves"

/obj/item/clothing/gloves/kaza_ruk/sec/peacekeeper
	name = "维和部队马伽术手套"
	desc = "这些手套能通过纳米芯片教你使用马伽术。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "fightgloves_blue"
	greyscale_colors = "#3F6E9E"

//PEACEKEEPER WEBBING
/obj/item/storage/belt/security/webbing/peacekeeper
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "blue_webbing"
	worn_icon_state = "blue_webbing"

/obj/item/storage/belt/security/webbing/peacekeeper/setup_reskins()
	return

//BOOTS
/obj/item/clothing/shoes/jackboots/peacekeeper
	name = "维和部队靴子"
	desc = "高速、低阻力的作战靴。"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	icon_state = "peacekeeper"
