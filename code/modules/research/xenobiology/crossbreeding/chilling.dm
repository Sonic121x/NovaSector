/*
Chilling extracts:
	Have a unique, primarily defensive effect when
	filled with 10u plasma and activated in-hand.
*/
/obj/item/slimecross/chilling
	name = "冰冷提取物"
	desc = "它摸起来很冷，仿佛已经完全冻住了。"
	effect = "chilling"
	icon_state = "chilling"

/obj/item/slimecross/chilling/Initialize(mapload)
	. = ..()
	create_reagents(10, INJECTABLE | DRAWABLE)

/obj/item/slimecross/chilling/attack_self(mob/user)
	if(!reagents.has_reagent(/datum/reagent/toxin/plasma, 10))
		to_chat(user, span_warning("这个提取物需要充满等离子体才能激活！"))
		return
	reagents.remove_reagent(/datum/reagent/toxin/plasma, 10)
	to_chat(user, span_notice("你挤压提取物，它吸收了等离子体！"))
	playsound(src, 'sound/effects/bubbles/bubbles.ogg', 50, TRUE)
	playsound(src, 'sound/effects/glass/glassbr1.ogg', 50, TRUE)
	do_effect(user)

/obj/item/slimecross/chilling/proc/do_effect(mob/user) //If, for whatever reason, you don't want to delete the extract, don't do ..()
	qdel(src)
	return

/obj/item/slimecross/chilling/grey
	colour = SLIME_TYPE_GREY
	effect_desc = "Creates some slime barrier cubes. When used they create slimy barricades."

/obj/item/slimecross/chilling/grey/do_effect(mob/user)
	user.visible_message(span_notice("[src] 产生了一些小的灰色立方体"))
	for(var/i in 1 to 3)
		new /obj/item/barriercube(get_turf(user))
	..()

/obj/item/slimecross/chilling/orange
	colour = SLIME_TYPE_ORANGE
	effect_desc = "Creates a ring of fire one tile away from the user."

/obj/item/slimecross/chilling/orange/do_effect(mob/user)
	user.visible_message(span_danger("[src] 碎裂了，并喷出一股热流！"))
	for(var/turf/T in orange(get_turf(user),2))
		if(get_dist(get_turf(user), T) > 1)
			new /obj/effect/hotspot(T)
	..()

/obj/item/slimecross/chilling/purple
	colour = SLIME_TYPE_PURPLE
	effect_desc = "Injects everyone in the area with some regenerative jelly."

/obj/item/slimecross/chilling/purple/do_effect(mob/user)
	var/area/user_area = get_area(user)
	if(user_area.outdoors)
		to_chat(user, span_warning("[src] 无法影响如此大的区域。"))
		return
	user.visible_message(span_notice("[src] 碎裂了，一股治疗光环短暂地充满了房间。"))
	for (var/list/zlevel_turfs as anything in user_area.get_zlevel_turf_lists())
		for(var/turf/area_turf as anything in zlevel_turfs)
			for(var/mob/living/carbon/nearby in area_turf)
				nearby.reagents?.add_reagent(/datum/reagent/medicine/regen_jelly,10)
	..()

/obj/item/slimecross/chilling/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Creates a rebreather, a tankless mask."

/obj/item/slimecross/chilling/blue/do_effect(mob/user)
	user.visible_message(span_notice("[src] 裂开，流出液态粘液，重组成了一个面具！"))
	new /obj/item/clothing/mask/nobreath(get_turf(user))
	..()

/obj/item/slimecross/chilling/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Temporarily surrounds the user with unbreakable walls."

/obj/item/slimecross/chilling/metal/do_effect(mob/user)
	user.visible_message(span_danger("[src] 像水银一样融化，并将 [user] 包围在一堵墙里！"))
	for(var/turf/T in orange(get_turf(user),1))
		if(get_dist(get_turf(user), T) > 0)
			new /obj/effect/forcefield/slimewall(T)
	..()

/obj/item/slimecross/chilling/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Recharges the room's APC by 50%."

/obj/item/slimecross/chilling/yellow/do_effect(mob/user)
	var/area/user_area = get_area(user)
	if(isnull(user_area.apc?.cell))
		user.visible_message(span_notice("[src] 碎裂了，但你周围的空气感觉正常。"))
		return

	var/obj/machinery/power/apc/area_apc = user_area.apc
	area_apc.cell.charge = min(area_apc.cell.charge + area_apc.cell.maxcharge / 2, area_apc.cell.maxcharge)
	user.visible_message(span_notice("[src] 碎裂了，空气突然感觉带电了一瞬间。"))
	..()

/obj/item/slimecross/chilling/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Removes all plasma gas in the area."

