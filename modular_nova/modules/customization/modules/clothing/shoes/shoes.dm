#define MODULAR_SHOES_ICON 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
#define MODULAR_SHOES_WORN_ICON 'modular_nova/master_files/icons/mob/clothing/feet.dmi'

/obj/item/clothing/shoes/wraps
	name = "镀金腿带"
	desc = "脚踝覆盖物。这些带有金色图案。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "gildedcuffs"
	body_parts_covered = FALSE

/obj/item/clothing/shoes/wraps/silver
	name = "银色腿带"
	desc = "脚踝护套。并非由真银制成。"
	icon_state = "silvergildedcuffs"

/obj/item/clothing/shoes/wraps/red
	name = "红色腿部绑带"
	desc = "脚踝护套。用这些闪亮的红色款式来展示你的风格吧！"
	icon_state = "redcuffs"

/obj/item/clothing/shoes/wraps/blue
	name = "蓝色腿部绑带"
	desc = "脚踝护套。冲浪去吧，兄弟。"
	icon_state = "bluecuffs"

/obj/item/clothing/shoes/cowboy/laced/recolorable
	worn_icon = MODULAR_SHOES_WORN_ICON
	greyscale_colors = "#412e22#daeeee"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/cowboy/laced/recolorable"
	post_init_icon_state = "cowboy_greyscale"
	greyscale_config = /datum/greyscale_config/cowboy_boots
	greyscale_config_worn = /datum/greyscale_config/cowboy_boots/worn
	greyscale_config_worn_digi = /datum/greyscale_config/cowboy_boots/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/high_heels
	name = "高跟鞋"
	desc = "一双漂亮的高跟鞋。对你低于平均的身高不会有太大补偿作用。"
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/high_heels"
	post_init_icon_state = "heels"
	greyscale_config = /datum/greyscale_config/heels
	greyscale_config_worn = /datum/greyscale_config/heels/worn
	greyscale_config_worn_digi = /datum/greyscale_config/heels/worn/digi
	greyscale_colors = "#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/high_heels/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_nova/master_files/sound/effects/heel1.ogg' = 1, 'modular_nova/master_files/sound/effects/heel2.ogg' = 1), 50)

/obj/item/clothing/shoes/fancy_heels
	name = "华丽高跟鞋"
	desc = "一双穿在脚上显得小巧许多的华丽高跟鞋。"
	worn_icon = MODULAR_SHOES_WORN_ICON
	greyscale_colors = "#FFFFFF"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/fancy_heels"
	post_init_icon_state = "fancyheels"
	greyscale_config = /datum/greyscale_config/fancyheels
	greyscale_config_worn = /datum/greyscale_config/fancyheels/worn
	greyscale_config_worn_digi = /datum/greyscale_config/fancyheels/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/fancy_heels/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_nova/master_files/sound/effects/heel1.ogg' = 1, 'modular_nova/master_files/sound/effects/heel2.ogg' = 1), 50)

/obj/item/clothing/shoes/jungleboots
	name = "丛林靴"
	desc = "带我去你的天堂，我想看看丛林。一双棕色的靴子。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "jungle"
	inhand_icon_state = "jackboots"
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE

/obj/item/clothing/shoes/jungleboots/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/jackboots/black
	name = "深色及踝靴"
	desc = "纳米传讯安保部门配发的战斗靴，适用于战斗场景或战斗情境。一切皆为战斗，时刻准备战斗。这双靴子是全黑色的。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "blackjack"

/obj/item/clothing/shoes/wraps/cloth
	name = "布质足部绑带"
	desc = "像木乃伊一样缠绕的拳击绷带或普通绷带，具体样式全凭穿着者选择。"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/wraps/cloth"
	post_init_icon_state = "clothwrap"
	greyscale_config = /datum/greyscale_config/clothwraps
	greyscale_config_worn = /datum/greyscale_config/clothwraps/worn
	greyscale_config_worn_digi = /datum/greyscale_config/clothwraps/worn/digi
	greyscale_colors = "#FFFFFF"
	body_parts_covered = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/wraps/colourable
	name = "可着色足部绑带"
	desc = "脚踝护套。这些款式拥有可自定义的颜色设计。"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/wraps/colourable"
	post_init_icon_state = "legwrap"
	greyscale_config = /datum/greyscale_config/legwraps
	greyscale_config_worn = /datum/greyscale_config/legwraps/worn
	greyscale_config_worn_digi = /datum/greyscale_config/legwraps/worn/digi
	greyscale_colors = "#FFFFFF"
	body_parts_covered = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/sports
	name = "运动鞋"
	desc = "为运动型人士准备的鞋子。查尔顿的巨人们招待着伊普斯维奇的泰坦们——让双方都显得尺寸正常。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "sportshoe"

