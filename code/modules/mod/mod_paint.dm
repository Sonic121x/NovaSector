#define MODPAINT_MAX_COLOR_VALUE 1.25
#define MODPAINT_MIN_COLOR_VALUE 0
#define MODPAINT_MAX_SECTION_COLORS 2
#define MODPAINT_MIN_SECTION_COLORS 0.25
#define MODPAINT_MAX_OVERALL_COLORS 4
#define MODPAINT_MIN_OVERALL_COLORS 1.5

/obj/item/mod/paint
	name = "模块服绘制套件"
	desc = "这个套件能将模块服的电镀重涂装成某些独特外观."
	icon = 'icons/obj/clothing/modsuit/mod_construction.dmi'
	icon_state = "paintkit"
	var/obj/item/mod/control/editing_mod
	var/atom/movable/screen/map_view/proxy_view
	var/list/current_color

/obj/item/mod/paint/Initialize(mapload)
	. = ..()
	current_color = COLOR_MATRIX_IDENTITY

/obj/item/mod/paint/examine(mob/user)
	. = ..()
	. += span_notice("<b>左键点击</b> MOD 防护服以更换皮肤。")
	. += span_notice("<b>右键点击</b> MOD 防护服以重新着色。")

/obj/item/mod/paint/ui_interact(mob/user, datum/tgui/ui)
	if(!editing_mod)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MODpaint", name)
		ui.open()
		proxy_view.display_to(user, ui.window)

/obj/item/mod/paint/ui_host()
	return editing_mod

/obj/item/mod/paint/ui_close(mob/user)
	. = ..()
	editing_mod = null
	QDEL_NULL(proxy_view)
	current_color = COLOR_MATRIX_IDENTITY

/obj/item/mod/paint/ui_status(mob/user, datum/ui_state/state)
	if(check_menu(editing_mod, user))
		return ..()
	return UI_CLOSE

/obj/item/mod/paint/ui_static_data(mob/user)
	var/list/data = list()
	data["mapRef"] = proxy_view.assigned_map
	return data

/obj/item/mod/paint/ui_data(mob/user)
	var/list/data = list()
	data["currentColor"] = current_color
	return data

/obj/item/mod/paint/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("transition_color")
			current_color = params["color"]
			animate(proxy_view, time = 0.5 SECONDS, color = current_color)
		if("confirm")
			if(length(current_color) != 20) //20 is the length of a matrix identity list
				return
			for(var/color_value in current_color)
				if(isnum(color_value))
					continue
				return
			var/total_color_value = 0
			var/list/total_colors = current_color.Copy()
			total_colors.Cut(13, length(total_colors)) // 13 to 20 are just a and c, dont want to count them
			var/red_value = current_color[1] + current_color[5] + current_color[9] //rr + gr + br
			var/green_value = current_color[2] + current_color[6] + current_color[10] //rg + gg + bg
			var/blue_value = current_color[3] + current_color[7] + current_color[11] //rb + gb + bb
			if(red_value > MODPAINT_MAX_SECTION_COLORS)
				balloon_alert(usr, "红色总量过高！([red_value*100]%/[MODPAINT_MAX_SECTION_COLORS*100]%)")
				return
			else if(red_value < MODPAINT_MIN_SECTION_COLORS)
				balloon_alert(usr, "红色总量过低！([red_value*100]%/[MODPAINT_MIN_SECTION_COLORS*100]%)")
				return
			if(green_value > MODPAINT_MAX_SECTION_COLORS)
				balloon_alert(usr, "绿色总量过高！([green_value*100]%/[MODPAINT_MAX_SECTION_COLORS*100]%)")
				return
			else if(green_value < MODPAINT_MIN_SECTION_COLORS)
				balloon_alert(usr, "绿色总量过低！([green_value*100]%/[MODPAINT_MIN_SECTION_COLORS*100]%)")
				return
			if(blue_value > MODPAINT_MAX_SECTION_COLORS)
				balloon_alert(usr, "蓝色总量过高！([blue_value*100]%/[MODPAINT_MAX_SECTION_COLORS*100]%)")
				return
			else if(blue_value < MODPAINT_MIN_SECTION_COLORS)
				balloon_alert(usr, "蓝色总量过低！([blue_value*100]%/[MODPAINT_MIN_SECTION_COLORS*100]%)")
				return
			for(var/color_value in total_colors)
				total_color_value += color_value
				if(color_value > MODPAINT_MAX_COLOR_VALUE)
					balloon_alert(usr, "某个颜色值过高！([color_value*100]%/[MODPAINT_MAX_COLOR_VALUE*100]%")
					return
				else if(color_value < MODPAINT_MIN_COLOR_VALUE)
					balloon_alert(usr, "某个颜色值过低！([color_value*100]%/[MODPAINT_MIN_COLOR_VALUE*100]%")
					return
			if(total_color_value > MODPAINT_MAX_OVERALL_COLORS)
				balloon_alert(usr, "颜色总量过高！([total_color_value*100]%/[MODPAINT_MAX_OVERALL_COLORS*100]%)")
				return
			else if(total_color_value < MODPAINT_MIN_OVERALL_COLORS)
				balloon_alert(usr, "颜色总量过低！([total_color_value*100]%/[MODPAINT_MIN_OVERALL_COLORS*100]%)")
				return
			editing_mod.set_mod_color(current_color)
			SStgui.close_uis(src)

