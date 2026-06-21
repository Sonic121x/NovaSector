
#define BEEBOX_MAX_FRAMES 3 //Max frames per box
#define BEES_RATIO 0.5 //Multiplied by the max number of honeycombs to find the max number of bees
#define BEE_PROB_NEW_BEE 20 //The chance for spare bee_resources to be turned into new bees
#define BEE_RESOURCE_HONEYCOMB_COST 100 //The amount of bee_resources for a new honeycomb to be produced, percentage cost 1-100
#define BEE_RESOURCE_NEW_BEE_COST 50 //The amount of bee_resources for a new bee to be produced, percentage cost 1-100



/mob/proc/bee_friendly()
	return 0



/mob/living/carbon/human/bee_friendly()
	if(ispodperson(src)) //bees pollinate plants, duh.
		return 1
	if (wear_suit && head && isclothing(wear_suit) && isclothing(head))
		var/obj/item/clothing/suit = wear_suit
		var/obj/item/clothing/hat = head
		if (suit.clothing_flags & hat.clothing_flags & THICKMATERIAL)
			return 1
	return 0


/obj/structure/beebox
	name = "蜂箱"
	desc = "米尔斯·曼纳斯博士白天只是个普通的以黄蜂为主题的超级英雄，但到了晚上，他就会变成“蜜蜂博士”！"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "beebox"
	anchored = TRUE
	density = TRUE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 40)
	var/mob/living/basic/bee/queen/queen_bee = null
	var/list/bees = list() //bees owned by the box, not those inside it
	var/list/honeycombs = list()
	var/list/honey_frames = list()
	var/bee_resources = 0


/obj/structure/beebox/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)


/obj/structure/beebox/Destroy()
	STOP_PROCESSING(SSobj, src)
	queen_bee = null
	QDEL_LIST(bees)
	QDEL_LIST(honey_frames)
	QDEL_LIST(honeycombs)
	return ..()


//Premade apiaries can spawn with a random reagent
/obj/structure/beebox/premade
	var/random_reagent = FALSE


/obj/structure/beebox/premade/Initialize(mapload)
	. = ..()

	icon_state = "beebox"
	var/datum/reagent/custom_reagent = null
	if(random_reagent)
		custom_reagent = get_random_reagent_id()
		custom_reagent = GLOB.chemical_reagents_list[custom_reagent]

	queen_bee = new(src)
	queen_bee.beehome = src
	bees += queen_bee
	queen_bee.assign_reagent(custom_reagent)

	for(var/i in 1 to BEEBOX_MAX_FRAMES)
		var/obj/item/honey_frame/new_frame = new(src)
		honey_frames += new_frame

	for(var/i in 1 to get_max_bees())
		var/mob/living/basic/bee/new_bee = new(src)
		bees += new_bee
		new_bee.beehome = src
		new_bee.assign_reagent(custom_reagent)


/obj/structure/beebox/premade/random
	icon_state = "random_beebox"
	random_reagent = TRUE


/obj/structure/beebox/process()
	if(queen_bee)
		if(bee_resources >= BEE_RESOURCE_HONEYCOMB_COST)
			if(honeycombs.len < get_max_honeycomb())
				bee_resources = max(bee_resources-BEE_RESOURCE_HONEYCOMB_COST, 0)
				var/obj/item/food/honeycomb/new_comb = new(src)
				if(queen_bee.beegent)
					new_comb.set_reagent(queen_bee.beegent.type)
				honeycombs += new_comb

		if(bees.len < get_max_bees())
			var/freebee = FALSE //a freebee, geddit?, hahaha HAHAHAHA
			if(bees.len <= 1) //there's always one set of worker bees, this isn't colony collapse disorder its 2d spessmen
				freebee = TRUE
			if((bee_resources >= BEE_RESOURCE_NEW_BEE_COST && prob(BEE_PROB_NEW_BEE)) || freebee)
				if(!freebee)
					bee_resources = max(bee_resources - BEE_RESOURCE_NEW_BEE_COST, 0)
				var/mob/living/basic/bee/new_bee = new(get_turf(src))
				new_bee.beehome = src
				new_bee.assign_reagent(queen_bee.beegent)
				bees += new_bee


/obj/structure/beebox/proc/get_max_honeycomb()
	. = 0
	for(var/obj/item/honey_frame/frame as anything in honey_frames)
		. += frame.honeycomb_capacity


/obj/structure/beebox/proc/get_max_bees()
	. = get_max_honeycomb() * BEES_RATIO


/obj/structure/beebox/examine(mob/user)
	. = ..()

	if(!queen_bee)
		. += span_warning("没有蜂后！没有蜂后就不会有蜂巢！")

	var/half_bee = get_max_bees()*0.5
	if(half_bee && (bees.len >= half_bee))
		. += span_notice("这里嗡嗡作响，热闹非凡...有很多蜜蜂！")

	. += span_notice("[bee_resources]/100 资源储备。")
	. += span_notice("[bee_resources]% 进度可生成新蜂巢。")
	. += span_notice("[bee_resources*2]% 进度可生成新蜜蜂。")

	if(honeycombs.len)
		var/plural = honeycombs.len > 1
		. += span_notice("There [plural? "are" : "is"] [honeycombs.len] uncollected honeycomb[plural ? "s":""] in the apiary.")

	if(honeycombs.len >= get_max_honeycomb())
		. += span_warning("没有空间容纳更多蜂巢了！")

