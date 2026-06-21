/obj/vehicle/sealed/mecha/odysseus
	desc = "一款敏捷的德福雷斯特·奥德修斯外骨骼，专为前线医疗支援和快速响应而设计和装备。"
	name = "\improper 奥德修斯"
	icon_state = "odysseus"
	base_icon_state = "odysseus"
	movedelay = 2
	max_temperature = 15000
	max_integrity = 120
	wreckage = /obj/structure/mecha_wreckage/odysseus
	mech_type = EXOSUIT_MODULE_ODYSSEUS
	step_energy_drain = 6
	accesses = list(ACCESS_MECH_SCIENCE, ACCESS_MECH_MEDICAL)
	pivot_step = TRUE

/obj/vehicle/sealed/mecha/odysseus/moved_inside(mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(human, TRAIT_MEDICAL_HUD, VEHICLE_TRAIT)

/obj/vehicle/sealed/mecha/odysseus/remove_occupant(mob/living/carbon/human/human)
	REMOVE_TRAIT(human, TRAIT_MEDICAL_HUD, VEHICLE_TRAIT)
	return ..()

/obj/vehicle/sealed/mecha/odysseus/mmi_moved_inside(obj/item/mmi/MMI, mob/user)
	. = ..()
	if(!. || isnull(MMI.brainmob))
		return
	ADD_TRAIT(MMI.brainmob, TRAIT_MEDICAL_HUD, VEHICLE_TRAIT)
