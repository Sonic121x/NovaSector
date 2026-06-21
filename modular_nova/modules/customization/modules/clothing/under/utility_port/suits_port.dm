//Base Jacket - same stats as /obj/item/clothing/suit/jacket, just toggleable and serving as the base for all the departmental jackets and flannels
/obj/item/clothing/suit/toggle/jacket/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	name = "轰炸机夹克"
	desc = "一件温暖的轰炸机夹克，内衬人造羊毛，让你在太空深处也能保持舒适温暖。飞行员墨镜不包含在内。"
	icon_state = "bomberalt"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/radio)
	body_parts_covered = CHEST|ARMS|GROIN
	cold_protection = CHEST|ARMS|GROIN
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	toggle_noun = "zipper"

//Job Jackets

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber
	name = "非部门夹克"
	desc = "一件中性黑色的舒适夹克"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber"
	post_init_icon_state = "jacket"
	greyscale_config = /datum/greyscale_config/dept_jacket
	greyscale_config_worn = /datum/greyscale_config/dept_jacket/worn
	greyscale_colors = "#39393f#eae3ce#17161f#39393f"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/engi
	name = "工程夹克"
	desc = "一件舒适的工程黄色夹克。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/engi"
	greyscale_colors = "#f8d860#eae3ce#17161f#f8d860"
	flags_1 = null

	armor_type = /datum/armor/jacket_engi
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/t_scanner, /obj/item/construction/rcd, /obj/item/pipe_dispenser, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter)

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/tcomm
	name = "电信夹克"
	desc = "一件舒适的工程黄色夹克，带有蓝色电信镶边。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/tcomm"
	greyscale_colors = "#f8d860#eae3ce#5c97e6#5c97e6"
	post_init_icon_state = "jacket_armband"
	flags_1 = null
	armor_type = /datum/armor/jacket_engi
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/t_scanner,
		/obj/item/construction/rcd,
		/obj/item/pipe_dispenser,
		/obj/item/toy,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/lighter,
	)

/datum/armor/jacket_engi
	fire = 30
	acid = 45

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sci
	name = "科研夹克"
	desc = "一件舒适的科研紫色夹克。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sci"
	greyscale_colors = "#7e1980#eae3ce#17161f#7e1980"
	flags_1 = null

	armor_type = /datum/armor/jacket_sci

/datum/armor/jacket_sci
	bomb = 10

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/med
	name = "医疗部夹克"
	desc = "一件舒适的医疗蓝色夹克。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/med"
	greyscale_colors = "#becace#eae3ce#17161f#becace"
	flags_1 = null
	armor_type = /datum/armor/jacket_med

/datum/armor/jacket_med
	bio = 50
	acid = 45

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/supply
	name = "货运夹克"
	desc = "一件舒适的补给棕色夹克。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/supply"
	greyscale_colors = "#b7793d#eae3ce#17161f#b7793d"
	flags_1 = null

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/supply/head
	name = "军需官夹克"
	desc = "即使人们拒绝承认你是部门主管，他们也能认出你是个狠角色。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/supply/head"
	greyscale_colors = "#292929#eae3ce#b7793d#b7793d"
	post_init_icon_state = "jacket_armband"

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sec
	name = "安保夹克"
	desc = "一件舒适的安保红色夹克。可能违反制服规定。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sec"
	greyscale_colors = "#a52f29#eae3ce#17161f#a52f29"
	flags_1 = null
	armor_type = /datum/armor/sec_dep_jacket

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sec/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/datum/armor/sec_dep_jacket
	melee = 30
	bullet = 20
	laser = 30
	energy = 40
	bomb = 25
	fire = 30
	acid = 45

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sec/blue
	desc = "一件过时的蓝色夹克。可能违反制服规定。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sec/blue"
	greyscale_colors = "#3f6e9e#eae3ce#17161f#3f6e9e"

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/bridge_officer
	name = "舰桥军官夹克"
	desc = "这是一件蓝银相间的夹克，表明穿着者是“舰桥军官”。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/bridge_officer"
	greyscale_colors = "#41579a#eae3ce#ffffff#4d4d4d"
	flags_1 = null

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/interdyne
	name = "英特戴恩轰炸机夹克"
	desc = "这是一件黑绿相间的轰炸机夹克，看起来是英特戴恩制药公司的配色。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/interdyne"
	greyscale_colors = "#333333#eae3ce#33cc33#33cc33"
	flags_1 = null

