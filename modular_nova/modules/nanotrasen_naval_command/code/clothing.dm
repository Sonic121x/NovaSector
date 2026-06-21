
// UNDER
/obj/item/clothing/under/rank/centcom/nova/naval
	name = "少尉制服"
	desc = "纳米传讯海军中拥有少尉军衔者所穿的制服。"
	icon_state = "naval_ensign"
	can_adjust = TRUE

/obj/item/clothing/under/rank/centcom/nova/naval/commander
	name = "指挥制服"
	desc = "纳米传讯海军中拥有指挥军衔者所穿的制服。"
	icon_state = "naval_command"

/obj/item/clothing/under/rank/centcom/nova/naval/admiral
	name = "海军上将制服"
	desc = "纳米传讯海军中拥有海军上将（Admiral）军衔者所穿的制服。"
	icon_state = "naval_admiral"

/obj/item/clothing/under/rank/centcom/nova/naval/fleet_admiral
	name = "舰队上将制服"
	desc = "纳米传讯海军中拥有舰队上将（Fleet Admiral）军衔者所穿的制服。"
	icon_state = "naval_fleet_admiral"

// GLOVES
/obj/item/clothing/gloves/combat/naval
	name = "纳米传讯海军手套"
	desc = "一双高品质的厚手套，饰有金色缝线，授予纳米传讯的海军指挥官。"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	icon_state = "naval_command"

/obj/item/clothing/gloves/combat/naval/fleet_admiral
	name = "舰队上将的手套"
	icon_state = "naval_fleet_admiral"


// HATS
/obj/item/clothing/head/hats/caphat/naval
	name = "海军帽"
	desc = "纳米传讯海军人员佩戴的帽子。"
	icon_state = "naval_command"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/hats/caphat/naval/fleet_admiral
	name = "舰队上将的帽子"
	desc = "纳米传讯舰队上将佩戴的帽子。"
	icon_state = "naval_fleet_admiral"

/obj/item/clothing/head/hats/caphat/naval/custom
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/hats/caphat/naval/custom"
	post_init_icon_state = "naval_silver"
	greyscale_config = /datum/greyscale_config/naval
	greyscale_config_worn = /datum/greyscale_config/naval/worn
	greyscale_colors = "#FF0000#333333#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1
	armor_type = /datum/armor/none

/obj/item/clothing/head/hats/caphat/naval/custom/gold
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/hats/caphat/naval/custom/gold"
	post_init_icon_state = "naval_gold"
	greyscale_config = /datum/greyscale_config/naval_gold
	greyscale_config_worn = /datum/greyscale_config/naval_gold/worn
	greyscale_colors = "#FF0000#333333"

// NECK
/obj/item/clothing/neck/pauldron
	name = "海军少校的肩甲"
	desc = "一个红色的软垫肩甲，象征着纳米传讯海军中海军少校（Lieutenant Commander）的军衔。"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	icon_state = "pauldron_ltcr"

/obj/item/clothing/neck/pauldron/commander
	name = "海军中校的肩甲"
	desc = "一个红色的软垫肩甲，象征着纳米传讯海军中海军中校（Commander）的军衔。"
	icon_state = "pauldron_commander"

/obj/item/clothing/neck/pauldron/captain
	name = "舰长的肩甲"
	desc = "一个红色的软垫肩甲，象征着纳米传讯海军中舰长（Captain）的军衔。"
	icon_state = "pauldron_captain"

/obj/item/clothing/neck/cloak/admiral
	name = "海军上将的披风"
	desc = "一件鲜绿色的披风，饰有金色缝线，由纳米传讯海军上将佩戴。"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	icon_state = "cape_admiral"

/obj/item/clothing/neck/cloak/fleet_admiral
	name = "舰队上将的披风"
	desc = "一件神圣的披风，由纳米传讯海军中最高军衔者——舰队上将佩戴。"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	icon_state = "cape_fleet_admiral"

// SUITS
/obj/item/clothing/suit/armor/vest/capcarapace/naval
	name = "海军护甲"
	desc = "一件由海军司令部成员穿戴的护甲。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "naval_carapace"

// GLASSES
/obj/item/clothing/glasses/hud/security/sunglasses/black
	name = "黑色安保太阳镜"
	desc = "一副海军司令部军官佩戴的黑色太阳镜。"
	icon = 'icons/obj/clothing/glasses.dmi'
	worn_icon = 'icons/mob/clothing/eyes.dmi'
	icon_state = "sun"
