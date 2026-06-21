/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "将你的角色向北移动"
	keybind_signal = COMSIG_KB_MOVEMENT_NORTH_DOWN

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "将你的角色向南移动"
	keybind_signal = COMSIG_KB_MOVEMENT_SOUTH_DOWN

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "将你的角色向左移动"
	keybind_signal = COMSIG_KB_MOVEMENT_WEST_DOWN

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "将你的角色向东移动"
	keybind_signal = COMSIG_KB_MOVEMENT_EAST_DOWN

/datum/keybinding/movement/zlevel_upwards
	hotkey_keys = list("Northeast") // PGUP
	name = "Upwards"
	full_name = "Move Upwards"
	description = "如果可能，将你的角色向上移动一个Z层级"
	keybind_signal = COMSIG_KB_MOVEMENT_ZLEVEL_MOVEUP_DOWN

/datum/keybinding/movement/zlevel_upwards/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.mob.up()
	return TRUE

/datum/keybinding/movement/zlevel_downwards
	hotkey_keys = list("Southeast") // PGDOWN
	name = "Downwards"
	full_name = "Move Downwards"
	description = "如果可能，将你的角色向下移动一个Z层级"
	keybind_signal = COMSIG_KB_MOVEMENT_ZLEVEL_MOVEDOWN_DOWN

/datum/keybinding/movement/zlevel_downwards/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.mob.down()
	return TRUE
