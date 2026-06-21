/obj/item/clothing/shoes/bhop
	name = "跳跃靴"
	desc = "一双特制的战斗靴，内置推进系统，可实现快速向前移动。"
	icon_state = "jetboots"
	inhand_icon_state = null
	resistance_flags = FIRE_PROOF
	actions_types = list(/datum/action/item_action/bhop)
	armor_type = /datum/armor/shoes_bhop
	strip_delay = 3 SECONDS
	var/jumpdistance = 5 //-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpspeed = 3
	var/recharging_rate = 60 //default 6 seconds between each dash
	var/recharging_time = 0 //time until next dash

/datum/armor/shoes_bhop
	bio = 90

/obj/item/clothing/shoes/bhop/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/bhop/ui_action_click(mob/user, action)
	if(!isliving(user))
		return

	if(recharging_time > world.time)
		to_chat(user, span_warning("靴子的内部推进器仍需充能！"))
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	ADD_TRAIT(user, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)  //Throwing itself doesn't protect mobs against lava (because gulag).
	if (user.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(user, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		playsound(src, 'sound/effects/stealthoff.ogg', 50, TRUE, TRUE)
		user.visible_message(span_warning("[usr] 向前猛冲到了空中！"))
		recharging_time = world.time + recharging_rate
	else
		REMOVE_TRAIT(user, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)
		to_chat(user, span_warning("有什么东西阻止了你向前冲刺！"))

/obj/item/clothing/shoes/bhop/rocket
	name = "火箭靴"
	desc = "内置火箭推进器的特殊靴子！SHAZBOT！"
	icon_state = "rocketboots"
	inhand_icon_state = null
	actions_types = list(/datum/action/item_action/bhop/brocket)
	jumpdistance = 20 //great for throwing yourself into walls and people at high speeds
	jumpspeed = 5
