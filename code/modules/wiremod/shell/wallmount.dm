/obj/structure/wallmount_circuit
	name = "电路箱"
	desc = "一个适合安装集成电路的壁挂式箱子。"
	icon = 'icons/obj/science/circuits.dmi'
	icon_state = "wallmount"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

	resistance_flags = LAVA_PROOF | FIRE_PROOF

/obj/structure/wallmount_circuit/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/shell, null, SHELL_CAPACITY_LARGE, SHELL_FLAG_REQUIRE_ANCHOR|SHELL_FLAG_USB_PORT)

/obj/structure/wallmount_circuit/wrench_act(mob/living/user, obj/item/tool)
	var/datum/component/shell/shell_comp = GetComponent(/datum/component/shell)
	if(shell_comp.locked)
		balloon_alert(user, "已锁定！")
		return ITEM_INTERACT_FAILURE
	to_chat(user, span_notice("你开始松开电路箱..."))
	if(tool.use_tool(src, user, 40, volume=50))
		to_chat(user, span_notice("你松开了电路箱。"))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/wallframe/circuit
	name = "电路箱框架"
	desc = "一个可以安装在墙上并安装电路的箱子。"
	icon = 'icons/obj/science/circuits.dmi'
	icon_state = "wallmount_assembly"
	result_path = /obj/structure/wallmount_circuit
	pixel_shift = 32
