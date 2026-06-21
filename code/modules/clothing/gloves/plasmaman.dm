/obj/item/clothing/gloves/color/plasmaman
	desc = "掩盖了那双丑陋粗糙的手。"
	name = "等离子环境手套"
	icon_state = "plasmaman"
	greyscale_colors = "#913b00"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/color_plasmaman
	equip_sound = 'sound/items/equip/glove_equip.ogg'

/datum/armor/color_plasmaman
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/gloves/color/plasmaman/black
	name = "黑色环境手套"
	icon_state = "blackplasma"
	greyscale_colors = "#2f2e31"

/obj/item/clothing/gloves/color/plasmaman/plasmanitrile
	name = "腈制环境手套"
	desc = "为等离子人专门制造的昂贵腈制手套."
	icon_state = "nitrile"
	greyscale_colors = "#913b00"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED)

/obj/item/clothing/gloves/color/plasmaman/white
	name = "白色环境手套"
	icon_state = "whiteplasma"
	greyscale_colors = "#ffffff"

/obj/item/clothing/gloves/color/plasmaman/robot
	name = "机械学家环境手套"
	icon_state = "robotplasma"
	greyscale_colors = "#932500"

/obj/item/clothing/gloves/color/plasmaman/janny
	name = "清洁工环境手套"
	icon_state = "jannyplasma"
	greyscale_colors = "#883391"

/obj/item/clothing/gloves/color/plasmaman/cargo
	name = "货舱环境手套"
	icon_state = "cargoplasma"
	greyscale_colors = "#bb9042"

/obj/item/clothing/gloves/color/plasmaman/engineer
	name = "工程环境手套"
	icon_state = "engieplasma"
	greyscale_colors = "#d75600"
	siemens_coefficient = 0

/obj/item/clothing/gloves/color/plasmaman/atmos
	name = "大气环境手套"
	icon_state = "atmosplasma"
	greyscale_colors = "#00a5ff"

/obj/item/clothing/gloves/color/plasmaman/explorer
	name = "探险环境手套"
	icon_state = "explorerplasma"
	greyscale_colors = "#47453d"

/obj/item/clothing/gloves/color/plasmaman/botanic_leather
	name = "植物学环境手套"
	desc = "这些皮手套可以保护你的手免受刺、倒刺、尖刺和其他有害的植物的伤害。"
	icon_state = "botanyplasma"
	greyscale_colors = "#3164ff"
	clothing_traits = list(TRAIT_PLANT_SAFE)

/obj/item/clothing/gloves/color/plasmaman/prototype
	name = "原型环境手套"
	icon_state = "protoplasma"
	greyscale_colors = "#911801"

/obj/item/clothing/gloves/color/plasmaman/clown
	name = "小丑环境手套"
	icon_state = "clownplasma"
	greyscale_colors = "#ff0000"

/obj/item/clothing/gloves/color/plasmaman/clown/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/clothing/gloves/color/plasmaman/head_of_personnel
	name = "人事部长环境手套"
	desc = "掩盖了那双丑陋的，瘦骨嶙峋的手。看来是想仿制舰长的手套。"
	icon_state = "hopplasma"
	inhand_icon_state = null
	greyscale_colors = null

/obj/item/clothing/gloves/color/plasmaman/chief_engineer
	name = "工程部长的环境服手套"
	icon_state = "ceplasma"
	greyscale_colors = "#45ff00"
	siemens_coefficient = 0

/obj/item/clothing/gloves/color/plasmaman/research_director
	name = "科研部长环境手套"
	icon_state = "rdplasma"
	greyscale_colors = "#64008a"

/obj/item/clothing/gloves/color/plasmaman/centcom_commander
	name = "中央指挥司令环境手套"
	icon_state = "commanderplasma"
	greyscale_colors = "#009100"

/obj/item/clothing/gloves/color/plasmaman/centcom_official
	name = "中央指挥官员环境手套"
	icon_state = "officialplasma"
	greyscale_colors = "#10af77"

/obj/item/clothing/gloves/color/plasmaman/centcom_intern
	name = "中央指挥实习生环境手套"
	icon_state = "internplasma"
	greyscale_colors = "#00974b"

/obj/item/clothing/gloves/color/plasmaman/radio
	name = "手语环境手套"
	desc = "允许发声能力较差的等离子人在通信中使用手语."
	icon_state = "radio_gplasma"
	inhand_icon_state = null
	greyscale_colors = null
	worn_icon_state = "radio_g"
	clothing_traits = list(TRAIT_CAN_SIGN_ON_COMMS)
