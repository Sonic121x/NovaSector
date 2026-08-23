// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/wires/mass_driver
	holder_type = /obj/machinery/mass_driver
	proper_name = "Mass Driver"

/datum/wires/mass_driver/New(atom/holder)
	wires = list(WIRE_LAUNCH, WIRE_SAFETIES)
	..()

/datum/wires/mass_driver/on_pulse(wire)
	var/obj/machinery/mass_driver/the_mass_driver = holder
	switch(wire)
		if(WIRE_LAUNCH)
			the_mass_driver.drive()
			holder.visible_message(span_notice(LANG("datum.9fa79d3d15a62c2f", null)))
		if(WIRE_SAFETIES)
			the_mass_driver.power = 3
			holder.visible_message(span_notice(LANG("datum.1916e26cc4f8ecf4", null)))

/datum/wires/mass_driver/on_cut(wire, mend, source)
	var/obj/machinery/mass_driver/the_mass_driver = holder
	switch(wire)
		if(WIRE_SAFETIES)
			if(the_mass_driver.power > 1) 
				the_mass_driver.power = 1
				holder.visible_message(span_notice(LANG("datum.1852881771c4638a", null)))
