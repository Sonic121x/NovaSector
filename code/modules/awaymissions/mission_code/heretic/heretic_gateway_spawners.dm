/obj/effect/spawner/random/heretic_gateway
	name = "随机异教徒门禁卡生成点"
	desc = "生成一张随机的门禁卡，但很可能是垃圾。"
	loot = list(
		/obj/item/keycard/cbrn_area = 5,
		/obj/item/keycard/biological_anomalies = 20,
		/obj/item/keycard/misc_anomalies = 20,
		/obj/item/keycard/weapon_anomalies = 20,
		/obj/effect/spawner/random/trash/deluxe_garbage = 35
	)

/obj/effect/spawner/random/heretic_gateway_low
	name = "随机异教徒门禁卡生成点"
	desc = "生成一张随机的门禁卡，但肯定只是垃圾。"
	loot = list(
		/obj/item/keycard/cbrn_area = 0.5,
		/obj/item/keycard/biological_anomalies = 5,
		/obj/item/keycard/misc_anomalies = 5,
		/obj/item/keycard/weapon_anomalies = 4,
		/obj/effect/spawner/random/trash/deluxe_garbage = 85.5
	)