/obj/item/slimecross/chilling/darkpurple/do_effect(mob/user)
	var/area/A = get_area(get_turf(user))
	if(A.outdoors)
		to_chat(user, span_warning("[src] 无法影响如此大的区域。"))
		return
	var/filtered = FALSE
	for(var/turf/open/T in A.get_turfs_from_all_zlevels())
		var/datum/gas_mixture/G = T.air
		if(istype(G))
			G.assert_gas(/datum/gas/plasma)
			G.gases[/datum/gas/plasma][MOLES] = 0
			filtered = TRUE
			G.garbage_collect()
			T.air_update_turf(FALSE, FALSE)
	if(filtered)
		user.visible_message(span_notice("裂纹遍布 [src]，一些空气被吸了进去！"))
	else
		user.visible_message(span_notice("[src] 裂开了，但什么都没发生。"))
	..()

/obj/item/slimecross/chilling/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Seals the user in a protective block of ice."

/obj/item/slimecross/chilling/darkblue/do_effect(mob/user)
	if(isliving(user))
		user.visible_message(span_notice("[src] 冻结了 [user] 的整个身体！"))
		var/mob/living/M = user
		M.apply_status_effect(/datum/status_effect/frozenstasis)
	..()

/obj/item/slimecross/chilling/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Creates several ration packs."

/obj/item/slimecross/chilling/silver/do_effect(mob/user)
	user.visible_message(span_notice("[src] 碎裂成冰冷的粉末，留下了几份应急食品！"))
	var/amount = rand(5, 10)
	for(var/i in 1 to amount)
		new /obj/item/food/rationpack(get_turf(user))
	..()

/obj/item/slimecross/chilling/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Touching people with this extract adds them to a list, when it is activated it teleports everyone on that list to the user."
	var/list/slimepals = list()
	var/active = FALSE

