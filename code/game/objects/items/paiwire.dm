/obj/item/pai_cable
	desc = "一根带通用接口的柔性包覆电缆。"
	name = "数据线"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wire1"
	item_flags = NOBLUDGEON
	///The current machine being hacked by the pAI cable.
	var/obj/machinery/hacking_machine

/obj/item/pai_cable/Destroy()
	hacking_machine = null
	return ..()

/obj/item/pai_cable/proc/plugin(obj/machinery/M, mob/living/user)
	if(!user.transferItemToLoc(src, M))
		return
	user.visible_message(span_notice("[user] 将 [src] 插入 [M] 的数据端口。"), span_notice("你将 [src] 插入 [M] 的数据端口。"), span_hear("你听到线缆插头固定到位的清脆咔哒声。"))
	hacking_machine = M
