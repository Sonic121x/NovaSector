/datum/mod_theme/contain
	name = "收容"
	desc = "一套由基金会异常科技为基础制作的战斗太空护具，可以保护使用者在异常的打击下幸存并保持战斗力。"
	extended_desc = "这是一套非常神秘的装具，它的制造组织称自己为SCP基金会，\
		只有机动特遣队才会穿戴这套装备。如果你看到了它，说明此地的异常情况非比寻常。\
		这套暗淡灰蓝的护甲防护性能与结构设计已经远超人类社会所能制造的最好护具的范围，\
		使用者是否能善用这套装备完全取决于他们自己。在大腿内测部位有一行小字:依照命令行事。"
	default_skin = "contain"
	armor_type = /datum/armor/mod_theme_contain
	resistance_flags = FIRE_PROOF|ACID_PROOF
	atom_flags = PREVENT_CONTENTS_EXPLOSION_1
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	complexity_max = DEFAULT_MAX_COMPLEXITY + 15
	hearing_protection = EAR_PROTECTION_NORMAL
	allowed_suit_storage = list(
		/obj/item/melee/baton,
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash,
	)
	variants = list(
		"contain" = list(
			MOD_ICON_OVERRIDE = 'modular_z121/icons/obj/clothing/modsuit/mod_clothing.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_z121/icons/mob/clothing/modsuit/mod_clothing.dmi',
			/obj/item/clothing/head/mod = list(
				UNSEALED_CLOTHING = SNUG_FIT|THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE|HEADINTERNALS,
				UNSEALED_INVISIBILITY = HIDEEARS|HIDEHAIR,
				SEALED_INVISIBILITY = HIDEFACIALHAIR|HIDEMASK|HIDEEYES|HIDEFACE|HIDESNOUT,
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

/datum/armor/mod_theme_contain
	melee = 100
	bullet = 90
	laser = 90
	energy = 50
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
	wound = 50

/obj/item/mod/control/pre_equipped/contain
	theme = /datum/mod_theme/contain
	applied_core = /obj/item/mod/core/infinite
	applied_modules = list(
		/obj/item/mod/module/storage/bluespace,
		/obj/item/mod/module/headprotector,
		/obj/item/mod/module/emp_shield/advanced,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/jetpack/advanced/nored,
		/obj/item/mod/module/magboot/advanced,
		/obj/item/mod/module/dna_lock,
		/obj/item/mod/module/longfall,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/status_readout,
		/obj/item/mod/module/anti_magic,
		/obj/item/mod/module/thermal_regulator,
		/obj/item/mod/module/holster,
		/obj/item/mod/module/shock_absorber,
		/obj/item/mod/module/shove_blocker/locked,
		/obj/item/mod/module/rad_protection,
		/obj/item/mod/module/visor/night,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack/advanced/nored,
	)

/obj/item/mod/module/jetpack/advanced/nored
	overlay_icon_file = 'modular_z121/icons/mob/clothing/modsuit/mod_modules.dmi'
	overlay_state_inactive = "module_jetpackadv"
	overlay_state_active = "module_jetpackadv_on"
