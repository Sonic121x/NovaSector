/obj/item/sensor_device/blueshield
	name = "蓝盾手持监视器"
	desc = "一款独特型号的手持船员监视器，似乎已为行政保护目的进行了定制。"
	icon = 'modular_nova/modules/blueshield/icons/device.dmi'
	icon_state = "blueshield_scanner"

/obj/item/sensor_device/blueshield/attack_self(mob/user)
	GLOB.blueshield_crewmonitor.show(user,src)
