/obj/item/kirbyplants
	name = "盆栽植物"
	icon = 'icons/obj/fluff/flora/plants.dmi'
	icon_state = "plant-01"
	base_icon_state = "plant-01"
	desc = "一小片被装在花盆里的自然。"
	layer = ABOVE_MOB_LAYER
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	item_flags = NO_PIXEL_RANDOM_DROP
	drop_sound = SFX_POTTED_PLANT_DROP
	pickup_sound = SFX_POTTED_PLANT_PICKUP

	/// Can this plant be trimmed by someone with TRAIT_BONSAI
	var/trimmable = TRUE
	/// Whether this plant is dead and requires a seed to revive
	var/dead = FALSE
	///If it's a special named plant, set this to true to prevent dead-name overriding.
	var/custom_plant_name = FALSE
	var/static/list/random_plant_states

/obj/item/kirbyplants/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/tactical)
	AddComponent(/datum/component/two_handed, require_twohands = TRUE, force_unwielded = 10, force_wielded = 10)
	AddElement(/datum/element/beauty, 500)
	if(icon_state != base_icon_state && icon_state != "plant-25") //mapedit support
		base_icon_state = icon_state
	update_appearance()

/obj/item/kirbyplants/update_name(updates)
	. = ..()
	if(custom_plant_name)
		return
	name = "[dead ? "dead ":null][initial(name)]"

/obj/item/kirbyplants/update_desc(updates)
	. = ..()
	desc = dead ? "这些无法辨认的植物残骸让你想往花盆里种点新东西。" : initial(desc)

/obj/item/kirbyplants/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, dead))
		update_appearance()

/obj/item/kirbyplants/update_icon_state()
	. = ..()
	icon_state = dead ? "plant-25" : base_icon_state
	// NOVA EDIT ADDITION START - AESTHETICS
	if(icon_state in modular_states)
		icon = 'modular_nova/modules/aesthetics/plants/icons/plants.dmi'
	else
		icon = 'icons/obj/fluff/flora/plants.dmi'
	// NOVA EDIT ADDITION END

/obj/item/kirbyplants/attackby(obj/item/I, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!dead && trimmable && HAS_TRAIT(user,TRAIT_BONSAI) && isturf(loc) && I.get_sharpness())
		to_chat(user,span_notice("你开始修剪[src]。"))
		if(do_after(user,3 SECONDS,target=src))
			to_chat(user,span_notice("你修剪完了[src]。"))
			change_visual()
	if(dead && istype(I, /obj/item/seeds))
		to_chat(user,span_notice("你开始往花盆里种一颗新种子。"))
		if(do_after(user,3 SECONDS,target=src))
			qdel(I)
			dead = FALSE
			update_appearance()

/// Cycle basic plant visuals
/obj/item/kirbyplants/proc/change_visual()
	if(isnull(random_plant_states))
		random_plant_states = generate_states()
	var/current = random_plant_states.Find(icon_state)
	var/next = WRAP(current+1,1,length(random_plant_states))
	base_icon_state = random_plant_states[next]
	update_appearance(UPDATE_ICON)

/obj/item/kirbyplants/proc/generate_states()
	var/list/plant_states = list()
	for(var/i in 1 to 24)
		var/number
		if(i < 10)
			number = "0[i]"
		else
			number = "[i]"
		plant_states += "plant-[number]"
	plant_states += "applebush"
	plant_states += modular_states // NOVA EDIT ADDITION - AESTHETICS - SEE modular_nova\modules\aesthetics\plants\plants.dm

	return plant_states

/obj/item/kirbyplants/random
	icon = 'icons/obj/fluff/flora/_flora.dmi'
	icon_state = "random_plant"

/obj/item/kirbyplants/random/Initialize(mapload)
	. = ..()
	icon = 'icons/obj/fluff/flora/plants.dmi'
	randomize_base_icon_state()

//Handles randomizing the icon during initialize()
/obj/item/kirbyplants/random/proc/randomize_base_icon_state()
	if(isnull(random_plant_states))
		random_plant_states = generate_states()
	base_icon_state = pick(random_plant_states)
	if(!dead) //no need to update the icon if we're already dead.
		update_appearance(UPDATE_ICON)

/obj/item/kirbyplants/random/dead
	icon_state = "plant-25"
	dead = TRUE

/obj/item/kirbyplants/random/dead/research_director
	name = "研究主管的盆栽植物"
	custom_plant_name = TRUE

/obj/item/kirbyplants/random/dead/update_desc(updates)
	. = ..()
	desc = "A gift from the botanical staff, presented after the RD's reassignment. There's a tag on it that says \"Y'all come back now, y'hear?\"[dead ? "\nIt doesn't look very healthy...":null]"

/obj/item/kirbyplants/random/fullysynthetic
	name = "塑料盆栽植物"
	desc = "一棵看起来廉价又虚假的塑料树。非常适合那些碰什么植物就死什么植物的人。"
	icon_state = "plant-26"
	custom_materials = (list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4))
	trimmable = FALSE

//Handles randomizing the icon during initialize()
/obj/item/kirbyplants/random/fullysynthetic/randomize_base_icon_state()
	base_icon_state = "plant-[rand(26, 29)]"
	update_appearance(UPDATE_ICON)

/obj/item/kirbyplants/photosynthetic
	name = "光合作用盆栽植物"
	desc = "一株生物发光植物。"
	icon_state = "plant-09"
	light_color = COLOR_BRIGHT_BLUE
	light_range = 3

/obj/item/kirbyplants/potty
	name = "盆栽植物波蒂"
	desc = "一名秘密特工，被安插在空间站的酒吧里，以保护那顶神秘的蛋糕帽。"
	icon_state = "potty"
	base_icon_state = "potty"
	custom_plant_name = TRUE
	trimmable = FALSE
	actions_types = list(/datum/action/item_action/toggle_light)
	action_slots = ALL
	light_range = 2
	light_power = 1
	light_system = OVERLAY_LIGHT
	light_on = TRUE
	color = LIGHT_COLOR_DEFAULT

	///Boolean on whether the light is on and flashing.
	var/light_enabled = TRUE

//this is called by the action type as well
/obj/item/kirbyplants/potty/attack_self(mob/user)
	. = ..()
	if(.)
		return .
	light_enabled = !light_enabled
	set_light_on(light_enabled)
	update_item_action_buttons()
	update_appearance(UPDATE_ICON)

/obj/item/kirbyplants/potty/update_overlays()
	. = ..()
	if(dead)
		return .
	if(light_enabled)
		. += "[base_icon_state]_light"

/obj/item/kirbyplants/fern
	name = "被忽视的蕨类植物"
	desc = "一个古老的植物学研究样本，采集自一个早已被遗忘的丛林星球。"
	icon_state = "fern"
	trimmable = FALSE

/obj/item/kirbyplants/fern/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_ALGAE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 5)
