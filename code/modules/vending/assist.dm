/obj/machinery/vending/assist
	name = "\improper 零件销商"
	desc = "最好的各种各样的电子产品一应俱全！我们不对鲁莽使用零件造成的事故损伤负责。"
	icon_state = "parts"
	icon_deny = "parts-deny"
	panel_type = "panel10"
	products = list(
		/obj/item/assembly/igniter = 3,
		/obj/item/assembly/prox_sensor = 5,
		/obj/item/assembly/signaler = 4,
		/obj/item/disk/computer/ordnance = 4,
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/servo = 3,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/scanning_module = 3,
		/obj/item/wirecutters = 2,
		/obj/item/stack/medical/wrap/sticky_tape/duct = 3,
	)
	contraband = list(
		/obj/item/assembly/health = 2,
		/obj/item/assembly/timer = 2,
		/obj/item/assembly/voice = 2,
		/obj/item/stock_parts/power_store/cell/high = 1,
		/obj/item/stock_parts/power_store/battery/high = 1,
		/obj/item/market_uplink/blackmarket = 1,
		/obj/item/screwdriver = 2,
		/obj/item/assembly/mousetrap = 4,
		/obj/item/weaponcrafting/stock = 2,
	)
	premium = list(
		/obj/item/assembly/igniter/condenser = 2,
		/obj/item/circuitboard/machine/vendor = 3,
		/obj/item/universal_scanner = 3,
		/obj/item/vending_refill/custom = 3,
	)

	refill_canister = /obj/item/vending_refill/assist
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"
	default_price = PAYCHECK_CREW * 0.7 //Default of 35.
	extra_price = PAYCHECK_CREW
	payment_department = NO_FREEBIES
	light_mask = "parts-light-mask"

/obj/item/vending_refill/assist
	machine_name = "Part-Mart"
	icon_state = "refill_parts"
