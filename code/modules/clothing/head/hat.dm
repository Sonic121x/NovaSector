/obj/item/clothing/head/hats
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	abstract_type = /obj/item/clothing/head/hats

/obj/item/clothing/head/hats/centhat
	name = "\improper 中央指挥帽"
	icon_state = "centcom"
	desc = "当皇帝真好。"
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_centhat
	strip_delay = 8 SECONDS

/datum/armor/hats_centhat
	melee = 30
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/costume/constable
	name = "警员头盔"
	desc = "一顶看起来像英式的头盔。"
	icon_state = "constable"
	inhand_icon_state = null
	custom_price = PAYCHECK_COMMAND * 1.5
	worn_y_offset = 4
	armor_type = /datum/armor/head_helmet
	hair_mask = /datum/hair_mask/standard_hat_middle

/obj/item/clothing/head/costume/spacepolice
	name = "太空警察帽"
	desc = "一顶用于日常巡逻的蓝色帽子。"
	icon_state = "policecap_families"
	inhand_icon_state = null

/obj/item/clothing/head/costume/canada
	name = "条纹红色高顶帽"
	desc = "闻起来像新鲜的甜甜圈球。 / <i>闻起来像新鲜的甜甜圈。</i>"
	icon_state = "canada"
	inhand_icon_state = null

/obj/item/clothing/head/costume/redcoat
	name = "英国军帽"
	icon_state = "redcoat"
	desc = "<i>'我猜这是个红发人。'</i>"

/obj/item/clothing/head/costume/mailman
	name = "邮差帽"
	icon_state = "mailman"
	desc = "<i>'准时送达'</i> 邮政服务头饰。"
	clothing_traits = list(TRAIT_HATED_BY_DOGS)
	custom_premium_price = PAYCHECK_CREW

/obj/item/clothing/head/bio_hood/plague
	name = "瘟疫医生帽"
	desc = "这曾是瘟疫医生使用的帽子。这顶帽子只能为你提供轻微的防护，避免暴露于瘟疫。"
	icon_state = "plaguedoctor"
	armor_type = /datum/armor/bio_hood_plague
	flags_inv = HIDEHAIR|HIDEEARS
	clothing_flags = SNUG_FIT
	flags_cover = NONE
	dirt_state = null
	alternate_worn_layer = HAIR_LAYER

/datum/armor/bio_hood_plague
	bio = 100

/obj/item/clothing/head/costume/nursehat
	name = "护士帽"
	desc = "该物品可快速识别受过专业训练的医疗人员。"
	icon_state = "nursehat"
	dog_fashion = /datum/dog_fashion/head/nurse

/obj/item/clothing/head/hats/bowler
	name = "圆顶礼帽"
	desc = "先生们，精英登船！"
	icon_state = "bowler"
	inhand_icon_state = null

/obj/item/clothing/head/costume/bearpelt
	name = "熊皮帽"
	desc = "毛绒绒的。"
	icon_state = "bearpelt"
	inhand_icon_state = null

/obj/item/clothing/head/costume/bearpelt/equipped(mob/living/user, slot)
	..()
	if(!ishuman(user) || !(slot & ITEM_SLOT_HEAD))
		return

	var/mob/living/carbon/human/human_user = user
	var/obj/item/clothing/suit/costume/bear_suit/our_suit = human_user.wear_suit
	if(!our_suit || !istype(our_suit))
		return

	our_suit.make_friendly(user, src)

/obj/item/clothing/head/flatcap
	name = "鸭舌帽"
	desc = "属于工人阶级的帽子。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/flatcap"
	post_init_icon_state = "beret_flat"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#8F7654"
	inhand_icon_state = null

/obj/item/clothing/head/cowboy
	name = "牛仔帽"
	desc = "在我的镇上没人能骗过刽子手。"
	icon = 'icons/obj/clothing/head/cowboy.dmi'
	worn_icon = 'icons/mob/clothing/head/cowboy.dmi'
	icon_state = "cowboy_hat_brown"
	worn_icon_state = "hunter"
	inhand_icon_state = null
	armor_type = /datum/armor/head_cowboy
	resistance_flags = FIRE_PROOF | ACID_PROOF
	/// Chance that the hat will catch a bullet for you
	var/deflect_chance = 2

/obj/item/clothing/head/cowboy/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/bullet_intercepting,\
		block_chance = deflect_chance,\
		active_slots = ITEM_SLOT_HEAD,\
		on_intercepted = CALLBACK(src, PROC_REF(on_intercepted_bullet)),\
	)

/// When we catch a bullet, fling away
/obj/item/clothing/head/cowboy/proc/on_intercepted_bullet(mob/living/victim, obj/projectile/bullet)
	victim.visible_message(span_warning("\The [bullet] 把 [victim] 的帽子打飞了！"))
	victim.dropItemToGround(src, force = TRUE, silent = TRUE)
	throw_at(get_edge_target_turf(loc, pick(GLOB.alldirs)), range = 3, speed = 3)
	playsound(victim, SFX_RICOCHET, 100, TRUE)

/datum/armor/head_cowboy
	melee = 5
	bullet = 5
	laser = 5
	energy = 15

