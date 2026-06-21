/obj/structure/window/fulltile/colony_fabricator
	name = "预制窗户"
	desc = "一个保守建造的金属框架，里面镶嵌着一块厚厚的太空级玻璃板。"
	icon = 'modular_nova/modules/colony_fabricator/icons/prefab_window.dmi'
	icon_state = "prefab-0"
	base_icon_state = "prefab"
	fulltile = TRUE
	glass_type = /obj/item/stack/sheet/plastic_wall_panel
	glass_amount = 1
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.5)

/obj/structure/grille/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/stack/sheet/plastic_wall_panel))
		return ..()

	if(broken)
		return
	var/obj/item/stack/stack_in_question = attacking_item
	if(stack_in_question.get_amount() < 1)
		to_chat(user, span_warning("你至少需要一块塑料面板才能那样做！"))
		return
	var/dir_to_set = SOUTHWEST
	if(!anchored)
		to_chat(user, span_warning("[src]需要先固定在地板上！"))
		return
	for(var/obj/structure/window/window_on_turf in loc)
		to_chat(user, span_warning("那里已经有一扇窗户了！"))
		return
	if(!clear_tile(user))
		return
	to_chat(user, span_notice("你开始安装窗户..."))
	if(!do_after(user, 1 SECONDS, target = src))
		return
	if(!src.loc || !anchored) //Grille broken or unanchored while waiting
		return
	for(var/obj/structure/window/window_on_turf in loc) //Another window already installed on grille
		return
	if(!clear_tile(user))
		return
	var/obj/structure/window/new_window = new /obj/structure/window/fulltile/colony_fabricator(drop_location())
	new_window.setDir(dir_to_set)
	new_window.state = 0
	stack_in_question.use(1)
	to_chat(user, span_notice("你将[new_window]安装到[src]上。"))
