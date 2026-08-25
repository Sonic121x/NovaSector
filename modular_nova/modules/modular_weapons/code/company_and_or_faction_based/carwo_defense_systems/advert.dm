/obj/structure/sign/poster/official/carwo_grenade
	name = "Tydhouer - Precision Timing"
	desc = "This poster depicts, alongside the prominent logo of Carwo Defense Systems, a variety of specialist .980 Tydhouer grenades for the Kiboko launcher."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/propaganda.dmi'
	icon_state = "grenadier"

/obj/structure/sign/poster/official/carwo_grenade/examine_more(mob/user)
	. = ..()

	. += LANG("obj.009081542a35602c", null)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/official/carwo_grenade, 32)

/obj/structure/sign/poster/official/carwo_magazine
	name = "Standardisation - Magazines of the Future"
	desc = "This poster depicts, alongside the prominent logo of Carwo Defense Systems, the variety of magazine types the company has on offer for rifles. \
		It also goes into great deal to say, more or less, that any rifle can take any rifle magazine. Now this is technology like never seen before."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/propaganda.dmi'
	icon_state = "mag_size"

/obj/structure/sign/poster/official/carwo_magazine/examine_more(mob/user)
	. = ..()

	. += LANG("obj.99c5fbdc43f1e7a5", null)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/official/carwo_magazine, 32)
