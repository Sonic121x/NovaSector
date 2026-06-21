/obj/item/gun/energy/e_gun/advtaser/mounted
	name = "手臂泰瑟枪"
	desc = "一种安装在手臂上的双模式武器，能够发射电极和致盲弹。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "taser"
	inhand_icon_state = "armcannonstun4"
	display_empty = FALSE
	force = 5
	selfcharge = 1
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Has no trigger at all, uses neural signals instead

/obj/item/gun/energy/e_gun/advtaser/mounted/add_seclight_point()
	return

/obj/item/gun/energy/laser/mounted
	name = "手臂激光炮"
	desc = "一种可以发射致命激光的手臂加农炮。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "laser_cyborg"
	inhand_icon_state = "armcannonlase"
	force = 5
	selfcharge = 1
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL

/obj/item/gun/energy/laser/mounted/add_deep_lore()
	return

/obj/item/gun/energy/laser/mounted/augment
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "arm_laser"
