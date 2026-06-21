/**
 * # Arctangent 2 function
 * A variant of arctan. When given a deltaX and deltaY, returns the angle. I will blow you out of the sky
 */
/obj/item/circuit_component/arctan2
	display_name = "Arctangent 2 Component"
	desc = "一个双参数 arctan2 组件，用于计算任意角度。"
	category = "Math"

	/// The input port for the x-offset
	var/datum/port/input/input_port_x
	/// The input port for the y-offset
	var/datum/port/input/input_port_y

	/// The result from the output
	var/datum/port/output/output

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/arctan2/populate_ports()
	input_port_x = add_input_port("Delta X", PORT_TYPE_NUMBER)
	input_port_y = add_input_port("Delta Y", PORT_TYPE_NUMBER)
	output = add_output_port("Angle", PORT_TYPE_NUMBER)

/obj/item/circuit_component/arctan2/input_received(datum/port/input/port)
	output.set_output(arctan(input_port_x.value, input_port_y.value))
