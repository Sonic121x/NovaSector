/*
Slimecrossing Potions
	Potions added by the slimecrossing system.
	Collected here for clarity.
*/

//Extract cloner - Charged Grey
/obj/item/slimepotion/extract_cloner
	name = "提取克隆药水"
	desc = "一种更强效的提取增强药剂，能够复制普通的史莱姆提取物。"
	icon_state = "potgold"

/obj/item/slimepotion/extract_cloner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(istype(interacting_with, /obj/item/slimecross))
		to_chat(user, span_warning("[interacting_with]过于复杂，药水无法克隆！"))
		return ITEM_INTERACT_BLOCKING
	if(!istype(interacting_with, /obj/item/slime_extract))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/slime_extract/S = interacting_with
	if(S.recurring)
		to_chat(user, span_warning("[interacting_with]过于复杂，药水无法克隆！"))
		return ITEM_INTERACT_BLOCKING
	var/path = S.type
	var/obj/item/slime_extract/C = new path(get_turf(interacting_with))
	C.extract_uses = S.extract_uses
	to_chat(user, span_notice("你将药水倒在[interacting_with]上，液体凝固成了它的复制品！"))
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Peace potion - Charged Light Pink
/obj/item/slimepotion/peacepotion
	name = "平定药水"
	desc = "一种浅粉色的化学品溶液，闻起来如液态平和。还有汞盐的气味。"
	icon_state = "potlightpink"

/obj/item/slimepotion/peacepotion/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	var/mob/living/peace_target = interacting_with
	if(!isliving(peace_target) || peace_target.stat == DEAD)
		to_chat(user, span_warning("[src]只对活物有效。"))
		return ITEM_INTERACT_BLOCKING
	if(ismegafauna(peace_target))
		to_chat(user, span_warning("[src]对纯粹的邪恶存在无效！"))
		return ITEM_INTERACT_BLOCKING
	if(peace_target != user)
		peace_target.visible_message(span_danger("[user]开始给[peace_target]喂食[src]！"),
			span_userdanger("[user]开始给你喂食[src]！"))
	else
		peace_target.visible_message(span_danger("[user]开始饮用[src]！"),
			span_danger("你开始饮用[src]！"))

	if(!do_after(user, 10 SECONDS, target = peace_target))
		return ITEM_INTERACT_BLOCKING
	if(peace_target != user)
		to_chat(user, span_notice("你给[peace_target]喂食了[src]！"))
	else
		to_chat(user, span_warning("你饮用了[src]！"))
	if(isanimal_or_basicmob(peace_target))
		ADD_TRAIT(peace_target, TRAIT_PACIFISM, MAGIC_TRAIT)
	else if(iscarbon(peace_target))
		var/mob/living/carbon/peaceful_carbon = peace_target
		peaceful_carbon.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_SURGERY)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Love potion - Charged Pink
/obj/item/slimepotion/lovepotion
	name = "爱情药水"
	desc = "一种据信能激发爱意的粉色化学混合物。"
	icon_state = "potpink"

/obj/item/slimepotion/lovepotion/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	var/mob/living/love_target = interacting_with
	if(!isliving(love_target) || love_target.stat == DEAD)
		to_chat(user, span_warning("爱情药水只对活物有效，变态！"))
		return ITEM_INTERACT_BLOCKING
	if(ismegafauna(love_target))
		to_chat(user, span_warning("爱情药水对纯粹的邪恶存在无效！"))
		return ITEM_INTERACT_BLOCKING
	if(user == love_target)
		to_chat(user, span_warning("你不能喝爱情药水。你是什么，自恋狂吗？"))
		return ITEM_INTERACT_BLOCKING
	if(love_target.has_status_effect(/datum/status_effect/in_love))
		to_chat(user, span_warning("[love_target] 已经陷入爱河了！"))
		return ITEM_INTERACT_BLOCKING

	love_target.visible_message(span_danger("[user] 开始给 [love_target] 喂爱情药水！"),
		span_userdanger("[user] 开始给你喂爱情药水！"))

	if(!do_after(user, 5 SECONDS, target = love_target))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你给 [love_target] 喂下了爱情药水！"))
	to_chat(love_target, span_notice("你对 [user] 产生了感情，并且对 [user.p_they()] 喜欢的人[user.p_s()]也是如此。"))
	love_target.add_ally(user)
	love_target.apply_status_effect(/datum/status_effect/in_love, user)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Pressure potion - Charged Dark Blue
/obj/item/slimepotion/spaceproof
	name = "史莱姆增压药水"
	desc = "一种强效化学密封剂，可使任何衣物变得完全气密。可使用两次。"
	icon_state = "potblack"
	var/uses = 2

