/**
 * TILE STACKS
 *
 * Allows us to place a turf on a plating.
 */
/obj/item/stack/tile
	name = "破损的地砖"
	singular_name = "broken tile"
	desc = "一块破损的地砖。这不应该存在。"
	lefthand_file = 'icons/mob/inhands/items/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/tiles_righthand.dmi'
	icon = 'icons/obj/tiles.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	novariants = TRUE
	material_flags = MATERIAL_EFFECTS
	/// What type of turf does this tile produce.
	var/turf_type = null
	/// What dir will the turf have?
	var/turf_dir = SOUTH
	/// Cached associative lazy list to hold the radial options for tile reskinning. See tile_reskinning.dm for more information. Pattern: list[type] -> image
	var/list/tile_reskin_types
	/// Cached associative lazy list to hold the radial options for tile dirs. See tile_reskinning.dm for more information.
	var/list/tile_rotate_dirs
	/// tile_rotate_dirs but before it gets converted to text
	var/list/tile_rotate_dirs_number

/obj/item/stack/tile/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little
	AddElement(/datum/element/openspace_item_click_handler)
	if(tile_reskin_types)
		tile_reskin_types = tile_reskin_list(tile_reskin_types)
	if(tile_rotate_dirs)
		tile_rotate_dirs_number = tile_rotate_dirs.Copy()
		var/list/values = list()
		for(var/set_dir in tile_rotate_dirs)
			values += dir2text(set_dir)
		tile_rotate_dirs = tile_dir_list(values, turf_type)


/obj/item/stack/tile/examine(mob/user)
	. = ..()
	if(tile_reskin_types || tile_rotate_dirs)
		. += span_notice("拿在手中使用时，可以更改你想要的 [src] 类型。")
	if(throwforce && !is_cyborg) //do not want to divide by zero or show the message to borgs who can't throw
		var/damage_value
		switch(ceil(MAX_LIVING_HEALTH / throwforce)) //throws to crit a human
			if(1 to 3)
				damage_value = "superb"
			if(4 to 6)
				damage_value = "great"
			if(7 to 9)
				damage_value = "good"
			if(10 to 12)
				damage_value = "fairly decent"
			if(13 to 15)
				damage_value = "mediocre"
		if(!damage_value)
			return
		. += span_notice("这些可以作为 [damage_value] 投掷武器使用。")

/**
 * Place our tile on a plating, or replace it.
 *
 * Arguments:
 * * target_plating - Instance of the plating we want to place on. Replaced during successful executions.
 * * user - The mob doing the placing.
 */
/obj/item/stack/tile/proc/place_tile(turf/open/floor/plating/target_plating, mob/user)
	var/turf/placed_turf_path = turf_type
	if(!ispath(placed_turf_path))
		return
	if(!istype(target_plating))
		return

	if(!use(1))
		return
	target_plating = target_plating.place_on_top(placed_turf_path, flags = CHANGETURF_INHERIT_AIR)
	target_plating.setDir(turf_dir)
	playsound(target_plating, 'sound/items/weapons/genhit.ogg', 50, TRUE)
	return target_plating

/obj/item/stack/tile/handle_openspace_click(turf/target, mob/user, list/modifiers)
	target.attackby(src, user, list2params(modifiers))

//Grass
/obj/item/stack/tile/grass
	name = "草皮地砖"
	singular_name = "grass floor tile"
	desc = "一块草皮，就像太空高尔夫球场使用的那种。"
	icon_state = "tile_grass"
	inhand_icon_state = "tile-grass"
	turf_type = /turf/open/floor/grass
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/grass

//Hay
/obj/item/stack/tile/hay
	name = "干草地板砖"
	singular_name = "hay floor tile"
	desc = "天啊，我饿得能吃下一——"
	icon_state = "tile_hay"
	inhand_icon_state = "tile-hay"
	turf_type = /turf/open/floor/hay
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/hay

//Fairygrass
/obj/item/stack/tile/fairygrass
	name = "仙草地板砖"
	singular_name = "fairygrass floor tile"
	desc = "一片奇特的、发着蓝光的草地。"
	icon_state = "tile_fairygrass"
	turf_type = /turf/open/floor/grass/fairy
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fairygrass

//Wood
/obj/item/stack/tile/wood
	name = "木地板砖"
	singular_name = "wood floor tile"
	desc = "易于铺设的木地板砖。拿在手中使用可以更改想要的图案。"
	icon_state = "tile-wood"
	inhand_icon_state = "tile-wood"
	turf_type = /turf/open/floor/wood
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/wood
	tile_reskin_types = list(
		/obj/item/stack/tile/wood,
		/obj/item/stack/tile/wood/large,
		/obj/item/stack/tile/wood/tile,
		/obj/item/stack/tile/wood/parquet,
	)
	mats_per_unit = list(/datum/material/wood = HALF_SHEET_MATERIAL_AMOUNT / 2)

