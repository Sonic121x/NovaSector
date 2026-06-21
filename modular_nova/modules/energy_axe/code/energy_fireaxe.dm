// Energy fire axes, for DS-2

/obj/item/fireaxe/energy
	icon = 'modular_nova/master_files/icons/obj/energy_axe.dmi'
	icon_state = "energy_axe0"
	base_icon_state = "energy_axe"
	worn_icon_state = "energy_axe"
	lefthand_file = 'modular_nova/master_files/icons/mob/energyaxe_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/energyaxe_righthand.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	name = "能量消防斧"
	desc = "你不太确定这还算不算一把消防斧了，但它确实很花哨！上面挂着一个标签，写着：“戈莱克斯掠夺者财产”"
	force = 5
	throwforce = 15
	light_system = OVERLAY_LIGHT
	light_range = 6
	light_color = COLOR_SOFT_RED
	light_on = FALSE
	armour_penetration = 35
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "An energized fire axe used in Syndicate bases for breaking glass, and people."

/obj/item/fireaxe/energy/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(energy_wield), override = TRUE)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(energy_unwield), override = TRUE)
	AddComponent(/datum/component/two_handed, force_unwielded = 10, force_wielded = 33, icon_wielded = "[base_icon_state]1", wieldsound = 'sound/items/weapons/saberon.ogg', unwieldsound = 'sound/items/weapons/saberoff.ogg')

/obj/item/fireaxe/energy/proc/energy_wield(obj/item/source, mob/living/carbon/user)
	SIGNAL_HANDLER

	hitsound = 'sound/items/weapons/blade1.ogg'
	START_PROCESSING(SSobj, src)
	set_light_on(TRUE)

//Swap hitsounds from energy slash to basic smack sound when unwielded

/obj/item/fireaxe/energy/proc/energy_unwield(obj/item/source, mob/living/carbon/user)
	SIGNAL_HANDLER

	hitsound = SFX_SWING_HIT
	STOP_PROCESSING(SSobj, src)
	set_light_on(FALSE)