/obj/item/slimepotion/spaceproof/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(uses <= 0)
		qdel(src)
		return ITEM_INTERACT_BLOCKING
	var/obj/item/clothing/clothing = interacting_with
	if(!istype(clothing))
		to_chat(user, span_warning("这种药水只能用在衣物上！"))
		return ITEM_INTERACT_BLOCKING
	if(istype(clothing, /obj/item/clothing/suit/space))
		to_chat(user, span_warning("这件 [interacting_with] 已经具有压力抗性了！"))
		return ITEM_INTERACT_BLOCKING
	if(clothing.min_cold_protection_temperature == SPACE_SUIT_MIN_TEMP_PROTECT && (clothing.clothing_flags & STOPSPRESSUREDAMAGE))
		to_chat(user, span_warning("这件 [interacting_with] 已经具有压力抗性了！"))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你将蓝色粘液涂抹在 [clothing] 上，使其变得气密。"))
	clothing.name = "压力抗性 [clothing.name]"
	clothing.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	clothing.add_atom_colour(color_transition_filter(COLOR_NAVY, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	clothing.min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing.cold_protection = clothing.body_parts_covered
	clothing.clothing_flags |= STOPSPRESSUREDAMAGE
	uses--
	if(uses <= 0)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

//Enhancer potion - Charged Cerulean
/obj/item/slimepotion/enhancer/max
	name = "提取最大化药"
	desc = "一种效力极强的化学混合物，能使史莱姆提取物的使用次数达到最大化。"
	icon_state = "potcerulean"

//Lavaproofing potion - Charged Red
/obj/item/slimepotion/lavaproof
	name = "史莱姆防熔岩药水"
	desc = "一种奇怪的微红色粘稠物，据说能像排斥水一样排斥熔岩，但不降低可燃性。有两个用途。"
	icon_state = "potyellow"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	var/uses = 2

/obj/item/slimepotion/lavaproof/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(uses <= 0)
		qdel(src)
		return ITEM_INTERACT_BLOCKING
	if(!isitem(interacting_with))
		to_chat(user, span_warning("你不能用防熔岩流体覆盖这个物品！"))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/clothing = interacting_with
	to_chat(user, span_notice("你将红色粘液涂抹在 [clothing] 上，使其变得防熔岩。"))
	clothing.name = "防熔岩 [clothing.name]"
	clothing.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	clothing.add_atom_colour(color_transition_filter(COLOR_MAROON, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	clothing.resistance_flags |= LAVA_PROOF
	if (isclothing(clothing))
		var/obj/item/clothing/clothing_real = clothing
		clothing_real.clothing_flags |= LAVAPROTECT
		clothing_real.resistance_flags |= FIRE_PROOF
	uses--
	if(uses <= 0)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

//Revival potion - Charged Grey
/obj/item/slimepotion/slime_reviver
	name = "史莱姆复活药水"
	desc = "注入了等离子体并经过压缩处理的这种物质能够使死去的黏液生物复活。"
	icon_state = "potgrey"

/obj/item/slimepotion/slime_reviver/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	var/mob/living/basic/slime/revive_target = interacting_with
	if(!isslime(revive_target))
		to_chat(user, span_warning("这种药水只对史莱姆有效！"))
		return ITEM_INTERACT_BLOCKING
	if(revive_target.stat != DEAD)
		to_chat(user, span_warning("这只史莱姆还活着！"))
		return ITEM_INTERACT_BLOCKING
	if(revive_target.maxHealth <= 0)
		to_chat(user, span_warning("这只史莱姆太不稳定，无法复活！"))
		return ITEM_INTERACT_BLOCKING
	user.do_attack_animation(interacting_with)
	revive_target.revive(HEAL_ALL)
	revive_target.set_stat(CONSCIOUS)
	revive_target.visible_message(span_notice("[revive_target] 充满了新的活力，眨眼间醒了过来！"))
	revive_target.maxHealth -= 10 //Revival isn't healthy.
	revive_target.health -= 10
	revive_target.regenerate_icons()
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Stabilizer potion - Charged Blue
/obj/item/slimepotion/slime/chargedstabilizer
	name = "史莱姆稳定剂"
	desc = "一种效力极强的化学混合物，能完全阻止史莱姆发生突变。"
	icon_state = "potcyan"

/obj/item/slimepotion/slime/chargedstabilizer/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	if(interacting_slime.stat)
		to_chat(user, span_warning("这只史莱姆已经死了！"))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.mutation_chance == 0)
		to_chat(user, span_warning("这只史莱姆已经没有变异的可能性了！"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("你给史莱姆喂下了全能稳定剂。它在这个周期内不会变异了！"))
	interacting_slime.mutation_chance = 0
	qdel(src)
	return ITEM_INTERACT_SUCCESS
