/obj/item/clothing/under/costume
	icon = 'icons/obj/clothing/under/costume.dmi'
	worn_icon = 'icons/mob/clothing/under/costume.dmi'

/obj/item/clothing/under/costume/roman
	name = "\improper 罗马盔甲"
	desc = "古罗马盔甲。由金属和皮革带制成。"
	icon_state = "roman"
	inhand_icon_state = "armor"
	can_adjust = FALSE
	strip_delay = 10 SECONDS
	resistance_flags = NONE

/obj/item/clothing/under/costume/jabroni
	name = "董大伟服装"
	desc = "黑暗，深邃，幻想。"
	icon_state = "darkholme"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/owl
	name = "猫头鹰制服"
	desc = "一件柔软的棕色连身衣，由合成羽毛和坚定的信念制成。"
	icon_state = "owl"
	inhand_icon_state = "owl"
	can_adjust = FALSE

/obj/item/clothing/under/costume/griffin
	name = "狮鹫制服"
	desc = "一件柔软的棕色连身衣，用合成羽毛做的白色羽毛领子，还带有一种对混乱的渴望。"
	icon_state = "griffin"
	can_adjust = FALSE

/obj/item/clothing/under/costume/seifuku
	name = "女学生制服"
	desc = "这就像我喜欢的日本动画片一样！"
	greyscale_colors = "#942737#4A518D#EBEBEB"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/seifuku"
	post_init_icon_state = "seifuku"
	greyscale_config_inhand_left = /datum/greyscale_config/seifuku_inhands_left
	greyscale_config_inhand_right = /datum/greyscale_config/seifuku_inhands_right
	inhand_icon_state = "seifuku"
	greyscale_config = /datum/greyscale_config/seifuku
	greyscale_config_worn = /datum/greyscale_config/seifuku/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alternate_worn_layer = UNDER_SUIT_LAYER

/obj/item/clothing/under/costume/seifuku/red
	icon_state = "/obj/item/clothing/under/costume/seifuku/red"
	greyscale_colors = "#3F4453#BB2E2E#EBEBEB"

/obj/item/clothing/under/costume/seifuku/teal
	icon_state = "/obj/item/clothing/under/costume/seifuku/teal"
	greyscale_colors = "#942737#2BA396#EBEBEB"

/obj/item/clothing/under/costume/seifuku/tan
	icon_state = "/obj/item/clothing/under/costume/seifuku/tan"
	greyscale_colors = "#87502E#B9A56A#EBEBEB"

/obj/item/clothing/under/costume/pirate
	name = "海盗套装"
	desc = "呀儿。"
	icon_state = "pirate"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/soviet
	name = "苏联制服"
	desc = "为了祖国！"
	icon_state = "soviet"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/redcoat
	name = "英军制服"
	desc = "看起来好老。"
	icon_state = "redcoat"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/kilt
	name = "苏格兰裙"
	desc = "包括鞋子和格子。"
	icon_state = "kilt"
	inhand_icon_state = "kilt"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE

/obj/item/clothing/under/costume/kilt/highlander
	desc = "你是唯一配得上这条短裙的人."

/obj/item/clothing/under/costume/kilt/highlander/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER_TRAIT)

/obj/item/clothing/under/costume/gladiator
	name = "角斗士制服"
	desc = "你不开心吗？你不就是为这个来的吗？"
	icon_state = "gladiator"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = NO_FEMALE_UNIFORM
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	can_adjust = FALSE
	resistance_flags = NONE

/obj/item/clothing/under/costume/gladiator/ash_walker
	desc = "这件角斗士制服似乎被灰覆盖，而且相当陈旧。"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/costume/maid
	name = "女仆装"
	desc = "中国女仆"
	greyscale_colors = "#494955#EEEEEE"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/maid"
	post_init_icon_state = "maid"
	greyscale_config = /datum/greyscale_config/maid
	greyscale_config_worn = /datum/greyscale_config/maid/worn
	greyscale_config_inhand_left = /datum/greyscale_config/maid_inhands_left
	greyscale_config_inhand_right = /datum/greyscale_config/maid_inhands_right
	inhand_icon_state = "maid"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|GROIN
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	alternate_worn_layer = UNDER_SUIT_LAYER
	can_adjust = FALSE
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR //weebs are gonna love this

/obj/item/clothing/under/costume/geisha
	name = "艺妓服"
	desc = "不包括可爱的太空忍者前辈。"
	icon_state = "geisha"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/under/costume/yukata
	name = "黑色浴衣"
	desc = "一件舒适的黑色棉质浴衣，灵感源自传统设计，非常适合非正式场合。"
	icon_state = "yukata1"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/costume/yukata/green
	name = "绿色浴衣"
	desc = "一件舒适的绿色棉质浴衣，灵感源自传统设计，非常适合非正式场合。"
	icon_state = "yukata2"