/obj/item/stack/tile/wood/parquet
	name = "拼花木地板砖"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood_parquet"
	turf_type = /turf/open/floor/wood/parquet
	merge_type = /obj/item/stack/tile/wood/parquet

/obj/item/stack/tile/wood/large
	name = "大型木地板砖"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood_large"
	turf_type = /turf/open/floor/wood/large
	merge_type = /obj/item/stack/tile/wood/large

/obj/item/stack/tile/wood/tile
	name = "瓷砖式木地板砖"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood_tile"
	turf_type = /turf/open/floor/wood/tile
	merge_type = /obj/item/stack/tile/wood/tile

//Bamboo
/obj/item/stack/tile/bamboo
	name = "竹席片"
	singular_name = "bamboo mat piece"
	desc = "一片带有装饰边的竹席。"
	icon_state = "tile_bamboo"
	inhand_icon_state = "tile-bamboo"
	turf_type = /turf/open/floor/bamboo
	merge_type = /obj/item/stack/tile/bamboo
	resistance_flags = FLAMMABLE
	tile_reskin_types = list(
		/obj/item/stack/tile/bamboo,
		/obj/item/stack/tile/bamboo/tatami,
		/obj/item/stack/tile/bamboo/tatami/purple,
		/obj/item/stack/tile/bamboo/tatami/black,
	)
	mats_per_unit = list(/datum/material/bamboo = HALF_SHEET_MATERIAL_AMOUNT / 2)

/obj/item/stack/tile/bamboo/tatami
	name = "绿边榻榻米"
	singular_name = "green tatami floor tile"
	icon_state = "tile_tatami_green"
	turf_type = /turf/open/floor/bamboo/tatami
	merge_type = /obj/item/stack/tile/bamboo/tatami
	tile_rotate_dirs = list(NORTH, EAST, SOUTH, WEST)

/obj/item/stack/tile/bamboo/tatami/purple
	name = "紫边榻榻米"
	singular_name = "purple tatami floor tile"
	icon_state = "tile_tatami_purple"
	turf_type = /turf/open/floor/bamboo/tatami/purple
	merge_type = /obj/item/stack/tile/bamboo/tatami/purple

/obj/item/stack/tile/bamboo/tatami/black
	name = "黑边榻榻米"
	singular_name = "black tatami floor tile"
	icon_state = "tile_tatami_black"
	turf_type = /turf/open/floor/bamboo/tatami/black
	merge_type = /obj/item/stack/tile/bamboo/tatami/black

//Basalt
/obj/item/stack/tile/basalt
	name = "玄武岩地板砖"
	singular_name = "basalt floor tile"
	desc = "以敌对环境为主题的人造灰烬土壤。"
	icon_state = "tile_basalt"
	inhand_icon_state = "tile-basalt"
	turf_type = /turf/open/floor/fakebasalt
	merge_type = /obj/item/stack/tile/basalt
	mats_per_unit = list(/datum/material/sand = SHEET_MATERIAL_AMOUNT * 2)

//Carpets
/obj/item/stack/tile/carpet
	name = "地毯"
	singular_name = "carpet tile"
	desc = "一块地毯。其大小与一块地板砖相同。"
	icon_state = "tile-carpet"
	inhand_icon_state = "tile-carpet"
	turf_type = /turf/open/floor/carpet
	resistance_flags = FLAMMABLE
	table_type = /obj/structure/table/wood/fancy
	merge_type = /obj/item/stack/tile/carpet
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet,
		/obj/item/stack/tile/carpet/symbol,
		/obj/item/stack/tile/carpet/star,
	)

/obj/item/stack/tile/carpet/symbol
	name = "符号地毯"
	singular_name = "symbol carpet tile"
	icon_state = "tile-carpet-symbol"
	desc = "一块地毯。这一块上面有一个符号。"
	turf_type = /turf/open/floor/carpet/lone
	merge_type = /obj/item/stack/tile/carpet/symbol
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST)

/obj/item/stack/tile/carpet/star
	name = "星形地毯"
	singular_name = "star carpet tile"
	icon_state = "tile-carpet-star"
	desc = "一块地毯。这块上面有一颗星星。"
	turf_type = /turf/open/floor/carpet/lone/star
	merge_type = /obj/item/stack/tile/carpet/star

/obj/item/stack/tile/carpet/black
	name = "黑色地毯"
	icon_state = "tile-carpet-black"
	inhand_icon_state = "tile-carpet-black"
	turf_type = /turf/open/floor/carpet/black
	table_type = /obj/structure/table/wood/fancy/black
	merge_type = /obj/item/stack/tile/carpet/black
	tile_reskin_types = null

