/obj/machinery/button/door/indestructible/blackmarket_trader
	name = "停滞护盾控制器"
	desc = "用于关闭环绕你环境的长期停滞场的按钮。"
	id = "bmt_control"

/obj/machinery/button/door/indestructible/blackmarket_trader/Initialize(mapload, ndir, built)
	. = ..()

/obj/machinery/button/door/indestructible/blackmarket_trader/screwdriver_act()
	return

/obj/machinery/button/door/indestructible/blackmarket_trader/crowbar_act()
	return

/obj/machinery/button/door/indestructible/blackmarket_trader/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	return

/obj/machinery/button/door/indestructible/blackmarket_trader/emag_act()
	return

/obj/machinery/button/door/indestructible/blackmarket_trader/attack_hand()
	. = ..()
	if(.)
		return
	qdel(src)

/obj/machinery/door/poddoor/blackmarket_trader
	name = "停滞护盾"
	desc = "能把那些讨厌的拾荒者挡在外面，但也让你出不去！"
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "dimensional_overlay"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/blackmarket_trader/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/machinery/door/poddoor/blackmarket_trader/screwdriver_act()
	return

/obj/machinery/button/door/indestructible/blackmarket_trader/crowbar_act()
	return

/obj/machinery/door/poddoor/blackmarket_trader/welder_act()
	return

/obj/machinery/door/poddoor/blackmarket_trader/open()
	qdel(src)
