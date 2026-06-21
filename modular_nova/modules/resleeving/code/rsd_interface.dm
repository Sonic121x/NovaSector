/obj/item/rsd_interface
	name = "RSD 魂器"
	desc = "一种通常插入惰性大脑的小型设备。由于共振无法在所谓的“真空”中持续存在，RSD——类似于它们模拟的大脑和 CPU——利用大脑白噪声作为基础，使共振能够在原本死寂的容器中持续存在。"
	icon = 'modular_nova/modules/aesthetics/implanter/icons/implanter.dmi'
	icon_state = "implanter1"
	inhand_icon_state = "syringe_0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/// Attempts to use the item on the target brain.
/obj/item/rsd_interface/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /obj/item/organ/brain))
		return NONE

	if(HAS_TRAIT(interacting_with, TRAIT_RSD_COMPATIBLE))
		user.balloon_alert(user, "已经升级过了！")
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] 用 [src] 升级了 [interacting_with]。"), span_notice("你将[interacting_with]升级为RSD兼容。"))
	interacting_with.AddElement(/datum/element/rsd_interface)
	playsound(interacting_with.loc, 'sound/items/weapons/circsawhit.ogg', 50, vary = TRUE)

	qdel(src)
	return ITEM_INTERACT_SUCCESS

/datum/element/rsd_interface/Attach(datum/target)
	. = ..()
	if(!istype(target, /obj/item/organ/brain))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	ADD_TRAIT(target, TRAIT_RSD_COMPATIBLE, INNATE_TRAIT)

/// Adds text to the examine text of the parent item, explaining that the item can be used to enable the use of NIFSoft HUDs
/datum/element/rsd_interface/proc/on_examine(datum/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	examine_text += span_cyan_nova("灵魂可以转移到[source]，前提是它是惰性的。")

/datum/element/rsd_interface/Detach(datum/target)
	UnregisterSignal(target, COMSIG_ATOM_EXAMINE)
	REMOVE_TRAIT(target, TRAIT_RSD_COMPATIBLE, INNATE_TRAIT)

	return ..()

