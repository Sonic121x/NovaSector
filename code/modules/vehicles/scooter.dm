/obj/vehicle/ridden/scooter
	name = "速度和实用性"
	desc = "一种有趣的出行方式。"
	icon_state = "scooter"
	are_legs_exposed = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 11)

/obj/vehicle/ridden/scooter/Initialize(mapload)
	. = ..()
	make_ridable()

/obj/vehicle/ridden/scooter/proc/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/scooter)

/obj/vehicle/ridden/scooter/wrench_act(mob/living/user, obj/item/tool)
	..()
	to_chat(user, span_notice("你开始拆卸车把..."))
	if(!tool.use_tool(src, user, 40, volume=50))
		return TRUE
	var/obj/vehicle/ridden/scooter/skateboard/improvised/skater = new(drop_location())
	new /obj/item/stack/rods(drop_location(), 2)
	to_chat(user, span_notice("你从 [src] 上拆下了车把。"))
	if(has_buckled_mobs())
		var/mob/living/carbon/carbons = buckled_mobs[1]
		unbuckle_mob(carbons)
		skater.buckle_mob(carbons)
	qdel(src)
	return TRUE

/obj/vehicle/ridden/scooter/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	for(var/mob/living/buckled_mob as anything in buckled_mobs)
		if(buckled_mob.num_legs > 0)
			buckled_mob.pixel_y = 5
		else
			buckled_mob.pixel_y = -4

/obj/vehicle/ridden/scooter/skateboard
	name = "滑板"
	desc = "一个老旧的滑板，仍可以拿来滑，但可能不太安全."
	icon_state = "skateboard"
	density = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10)
	///Sparks datum for when we grind on tables
	var/datum/effect_system/basic/spark_spread/sparks
	///Whether the board is currently grinding
	var/grinding = FALSE
	///Stores the time of the last crash plus a short cooldown, affects availability and outcome of certain actions
	var/next_crash
	///The handheld item counterpart for the board
	var/board_item_type = /obj/item/melee/skateboard
	///Stamina drain multiplier
	var/instability = 10
	///If true, riding the skateboard with walk intent on will prevent crashing.
	var/can_slow_down = TRUE
	///The actual item for the skateboard
	var/obj/item/melee/skateboard/board_item

/obj/vehicle/ridden/scooter/skateboard/Initialize(mapload, obj/item/melee/skateboard/board_item)
	. = ..()
	sparks = new(src, 1, FALSE)
	sparks.attach(src)
	if(!istype(board_item))
		src.board_item = new board_item_type(src)
	else
		src.board_item = board_item

/obj/vehicle/ridden/scooter/skateboard/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/scooter/skateboard)

/obj/vehicle/ridden/scooter/skateboard/Destroy()
	QDEL_NULL(sparks)
	return ..()

/obj/vehicle/ridden/scooter/skateboard/relaymove(mob/living/user, direction)
	if (grinding || world.time < next_crash)
		return FALSE
	return ..()

/obj/vehicle/ridden/scooter/skateboard/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/ridden/scooter/skateboard/ollie, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/ridden/scooter/skateboard/kickflip, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/ridden/scooter/skateboard/post_buckle_mob(mob/living/M)//allows skateboards to be non-dense but still allows 2 skateboarders to collide with each other
	set_density(TRUE)
	return ..()

/obj/vehicle/ridden/scooter/skateboard/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		set_density(FALSE)
	return ..()

/obj/vehicle/ridden/scooter/skateboard/Bump(atom/bumped_thing)
	. = ..()
	if(!bumped_thing.density || !has_buckled_mobs() || world.time < next_crash)
		return
	var/mob/living/rider = buckled_mobs[1]
	if(rider.move_intent == MOVE_INTENT_WALK && can_slow_down) //Going slow prevents you from crashing.
		return

	next_crash = world.time + 10
	rider.adjust_stamina_loss(instability*6)
	playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
	if(!iscarbon(rider) || rider.get_stamina_loss() >= 100 || grinding || iscarbon(bumped_thing))
		var/atom/throw_target = get_edge_target_turf(rider, pick(GLOB.cardinals))
		unbuckle_mob(rider)
		if((istype(bumped_thing, /obj/machinery/disposal/bin)))
			rider.Paralyze(8 SECONDS)
			rider.forceMove(bumped_thing)
			forceMove(bumped_thing)
			visible_message(span_danger("[src] 撞上了 [bumped_thing]，并直接被甩了进去！"))
			return
		rider.throw_at(throw_target, 3, 2)
		var/head_slot = rider.get_item_by_slot(ITEM_SLOT_HEAD)
		if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/utility/hardhat)))
			rider.adjust_organ_loss(ORGAN_SLOT_BRAIN, 5)
			rider.updatehealth()
		visible_message(span_danger("[src] 撞上了 [bumped_thing]，把 [rider] 甩飞了！"))
		rider.Paralyze(8 SECONDS)
		if(iscarbon(bumped_thing))
			var/mob/living/carbon/victim = bumped_thing
			var/grinding_mulitipler = 1
			if(grinding)
				grinding_mulitipler = 2
			victim.Knockdown(4 * grinding_mulitipler SECONDS)
	else
		var/backdir = REVERSE_DIR(dir)
		step(src, backdir)
		rider.spin(4, 1)

