/obj/item/undertile_circuit
	name = "电路面板"
	desc = "一个用于集成电路的面板。需要安装在地板砖下方才能运作。"
	icon = 'icons/obj/science/circuits.dmi'
	inhand_icon_state = "flashtool"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	icon_state = "undertile"

/obj/item/undertile_circuit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE)
	AddComponent(/datum/component/shell, null, SHELL_CAPACITY_SMALL, SHELL_FLAG_REQUIRE_ANCHOR|SHELL_FLAG_USB_PORT)
