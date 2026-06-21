/obj/item/clothing/under/costume
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/costume_digi.dmi'

/obj/item/clothing/under/costume/russian_officer
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/security_digi.dmi'

/obj/item/clothing/under/costume/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/costume.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/costume.dmi'
	can_adjust = FALSE

//My least favorite file. Just... try to keep it sorted. And nothing over the top

/*
*	UNSORTED
*/
/obj/item/clothing/under/costume/nova/cavalry
	name = "骑兵制服"
	desc = "投身于更崇高的事业。为了忠诚与荣誉，因为只有当所有人都背弃它时，它才会消亡。"
	icon_state = "cavalry" //specifically an 1890s US Army Cavalry Uniform

/obj/item/clothing/under/costume/deckers/alt //not even going to bother re-pathing this one because it's such a unique case of 'TGs item has something but this alt doesnt'
	name = "迪克斯无面具套装"
	desc = "一件霓虹蓝配色的迪克斯连体服。"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/costume.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/costume.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/costume_digi.dmi'
	icon_state = "decking_jumpsuit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/nova/bathrobe
	name = "浴袍"
	desc = "一件温暖蓬松的浴袍，非常适合在终于洗干净后放松身心。"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/bathrobe"
	post_init_icon_state = "robes"
	worn_icon = 'modular_nova/modules/GAGS/icons/suit/suit.dmi'
	worn_icon_teshari = 'modular_nova/modules/GAGS/icons/suit/suit_teshari.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	greyscale_colors = "#ffffff"
	greyscale_config = /datum/greyscale_config/bathrobe
	greyscale_config_worn = /datum/greyscale_config/bathrobe/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/bathrobe/worn/teshari
	greyscale_config_worn_better_vox = /datum/greyscale_config/bathrobe/worn/newvox
	greyscale_config_worn_vox = /datum/greyscale_config/bathrobe/worn/oldvox
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#434d7a" //THATS RIGHT, FUCK YOU! THE BATHROBE CAN BE RECOLORED!
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/dutch
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/dutch"
	post_init_icon_state = "dutchsuit"
	greyscale_config = /datum/greyscale_config/dutch_outfit
	greyscale_config_worn = /datum/greyscale_config/dutch_outfit/worn
	greyscale_config_worn_digi = /datum/greyscale_config/dutch_outfit/worn/digi
	greyscale_colors = "#333333#f8f8f8#ff0000#ffcc00"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/dutch/syndicate
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

/obj/item/clothing/suit/costume/pg
	icon = 'icons/map_icons/clothing/suit/costume.dmi'
	icon_state = "/obj/item/clothing/suit/costume/pg"
	post_init_icon_state = "powderganger"
	greyscale_config = /datum/greyscale_config/powderganger
	greyscale_config_worn = /datum/greyscale_config/powderganger/worn
	greyscale_colors = "#76502b#c0c0c0"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/chaplainsuit/monkrobeeast
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/chaplainsuit/monkrobeeast"
	post_init_icon_state = "monkrobeeast"
	greyscale_config = /datum/greyscale_config/monkrobeeast
	greyscale_config_worn = /datum/greyscale_config/monkrobeeast/worn
	greyscale_config_worn_digi = /datum/greyscale_config/monkrobeeast/worn/digi
	greyscale_colors = "#EADB83#D98E43#A52F29#212026"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/nova/maid_uniform
	name = "maid uniform"
	desc = "A simple maid uniform for housekeeping."
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/maid_uniform"
	post_init_icon_state = "maid_uniform"
	greyscale_config = /datum/greyscale_config/maid_uniform
	greyscale_config_worn = /datum/greyscale_config/maid_uniform/worn
	greyscale_colors = "#2B2B31#EEEEEE"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alternate_worn_layer = UNDER_SUIT_LAYER
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/nova/maid_uniform_alt
	name = "maid uniform"
	desc = "A simple maid uniform for housekeeping."
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/maid_uniform_alt"
	post_init_icon_state = "maid_uniform_alt"
	greyscale_config = /datum/greyscale_config/maid_uniform_alt
	greyscale_config_worn = /datum/greyscale_config/maid_uniform_alt/worn
	greyscale_colors = "#2B2B31#EEEEEE"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alternate_worn_layer = UNDER_SUIT_LAYER
	can_adjust = TRUE
	flags_1 = IS_PLAYER_COLORABLE_1

/*
*	LUNAR AND JAPANESE CLOTHES
*/

/obj/item/clothing/under/costume/nova/qipao
	name = "旗袍"
	desc = "一件旗袍，在古代地球中国，女性在社交活动和农历新年期间的传统穿着。"
	body_parts_covered = CHEST|GROIN|LEGS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#2b2b2b"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/qipao"
	post_init_icon_state = "qipao"
	greyscale_config = /datum/greyscale_config/qipao
	greyscale_config_worn = /datum/greyscale_config/qipao/worn
	greyscale_config_worn_digi = /datum/greyscale_config/qipao/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/costume/nova/qipao/customtrim
	greyscale_colors = "#2b2b2b#ffce5b"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/qipao/customtrim"
	post_init_icon_state = "qipao"
	greyscale_config = /datum/greyscale_config/qipao_customtrim
	greyscale_config_worn = /datum/greyscale_config/qipao_customtrim/worn
	greyscale_config_worn_digi = /datum/greyscale_config/qipao_customtrim/worn/digi

