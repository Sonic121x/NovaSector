
/obj/item/clothing/under/rank/civilian/mime
	name = "默剧套装"
	desc = "颜色不是很鲜艳。"
	icon_state = "mime"
	inhand_icon_state = null

/obj/item/clothing/under/rank/civilian/mime/skirt
	name = "默剧裙"
	desc = "It's not very colourful."
	icon_state = "mime_skirt"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/mime/sexy
	name = "性感默剧套装"
	desc = "对马戏团来说很不合适。"
	icon_state = "sexymime"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown
	name = "小丑套装"
	desc = "<i>'HONK!'</i>"
	icon_state = "clown"
	inhand_icon_state = "clown"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE
	supports_variations_flags = NONE

//NOVA EDIT REMOVAL BEGIN
/*
/obj/item/clothing/under/rank/civilian/clown/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 50, falloff_exponent = 20) //die off quick please
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)
*/
//NOVA EDIT REMOVAL END

/obj/item/clothing/under/rank/civilian/clown/blue
	name = "蓝色小丑套装"
	desc = "<i>'BLUE HONK!'</i>"
	icon_state = "blueclown"
	inhand_icon_state = "blueclown"

/obj/item/clothing/under/rank/civilian/clown/green
	name = "绿色小丑套装"
	desc = "<i>'GREEN HONK!'</i>"
	icon_state = "greenclown"
	inhand_icon_state = "greenclown"

/obj/item/clothing/under/rank/civilian/clown/yellow
	name = "黄色小丑套装"
	desc = "<i>'YELLOW HONK!'</i>"
	icon_state = "yellowclown"
	inhand_icon_state = "yellowclown"

/obj/item/clothing/under/rank/civilian/clown/purple
	name = "紫色小丑套装"
	desc = "<i>'PURPLE HONK!'</i>"
	icon_state = "purpleclown"
	inhand_icon_state = "purpleclown"

/obj/item/clothing/under/rank/civilian/clown/orange
	name = "橙色小丑套装"
	desc = "<i>'ORANGE HONK!'</i>"
	icon_state = "orangeclown"
	inhand_icon_state = "orangeclown"

/obj/item/clothing/under/rank/civilian/clown/rainbow
	name = "彩虹小丑套装"
	desc = "<i>'R A I N B O W HONK!'</i>"
	icon_state = "rainbowclown"
	inhand_icon_state = "rainbowclown"

/obj/item/clothing/under/rank/civilian/clown/jester
	name = "弄臣套装"
	desc = "一套欢快的服装，很适合服侍你的主子，以及叔叔。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/civilian/clown/jester"
	post_init_icon_state = "jester_map"
	greyscale_config = /datum/greyscale_config/jester_suit
	greyscale_config_worn = /datum/greyscale_config/jester_suit/worn
	greyscale_colors = "#00ff00#ff0000"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/rank/civilian/clown/jesteralt
	name = "弄臣套装"
	desc = "一套欢快的服装，很适合服侍你的主子，以及叔叔。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/civilian/clown/jesteralt"
	post_init_icon_state = "jester_alt"
	greyscale_config = /datum/greyscale_config/jester_suit_alt
	greyscale_config_worn = /datum/greyscale_config/jester_suit_alt/worn
	greyscale_colors = "#E10000#E1E100"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/rank/civilian/clown/sexy
	name = "性感小丑套装"
	desc = "让你看起来非常的轰克！"
	icon_state = "sexyclown"
	inhand_icon_state = null
