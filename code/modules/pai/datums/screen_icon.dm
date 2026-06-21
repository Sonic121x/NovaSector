// Datums describing an icon that is overlaid on a pAI card, to make its screen show something. The
// player can select between any of these at any time. These are usually faces, but can
// realistically be anything (similar to an AI's display).

/datum/pai_screen_image
	// The name to show in the radial menu.
	var/name
	// The icon and icon state that is applied to the pAI device when this screen image is selected.
	var/icon/icon = 'icons/obj/aicards.dmi'
	var/icon_state
	// The FontAwesome icon to use next to the "Display" button in the pAI's tgui interface window.
	var/interface_icon

/datum/pai_screen_image/angry
	name = "愤怒"
	icon_state = "pai-angry"
	interface_icon = "angry"

/datum/pai_screen_image/cat
	name = "猫"
	icon_state = "pai-cat"
	interface_icon = "cat"

/datum/pai_screen_image/extremely_happy
	name = "极度开心"
	icon_state = "pai-extremely-happy"
	interface_icon = "grin-beam"

/datum/pai_screen_image/face
	name = "脸"
	icon_state = "pai-face"
	interface_icon = "grin-alt"

/datum/pai_screen_image/happy
	name = "开心"
	icon_state = "pai-happy"
	interface_icon = "smile"

/datum/pai_screen_image/laugh
	name = "大笑"
	icon_state = "pai-laugh"
	interface_icon = "grin-tears"

/datum/pai_screen_image/neutral
	name = "中性"
	icon_state = "pai-null"
	interface_icon = "meh"

/datum/pai_screen_image/off
	name = "无"
	icon_state = "pai-off"
	interface_icon = "meh-blank"

/datum/pai_screen_image/sad
	name = "悲伤"
	icon_state = "pai-sad"
	interface_icon = "sad-cry"

/datum/pai_screen_image/sunglasses
	name = "太阳镜"
	icon_state = "pai-sunglasses"
	interface_icon = "sun"

/datum/pai_screen_image/what
	name = "什么"
	icon_state = "pai-what"
	interface_icon = "frown-open"