/obj/item/clothing/shoes/jackboots/knee
	name = "及膝靴"
	desc = "一双典型的纳米传讯制式战斗长靴，长度足以覆盖穿戴者的膝盖。通常由指挥军官穿着。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "kneeboots"

/obj/item/clothing/shoes/jackboots/timbs
	name = "徒步靴"
	desc = "虽然防护性不如纳米传讯配发的工作靴，但这些时尚的靴子在恶劣气候下依然相当有效。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "timbs"
	fastening_type = SHOES_LACED

/obj/item/clothing/shoes/jackboots/duckboots
	name = "东北鸭靴"
	desc = "一双坚固的冬季靴子。牛皮鞋面缝合在橡胶鞋底上，提供了无与伦比的防水性，而鞋底花纹确保了在崎岖地形中的高抓地力。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "duckboots"
	fastening_type = SHOES_LACED

/obj/item/clothing/shoes/jackboots/duckboots/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, "它的鞋跟上印有一个小小的<b>[span_red("red five pointed star")]</b>，鞋底下方蚀刻着<b>[span_red("DIRIGO")]</b>。")

/obj/item/clothing/shoes/jackboots/toeless // Ported from SPLURT
	name = "无趾军靴"
	desc = "经过改装的短靴，对脚趾长有爪子的种族特别友好。"
	icon = MODULAR_SHOES_ICON
	icon_state = "jackboots-toeless"
	worn_icon = MODULAR_SHOES_WORN_ICON
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'

/obj/item/clothing/shoes/workboots/toeless // Ported from SPLURT
	name = "无趾工作靴"
	desc = "一双无趾工作靴，专为工业环境设计。为脚趾带爪的种族进行了改装。"
	icon = MODULAR_SHOES_ICON
	icon_state = "workboots-toeless"
	worn_icon = MODULAR_SHOES_WORN_ICON
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'

/obj/item/clothing/shoes/winterboots/christmas
	name = "圣诞靴"
	desc = "一双毛茸茸的圣诞靴子！"
	greyscale_colors = "#cc0f0f#c4c2c2"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/winterboots/christmas"
	post_init_icon_state = "christmas_boots"
	greyscale_config = /datum/greyscale_config/boots/christmasboots
	greyscale_config_worn = /datum/greyscale_config/boots/christmasboots/worn
	greyscale_config_worn_digi = /datum/greyscale_config/boots/christmasboots/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/clown_shoes/pink
	name = "粉色小丑鞋"
	desc = "一双特别粉红的、充满双关意味的鞋子。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	icon_state = "pink_clown_shoes"

/obj/item/clothing/shoes/clown_shoes/pink/heels
	name = "粉色小丑高跟鞋"
	desc = "一双特别粉色的双关语高跟鞋。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'
	icon_state = "pink_clown_heels"
	inhand_icon_state = null

// No clown squeak version
/obj/item/clothing/shoes/pink_clown_heels
	name = "粉色小丑高跟鞋"
	desc = "一双特别粉的高跟鞋。"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'
	icon_state = "pink_clown_heels"
	inhand_icon_state = null

/obj/item/clothing/shoes/pink_clown_heels/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_nova/master_files/sound/effects/heel1.ogg' = 1, 'modular_nova/master_files/sound/effects/heel2.ogg' = 1), 50)

