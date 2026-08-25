/obj/item/assembly/control/polarizer
	name = "window polarization remote controller"
	desc = "A small electronic device able to control the polarization status of linked windows remotely."
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	/// Whether the connected windows are meant to be polarized or not.
	var/polarizing = FALSE


/obj/item/assembly/control/polarizer/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.9d1d60313c9c2dd8", null))


/obj/item/assembly/control/polarizer/multitool_act(mob/living/user)
	attack_self(user)


/obj/item/assembly/control/polarizer/attack_self(mob/living/user)
	var/change_id = tgui_input_number(user, LANG("obj.9369c29f5f15b1de", list(src)), LANG("obj.48940215f9d72725", null), text2num(id), 1000)
	if(!change_id || QDELETED(user) || QDELETED(src) || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	id = "[change_id]"
	balloon_alert(user, LANG("obj.3852daee6363f0cd", null))
	to_chat(user, span_notice(LANG("obj.7fe56c167316abeb", list(id))))


/obj/item/assembly/control/polarizer/activate()
	if(cooldown)
		return

	cooldown = TRUE

	if(!GLOB.polarization_controllers[id])
		addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 1 SECONDS) // Just so they can't spam the button.
		return

	polarizing = !polarizing

	for(var/datum/component/polarization_controller/controller as anything in GLOB.polarization_controllers[id])
		controller.toggle(polarizing)

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 1 SECONDS)


/obj/machinery/button/polarizer
	device_type = /obj/item/assembly/control/polarizer


/datum/design/polarizer
	name = "Window Polarization Remote Controller"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE | COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/assembly/control/polarizer
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
