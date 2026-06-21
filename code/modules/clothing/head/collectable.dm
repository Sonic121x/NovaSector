
//Hat Station 13

/obj/item/clothing/head/collectable
	name = "收藏版帽子"
	desc = "一顶珍贵的收藏版帽子。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = null
	abstract_type = /obj/item/clothing/head/collectable

/obj/item/clothing/head/collectable/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/series, /obj/item/clothing/head/collectable, "Super duper collectable hats")

/obj/item/clothing/head/collectable/petehat
	name = "非常罕见的皮特的帽子！"
	desc = "闻起来有点等离子的味道。"
	icon_state = "petehat"

/obj/item/clothing/head/collectable/xenom
	name = "收藏版异形头盔！"
	desc = "嘶嘶嘶！"
	clothing_flags = SNUG_FIT
	icon_state = "xenom"

/obj/item/clothing/head/collectable/chef
	name = "收藏版主厨帽"
	desc = "对于帽子收藏者来说，这是一顶很珍贵的主厨帽！"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "chef"
	inhand_icon_state = "chefhat"
	dog_fashion = /datum/dog_fashion/head/chef

/obj/item/clothing/head/collectable/paper
	name = "收藏版纸帽"
	desc = "一顶看似普通的纸帽，实则是一顶罕见而珍贵的珍藏版纸帽。远离水、火和馆长。"
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "paper"
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/collectable/tophat
	name = "收藏礼帽"
	desc = "只有最负盛名的帽子收藏家才戴的大礼帽。"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "tophat"
	inhand_icon_state = "that"

/obj/item/clothing/head/collectable/captain
	name = "收藏版舰长帽"
	desc = "一顶可收藏的帽子，让你看起来就像一个真正的康蛮德尔~！"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "captain"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/captain

/obj/item/clothing/head/collectable/police
	name = "收藏版警官帽"
	desc = "一顶可收藏的警官帽。这顶帽子强调你就是法律。"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "policehelm"
	dog_fashion = /datum/dog_fashion/head/warden

/obj/item/clothing/head/collectable/beret
	name = "收藏版贝雷帽"
	desc = "一顶收藏版的红色贝雷帽，闻起来有股淡淡的大蒜味。"
	icon = 'icons/map_icons/clothing/head/beret.dmi'
	icon_state = "/obj/item/clothing/head/beret"
	post_init_icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	dog_fashion = /datum/dog_fashion/head/beret
	hair_mask = /datum/hair_mask/standard_hat_middle
	flags_1 = NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/head/collectable/welding
	name = "收藏版焊接面罩"
	desc = "一顶收藏款焊接头盔。现在含铅量减少80%！非实际焊接用途。佩戴此头盔进行任何焊接操作，风险自负！"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "welding"
	inhand_icon_state = "welding"
	lefthand_file = 'icons/mob/inhands/clothing/masks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/masks_righthand.dmi'
	clothing_flags = SNUG_FIT

/obj/item/clothing/head/collectable/slime
	name = "收藏版史莱姆帽"
	desc = "就像真正的脑虫一样！"
	icon_state = "headslime"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT

/obj/item/clothing/head/collectable/flatcap
	name = "收藏版平顶帽"
	desc = "一顶收藏版农民平顶帽！"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/flatcap"
	post_init_icon_state = "beret_flat"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#8F7654"
	inhand_icon_state = null
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/head/collectable/pirate
	name = "收藏版海盗帽"
	desc = "你会成为一个伟大的恐怖辛迪加·罗伯茨！"
	icon_state = "pirate"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/pirate

/obj/item/clothing/head/collectable/pirate/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/obj/item/clothing/head/collectable/kitty
	name = "收藏版猫耳"
	desc = "这绒毛的感觉……也太真实了吧。"
	icon_state = "kitty"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/collectable/rabbitears
	name = "收藏版兔耳"
	desc = "不如脚幸运！"
	icon_state = "bunny"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/rabbit

/obj/item/clothing/head/collectable/wizard
	name = "收藏版巫师帽"
	desc = "注意：戴上这顶帽子所获得的魔法力量纯属巧合。"
	icon = 'icons/obj/clothing/head/wizard.dmi'
	worn_icon = 'icons/mob/clothing/head/wizard.dmi'
	icon_state = "wizard"
	dog_fashion = /datum/dog_fashion/head/blue_wizard

/obj/item/clothing/head/collectable/wizard/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -2)

/obj/item/clothing/head/collectable/hardhat
	name = "收藏版安全帽"
	desc = "警告! 不会提供真正的保护，也不会产生任何亮光，但该死的，它确实很漂亮！"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	clothing_flags = SNUG_FIT
	icon_state = "hardhat0_yellow"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/collectable/hos
	name = "收藏版HoS帽"
	desc = "现在你可以殴打囚犯，做出愚蠢的判决，毫无理由地逮捕他们！"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "hoscap"

/obj/item/clothing/head/collectable/hop
	name = "收藏版HoP帽"
	desc = "现在轮到你要求更繁琐的文件、签名、盖章和雇佣更多的小丑了！文书,谢谢!"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "hopcap"
	dog_fashion = /datum/dog_fashion/head/hop

/obj/item/clothing/head/collectable/thunderdome
	name = "收藏版雷霆圆顶头盔"
	desc = "加油红队！我是说绿队！我是说红队！不，是绿队！"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome_helmet"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR|HIDEHAIR

/obj/item/clothing/head/collectable/swat
	name = "收藏版特警头盔"
	desc = "That's not real blood. That's red paint." //Reference to the actual description
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie_helmet"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR

/obj/item/clothing/head/collectable/swat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 2)
