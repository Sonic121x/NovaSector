/obj/item/clothing/under/rank/civilian
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/civilian_digi.dmi'

/obj/item/clothing/under/rank/civilian/lawyer // Lawyers' suits are in TG's suits.dmi
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/suits_digi.dmi'

/obj/item/clothing/under/rank/civilian/lawyer/bluesuit // EXCEPT THIS ONE.
	greyscale_config_worn_digi = /datum/greyscale_config/buttondown_slacks/worn/digi

/obj/item/clothing/under/rank/civilian/head_of_personnel/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/civilian.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/civilian.dmi'
	can_adjust = FALSE //Just gonna set it to default for ease

//TG's files separate this into Civilian, Clown/Mime, and Curator. We wont have as many, so all Service goes into this file.
//DO NOT ADD A /obj/item/clothing/under/rank/civilian/lawyer/nova. USE /obj/item/clothing/under/suit/nova FOR MODULAR SUITS (civilian/suits.dm).

/*
*	HEAD OF PERSONNEL
*/

/obj/item/clothing/under/rank/civilian/head_of_personnel/nova/parade
	name = "人事主管的男性正式制服"
	desc = "一件为人事主管准备的奢华制服，采用深蓝色织物制成。翻领上别着一枚柯基犬头形状的小徽章。"
	icon_state = "hop_parade_male"

/obj/item/clothing/under/rank/civilian/head_of_personnel/nova/parade/female
	name = "人事主管的女性正式制服"
	icon_state = "hop_parade_female"

/obj/item/clothing/under/rank/civilian/head_of_personnel/nova/turtleneck
	name = "人事主管的高领毛衣"
	desc = "一件柔软的蓝色高领毛衣和黑色卡其裤，供那些比起风格更偏爱舒适度的行政人员穿着。"
	icon_state = "hopturtle"
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/civilian/head_of_personnel/nova/turtleneck/skirt
	name = "人事主管的高领毛衣裙"
	desc = "一件柔软的蓝色高领毛衣和黑色短裙，供那些比起风格更偏爱舒适度的行政人员穿着。"
	icon_state = "hopturtle_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/imperial/hop
	name = "人事主管的海军连体服"
	desc = "一套浅绿色的海军制服，配有标明人事官身份的军衔徽章。目标，最大火力。"
	icon_state = "/obj/item/clothing/under/imperial/hop"
	greyscale_colors = "#829A8C#829A8C#829A8C#373741#F3F3F3#BC2626#2979CD"
	flags_1 = NONE

/obj/item/clothing/under/imperialskirt/hop
	desc = "一条浅绿色的海军短裙，配有标明人事官身份的军衔徽章。目标，最大火力。"
	name = "人事主管的海军连体裙"
	greyscale_colors = "#829A8C#829A8C#373741#F3F3F3#BC2626#2979CD"
	icon_state = "/obj/item/clothing/under/imperialskirt/hop"
	flags_1 = NONE
