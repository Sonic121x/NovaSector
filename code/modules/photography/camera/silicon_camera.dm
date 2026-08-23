// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/obj/item/camera/siliconcam
	name = "silicon photo camera"
	resistance_flags = INDESTRUCTIBLE
	cooldown = 2 SECONDS
	/// List of all pictures taken by this camera.
	var/list/datum/picture/stored = list()

/// Checks if we can take a picture at this moment. Returns TRUE if we can, FALSE if we can't.
/obj/item/camera/siliconcam/proc/can_take_picture(mob/living/silicon/clicker)
	if(IS_UNCONSCIOUS_OR_CRIT(clicker) || clicker.incapacitated)
		return FALSE
	return TRUE

/obj/item/camera/siliconcam/proc/InterceptClickOn(mob/living/silicon/clicker, params, atom/clicked_on)
	if(!can_take_picture(clicker))
		return
	clicker.face_atom(clicked_on)
	attempt_picture(clicked_on, clicker)
	toggle_camera_mode(clicker, sound = FALSE)

/// Toggles the camera mode on or off.
/// If sound is TRUE, plays a sound effect and displays a message on successful toggle
/obj/item/camera/siliconcam/proc/toggle_camera_mode(mob/user, sound = TRUE)
	if(user.click_intercept == src)
		user.click_intercept = null

	else if(isnull(user.click_intercept))
		user.click_intercept = src

	else
		// Trying to turn on camera mode while you have another click intercept active, such as malf abilities
		if(sound)
			balloon_alert(user, LANG("obj.82771ce201a43292", null))
			playsound(user, 'sound/machines/buzz/buzz-sigh.ogg', 25, TRUE)
		return

	if(sound)
		playsound(user, 'sound/items/tools/wirecutter.ogg', 50, TRUE)
		balloon_alert(user, LANG("obj.1696633aa49c30ec", list(user.click_intercept == src ? "activated" : "deactivated")))

/obj/item/camera/siliconcam/proc/selectpicture(mob/user)
	RETURN_TYPE(/datum/picture)
	if(!length(stored))
		user.balloon_alert(user, LANG("obj.eb74bb771df66792", null))
		return
	var/list/nametemp = list()
	var/list/temp = list()
	for(var/datum/picture/stored_photo as anything in stored)
		nametemp += stored_photo.picture_name
		temp[stored_photo.picture_name] = stored_photo
	var/find = tgui_input_list(user, LANG("obj.1ac29f4f1fcb832b", null), LANG("obj.d95a3efe5bd502c9", null), nametemp)
	if(isnull(find) || isnull(temp[find]))
		return
	return temp[find]

/obj/item/camera/siliconcam/proc/viewpictures(mob/user)
	var/datum/picture/selection = selectpicture(user)
	if(istype(selection))
		var/obj/item/photo/P = new(src, selection)
		P.show(user)
		to_chat(user, P.desc)
		qdel(P)

/obj/item/camera/siliconcam/ai_camera
	name = "AI photo camera"
	flash_enabled = FALSE

/obj/item/camera/siliconcam/ai_camera/can_take_picture(mob/living/silicon/ai/clicker)
	if(clicker.control_disabled)
		return FALSE
	return ..()

/obj/item/camera/siliconcam/ai_camera/balloon_alert(mob/viewer, text)
	if(isAI(loc))
		// redirects balloon alerts on us to balloon alerts on our ai eye
		var/mob/living/silicon/ai/ai = loc
		return ai.eyeobj.balloon_alert(viewer, text)

	return ..()

/obj/item/camera/siliconcam/ai_camera/after_picture(mob/user, datum/picture/picture)
	var/number = length(stored)
	picture.picture_name = "Image [number] (taken by [loc.name])"
	stored[picture] = TRUE
	balloon_alert(user, LANG("obj.3fb112834df9e975", null))
	user.playsound_local(get_turf(user), SFX_POLAROID, 50, TRUE, -3)

/obj/item/camera/siliconcam/robot_camera
	name = "Cyborg photo camera"
	var/printcost = 2

/obj/item/camera/siliconcam/robot_camera/can_take_picture(mob/living/silicon/robot/clicker)
	if(clicker.lockcharge)
		return FALSE
	return ..()

/obj/item/camera/siliconcam/robot_camera/after_picture(mob/living/silicon/robot/user, datum/picture/picture)
	if(istype(user) && istype(user.connected_ai))
		var/number = user.connected_ai.aicamera.stored.len
		picture.picture_name = "Image [number] (taken by [loc.name])"
		user.connected_ai.aicamera.stored[picture] = TRUE
		balloon_alert(user, LANG("obj.2aff1fefba924e2d", null))
	else
		var/number = stored.len
		picture.picture_name = "Image [number] (taken by [loc.name])"
		stored[picture] = TRUE
		balloon_alert(user, LANG("obj.b86d818d4bf7b8e8", null))
	playsound(src, SFX_POLAROID, 75, TRUE, -3)

/obj/item/camera/siliconcam/robot_camera/selectpicture(mob/living/silicon/robot/user)
	if(istype(user) && user.connected_ai)
		user.picturesync()
		return user.connected_ai.aicamera.selectpicture(user)
	return ..()

/obj/item/camera/siliconcam/robot_camera/proc/borgprint(mob/living/silicon/robot/user)
	if(!istype(user) || user.toner < printcost)
		balloon_alert(user, LANG("obj.f00608258451f700", null))
		return
	var/datum/picture/selection = selectpicture(user)
	if(!istype(selection))
		balloon_alert(user, LANG("obj.3d217d8a8f5886a2", null))
		return
	var/obj/item/photo/printed = new(user.drop_location(), selection)
	printed.pixel_x = printed.base_pixel_x + rand(-10, 10)
	printed.pixel_y = printed.base_pixel_y + rand(-10, 10)
	user.toner -= printcost  //All fun allowed.
	user.visible_message(span_notice(LANG("obj.adb9d4fa007382a6", list(user.name))), span_notice(LANG("obj.ea70dffc1019f291", null)))
	balloon_alert(user, LANG("obj.11d977901fe54db2", null))
	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 50, TRUE, -3)
