/obj/item/clothing/under/suit
	icon = 'icons/obj/clothing/under/suits.dmi'
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	can_adjust = FALSE
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS
	inhand_icon_state = null

/obj/item/clothing/under/suit/red //Also used by the Curator's suit, /obj/item/clothing/under/rank/civilian/curator
	name = "红色西装"
	desc = "红色西装和蓝色领带。有点正式。"
	icon_state = "red_suit"
	inhand_icon_state = "r_suit"

/obj/item/clothing/under/suit/charcoal
	name = "炭黑色西装"
	desc = "一套炭黑色的西装和一条红色的领带.非常专业."
	icon_state = "charcoal_suit"

/obj/item/clothing/under/suit/navy
	name = "海军西装"
	desc = "一件海军西装和红色领带，是为空间站里最优秀的人准备的."
	icon_state = "navy_suit"

/obj/item/clothing/under/suit/burgundy
	name = "酒红色西装"
	desc = "酒红色西装配黑色领带。有点正式。"
	icon_state = "burgundy_suit"

/obj/item/clothing/under/suit/checkered
	name = "格子西装"
	desc = "你那套西装真不错。要是出了什么问题就太可惜了，是吧？"
	icon_state = "checkered_suit"

/obj/item/clothing/under/suit/beige
	name = "米色西装"
	desc = "一套优秀的浅色西装，业内专家强调，不应与劣质的棕褐色西装混淆。"
	icon_state = "beige_suit"

/obj/item/clothing/under/suit/black
	name = "黑色两件式西装"
	desc = "一套黑色西装，配炭灰色长裤和红色领带。非常正式。"
	icon_state = "black_suit"

/obj/item/clothing/under/suit/black/skirt
	name = "黑色两件式西装"
	desc = "一套黑色西装，配炭灰色短裙和红色领带。非常正式。"
	icon_state = "black_suit_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/suit/white
	name = "白色西装"
	desc = "白色西装和搭配蓝色衬衫再配上夹克。你想来一场激烈的较量？好吧!"
	icon_state = "white_suit"
	inhand_icon_state = "white_suit"

/obj/item/clothing/under/suit/white/skirt
	name = "白色西装裙"
	desc = "一件白色的套装裙，适合一位出色的主人。"
	icon_state = "white_suit_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/suit/tan
	name = "棕褐色西装"
	desc = "褐色西装。很聪明，但很随意。"
	icon_state = "tan_suit"
	inhand_icon_state = "tan_suit"

/obj/item/clothing/under/suit/waiter
	name = "侍者套装"
	desc = "这是一件非常漂亮的制服，有一个专门放小费的口袋."
	icon_state = "waiter"
	inhand_icon_state = "waiter"

/obj/item/clothing/under/suit/black_really
	name = "高管西装"
	desc = "一套正式的黑色西装，是给空间站里最优秀的人穿的."
	icon_state = "really_black_suit"
	inhand_icon_state = null

/obj/item/clothing/under/suit/black_really/skirt
	name = "高管西装裙"
	desc = "一套正式的黑色西装，是给空间站里最优秀的人穿的."
	icon_state = "really_black_suit_skirt"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY|FEMALE_UNIFORM_NO_BREASTS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/suit/tuxedo
	name = "燕尾服"
	desc = "一件正式的黑色燕尾服。它散发着优雅。"
	icon_state = "tuxedo"
	inhand_icon_state = null

/obj/item/clothing/under/suit/tuxedo/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 4) //You aren't going to fish with this are you?

/obj/item/clothing/under/suit/carpskin
	name = "鲤鱼西装"
	desc = "一套用最上等鳞片制成的奢华西装，非常适合进行可疑的商业交易。"
	icon_state = "carpskin_suit"
	inhand_icon_state = null
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/under/suit/carpskin/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)
