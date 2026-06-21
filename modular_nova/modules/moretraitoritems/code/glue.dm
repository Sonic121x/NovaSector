/obj/item/syndie_glue
	name = "一瓶强力胶"
	desc = "一种黑市品牌的高强度粘合剂，很少向公众出售。请勿食用。"
	icon = 'modular_nova/master_files/icons/obj/tools.dmi'
	icon_state	= "glue"
	w_class = WEIGHT_CLASS_SMALL
	var/uses = 1


/obj/item/syndie_glue/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!uses)
		to_chat(user, span_warning("胶水瓶空了！"))
		return NONE
	if(!isitem(interacting_with))
		return NONE
	if(HAS_TRAIT_FROM(interacting_with, TRAIT_NODROP, TRAIT_GLUED_ITEM))
		to_chat(user, span_warning("[interacting_with] 已经很粘了！"))
		return ITEM_INTERACT_BLOCKING

	uses -= 1
	ADD_TRAIT(interacting_with, TRAIT_NODROP, TRAIT_GLUED_ITEM)
	interacting_with.desc += " It looks sticky."
	to_chat(user, span_notice("你将 [interacting_with] 涂满了胶水，让它变得异常粘稠！"))
	if(uses == 0)
		icon_state = "glue_used"
		name = "空的强力胶瓶"
	return ITEM_INTERACT_SUCCESS
