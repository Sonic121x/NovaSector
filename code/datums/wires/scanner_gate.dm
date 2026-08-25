// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/wires/scanner_gate
	holder_type = /obj/machinery/scanner_gate
	proper_name = "Scanner Gate"
	wires = list(WIRE_ACCEPT, WIRE_DENY, WIRE_DISABLE)
	wire_behavior = WIRES_FUNCTIONAL_OUTPUT

/datum/wires/scanner_gate/on_pulse(wire, user)
	. = ..()
	var/obj/machinery/scanner_gate/scan_gate = holder
	switch(wire)
		if(WIRE_ACCEPT)
			scan_gate.light_pass = !scan_gate.light_pass
		if(WIRE_DENY)
			scan_gate.light_fail = !scan_gate.light_fail
		if(WIRE_DISABLE)
			scan_gate.ignore_signals = !scan_gate.ignore_signals

/datum/wires/scanner_gate/get_status()
	var/obj/machinery/scanner_gate/scanner = holder
	. = list()
	. += LANG("datum.11db0ccf8e342ea3", list(scanner.light_pass ? "on" : "off"))
	. += LANG("datum.a29999799dd5e7fc", list(scanner.light_fail ? "on" : "off"))
	. += LANG("datum.643df2a99ae250fc", list(scanner.ignore_signals ? "on" : "off"))
