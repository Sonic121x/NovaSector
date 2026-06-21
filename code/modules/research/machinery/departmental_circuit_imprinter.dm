/obj/machinery/rnd/production/circuit_imprinter/department
	name = "电路板打印机"
	desc = "一款特殊的电路印制器，内置有接口，专为部门使用而设计，还内置了 ExoSync 接收器，使其能够根据其 ROM 编码的部门类型打印出与之匹配的设计图案。"
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/department

/obj/machinery/rnd/production/circuit_imprinter/department/science
	name = "电路板打印机 - 科研"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/department/science
	allowed_department_flags = DEPARTMENT_BITFLAG_SCIENCE
	payment_department = ACCOUNT_SCI
