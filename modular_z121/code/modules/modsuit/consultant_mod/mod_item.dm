/datum/mod_theme/consultant
	name = "顾问"
	desc = "由公司模块服改装，旨在为用户提供最舒适体验的模块服。"
	extended_desc = "一个甚至比富豪更昂贵的模块服，这套模块服是隔热的，高级中央司令部军官的防腐蚀涂层服，部署了崭新护甲和高级马达，\
		启动时几乎感受不到重量。改造这个模块服的喷漆在超过五十个纳米空间站是战争罪并且是处决的理由，头盔样式和Gorlex Marauder的相似\
		纯粹是巧合。这是最新的V2版本，其上覆盖着反射性等离子玻璃屏蔽和先进的凯夫拉纤维编织而成。有消息称部分此模块服的装甲直接从虚构模块服\
		上撕下。"
	default_skin = "corporate"
	armor_type = /datum/armor/mod_theme_consultant
	resistance_flags = FIRE_PROOF|ACID_PROOF
	atom_flags = PREVENT_CONTENTS_EXPLOSION_1
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	slowdown_deployed = 0.25
	allowed_suit_storage = list(
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash,
		/obj/item/melee/baton,
	)
	variants = list(
		"corporate" = list(
			/obj/item/clothing/head/mod = list(
				UNSEALED_CLOTHING = SNUG_FIT|THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE|HEADINTERNALS,
				UNSEALED_INVISIBILITY = HIDEFACIALHAIR|HIDEEARS|HIDEHAIR|HIDESNOUT,
				SEALED_INVISIBILITY = HIDEMASK|HIDEEYES|HIDEFACE,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
				UNSEALED_MESSAGE = HELMET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = HELMET_SEAL_MESSAGE,
			),
			/obj/item/clothing/suit/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT,
				UNSEALED_MESSAGE = CHESTPLATE_UNSEAL_MESSAGE,
				SEALED_MESSAGE = CHESTPLATE_SEAL_MESSAGE,
			),
			/obj/item/clothing/gloves/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
				UNSEALED_MESSAGE = GAUNTLET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = GAUNTLET_SEAL_MESSAGE,
			),
			/obj/item/clothing/shoes/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
				UNSEALED_MESSAGE = BOOT_UNSEAL_MESSAGE,
				SEALED_MESSAGE = BOOT_SEAL_MESSAGE,
			),
		),
	)

/datum/armor/mod_theme_consultant
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 30
	bio = 100
	fire = 100
	acid = 100
	wound = 20

/datum/armor/mod_theme_consultant
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 30
	bio = 100
	fire = 100
	acid = 100
	wound = 20

/obj/item/mod/control/pre_equipped/consultant
	theme = /datum/mod_theme/consultant
	applied_cell = /obj/item/stock_parts/power_store/cell/hyper
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/hat_stabilizer,
		/obj/item/mod/module/headprotector,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/megaphone)

/obj/structure/closet/secure_closet/nanotrasen_consultant/PopulateContents()
	. = ..()
	new /obj/item/mod/control/pre_equipped/consultant(src)
