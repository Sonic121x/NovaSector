/obj/item/syndie_glue
	name = "bottle of super glue"
	desc = "A black market brand of high strength adhesive, rarely sold to the public. Do not ingest."
	icon = 'modular_nova/master_files/icons/obj/tools.dmi'
	icon_state	= "glue"
	w_class = WEIGHT_CLASS_SMALL
	var/uses = 1


/obj/item/syndie_glue/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!uses)
		to_chat(user, span_warning(LANG("obj.1191ef7773f2c343", null)))
		return NONE
	if(!isitem(interacting_with))
		return NONE
	if(HAS_TRAIT_FROM(interacting_with, TRAIT_NODROP, TRAIT_GLUED_ITEM))
		to_chat(user, span_warning(LANG("obj.37e74b89b4addcec", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING

	uses -= 1
	ADD_TRAIT(interacting_with, TRAIT_NODROP, TRAIT_GLUED_ITEM)
	interacting_with.desc += " It looks sticky."
	to_chat(user, span_notice(LANG("obj.5296d31a471cd8d5", list(interacting_with))))
	if(uses == 0)
		icon_state = "glue_used"
		name = "empty bottle of super glue"
	return ITEM_INTERACT_SUCCESS
