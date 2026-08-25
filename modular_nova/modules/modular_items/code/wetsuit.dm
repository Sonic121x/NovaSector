/obj/item/clothing/under/akula_wetsuit/refit
	name = "refitted Shoredress wetsuit"
	desc = "The 'Wetworks'-pattern Shoredress is a long-standing template upon which most Azulean 'wetsuits' are made. \
		This atmospheric exploration suit is a single form-fitting garment, designed to keep wearers comfortable in the harsh environment of dry land; \
		even sometimes worn underneath orbital suits such as MODs. \n\n\
		This variation seems to have been refitted to a more standard body shape."
	worn_icon = 'modular_nova/modules/modular_items/icons/akulasuit.dmi'
	female_sprite_flags = FEMALE_UNIFORM_FULL

/obj/item/clothing/under/akula_wetsuit/refit/Initialize(mapload)
	. = ..()
	qdel(GetComponent(/datum/component/wetsuit))

/obj/item/clothing/under/akula_wetsuit/refit/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.9710c283f64a439b", null))

/obj/item/clothing/under/akula_wetsuit/refit/examine_more(mob/user)
	. = ..()

	. += LANG("obj.faae1958023fca89", null)
