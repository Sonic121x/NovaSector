/**
 * # Toggle Component
 *
 * Does a toggle between true and false on trigger
 */
/obj/item/circuit_component/compare/toggle
	display_name = "Toggle"
	desc = "一个在触发时在开启和关闭之间切换的组件。所有输入端口（除了设置切换端口）都会触发该组件。"
	category = "Math"

	/// A signal to reset the toggle back to 0
	var/datum/port/input/toggle_set
	/// A signal to toggle and return the current state
	var/datum/port/input/toggle_and_compare

	var/toggle_state = FALSE

/obj/item/circuit_component/compare/toggle/populate_custom_ports()
	toggle_set = add_input_port("Set Toggle State", PORT_TYPE_BOOLEAN)
	toggle_and_compare = add_input_port("Toggle And Compare", PORT_TYPE_SIGNAL)
	toggle_state = FALSE

/obj/item/circuit_component/compare/toggle/input_received(datum/port/input/port)
	if(port == toggle_set)
		toggle_state = !!port.value
		return
	if(COMPONENT_TRIGGERED_BY(toggle_and_compare, port))
		toggle_state = !toggle_state
		if(toggle_state)
			true.set_output(COMPONENT_SIGNAL)
		else
			false.set_output(COMPONENT_SIGNAL)
	return ..()

/obj/item/circuit_component/compare/toggle/do_comparisons()
	return toggle_state
