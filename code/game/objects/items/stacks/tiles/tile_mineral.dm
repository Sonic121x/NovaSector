/obj/item/stack/tile/mineral
	/// Determines what stack is gotten out of us when welded.
	var/mineralType = null

/obj/item/stack/tile/mineral/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(W.tool_behaviour == TOOL_WELDER)
		if(get_amount() < 4)
			to_chat(user, span_warning("你至少需要四块砖才能这么做！"))
			return
		if(!mineralType)
			to_chat(user, span_warning("你无法重塑这个！"))
			stack_trace("A mineral tile of type [type] doesn't have its mineralType set.")
			return
		if(W.use_tool(src, user, 0, volume=40))
			var/sheet_type = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
			var/obj/item/stack/sheet/mineral/new_item = new sheet_type(user.loc)
			user.visible_message(span_notice("[user]用[W]将[src]塑造成了[new_item]。"), \
				span_notice("你用[W]将[src]塑造成了[new_item]。"), \
				span_hear("你听到了焊接声."))
			var/holding = user.is_holding(src)
			use(4)
			if(holding && QDELETED(src))
				user.put_in_hands(new_item)
	else
		return ..()

/obj/item/stack/tile/mineral/plasma
	name = "等离子砖"
	singular_name = "plasma floor tile"
	desc = "一块由高度易燃的等离子体制成的砖。这结局肯定很美好。"
	icon_state = "tile_plasma"
	inhand_icon_state = "tile-plasma"
	turf_type = /turf/open/floor/mineral/plasma
	mineralType = "plasma"
	mats_per_unit = list(/datum/material/plasma=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/plasma

/obj/item/stack/tile/mineral/uranium
	name = "铀砖"
	singular_name = "uranium floor tile"
	desc = "一块由铀制成的砖。你感觉有点头晕。"
	icon_state = "tile_uranium"
	inhand_icon_state = "tile-uranium"
	turf_type = /turf/open/floor/mineral/uranium
	mineralType = "uranium"
	mats_per_unit = list(/datum/material/uranium=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/uranium

/obj/item/stack/tile/mineral/gold
	name = "金砖"
	singular_name = "gold floor tile"
	desc = "一块由黄金制成的砖，这里的炫富气息很浓。"
	icon_state = "tile_gold"
	inhand_icon_state = "tile-gold"
	turf_type = /turf/open/floor/mineral/gold
	mineralType = "gold"
	mats_per_unit = list(/datum/material/gold=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/gold

/obj/item/stack/tile/mineral/silver
	name = "银质地砖"
	singular_name = "silver floor tile"
	desc = "由银制成的地砖，其上反射的光芒令人目眩。"
	icon_state = "tile_silver"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/mineral/silver
	mineralType = "silver"
	mats_per_unit = list(/datum/material/silver=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/silver

/obj/item/stack/tile/mineral/diamond
	name = "钻石地砖"
	singular_name = "diamond floor tile"
	desc = "由钻石制成的地砖。哇，真是，哇。"
	icon_state = "tile_diamond"
	inhand_icon_state = "tile-diamond"
	turf_type = /turf/open/floor/mineral/diamond
	mineralType = "diamond"
	mats_per_unit = list(/datum/material/diamond=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/diamond

/obj/item/stack/tile/mineral/bananium
	name = "香蕉矿地砖"
	singular_name = "bananium floor tile"
	desc = "由香蕉矿制成的不打滑地砖，HOOOOOOOOONK！"
	icon_state = "tile_bananium"
	inhand_icon_state = "tile-bananium"
	turf_type = /turf/open/floor/mineral/bananium
	mineralType = "bananium"
	mats_per_unit = list(/datum/material/bananium=SHEET_MATERIAL_AMOUNT*0.25)
	material_flags = NONE //The slippery comp makes it unpractical for good clown decor. The material tiles should still slip.
	merge_type = /obj/item/stack/tile/mineral/bananium

/obj/item/stack/tile/mineral/abductor
	name = "外星地板砖"
	singular_name = "alien floor tile"
	desc = "由外星合金制成的地砖。"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "tile_abductor"
	inhand_icon_state = "tile-abductor"
	mats_per_unit = list(/datum/material/alloy/alien=SHEET_MATERIAL_AMOUNT*0.25)
	turf_type = /turf/open/floor/mineral/abductor
	mineralType = "abductor"
	merge_type = /obj/item/stack/tile/mineral/abductor

/obj/item/stack/tile/mineral/titanium
	name = "钛质地砖"
	singular_name = "titanium floor tile"
	desc = "光滑的钛质地砖，用于航天飞机。"
	icon_state = "tile_titanium"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/mineral/titanium
	mineralType = "titanium"
	mats_per_unit = list(/datum/material/titanium=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/titanium
	tile_reskin_types = list(
		/obj/item/stack/tile/mineral/titanium,
		/obj/item/stack/tile/mineral/titanium/yellow,
		/obj/item/stack/tile/mineral/titanium/blue,
		/obj/item/stack/tile/mineral/titanium/white,
		/obj/item/stack/tile/mineral/titanium/purple,
		/obj/item/stack/tile/mineral/titanium/tiled,
		/obj/item/stack/tile/mineral/titanium/tiled/yellow,
		/obj/item/stack/tile/mineral/titanium/tiled/blue,
		/obj/item/stack/tile/mineral/titanium/tiled/white,
		/obj/item/stack/tile/mineral/titanium/tiled/purple,
		)

/obj/item/stack/tile/mineral/titanium/yellow
	name = "黄色钛质地砖"
	singular_name = "yellow titanium floor tile"
	desc = "光滑的黄色钛质地砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/yellow
	icon_state = "tile_titanium_yellow"
	merge_type = /obj/item/stack/tile/mineral/titanium/yellow

/obj/item/stack/tile/mineral/titanium/blue
	name = "蓝色钛质地砖"
	singular_name = "blue titanium floor tile"
	desc = "光滑的蓝色钛质地砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/blue
	icon_state = "tile_titanium_blue"
	merge_type = /obj/item/stack/tile/mineral/titanium/blue

/obj/item/stack/tile/mineral/titanium/white
	name = "白色钛质地砖"
	singular_name = "white titanium floor tile"
	desc = "光滑的白色钛质地砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/white
	icon_state = "tile_titanium_white"
	merge_type = /obj/item/stack/tile/mineral/titanium/white

/obj/item/stack/tile/mineral/titanium/purple
	name = "紫色钛质地砖"
	singular_name = "purple titanium floor tile"
	desc = "光滑的紫色钛质地砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/purple
	icon_state = "tile_titanium_purple"
	merge_type = /obj/item/stack/tile/mineral/titanium/purple

/obj/item/stack/tile/mineral/titanium/tiled
	name = "拼花钛质地砖"
	singular_name = "tiled titanium floor tile"
	desc = "钛质地板砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/tiled
	icon_state = "tile_titanium_tiled"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled

/obj/item/stack/tile/mineral/titanium/tiled/yellow
	name = "黄色钛合金地砖"
	singular_name = "yellow titanium floor tile"
	desc = "黄色钛合金地板砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/tiled/yellow
	icon_state = "tile_titanium_tiled_yellow"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/yellow

/obj/item/stack/tile/mineral/titanium/tiled/blue
	name = "蓝色钛合金地砖"
	singular_name = "blue titanium floor tile"
	desc = "蓝色钛合金地板砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/tiled/blue
	icon_state = "tile_titanium_tiled_blue"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/blue

/obj/item/stack/tile/mineral/titanium/tiled/white
	name = "白色钛合金地砖"
	singular_name = "white titanium floor tile"
	desc = "白色钛合金地板砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/tiled/white
	icon_state = "tile_titanium_tiled_white"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/white

/obj/item/stack/tile/mineral/titanium/tiled/purple
	name = "紫色钛合金地砖"
	singular_name = "purple titanium floor tile"
	desc = "紫色钛合金地板砖，用于航天飞机。"
	turf_type = /turf/open/floor/mineral/titanium/tiled/purple
	icon_state = "tile_titanium_tiled_purple"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/purple

/obj/item/stack/tile/mineral/plastitanium
	name = "塑钛地砖"
	singular_name = "plastitanium floor tile"
	desc = "由塑钛制成的地砖，用于非常邪恶的航天飞机。"
	icon_state = "tile_plastitanium"
	inhand_icon_state = "tile-darkshuttle"
	turf_type = /turf/open/floor/mineral/plastitanium
	mineralType = "plastitanium"
	mats_per_unit = list(/datum/material/alloy/plastitanium=SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/plastitanium
	tile_reskin_types = list(
		/obj/item/stack/tile/mineral/plastitanium,
		/obj/item/stack/tile/mineral/plastitanium/red,
		)

/obj/item/stack/tile/mineral/plastitanium/red
	name = "红色塑钛地砖"
	singular_name = "red plastitanium floor tile"
	desc = "由塑钛制成的地砖，用于非常红色的航天飞机。"
	turf_type = /turf/open/floor/mineral/plastitanium/red
	icon_state = "tile_plastitanium_red"
	merge_type = /obj/item/stack/tile/mineral/plastitanium/red

/obj/item/stack/tile/mineral/snow
	name = "雪地砖"
	singular_name = "snow tile"
	desc = "一层雪。"
	icon_state = "tile_snow"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/fake_snow
	mineralType = "snow"
	merge_type = /obj/item/stack/tile/mineral/snow
	mats_per_unit = list(/datum/material/snow = HALF_SHEET_MATERIAL_AMOUNT / 2)
