///////////////////////////////////
////////  Mecha wreckage   ////////
///////////////////////////////////


/obj/structure/mecha_wreckage
	name = "机甲残骸"
	desc = "一些不幸的机甲残骸。完全无法挽回，但也许还能回收些什么."
	icon = 'icons/mob/rideables/mecha.dmi'
	density = TRUE
	anchored = FALSE
	opacity = FALSE
	var/list/welder_salvage = list(/obj/item/stack/sheet/plasteel, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	var/salvage_num = 5
	var/list/crowbar_salvage = list()
	var/wires_removed = FALSE
	var/mob/living/silicon/ai/AI //AIs to be salvaged
	var/list/parts

/obj/structure/mecha_wreckage/Initialize(mapload, mob/living/silicon/ai/AI_pilot)
	. = ..()
	if(parts)
		for(var/i in 1 to 2)
			if(!parts.len)
				break
			if(prob(60))
				continue
			var/part = pick(parts)
			welder_salvage += part
		parts = null
	if(!AI_pilot) //Type-checking for this is already done in mecha/Destroy()
		return
	AI = AI_pilot
	AI.apply_damage(150, BURN) //Give the AI a bit of damage from the "shock" of being suddenly shut down
	INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon, death)) //The damage is not enough to kill the AI, but to be 'corrupted files' in need of repair.
	AI.forceMove(src) //Put the dead AI inside the wreckage for recovery
	add_overlay(mutable_appearance('icons/obj/weapons/guns/projectiles.dmi', "green_laser")) //Overlay for the recovery beacon
	AI.controlled_equipment = null
	AI.remote_control = null

/obj/structure/mecha_wreckage/Destroy()
	if(AI)
		QDEL_NULL(AI)
	QDEL_LIST(crowbar_salvage)
	src.visible_message(span_danger("[src]的超结构向内折叠，坍塌成一堆无法回收的废料！"))
	playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	for(var/mob/living/witness in range(2, src))
		shake_camera(witness, 2, 1)
	new /obj/effect/decal/cleanable/blood/gibs/robot_debris(get_turf(src))
	return ..()

/obj/structure/mecha_wreckage/examine(mob/user)
	. = ..()
	if(!AI)
		return
	. += span_notice("AI回收信标已激活。")

/obj/structure/mecha_wreckage/welder_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(salvage_num <= 0 || !length(welder_salvage))
		to_chat(user, span_notice("你没看到任何能用[I]切割的东西！"))
		return
	if(!I.use_tool(src, user, 0, volume=50))
		return
	if(prob(30))
		to_chat(user, span_notice("你未能从[src]中抢救出任何有价值的东西！"))
		return
	var/type = pick(welder_salvage)
	var/N = new type(get_turf(user))
	user.visible_message(span_notice("[user]从[src]上切下了[N]。"), span_notice("你从[src]上切下了[N]。"))
	if(!isstack(N))
		welder_salvage -= type
	salvage_num--

/obj/structure/mecha_wreckage/wirecutter_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(wires_removed)
		to_chat(user, span_notice("你没看到任何能用[I]切割的东西！"))
		return
	var/N = new /obj/item/stack/cable_coil(get_turf(user), rand(1,3))
	user.visible_message(span_notice("[user]从[src]上切下了[N]。"), span_notice("你从[src]上切下了[N]。"))
	wires_removed = TRUE

/obj/structure/mecha_wreckage/crowbar_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(crowbar_salvage.len)
		var/obj/S = pick(crowbar_salvage)
		S.forceMove(user.drop_location())
		user.visible_message(span_notice("[user]从[src]上撬下了[S]。"), span_notice("你从[src]上撬下了[S]。"))
		crowbar_salvage -= S
		return
	to_chat(user, span_notice("你没看到任何能用[I]撬动的东西！"))