/obj/item/stack/tile/carpet/blue
	name = "蓝色地毯"
	icon_state = "tile-carpet-blue"
	inhand_icon_state = "tile-carpet-blue"
	turf_type = /turf/open/floor/carpet/blue
	table_type = /obj/structure/table/wood/fancy/blue
	merge_type = /obj/item/stack/tile/carpet/blue
	tile_reskin_types = null

/obj/item/stack/tile/carpet/cyan
	name = "青色地毯"
	icon_state = "tile-carpet-cyan"
	inhand_icon_state = "tile-carpet-cyan"
	turf_type = /turf/open/floor/carpet/cyan
	table_type = /obj/structure/table/wood/fancy/cyan
	merge_type = /obj/item/stack/tile/carpet/cyan
	tile_reskin_types = null

/obj/item/stack/tile/carpet/green
	name = "绿色地毯"
	icon_state = "tile-carpet-green"
	inhand_icon_state = "tile-carpet-green"
	turf_type = /turf/open/floor/carpet/green
	table_type = /obj/structure/table/wood/fancy/green
	merge_type = /obj/item/stack/tile/carpet/green
	tile_reskin_types = null

/obj/item/stack/tile/carpet/orange
	name = "橙色地毯"
	icon_state = "tile-carpet-orange"
	inhand_icon_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/orange
	table_type = /obj/structure/table/wood/fancy/orange
	merge_type = /obj/item/stack/tile/carpet/orange
	tile_reskin_types = null

/obj/item/stack/tile/carpet/purple
	name = "紫色地毯"
	icon_state = "tile-carpet-purple"
	inhand_icon_state = "tile-carpet-purple"
	turf_type = /turf/open/floor/carpet/purple
	table_type = /obj/structure/table/wood/fancy/purple
	merge_type = /obj/item/stack/tile/carpet/purple
	tile_reskin_types = null

/obj/item/stack/tile/carpet/red
	name = "红色地毯"
	icon_state = "tile-carpet-red"
	inhand_icon_state = "tile-carpet-red"
	turf_type = /turf/open/floor/carpet/red
	table_type = /obj/structure/table/wood/fancy/red
	merge_type = /obj/item/stack/tile/carpet/red
	tile_reskin_types = null

/obj/item/stack/tile/carpet/royalblack
	name = "皇家黑色地毯"
	icon_state = "tile-carpet-royalblack"
	inhand_icon_state = "tile-carpet-royalblack"
	turf_type = /turf/open/floor/carpet/royalblack
	table_type = /obj/structure/table/wood/fancy/royalblack
	merge_type = /obj/item/stack/tile/carpet/royalblack
	tile_reskin_types = null

/obj/item/stack/tile/carpet/royalblue
	name = "皇家蓝色地毯"
	icon_state = "tile-carpet-royalblue"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/royalblue
	table_type = /obj/structure/table/wood/fancy/royalblue
	merge_type = /obj/item/stack/tile/carpet/royalblue
	tile_reskin_types = null

/obj/item/stack/tile/carpet/executive
	name = "行政地毯"
	icon_state = "tile_carpet_executive"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/executive
	merge_type = /obj/item/stack/tile/carpet/executive
	tile_reskin_types = null

/obj/item/stack/tile/carpet/stellar
	name = "星际地毯"
	icon_state = "tile_carpet_stellar"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/stellar
	merge_type = /obj/item/stack/tile/carpet/stellar
	tile_reskin_types = null

/obj/item/stack/tile/carpet/donk
	name = "\improper Donk公司宣传地毯"
	icon_state = "tile_carpet_donk"
	inhand_icon_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/donk
	merge_type = /obj/item/stack/tile/carpet/donk
	tile_reskin_types = null

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/iron/fifty
	amount = 50

/obj/item/stack/tile/carpet/black/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue/fifty
	amount = 50

/obj/item/stack/tile/carpet/cyan/fifty
	amount = 50

/obj/item/stack/tile/carpet/green/fifty
	amount = 50

/obj/item/stack/tile/carpet/orange/fifty
	amount = 50

/obj/item/stack/tile/carpet/purple/fifty
	amount = 50

/obj/item/stack/tile/carpet/red/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblack/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblue/fifty
	amount = 50

/obj/item/stack/tile/carpet/executive/thirty
	amount = 30

/obj/item/stack/tile/carpet/stellar/thirty
	amount = 30

