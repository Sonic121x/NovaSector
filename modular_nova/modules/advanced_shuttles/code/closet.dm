/obj/structure/closet/shuttle/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(enable_door_overlay && !is_animating_door)
		if(opened && has_opened_overlay)
			var/mutable_appearance/door_overlay = mutable_appearance(icon, "[icon_door || icon_state]_open", alpha = src.alpha)	//This was the only change, adding icon_door; TG wouldnt want it.
			. += door_overlay
			door_overlay.overlays += emissive_blocker(door_overlay.icon, door_overlay.icon_state, src, alpha = door_overlay.alpha) // If we don't do this the door doesn't block emissives and it looks weird.
		else if(has_closed_overlay)
			. += "[icon_door || icon_state]_door"
//TG won't ever really need this because their lockers with non-matching fronts dont have non-matching backs; so I simply re-define the proc for our shuttleclosets

/obj/structure/closet/shuttle
	anchored = TRUE
	density = TRUE
	icon = 'modular_nova/master_files/icons/obj/closet.dmi'
	icon_state = "wallcloset"
	icon_door = "wallcloset_mesh"
	door_anim_time = 0 //Somebody needs to remove the hard-sprited shuttles, or at least their lockers. These are a sin.

/obj/structure/closet/shuttle/white
	icon_state = "wallcloset_white"
	icon_door = "wallcloset_white"

/obj/structure/closet/shuttle/emergency
	name = "应急储物柜"
	desc = "这是一个用于存放应急呼吸面罩和氧气罐的存储单元。"
	icon_door = "wallcloset_o2"

/obj/structure/closet/shuttle/emergency/PopulateContents()
	for (var/i in 1 to 2)
		new /obj/item/tank/internals/emergency_oxygen/engi(src)
		new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/storage/toolbox/emergency(src)

/obj/structure/closet/shuttle/emergency/white
	icon_state = "wallcloset_white"

/obj/structure/closet/shuttle/medical
	name = "急救储物柜"
	desc = "这是一个用于存放应急医疗用品的存储单元。"
	icon_door = "wallcloset_med"

/obj/structure/closet/shuttle/medical/PopulateContents()
	new /obj/item/storage/medkit/emergency(src)
	new /obj/item/healthanalyzer(src)
	new /obj/item/reagent_containers/hypospray(src)

/obj/structure/closet/shuttle/medical/white
	icon_state = "wallcloset_white"

/obj/structure/closet/shuttle/mining
	desc = "这是一个用于存放应急呼吸面罩、氧气罐和压力服的存储单元。"
	icon_state = "wallcloset_white"
	icon_door = "wallcloset_mining"

/obj/structure/closet/shuttle/mining/PopulateContents()
	for (var/i in 1 to 2)
		new /obj/item/tank/internals/emergency_oxygen/engi(src)
		new /obj/item/clothing/mask/breath(src)
	new /obj/item/storage/toolbox/emergency(src)
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/clothing/suit/space(src)

/obj/structure/closet/shuttle/engivent
	wall_mounted = TRUE
	name = "引擎通风"
	desc = "穿梭机引擎的排气口。看起来刚好能容纳一个人..."
	icon_state = "vent"
	icon_door = "vent"

//Generic Wall Closets - mount onto a wall, will end up storing anything that's on the tile it was placed from and 'occupies'.
//Mob Size is small so that it doesn't end up storing players standing on those tiles.
/obj/structure/closet/generic/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE //Prevents it being unwrenched and dragged around. Gotta unweld it!
	paint_jobs = FALSE //Prevents it being repainted into other non-wall lockers.
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "locker_wall"

/obj/structure/closet/emcloset/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "emergency_wall"

/obj/structure/closet/firecloset/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "fire_wall"

//These two are pre-locked versions of closet/generic/wall, for mapping only
/obj/structure/closet/secure_closet/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "locker_wall"

/obj/structure/closet/secure_closet/personal/wall
	door_anim_squish = 0.3
	door_anim_angle = 115
	door_hinge_x = -8.5
	wall_mounted = TRUE
	max_mob_size = MOB_SIZE_SMALL
	density = TRUE
	anchored = TRUE
	anchorable = FALSE
	paint_jobs = FALSE
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "locker_wall"

//These procs create empty subtypes, for when it's placed by a user rather than mapped in...
//Secure/personal don't get these since they're made with airlock electronics
/obj/structure/closet/generic/wall/empty/PopulateContents()
	return

/obj/structure/closet/emcloset/wall/empty/PopulateContents()
	return

/obj/structure/closet/firecloset/wall/empty/PopulateContents()
	return

//Wallmounts, for rebuilding the wall lockers above
/obj/item/wallframe/closet
	name = "壁挂式储物柜"
	desc = "这是一个壁挂式储物单元，用来存放...嗯，你想放进去的任何东西。贴在墙上使用。"
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "locker_mount"
	result_path = /obj/structure/closet/generic/wall/empty
	pixel_shift = 32

/obj/item/wallframe/emcloset
	name = "壁挂式应急储物柜"
	desc = "这是一个用于存放应急呼吸面罩和氧气罐的壁挂式储物单元。贴在墙上使用。"
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "emergency_mount"
	result_path = /obj/structure/closet/emcloset/wall/empty
	pixel_shift = 32

/obj/item/wallframe/firecloset
	name = "壁挂式消防安全柜"
	desc = "这是一个用于存放消防用品的壁挂式储物单元。贴在墙上使用。"
	icon = 'modular_nova/master_files/icons/obj/closet_wall.dmi'
	icon_state = "fire_mount"
	result_path = /obj/structure/closet/firecloset/wall/empty
	pixel_shift = 32
