// MODULAR SECURITY WEAR (NOT OVERRIDES, LOOK IN 'modular_nova\modules\sec_haul\code\security_clothing\sec_clothing_overrides.dm')

// DETECTIVE
/obj/item/clothing/under/rank/security/detective/cowboy
	name = "金发牛仔制服"
	desc = "一件蓝色衬衫和深色牛仔裤，外加一双带马刺的牛仔靴。"
	icon = 'modular_nova/master_files/icons/donator/obj/clothing/uniform.dmi'	//Donator item-ish? See the /armorless one below it
	worn_icon = 'modular_nova/master_files/icons/donator/mob/clothing/uniform.dmi'
	icon_state = "cowboy_uniform"
	supports_variations_flags = NONE
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/security/detective/cowboy/armorless //Donator variant, just uses the sprite.
	armor_type = /datum/armor/clothing_under

/obj/item/clothing/suit/cowboyvest
	name = "金发牛仔背心"
	desc = "一件白色奶油色背心，内衬……竟然是毛皮，专为沙漠天气设计。背心上缝有一个小鹿头标志。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "cowboy_vest"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	heat_protection = CHEST|ARMS

/obj/item/clothing/suit/toggle/jacket/nova/det_trench/cowboyvest
	name = "金发牛仔背心"
	desc = "一件白色奶油色背心，内衬……竟然是毛皮，专为沙漠天气设计。背心上缝有一个小鹿头标志。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "cowboy_vest"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	heat_protection = CHEST|ARMS

/obj/item/clothing/under/rank/security/detective/runner
	name = "奔跑者毛衣"
	desc = "<i>\"你看起来很孤独。\"</i>"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/security.dmi'
	icon_state = "runner"
	supports_variations_flags = NONE
	can_adjust = FALSE

/// PRISONER
/obj/item/clothing/under/rank/prisoner/protcust
	name = "保护性监禁囚犯连体服"
	desc = "一件芥末色的囚犯连体服，通常由前安保成员、线人和前中央司令部雇员穿着。其套装传感器卡在\"完全开启\"位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/protcust"
	greyscale_colors = "#FFB600"

/obj/item/clothing/under/rank/prisoner/skirt/protcust
	name = "保护性监禁囚犯连体裙"
	desc = "一件芥末色的囚犯连体裙，通常由前安保成员、线人和前中央司令部雇员穿着。其套装传感器卡在\"完全开启\"位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/skirt/protcust"
	greyscale_colors = "#FFB600"
	supports_variations_flags = NONE

/obj/item/clothing/under/rank/prisoner/lowsec
	name = "低安全级别囚犯连体服"
	desc = "一件苍白、近乎奶油色的囚犯连体服，代表低安全级别囚犯，例如欺诈等白领犯罪。其套装传感器卡在\"完全开启\"位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/lowsec"
	greyscale_colors = "#AB9278"

/obj/item/clothing/under/rank/prisoner/skirt/lowsec
	name = "低安全级别囚犯连体裙"
	desc = "一件苍白、近乎奶油色的囚犯连体裙，代表低安全级别囚犯，例如欺诈等白领犯罪。其套装传感器卡在\"完全开启\"位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/skirt/lowsec"
	greyscale_colors = "#AB9278"
	supports_variations_flags = NONE

/obj/item/clothing/under/rank/prisoner/highsec
	name = "高风险囚犯连体服"
	desc = "一件鲜红色的囚犯连体服，在不同人眼中，它要么是荣誉的象征，要么是需要避开的标志。其套装传感器卡在\"完全开启\"位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/highsec"
	greyscale_colors = "#FF3400"

/obj/item/clothing/under/rank/prisoner/skirt/highsec
	name = "高风险囚犯连体裙"
	desc = "一件鲜红色的囚犯连体裙，在不同人眼中，它要么是荣誉的象征，要么是需要避开的标志。其套装传感器卡在\"完全开启\"位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/skirt/highsec"
	greyscale_colors = "#FF3400"
	supports_variations_flags = NONE

/obj/item/clothing/under/rank/prisoner/supermax
	name = "超级囚犯连体服"
	desc = "一件深绯红色的囚犯连体服，专为最恶劣的罪犯或小丑准备。其服装传感器被卡在“完全开启”的位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/supermax"
	greyscale_colors = "#992300"

/obj/item/clothing/under/rank/prisoner/skirt/supermax
	name = "超级囚犯连体裙"
	desc = "一件深绯红色的囚犯连体裙，专为最恶劣的罪犯或小丑准备。其服装传感器被卡在“完全开启”的位置。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/skirt/supermax"
	greyscale_colors = "#992300"
	supports_variations_flags = NONE

/obj/item/clothing/under/rank/prisoner/classic
	name = "经典囚犯连体服"
	desc = "一件黑白条纹的连体服，就像电影里的一样。"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/costume.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/costume.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/costume_digi.dmi'
	icon_state = "prisonerclassic"
	post_init_icon_state = null
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/rank/prisoner/syndicate
	name = "辛迪加囚犯连体服"
	desc = "辛迪加俘虏穿着的绯红色连体服。其传感器已被短路。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/supermax" // same as supermax
	greyscale_colors = "#992300"
	has_sensor = FALSE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/under/rank/prisoner/skirt/syndicate
	name = "辛迪加囚犯连体裙"
	desc = "辛迪加俘虏穿着的绯红色连体裙。其传感器已被短路。"
	icon_state = "/obj/item/clothing/under/rank/prisoner/skirt/supermax" // same as supermax
	greyscale_colors = "#992300"
	has_sensor = FALSE
	supports_variations_flags = NONE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1
