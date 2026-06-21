/obj/item/implant/freedom
	name = "自由植入物"
	desc = "用这个来逃离那些邪恶的红衫军。"
	icon_state = "freedom"
	implant_color = "r"
	uses = FREEDOM_IMPLANT_CHARGES

	implant_info = "Activated manually. \
		Unlocks bindings on arms and legs when activated, but not larger ones e.g. straightjackets."

	implant_lore = "The CSMD Freedom Beacon is a hybrid signal transmitter and specialized nanite manufactory \
		designed to defeat handcuffs, legcuffs, and other equivalent arm and leg bindings by both transmitting \
		unlock signals for electrical cuff lock systems and, in the event of failure, generating thin nanite tendrils \
		to nondestructively unsecure relevant bindings. Unfortunately, this only works for bindings on the arms and legs; \
		larger restraints, such as straightjackets are too complex for the nanites to deal with."

/obj/item/implant/freedom/implant(mob/living/target, mob/user, silent, force)
	. = ..()
	if(!.)
		return FALSE
	if(!iscarbon(target)) //This is pretty much useless for anyone else since they can't be cuffed
		balloon_alert(user, "那太浪费了！")
		return FALSE
	return TRUE

/obj/item/implant/freedom/activate()
	. = ..()
	var/mob/living/carbon/carbon_imp_in = imp_in
	if(!can_trigger(carbon_imp_in))
		balloon_alert(carbon_imp_in, "没有束缚！")
		return

	uses--

	carbon_imp_in.uncuff()
	var/obj/item/clothing/shoes/shoes = carbon_imp_in.shoes
	if(istype(shoes) && shoes.tied == SHOES_KNOTTED)
		shoes.adjust_laces(SHOES_TIED, carbon_imp_in)

	if(!uses)
		addtimer(CALLBACK(carbon_imp_in, TYPE_PROC_REF(/atom, balloon_alert), carbon_imp_in, "implant degraded!"), 1 SECONDS)
		qdel(src)
	carbon_imp_in.remove_status_effect(/datum/status_effect/tased) // NOVA EDIT ADDITION - if being tased, removes the status on use, and detaches the electrode. 

/obj/item/implant/freedom/proc/can_trigger(mob/living/carbon/implanted_in)
	if(implanted_in.handcuffed || implanted_in.legcuffed)
		return TRUE

	// NOVA EDIT ADDITION START
	if(implanted_in.has_status_effect(/datum/status_effect/tased))
		return TRUE
	// NOVA EDIT ADDITION END
	var/obj/item/clothing/shoes/shoes = implanted_in.shoes
	if(istype(shoes) && shoes.tied == SHOES_KNOTTED)
		return TRUE

	return FALSE


/obj/item/implanter/freedom
	name = "植入器" // NOVA EDIT , was implanter (freedom)
	imp_type = /obj/item/implant/freedom
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // NOVA EDIT
	special_desc = "A Syndicate implanter used for a freedom implant" // NOVA EDIT

/obj/item/implantcase/freedom
	name = "implant case - 'Freedom'"
	desc = "一个装有自由植入物的玻璃盒。"
	imp_type = /obj/item/implant/freedom