/obj/item/clothing/under/costume/nova/cheongsam
	name = "长衫"
	desc = "一件长衫，在古代地球中国，男性在社交活动和农历新年期间的传统穿着。"
	body_parts_covered = CHEST|GROIN|LEGS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#2b2b2b#353535"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/cheongsam"
	post_init_icon_state = "cheongsam"
	greyscale_config = /datum/greyscale_config/cheongsam
	greyscale_config_worn = /datum/greyscale_config/cheongsam/worn
	greyscale_config_worn_digi = /datum/greyscale_config/cheongsam/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/costume/nova/cheongsam/customtrim
	greyscale_colors = "#2b2b2b#ffce5b#353535"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/cheongsam/customtrim"
	post_init_icon_state = "cheongsam"
	greyscale_config = /datum/greyscale_config/cheongsam_customtrim
	greyscale_config_worn = /datum/greyscale_config/cheongsam_customtrim/worn
	greyscale_config_worn_digi = /datum/greyscale_config/cheongsam_customtrim/worn/digi

/obj/item/clothing/under/costume/nova/yukata
	name = "浴衣"
	desc = "一件古代地球日本传统的浴衣，通常在休闲场合穿着。"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#2b2b2b#666666"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/yukata"
	post_init_icon_state = "yukata"
	greyscale_config = /datum/greyscale_config/yukata
	greyscale_config_worn = /datum/greyscale_config/yukata/worn
	greyscale_config_worn_digi = /datum/greyscale_config/yukata/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/costume/nova/kamishimo
	name = "裃"
	desc = "一件古代地球日本传统的裃。"
	icon_state = "kamishimo"

/obj/item/clothing/under/costume/nova/kimono
	name = "华丽和服"
	desc = "一件古代地球日本传统的和服。比浴衣更长、更华丽。"
	icon_state = "kimono"
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/costume/nova/shihakusho
	name = "死霸装"
	desc = "一件古代地球日本传统的死霸装。"
	icon_state = "shihakusho"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/under/costume/nova/chima_jeogori
	name = "赤古里裙"
	desc = "韩国传统服饰，常作为正装穿着。"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/chima_jeogori"
	post_init_icon_state = "chima_jeogori"
	greyscale_config = /datum/greyscale_config/chima_jeogori
	greyscale_config_worn = /datum/greyscale_config/chima_jeogori/worn
	greyscale_colors = "#a52f29#2ba396#545461#88242d#eeeeee"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alternate_worn_layer = UNDER_SUIT_LAYER
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	flags_1 = IS_PLAYER_COLORABLE_1

/*
*	CHRISTMAS CLOTHES
*/

/obj/item/clothing/under/costume/nova/christmas
	name = "圣诞装扮"
	desc = "伙计们，你们敢信吗？圣诞节。就在一光年之外！" //Lightyear is a measure of distance I hate it being used for this joke :(
	greyscale_colors = "#cc0f0f#c4c2c2"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/nova/christmas"
	post_init_icon_state = "christmas_male"
	greyscale_config = /datum/greyscale_config/chrimbo
	greyscale_config_worn = /datum/greyscale_config/chrimbo/worn
	greyscale_config_worn_digi = /datum/greyscale_config/chrimbo/worn/digi
	body_parts_covered = CHEST|GROIN|ARMS
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/nova/christmas/croptop
	name = "性感圣诞装扮"
	desc = "About 550 years since the release of Mariah Carey's \"All I Want For Christmas is You\", society has yet to properly recover from its repercussions. Some still keep a gun as their christmas mantlepiece, just in case she's heard singing on their rooftop late in the night..."
	greyscale_colors = "#cc0f0f#c4c2c2"
	icon_state = "/obj/item/clothing/under/costume/nova/christmas/croptop"
	post_init_icon_state = "christmas_female"
	greyscale_config = /datum/greyscale_config/chrimbo
	greyscale_config_worn = /datum/greyscale_config/chrimbo/worn
	greyscale_config_worn_digi = /datum/greyscale_config/chrimbo/worn/digi
	body_parts_covered = CHEST|GROIN
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	flags_1 = IS_PLAYER_COLORABLE_1

/*
*	TREK CLOTHES
*/
/obj/item/clothing/under/trek/command
	greyscale_config_worn_digi = /datum/greyscale_config/trek/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/trek/engsec
	greyscale_config_worn_digi = /datum/greyscale_config/trek/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/trek/medsci
	greyscale_config_worn_digi = /datum/greyscale_config/trek/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/camo/gags
	name = "camouflage jumpsuit"
	desc = "The space mall ninja fears the space mall soldier."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/solfed/marines"
	post_init_icon_state = "solfed_camo"
	worn_icon_state = "solfed_camo"
	worn_icon_digi = "solfed_camo"
	greyscale_config = /datum/greyscale_config/solfedcamo
	greyscale_config_worn = /datum/greyscale_config/solfedcamo/worn
	greyscale_config_worn_digi = /datum/greyscale_config/solfedcamo/worn/digi
	greyscale_colors = "#4d4d4d#333333#292929"
	can_adjust = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1
