/* Types of tanks!
 * Contains:
 * Oxygen
 * Anesthetic
 * Air
 * Plasma
 * Emergency Oxygen
 * Generic
 */
/obj/item/tank/internals
	interaction_flags_click = FORBID_TELEKINESIS_REACH|NEED_HANDS|ALLOW_RESTING


/// Allows carbon to toggle internals via AltClick of the equipped tank.
/obj/item/tank/internals/click_alt(mob/user)
	toggle_internals(user)
	return CLICK_ACTION_SUCCESS

/obj/item/tank/internals/examine(mob/user)
	. = ..()
	. += span_notice("Alt-点击气罐以切换阀门。")

/*
 * Oxygen
 */
/obj/item/tank/internals/oxygen
	name = "氧气罐"
	desc = "一个氧气罐，这个是蓝色的。"
	icon_state = "oxygen"
	inhand_icon_state = "oxygen_tank"
	tank_holder_icon_state = "holder_oxygen"
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back


/obj/item/tank/internals/oxygen/populate_gas()
	air_contents.set_gas(/datum/gas/oxygen, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/internals/oxygen/yellow
	desc = "一个氧气罐，这个是黄色的。"
	icon_state = "oxygen_f"
	inhand_icon_state = "oxygen_f_tank"
	tank_holder_icon_state = "holder_oxygen_f"
	dog_fashion = null

/obj/item/tank/internals/oxygen/red
	desc = "一个氧气罐，这个是红色的。"
	icon_state = "oxygen_fr"
	inhand_icon_state = "oxygen_fr_tank"
	tank_holder_icon_state = "holder_oxygen_fr"
	dog_fashion = null

/obj/item/tank/internals/oxygen/empty/populate_gas()
	return

/*
 * Anesthetic
 */
/obj/item/tank/internals/anesthetic
	name = "麻醉剂罐"
	desc = "一个装有N2O/O2混合气体的罐子。"
	icon_state = "anesthetic"
	inhand_icon_state = "an_tank"
	tank_holder_icon_state = "holder_anesthetic"
	force = 10

/obj/item/tank/internals/anesthetic/populate_gas()
	air_contents.set_gas(/datum/gas/oxygen, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD)
	air_contents.set_gas(/datum/gas/nitrous_oxide, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)


/obj/item/tank/internals/anesthetic/examine(mob/user)
	. = ..()
	. += span_notice("[src]上刻着一则警告...")
	. += span_warning("人体内没有消耗N2O的生理过程，因此病人会呼出N2O……使你暴露其中。请务必在通风良好的空间工作，以避免困倦导致的意外。")

/obj/item/tank/internals/anesthetic/pure
	desc = "一个装有纯N2O的罐子。罐子上被草草地贴了一张警告标签。"
	icon_state = "anesthetic_warning"

/obj/item/tank/internals/anesthetic/pure/populate_gas()
	air_contents.adjust_gas(/datum/gas/nitrous_oxide, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/*
 * Plasma
 */
/obj/item/tank/internals/plasma
	name = "等离子罐"
	desc = "装有危险的等离子体。请勿吸入。警告：极度易燃。"
	icon_state = "plasma"
	inhand_icon_state = "plasma_tank"
	worn_icon_state = "plasmatank"
	tank_holder_icon_state = null
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = null //they have no straps!
	force = 8


/obj/item/tank/internals/plasma/populate_gas()
	air_contents.set_gas(/datum/gas/plasma, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/plasma/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if ((!F.status) || (F.ptank))
			return
		if(!user.transferItemToLoc(src, F))
			return
		src.master = F
		F.ptank = src
		F.update_appearance()
	else
		return ..()

/obj/item/tank/internals/plasma/full/populate_gas()
	air_contents.set_gas(/datum/gas/plasma, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/plasma/empty/populate_gas()
	return

/*
 * Plasmaman Plasma Tank
 */

/obj/item/tank/internals/plasmaman
	name = "等离子体内循环罐"
	desc = "一种专门设计用于体内循环的等离子气体罐，尤其适用于等离子体生命形式。如果你不是等离子人，或许不该使用它。"
	icon_state = "plasmaman_tank"
	inhand_icon_state = "plasmaman_tank"
	tank_holder_icon_state = null
	force = 10
	distribute_pressure = TANK_PLASMAMAN_RELEASE_PRESSURE

/obj/item/tank/internals/plasmaman/populate_gas()
	air_contents.set_gas(/datum/gas/plasma, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/plasmaman/full/populate_gas()
	air_contents.set_gas(/datum/gas/plasma, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/internals/plasmaman/belt
	icon_state = "plasmaman_tank_belt"
	inhand_icon_state = "plasmaman_tank_belt"
	worn_icon_state = "plasmaman_tank_belt"
	tank_holder_icon_state = null
	worn_icon = null
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 6 //same size as the engineering ones but plasmamen have special lungs that consume less plasma per breath
	w_class = WEIGHT_CLASS_SMALL //thanks i forgot this

/obj/item/tank/internals/plasmaman/belt/full/populate_gas()
	air_contents.set_gas(/datum/gas/plasma, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/plasmaman/belt/empty/populate_gas()
	return



/*
 * Emergency Oxygen
 */
/obj/item/tank/internals/emergency_oxygen
	name = "应急氧气罐"
	desc = "用于紧急情况。内含氧气极少，请尽量节省使用，直到真正需要时。"
	icon_state = "emergency"
	inhand_icon_state = "emergency_tank"
	worn_icon_state = "emergency"
	tank_holder_icon_state = "holder_emergency"
	worn_icon = null
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	volume = 3 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)


/obj/item/tank/internals/emergency_oxygen/populate_gas()
	air_contents.set_gas(/datum/gas/oxygen, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/internals/emergency_oxygen/empty/populate_gas()
	return

/obj/item/tank/internals/emergency_oxygen/engi
	name = "扩容应急氧气罐"
	icon_state = "emergency_engi"
	inhand_icon_state = "emergency_engi_tank"
	worn_icon_state = "emergency_engi"
	tank_holder_icon_state = "holder_emergency_engi"
	worn_icon = null
	volume = 6 // should last 24 minutes if full

/obj/item/tank/internals/emergency_oxygen/engi/empty/populate_gas()
	return

/obj/item/tank/internals/emergency_oxygen/double
	name = "双倍应急氧气罐"
	icon_state = "emergency_double"
	worn_icon_state = "emergency_engi"
	tank_holder_icon_state = "holder_emergency_engi"
	volume = 12 //If it's double of the above, shouldn't it be double the volume??

/obj/item/tank/internals/emergency_oxygen/double/empty/populate_gas()
	return

// *
// * GENERIC
// *

/obj/item/tank/internals/generic
	name = "气体罐"
	desc = "一种用于储存和运输气体的通用罐。可用于体内循环。"
	icon_state = "generic"
	inhand_icon_state = "generic_tank"
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back

/obj/item/tank/internals/generic/populate_gas()
	return

/*
 * Funny internals
 */
/obj/item/tank/internals/emergency_oxygen/engi/clown
	name = "滑稽应急氧气罐"
	desc = "用于紧急情况。内含极少氧气及额外的滑稽气体，请尽量节省使用，直到真正需要时。"
	icon_state = "emergency_clown"
	inhand_icon_state = "emergency_clown"
	worn_icon_state = "emergency_clown"
	tank_holder_icon_state = "holder_emergency_clown"
	distribute_pressure = TANK_CLOWN_RELEASE_PRESSURE

/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o

/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o/populate_gas()
	air_contents.set_gas(/datum/gas/oxygen, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.95)
	air_contents.set_gas(/datum/gas/nitrous_oxide, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.05)

/obj/item/tank/internals/emergency_oxygen/engi/clown/bz

/obj/item/tank/internals/emergency_oxygen/engi/clown/bz/populate_gas()
	air_contents.set_gas(/datum/gas/oxygen,(10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.9)
	air_contents.set_gas(/datum/gas/bz,(10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.1)

/obj/item/tank/internals/emergency_oxygen/engi/clown/helium
	distribute_pressure = TANK_CLOWN_RELEASE_PRESSURE + 2

/obj/item/tank/internals/emergency_oxygen/engi/clown/helium/populate_gas()
	air_contents.set_gas(/datum/gas/oxygen, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.75)
	air_contents.set_gas(/datum/gas/helium, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.25)