///Moves the vehicle forward and if it lands on a table, repeats
/obj/vehicle/ridden/scooter/skateboard/proc/grind()
	step(src, dir)
	if(!has_buckled_mobs() || !(locate(/obj/structure/table) in loc.contents) && !(locate(/obj/structure/fluff/tram_rail) in loc.contents))
		obj_flags = CAN_BE_HIT
		grinding = FALSE
		icon_state = "[initial(icon_state)]"
		return

	var/mob/living/skater = buckled_mobs[1]
	skater.adjust_stamina_loss(instability*0.3)
	if(skater.get_stamina_loss() >= 100)
		obj_flags = CAN_BE_HIT
		playsound(src, 'sound/effects/bang.ogg', 20, TRUE)
		unbuckle_mob(skater)
		var/atom/throw_target = get_edge_target_turf(src, pick(GLOB.cardinals))
		skater.throw_at(throw_target, 2, 2)
		visible_message(span_danger("[skater] loses [skater.p_their()] footing and slams on the ground!"))
		skater.Paralyze(4 SECONDS)
		grinding = FALSE
		icon_state = "[initial(icon_state)]"
		return
	playsound(src, 'sound/vehicles/skateboard_roll.ogg', 50, TRUE)
	var/turf/location = get_turf(src)

	if(location)
		if(prob(25))
			location.hotspot_expose(1000,1000)
			sparks.start() //the most radical way to start plasma fires
	for(var/mob/living/carbon/victim in location)
		if(victim.body_position == LYING_DOWN)
			playsound(location, 'sound/items/trayhit/trayhit2.ogg', 40)
			victim.apply_damage(damage = 25, damagetype = BRUTE, def_zone = victim.get_random_valid_zone(even_weights = TRUE), wound_bonus = 20)
			victim.Paralyze(1.5 SECONDS)
			skater.adjust_stamina_loss(instability)
			victim.visible_message(span_danger("[victim] 直接被 [skater] 的 [src] 碾进了地里！太酷了！"))
	addtimer(CALLBACK(src, PROC_REF(grind)), 0.1 SECONDS)

/obj/vehicle/ridden/scooter/skateboard/mouse_drop_dragged(atom/over_object, mob/user)
	var/mob/living/carbon/skater = user
	if(!istype(skater))
		return
	if (over_object == skater)
		pick_up_board(skater)

/obj/vehicle/ridden/scooter/skateboard/proc/pick_up_board(mob/living/carbon/skater, forced = FALSE)
	if ((skater.incapacitated || !Adjacent(skater)) && !forced)
		return
	if(has_buckled_mobs())
		to_chat(skater, span_warning("上面有人时你无法把它抬起来。"))
		return
	skater.put_in_hands(board_item)
	qdel(src)

/obj/vehicle/ridden/scooter/skateboard/pro
	name = "skateboard"
	desc = "一个八O牌专业滑板。它看起来比普通滑板更稳健."
	icon_state = "skateboard2"
	board_item_type = /obj/item/melee/skateboard/pro
	instability = 6

/obj/vehicle/ridden/scooter/skateboard/pro/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/scooter/skateboard/pro)

/obj/vehicle/ridden/scooter/skateboard/hoverboard
	name = "悬浮滑板"
	desc = "一股来自过去的狂风，如此复古！"
	board_item_type = /obj/item/melee/skateboard/hoverboard
	instability = 3
	icon_state = "hoverboard_red"

/obj/vehicle/ridden/scooter/skateboard/hoverboard/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/scooter/skateboard/hover)

/obj/vehicle/ridden/scooter/skateboard/hoverboard/can_z_move(direction, turf/start, turf/destination, z_move_flags = ZMOVE_FLIGHT_FLAGS, mob/living/rider)
	. = ..()
	if(!.)
		return
	if(rider && (z_move_flags & ZMOVE_CAN_FLY_CHECKS) && direction == UP)
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, span_warning("[src] [p_are()] 动力不足以向上飞。"))
		return FALSE

/obj/vehicle/ridden/scooter/skateboard/hoverboard/holyboarded
	name = "神圣滑板"
	desc = "A board blessed by the gods with the power to grind for our sins. Has the initials 'J.C.' on the underside."
	board_item_type = /obj/item/melee/skateboard/holyboard
	instability = 3
	icon_state = "hoverboard_holy"

/obj/vehicle/ridden/scooter/skateboard/hoverboard/holyboarded/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/scooter/skateboard/hover/holy)

/obj/vehicle/ridden/scooter/skateboard/hoverboard/holyboarded/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY)

/obj/vehicle/ridden/scooter/skateboard/hoverboard/admin
	name = "\improper 主管板"
	desc = "宇宙飞船工程的极高的复杂度都集中在这一块板上，价格也一样。"
	board_item_type = /obj/item/melee/skateboard/hoverboard/admin
	instability = 0
	icon_state = "hoverboard_nt"

