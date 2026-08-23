/obj/item/clothing/neck/necklace/translator/hearthkin
	name = "antique necklace"
	desc = "A necklace with a old, strange device as its pendant. Symbols \
		constantly seem to appear on its screen, as noises happen around it, \
		but its purpose is not immediately apparent."
	icon = 'modular_nova/modules/primitive_catgirls/icons/translator.dmi'
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/translator_worn.dmi'
	icon_state = "translator"
	language_granted = /datum/language/siiktajr


/obj/item/clothing/neck/necklace/translator/hearthkin/equip_feedback(mob/living/carbon/human/equipper)
	to_chat(equipper, span_notice( \
		LANG("obj.30c9ac8d1c78406e", list(initial(language_granted.name), initial(language_granted.name))) \
	))


/obj/item/clothing/neck/necklace/translator/hearthkin/unequip_feedback(mob/living/carbon/human/unequipper)
	to_chat(unequipper, span_boldnotice( \
		LANG("obj.d8978b52fad43199", list(src, initial(language_granted.name))) \
	))
