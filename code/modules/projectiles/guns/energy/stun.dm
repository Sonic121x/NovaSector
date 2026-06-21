/obj/item/gun/energy/taser
	name = "泰瑟枪"
	desc = "一种低容量、基于能量的电击枪，安保团队用来远程制服目标。"
	icon_state = "taser"
	inhand_icon_state = null //so the human update icon uses the icon_state instead.
	light_color = LIGHT_COLOR_DIM_YELLOW
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	ammo_x_offset = 3

/obj/item/gun/energy/e_gun/advtaser
	name = "混合泰瑟枪"
	desc = "一种双模式泰瑟枪，设计用于发射短距离高功率电极和远程麻痹光束。"
	icon_state = "advtaser"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/e_gun/advtaser/cyborg
	name = "赛博泰瑟枪"
	desc = "An integrated hybrid taser that draws directly from a cyborg's power cell. The weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/e_gun/advtaser/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/e_gun/advtaser/cyborg/add_seclight_point()
	return

/obj/item/gun/energy/disabler
	name = "镇暴光枪"
	desc = "这是一种自卫武器，可以对抗暴徒，削弱它们，直到它们麻痹。"
	icon_state = "disabler"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 10)

/obj/item/gun/energy/disabler/smg
	name = "眩晕枪冲锋枪"
	desc = "一款自动型眩晕枪变体，与传统型号相比，它以略微降低光束效能为代价，换取了更高的弹药容量。"
	icon_state = "disabler_smg"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/smg)
	shaded_charge = 1

/obj/item/gun/energy/disabler/smg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS, allow_akimbo = FALSE)

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(\
		/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 13, \
	)

/obj/item/gun/energy/disabler/cyborg
	name = "赛博镇暴光枪"
	desc = "An integrated disabler that draws from a cyborg's power cell. This weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/disabler/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)
