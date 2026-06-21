/obj/machinery/rnd/production/circuit_imprinter
	name = "电路板打印机"
	desc = "制造用于机器结构的电路板。"
	icon_state = "circuit_imprinter"
	base_icon_state = "circuit_imprinter"
	production_animation = "circuit_imprinter_ani"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter
	allowed_buildtypes = IMPRINTER

/obj/machinery/rnd/production/circuit_imprinter/compute_efficiency()
	var/rating = 0
	for(var/datum/stock_part/servo/servo in component_parts)
		rating += servo.tier

	return 0.5 ** max(rating - 1, 0) // One sheet, half sheet, quarter sheet, eighth sheet.

/obj/machinery/rnd/production/circuit_imprinter/flick_animation(datum/material/mat)
	return //we presently have no animation

/obj/machinery/rnd/production/circuit_imprinter/offstation
	name = "古老的电路板打印机"
	desc = "生产用于机器制造的电路板。其老旧的生产设备可能限制了其能够应用所有已知技术的能力。"
	allowed_buildtypes = AWAY_IMPRINTER
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/offstation
