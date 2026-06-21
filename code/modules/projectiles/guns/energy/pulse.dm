/obj/item/gun/energy/pulse
	name = "脉冲步枪"
	desc = "一款重型、多功能能量步枪，具有三种模式。前线作战人员的首选。"
	icon_state = "pulse"
	inhand_icon_state = null
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	modifystate = TRUE
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BACK
	light_color = COLOR_BLUE
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	cell_type = /obj/item/stock_parts/power_store/cell/pulse

/obj/item/gun/energy/pulse/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/pulse/prize
	pin = /obj/item/firing_pin

/obj/item/gun/energy/pulse/prize/Initialize(mapload)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)
	var/turf/T = get_turf(src)

	message_admins("A pulse rifle prize has been created at [ADMIN_VERBOSEJMP(T)]")
	log_game("A pulse rifle prize has been created at [AREACOORD(T)]")

	notify_ghosts(
		"Someone won a pulse rifle as a prize!",
		source = src,
		header = "Pulse rifle prize",
	)

/obj/item/gun/energy/pulse/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/energy/pulse/carbine
	name = "脉冲卡宾枪"
	desc = "脉冲步枪的紧凑型版本，火力较小但更易于存放。"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "pulse_carbine"
	worn_icon_state = "gun"
	inhand_icon_state = null
	cell_type = /obj/item/stock_parts/power_store/cell/pulse/carbine

/obj/item/gun/energy/pulse/carbine/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 12)

/obj/item/gun/energy/pulse/carbine/lethal
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode)

/obj/item/gun/energy/pulse/carbine/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/energy/pulse/carbine/taserless
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/pulse/destroyer
	name = "脉冲摧毁炮"
	desc = "一把为纯粹毁灭而打造的重型能量步枪。"
	worn_icon_state = "pulse"
	cell_type = /obj/item/stock_parts/power_store/cell/infinite
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse)

/obj/item/gun/energy/pulse/destroyer/attack_self(mob/living/user)
	to_chat(user, span_danger("[src.name] 有三种设置，它们全都是毁灭性的。"))

/obj/item/gun/energy/pulse/pistol
	name = "脉冲手枪"
	desc = "一种脉冲步枪，但设计成易于隐藏的手枪形式，容量较低。"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	icon_state = "pulse_pistol"
	worn_icon_state = "gun"
	inhand_icon_state = "gun"
	cell_type = /obj/item/stock_parts/power_store/cell/pulse/pistol

/obj/item/gun/energy/pulse/pistol/taserless
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/pulse/pistol/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/energy/pulse/pistol/m1911
	name = "\improper M1911-P"
	desc = "一款紧凑型脉冲核心，装配于经典手枪框架，专为纳米传讯官员设计。这不是枪的尺寸，而是它在人身上打出的孔的大小。"
	icon_state = "m1911"
	inhand_icon_state = "gun"
	cell_type = /obj/item/stock_parts/power_store/cell/infinite