/obj/item/stack/tile/carpet/donk/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon
	name = "霓虹地毯"
	singular_name = "neon carpet tile"
	desc = "一块橡胶垫，嵌有磷光图案。"
	inhand_icon_state = "tile-neon"
	turf_type = /turf/open/floor/carpet/neon
	merge_type = /obj/item/stack/tile/carpet/neon
	tile_reskin_types = null


	// Neon overlay
	/// The icon used for the neon overlay and emissive overlay.
	var/neon_icon
	/// The icon state used for the neon overlay and emissive overlay.
	var/neon_icon_state
	/// The icon state used for the neon overlay inhands.
	var/neon_inhand_icon_state
	/// The color used for the neon overlay.
	var/neon_color
	/// The alpha used for the emissive overlay.
	var/emissive_alpha = 150

/obj/item/stack/tile/carpet/neon/update_overlays()
	. = ..()
	var/mutable_appearance/neon_overlay = mutable_appearance(neon_icon || icon, neon_icon_state || icon_state, alpha = alpha)
	neon_overlay.color = neon_color
	. += neon_overlay
	. += emissive_appearance(neon_icon || icon, neon_icon_state || icon_state, src, alpha = emissive_alpha)

/obj/item/stack/tile/carpet/neon/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands || !neon_inhand_icon_state)
		return

	var/mutable_appearance/neon_overlay = mutable_appearance(icon_file, neon_inhand_icon_state)
	neon_overlay.color = neon_color
	. += neon_overlay
	. += emissive_appearance(icon_file, neon_inhand_icon_state, src, alpha = emissive_alpha)

/obj/item/stack/tile/carpet/neon/simple
	name = "简约霓虹地毯"
	singular_name = "simple neon carpet tile"
	icon_state = "tile_carpet_neon_simple"
	neon_icon_state = "tile_carpet_neon_simple_light"
	neon_inhand_icon_state = "tile-neon-glow"
	turf_type = /turf/open/floor/carpet/neon/simple
	merge_type = /obj/item/stack/tile/carpet/neon/simple
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple,
		/obj/item/stack/tile/carpet/neon/simple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	neon_inhand_icon_state = "tile-neon-glow-nodots"
	turf_type = /turf/open/floor/carpet/neon/simple
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple,
		/obj/item/stack/tile/carpet/neon/simple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/white
	name = "简约白色霓虹地毯"
	singular_name = "simple white neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/white
	merge_type = /obj/item/stack/tile/carpet/neon/simple/white
	neon_color = COLOR_WHITE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/white,
		/obj/item/stack/tile/carpet/neon/simple/white/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/white/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/white/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/white/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/white,
		/obj/item/stack/tile/carpet/neon/simple/white/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/black
	name = "简约黑色霓虹地毯"
	singular_name = "simple black neon carpet tile"
	neon_icon_state = "tile_carpet_neon_simple_glow"
	turf_type = /turf/open/floor/carpet/neon/simple/black
	merge_type = /obj/item/stack/tile/carpet/neon/simple/black
	neon_color = COLOR_BLACK
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/black,
		/obj/item/stack/tile/carpet/neon/simple/black/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/black/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_glow_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/black/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/black/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/black,
		/obj/item/stack/tile/carpet/neon/simple/black/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/red
	name = "简约红色霓虹地毯"
	singular_name = "simple red neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/red
	merge_type = /obj/item/stack/tile/carpet/neon/simple/red
	neon_color = COLOR_RED
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/red,
		/obj/item/stack/tile/carpet/neon/simple/red/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/red/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/red/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/red/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/red,
		/obj/item/stack/tile/carpet/neon/simple/red/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/orange
	name = "简易橙色霓虹地毯"
	singular_name = "simple orange neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/orange
	merge_type = /obj/item/stack/tile/carpet/neon/simple/orange
	neon_color = COLOR_ORANGE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/orange,
		/obj/item/stack/tile/carpet/neon/simple/orange/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/orange/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/orange/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/orange/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/orange,
		/obj/item/stack/tile/carpet/neon/simple/orange/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/yellow
	name = "简易黄色霓虹地毯"
	singular_name = "simple yellow neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/yellow
	merge_type = /obj/item/stack/tile/carpet/neon/simple/yellow
	neon_color = COLOR_YELLOW
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/yellow,
		/obj/item/stack/tile/carpet/neon/simple/yellow/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/yellow/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/yellow/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/yellow,
		/obj/item/stack/tile/carpet/neon/simple/yellow/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/lime
	name = "简易青柠色霓虹地毯"
	singular_name = "simple lime neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/lime
	merge_type = /obj/item/stack/tile/carpet/neon/simple/lime
	neon_color = COLOR_LIME
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/lime,
		/obj/item/stack/tile/carpet/neon/simple/lime/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/lime/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/lime/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/lime/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/lime,
		/obj/item/stack/tile/carpet/neon/simple/lime/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/green
	name = "简易绿色霓虹地毯"
	singular_name = "simple green neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/green
	merge_type = /obj/item/stack/tile/carpet/neon/simple/green
	neon_color = COLOR_GREEN
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/green,
		/obj/item/stack/tile/carpet/neon/simple/green/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/green/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/green/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/green/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/green,
		/obj/item/stack/tile/carpet/neon/simple/green/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/teal
	name = "简易蓝绿色霓虹地毯"
	singular_name = "simple teal neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/teal
	merge_type = /obj/item/stack/tile/carpet/neon/simple/teal
	neon_color = COLOR_TEAL
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/teal,
		/obj/item/stack/tile/carpet/neon/simple/teal/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/teal/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/teal/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/teal/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/teal,
		/obj/item/stack/tile/carpet/neon/simple/teal/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/cyan
	name = "简易青色霓虹地毯"
	singular_name = "simple cyan neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/cyan
	merge_type = /obj/item/stack/tile/carpet/neon/simple/cyan
	neon_color = COLOR_CYAN
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/cyan,
		/obj/item/stack/tile/carpet/neon/simple/cyan/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/cyan/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/cyan/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/cyan,
		/obj/item/stack/tile/carpet/neon/simple/cyan/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/blue
	name = "简易蓝色霓虹地毯"
	singular_name = "simple blue neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/blue
	merge_type = /obj/item/stack/tile/carpet/neon/simple/blue
	neon_color = COLOR_BLUE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/blue,
		/obj/item/stack/tile/carpet/neon/simple/blue/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/blue/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/blue/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/blue/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/blue,
		/obj/item/stack/tile/carpet/neon/simple/blue/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/purple
	name = "简易紫色霓虹地毯"
	singular_name = "simple purple neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/purple
	merge_type = /obj/item/stack/tile/carpet/neon/simple/purple
	neon_color = COLOR_PURPLE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/purple,
		/obj/item/stack/tile/carpet/neon/simple/purple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/purple/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/purple/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/purple/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/purple,
		/obj/item/stack/tile/carpet/neon/simple/purple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/violet
	name = "简易紫罗兰色霓虹地毯"
	singular_name = "simple violet neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/violet
	merge_type = /obj/item/stack/tile/carpet/neon/simple/violet
	neon_color = COLOR_VIOLET
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/violet,
		/obj/item/stack/tile/carpet/neon/simple/violet/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/violet/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/violet/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/violet/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/violet,
		/obj/item/stack/tile/carpet/neon/simple/violet/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/pink
	name = "简易粉色霓虹地毯"
	singular_name = "simple pink neon carpet tile"
	turf_type = /turf/open/floor/carpet/neon/simple/pink
	merge_type = /obj/item/stack/tile/carpet/neon/simple/pink
	neon_color = COLOR_LIGHT_PINK
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/pink,
		/obj/item/stack/tile/carpet/neon/simple/pink/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/pink/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/pink/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/pink/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/pink,
		/obj/item/stack/tile/carpet/neon/simple/pink/nodots,
	)

