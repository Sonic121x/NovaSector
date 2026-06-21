/obj/item/storage/drone_tools
	name = "内置工具"
	desc = "访问你的内置工具。"
	icon = 'icons/hud/screen_drone.dmi'
	icon_state = "tool_storage"
	storage_type = /datum/storage/drone
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/storage/drone_tools/Initialize(mapload)
	. = ..()

	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/storage/drone_tools/PopulateContents()
	var/list/builtintools = list()
	builtintools += new /obj/item/crowbar/drone(src)
	builtintools += new /obj/item/screwdriver/drone(src)
	builtintools += new /obj/item/wrench/drone(src)
	builtintools += new /obj/item/weldingtool/drone(src)
	builtintools += new /obj/item/wirecutters/drone(src)
	builtintools += new /obj/item/multitool/drone(src)
	builtintools += new /obj/item/pipe_dispenser/drone(src)
	builtintools += new /obj/item/t_scanner/drone(src)
	builtintools += new /obj/item/analyzer/drone(src)
	builtintools += new /obj/item/soap/drone(src)

	for(var/obj/item/tool as anything in builtintools)
		tool.AddComponent(/datum/component/holderloving, src)

/obj/item/crowbar/drone
	name = "内置撬棍"
	desc = "集成在你底盘内的撬棍。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "toolkit_engiborg_crowbar"
	inhand_icon_state = "crowbar"
	icon_angle = 0
	item_flags = NO_MAT_REDEMPTION

/obj/item/screwdriver/drone
	name = "内置螺丝刀"
	desc = "集成在你底盘内的螺丝刀。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "toolkit_engiborg_screwdriver"
	post_init_icon_state = null
	inhand_icon_state = "screwdriver"
	item_flags = NO_MAT_REDEMPTION
	random_color = FALSE
	greyscale_config = null
	greyscale_colors = null

/obj/item/screwdriver/drone/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file, mutant_styles) // NOVA EDIT CHANGE - ORIGINAL: separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file)
	. = ..()
	if(!isinhands)
		return
	. += mutable_appearance(icon_file, "screwdriver_head", appearance_flags = RESET_COLOR)

/obj/item/wrench/drone
	name = "内置扳手"
	desc = "集成在你底盘内的扳手。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "toolkit_engiborg_wrench"
	inhand_icon_state = "wrench"
	icon_angle = 0
	item_flags = NO_MAT_REDEMPTION

/obj/item/weldingtool/drone
	name = "内置焊接工具"
	desc = "集成在你底盘内的焊接工具。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "indwelder_cyborg"
	item_flags = NO_MAT_REDEMPTION

/obj/item/wirecutters/drone
	name = "内置钢丝钳"
	desc = "集成在你底盘内的钢丝钳。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "toolkit_engiborg_cutters"
	inhand_icon_state = "cutters"
	item_flags = NO_MAT_REDEMPTION
	random_color = FALSE
	greyscale_config = null
	greyscale_colors = null

/obj/item/multitool/drone
	name = "内置多功能工具"
	desc = "集成在你底盘内的多功能工具。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "toolkit_engiborg_multitool"
	icon_angle = 0
	item_flags = NO_MAT_REDEMPTION
	toolspeed = 0.5

/obj/item/analyzer/drone
	name = "数字气体分析仪"
	desc = "集成在你底盘内的气体分析仪。"
	item_flags = NO_MAT_REDEMPTION

/obj/item/t_scanner/drone
	name = "数字T射线扫描仪"
	desc = "一个内置在你底盘中的T射线扫描仪。"
	item_flags = NO_MAT_REDEMPTION

/obj/item/pipe_dispenser/drone
	name = "内置快速管道分发器"
	desc = "一个内置在你底盘中的快速管道分发器。"
	item_flags = NO_MAT_REDEMPTION
