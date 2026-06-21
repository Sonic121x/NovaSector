/obj/effect/spawner/random/vending
	name = "机械生成器"
	desc = "随机电子元件，带来额外乐趣。"
	/// whether it hacks the vendor on spawn (only used for mapedits)
	var/hacked = FALSE

/obj/effect/spawner/random/vending/make_item(spawn_loc, type_path_to_make)
	var/obj/machinery/vending/vending = ..()
	if(istype(vending))
		vending.extended_inventory = hacked

	return vending

/obj/effect/spawner/random/vending/snackvend
	name = "生成随机零食售货机"
	desc = "变成一个随机零食售货机"
	icon_state = "snack"
	loot_type_path = /obj/machinery/vending/snack
	loot = list()

/obj/effect/spawner/random/vending/snackvend/Initialize(mapload)
	if(check_holidays(HOTDOG_DAY))
		loot += /obj/machinery/vending/hotdog
	return ..()

/obj/effect/spawner/random/vending/colavend
	name = "生成随机可乐售货机"
	desc = "变成一个随机可乐售货机。"
	icon_state = "cola"
	loot_type_path = /obj/machinery/vending/cola
	loot = list()
