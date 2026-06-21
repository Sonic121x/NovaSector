///String to access turbine part typepath to upgrade
#define TURBINE_UPGRADE_PART "part"
///String to access turbine part required amount to upgrade
#define TURBINE_UPGRADE_AMOUNT "amount"

/obj/item/turbine_parts
	name = "涡轮机配件"
	desc = "你真的应该呼叫给管理员"
	icon = 'icons/obj/machines/engine/turbine.dmi'
	icon_state = "inlet_compressor"

	///Current part tier
	var/current_tier = TURBINE_PART_TIER_ONE

/obj/item/turbine_parts/examine(mob/user)
	. = ..()
	. += span_notice("这是一个第[current_tier]级涡轮部件，额定转速为[get_tier_value(TURBINE_MAX_RPM)] rpm，额定温度为[get_tier_value(TURBINE_MAX_TEMP)] K。")

	var/list/required_parts = get_tier_upgrades()
	if(length(required_parts))
		var/obj/item/stack/material = required_parts[TURBINE_UPGRADE_PART]
		. += span_notice("可使用[required_parts[TURBINE_UPGRADE_AMOUNT]]张[initial(material.name)]板材进行升级。")
	else
		. += span_notice("已达到最高等级。")

/**
 * Returns the max values of various attributes of this turbine based on its tier
 * param - see code/__DEFINES/turbine_defines/.dm
 */
/obj/item/turbine_parts/proc/get_tier_value(param)
	SHOULD_BE_PURE(TRUE)

	var/max_value = 0
	for(var/_ in 1 to current_tier)
		switch(param)
			if(TURBINE_MAX_RPM)
				if(!max_value)
					max_value = TURBINE_MAX_BASE_RPM
				else
					max_value *= 2.5

			if(TURBINE_MAX_TEMP)
				if(!max_value)
					max_value = 50000
				else
					max_value =  max_value ** 1.2

			if(TURBINE_MAX_EFFICIENCY)
				if(!max_value)
					max_value = 0.25
				else
					max_value += 0.2
	return max_value

///Returns a list containing the typepath & amount of it required to upgrade to the next tier
/obj/item/turbine_parts/proc/get_tier_upgrades()
	PROTECTED_PROC(TRUE)
	SHOULD_BE_PURE(TRUE)
	RETURN_TYPE(/list)

	switch(current_tier)
		if(TURBINE_PART_TIER_ONE)
			return list(TURBINE_UPGRADE_PART = /obj/item/stack/sheet/plasteel, TURBINE_UPGRADE_AMOUNT = 10)
		if(TURBINE_PART_TIER_TWO)
			return list(TURBINE_UPGRADE_PART = /obj/item/stack/sheet/mineral/titanium, TURBINE_UPGRADE_AMOUNT = 10)
		if(TURBINE_PART_TIER_THREE)
			return list(TURBINE_UPGRADE_PART = /obj/item/stack/sheet/mineral/metal_hydrogen, TURBINE_UPGRADE_AMOUNT = 5)

/obj/item/turbine_parts/item_interaction(mob/living/user, obj/item/attacking_item, list/modifiers)
	. = NONE

	var/list/required_parts = get_tier_upgrades()
	if(!length(required_parts))
		balloon_alert(user, "已达最高等级！")
		return ITEM_INTERACT_FAILURE

	var/obj/item/stack/sheet/material = attacking_item
	if(!istype(material, required_parts[TURBINE_UPGRADE_PART]))
		balloon_alert(user, "零件不匹配！")
		return ITEM_INTERACT_FAILURE

	var/amount = required_parts[TURBINE_UPGRADE_AMOUNT]
	if(material.amount < amount)
		balloon_alert(user, "需要 [amount] 张板材！")
		return ITEM_INTERACT_FAILURE

	if(do_after(user, current_tier SECONDS, src) && material.use(amount))
		current_tier += 1
		return ITEM_INTERACT_SUCCESS

/obj/item/turbine_parts/compressor
	name = "压缩机配件"
	desc = "安装一台涡轮引擎压缩机以提升性能"
	icon_state = "compressor_part"

/obj/item/turbine_parts/rotor
	name = "转子配件"
	desc = "安装一个涡轮引擎转子以提升性能"
	icon_state = "rotor_part"

/obj/item/turbine_parts/stator
	name = "定子配件"
	desc = "安装一台涡轮引擎涡轮机以提升性能"
	icon_state = "stator_part"

/obj/item/turbine_parts/stator/get_tier_value(param)
	if(param == TURBINE_MAX_EFFICIENCY)
		var/max_value = 0
		for(var/_ in 1 to current_tier)
			if(!max_value)
				max_value = 0.85
			else
				max_value += 0.015
		return max_value

	return ..()

/obj/item/turbine_parts/stator/get_tier_upgrades()
	switch(current_tier)
		if(TURBINE_PART_TIER_ONE)
			return list(TURBINE_UPGRADE_PART = /obj/item/stack/sheet/mineral/titanium, TURBINE_UPGRADE_AMOUNT = 15)
		if(TURBINE_PART_TIER_TWO)
			return list(TURBINE_UPGRADE_PART = /obj/item/stack/sheet/mineral/metal_hydrogen, TURBINE_UPGRADE_AMOUNT = 15)
		if(TURBINE_PART_TIER_THREE)
			return list(TURBINE_UPGRADE_PART = /obj/item/stack/sheet/mineral/zaukerite, TURBINE_UPGRADE_AMOUNT = 10)

#undef TURBINE_UPGRADE_PART
#undef TURBINE_UPGRADE_AMOUNT
