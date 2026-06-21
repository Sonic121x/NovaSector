/obj/item/encryptionkey/headset_faction
	name = "派系无线电加密密钥"
	channels = list(RADIO_CHANNEL_FACTION = 1)
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/encryptionkey/headset_faction"
	post_init_icon_state = "cypherkey_cargo"
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#dca01b"
	special_channels = RADIO_SPECIAL_CENTCOM

/obj/item/radio/headset/headset_faction
	name = "派系无线电耳机"
	desc = "派系使用的耳机。"
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/headset_faction

/obj/item/radio/headset/headset_faction/bowman
	name = "派系鲍曼耳机"
	desc = "派系使用的耳机。保护耳朵免受闪光弹伤害。"
	icon_state = "com_headset_alt"

/obj/item/radio/headset/headset_faction/bowman/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/headset_faction/bowman/captain
	name = "派系舰长鲍曼耳机"
	desc = "头目的耳机。保护耳朵免受闪光弹伤害。"
	command = TRUE