/obj/item/stack/tile/carpet/neon/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/white/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/white/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/white/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/black/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/black/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/black/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/red/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/red/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/red/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/orange/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/orange/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/orange/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/yellow/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/yellow/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/yellow/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/lime/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/lime/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/lime/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/green/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/green/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/green/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/teal/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/teal/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/teal/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/cyan/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/cyan/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/cyan/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/blue/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/blue/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/blue/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/purple/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/purple/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/purple/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/violet/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/violet/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/violet/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/pink/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/pink/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/pink/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/white/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/white/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/white/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/black/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/black/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/black/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/red/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/red/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/red/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/orange/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/orange/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/orange/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/lime/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/lime/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/lime/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/green/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/green/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/green/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/teal/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/teal/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/teal/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/blue/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/blue/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/blue/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/purple/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/purple/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/purple/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/violet/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/violet/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/violet/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/pink/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/pink/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/pink/nodots/sixty
	amount = 60

/obj/item/stack/tile/fakespace
	name = "星空地毯"
	singular_name = "astral carpet tile"
	desc = "一块带有逼真星空图案的地毯。"
	icon_state = "tile_space"
	inhand_icon_state = "tile-space"
	turf_type = /turf/open/floor/fakespace
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakespace

/obj/item/stack/tile/fakespace/loaded
	amount = 30

/obj/item/stack/tile/fakepit
	name = "伪装坑洞"
	singular_name = "fake pit"
	desc = "一块带有强制透视坑洞幻觉的地毯。这绝不可能骗到任何人！"
	icon_state = "tile_pit"
	inhand_icon_state = "tile-basalt"
	turf_type = /turf/open/floor/fakepit
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakepit

