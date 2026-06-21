
///apply a bunch of fire immunity effect to clothing
/datum/religion_rites/fireproof/proc/apply_fireproof(obj/item/clothing/fireproofed)
	fireproofed.name = "不熔 [fireproofed.name]"
	fireproofed.max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	fireproofed.heat_protection = chosen_clothing.body_parts_covered
	fireproofed.resistance_flags |= FIRE_PROOF

/datum/religion_rites/fireproof
	name = "不熔防护"
	desc = "赋予任何一件衣物防火免疫。"
	ritual_length = 12 SECONDS
	ritual_invocations = list("And so to support the holder of the Ever-Burning candle ...",
	"... allow this unworthy apparel to serve you ...",
	"... make it strong enough to burn a thousand times and more ...")
	invoke_msg = "... Come forth in your new form, and join the unmelting wax of the one true flame!"
	favor_cost = 700
///the piece of clothing that will be fireproofed, only one per rite
	var/obj/item/clothing/chosen_clothing

/datum/religion_rites/fireproof/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/clothing/apparel in get_turf(religious_tool))
		if(apparel.max_heat_protection_temperature >= FIRE_IMMUNITY_MAX_TEMP_PROTECT)
			continue //we ignore anything that is already fireproof
		chosen_clothing = apparel //the apparel has been chosen by our lord and savior
		return ..()
	return FALSE

/datum/religion_rites/fireproof/invoke_effect(mob/living/user, atom/religious_tool)
	..()
	if(!QDELETED(chosen_clothing) && get_turf(religious_tool) == chosen_clothing.loc) //check if the same clothing is still there
		if(istype(chosen_clothing,/obj/item/clothing/suit/hooded))
			for(var/obj/item/clothing/head/integrated_helmet in chosen_clothing.contents) //check if the clothing has a hood/helmet integrated and fireproof it if there is one.
				apply_fireproof(integrated_helmet)
		apply_fireproof(chosen_clothing)
		playsound(get_turf(religious_tool), 'sound/effects/magic/fireball.ogg', 50, TRUE)
		chosen_clothing = null //our lord and savior no longer cares about this apparel
		return TRUE
	chosen_clothing = null
	to_chat(user, span_warning("为仪式选择的衣物已不在祭坛上！"))
	return FALSE


/datum/religion_rites/burning_sacrifice
	name = "燃烧献祭"
	desc = "献祭一个被束缚的燃烧中或焦化的尸体以获得恩惠，尸体受到的燃烧伤害越高，你获得的恩惠就越多。"
	ritual_length = 15 SECONDS
	ritual_invocations = list("Burning body ...",
	"... cleansed by the flame ...",
	"... we were all created from fire ...",
	"... and to it ...")
	invoke_msg = "... WE RETURN! "
///the burning corpse chosen for the sacrifice of the rite
	var/mob/living/carbon/chosen_sacrifice

/datum/religion_rites/burning_sacrifice/perform_rite(mob/living/user, atom/religious_tool)
	if(!ismovable(religious_tool))
		to_chat(user, span_warning("此仪式需要一个能将个体束缚其上的宗教装置。"))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	if(!LAZYLEN(movable_reltool.buckled_mobs))
		to_chat(user, span_warning("祭坛上没有任何被束缚的东西！"))
		return FALSE
	for(var/corpse in movable_reltool.buckled_mobs)
		if(!iscarbon(corpse))// only works with carbon corpse since most normal mobs can't be set on fire.
			to_chat(user, span_warning("只有碳基生命体才能被正确燃烧以用于献祭！"))
			return FALSE
		chosen_sacrifice = corpse
		if(chosen_sacrifice.stat != DEAD)
			to_chat(user, span_warning("你只能献祭死去的尸体，这个还活着！"))
			return FALSE
		if(!chosen_sacrifice.on_fire && !HAS_TRAIT_FROM(chosen_sacrifice, TRAIT_HUSK, BURN))
			to_chat(user, span_warning("这具尸体需要处于燃烧或焦化状态才能被献祭！"))
			return FALSE
		return ..()

/datum/religion_rites/burning_sacrifice/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	if(!(chosen_sacrifice in religious_tool.buckled_mobs)) //checks one last time if the right corpse is still buckled
		to_chat(user, span_warning("正确的祭品已不在祭坛上！"))
		chosen_sacrifice = null
		return FALSE
	if(!chosen_sacrifice.on_fire && !HAS_TRAIT_FROM(chosen_sacrifice, TRAIT_HUSK, BURN))
		to_chat(user, span_warning("祭品必须处于燃烧或焦化状态才能完成仪式的最后部分！"))
		chosen_sacrifice = null
		return FALSE
	if(chosen_sacrifice.stat != DEAD)
		to_chat(user, span_warning("祭品必须保持死亡状态，仪式才能生效！"))
		chosen_sacrifice = null
		return FALSE
	var/favor_gained = 100 + round(chosen_sacrifice.get_fire_loss())
	GLOB.religious_sect.adjust_favor(favor_gained, user)
	to_chat(user, span_notice("[GLOB.deity]吸收了焦黑的尸体以及随之而来的所有火焰。[GLOB.deity]奖励你[favor_gained]点恩惠。"))
	chosen_sacrifice.dust(force = TRUE)
	playsound(get_turf(religious_tool), 'sound/effects/supermatter.ogg', 50, TRUE)
	chosen_sacrifice = null
	return TRUE

/datum/religion_rites/infinite_candle
	name = "不朽蜡烛"
	desc = "创造5支永不耗尽蜡的蜡烛。"
	ritual_length = 10 SECONDS
	invoke_msg = "Burn bright, little candles, for you will only extinguish along with the universe."
	favor_cost = 200

/datum/religion_rites/infinite_candle/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	for(var/i in 1 to 5)
		new /obj/item/flashlight/flare/candle/infinite(altar_turf)
	playsound(altar_turf, 'sound/effects/magic/fireball.ogg', 50, TRUE)
	return TRUE

/datum/religion_rites/blazing_star
	name = "炽焰之星"
	desc = "为圣箭附魔，使其在击中时点燃目标，或者如果受害者已经着火……注意，这会消耗掉箭矢。"
	ritual_length = 15 SECONDS
	ritual_invocations = list(
		"And so to keep the Ever-Burning candle protected ...",
		"... grant this feeble bolt your blessing ...",
		"... make it burn bright ...",
	)
	invoke_msg = "... a blazing star is born!"
	favor_cost = 1500
	///arrow to enchant
	var/obj/item/ammo_casing/arrow/holy/enchant_target

/datum/religion_rites/blazing_star/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/ammo_casing/arrow/holy/can_enchant in get_turf(religious_tool))
		if(istype(can_enchant, /obj/item/ammo_casing/arrow/holy/blazing))
			continue
		enchant_target = can_enchant
		return ..()
	to_chat(user, span_warning("你需要将一支圣箭放在[religious_tool]上才能进行此操作！"))
	return FALSE

/datum/religion_rites/blazing_star/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/ammo_casing/arrow/holy/enchanting = enchant_target
	var/turf/tool_turf = get_turf(religious_tool)
	enchant_target = null
	if(QDELETED(enchanting) || !(tool_turf == enchanting.loc)) //check if the arrow is still there
		to_chat(user, span_warning("你的目标离开了祭坛！"))
		return FALSE
	enchanting.visible_message(span_notice("[enchant_target]被圣火祝福了！"))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)
	new /obj/item/ammo_casing/arrow/holy/blazing(tool_turf)
	qdel(enchanting)
	return TRUE
