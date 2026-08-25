// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

//////////////////////////
//Movable Screen Objects//
//   By RemieRichards //
//////////////////////////


//Movable Screen Object
//Not tied to the grid, places its center where the cursor is

/atom/movable/screen/movable
	mouse_drag_pointer = 'icons/effects/mouse_pointers/screen_drag.dmi'
	var/snap2grid = FALSE
	var/x_off = -16
	var/y_off = -16

//Snap Screen Object
//Tied to the grid, snaps to the nearest turf

/atom/movable/screen/movable/snap
	snap2grid = TRUE

/atom/movable/screen/movable/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	var/position = mouse_params_to_position(params)
	if(!position)
		return

	screen_loc = position

/// Takes mouse parmas as input, returns a string representing the appropriate mouse position
/atom/movable/screen/movable/proc/mouse_params_to_position(params)
	var/list/modifiers = params2list(params)

	//No screen-loc information? abort.
	if(!LAZYACCESS(modifiers, SCREEN_LOC))
		return
	var/client/our_client = usr.client
	var/list/offset	= screen_loc_to_offset(LAZYACCESS(modifiers, SCREEN_LOC))
	if(snap2grid) //Discard Pixel Values
		offset[1] = FLOOR(offset[1], ICON_SIZE_X) // drops any pixel offset
		offset[2] = FLOOR(offset[2], ICON_SIZE_Y) // drops any pixel offset
	else //Normalise Pixel Values (So the object drops at the center of the mouse, not 16 pixels off)
		offset[1] += x_off
		offset[2] += y_off
	return offset_to_screen_loc(offset[1], offset[2], our_client?.view)

ADMIN_VERB(test_movable_UI, R_DEBUG, "生成可移动 UI 对象", "Spawn a movable UI object for testing.", ADMIN_CATEGORY_DEBUG)
	var/atom/movable/screen/movable/M = new
	M.name = "Movable UI Object"
	M.icon_state = "block"
	M.maptext = MAPTEXT(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE ? "可移动" : "Movable") // NOVA EDIT - i18n: maptext 不过 AC，全服中文直给中文标签
	M.maptext_width = 64

	var/screen_l = input(user, LANG("datum.a9622be67f9bfa5f", null),LANG("datum.df64e0c84244c1ab", null)) as text|null
	if(!screen_l)
		return

	M.screen_loc = screen_l
	user.screen += M

ADMIN_VERB(test_snap_ui, R_DEBUG, "生成吸附 UI 对象", "Spawn a snap UI object for testing.", ADMIN_CATEGORY_DEBUG)
	var/atom/movable/screen/movable/snap/S = new
	S.name = "Snap UI Object"
	S.icon_state = "block"
	S.maptext = MAPTEXT(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE ? "吸附" : "Snap") // NOVA EDIT - i18n: maptext 不过 AC，全服中文直给中文标签
	S.maptext_width = 64

	var/screen_l = input(user,LANG("datum.a9622be67f9bfa5f", null),LANG("datum.1ad9c84d7629c227", null)) as text|null
	if(!screen_l)
		return

	S.screen_loc = screen_l
	user.screen += S