/obj/item/stack/tile/fakepit/loaded
	amount = 30

/obj/item/stack/tile/fakeice
	name = "伪装冰面"
	singular_name = "fake ice tile"
	desc = "一块带有逼真冰面图案的地砖。"
	icon_state = "tile_ice"
	inhand_icon_state = "tile-diamond"
	turf_type = /turf/open/floor/fakeice
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakeice

/obj/item/stack/tile/fakeice/loaded
	amount = 30

//High-traction
/obj/item/stack/tile/noslip
	name = "高牵引力地砖"
	singular_name = "high-traction floor tile"
	desc = "一块高牵引力地砖。摸起来有橡胶质感。"
	icon_state = "tile_noslip"
	inhand_icon_state = "tile-noslip"
	turf_type = /turf/open/floor/noslip
	merge_type = /obj/item/stack/tile/noslip

/obj/item/stack/tile/noslip/thirty
	amount = 30

/obj/item/stack/tile/noslip/tram
	name = "高牵引力站台地砖"
	singular_name = "high-traction platform tile"
	desc = "一块为有轨电车供电的钛铝感应板。"
	icon_state = "tile_noslip"
	inhand_icon_state = "tile-noslip"
	turf_type = /turf/open/floor/noslip/tram
	merge_type = /obj/item/stack/tile/noslip/tram

/obj/item/stack/tile/tram
	name = "有轨电车平台地砖"
	singular_name = "tram platform"
	desc = "用于有轨电车平台的地砖。"
	icon_state = "darkiron_catwalk"
	inhand_icon_state = "tile-neon"
	turf_type = /turf/open/floor/tram
	merge_type = /obj/item/stack/tile/tram

/obj/item/stack/tile/tram/plate
	name = "线性感应有轨电车地砖"
	singular_name = "linear induction tram tile"
	desc = "带有铝板用于有轨电车推进的地砖。"
	icon_state = "darkiron_plate"
	inhand_icon_state = "tile-neon"
	turf_type = /turf/open/floor/tram/plate
	merge_type = /obj/item/stack/tile/tram/plate

//Circuit
/obj/item/stack/tile/circuit
	name = "蓝色电路地砖"
	singular_name = "blue circuit tile"
	desc = "一块蓝色电路地砖。"
	icon_state = "tile_bcircuit"
	inhand_icon_state = "tile-bcircuit"
	turf_type = /turf/open/floor/circuit
	merge_type = /obj/item/stack/tile/circuit
	tile_reskin_types = list(
		/obj/item/stack/tile/circuit,
		/obj/item/stack/tile/circuit/green,
		/obj/item/stack/tile/circuit/red,
	)
	mats_per_unit = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.05, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.05)

/obj/item/stack/tile/circuit/green
	name = "绿色电路地砖"
	singular_name = "green circuit tile"
	desc = "一块绿色电路地砖。"
	icon_state = "tile_gcircuit"
	inhand_icon_state = "tile-gcircuit"
	turf_type = /turf/open/floor/circuit/green
	merge_type = /obj/item/stack/tile/circuit/green

/obj/item/stack/tile/circuit/green/anim
	turf_type = /turf/open/floor/circuit/green/anim
	merge_type = /obj/item/stack/tile/circuit/green/anim

/obj/item/stack/tile/circuit/red
	name = "红色电路地砖"
	singular_name = "red circuit tile"
	desc = "一块红色电路地砖。"
	icon_state = "tile_rcircuit"
	inhand_icon_state = "tile-rcircuit"
	turf_type = /turf/open/floor/circuit/red
	merge_type = /obj/item/stack/tile/circuit/red

/obj/item/stack/tile/circuit/red/anim
	turf_type = /turf/open/floor/circuit/red/anim
	merge_type = /obj/item/stack/tile/circuit/red/anim

//Pod floor
/obj/item/stack/tile/pod
	name = "舱室地板砖"
	singular_name = "pod floor tile"
	desc = "一块带凹槽的地板砖。"
	icon_state = "tile_pod"
	inhand_icon_state = "tile-pod"
	turf_type = /turf/open/floor/pod
	merge_type = /obj/item/stack/tile/pod
	tile_reskin_types = list(
		/obj/item/stack/tile/pod,
		/obj/item/stack/tile/pod/light,
		/obj/item/stack/tile/pod/dark,
		)

/obj/item/stack/tile/pod/light
	name = "浅色舱室地板砖"
	singular_name = "light pod floor tile"
	desc = "一块浅色的带凹槽地板砖。"
	icon_state = "tile_podlight"
	turf_type = /turf/open/floor/pod/light
	merge_type = /obj/item/stack/tile/pod/light

