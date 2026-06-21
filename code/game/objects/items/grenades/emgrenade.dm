/obj/item/grenade/empgrenade //NOVA EDIT - ICON OVERRIDDEN IN AESTHETICS MODULE
	name = "经典EMP手榴弹"
	desc = "它被设计用来对电子系统造成严重破坏。"
	icon_state = "emp"
	inhand_icon_state = "emp"

/obj/item/grenade/empgrenade/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return
	update_mob()
	empulse(src, 4, 10, emp_source = src)
	qdel(src)
