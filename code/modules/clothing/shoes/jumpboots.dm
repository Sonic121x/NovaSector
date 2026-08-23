// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/clothing/shoes/bhop
	name = "jump boots"
	desc = "A specialized pair of combat boots with a built-in propulsion system for rapid forward movement."
	icon_state = "jumpboots"
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
		to_chat(user, span_warning(LANG("obj.6e6195b19e09bb2f", null)))
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	ADD_TRAIT(user, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)  //Throwing itself doesn't protect mobs against lava (because gulag).
	if (user.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(user, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		playsound(src, 'sound/effects/stealthoff.ogg', 50, TRUE, TRUE)
		user.visible_message(span_warning(LANG("obj.951d5b71b9614f3f", list(usr))))
		recharging_time = world.time + recharging_rate
	else
		REMOVE_TRAIT(user, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)
		to_chat(user, span_warning(LANG("obj.9227c41df31765a4", null)))

/obj/item/clothing/shoes/bhop/rocket
	name = "rocket boots"
	desc = "Very special boots with built-in rocket thrusters! SHAZBOT!"
	icon_state = "rocketboots"
	inhand_icon_state = null
	actions_types = list(/datum/action/item_action/bhop/brocket)
	jumpdistance = 20 //great for throwing yourself into walls and people at high speeds
	jumpspeed = 5

// Has the rocket boot's dodge action, in addition to sustained flight while activated.
/obj/item/clothing/shoes/bhop/rocket/jet
	name = "jet boots"
	desc = "Top of the line rocket boots, featuring a precise enough flight mechanism that can enable flight!"
	icon_state = "jetboots"
	actions_types = list(/datum/action/item_action/bhop, /datum/action/item_action/toggle_flight)
	/// Are the jet boots currently flying?
	var/flight_active = FALSE

/obj/item/clothing/shoes/bhop/rocket/jet/update_icon_state()
	if(flight_active)
		icon_state = "jetboots_active"
	else
		icon_state = "jetboots"
	return ..()
