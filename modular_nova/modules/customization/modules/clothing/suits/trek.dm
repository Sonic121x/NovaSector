//Trek Jacket(s?)
/obj/item/clothing/suit/fedcoat
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	name = "联邦制服夹克"
	desc = "来自联合联邦的制服夹克。将相位器调到超棒档。"
	icon_state = "fedcoat"
	inhand_icon_state = "coatsecurity"
	allowed = list(
				/obj/item/tank/internals/emergency_oxygen,
				/obj/item/flashlight,
				/obj/item/analyzer,
				/obj/item/radio,
				/obj/item/gun,
				/obj/item/melee/baton,
				/obj/item/restraints/handcuffs,
				/obj/item/reagent_containers/hypospray,
				/obj/item/hypospray,
				/obj/item/healthanalyzer,
				/obj/item/reagent_containers/syringe,
				/obj/item/reagent_containers/cup/vial,
				/obj/item/reagent_containers/cup/beaker,
				/obj/item/storage/pill_bottle,
				/obj/item/taperecorder)
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	body_parts_covered = CHEST|GROIN|ARMS
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/fedcoat/medsci
	icon_state = "fedblue"
	inhand_icon_state = "coatmedical"

/obj/item/clothing/suit/fedcoat/eng
	icon_state = "fedeng"
	inhand_icon_state = "coatengineer"

/obj/item/clothing/suit/fedcoat/capt
	icon_state = "fedcapt"
	inhand_icon_state = "coatcaptain"

//fedcoat but modern
/obj/item/clothing/suit/fedcoat/modern
	name = "现代联邦制服夹克"
	desc = "一件来自联合联邦的现代制服夹克。"
	icon_state = "fedmodern"
	inhand_icon_state = "coatsecurity"

/obj/item/clothing/suit/fedcoat/modern/medsci
	name = "现代医学科联邦夹克"
	icon_state = "fedmodernblue"
	inhand_icon_state = "coatmedical"

/obj/item/clothing/suit/fedcoat/modern/eng
	name = "现代工程联邦夹克"
	icon_state = "fedmoderneng"
	inhand_icon_state = "coatengineer"

/obj/item/clothing/suit/fedcoat/modern/sec
	name = "现代安保联邦夹克"
	icon_state = "fedmodernsec"
	inhand_icon_state = "coatcaptain"