/// Bounty hunter's hat, very likely to intercept bullets
/obj/item/clothing/head/cowboy/bounty
	name = "赏金猎人帽"
	desc = "飞向天空，搭档。"
	icon_state = "bounty_hunter"
	worn_icon_state = "hunter"
	deflect_chance = 50

/obj/item/clothing/head/cowboy/black
	name = "亡命之徒帽"
	desc = "脖子上套着绳子的人并不总是会被绞死。"
	icon_state = "cowboy_hat_black"
	worn_icon_state = "cowboy_hat_black"
	inhand_icon_state = "cowboy_hat_black"

/// More likely to intercept bullets, since you're likely to not be wearing your modsuit with this on
/obj/item/clothing/head/cowboy/black/syndicate
	deflect_chance = 25

/obj/item/clothing/head/cowboy/white
	name = "宽边高顶帽"
	desc = "世界上有两种人：持枪的人和挖土的人。你是挖土的吗？"
	icon_state = "cowboy_hat_white"
	worn_icon_state = "cowboy_hat_white"
	inhand_icon_state = "cowboy_hat_white"

/obj/item/clothing/head/cowboy/grey
	name = "流浪汉的帽子"
	desc = "给一个没有名字的助手戴的帽子。"
	icon_state = "cowboy_hat_grey"
	worn_icon_state = "cowboy_hat_grey"
	inhand_icon_state = "cowboy_hat_grey"

/obj/item/clothing/head/cowboy/red
	name = "副警长帽"
	desc = "不要让艳丽的颜色欺骗了你。这顶帽子见过很多可怕的事。"
	icon_state = "cowboy_hat_red"
	worn_icon_state = "cowboy_hat_red"
	inhand_icon_state = "cowboy_hat_red"

/obj/item/clothing/head/cowboy/brown
	name = "警长帽"
	desc = "飞向天空，搭档。"
	icon_state = "cowboy_hat_brown"
	worn_icon_state = "cowboy_hat_brown"
	inhand_icon_state = "cowboy_hat_brown"

/obj/item/clothing/head/costume/santa
	name = "圣诞帽"
	desc = "圣诞节的时候，我的老板送给我的！"
	icon_state = "santahatnorm"
	inhand_icon_state = "that"
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	dog_fashion = /datum/dog_fashion/head/santa

/obj/item/clothing/head/costume/santa/gags
	name = "圣诞帽"
	desc = "圣诞节的时候，我的老板送给我的！"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/santa/gags"
	post_init_icon_state = "santa_hat"
	greyscale_config = /datum/greyscale_config/santa_hat
	greyscale_config_worn = /datum/greyscale_config/santa_hat/worn
	greyscale_colors = "#cc0000#f8f8f8"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/jester
	name = "弄臣帽"
	desc = "一顶带铃铛的帽子，给这身衣服增添几分欢快的气氛。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/jester"
	post_init_icon_state = "jester_map"
	greyscale_config = /datum/greyscale_config/jester_hat
	greyscale_config_worn = /datum/greyscale_config/jester_hat/worn
	greyscale_colors = "#00ff00#ff0000"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/jesteralt
	name = "弄臣帽"
	desc = "一顶带铃铛的帽子，给这身衣服增添几分欢快的气氛。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/jesteralt"
	post_init_icon_state = "jester_alt"
	greyscale_config = /datum/greyscale_config/jester_hat_alt
	greyscale_config_worn = /datum/greyscale_config/jester_hat_alt/worn
	greyscale_colors = "#E10000#E1E100"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/rice_hat
	name = "大米帽"
	desc = "欢迎来稻田，混蛋。"
	icon_state = "rice_hat"
	base_icon_state = "rice_hat"
	var/reversed = FALSE

/obj/item/clothing/head/costume/rice_hat/click_alt(mob/user)
	reversed = !reversed
	worn_icon_state = "[base_icon_state][reversed ? "_kim" : ""]"
	to_chat(user, span_notice("你[reversed ? "lower" : "raise"]了帽子。"))
	update_appearance()

/obj/item/clothing/head/costume/lizard
	name = "蜥蜴皮钟形帽"
	desc = "为了做这顶帽子，一共有多少只蜥蜴丟了性命呢？可这还不够。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/lizard"
	post_init_icon_state = "lizard_hat"
	greyscale_config = /datum/greyscale_config/lizard_hat
	greyscale_config_worn = /datum/greyscale_config/lizard_hat/worn
	greyscale_colors = "#859333"

/obj/item/clothing/head/costume/lizard/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	var/obj/item/stack/sheet/animalhide/carbon/lizard/skin = locate() in components
	if (isnull(skin) || !length(skin.skin_color)) // what
		return ..()
	set_greyscale(skin.skin_color)
	return ..()

/obj/item/clothing/head/costume/scarecrow_hat
	name = "稻草人帽"
	desc = "一顶简单的稻草帽。"
	icon_state = "scarecrow_hat"

/obj/item/clothing/head/costume/pharaoh
	name = "法老帽"
	desc = "像埃及人一样走路。"
	icon_state = "pharoah_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/nemes
	name = "内梅斯头饰"
	desc = "不包括豪华太空金字塔。"
	icon_state = "nemes_headdress"