/obj/item/clothing/under/costume/yukata/white
	name = "白色浴衣"
	desc = "一件舒适的白色棉质浴衣，灵感源自传统设计，非常适合非正式场合。"
	icon_state = "yukata3"

/obj/item/clothing/under/costume/kimono
	name = "黑色和服"
	desc = "一件奢华的黑丝和服，带有传统风情，适合优雅的节庆场合。"
	icon_state = "kimono1"
	inhand_icon_state = "yukata1"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/costume/kimono/red
	name = "红色和服"
	desc = "一件奢华的红丝和服，带有传统风情，适合优雅的节庆场合。"
	icon_state = "kimono2"
	inhand_icon_state = "kimono2"

/obj/item/clothing/under/costume/kimono/purple
	name = "紫色和服"
	desc = "一件奢华的紫丝和服，带有传统风情，适合优雅的节庆场合。"
	icon_state = "kimono3"
	inhand_icon_state = "kimono3"

/obj/item/clothing/under/costume/villain
	name = "反派角色服"
	desc = "如果你想要抓住一个真正的超级英雄，那么换换衣服是必要的。"
	icon_state = "villain"
	can_adjust = FALSE

/obj/item/clothing/under/costume/sailor
	name = "水手服"
	desc = "船长在军官室里喝着杜松子酒。"
	icon_state = "sailor"
	inhand_icon_state = "b_suit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/singer
	abstract_type = /obj/item/clothing/under/costume/singer
	desc = "光看这个就让你想唱歌。"
	body_parts_covered = CHEST|GROIN|ARMS
	alternate_worn_layer = ABOVE_SHOES_LAYER
	can_adjust = FALSE

/obj/item/clothing/under/costume/singer/yellow
	name = "黄色表演服"
	icon_state = "ysing"
	inhand_icon_state = null
	female_sprite_flags = NO_FEMALE_UNIFORM

/obj/item/clothing/under/costume/singer/blue
	name = "绿色表演服"
	icon_state = "bsing"
	inhand_icon_state = null
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/costume/singer/red
	name = "红色表演者服装"
	icon_state = "rsing"
	inhand_icon_state = null
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/costume/mummy
	name = "木乃伊裹条"
	desc = "要么重置石板，要么再多听我啰嗦几句。"
	icon_state = "mummy"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE

/obj/item/clothing/under/costume/scarecrow
	name = "稻草人衣服"
	desc = "在植物中完美伪装。"
	icon_state = "scarecrow"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE

/obj/item/clothing/under/costume/draculass
	name = "恶魔风格外套"
	desc = "这条裙子的灵感来自古老的“维多利亚”时代。"
	icon_state = "draculass"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE

/obj/item/clothing/under/costume/drfreeze
	name = "冷冻博士连身衣"
	desc = "一件改良的科学家连身衣，看起来特别酷."
	icon_state = "drfreeze"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/lobster
	name = "泡沫龙虾服"
	desc = "谁把大学吉祥物砍了？"
	icon_state = "lobster"
	inhand_icon_state = null
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/costume/gondola
	name = "贡多拉毛皮服"
	desc = "现在你可以做给大家吃了。"
	icon_state = "gondola"
	inhand_icon_state = "lb_suit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/skeleton
	name = "骨架连身衣"
	desc = "一件黑色连身裤，上面印着白色的骨头图案。好吓人！"
	icon_state = "skeleton"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE

// Mech suit skins
/datum/atom_skin/mech_suit
	abstract_type = /datum/atom_skin/mech_suit

/datum/atom_skin/mech_suit/red
	preview_name = "Red"
	new_icon_state = "red_mech_suit"

/datum/atom_skin/mech_suit/white
	preview_name = "White"
	new_icon_state = "white_mech_suit"

/datum/atom_skin/mech_suit/blue
	preview_name = "Blue"
	new_icon_state = "blue_mech_suit"

/datum/atom_skin/mech_suit/black
	preview_name = "Black"
	new_icon_state = "black_mech_suit"

/obj/item/clothing/under/costume/mech_suit
	name = "机甲驾驶服"
	desc = "一套机甲驾驶服，可能会让你的屁股看起来很大."
	icon_state = "red_mech_suit"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	female_sprite_flags = NO_FEMALE_UNIFORM
	alternate_worn_layer = GLOVES_LAYER //covers hands but gloves can go over it. This is how these things work in my head.
	can_adjust = FALSE

