GLOBAL_LIST_EMPTY(elevator_doors)

/obj/machinery/door/window/elevator
	name = "电梯门"
	desc = "防止像你这样的傻瓜走进敞开的电梯井。"
	icon_state = "left"
	base_state = "left"
	can_atmos_pass = ATMOS_PASS_DENSITY // elevator shaft is airtight when closed
	req_access = list(ACCESS_TCOMMS)

/obj/machinery/door/window/elevator/right
	icon_state = "right"
	base_state = "right"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/door/window/elevator/left, 0)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/door/window/elevator/right, 0)
