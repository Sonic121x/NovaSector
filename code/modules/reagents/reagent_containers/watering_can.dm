/obj/item/reagent_containers/cup/watering_can
	name = "喷壶"
	desc = "这是一个浇水壶。科学证明，用浇水壶模拟降雨可以提高植物的生长效率！"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "watering_can"
	inhand_icon_state = "watering_can"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	custom_materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2)
	w_class = WEIGHT_CLASS_NORMAL
	volume = 100
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(20,100)

/obj/item/reagent_containers/cup/watering_can/Initialize(mapload, vol)
	. = ..()
	if(mapload)
		AddElement(/datum/element/swabable, CELL_LINE_TABLE_SNAIL, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/obj/item/reagent_containers/cup/watering_can/wood
	name = "木喷壶"
	desc = "一个老旧的金属浇水壶，但不知何故被拙劣地涂上了油漆，使其看起来像是木制的……"
	icon_state = "watering_can_wood"
	inhand_icon_state = "watering_can_wood"
	volume = 70
	possible_transfer_amounts = list(20,70)

/obj/item/reagent_containers/cup/watering_can/advanced
	desc = "所有植物学家想梦寐以求的喷壶.这个神奇的技术产品可以自己产生水!"
	name = "先进喷壶"
	icon_state = "adv_watering_can"
	inhand_icon_state = "adv_watering_can"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	list_reagents = list(/datum/reagent/water = 100)
	///Refill rate for the watering can
	var/refill_rate = 5
	///Determins what reagent to use for refilling
	var/datum/reagent/refill_reagent = /datum/reagent/water

/obj/item/reagent_containers/cup/watering_can/advanced/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/cup/watering_can/advanced/process(seconds_per_tick)
	///How much to refill
	var/refill_add = min(volume - reagents.total_volume, refill_rate * seconds_per_tick)
	if(refill_add > 0)
		reagents.add_reagent(refill_reagent, refill_add)

/obj/item/reagent_containers/cup/watering_can/advanced/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