/obj/item/clothing/under/costume/mech_suit/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/mech_suit)

/obj/item/clothing/under/costume/russian_officer
	name = "\improper 俄罗斯军官制服"
	desc = "最新的俄罗斯时尚服装。"
	icon = 'icons/obj/clothing/under/security.dmi'
	icon_state = "hostanclothes"
	inhand_icon_state = null
	worn_icon = 'icons/mob/clothing/under/security.dmi'
	alt_covers_chest = TRUE
	armor_type = /datum/armor/clothing_under/costume_russian_officer
	strip_delay = 5 SECONDS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	can_adjust = FALSE

/datum/armor/clothing_under/costume_russian_officer
	melee = 10
	fire = 30
	acid = 30

/obj/item/clothing/under/costume/buttondown
	gender = PLURAL
	female_sprite_flags = NO_FEMALE_UNIFORM
	custom_price = PAYCHECK_CREW
	icon = 'icons/obj/clothing/under/shorts_pants_shirts.dmi'
	worn_icon = 'icons/mob/clothing/under/shorts_pants_shirts.dmi'
	species_exception = list(/datum/species/golem)
	can_adjust = TRUE
	alt_covers_chest = TRUE
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/under/costume/buttondown/slacks
	name = "纽扣衬衫配西裤"
	desc = "一件精致的纽扣衬衫配西裤。"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/buttondown/slacks"
	post_init_icon_state = "buttondown_slacks"
	greyscale_config = /datum/greyscale_config/buttondown_slacks
	greyscale_config_worn = /datum/greyscale_config/buttondown_slacks/worn
	greyscale_config_worn_digi = /datum/greyscale_config/buttondown_slacks/worn/digi //NOVA EDIT ADDITION - Mutant Greyscale
	greyscale_colors = "#EEEEEE#EE8E2E#222227#D8D39C"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/buttondown/slacks/service //preset one to be a formal white shirt and black pants
	icon_state = "/obj/item/clothing/under/costume/buttondown/slacks/service"
	greyscale_colors = "#EEEEEE#CBDBFC#17171B#222227"

/obj/item/clothing/under/costume/buttondown/shorts
	name = "纽扣衬衫配短裤"
	desc = "一件精致的纽扣衬衫配短裤。"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/buttondown/shorts"
	post_init_icon_state = "buttondown_shorts"
	greyscale_config = /datum/greyscale_config/buttondown_shorts
	greyscale_config_worn = /datum/greyscale_config/buttondown_shorts/worn
	greyscale_config_worn_digi = /datum/greyscale_config/buttondown_shorts/worn/digi //NOVA EDIT ADDITION - Mutant Greyscale
	greyscale_colors = "#EEEEEE#EE8E2E#222227#D8D39C"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/buttondown/skirt
	name = "纽扣衬衫配短裙"
	desc = "一件精致的纽扣衬衫配短裙。"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/buttondown/skirt"
	post_init_icon_state = "buttondown_skirt"
	greyscale_config = /datum/greyscale_config/buttondown_skirt
	greyscale_config_worn = /datum/greyscale_config/buttondown_skirt/worn
	greyscale_colors = "#EEEEEE#EE8E2E#222227#D8D39C"
	body_parts_covered = CHEST|GROIN|ARMS
	flags_1 = IS_PLAYER_COLORABLE_1
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/costume/buttondown/skirt/service //preset one to be a formal white shirt and black skirt
	icon_state = "/obj/item/clothing/under/costume/buttondown/skirt/service"
	greyscale_colors = "#EEEEEE#CBDBFC#17171B#222227"

/obj/item/clothing/under/costume/jackbros
	name = "迪克兄弟服装"
	desc = "是时候去CCB了。"
	icon_state = "JackFrostUniform"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/deckers
	name = "德克尔服"
	icon_state = "decker_jumpsuit"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/football_suit
	name = "足球服"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/football_suit"
	post_init_icon_state = "football_suit"
	can_adjust = FALSE
	greyscale_config = /datum/greyscale_config/football_suit
	greyscale_config_worn = /datum/greyscale_config/football_suit/worn
	greyscale_config_worn_digi = /datum/greyscale_config/football_suit/worn/digi //NOVA EDIT ADDITION - Mutant Greyscale
	greyscale_colors = "#D74722"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/costume/swagoutfit
	name = "斯瓦格服"
	desc = "为什么不准备去泡几个妞呢？"
	icon_state = "SwagOutfit"
	inhand_icon_state = null
	can_adjust = FALSE
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/under/costume/referee
	name = "裁判制服"
	desc = "标准的黑白条纹制服，代表权威。"
	icon_state = "referee"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/joker
	name = "戏剧演员服装"
	desc = "患有精神疾病最让人难受的部分就是人们总是期望你表现得像没有精神疾病一样。"
	icon_state = "joker"
	can_adjust = FALSE