/obj/item/clothing/shoes/colorable_laceups
	name = "系带鞋"
	desc = "这些鞋似乎没有预先抛光，真令人扫兴。"
	worn_icon = 'modular_nova/modules/GAGS/icons/shoes/shoes.dmi'
	worn_icon_teshari = 'modular_nova/modules/GAGS/icons/shoes/shoes_teshari.dmi'
	greyscale_colors = "#383631"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/colorable_laceups"
	post_init_icon_state = "laceups"
	greyscale_config = /datum/greyscale_config/laceup
	greyscale_config_worn = /datum/greyscale_config/laceup/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/laceup/worn/teshari
	greyscale_config_worn_better_vox = /datum/greyscale_config/laceup/worn/newvox
	greyscale_config_worn_vox = /datum/greyscale_config/laceup/worn/oldvox
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/colorable_sandals
	name = "凉鞋"
	desc = "传闻说穿着这玩意儿配袜子会让你被好几个星区列入禁止入境名单。"
	worn_icon = 'modular_nova/modules/GAGS/icons/shoes/shoes.dmi'
	worn_icon_teshari = 'modular_nova/modules/GAGS/icons/shoes/shoes_teshari.dmi'
	greyscale_colors = "#383631"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/colorable_sandals"
	post_init_icon_state = "sandals"
	greyscale_config = /datum/greyscale_config/sandals
	greyscale_config_worn = /datum/greyscale_config/sandals/worn
	greyscale_config_worn_digi = /datum/greyscale_config/sandals/worn/digi
	greyscale_config_worn_teshari = /datum/greyscale_config/sandals/worn/teshari
	greyscale_config_worn_better_vox = /datum/greyscale_config/sandals/worn/newvox
	greyscale_config_worn_vox = /datum/greyscale_config/sandals/worn/oldvox
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/jackboots/recolorable
	worn_icon = 'modular_nova/modules/GAGS/icons/shoes/shoes.dmi'
	worn_icon_teshari = 'modular_nova/modules/GAGS/icons/shoes/shoes_teshari.dmi'
	greyscale_colors = "#383631"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/jackboots/recolorable"
	post_init_icon_state = "boots"
	greyscale_config = /datum/greyscale_config/boots
	greyscale_config_worn = /datum/greyscale_config/boots/worn
	greyscale_config_worn_digi = /datum/greyscale_config/boots/worn/digi
	greyscale_config_worn_teshari = /datum/greyscale_config/boots/worn/teshari
	greyscale_config_worn_better_vox = /datum/greyscale_config/boots/worn/newvox
	greyscale_config_worn_vox = /datum/greyscale_config/boots/worn/oldvox
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/jackboots/knee/recolorable
	name = "及膝靴"
	desc = "一双典型的纳米传讯制式战斗长筒靴，长度足以覆盖穿着者的膝盖。通常由指挥军官穿着。"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	greyscale_colors = "#2D2D30"
	icon_state = "/obj/item/clothing/shoes/jackboots/knee/recolorable"
	post_init_icon_state = "knee_boots"
	greyscale_config = /datum/greyscale_config/knee_boots
	greyscale_config_worn = /datum/greyscale_config/knee_boots/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/sport_boots
	name = "运动靴"
	desc = "一双舒适的运动靴，适合跑步和体育活动。"
	worn_icon = MODULAR_SHOES_WORN_ICON
	greyscale_colors = "#292929#ffffff#ff9900"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/sport_boots"
	post_init_icon_state = "sport_boots"
	greyscale_config = /datum/greyscale_config/sport_boots
	greyscale_config_worn = /datum/greyscale_config/sport_boots/worn
	greyscale_config_worn_digi = /datum/greyscale_config/sport_boots/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/wraps/cloth
	name = "布质足部绑带"
	desc = "像木乃伊一样缠绕的拳击绷带或普通绷带，具体样式全凭穿着者选择。"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/wraps/cloth"
	post_init_icon_state = "clothwrap"
	greyscale_config = /datum/greyscale_config/clothwraps
	greyscale_config_worn = /datum/greyscale_config/clothwraps/worn
	greyscale_config_worn_digi = /datum/greyscale_config/clothwraps/worn/digi
	greyscale_colors = "#FFFFFF"
	body_parts_covered = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/galoshes/heeled
	name = "高跟雨靴"
	desc = "一双黄色的橡胶高跟，旨在防止在湿滑表面打滑。这比普通高跟鞋更难行走。"
	icon_state = "galoshes_heeled"
	icon = MODULAR_SHOES_ICON
	worn_icon = MODULAR_SHOES_WORN_ICON
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'
	custom_premium_price = PAYCHECK_CREW * 3