/obj/vehicle/ridden/scooter/skateboard/improvised
	name = "简易滑板"
	desc = "An unfinished scooter which can only barely be called a skateboard. It's still rideable, but probably unsafe. Looks like you'll need to add a few rods to make handlebars."
	board_item_type = /obj/item/melee/skateboard/improvised
	instability = 12

//CONSTRUCTION
/obj/item/scooter_frame
	name = "滑板车框架"
	desc = "用于制作滑板车的金属框架。看起来你还需要添加一些铁来制作轮子。"
	icon = 'icons/mob/rideables/vehicles.dmi'
	icon_state = "scooter_frame"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)

/obj/item/scooter_frame/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stack/sheet/iron))
		return NONE
	if(!tool.tool_start_check(user, amount=5))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你开始为 [src] 添加轮子。"))
	if(!tool.use_tool(src, user, 80, volume = 50, amount = 5))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你为 [src] 做好了轮子。"))
	new /obj/vehicle/ridden/scooter/skateboard/improvised(user.loc)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/scooter_frame/wrench_act(mob/living/user, obj/item/tool)
	to_chat(user, span_notice("你拆解了 [src]。"))
	new /obj/item/stack/rods(drop_location(), 10)
	tool.play_tool_sound(src)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/vehicle/ridden/scooter/skateboard/wrench_act(mob/living/user, obj/item/tool)
	return

/obj/vehicle/ridden/scooter/skateboard/improvised/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if (.)
		return
	if(!istype(tool, /obj/item/stack/rods))
		return NONE
	if(!tool.tool_start_check(user, amount=2))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你开始为[src]制作把手。"))
	if(!tool.use_tool(src, user, 25, volume=50, amount=2))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你将杆子添加到[src]上，制成了把手。"))
	var/obj/vehicle/ridden/scooter/skaterskoot = new(loc)
	if(has_buckled_mobs())
		var/mob/living/carbon/skaterboy = buckled_mobs[1]
		unbuckle_mob(skaterboy)
		skaterskoot.buckle_mob(skaterboy)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/vehicle/ridden/scooter/skateboard/improvised/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return
	to_chat(user, span_notice("你开始拆解并移除[src]上的轮子..."))
	if(!tool.use_tool(src, user, 20, volume=50))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你拆解了[src]上的轮子。"))
	new /obj/item/stack/sheet/iron(drop_location(), 5)
	new /obj/item/scooter_frame(drop_location())
	if(has_buckled_mobs())
		var/mob/living/carbon/skatergirl = buckled_mobs[1]
		unbuckle_mob(skatergirl)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Wheelys
/obj/vehicle/ridden/scooter/skateboard/wheelys
	name = "伸缩轮滑鞋"
	desc = "采用专利的可伸缩轮架技术。绝不为了美观而牺牲速度——但要说这两者哪个更重要，恐怕很难说吧。"
	icon_state = null
	density = FALSE
	instability = 12
	///Stores the shoes associated with the vehicle
	var/obj/item/clothing/shoes/wheelys/shoes = null
	///Name of the wheels, for visible messages
	var/wheel_name = "wheels"
	///Component typepath to attach in [/obj/vehicle/ridden/scooter/skateboard/wheelys/proc/make_ridable()]
	var/component_type = /datum/component/riding/vehicle/scooter/skateboard/wheelys

/obj/vehicle/ridden/scooter/skateboard/wheelys/make_ridable()
	AddElement(/datum/element/ridable, component_type)

/obj/vehicle/ridden/scooter/skateboard/wheelys/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		to_chat(M, span_notice("你将[wheel_name]弹回了原位。"))
		moveToNullspace()
		shoes.toggle_wheels(FALSE)
	return ..()

/obj/vehicle/ridden/scooter/skateboard/wheelys/pick_up_board(mob/living/carbon/Skater)
	return

/obj/vehicle/ridden/scooter/skateboard/wheelys/post_buckle_mob(mob/living/M)
	to_chat(M, span_notice("你弹出了[wheel_name]。"))
	shoes.toggle_wheels(TRUE)
	return ..()

///Sets the shoes that the vehicle is associated with, called when the shoes are initialized
/obj/vehicle/ridden/scooter/skateboard/wheelys/proc/link_shoes(newshoes)
	shoes = newshoes

/obj/vehicle/ridden/scooter/skateboard/wheelys/rollerskates
	name = "滑轮鞋"
	desc = "一对八O牌滑轮鞋.有年代感，但仍可用！"
	instability = 8
	component_type = /datum/component/riding/vehicle/scooter/skateboard/wheelys/rollerskates

/obj/vehicle/ridden/scooter/skateboard/wheelys/skishoes
	name = "滑雪鞋"
	desc = "一双配备了可折叠滑雪板的鞋子！在雪地环境中行走时非常方便，能毫无阻碍地前行。"
	instability = 8
	wheel_name = "skis"
	component_type = /datum/component/riding/vehicle/scooter/skateboard/wheelys/skishoes
