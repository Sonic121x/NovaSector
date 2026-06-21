// Prioritizes the type of atom that the manipulator interact with. Interaction lists get built on the points themselves.

/datum/manipulator_priority
	/// The name of the priority for the UI display.
	var/name
	/// Which typepath does this priority handle.
	var/atom_typepath
	/// Is this priority active? If not, it will be ignored.
	var/active = TRUE

/datum/manipulator_priority/drop/on_floor
	name = "放置在地面"
	atom_typepath = /turf

/datum/manipulator_priority/drop/in_storage
	name = "放入存储"
	atom_typepath = /obj/item/storage

/datum/manipulator_priority/interact/with_living
	name = "对生物使用"
	atom_typepath = /mob/living

/datum/manipulator_priority/interact/with_structure
	name = "对结构使用"
	atom_typepath = /obj/structure

/datum/manipulator_priority/interact/with_machinery
	name = "对机械使用"
	atom_typepath = /obj/machinery

/datum/manipulator_priority/interact/with_items
	name = "对物品使用"
	atom_typepath = /obj/item

/datum/manipulator_priority/interact/with_vehicles
	name = "对载具使用"
	atom_typepath = /obj/vehicle
