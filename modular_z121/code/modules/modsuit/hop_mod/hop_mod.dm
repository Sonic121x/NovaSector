/datum/mod_theme/hop
	name = "服务"
	desc = "纳诺特拉森与隆尚食品公司合作的娱乐模块服，在投入空间站使用前做了一些改造，以适用于指挥与娱乐行业工作。"
	extended_desc = "在纳米沙滩球取得巨大销售胜利后,纳诺特拉森与中国大型食品企业隆尚食品公司共同研制服务行业模块服,一经发售在中国太空城受到了极大的欢迎。\
	在不同的地区被改装成不同功能的服务模块服,由于它的兼容性优越,可以接入各类服务型部件。在13号空间站被改制成了具有奢侈观赏性和稍显滑稽的外观。"
	default_skin = "service"
	armor_type = /datum/armor/mod_theme_hop
	resistance_flags = FIRE_PROOF|ACID_PROOF
	slowdown_deployed = 0
	variants = list(
		"service" = list(
			MOD_ICON_OVERRIDE = 'modular_z121/icons/obj/clothing/modsuit/mod_clothing.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_z121/icons/mob/clothing/modsuit/mod_clothing.dmi',
			/obj/item/clothing/head/mod = list(
				UNSEALED_LAYER = NECK_LAYER,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE|HEADINTERNALS,
				UNSEALED_INVISIBILITY = HIDEFACIALHAIR,
				SEALED_INVISIBILITY = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
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

/datum/armor/mod_theme_hop
	melee = 10
	bullet = 10
	laser = 10
	energy = 10
	bomb = 10
	bio = 100
	fire = 100
	acid = 100
	wound = 10


/obj/item/mod/control/pre_equipped/hop
	theme = /datum/mod_theme/hop
	applied_cell = /obj/item/stock_parts/power_store/cell/super
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/flashlight,
            /obj/item/mod/module/microwave_beam,
            /obj/item/mod/module/mister/cleaner,
            /obj/item/mod/module/stamp,
            /obj/item/mod/module/paper_dispenser,
            /obj/item/mod/module/magnetic_harness,
            /obj/item/mod/module/fishing_glove,
	)

/obj/structure/closet/secure_closet/hop/PopulateContents()
	. = ..()
	new /obj/item/mod/control/pre_equipped/hop(src)
