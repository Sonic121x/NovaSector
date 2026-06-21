//This one's from bay12
/obj/machinery/vending/robotics
	name = "\improper 机兵入门售货机"
	desc = "打造你自己的机器人大军所需的一切工具。"
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	panel_type = "panel14"
	light_mask = "robotics-light-mask"
	products = list(
		/obj/item/clothing/suit/toggle/labcoat = 4,
		/obj/item/clothing/under/rank/rnd/roboticist = 4,
		/obj/item/stack/cable_coil = 4,
		/obj/item/assembly/flash/handheld = 4,
		/obj/item/stock_parts/power_store/cell/high = 12,
		/obj/item/assembly/prox_sensor = 3,
		/obj/item/assembly/signaler = 3,
		/obj/item/healthanalyzer = 3,
		/obj/item/scalpel = 2,
		/obj/item/circular_saw = 2,
		/obj/item/bonesetter = 2,
		/obj/item/tank/internals/anesthetic = 2,
		/obj/item/clothing/mask/breath/medical = 5,
		/obj/item/screwdriver = 5,
		/obj/item/crowbar = 5,
	)
	refill_canister = /obj/item/vending_refill/robotics
	default_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/robotics
	machine_name = "Robotech Deluxe"
	icon_state = "refill_engi"
