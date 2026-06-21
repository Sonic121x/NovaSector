/*
 * Contains:
 * Security
 * Detective
 * Navy uniforms
 */

/*
 * Security
 */

/obj/item/clothing/under/rank/security
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'
	abstract_type = /obj/item/clothing/under/rank/security
	armor_type = /datum/armor/clothing_under/rank_security
	strip_delay = 5 SECONDS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/clothing_under/rank_security
	melee = 10
	fire = 30
	acid = 30
	wound = 10

/obj/item/clothing/under/rank/security/officer
	name = "安保连身衣"
	desc = "一种为安保设计的战术安全连身衣，配有纳米传讯皮带扣。"
	icon_state = "rsecurity"
	inhand_icon_state = "r_suit"

/obj/item/clothing/under/rank/security/officer/grey
	name = "灰色安保连身衣"
	desc = "这是多年前的遗留的战术装备，当时纳米传讯认为战衣染成红色比清洗血迹要划算的多。"
	icon_state = "security"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/officer/skirt
	name = "安保裙"
	desc = "一种“战术”安全制服，裤子被裙子取代。"
	icon_state = "secskirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/officer/blueshirt
	name = "蓝色衬衫和领带"
	desc = "我现在有点忙，卡尔霍恩。"
	icon_state = "blueshift"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/officer/formal
	name = "安保部长的正装制服"
	desc = "最新款式的安保制服。"
	icon_state = "officerblueclothes"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/constable
	name = "警察制服"
	desc = "一套英伦风格的装束。"
	icon_state = "constable"
	inhand_icon_state = null
	can_adjust = FALSE
	custom_price = PAYCHECK_COMMAND


/obj/item/clothing/under/rank/security/warden
	name = "安保服"
	desc = "一套正式的安保安全套装，配有纳米传讯皮带扣。"
	icon_state = "rwarden"
	inhand_icon_state = "r_suit"

/obj/item/clothing/under/rank/security/warden/grey
	name = "灰色安保服"
	desc = "这是多年前的遗留的正式战术装备，当时纳米传讯认为战衣染成红色比清洗血迹要划算的多。"
	icon_state = "warden"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/warden/skirt
	name = "典狱长套裙"
	desc = "一种正式的安保制服，配有纳米传讯皮带扣。"
	icon_state = "rwarden_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/warden/formal
	desc = "制服上的徽章告诉你表面这件制服是典狱长的。"
	name = "典狱长的正装制服"
	icon_state = "wardenblueclothes"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/*
 * Detective
 */
/obj/item/clothing/under/rank/security/detective
	name = "破旧的西装"
	desc = "穿这个的人是认真的。"
	icon_state = "detective"
	inhand_icon_state = "det"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/skirt
	name = "侦探高管西装裙"
	desc = "Someone who wears this means business."
	icon_state = "detective_skirt"
	inhand_icon_state = "det"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/detective/noir
	name = "黑色西装"
	desc = "一套冷酷的私家侦探深色西装，还系着领带扣。"
	icon_state = "noirdet"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/noir/skirt
	name = "黑白西装裙"
	desc = "一套冷酷的私家侦探深色裙，还系着领带扣。"
	icon_state = "noirdet_skirt"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/security/head_of_security
	name = "安保部长制服"
	desc = "一件安保连身衣，经过特别的装饰，上面印有那些有幸获得“安保部长”职位的姓名标识。"
	icon_state = "rhos"
	inhand_icon_state = "r_suit"
	armor_type = /datum/armor/clothing_under/security_head_of_security
	strip_delay = 6 SECONDS

/datum/armor/clothing_under/security_head_of_security
	melee = 10
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/under/rank/security/head_of_security/skirt
	name = "安保部长裙"
	desc = "一件安保连身裙，经过特别的装饰，上面印有那些有幸获得“安保部长”职位的姓名标识。"
	icon_state = "rhos_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/head_of_security/grey
	name = "安保部长灰色连身衣"
	desc = "有年长之人，也有勇敢之人，但很少有年老亦勇敢之人。"
	icon_state = "hos"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/head_of_security/alt
	name = "安保部长高领毛衣"
	desc = "一件别具风格的安保部长连身衣，配有战术长裤，堪称常规安保连身衣的豪华升级版。"
	icon_state = "hosalt"
	inhand_icon_state = "bl_suit"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	name = "安保部长高领毛衣裙"
	desc = "一件别具风格的安保部长连身裙，配有战术裙装，堪称常规安保连身衣的豪华升级版。"
	icon_state = "hosalt_skirt"
	inhand_icon_state = "bl_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/head_of_security/parade
	name = "安保部长检阅制服"
	desc = "一件安保部长的豪华服装，专门为特殊场合准备。"
	icon_state = "hos_parade_male"
	inhand_icon_state = "r_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/parade/female
	name = "安保部长正装制服"
	desc = "一件女性保安部长的豪华服装，专门为特殊场合准备。"
	icon_state = "hos_parade_fem"
	inhand_icon_state = "r_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/formal
	desc = "这身制服上的徽章告诉你这身制服是安保部长的。"
	name = "安保部长的正装制服"
	icon_state = "hosblueclothes"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/*
 *Spacepol
 */

/obj/item/clothing/under/rank/security/officer/spacepol
	name = "警察制服"
	desc = "不受大公司、行星或海盗控制的空间区域均由太空刑警管辖。"
	icon_state = "spacepol"
	inhand_icon_state = null
	can_adjust = FALSE
	armor_type = /datum/armor/clothing_under/sec_uniform_spacepol

/datum/armor/clothing_under/sec_uniform_spacepol
	fire = 10
	acid = 10
	melee = 10
	wound = 10

/obj/item/clothing/under/rank/prisoner
	name = "监狱连身衣"
	desc = "标准化的纳米特拉森囚犯服装。其服装传感器被卡在“完全开启”位置。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/prisoner"
	post_init_icon_state = "jumpsuit"
	inhand_icon_state = "jumpsuit"
	greyscale_config = /datum/greyscale_config/jumpsuit/prison
	greyscale_config_worn = /datum/greyscale_config/jumpsuit/prison/worn
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit/prison/inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit/prison/inhand_right
	greyscale_colors = "#ff8300"
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/prisoner/nosensor
	desc = "标准化的纳米特拉森囚犯服装。其服装传感器被卡在“关闭”位置。"
	has_sensor = NO_SENSORS
	sensor_mode = SENSOR_OFF
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/under/rank/prisoner/skirt
	name = "监狱连身裙"
	desc = "标准化的纳米特拉森囚犯服装。其服装传感器被卡在“完全开启”位置。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/prisoner/skirt"
	post_init_icon_state = "jumpskirt"
	greyscale_config = /datum/greyscale_config/jumpsuit/prison
	greyscale_config_worn = /datum/greyscale_config/jumpsuit/prison/worn
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit/prison/inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit/prison/inhand_right
	greyscale_colors = "#ff8300"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/officer/beatcop
	name = "太空警察制服"
	desc = "一种经常在甜甜圈店排队的警察制服。"
	icon_state = "spacepolice_families"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/detective/disco
	name = "超级警察制服"
	desc = "喇叭裤和脏衬衫，在有人这件衣服腋窝撒尿之前可能会很有格调。这是一件超级明星的衣服"
	icon_state = "jamrock_suit"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/detective/kim
	name = "航空轰炸手西装"
	desc = "一套剪裁合身，整洁笔挺的西装;既显得专业又十分舒适，而且颇具权威感。"
	icon_state = "aerostatic_suit"
	inhand_icon_state = null
	can_adjust = FALSE
