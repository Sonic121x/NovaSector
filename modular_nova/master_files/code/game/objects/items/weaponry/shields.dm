/obj/item/shield/energy/returning
	name = "returning energy shield"
	active_throwforce = 27 // exactly 5 hits to kill.
	reflection_probability  =  0 // no reflects.

/obj/item/shield/energy/returning/on_transform(obj/item/source, mob/user, active)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		AddComponent(/datum/component/boomerang, throw_range+2, TRUE)
	else
		qdel(GetComponent(/datum/component/boomerang))

/obj/item/shield/energy/returning/examine(mob/user)
	. = ..()
	. += span_info(LANG("obj.dfa0935c5960e240", null))

/obj/item/shield/energy/returning/blueshield
	name = "blueshield energy shield"

/obj/item/shield/energy/returning/blueshield/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)
