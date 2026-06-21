/obj/item/storage/cans
	name = "易拉罐环"
	desc = "最多可容纳六个饮料罐，以及部分瓶子。"
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "canholder"
	inhand_icon_state = "cola"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT*1.2)
	max_integrity = 500
	storage_type = /datum/storage/sixcan

/obj/item/storage/cans/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始和兄弟们开最后一罐冰镇饮料！看起来[user.p_theyre()]试图自杀！"))
	return BRUTELOSS

/obj/item/storage/cans/update_icon_state()
	icon_state = "[initial(icon_state)][contents.len]"
	return ..()

/obj/item/storage/cans/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/storage/cans/sixsoda
	name = "苏打水瓶环"
	desc = "可容纳六个苏打水罐。记得用完后回收！"

/obj/item/storage/cans/sixsoda/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/cup/soda_cans/cola(src)

/obj/item/storage/cans/sixbeer
	name = "啤酒罐环"
	desc = "可容纳六罐啤酒。用完后记得回收！"

/obj/item/storage/cans/sixbeer/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/cup/soda_cans/beer(src)

/obj/item/storage/cans/sixgamerdrink
	name = "玩家饮料瓶环"
	desc = "可容纳六罐玩家饮料。用完后记得回收！"

	/// Pool of gamer drinks tm we may add from
	var/list/gamer_drink_options = list(
		/obj/item/reagent_containers/cup/soda_cans/pwr_game = 55,
		/obj/item/reagent_containers/cup/soda_cans/space_mountain_wind = 15,
		/obj/item/reagent_containers/cup/soda_cans/monkey_energy = 15,
		/obj/item/reagent_containers/cup/soda_cans/volt_energy = 10,
		/obj/item/reagent_containers/cup/soda_cans/thirteenloko = 5,
	)

/obj/item/storage/cans/sixgamerdrink/PopulateContents()
	for(var/i in 1 to 6)
		var/obj/item/chosen_gamer_drink = pick_weight(gamer_drink_options)
		new chosen_gamer_drink(src)

/obj/item/storage/cans/sixenergydrink
	name = "能量饮料瓶环"
	desc = "可容纳六罐能量饮料。用完后记得回收！"

	/// Pool of energy drinks tm we may add from
	var/list/energy_drink_options = list(
		/obj/item/reagent_containers/cup/soda_cans/space_mountain_wind = 50,
		/obj/item/reagent_containers/cup/soda_cans/monkey_energy = 30,
		/obj/item/reagent_containers/cup/soda_cans/volt_energy = 15,
		/obj/item/reagent_containers/cup/soda_cans/thirteenloko = 5,
	)

/obj/item/storage/cans/sixenergydrink/PopulateContents()
	for(var/i in 1 to 6)
		var/obj/item/chosen_energy_drink = pick_weight(energy_drink_options)
		new chosen_energy_drink(src)
