/obj/item/clothing/under/rank/rnd
	icon = 'icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'icons/mob/clothing/under/rnd.dmi'
	abstract_type = /obj/item/clothing/under/rank/rnd

/datum/armor/clothing_under/science
	bomb = 10
	bio = 40

/obj/item/clothing/under/rank/rnd/research_director
	desc = "这是那些有能力担任“研究总监”职位的人所穿的西装。它的面料对生物污染物提供了轻微的保护。"
	name = "研究总监的长袖西装"
	icon_state = "director"
	inhand_icon_state = "lb_suit"
	armor_type = /datum/armor/clothing_under/rnd_research_director
	can_adjust = FALSE

/datum/armor/clothing_under/rnd_research_director
	bomb = 10
	bio = 50
	acid = 35

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert
	desc = "已故伟大的希尔伯特博士的研究主管连身衣。由于希尔伯特酒店承受的巨大压力，服装传感器早已失效。"
	has_sensor = NO_SENSORS
	random_sensor = FALSE

/obj/item/clothing/under/rank/rnd/research_director/skirt
	name = "研究总监的长袖连身裙"
	desc = "这是那些有能力担任“研究总监”职位的人所穿的裙子。它的面料对生物污染物提供了轻微的保护。"
	icon_state = "director_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/rnd/research_director/alt
	name = "研究总监的棕褐色西装"
	desc = "说不定哪天你也能造出自己的半人半猪造物。其面料对生物污染物可提供微弱防护。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	worn_icon = 'icons/mob/clothing/under/shorts_pants_shirts.dmi'
	icon_state = "/obj/item/clothing/under/rank/rnd/research_director/alt"
	post_init_icon_state = "buttondown_slacks"
	greyscale_config = /datum/greyscale_config/buttondown_slacks
	greyscale_config_worn = /datum/greyscale_config/buttondown_slacks/worn
	greyscale_colors = "#ffeeb6#c2d3da#402912#615233"
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/research_director/alt/skirt
	name = "研究总监的棕褐色短裙"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/rnd/research_director/alt/skirt"
	post_init_icon_state = "buttondown_skirt"
	greyscale_config = /datum/greyscale_config/buttondown_skirt
	greyscale_config_worn = /datum/greyscale_config/buttondown_skirt/worn
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/rnd/research_director/turtleneck
	desc = "一件纳米特拉森紫色的高领毛衣和黑色牛仔裤，适合一位拥有卓越时尚品味的主任。"
	name = "科研部长高领毛衣"
	icon_state = "rdturtle"
	inhand_icon_state = "p_suit"
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt
	name = "科研部长高领毛衣裙"
	desc = "一件纳米特拉森紫色的高领毛衣和一条黑色短裙，适合一位拥有卓越时尚品味的主任。"
	icon_state = "rdturtle_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/rnd/scientist
	name = "科学家连身衣"
	desc = "它由特殊纤维制成，能提供针对爆炸的基础防护。其特殊标识表明穿戴者是科学家。"
	icon_state = "science"
	inhand_icon_state = "w_suit"
	armor_type = /datum/armor/clothing_under/science

/obj/item/clothing/under/rank/rnd/scientist/skirt
	name = "科学家连身裙"
	icon_state = "science_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/rnd/roboticist
	desc = "这是一件黑色的轻便衣物，缝线已经被加固处理，非常适合其专业工作。"
	name = "机械学家连身衣"
	icon_state = "robotics"
	inhand_icon_state = null
	resistance_flags = NONE

/obj/item/clothing/under/rank/rnd/roboticist/skirt
	name = "机械学家连身裙"
	desc = "It's a slimming black with reinforced seams; great for industrial work."
	icon_state = "robotics_skirt"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/rnd/geneticist
	name = "遗传学家连身衣"
	desc = "该防护服由特殊纤维制成，能提供针对生物危害的特殊防护，并印有基因学家职级条纹。"
	icon_state = "genetics"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/rnd/geneticist/skirt
	name = "遗传学家连身裙"
	icon_state = "genetics_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
