// clean soups
/obj/item/reagent_containers/cup/soup_pot
	/// Whether or not the pot is set to clean other reagents from soups
	var/emulsify_reagents

/obj/item/reagent_containers/cup/soup_pot/examine(mob/user)
	. = ..()
	. += LANG("obj.e9e2b2edaaba115f", list(src))

// alt-right click toggles whether soups will get cleaned
/obj/item/reagent_containers/cup/soup_pot/click_alt_secondary(mob/user)
	emulsify_reagents = !emulsify_reagents
	balloon_alert(user, LANG("obj.496c4ab319f603c1", list(emulsify_reagents ? "enabled" : "disabled")))