/obj/item/slimecross/chilling/bluespace/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with) || active)
		return NONE
	user.do_attack_animation(interacting_with)
	if(HAS_TRAIT(interacting_with, TRAIT_NO_TELEPORT))
		to_chat(user, span_warning("[interacting_with] 抵抗与 [src] 建立链接！"))
		return ITEM_INTERACT_BLOCKING
	if(interacting_with in slimepals)
		slimepals -= interacting_with
		to_chat(user, span_notice("你解除了 [src] 与 [interacting_with] 的链接。"))
	else
		slimepals += interacting_with
		to_chat(user, span_notice("你将 [src] 与 [interacting_with] 链接起来。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/chilling/bluespace/do_effect(mob/user)
	if(slimepals.len <= 0)
		to_chat(user, span_warning("[src] 没有与任何人链接！"))
		return
	to_chat(user, span_notice("你感觉到 [src] 脉动起来，开始充能蓝空能量..."))
	active = TRUE
	for(var/mob/living/M in slimepals)
		var/datum/status_effect/slimerecall/S = M.apply_status_effect(/datum/status_effect/slimerecall)
		S.target = user
	if(do_after(user, 10 SECONDS, target=src))
		to_chat(user, span_notice("[src] 碎裂开来，在现实中撕开一个裂口，将链接的个体从虚空中拽了出来！"))
		for(var/mob/living/M in slimepals)
			var/datum/status_effect/slimerecall/S = M.has_status_effect(/datum/status_effect/slimerecall)
			M.remove_status_effect(S)
	else
		to_chat(user, span_warning("[src] 暗淡下去，随着能量消散而化为乌有。"))
		for(var/mob/living/M in slimepals)
			var/datum/status_effect/slimerecall/S = M.has_status_effect(/datum/status_effect/slimerecall)
			if(istype(S))
				S.interrupted = TRUE
				M.remove_status_effect(S)
	..()

/obj/item/slimecross/chilling/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Touching someone with it adds/removes them from a list. Activating the extract stops time for 30 seconds, and everyone on the list is immune, except the user."
	var/list/slimepals = list()

/obj/item/slimecross/chilling/sepia/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	user.do_attack_animation(interacting_with)
	if(interacting_with in slimepals)
		slimepals -= interacting_with
		to_chat(user, span_notice("你解除了 [src] 与 [interacting_with] 的链接。"))
	else
		slimepals += interacting_with
		to_chat(user, span_notice("你将 [src] 与 [interacting_with] 链接起来。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/chilling/sepia/do_effect(mob/user)
	user.visible_message(span_warning("[src] 碎裂，冻结了时间本身！"))
	slimepals -= user //support class
	new /obj/effect/timestop(get_turf(user), 2, 300, slimepals)
	..()

/obj/item/slimecross/chilling/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Creates a flimsy copy of the user, that they control."

/obj/item/slimecross/chilling/cerulean/do_effect(mob/user)
	if(isliving(user))
		user.visible_message(span_warning("[src] 嘎吱作响并转变成了 [user] 的克隆体！"))
		var/mob/living/M = user
		M.apply_status_effect(/datum/status_effect/slime_clone)
	..()

/obj/item/slimecross/chilling/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Creates a pair of Prism Glasses, which allow the wearer to place colored light crystals."

/obj/item/slimecross/chilling/pyrite/do_effect(mob/user)
	user.visible_message(span_notice("[src] 结晶成了一副眼镜！"))
	new /obj/item/clothing/glasses/prism_glasses(get_turf(user))
	..()

/obj/item/slimecross/chilling/red
	colour = SLIME_TYPE_RED
	effect_desc = "Pacifies every slime in your vacinity."

/obj/item/slimecross/chilling/red/do_effect(mob/user)
	var/slimesfound = FALSE
	for(var/mob/living/basic/slime/slime_in_view in view(get_turf(user), 7))
		slimesfound = TRUE
		slime_in_view.set_pacified_behaviour()
	if(slimesfound)
		user.visible_message(span_notice("[src] 碎裂时发出一声平和的鸣响，附近的史莱姆似乎平静了下来。"))
	else
		user.visible_message(span_notice("[src] 碎裂时发出一声平和的鸣响，但什么都没发生..."))
	return ..()

/obj/item/slimecross/chilling/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Creates a bone gun in the hand it is used in, which uses blood as ammo."

/obj/item/slimecross/chilling/green/do_effect(mob/user)
	var/mob/living/L = user
	if(!istype(user))
		return
	var/obj/item/held = L.get_active_held_item() //This should be itself, but just in case...
	L.dropItemToGround(held)
	var/obj/item/gun/magic/bloodchill/gun = new(user)
	if(!L.put_in_hands(gun))
		qdel(gun)
		user.visible_message(span_warning("[src] 瞬间冻结了 [user] 的手臂，使皮肉可怕地开裂！"))
	else
		user.visible_message(span_danger("[src] 冷却并折断了 [user] 手臂前端骨骼，留下了一个奇怪的、枪状的结构！"))
	user.emote("scream")
	L.apply_damage(30, BURN, L.get_active_hand())
	..()

/obj/item/slimecross/chilling/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Creates a slime corgi puppy."

/obj/item/slimecross/chilling/pink/do_effect(mob/user)
	user.visible_message(span_notice("[src] 像鸡蛋一样裂开，一只可爱的小狗滚了出来！"))
	new /mob/living/basic/pet/dog/corgi/puppy/slime(get_turf(user))
	..()

/obj/item/slimecross/chilling/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Produces a golden capture device"

/obj/item/slimecross/chilling/gold/do_effect(mob/user)
	user.visible_message(span_notice("[src] 发出金色的光芒，融化并重组成了一个蛋状的装置！"))
	new /obj/item/capturedevice(get_turf(user))
	..()

/obj/item/slimecross/chilling/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "It creates a weak, but wide-ranged explosion."

/obj/item/slimecross/chilling/oil/do_effect(mob/user)
	user.visible_message(span_danger("[src] 开始以压抑的强度震动！"))
	addtimer(CALLBACK(src, PROC_REF(boom)), 5 SECONDS)

/obj/item/slimecross/chilling/oil/proc/boom()
	explosion(src, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 10, explosion_cause = src) //Large radius, but mostly light damage, and no flash.
	qdel(src)

/obj/item/slimecross/chilling/black
	colour = SLIME_TYPE_BLACK
	effect_desc = "Transforms the user into a golem."

/obj/item/slimecross/chilling/black/do_effect(mob/user)
	if(ishuman(user))
		user.visible_message(span_notice("[src] 沿着 [user] 的皮肤结晶，变成了坚硬的石头！"))
		var/mob/living/carbon/human/H = user
		H.set_species(/datum/species/golem)
	..()

/obj/item/slimecross/chilling/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Creates a Heroine Bud, a special flower that pacifies whoever wears it on their head. They will not be able to take it off without help."

/obj/item/slimecross/chilling/lightpink/do_effect(mob/user)
	user.visible_message(span_notice("[src] 绽放成一朵美丽的花！"))
	new /obj/item/clothing/head/peaceflower(get_turf(user))
	..()

/obj/item/slimecross/chilling/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Solidifies into a set of adamantine armor."

/obj/item/slimecross/chilling/adamantine/do_effect(mob/user)
	user.visible_message(span_notice("[src] 吱嘎作响并碎裂，转变为一套沉重的盔甲！"))
	new /obj/item/clothing/suit/armor/heavy/adamantine(get_turf(user))
	..()

/obj/item/slimecross/chilling/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Makes an unpassable wall in every door in the area."

/obj/item/slimecross/chilling/rainbow/do_effect(mob/user)
	var/area/area = get_area(user)
	if(area.outdoors)
		to_chat(user, span_warning("[src] 无法影响如此大的区域。"))
		return
	user.visible_message(span_warning("[src] 反射出一片令人眼花缭乱的色彩和光芒，能量涌向附近的气闸门！"))
	for (var/list/zlevel_turfs as anything in area.get_zlevel_turf_lists())
		for(var/turf/area_turf as anything in zlevel_turfs)
			for(var/obj/machinery/door/airlock/door in area_turf)
				new /obj/effect/forcefield/slimewall/rainbow(door.loc)
	return ..()
