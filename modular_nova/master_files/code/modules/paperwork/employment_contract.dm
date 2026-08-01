/obj/item/paper/work_contract
	icon_state = "paper_words"
	throw_range = 3
	throw_speed = 3
	item_flags = NOBLUDGEON
	///Needed to get the spawned mob's name to display in the paper.
	var/employee_name = ""

/obj/item/paper/work_contract/Initialize(mapload, new_employee_name)
	if(!new_employee_name)
		return INITIALIZE_HINT_QDEL

	AddElement(/datum/element/update_icon_blocker)
	. = ..()
	employee_name = new_employee_name
	name = "paper- [employee_name] employment contract"
	add_raw_text(LANG("obj.71f0e971", list(employee_name, employee_name))
	)
/obj/structure/filingcabinet/employment/addFile(mob/living/carbon/human/employee)
	new /obj/item/paper/work_contract(src, employee.mind.name)
