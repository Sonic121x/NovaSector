/obj/item/shield/energy/returning
	name = "回旋能量盾"
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
	. += span_info("它有一个螺旋桨，使其在激活状态下被投掷后，只要在空中未被抓住，就能返回使用者手中。")

/obj/item/shield/energy/returning/blueshield
	name = "蓝盾能量盾"

/obj/item/shield/energy/returning/blueshield/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)