/obj/structure/mecha_wreckage/transfer_ai(interaction, mob/user, mob/living/silicon/ai/ai_mob, obj/item/aicard/card)
	if(!..())
		return

	//Proc called on the wreck by the AI card.
	if(interaction != AI_TRANS_TO_CARD) //AIs can only be transferred in one direction, from the wreck to the card.
		return
	if(!AI) //No AI in the wreck
		to_chat(user, span_warning("未找到AI备份。"))
		return
	cut_overlays() //Remove the recovery beacon overlay
	AI.forceMove(card) //Move the dead AI to the card.
	card.AI = AI
	if(AI.client) //AI player is still in the dead AI and is connected
		to_chat(AI, span_notice("你文件系统的残留部分已在一个移动存储设备上恢复。"))
	else //Give the AI a heads-up that it is probably going to get fixed.
		AI.notify_revival("You have been recovered from the wreckage!", source = card)
	to_chat(user, "[span_boldnotice("Backup files recovered")]: [AI.name] ([rand(1000,9999)].exe) salvaged from [name] and stored within local memory.")
	AI = null

/obj/structure/mecha_wreckage/gygax
	name = "\improper Gygax-吉加斯残骸"
	icon_state = "gygax-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/gold, /obj/item/stack/sheet/mineral/silver, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	parts = list(
				/obj/item/mecha_parts/part/gygax_torso,
				/obj/item/mecha_parts/part/gygax_head,
				/obj/item/mecha_parts/part/gygax_left_arm,
				/obj/item/mecha_parts/part/gygax_right_arm,
				/obj/item/mecha_parts/part/gygax_left_leg,
				/obj/item/mecha_parts/part/gygax_right_leg
				)

/obj/structure/mecha_wreckage/gygax/dark
	name = "\improper Dark Gygax-暗黑吉加斯残骸"
	icon_state = "darkgygax-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/plastitanium, /obj/item/stack/sheet/iron, /obj/item/stack/rods)

/obj/structure/mecha_wreckage/marauder
	name = "\improper Marauder-掠夺者残骸"
	icon_state = "marauder-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/titanium, /obj/item/stack/sheet/iron, /obj/item/stack/rods)

/obj/structure/mecha_wreckage/mauler
	name = "\improper Mauler-毛勒残骸"
	icon_state = "mauler-broken"
	desc = "辛迪加对此可不会太高兴..."
	welder_salvage = list(/obj/item/stack/sheet/mineral/plastitanium, /obj/item/stack/sheet/mineral/diamond, /obj/item/stack/sheet/iron, /obj/item/stack/rods)

/obj/structure/mecha_wreckage/seraph
	name = "\improper Seraph-六翼天使残骸"
	icon_state = "seraph-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/titanium, /obj/item/stack/sheet/mineral/diamond, /obj/item/stack/sheet/iron, /obj/item/stack/rods)

/obj/structure/mecha_wreckage/reticence
	name = "\improper Reticence-缄默残骸"
	icon_state = "reticence-broken"
	color = "#87878715"
	desc = "..."
	welder_salvage = list(/obj/item/shard) //get it, it's a glass cannon

/obj/structure/mecha_wreckage/ripley
	name = "\improper Ripley-雷普利残骸"
	icon_state = "ripley-broken"
	welder_salvage = list(/obj/item/stack/sheet/iron, /obj/item/stack/rods)
	parts = list(
				/obj/item/mecha_parts/part/ripley_torso,
				/obj/item/mecha_parts/part/ripley_left_arm,
				/obj/item/mecha_parts/part/ripley_right_arm,
				/obj/item/mecha_parts/part/ripley_left_leg,
				/obj/item/mecha_parts/part/ripley_right_leg)

/obj/structure/mecha_wreckage/ripley/mk2
	name = "\improper Ripley MK-II-雷普利残骸"
	icon_state = "ripleymkii-broken"

/obj/structure/mecha_wreckage/ripley/paddy
	name = "\improper 帕迪机甲残骸"
	icon_state = "paddy-broken"

