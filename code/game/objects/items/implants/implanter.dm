// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * Players can use this item to put obj/item/implant's in living mobs. Can be renamed with a pen.
 */
/obj/item/implanter
	name = "implanter"
	desc = "A sterile automatic implant injector."
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
		target.visible_message(span_warning(LANG("obj.3d57abfb81d3cc30", list(user, target))))
		if(!do_after(user, 5 SECONDS, target))
			return

	if(!(src && imp))
		return

	if(imp.implant(target, user))
		if (target == user)
			to_chat(user, span_notice(LANG("obj.4fb833c45fdd5f86", null)))
		else
			target.visible_message(span_notice(LANG("obj.218aaa2d085d7791", list(user, target))), span_notice(LANG("obj.75824e461caf0bcc", list(user))))
		imp = null
		update_appearance()
	else
		to_chat(user, span_warning(LANG("obj.e7a2d980f0f21830", list(src, target))))

/obj/item/implanter/Initialize(mapload)
	. = ..()
	if(!imp && imp_type)
		imp = new imp_type(src)
	update_appearance()

/obj/item/implanter/nameformat(input, user)
	return "implanter[input?  " ([input])" : null]"
