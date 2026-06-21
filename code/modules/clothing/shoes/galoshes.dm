/obj/item/clothing/shoes/galoshes
	desc = "一双黄色橡胶靴，穿上它，能够在湿滑的表面上行走而不被滑倒。"
	name = "胶鞋"
	icon_state = "galoshes"
	inhand_icon_state = "galoshes"
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	slowdown = SHOES_SLOWDOWN+1
	strip_delay = 3 SECONDS
	equip_delay_other = 5 SECONDS
	resistance_flags = NONE
	armor_type = /datum/armor/shoes_galoshes
	can_be_bloody = FALSE
	custom_price = PAYCHECK_CREW * 3
	fastening_type = SHOES_SLIPON
	///How much these boots affect fishing difficulty
	var/fishing_modifier = -3

/obj/item/clothing/shoes/galoshes/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, fishing_modifier)

/obj/item/clothing/shoes/galoshes/dry
	name = "吸水胶鞋"
	desc = "一双紫色的橡胶靴，能防止在潮湿的地面上打滑。"
	icon_state = "galoshes_dry"
	fishing_modifier = -6

/datum/armor/shoes_galoshes
	bio = 100
	fire = 40
	acid = 75

/obj/item/clothing/shoes/galoshes/dry/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_SHOES_STEP_ACTION, PROC_REF(on_step))

/obj/item/clothing/shoes/galoshes/dry/proc/on_step()
	SIGNAL_HANDLER

	var/turf/open/t_loc = get_turf(src)
	SEND_SIGNAL(t_loc, COMSIG_TURF_MAKE_DRY, TURF_WET_WATER, TRUE, INFINITY)
