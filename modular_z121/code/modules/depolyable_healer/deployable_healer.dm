//	物品形式
/obj/item/deployable_healer
	name = "一次性应急纳米治疗信标部署器"
	desc = "一次性部署设备, 展开后产生一个持续作用的纳米治疗场. 一经部署就无法再被移动."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "plasticbox"

/obj/item/deployable_healer/attack_self(mob/user, modifiers)
	new /obj/machinery/deployable_healer(user.loc)

	qdel(src)
