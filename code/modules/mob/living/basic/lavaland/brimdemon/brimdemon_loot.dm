/// Reagent pool left by dying brimdemon
/obj/effect/decal/cleanable/brimdust
	name = "狱炎尘"
	desc = "来自狱炎恶魔的尘埃。因其对植物学的助益而被视为有价值之物。"
	icon_state = "brimdust"
	icon = 'icons/obj/mining.dmi'
	plane = GAME_PLANE
	layer = CLEANABLE_OBJECT_LAYER
	mergeable_decal = FALSE
	decal_reagent = /datum/reagent/brimdust
	reagent_amount = 15

/// Ashwalker ore sensor crafted from brimdemon ash
/obj/item/ore_sensor
	name = "矿石传感器"
	desc = "这个耳戴式工具利用恶魔频率来探测附近地形中的矿石。"
	icon_state = "oresensor"
	icon = 'icons/obj/mining.dmi'
	slot_flags = ITEM_SLOT_EARS
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)
	var/range = 5
	var/cooldown = 4 SECONDS //between the standard and the advanced ore scanner in strength
	COOLDOWN_DECLARE(ore_sensing_cooldown)

/obj/item/ore_sensor/equipped(mob/user, slot, initial)
	. = ..()
	if(slot & ITEM_SLOT_EARS)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/ore_sensor/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/ore_sensor/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, ore_sensing_cooldown))
		return
	COOLDOWN_START(src, ore_sensing_cooldown, cooldown)
	mineral_scan_pulse(get_turf(src), range, src)
