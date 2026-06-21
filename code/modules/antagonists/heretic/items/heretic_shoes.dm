/obj/item/clothing/shoes/greaves_of_the_prophet
	name = "\improper 关节碎裂胫甲"
	desc = "由粗糙磨损的铁制成的护胫。感觉比它们踏足的地面更加稳固。表面覆盖着一层薄锈——然而，这景象却让你感到奇异的宽慰。"
	icon_state = "hereticgreaves"
	resistance_flags = ACID_PROOF | FIRE_PROOF | LAVA_PROOF

/obj/item/clothing/shoes/greaves_of_the_prophet/Initialize(mapload)
	. = ..()
	attach_clothing_traits(list(TRAIT_NO_SLIP_WATER, TRAIT_NO_SLIP_ICE, TRAIT_NO_SLIP_SLIDE, TRAIT_NO_SLIP_ALL))
