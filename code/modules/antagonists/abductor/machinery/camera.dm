/obj/machinery/computer/camera_advanced/abductor
	name = "人类观察控制台"
	var/team_number = 0
	networks = list(CAMERANET_NETWORK_SS13, CAMERANET_NETWORK_ABDUCTOR)
	var/obj/machinery/abductor/console/console
	/// We can't create our actions until after LateInitialize
	/// So we instead do it on the first call to GrantActions
	var/abduct_created = FALSE
	lock_override = TRUE

	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "camera"
	icon_keyboard = null
	icon_screen = null
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/camera_advanced/abductor/Destroy()
	if(console)
		console.camera = null
		console = null
	return ..()

/obj/machinery/computer/camera_advanced/abductor/CreateEye()
	. = ..()
	//For observers
	eyeobj.icon = 'icons/mob/eyemob.dmi'
	eyeobj.icon_state = "abductor_camera"
	//For the user
	eyeobj.set_user_icon(eyeobj.icon, eyeobj.icon_state)

/obj/machinery/computer/camera_advanced/abductor/GrantActions(mob/living/carbon/user)
	if(!abduct_created)
		abduct_created = TRUE
		actions += new /datum/action/innate/teleport_in(console.pad)
		actions += new /datum/action/innate/teleport_out(console)
		actions += new /datum/action/innate/teleport_self(console.pad)
		actions += new /datum/action/innate/vest_mode_swap(console)
		actions += new /datum/action/innate/vest_disguise_swap(console)
		actions += new /datum/action/innate/set_droppoint(console)
	..()

/obj/machinery/computer/camera_advanced/abductor/proc/IsScientist(mob/living/carbon/human/H)
	return HAS_TRAIT(H, TRAIT_ABDUCTOR_SCIENTIST_TRAINING)

/datum/action/innate/teleport_in
///Is the amount of time required between uses
	var/abductor_pad_cooldown = 8 SECONDS
///Is used to compare to world.time in order to determine if the action should early return
	var/use_delay
	name = "送至"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_down_pad"

/datum/action/innate/teleport_in/Activate()
	if(!target || !iscarbon(owner))
		return
	if(world.time < use_delay)
		to_chat(owner, span_warning("你必须等待 [DisplayTimeText(use_delay - world.time)] 才能再次使用 [target]！"))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/eye/camera/remote/remote_eye = C.remote_control
	var/obj/machinery/abductor/pad/P = target

	var/area/target_area = get_area(remote_eye)
	if((target_area.area_flags & NOTELEPORT) && !istype(target_area, /area/centcom/abductor_ship))
		to_chat(owner, span_warning("该区域屏蔽过强，无法安全传送。"))
		return

	if(target_area.motion_monitored)
		to_chat(owner, span_warning("该区域屏蔽过强，无法安全传送。"))
		return

	use_delay = (world.time + abductor_pad_cooldown)

	if(SScameras.is_visible_by_cameras(remote_eye.loc))
		P.PadToLoc(remote_eye.loc)

/datum/action/innate/teleport_out
	name = "收回"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_up"

/datum/action/innate/teleport_out/Activate()
	if(!target || !iscarbon(owner))
		return
	var/obj/machinery/abductor/console/console = target

	console.TeleporterRetrieve()

/datum/action/innate/teleport_self
///Is the amount of time required between uses
	var/teleport_self_cooldown = 9 SECONDS
	var/use_delay
	name = "自身送至"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_down"

/datum/action/innate/teleport_self/Activate()
	if(!target || !iscarbon(owner))
		return
	if(world.time < use_delay)
		to_chat(owner, span_warning("你一次只能传送到一个地方！"))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/eye/camera/remote/remote_eye = C.remote_control
	var/obj/machinery/abductor/pad/P = target

	var/area/target_area = get_area(remote_eye)
	if((target_area.area_flags & NOTELEPORT) && !istype(target_area, /area/centcom/abductor_ship))
		to_chat(owner, span_warning("该区域屏蔽过强，无法安全传送。"))
		return

	if(target_area.motion_monitored)
		to_chat(owner, span_warning("该区域屏蔽过强，无法安全传送。"))
		return

	use_delay = (world.time + teleport_self_cooldown)

	if(SScameras.is_visible_by_cameras(remote_eye.loc))
		P.MobToLoc(remote_eye.loc,C)

/datum/action/innate/vest_mode_swap
	name = "切换背心模式"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "vest_mode"

/datum/action/innate/vest_mode_swap/Activate()
	if(!target || !iscarbon(owner))
		return
	var/obj/machinery/abductor/console/console = target
	console.FlipVest()


/datum/action/innate/vest_disguise_swap
	name = "切换背心伪装"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "vest_disguise"

/datum/action/innate/vest_disguise_swap/Activate()
	if(!target || !iscarbon(owner))
		return
	var/obj/machinery/abductor/console/console = target
	console.SelectDisguise(remote=1)

/datum/action/innate/set_droppoint
	name = "设置实验释放点"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "set_drop"

/datum/action/innate/set_droppoint/Activate()
	if(!target || !iscarbon(owner))
		return

	var/mob/living/carbon/human/C = owner
	var/mob/eye/camera/remote/remote_eye = C.remote_control

	var/obj/machinery/abductor/console/console = target
	console.SetDroppoint(remote_eye.loc,owner)