/obj/item/clothing/under/costume/yuri
	name = "尤里新兵连身衣"
	icon_state = "yuri_uniform"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/dutch
	name = "荷兰人服"
	desc = "你可以感觉到一个<b>该死的计划</b>即将到来。"
	icon_state = "DutchUniform"
	inhand_icon_state = null
	can_adjust = FALSE

// For the nuke-ops cowboy fit. Sadly no Lone Ranger fit & I don't wanna bloat costume files further.
/obj/item/clothing/under/costume/dutch/syndicate
	desc = "你能感觉到一个<b>该死的计划</b>正在酝酿，而这套西装里的装甲衬里会让它顺利实施。"
	armor_type = /datum/armor/clothing_under/syndicate

/obj/item/clothing/under/costume/osi
	name = "O.S.I.连身衣"
	icon_state = "osi_jumpsuit"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/tmc
	name = "迷失M.C服"
	icon_state = "tmc_jumpsuit"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/costume/gi
	name = "武道服"
	desc = "助理也好，核弹客也罢。你能打败任何人；这叫努力！"
	icon = 'icons/map_icons/clothing/under/costume.dmi'
	icon_state = "/obj/item/clothing/under/costume/gi"
	post_init_icon_state = "martial_arts_gi"
	greyscale_config = /datum/greyscale_config/gi
	greyscale_config_worn = /datum/greyscale_config/gi/worn
	greyscale_colors = "#f1eeee#000000"
	flags_1 = IS_PLAYER_COLORABLE_1
	inhand_icon_state = null
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/under/costume/gi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/gags_recolorable)
	update_icon(UPDATE_OVERLAYS)

/obj/item/clothing/under/costume/gi/goku
	name = "神圣武道服"
	desc = "由一位触动了许多人心灵和生活的人所创造。"
	icon_state = "/obj/item/clothing/under/costume/gi/goku"
	post_init_icon_state = "martial_arts_gi_goku"
	greyscale_colors = "#f89925#3e6dd7"

/obj/item/clothing/under/costume/traditional
	name = "传统服饰"
	desc = "一套色彩鲜艳的完整服饰。很可能具有传统用途。也许这些颜色代表着一个家族、氏族或等级，谁知道呢。"
	icon_state = "tradition"
	inhand_icon_state = null
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/costume/loincloth
	name = "皮革缠腰布"
	desc = "只是一块用来遮盖私处的皮革。摸起来很痒。制作它的人一定很绝望，或者很野蛮。"
	icon_state = "loincloth"
	inhand_icon_state = null
	body_parts_covered = GROIN
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/costume/henchmen
	name = "跟班连体服"
	desc = "一件给合格跟班穿的非常花哨的连体服。公会规定，你懂的。"
	icon = 'icons/obj/clothing/under/syndicate.dmi'
	worn_icon = 'icons/mob/clothing/under/syndicate.dmi'
	icon_state = "henchmen"
	inhand_icon_state = null
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEEARS|HIDEEYES|HIDEHAIR

/obj/item/clothing/under/costume/gamberson
	name = "重演者的软甲"
	desc = "一套色彩鲜艳、看起来像中世纪软甲的衣服。"
	icon_state = "gamberson"
	inhand_icon_state = null
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/costume/gamberson/military
	name = "剑士软甲"
	desc = "一件加厚的中世纪软甲。有足够的羊毛层来削弱任何小型武器的打击。"
	armor_type = /datum/armor/clothing_under/rank_security
	has_sensor = NO_SENSORS

/obj/item/clothing/under/costume/captain
	name = "船长制服"
	desc = "一套绿色西装和黄色领带。彰显权威。"
	icon_state = "green_suit"
	inhand_icon_state = "dg_suit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/captain/skirt
	name = "绿色西装裙"
	desc = "一件绿色西装裙和黄色领带。彰显权威。"
	icon_state = "green_suit_skirt"
	inhand_icon_state = "dg_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/costume/head_of_personnel
	name = "人事主管制服"
	desc = "一套青色西装和黄色领带。一套权威但俗气的装束。"
	icon_state = "teal_suit"
	inhand_icon_state = "g_suit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/head_of_personnel/skirt
	name = "青色西装裙"
	desc = "一件青色西装裙和黄色领带。一套权威但俗气的装束。"
	icon_state = "teal_suit_skirt"
	inhand_icon_state = "g_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