/obj/item/clothing/head/costume/delinquent
	name = "承太郎帽"
	desc = "呀嘞呀嘞达贼。"
	icon_state = "delinquent"

/obj/item/clothing/head/hats/intern
	name = "\improper 中央指挥部实习主管帽"
	desc = "一顶用中央指挥部绿色织成的、豆豆帽与软帽的可怕混合体。你得是多么渴望能压同僚一头，才会同意戴上这个东西。"
	icon_state = "intern_hat"
	inhand_icon_state = null

/obj/item/clothing/head/hats/coordinator
	name = "舰长军帽"
	desc = "派对协调员的帽子，时髦！"
	icon_state = "capcap"
	inhand_icon_state = "that"
	armor_type = /datum/armor/hats_coordinator

/datum/armor/hats_coordinator
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/costume/jackbros
	name = "霜冻帽"
	desc = "嘿——吼！"
	icon_state = "JackFrostHat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/weddingveil
	name = "婚礼头纱"
	desc = "轻薄的白色头纱。"
	icon_state = "weddingveil"
	inhand_icon_state = null

/obj/item/clothing/head/hats/centcom_cap
	name = "\improper CentCom指挥官帽"
	icon_state = "centcom_cap"
	desc = "由最优秀的中央司令部指挥官佩戴。帽子的衬里有两个模糊的首字母。"
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_centcom_cap
	strip_delay = 8 SECONDS

/datum/armor/hats_centcom_cap
	melee = 30
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/fedora/human_leather
	name = "人皮帽"
	desc = "这帽子可以震慑住别人。所有人都将见识到我的实力。"
	icon_state = "human_leather"
	inhand_icon_state = null

/obj/item/clothing/head/costume/ushanka
	name = "苏联毛帽"
	desc = "很适合在西伯利亚的冬季戴着它，对吧？"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/ushanka"
	post_init_icon_state = "ushanka_gagdown"
	greyscale_config = /datum/greyscale_config/ushanka
	greyscale_config_worn = /datum/greyscale_config/ushanka/worn
	greyscale_colors = "#C7B08B#5A4E44"
	flags_1 = IS_PLAYER_COLORABLE_1
	inhand_icon_state = null
	flags_inv = HIDEEARS // NOVA EDIT CHANGE - (Original: HIDEEARS|HIDEHAIR)
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	dog_fashion = /datum/dog_fashion/head/ushanka
	var/earflaps = TRUE
	///Sprite visible when the ushanka flaps are folded up.
	var/upsprite = "ushanka_gagup"
	///Sprite visible when the ushanka flaps are folded down.
	var/downsprite = "ushanka_gagdown"

/obj/item/clothing/head/costume/ushanka/attack_self(mob/user)
	if(earflaps)
		icon_state = upsprite
		inhand_icon_state = upsprite
		to_chat(user, span_notice("你抬起了乌山卡帽的耳罩。"))
	else
		icon_state = downsprite
		inhand_icon_state = downsprite
		to_chat(user, span_notice("你放下了乌毡帽的耳罩。"))
	earflaps = !earflaps

/obj/item/clothing/head/costume/ushanka/polar
	name = "猎熊人乌纱帽"
	desc = "由西伯利亚的真北极熊皮手工制作而成。"
	icon_state = "/obj/item/clothing/head/costume/ushanka/polar"
	greyscale_colors = "#FCFCFD#CCCED1"
	flags_1 = null

/obj/item/clothing/head/costume/ushanka/sec
	name = "安保乌纱卡帽"
	icon_state = "/obj/item/clothing/head/costume/ushanka/sec"
	desc = "一顶温暖舒适的乌沙帽，根据标签说明，是用'全天然香料'染色的。"
	greyscale_colors = "#C7B08B#A52F29"
	armor_type = /datum/armor/cosmetic_sec
	flags_1 = null

/obj/item/clothing/head/costume/nightcap
	abstract_type = /obj/item/clothing/head/costume/nightcap

/obj/item/clothing/head/costume/nightcap/blue
	name = "蓝色睡帽"
	desc = "这顶蓝色睡帽适用于所有想做美梦和想好好打个盹的人。"
	icon_state = "sleep_blue"

/obj/item/clothing/head/costume/nightcap/red
	name = "红色睡帽"
	desc = "这顶红色睡帽适用于所有贪睡和想打盹的人。"
	icon_state = "sleep_red"

/obj/item/clothing/head/costume/paper_hat
	name = "纸帽子"
	desc = "一顶用纸做的、摇摇欲坠的帽子。"
	icon_state = "paper"
	worn_icon_state = "paper"
	dog_fashion = /datum/dog_fashion/head
	custom_materials = list(/datum/material/paper = HALF_SHEET_MATERIAL_AMOUNT / 2)

/obj/item/clothing/head/costume/paper_hat/savior
	name = "ancient paper hat"
	desc = "An ancient hat made of paper. \"Savior of the Universe\" is spelled out on the rim in orange marker. "
	icon_state = "paper_savior"
	worn_icon_state = "paper_savior"
