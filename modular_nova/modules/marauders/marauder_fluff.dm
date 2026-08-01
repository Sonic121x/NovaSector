//some drinks
/obj/item/reagent_containers/cup/glass/drinkingglass/filled/martini
	list_reagents = list(/datum/reagent/consumable/ethanol/martini = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/fringe_weaver
	list_reagents = list(/datum/reagent/consumable/ethanol/fringe_weaver = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/doctor_delight
	list_reagents = list(/datum/reagent/consumable/doctor_delight = 50)

//papers
/obj/item/paper/fluff/midround_traitor/voucher_instruction
	name = "\proper equipment voucher instructions"
	default_raw_text = {"This folder holds vouchers which can be redeemed at computer consoles, printing machinery and vending machines.
		<br><b>Primary weapons voucher:</b>
		• Security protolathe
		<br><b>Secondary weapons voucher:</b>
		• SecTech vending machine
		<br><b>Robotics exosuit voucher:</b>
		• Exosuit fabricator
		• Orbital mech pad console
		<br><b>Medical implant voucher:</b>
		• Medical protolathe
		• Limb grower
		<br><b>General supplies voucher:</b>
		• Ammunition workbench
		• Operating computer console
		• Robotech vending machine
		• Syndichem vending machine
		• Silicate selections vending machine
		• Part-mart vending machine
		<br>Medical implant vouchers, general supply vouchers and secondary weapon vouchers can be traded for at the communications console in the briefing room. Turn in any voucher, but primary weapon and robotics exosuit vouchers cannot be gotten more of. Spend them wisely."}

/obj/item/paper/fluff/midround_traitor/greeting
	can_become_message_in_bottle = FALSE

/obj/item/paper/fluff/midround_traitor/greeting/proc/write_note(name)
	var/addressed_to
	if(is_mononym(name))
		addressed_to = name
	else
		addressed_to = "[first_name(name)]"

	add_raw_text("[addressed_to],")
	add_raw_text(LANG("obj.351802d3", null))
	add_raw_text(LANG("obj.64a52674", list(SIGNATURE_FONT, pick(GLOB.first_names), rand(2,12))))
