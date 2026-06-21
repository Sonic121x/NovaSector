/obj/item/clothing/under/rank/cargo
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/cargo_digi.dmi'

/obj/item/clothing/under/rank/cargo/tech/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/cargo.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/cargo.dmi'

/obj/item/clothing/under/rank/cargo/qm/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/cargo.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/cargo.dmi'

// Add a /obj/item/clothing/under/rank/cargo/miner/nova if you add miner uniforms

/*
*	CARGO TECH
*/

/obj/item/clothing/under/rank/cargo/tech/nova/utility
	name = "货运实用制服"
	desc = "货运部门员工穿着的实用制服。"
	icon_state = "util_cargo"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/cargo/tech/nova/utility/syndicate
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/cargo/tech/nova/long
	name = "货运技工长款连体服"
	desc = "适合那些宁愿保护双腿也不愿展示它们的板条箱搬运工。"
	icon_state = "cargo_long"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/cargo/tech/nova/gorka
	name = "货运戈尔卡服"
	desc = "货运部门穿着的坚固实用的戈尔卡服。"
	icon_state = "gorka_cargo"
	can_adjust = FALSE

/obj/item/clothing/under/rank/cargo/tech/nova/turtleneck
	name = "货运高领衫"
	desc = "货运部门穿着的舒适高领毛衣。"
	icon_state = "turtleneck_cargo"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/cargo/tech/nova/turtleneck/skirt
	name = "货运裙领衫"
	desc = "货运部门穿着的舒适高领毛衣，这次配了条裙子！"
	icon_state = "skirtleneck"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	gets_cropped_on_taurs = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/rank/cargo/tech/nova/evil
	name = "黑色货运制服"
	desc = "一件标准的货运制服，带有一种更……令人敬畏的格调。"
	icon_state = "qmsynd"
	can_adjust = FALSE

/obj/item/clothing/under/rank/cargo/tech/nova/casualman
	name = "货运技工便服"
	desc = "一条时尚的黑色牛仔裤和一件普通毛衣，适合休闲的技工。"
	icon_state = "cargotechjean"
	can_adjust = FALSE

/*
*	QUARTERMASTER
*/

/obj/item/clothing/under/rank/cargo/qm/nova/gorka
	name = "军需官戈尔卡服"
	desc = "一件结实耐用的戈尔卡制服，带有银色标记。与普通员工的制服不同，这件内衬是丝绸的。"
	icon_state = "gorka_qm"
	can_adjust = FALSE

/obj/item/clothing/under/imperial/quartermaster
	name = "军需官的海军制服"
	desc = "一件来自伟大海军的制服，被可疑地授予了纳米传讯最喜爱的工会代表。"
	icon_state = "/obj/item/clothing/under/imperial/quartermaster"
	greyscale_colors = "#8B4C31#8B4C31#3E3E48#373741#ccced1#DEB63D#DEB63D"
	flags_1 = NONE

/obj/item/clothing/under/imperialskirt/quartermaster
	name = "军需官的海军裙"
	desc = "一件被可疑地授予纳米传讯最爱的工会代表的帝国海军制服。"
	greyscale_colors = "#8B4C31#3E3E48#373741#ccced1#DEB63D#DEB63D"
	icon_state = "/obj/item/clothing/under/imperialskirt/quartermaster"
	flags_1 = NONE

/obj/item/clothing/under/rank/cargo/qm/nova/turtleneck
	name = "军需官的高领衫"
	desc = "一件军需官穿着的紧身高领毛衣，特点是搭配了一条看起来价格不菲的西裤。"
	icon_state = "turtleneck_qm"

/obj/item/clothing/under/rank/cargo/qm/nova/turtleneck/skirt
	name = "军需官的裙领衫"
	desc = "一件军需官穿着的舒适高领毛衣，其丝绸裙摆优雅的双层衬里彰显了这一点。"
	icon_state = "skirtleneckQM"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/cargo/qm/nova/interdyne
	name = "甲板军官连体服"
	desc = "一套带有经典货运背心的深色西装。献给所有纸质事务的终极掌控者。"
	icon_state = "qmsynd"
	has_sensor = NO_SENSORS
	armor_type = /datum/armor/clothing_under/nova_interdyne
	can_adjust = FALSE

/datum/armor/clothing_under/nova_interdyne
	melee = 10
	fire = 50
	acid = 40

/obj/item/clothing/under/rank/cargo/qm/nova/formal
	name = "军需官的正式连体服"
	desc = "一款西部风格、为守旧派仓库主管准备的备用制服。"
	icon_state = "supply_chief"
	can_adjust = FALSE

/obj/item/clothing/under/rank/cargo/qm/nova/formal/skirt
	name = "军需官的正式连身裙"
	desc = "为守旧的仓库主管准备的西部风格备用制服。包含裙子！"
	icon_state = "supply_chief_skirt"
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/cargo/qm/nova/casual
	name = "军需官的便服"
	desc = "一件棕色夹克搭配同色长裤，适合休闲的军需官。"
	icon_state = "qmc"