/obj/structure/mecha_wreckage/clarke
	name = "\improper Clarke-克拉克 残骸"
	icon_state = "clarke-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/gold, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	parts = list(
				/obj/item/mecha_parts/part/clarke_torso,
				/obj/item/mecha_parts/part/clarke_head,
				/obj/item/mecha_parts/part/clarke_left_arm,
				/obj/item/mecha_parts/part/clarke_right_arm,
				/obj/item/stack/conveyor)

/obj/structure/mecha_wreckage/ripley/deathripley
	name = "\improper Death-Ripley-死队雷普利残骸"
	icon_state = "deathripley-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/plastitanium, /obj/item/stack/sheet/mineral/diamond, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	parts = null

/obj/structure/mecha_wreckage/honker
	name = "\improper H.O.N.K残骸"
	icon_state = "honker-broken"
	desc = "宇宙万法的那个源头是，是和谐的。"
	welder_salvage = list(/obj/item/stack/sheet/mineral/bananium, /obj/item/grown/bananapeel, /obj/item/stack/sheet/iron)
	parts = list(
				/obj/item/mecha_parts/part/honker_torso,
				/obj/item/mecha_parts/part/honker_head,
				/obj/item/mecha_parts/part/honker_left_arm,
				/obj/item/mecha_parts/part/honker_right_arm,
				/obj/item/mecha_parts/part/honker_left_leg,
				/obj/item/mecha_parts/part/honker_right_leg)

/obj/structure/mecha_wreckage/durand
	name = "\improper Durand-杜兰德 残骸"
	icon_state = "durand-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/silver, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	parts = list(
			/obj/item/mecha_parts/part/durand_torso,
			/obj/item/mecha_parts/part/durand_head,
			/obj/item/mecha_parts/part/durand_left_arm,
			/obj/item/mecha_parts/part/durand_right_arm,
			/obj/item/mecha_parts/part/durand_left_leg,
			/obj/item/mecha_parts/part/durand_right_leg)

/obj/structure/mecha_wreckage/phazon
	name = "\improper Phazon-法宗残骸"
	icon_state = "phazon-broken"
	parts = list(
		/obj/item/mecha_parts/part/phazon_torso,
		/obj/item/mecha_parts/part/phazon_head,
		/obj/item/mecha_parts/part/phazon_left_arm,
		/obj/item/mecha_parts/part/phazon_right_arm,
		/obj/item/mecha_parts/part/phazon_left_leg,
		/obj/item/mecha_parts/part/phazon_right_leg)

/obj/structure/mecha_wreckage/savannah_ivanov
	name = "\improper Savannah-Ivanov-萨凡纳-伊万诺夫残骸"
	icon = 'icons/mob/rideables/coop_mech.dmi'
	icon_state = "savannah_ivanov-broken"
	welder_salvage = list(/obj/item/stack/sheet/mineral/silver, /obj/item/stack/sheet/iron, /obj/item/stack/rods)
	parts = list(
		/obj/item/mecha_parts/part/savannah_ivanov_torso,
		/obj/item/mecha_parts/part/savannah_ivanov_head,
		/obj/item/mecha_parts/part/savannah_ivanov_left_arm,
		/obj/item/mecha_parts/part/savannah_ivanov_right_arm,
		/obj/item/mecha_parts/part/savannah_ivanov_left_leg,
		/obj/item/mecha_parts/part/savannah_ivanov_right_leg)

/obj/structure/mecha_wreckage/odysseus
	name = "\improper Odysseus-奥德修斯残骸"
	icon_state = "odysseus-broken"
	parts = list(
			/obj/item/mecha_parts/part/odysseus_torso,
			/obj/item/mecha_parts/part/odysseus_head,
			/obj/item/mecha_parts/part/odysseus_left_arm,
			/obj/item/mecha_parts/part/odysseus_right_arm,
			/obj/item/mecha_parts/part/odysseus_left_leg,
			/obj/item/mecha_parts/part/odysseus_right_leg)