/obj/item/stack/tile/pod/dark
	name = "深色舱室地板砖"
	singular_name = "dark pod floor tile"
	desc = "一块深色的带凹槽地板砖。"
	icon_state = "tile_poddark"
	turf_type = /turf/open/floor/pod/dark
	merge_type = /obj/item/stack/tile/pod/dark

/obj/item/stack/tile/plastic
	name = "塑料地砖"
	singular_name = "plastic floor tile"
	desc = "一块廉价、脆弱的塑料地板砖。"
	icon_state = "tile_plastic"
	mats_per_unit = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT / 2)
	turf_type = /turf/open/floor/plastic
	merge_type = /obj/item/stack/tile/plastic

/obj/item/stack/tile/material
	name = "地板砖"
	singular_name = "floor tile"
	desc = "你行走的地面。"
	//throwforce = 10 //ORIGINAL
	throwforce = 6 //NOVA EDIT CHANGE
	icon_state = "material_tile"
	inhand_icon_state = "tile"
	turf_type = /turf/open/floor/material
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	merge_type = /obj/item/stack/tile/material

/obj/item/stack/tile/material/place_tile(turf/open/target_plating, mob/user)
	// Save refernce to the materials for the case when we place last tile in the stack
	var/list/saved_mats_per_unit = mats_per_unit
	. = ..()
	var/turf/open/floor/material/floor = .
	floor?.set_custom_materials(saved_mats_per_unit)

/obj/item/stack/tile/eighties
	name = "复古地砖"
	singular_name = "retro floor tile"
	desc = "一叠让你想起放克时代的地砖。在手中使用以选择黑色或红色图案。"
	icon_state = "tile_eighties"
	turf_type = /turf/open/floor/eighties
	merge_type = /obj/item/stack/tile/eighties
	tile_reskin_types = list(
		/obj/item/stack/tile/eighties,
		/obj/item/stack/tile/eighties/red,
	)

/obj/item/stack/tile/eighties/loaded
	amount = 15

/obj/item/stack/tile/eighties/red
	name = "红色复古地砖"
	singular_name = "red retro floor tile"
	desc = "一叠超红的（REDICAL）地砖！在手中使用以选择黑色或红色图案！" //i am so sorry
	icon_state = "tile_eightiesred"
	turf_type = /turf/open/floor/eighties/red
	merge_type = /obj/item/stack/tile/eighties/red

/obj/item/stack/tile/bronze
	name = "青铜地砖"
	singular_name = "bronze floor tile"
	desc = "由高品质青铜制成的叮当作响的地砖。发条构造技术可以最大限度地减少叮当声。"
	icon_state = "tile_brass"
	turf_type = /turf/open/floor/bronze
	mats_per_unit = list(/datum/material/bronze = HALF_SHEET_MATERIAL_AMOUNT / 2)
	merge_type = /obj/item/stack/tile/bronze
	tile_reskin_types = list(
		/obj/item/stack/tile/bronze,
		/obj/item/stack/tile/bronze/flat,
		/obj/item/stack/tile/bronze/filled,
	)

/obj/item/stack/tile/bronze/flat
	name = "平坦青铜地砖"
	singular_name = "flat bronze floor tile"
	icon_state = "tile_reebe"
	turf_type = /turf/open/floor/bronze/flat
	merge_type = /obj/item/stack/tile/bronze/flat

/obj/item/stack/tile/bronze/filled
	name = "填充青铜地砖"
	singular_name = "filled bronze floor tile"
	icon_state = "tile_brass_filled"
	turf_type = /turf/open/floor/bronze/filled
	merge_type = /obj/item/stack/tile/bronze/filled

/obj/item/stack/tile/cult
	name = "雕文地砖"
	singular_name = "engraved floor tile"
	desc = "一种由符文金属制成的奇怪地砖。似乎并没有任何超自然力量。"
	icon_state = "tile_cult"
	turf_type = /turf/open/floor/cult
	mats_per_unit = list(/datum/material/runedmetal=SMALL_MATERIAL_AMOUNT*5)
	merge_type = /obj/item/stack/tile/cult

/// Floor tiles used to test emissive turfs.
/obj/item/stack/tile/emissive_test
	name = "自发光测试地砖"
	singular_name = "emissive test floor tile"
	desc = "一种用于测试自发光地形的夜光地砖。"
	turf_type = /turf/open/floor/emissive_test
	merge_type = /obj/item/stack/tile/emissive_test

/obj/item/stack/tile/emissive_test/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src, alpha = alpha)

/obj/item/stack/tile/emissive_test/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	. += emissive_appearance(standing.icon, standing.icon_state, src, alpha = standing.alpha)

