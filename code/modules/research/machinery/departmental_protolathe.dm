/obj/machinery/rnd/production/protolathe/department
	name = "部门复合机"
	desc = "一款特殊的专用机床，内置有接口，专为部门使用而设计，其内置的 ExoSync 接收器能够根据其 ROM 编码的部门类型打印出与之匹配的设计部件。"
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe/department

/obj/machinery/rnd/production/protolathe/department/engineering
	name = "复合机 - 工程"
	allowed_department_flags = DEPARTMENT_BITFLAG_ENGINEERING
	circuit = /obj/item/circuitboard/machine/protolathe/department/engineering
	stripe_color = "#EFB341"
	payment_department = ACCOUNT_ENG

/obj/machinery/rnd/production/protolathe/department/service
	name = "复合机 - 服务"
	allowed_department_flags = DEPARTMENT_BITFLAG_SERVICE
	circuit = /obj/item/circuitboard/machine/protolathe/department/service
	stripe_color = "#83ca41"
	payment_department = ACCOUNT_SRV

/obj/machinery/rnd/production/protolathe/department/medical
	name = "复合机 - 医疗"
	allowed_department_flags = DEPARTMENT_BITFLAG_MEDICAL
	circuit = /obj/item/circuitboard/machine/protolathe/department/medical
	stripe_color = "#52B4E9"
	payment_department = ACCOUNT_MED

/obj/machinery/rnd/production/protolathe/department/cargo
	name = "复合机 - 货舱"
	allowed_department_flags = DEPARTMENT_BITFLAG_CARGO
	circuit = /obj/item/circuitboard/machine/protolathe/department/cargo
	stripe_color = "#956929"
	payment_department = ACCOUNT_CAR

/obj/machinery/rnd/production/protolathe/department/science
	name = "复合机 - 科研"
	allowed_department_flags = DEPARTMENT_BITFLAG_SCIENCE
	circuit = /obj/item/circuitboard/machine/protolathe/department/science
	stripe_color = "#D381C9"
	payment_department = ACCOUNT_SCI

/obj/machinery/rnd/production/protolathe/department/security
	name = "复合机 - 安保"
	allowed_department_flags = DEPARTMENT_BITFLAG_SECURITY
	circuit = /obj/item/circuitboard/machine/protolathe/department/security
	stripe_color = "#DE3A3A"
	payment_department = ACCOUNT_SEC
