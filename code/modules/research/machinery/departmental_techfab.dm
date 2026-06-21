/obj/machinery/rnd/production/techfab/department
	name = "部门复合机"
	desc = "一款先进的制造设备，专门用于打印最新的原型产品和从科学领域研究出来的电路。它配备了与研究网络同步的硬件。此设备属于部门专用，且只拥有有限数量的解密密钥。"
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/techfab/department

/obj/machinery/rnd/production/techfab/department/engineering
	name = "复合机 - 工程"
	allowed_department_flags = DEPARTMENT_BITFLAG_ENGINEERING
	circuit = /obj/item/circuitboard/machine/techfab/department/engineering
	stripe_color = "#EFB341"
	payment_department = ACCOUNT_ENG

/obj/machinery/rnd/production/techfab/department/service
	name = "复合机 - 服务"
	allowed_department_flags = DEPARTMENT_BITFLAG_SERVICE
	circuit = /obj/item/circuitboard/machine/techfab/department/service
	stripe_color = "#83ca41"
	payment_department = ACCOUNT_SRV

/obj/machinery/rnd/production/techfab/department/medical
	name = "复合机 - 医疗"
	allowed_department_flags = DEPARTMENT_BITFLAG_MEDICAL
	circuit = /obj/item/circuitboard/machine/techfab/department/medical
	stripe_color = "#52B4E9"
	payment_department = ACCOUNT_MED

/obj/machinery/rnd/production/techfab/department/cargo
	name = "复合机 - 补给"
	allowed_department_flags = DEPARTMENT_BITFLAG_CARGO
	circuit = /obj/item/circuitboard/machine/techfab/department/cargo
	stripe_color = "#956929"
	payment_department = ACCOUNT_CAR

/obj/machinery/rnd/production/techfab/department/science
	name = "复合机 - 科研"
	allowed_department_flags = DEPARTMENT_BITFLAG_SCIENCE
	circuit = /obj/item/circuitboard/machine/techfab/department/science
	stripe_color = "#D381C9"
	payment_department = ACCOUNT_SCI

/obj/machinery/rnd/production/techfab/department/security
	name = "复合机 - 安保"
	allowed_department_flags = DEPARTMENT_BITFLAG_SECURITY
	circuit = /obj/item/circuitboard/machine/techfab/department/security
	stripe_color = "#DE3A3A"
	payment_department = ACCOUNT_SEC