/obj/item/stack/tile/emissive_test/sixty
	amount = 60

/obj/item/stack/tile/emissive_test/white
	name = "白色自发光测试地砖"
	singular_name = "white emissive test floor tile"
	turf_type = /turf/open/floor/emissive_test/white
	merge_type = /obj/item/stack/tile/emissive_test/white

/obj/item/stack/tile/emissive_test/white/sixty
	amount = 60

//Catwalk Tiles
/obj/item/stack/tile/catwalk_tile //This is our base type, sprited to look maintenance-styled
	name = "网格走道板"
	singular_name = "catwalk plating tile"
	desc = "能显示下方内容的铺地板。工程师们的最爱！"
	icon_state = "maint_catwalk"
	inhand_icon_state = "tile-catwalk"
	mats_per_unit = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.2)
	turf_type = /turf/open/floor/catwalk_floor
	merge_type = /obj/item/stack/tile/catwalk_tile //Just to be cleaner, these all stack with each other
	tile_reskin_types = list(
		/obj/item/stack/tile/catwalk_tile,
		/obj/item/stack/tile/catwalk_tile/iron,
		/obj/item/stack/tile/catwalk_tile/iron_white,
		/obj/item/stack/tile/catwalk_tile/iron_dark,
		/obj/item/stack/tile/catwalk_tile/titanium,
		/obj/item/stack/tile/catwalk_tile/iron_smooth //this is the original greenish one
	)

/obj/item/stack/tile/catwalk_tile/sixty
	amount = 60

/obj/item/stack/tile/catwalk_tile/iron
	name = "铁制网格走道地板"
	singular_name = "iron catwalk floor tile"
	icon_state = "iron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron

/obj/item/stack/tile/catwalk_tile/iron_white
	name = "白色网格走道地板"
	singular_name = "white catwalk floor tile"
	icon_state = "whiteiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_white

/obj/item/stack/tile/catwalk_tile/iron_dark
	name = "深色网格走道地板"
	singular_name = "dark catwalk floor tile"
	icon_state = "darkiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_dark

/obj/item/stack/tile/catwalk_tile/titanium
	name = "钛制网格走道地板"
	singular_name = "titanium catwalk floor tile"
	icon_state = "titanium_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/titanium

/obj/item/stack/tile/catwalk_tile/iron_smooth //this is the greenish one
	name = "光滑铁制网格走道地板"
	singular_name = "smooth iron catwalk floor tile"
	icon_state = "smoothiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_smooth

// Glass floors
/obj/item/stack/tile/glass
	name = "玻璃地板"
	singular_name = "glass floor tile"
	desc = "玻璃窗地板，让你能看见……下面不管是什么东西。"
	icon_state = "tile_glass"
	turf_type = /turf/open/floor/glass
	inhand_icon_state = "tile-glass"
	merge_type = /obj/item/stack/tile/glass
	mats_per_unit = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT * 0.25) // 4 tiles per sheet

/obj/item/stack/tile/glass/sixty
	amount = 60

/obj/item/stack/tile/rglass
	name = "强化玻璃地板"
	singular_name = "reinforced glass floor tile"
	desc = "强化玻璃窗地板。这些家伙比它们的上一代强了50%！"
	icon_state = "tile_rglass"
	inhand_icon_state = "tile-rglass"
	turf_type = /turf/open/floor/glass/reinforced
	merge_type = /obj/item/stack/tile/rglass
	mats_per_unit = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.125, /datum/material/glass=SHEET_MATERIAL_AMOUNT * 0.25) // 4 tiles per sheet

/obj/item/stack/tile/rglass/sixty
	amount = 60

/obj/item/stack/tile/glass/plasma
	name = "等离子玻璃地板"
	singular_name = "plasma glass floor tile"
	desc = "等离子玻璃窗地板，用于当……下面的东西对普通玻璃来说太吓人的时候。"
	icon_state = "tile_pglass"
	turf_type = /turf/open/floor/glass/plasma
	merge_type = /obj/item/stack/tile/glass/plasma
	mats_per_unit = list(/datum/material/alloy/plasmaglass = SHEET_MATERIAL_AMOUNT * 0.25)

/obj/item/stack/tile/rglass/plasma
	name = "强化等离子玻璃地板"
	singular_name = "reinforced plasma glass floor tile"
	desc = "强化等离子玻璃窗地板，因为楼下的东西最好真的待在那里别上来。"
	icon_state = "tile_rpglass"
	turf_type = /turf/open/floor/glass/reinforced/plasma
	merge_type = /obj/item/stack/tile/rglass/plasma
	mats_per_unit = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.125, /datum/material/alloy/plasmaglass = SHEET_MATERIAL_AMOUNT * 0.25)
