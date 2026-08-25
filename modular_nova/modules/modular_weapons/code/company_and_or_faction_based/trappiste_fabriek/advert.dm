/obj/structure/sign/poster/official/trappiste_suppressor
	name = "Keep It Quiet - Ear Protection Unneeded"
	desc = "This poster depicts, alongside the prominent logo of Trappiste Fabriek, a \
		diagram of the average suppressor, and how on most* Trappiste weapons \
		the sound of firing will be low enough to eradicate the need for ear protection. \
		How safety minded, they even have a non-liability statement too."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/propaganda.dmi'
	icon_state = "keep_it_quiet"

/obj/structure/sign/poster/official/trappiste_suppressor/examine_more(mob/user)
	. = ..()

	. += LANG("obj.d05764512ae34865", null)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/official/trappiste_suppressor, 32)

/obj/structure/sign/poster/official/trappiste_ammunition
	name = "Know Your Ammuniton Colors"
	desc = "This poster depicts, alongside the prominent logo of Trappiste Fabriek, \
		a variety of colors that one may find on .585 Trappiste rounds. \
		A plain white case usually means lethal, while a blue stripe is less-lethal \
		and a purple stripe is more lethal. How informative."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/propaganda.dmi'
	icon_state = "know_the_difference"

/obj/structure/sign/poster/official/trappiste_ammunition/examine_more(mob/user)
	. = ..()

	. += LANG("obj.fb70897e6cc22f58", null)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/official/trappiste_ammunition, 32)
