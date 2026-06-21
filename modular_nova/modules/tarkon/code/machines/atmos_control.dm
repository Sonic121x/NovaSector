/////////////////// Port Tarkon Atmost Control ///////////////////

/obj/machinery/computer/atmos_control/tarkon
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon
	reconnecting = FALSE // this is hardwired to main station chambers

/obj/item/circuitboard/computer/atmos_control/tarkon
	name = "塔康大气控制"
	build_path = /obj/machinery/computer/atmos_control/tarkon

/obj/machinery/computer/atmos_control/tarkon/oxygen_tank
	name = "塔康氧气供应控制"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/oxygen_tank
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_O2 = "Oxygen Supply")

/obj/item/circuitboard/computer/atmos_control/tarkon/oxygen_tank
	name = "塔康氧气供应控制"
	build_path = /obj/machinery/computer/atmos_control/tarkon/oxygen_tank

/obj/machinery/air_sensor/tarkon/oxygen_tank
	name = "氧气罐气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_O2

/obj/machinery/computer/atmos_control/tarkon/plasma_tank
	name = "塔康等离子体供应控制"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/plasma_tank
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_PLAS = "Plasma Supply")

/obj/item/circuitboard/computer/atmos_control/tarkon/plasma_tank
	name = "塔康等离子体供应控制"
	build_path = /obj/machinery/computer/atmos_control/tarkon/plasma_tank

/obj/machinery/air_sensor/tarkon/plasma_tank
	name = "等离子体罐气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_PLAS

/obj/machinery/computer/atmos_control/tarkon/mix_tank
	name = "塔康混合室控制"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/mix_tank
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_MIX = "Mix Chamber")

/obj/item/circuitboard/computer/atmos_control/tarkon/mix_tank
	name = "塔康混合气体供应控制"
	build_path = /obj/machinery/computer/atmos_control/tarkon/mix_tank

/obj/machinery/air_sensor/tarkon/mix_tank
	name = "混合罐气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_MIX

/obj/machinery/computer/atmos_control/tarkon/nitrogen_tank
	name = "塔康氮气供应控制"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/nitrogen_tank
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_N2 = "Nitrogen Supply")

/obj/item/circuitboard/computer/atmos_control/tarkon/nitrogen_tank
	name = "塔康氮气供应控制"
	build_path = /obj/machinery/computer/atmos_control/tarkon/nitrogen_tank

/obj/machinery/air_sensor/tarkon/nitrogen_tank
	name = "氮气罐气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_N2

/obj/machinery/computer/atmos_control/tarkon/nitrous_tank
	name = "塔康一氧化二氮供应控制"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/nitrous_tank
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_N2O = "Nitrous Oxide Supply")

/obj/item/circuitboard/computer/atmos_control/tarkon/nitrous_tank
	name = "塔康一氧化二氮供应控制台"
	build_path = /obj/machinery/computer/atmos_control/tarkon/nitrous_tank

/obj/machinery/air_sensor/tarkon/nitrous_tank
	name = "一氧化二氮储罐气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_N2O

/obj/machinery/computer/atmos_control/tarkon/carbon_tank
	name = "塔康二氧化碳供应控制台"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/carbon_tank
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_CO2 = "Carbon Dioxide Supply")

/obj/item/circuitboard/computer/atmos_control/tarkon/carbon_tank
	name = "塔康二氧化碳供应控制台"
	build_path = /obj/machinery/computer/atmos_control/tarkon/carbon_tank

/obj/machinery/air_sensor/tarkon/carbon_tank
	name = "二氧化碳储罐气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_CO2

/obj/machinery/computer/atmos_control/tarkon/incinerator
	name = "塔康焚化炉舱室控制台"
	circuit = /obj/item/circuitboard/computer/atmos_control/tarkon/incinerator
	atmos_chambers = list(ATMOS_GAS_MONITOR_TARKON_INCINERATOR = "Incinerator Chamber")

/obj/item/circuitboard/computer/atmos_control/tarkon/incinerator
	name = "塔康焚化炉舱室控制台"
	build_path = /obj/machinery/computer/atmos_control/tarkon/incinerator

/obj/machinery/air_sensor/tarkon/incinerator_tank
	name = "焚化炉舱室气体传感器"
	chamber_id = ATMOS_GAS_MONITOR_TARKON_INCINERATOR

/obj/machinery/airlock_sensor/incinerator_tarkon
	id_tag = INCINERATOR_TARKON_AIRLOCK_SENSOR
	master_tag = INCINERATOR_TARKON_AIRLOCK_CONTROLLER

/obj/machinery/door/airlock/public/glass/incinerator/tarkon_interior
	name = "涡轮机内部气闸门"
	id_tag = INCINERATOR_TARKON_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/public/glass/incinerator/tarkon_exterior
	name = "涡轮机外部气闸门"
	id_tag = INCINERATOR_TARKON_AIRLOCK_EXTERIOR

/obj/machinery/airlock_controller/incinerator_tarkon
	name = "焚化炉访问控制台"
	airpump_tag = INCINERATOR_TARKON_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_TARKON_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_TARKON_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_TARKON_AIRLOCK_INTERIOR
	sanitize_external = TRUE
	sensor_tag = INCINERATOR_TARKON_AIRLOCK_SENSOR

/obj/machinery/atmospherics/components/binary/dp_vent_pump/high_volume/incinerator_tarkon
	id_tag = INCINERATOR_TARKON_DP_VENTPUMP

/obj/machinery/igniter/incinerator_tarkon
	id = INCINERATOR_TARKON_IGNITER

/obj/machinery/button/ignition/incinerator/tarkon
	id = INCINERATOR_TARKON_IGNITER
