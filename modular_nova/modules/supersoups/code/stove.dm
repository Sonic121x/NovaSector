// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
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