/obj/item/mod/paint/proc/paint_skin(obj/item/mod/control/mod, mob/user)
	if(length(mod.theme.variants) <= 1)
		balloon_alert(user, "没有可用的替换皮肤！")
		return
	var/list/skins = list()
	for(var/mod_skin_name in mod.theme.variants)
		var/list/mod_skin = mod.theme.variants[mod_skin_name]
		skins[mod_skin_name] = image(icon = mod_skin[MOD_ICON_OVERRIDE] || mod.icon, icon_state = "[mod_skin_name]-control")
	var/pick = show_radial_menu(user, mod, skins, custom_check = CALLBACK(src, PROC_REF(check_menu), mod, user), require_near = TRUE)
	if(!pick)
		balloon_alert(user, "未选择皮肤！")
		return
	mod.theme.set_skin(mod, pick)

/obj/item/mod/paint/proc/check_menu(obj/item/mod/control/mod, mob/user)
	if(user.incapacitated || !user.is_holding(src) || !mod || mod.active || mod.activating)
		return FALSE
	return TRUE

#undef MODPAINT_MAX_COLOR_VALUE
#undef MODPAINT_MIN_COLOR_VALUE
#undef MODPAINT_MAX_SECTION_COLORS
#undef MODPAINT_MIN_SECTION_COLORS
#undef MODPAINT_MAX_OVERALL_COLORS
#undef MODPAINT_MIN_OVERALL_COLORS

/obj/item/mod/skin_applier
	name = "模块皮肤应用"
	desc = "这个一次性皮肤涂装器将为特定类型的MOD防护服添加皮肤。必须用于未激活的控制单元。"
	icon = 'icons/obj/clothing/modsuit/mod_construction.dmi'
	icon_state = null
	var/skin = "civilian"

/obj/item/mod/skin_applier/Initialize(mapload)
	. = ..()
	name = "[skin]模块皮肤应用"

/obj/item/mod/skin_applier/interact_with_atom(atom/attacked_atom, mob/living/user, params)
	if(!istype(attacked_atom, /obj/item/mod/control))
		return NONE
	var/obj/item/mod/control/mod = attacked_atom
	if(mod.active || mod.activating)
		balloon_alert(user, "设备已激活！")
		return ITEM_INTERACT_BLOCKING
	if(!(skin in mod.theme.variants))
		balloon_alert(user, "皮肤与主题不匹配！")
		return ITEM_INTERACT_BLOCKING
	mod.theme.set_skin(mod, skin)
	balloon_alert(user, "皮肤已应用")
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/mod/skin_applier/honkerative
	desc = /obj/item/mod/skin_applier::desc + "此外，这个套件尝试安装一个摇摆行走模块。Honk！"
	skin = "honkerative"

/obj/item/mod/skin_applier/honkerative/interact_with_atom(obj/item/mod/control/controlunit, mob/living/user, params)
	. = ..()
	if(!(. & ITEM_INTERACT_SUCCESS))
		return
	controlunit.install(new /obj/item/mod/module/waddle(get_turf(user)), user)
