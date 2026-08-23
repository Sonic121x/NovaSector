// The peacekeeper armors and helmets will be less effective at stopping bullet damage than bulletproof vests, but stronger against wounds especially, and some other damage types
/datum/armor/armor_sf_peacekeeper
	melee = ARMOR_LEVEL_WEAK
	bullet = ARMOR_LEVEL_MID
	laser = ARMOR_LEVEL_TINY
	energy = ARMOR_LEVEL_TINY
	bomb = ARMOR_LEVEL_WEAK
	fire = ARMOR_LEVEL_MID
	acid = ARMOR_LEVEL_WEAK
	wound = WOUND_ARMOR_HIGH

/obj/item/clothing/suit/armor/sf_peacekeeper
	name = "'Touvou' peacekeeper armor vest"
	desc = "A bright blue vest, proudly bearing 'SF' in white on its front and back. Dense fabric with a thin layer of rolled metal \
		will protect you from bullets best, a few blunt blows, and the wounds they cause. Lasers will burn more or less straight through it."
	icon = 'modular_nova/modules/specialist_armor/icons/armor.dmi'
	icon_state = "soft_peacekeeper"
	worn_icon = 'modular_nova/modules/specialist_armor/icons/armor_worn.dmi'
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/armor_sf_peacekeeper
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/sf_peacekeeper/examine_more(mob/user)
	. = ..()

	. += LANG("obj.ff790ba9cbc6aee7", null)

	return .

/obj/item/clothing/suit/armor/sf_peacekeeper/debranded
	name = "'Touvou' soft armor vest"
	desc = "A bright white vest, notably missing an 'SF' marking on either its front or back. Dense fabric with a thin layer of rolled metal \
		will protect you from bullets best, a few blunt blows, and the wounds they cause. Lasers will burn more or less straight through it."
	icon_state = "soft_civilian"

/obj/item/clothing/head/helmet/sf_peacekeeper
	name = "'Kastrol' peacekeeper helmet"
	desc = "A large, almost always ill-fitting helmet painted in bright blue. It proudly bears the emblems of SolFed on its sides. \
		It will protect from bullets best, with some protection against blunt blows, but falters easily in the presence of lasers."
	icon = 'modular_nova/modules/specialist_armor/icons/armor.dmi'
	icon_state = "helmet_peacekeeper"
	worn_icon = 'modular_nova/modules/specialist_armor/icons/armor_worn.dmi'
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/armor_sf_peacekeeper
	dog_fashion = null
	flags_inv = null
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/helmet/sf_peacekeeper/examine_more(mob/user)
	. = ..()

	. += LANG("obj.9c96c294a31c6f86", null)

	return .

/obj/item/clothing/head/helmet/sf_peacekeeper/debranded
	name = "'Kastrol' ballistic helmet"
	desc = "A large, almost always ill-fitting helmet painted a dull grey. This one seems to lack any special markings. \
		It will protect from bullets best, with some protection against blunt blows, but falters easily in the presence of lasers."
	icon_state = "helmet_grey"
