/**
 * # Decimal Conversion Component
 *
 * Return a number from an array of binary inputs.
 */
/obj/item/circuit_component/decimal_conversion
	display_name = "Decimal Conversion"
	desc = "将一系列以 1 或 0 表示的二进制数字（常用于布尔运算或二进制操作）合并成一个十进制数。"
	category = "Math"

	/// One number
	var/datum/port/output/number

	/// Many binary digits
	var/list/datum/port/bit_array = list()

	ui_buttons = list(
		"plus" = "add",
		"minus" = "remove"
	)

/obj/item/circuit_component/decimal_conversion/populate_ports()
	AddComponent(/datum/component/circuit_component_add_port, \
		port_list = bit_array, \
		add_action = "add", \
		remove_action = "remove", \
		port_type = PORT_TYPE_NUMBER, \
		prefix = "Bit", \
		minimum_amount = 1, \
		maximum_amount = MAX_BITFIELD_SIZE \
	)
	number = add_output_port("Number", PORT_TYPE_NUMBER, order = 1.1)

/obj/item/circuit_component/decimal_conversion/input_received(datum/port/input/port)
	if(!length(bit_array))
		return

	var/result = 0
	for(var/iteration in 1 to length(bit_array))
		var/datum/port/input/bit = bit_array[iteration]
		if(bit.value)
			result += (2 ** (iteration-1))
	number.set_output(result)