/obj/structure/beebox/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/beebox/attackby(obj/item/item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(item, /obj/item/honey_frame))
		var/obj/item/honey_frame/frame = item
		if(honey_frames.len < BEEBOX_MAX_FRAMES)
			visible_message(span_notice("[user] 向蜂箱添加了一个框架。"))
			if(!user.transferItemToLoc(frame, src))
				return
			honey_frames += frame
		else
			to_chat(user, span_warning("蜂箱里没有空间容纳更多框架了！"))
		return

	if(istype(item, /obj/item/queen_bee))
		if(queen_bee)
			to_chat(user, span_warning("这个蜂巢已经有蜂后了！"))
			return

		var/obj/item/queen_bee/new_queen = item
		user.temporarilyRemoveItemFromInventory(new_queen)

		bees += new_queen.queen
		queen_bee = new_queen.queen

		new_queen.queen.forceMove(src)

		if(queen_bee)
			visible_message(span_notice("[user] 将 [queen_bee] 放入蜂箱，使其成为它们的新家。"))
			var/relocated = 0
			for(var/mob/living/basic/bee/relocating_bee as anything in bees)
				if(relocating_bee.reagent_incompatible(queen_bee))
					bees -= relocating_bee
					relocating_bee.beehome = null
					if(relocating_bee.loc == src)
						relocating_bee.forceMove(drop_location())
					relocated++
			if(relocated)
				to_chat(user, span_warning("这只蜂后与居住在此的一些蜜蜂携带不同的化学物质，那些蜜蜂将不会返回这个蜂箱！"))

		else
			to_chat(user, span_warning("蜂后消失了！最近新闻里常有蜜蜂失踪的事件..."))

		return

	..()

/obj/structure/beebox/interact(mob/user)
	. = ..()
	if(!user.bee_friendly())
		//Time to get stung!
		var/bees_attack = FALSE
		for(var/mob/living/basic/bee/worker as anything in bees) //everyone who's ever lived here now instantly hates you, suck it assistant!
			if(worker.is_queen)
				continue
			if(worker.loc == src)
				worker.forceMove(drop_location())
			bees_attack = TRUE
		if(bees_attack)
			visible_message(span_danger("[user] 惊扰了蜜蜂！"))
		else
			visible_message(span_danger("[user] disturbs \the [src] to no effect!"))
	else
		var/option = tgui_alert(user, "你想移除哪个部件？", "蜂箱调整", list("Honey Frame", "Queen Bee"))
		if(!option || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, NEED_DEXTERITY))
			return
		switch(option)
			if("Honey Frame")
				if(!honey_frames.len)
					to_chat(user, span_warning("没有蜜脾可以移除！"))
					return

				var/obj/item/honey_frame/frame = pick_n_take(honey_frames)
				if(frame)
					if(!user.put_in_active_hand(frame))
						frame.forceMove(drop_location())
					visible_message(span_notice("[user] 从蜂箱中取出了一个巢框。"))

					var/amtH = frame.honeycomb_capacity
					var/fallen = 0
					while(honeycombs.len && amtH) //let's pretend you always grab the frame with the most honeycomb on it
						var/obj/item/food/honeycomb/comb = pick_n_take(honeycombs)
						if(comb)
							comb.forceMove(drop_location())
							amtH--
							fallen++
					if(fallen)
						var/multiple = fallen > 1
						visible_message(span_notice("[user] 从框架上刮下了[multiple ? "[fallen]" : "a"]蜂巢[multiple ? "s" : ""]。"))

			if("Queen Bee")
				if(!queen_bee || queen_bee.loc != src)
					to_chat(user, span_warning("没有蜂后可以移除！"))
					return
				var/obj/item/queen_bee/queen = new()
				queen_bee.forceMove(queen)
				bees -= queen_bee
				queen.queen = queen_bee
				queen.name = queen_bee.name
				if(!user.put_in_active_hand(queen))
					queen.forceMove(drop_location())
				visible_message(span_notice("[user] 从蜂箱中移除了蜂后。"))
				queen_bee = null

/obj/structure/beebox/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood (loc, 20)
	for(var/mob/living/basic/bee/worker as anything in bees)
		if(worker.loc == src)
			worker.forceMove(get_turf(src))
		bees -= worker
		worker.beehome = null
	for(var/obj/item/honey_frame/frame as anything in honey_frames)
		if(frame.loc == src)
			frame.forceMove(get_turf(src))
		honey_frames -= frame

/obj/structure/beebox/unwrenched
	anchored = FALSE

/obj/structure/beebox/proc/habitable(mob/living/basic/target)
	if(!istype(target, /mob/living/basic/bee))
		return FALSE
	var/mob/living/basic/bee/citizen = target
	if(citizen.reagent_incompatible(queen_bee) || bees.len >= get_max_bees())
		return FALSE
	return TRUE

#undef BEE_PROB_NEW_BEE
#undef BEE_RESOURCE_HONEYCOMB_COST
#undef BEE_RESOURCE_NEW_BEE_COST
#undef BEEBOX_MAX_FRAMES
#undef BEES_RATIO
