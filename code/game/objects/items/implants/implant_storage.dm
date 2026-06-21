/obj/item/implant/storage
	name = "存储植入体"
	desc = "在蓝空间口袋中最多存储两件大型物品。"
	icon_state = "storage"
	implant_color = "r"
	var/max_slot_stacking = 4

/obj/item/implant/storage/activate()
	. = ..()
	atom_storage?.open_storage(imp_in)

/obj/item/implant/storage/removed(source, silent = FALSE, special = FALSE)
	if(special)
		return ..()

	var/mob/living/implantee = source
	for (var/obj/item/stored in contents)
		stored.add_mob_blood(implantee)
	atom_storage.remove_all()
	implantee.visible_message(span_warning("当[src]离开[implantee]时，一个蓝空间口袋在其周围打开，喷出其中的内容物并撕裂周围组织！"))
	implantee.apply_damage(20, BRUTE, BODY_ZONE_CHEST)
	QDEL_NULL(atom_storage)
	return ..()

/obj/item/implant/storage/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	for(var/X in target.implants)
		if(istype(X, type))
			var/obj/item/implant/storage/imp_e = X
			if(!imp_e.atom_storage)
				imp_e.create_storage(storage_type = /datum/storage/implant)
				qdel(src)
				return TRUE
			else if(imp_e.atom_storage.max_slots < max_slot_stacking)
				imp_e.atom_storage.max_slots += initial(imp_e.atom_storage.max_slots)
				imp_e.atom_storage.max_total_storage += initial(imp_e.atom_storage.max_total_storage)
				return TRUE
			return FALSE
	create_storage(storage_type = /datum/storage/implant)
	ADD_TRAIT(src, TRAIT_CONTRABAND_BLOCKER, INNATE_TRAIT)
	return ..()

/obj/item/implanter/storage
	name = "植入器" // NOVA EDIT , original was implanter (storage)
	imp_type = /obj/item/implant/storage
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // NOVA EDIT
	special_desc = "A Syndicate implanter used for a storage implant" // NOVA EDIT
