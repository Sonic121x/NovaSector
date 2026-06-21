/obj/machinery/vending/modularpc
	name = "\improper 豪华掌上电脑售货机"
	desc = "垃圾佬用来组装自己电脑的所有零件售货机"
	icon_state = "modularpc"
	icon_deny = "modularpc-deny"
	panel_type = "panel21"
	light_mask = "modular-light-mask"
	product_ads = "Get your gamer gear!;The best GPUs for all of your space-crypto needs!;The most robust cooling!;The finest RGB in space!"
	vend_reply = "Game on!"
	products = list(
		/obj/item/disk/computer = 8,
		/obj/item/modular_computer/laptop = 4,
		/obj/item/modular_computer/pda = 4,
	)
	premium = list(
		/obj/item/pai_card = 2,
	)
	refill_canister = /obj/item/vending_refill/modularpc
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/modularpc
	machine_name = "Deluxe Silicate Selections"
	icon_state = "refill_engi"
