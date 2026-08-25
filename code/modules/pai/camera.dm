// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/camera/siliconcam/pai_camera
	name = "pAI photo camera"
	light_color = COLOR_PAI_GREEN

/obj/item/camera/siliconcam/pai_camera/after_picture(mob/user, datum/picture/picture)
	var/number = length(stored)
	picture.picture_name = "Image [number] (taken by [loc.name])"
	stored[picture] = TRUE
	playsound(src, SFX_POLAROID, 75, TRUE, -3)
	balloon_alert(user, LANG("obj.3fb112834df9e975", null))

/**
 * Handles selecting and printing stored images.
 *
 * @param {mob} user - The pAI.
 *
 * @returns {boolean} - TRUE if the pAI prints an image,
 * 	FALSE otherwise.
*/
/obj/item/camera/siliconcam/pai_camera/proc/pai_print(mob/user)
	var/mob/living/silicon/pai/pai = loc
	var/datum/picture/selection = selectpicture(user)
	if(!istype(selection))
		balloon_alert(user, LANG("obj.f76d9d32a551205a", null))
		return FALSE
	printpicture(user, selection)
	user.visible_message(span_notice(LANG("obj.ddc5737483250999", list(pai.name))), span_notice(LANG("obj.ea70dffc1019f291", null)))
	return TRUE

/**
 * All inclusive camera proc. Zooms, snaps, prints.
 *
 * @param {mob} user - The pAI requesting the camera.
 *
 * @param {string} mode - The camera option to toggle.
 *
 * @returns {boolean} - TRUE if the camera worked.
 */
/mob/living/silicon/pai/proc/use_camera(mob/user, mode)
	if(!aicamera || isnull(mode))
		return FALSE
	switch(mode)
		if(PAI_PHOTO_MODE_CAMERA)
			aicamera.toggle_camera_mode(user)
		if(PAI_PHOTO_MODE_PRINTER)
			var/obj/item/camera/siliconcam/pai_camera/paicam = aicamera
			paicam.pai_print(user)
		if(PAI_PHOTO_MODE_ZOOM)
			aicamera.adjust_zoom(user)
	return TRUE