/obj/item/clothing/shoes/fancy_heels/cc
	name = "nanotrasen heels"
	desc = "Surely these aren't official. Right?"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/cc"
	greyscale_colors = "#316E4A"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/syndi
	name = "syndiheels"
	desc = "Heel in more way than one."
	icon_state = "/obj/item/clothing/shoes/fancy_heels/syndi"
	greyscale_colors = "#18191E"
	body_parts_covered = parent_type::body_parts_covered | LEGS
	armor_type = /datum/armor/shoes_combat

	lace_time = 12 SECONDS
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	strip_delay = 2 SECONDS
	force = 10
	throwforce = 15
	sharpness = SHARP_POINTY
	attack_verb_continuous = list("attacks", "slices", "slashes", "cuts", "stabs")
	attack_verb_simple = list("attack", "slice", "slash", "cut", "stab")
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/wizard
	name = "magical heels"
	desc = "A pair of heels that seem to magically solve all the problems with walking in heels."
	icon_state = "/obj/item/clothing/shoes/fancy_heels/wizard"
	strip_delay = 2 SECONDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	greyscale_colors = "#291A69"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/red
	name = "red heels"
	desc = "A pair of classy red heels."
	icon_state = "/obj/item/clothing/shoes/fancy_heels/red"
	greyscale_colors = "#921C25"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/blue
	name = "blue heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/blue"
	greyscale_colors = "#41579a"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/lightgrey
	name = "light grey heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/lightgrey"
	greyscale_colors = "#d0d7da"
	flags_1 = null

//HEELED STUFF (NOT THE FANCY HEELS) SPRITES BY DimWhat OF MONKE STATION

/obj/item/clothing/shoes/workboots/mining/heeled
	name = "heeled mining boots"
	desc = "Steel-toed mining heels for mining in hazardous environments. This was an awful idea."
	icon_state = "explorer_heeled"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'
	species_exception = null

/obj/item/clothing/shoes/fancy_heels/navyblue
	name = "navy blue heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/navyblue"
	greyscale_colors = "#362f68"
	flags_1 = null

/obj/item/clothing/shoes/workboots/heeled
	name = "heeled work boots"
	desc = "Nanotrasen-issue Engineering lace-up work heels that seem almost especially designed to cause a workplace accident."
	icon_state = "workboots_heeled"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'
	species_exception = null

//MEDICAL

/obj/item/clothing/shoes/fancy_heels/white
	name = "white heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/white"
	greyscale_colors = "#ffffff"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/darkblue
	name = "dark blue heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/darkblue"
	greyscale_colors = "#364660"
	flags_1 = null

//SCIENCE

/obj/item/clothing/shoes/fancy_heels/black
	name = "black heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/black"
	greyscale_colors = "#39393f"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/purple
	name = "purple heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/purple"
	greyscale_colors = "#7e1980"
	flags_1 = null

//SECURITY

/obj/item/clothing/shoes/fancy_heels/red
	name = "red heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/red"
	greyscale_colors = "#a52f29"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/grey
	name = "grey heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/grey"
	greyscale_colors = "#918f8c"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/brown
	name = "brown heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/brown"
	greyscale_colors = "#784f44"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/orange
	name = "orange heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/orange"
	greyscale_colors = "#ff8d1e"
	flags_1 = null

//HEELED STUFF (NOT THE FANCY HEELS) SPRITES BY DimWhat OF MONKE STATION

/obj/item/clothing/shoes/jackboots/gogo_boots
	name = "tactical go-go boots"
	desc = "Highly tactical footwear designed to give you a better view of the battlefield."
	icon_state = "hos_boots"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'

//SERVICE

/obj/item/clothing/shoes/fancy_heels/lightblue
	name = "light blue heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/lightblue"
	greyscale_colors = "#3e6588"
	flags_1 = null
/obj/item/clothing/shoes/fancy_heels/green
	name = "green heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/green"
	greyscale_colors = "#50d967"
	flags_1 = null

/obj/item/clothing/shoes/clown_shoes/heeled
	name = "honk heels"
	desc = "A pair of high heeled clown shoes. What kind of maniac would design these?"
	icon_state ="honk_heels"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/feet_digi.dmi'

/obj/item/clothing/shoes/fancy_heels/darkgreen
	name = "dark green heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/darkgreen"
	greyscale_colors = "#47853a"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/teal
	name = "teal heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/teal"
	greyscale_colors = "#5cbfaa"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/mutedblack
	name = "muted black heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/mutedblack"
	greyscale_colors = "#2f3038"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/mutedblue
	name = "muted blue heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/mutedblue"
	greyscale_colors = "#1165c5"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/beige
	name = "beige heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/beige"
	greyscale_colors = "#a69e9a"
	flags_1 = null

/obj/item/clothing/shoes/fancy_heels/darkgrey
	name = "dark grey heels"
	icon_state = "/obj/item/clothing/shoes/fancy_heels/darkgrey"
	greyscale_colors = "#46464d"
	flags_1 = null

#undef MODULAR_SHOES_ICON
#undef MODULAR_SHOES_WORN_ICON
