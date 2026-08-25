// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/gun_maintenance_supplies
	name = "gun maintenance kit"
	desc = "A toolbox containing gun maintenance supplies and spare parts. Can be applied to firearms to maintain them."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "maint_kit"
	inhand_icon_state = "ammobox"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	force = 12
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_BULKY
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound = 'sound/items/handling/ammobox_pickup.ogg'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6)
	/// How many times we can use this maintenance kit to maintain a gun
	var/uses = 3
	/// THe maximum uses, used for our examine text.
	var/max_uses = 3

/obj/item/gun_maintenance_supplies/examine(mob/user)
	. = ..()
	. += span_info(LANG("obj.62f679cb65959514", list(uses, max_uses)))

/obj/item/gun_maintenance_supplies/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return ITEM_INTERACT_BLOCKING

	if(!isgun(interacting_with))
		balloon_alert(user, LANG("obj.d5d11148a6dc787c", null))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/gun/gun_to_fix = interacting_with

	var/gun_is_damaged = gun_to_fix.get_integrity() < gun_to_fix.max_integrity
	var/use_charge = FALSE

	if(gun_is_damaged)
		gun_to_fix.repair_damage(gun_to_fix.max_integrity)
		use_charge = TRUE

	if(istype(gun_to_fix, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/ballistic_gun_to_fix = gun_to_fix

		if(ballistic_gun_to_fix.misfire_probability > initial(ballistic_gun_to_fix.misfire_probability))
			ballistic_gun_to_fix.misfire_probability = initial(ballistic_gun_to_fix.misfire_probability)

		if(istype(ballistic_gun_to_fix, /obj/item/gun/ballistic/rifle/boltaction))
			var/obj/item/gun/ballistic/rifle/boltaction/rifle_to_fix = ballistic_gun_to_fix
			if(rifle_to_fix.jammed)
				rifle_to_fix.jammed = FALSE
				rifle_to_fix.unjam_chance = initial(rifle_to_fix.unjam_chance)
				rifle_to_fix.jamming_chance = initial(rifle_to_fix.jamming_chance)
		use_charge = TRUE

	if(!use_charge)
		balloon_alert(user, LANG("obj.cf56643785b9d2ce", null))
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, LANG("obj.5456b6d04881d386", null))
	use_the_kit()
	return ITEM_INTERACT_SUCCESS

/obj/item/gun_maintenance_supplies/proc/use_the_kit()
	uses --
	if(!uses)
		qdel(src)

/obj/item/gun_maintenance_supplies/makeshift
	name = "makeshift gun maintenance kit"
	desc = "A toolbox containing enough supplies to juryrig repairs on firearms. Can be applied to firearms to maintain them. \
		The tools are a little basic, and the materials low-quality, but it gets the job done."
	icon_state = "maint_kit_makeshift"
	inhand_icon_state = "toolbox_blue"
	uses = 1
	max_uses = 1
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6, /datum/material/plastic = SMALL_MATERIAL_AMOUNT)
