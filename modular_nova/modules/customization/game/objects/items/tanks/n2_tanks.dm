/*
 * Nitrogen Tanks for Vox
 */

/obj/item/tank/internals/nitrogen
	name = "氮气罐"
	desc = "一个小型氮气罐，供不呼吸标准空气混合物的船员使用。"
	icon_state = "oxygen_fr"
	force = 10
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE

/obj/item/tank/internals/nitrogen/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrogen)
	air_contents.gases[/datum/gas/nitrogen][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/nitrogen/full/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrogen)
	air_contents.gases[/datum/gas/nitrogen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/nitrogen/belt
	icon = 'modular_nova/master_files/icons/obj/tank.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/belt.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/equipment/tanks_righthand.dmi'
	icon_state = "nitrogen_extended"
	inhand_icon_state = "nitrogen"
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 24
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tank/internals/nitrogen/belt/full/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrogen)
	air_contents.gases[/datum/gas/nitrogen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/nitrogen/belt/emergency
	name = "应急氮气罐"
	desc = "用于紧急情况。内含氮气极少，请尽量节省使用，直到真正需要时。"
	icon_state = "nitrogen"
	worn_icon_state = "nitrogen_extended"
	volume = 3

/obj/item/tank/internals/nitrogen/belt/emergency/populate_gas()
	air_contents.assert_gas(/datum/gas/nitrogen)
	air_contents.gases[/datum/gas/nitrogen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
