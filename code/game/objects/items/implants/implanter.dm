/**
 * Players can use this item to put obj/item/implant's in living mobs. Can be renamed with a pen.
 */
/obj/item/implanter
	name = "植入器"
	desc = "一个无菌的自动植入物注射器。"
	icon = 'icons/obj/medical/syringe.dmi' //NOVA EDIT - ICON OVERRIDDEN IN AESTHETICS MODULE
	icon_state = "implanter0"
	inhand_icon_state = "syringe_0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = UNIQUE_RENAME | RENAME_NO_DESC
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 6, /datum/material/glass=SMALL_MATERIAL_AMOUNT *2)
	///The implant in our implanter
	var/obj/item/implant/imp = null
	///Type of implant this will spawn as imp upon being spawned
	var/imp_type = null

/obj/item/implanter/update_icon_state()
	icon_state = "implanter[imp ? 1 : 0]"
	return ..()

/obj/item/implanter/attack(mob/living/target, mob/user)
	if(!(istype(target) && user && imp))
		return

	if(target != user)
		target.visible_message(span_warning("[user]正试图给[target]植入植入物。"))
		if(!do_after(user, 5 SECONDS, target))
			return

	if(!(src && imp))
		return

	if(imp.implant(target, user))
		if (target == user)
			to_chat(user, span_notice("你给自己植入了植入物。"))
		else
			target.visible_message(span_notice("[user]给[target]植入了植入物。"), span_notice("[user]给你植入了植入物。"))
		imp = null
		update_appearance()
	else
		to_chat(user, span_warning("[src]未能给[target]植入植入物。"))

/obj/item/implanter/Initialize(mapload)
	. = ..()
	if(!imp && imp_type)
		imp = new imp_type(src)
	update_appearance()

/obj/item/implanter/nameformat(input, user)
	return "implanter[input?  " ([input])" : null]"