/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/syndicate
	name = "辛迪加辅助夹克"
	desc = "一件看起来相当可疑的夹克，颜色为黑色和红色。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/syndicate"
	post_init_icon_state = "jacket_armband"
	greyscale_colors = "#333333#eae3ce#ff0000#ff0000"
	flags_1 = null

//Flannels
/obj/item/clothing/suit/toggle/jacket/nova/flannel
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	name = "法兰绒夹克"
	desc = "一件舒适温暖的格子法兰绒夹克。深受伐木工和卡车司机的喜爱。"
	icon_state = "flannel"
	body_parts_covered = CHEST|ARMS //Being a bit shorter, flannels dont cover quite as much as the rest of the woolen jackets (- GROIN)
	cold_protection = CHEST|ARMS
	heat_protection = CHEST|ARMS	//As a plus side, they're more insulating, protecting a bit from the heat as well

/obj/item/clothing/suit/toggle/jacket/nova/flannel/red
	name = "红色法兰绒夹克"
	icon_state = "flannel_red"

/obj/item/clothing/suit/toggle/jacket/nova/flannel/aqua
	name = "水绿色法兰绒夹克"
	icon_state = "flannel_aqua"

/obj/item/clothing/suit/toggle/jacket/nova/flannel/brown
	name = "棕色法兰绒夹克"
	icon_state = "flannel_brown"

/obj/item/clothing/suit/toggle/jacket/nova/flannel/gags
	name = "法兰绒衬衫"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/flannel/gags"
	post_init_icon_state = "flannelgags"
	greyscale_config = /datum/greyscale_config/flannelgags
	greyscale_config_worn = /datum/greyscale_config/flannelgags/worn
	greyscale_colors = "#a61e1f"
	flags_1 = IS_PLAYER_COLORABLE_1

/// Placed in here for now until a better solution is found.

/obj/item/clothing/suit/nova/furred_trenchcoat
	name = "毛皮衬里风衣"
	desc = "一件内衬毛皮的温暖风衣，专为寒冷、黑暗、绝望的冬夜而制。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/nova/furred_trenchcoat"
	post_init_icon_state = "coat"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	greyscale_config = /datum/greyscale_config/fluffywintercoat
	greyscale_config_worn = /datum/greyscale_config/fluffywintercoat/worn
	greyscale_colors = "#eaeaea#969696#4d4d4d#ccffff"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/nova/overcoat
	name = "华贵大衣"
	desc = "一件华贵的大衣，看起来相当精致。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/nova/overcoat"
	post_init_icon_state = "overcoat"
	body_parts_covered = CHEST|ARMS
	greyscale_config = /datum/greyscale_config/overcoat
	greyscale_config_worn = /datum/greyscale_config/overcoat/worn
	greyscale_colors = "#2d3a46#ffcc66#eaeaea"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/nova/sweater
	name = "大号毛衣"
	desc = "一件超大号毛衣！这东西大得可以当临时毯子用。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/nova/sweater"
	post_init_icon_state = "sweater"
	body_parts_covered = CHEST|ARMS
	greyscale_config = /datum/greyscale_config/sweater_nova_1
	greyscale_config_worn = /datum/greyscale_config/sweater_nova_1/worn
	greyscale_colors = "#2d3a46"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	
/obj/item/clothing/suit/nova/sweater/bow
	name = "带蝴蝶结的大号毛衣"
	desc = "一件带有同样大蝴蝶结的超大号毛衣！这东西大得可以当临时毯子用。"
	icon_state = "/obj/item/clothing/suit/nova/sweater/bow"
	post_init_icon_state = "sweaterbow"
	greyscale_config = /datum/greyscale_config/sweater_nova_2
	greyscale_config_worn = /datum/greyscale_config/sweater_nova_2/worn
	greyscale_colors = "#2d3a46#ffcc66"
