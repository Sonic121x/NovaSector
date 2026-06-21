/obj/item/holosign_creator/privacy
	name = "个人全息标志投影仪"
	desc = "一种全息投影仪，可创建隐私屏障，告知他人您需要隐私。右键单击可在粉色（情色警示）和灰色（隐私）之间切换。"
	icon = 'modular_nova/master_files/icons/obj/devices/tools.dmi'
	icon_state = "signmaker_erp"
	holosign_type = /obj/structure/holosign/privacy
	creation_time = 0
	max_signs = 8
	obj_flags_nova = ERP_ITEM
	/// Used to toggle the holosign type between normal privacy and lewd.
	var/erp_mode = FALSE

/obj/item/holosign_creator/privacy/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/holosign_creator/privacy/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_RMB] = "[erp_mode ? "Turn off" : "Turn on"] Lewd Advisory Mode"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/holosign_creator/privacy/attack_self_secondary(mob/user, modifiers)
	if(erp_mode)
		erp_mode = FALSE
		holosign_type = /obj/structure/holosign/privacy
		balloon_alert(user, "已关闭成人内容警示模式")
	else
		erp_mode = TRUE
		holosign_type = /obj/structure/holosign/privacy/erp
		balloon_alert(user, "已开启色情咨询模式")
	return ..()

/obj/structure/holosign/privacy
	name = "隐私全息标志"
	desc = "一个闪烁着“私人”字样的全息标志。即使门没锁，如果您未被邀请，礼貌起见也不应再向前走。"
	icon = 'modular_nova/master_files/icons/effects/holosigns.dmi'
	icon_state = "holosign_privacy"
	base_icon_state = "holosign_privacy"

/obj/structure/holosign/privacy/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(tool != projector)
		return
	qdel(src)

/obj/structure/holosign/privacy/erp
	name = "情色警示全息标志"
	desc = "一个闪烁着“情色”字样的全息标志。如果您选择继续前进，可能会遇到性活动。"
	icon_state = "holosign_erp"
	base_icon_state = "holosign_erp"
