/**
 * PLATINGS
 *
 * Handle interaction with tiles and lets you put stuff on top of it.
 */
/turf/open/floor/plating
	name = "镀层"
	icon_state = "plating"
	base_icon_state = "plating"
	overfloor_placed = FALSE
	underfloor_accessibility = UNDERFLOOR_INTERACTABLE
	baseturfs = /turf/baseturf_bottom
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	rust_resistance = RUST_RESISTANCE_BASIC

	//Can this plating have reinforced floors placed ontop of it
	var/attachment_holes = TRUE

	//Used for upgrading this into R-Plating
	var/upgradable = TRUE

/turf/open/floor/plating/broken_states()
	return list("damaged1", "damaged2", "damaged4")

/turf/open/floor/plating/burnt_states()
	return list("floorscorched1", "floorscorched2")

/turf/open/floor/plating/examine(mob/user)
	. = ..()
	if(broken || burnt)
		. += span_notice("看起来这些凹痕可以用<i>焊接</i>弄平。")
		return
	if(attachment_holes)
		. += span_notice("有几个可以安装新<i>地砖</i>或加固<i>钢筋</i>的孔洞。")
	else
		. += span_notice("你或许可以用一些<i>地砖</i>在上面建造...")
	if(upgradable)
		. += span_notice("你或许可以用一些塑钢让这层甲板更坚固。")

#define PLATE_REINFORCE_COST 2

/turf/open/floor/plating/attackby(obj/item/C, mob/user, list/modifiers)
	if(..())
		return
	if(istype(C, /obj/item/stack/rods) && attachment_holes)
		if(broken || burnt)
			if(!iscyborg(user))
				to_chat(user, span_warning("先修理甲板！用焊接工具修复损伤。"))
			else
				to_chat(user, span_warning("先修理甲板！用焊接工具或甲板修复工具修复损伤。")) //we don't need to confuse humans by giving them a message about plating repair tools, since only janiborgs should have access to them outside of Christmas presents or admin intervention
			return
		var/obj/item/stack/rods/R = C
		if (R.get_amount() < 2)
			to_chat(user, span_warning("你需要两根钢筋来制作加固地板！"))
			return
		else
			to_chat(user, span_notice("你开始加固地板..."))
			if(do_after(user, 3 SECONDS, target = src))
				if (R.get_amount() >= 2 && !istype(src, /turf/open/floor/engine))
					place_on_top(/turf/open/floor/engine, flags = CHANGETURF_INHERIT_AIR)
					playsound(src, 'sound/items/deconstruct.ogg', 80, TRUE)
					R.use(2)
					to_chat(user, span_notice("你加固了地板。"))
				return
	else if(istype(C, /obj/item/stack/tile))
		if(!broken && !burnt)
			for(var/obj/O in src)
				for(var/M in O.buckled_mobs)
					to_chat(user, span_warning("有人被绑在\the [O]上！解开[M]才能把\him 移开。"))
					return
			var/obj/item/stack/tile/tile = C
			tile.place_tile(src, user)
		else
			if(!iscyborg(user))
				balloon_alert(user, "损坏太严重，需要用焊接工具！")
			else
				balloon_alert(user, "损坏过重，请使用焊接或甲板修复工具！")
	else if(istype(C, /obj/item/cautery/prt)) //plating repair tool
		if((broken || burnt) && C.use_tool(src, user, 0, volume=80))
			to_chat(user, span_danger("你修复了破损铺板上的一些凹痕。"))
			icon_state = base_icon_state
			burnt = FALSE
			broken = FALSE
			update_appearance()
	else if(istype(C, /obj/item/stack/sheet/plasteel) && upgradable) //Reinforcement!
		if(!broken && !burnt)
			var/obj/item/stack/sheet/sheets = C
			if(sheets.get_amount() < PLATE_REINFORCE_COST)
				return
			balloon_alert(user, "正在加固甲板...")
			if(do_after(user, 12 SECONDS, target = src))
				if(sheets.get_amount() < PLATE_REINFORCE_COST)
					return
				sheets.use(PLATE_REINFORCE_COST)
				playsound(src, 'sound/machines/creak.ogg', 100, vary = TRUE)
				place_on_top(/turf/open/floor/plating/reinforced, CHANGETURF_INHERIT_AIR)
		else
			if(!iscyborg(user))
				balloon_alert(user, "损坏过重，请使用焊接工具！")
			else
				balloon_alert(user, "损坏过重，使用焊接或铺板修复工具！")
	else if(istype(C, /obj/item/stack/sheet/mineral/plastitanium) && attachment_holes)
		if(broken || burnt)
			if(!iscyborg(user))
				to_chat(user, span_warning("先修理甲板！用焊接工具修复损伤。"))
			else
				to_chat(user, span_warning("先修理甲板！用焊接工具或甲板修复工具修复损伤。"))
			return
		var/obj/item/stack/sheet/mineral/plastitanium/sheet = C
		if (sheet.get_amount() < 1)
			to_chat(user, span_warning("你手里真的什么都没拿。"))
			return
		else
			balloon_alert(user, "铺设绝缘地板...")
			if(!do_after(user, 1.5 SECONDS, target = src))
				return
			if(sheet.get_amount() < 1 || istype(src, /turf/open/floor/engine/insulation))
				return
			place_on_top(/turf/open/floor/engine/insulation, flags = CHANGETURF_INHERIT_AIR)
			playsound(src, 'sound/items/deconstruct.ogg', 80, TRUE)
			sheet.use(1)
			to_chat(user, span_notice("你给地板做了绝缘处理。"))
			balloon_alert(user, "已绝缘！")

/turf/open/floor/plating/welder_act(mob/living/user, obj/item/I)
	..()
	if((broken || burnt) && I.use_tool(src, user, 0, volume=80))
		to_chat(user, span_danger("你修复了破损铺板上的一些凹痕。"))
		icon_state = base_icon_state
		burnt = FALSE
		broken = FALSE
		update_appearance()

	return TRUE

#undef PLATE_REINFORCE_COST



/turf/open/floor/plating/make_plating(force = FALSE)
	return

/turf/open/floor/plating/foam
	name = "金属泡沫镀层"
	desc = "由金属泡沫制成的薄而脆弱的地板。设计为在战斗姿态下应用时能通过铺砖轻松替换。"
	icon_state = "foam_plating"
	upgradable = FALSE
	attachment_holes = FALSE

/turf/open/floor/plating/foam/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_WELDER, TOOL_ACT_PRIMARY)

/turf/open/floor/plating/foam/burn_tile()
	return //jetfuel can't melt steel foam

/turf/open/floor/plating/foam/break_tile()
	return //jetfuel can't break steel foam...

/turf/open/floor/plating/foam/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!ismetaltile(tool))
		return NONE

	var/obj/item/stack/tile/tiles = tool
	if(!tiles.use(1))
		return ITEM_INTERACT_BLOCKING
	var/obj/lattice = locate(/obj/structure/lattice) in src
	if(lattice)
		qdel(lattice)
	to_chat(user, span_notice("你用铺砖加固了泡沫铺板。"))
	playsound(src, 'sound/items/weapons/Genhit.ogg', 50, TRUE)
	ChangeTurf(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
	return ITEM_INTERACT_SUCCESS

/turf/open/floor/plating/foam/attackby(obj/item/attacking_item, mob/user, list/modifiers)
	playsound(src, 'sound/items/weapons/tap.ogg', 100, TRUE) //The attack sound is muffled by the foam itself
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	if(prob(attacking_item.force * 20 - 25))
		user.visible_message(span_danger("[user]砸穿了[src]！"), \
						span_danger("你用[attacking_item]砸穿了[src]！"))
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	else
		to_chat(user, span_danger("你击中了[src]，但毫无效果！"))

/turf/open/floor/plating/foam/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_TURF && the_rcd.rcd_design_path == /turf/open/floor/plating/rcd)
		return list("delay" = 0, "cost" = 1)

/turf/open/floor/plating/foam/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(rcd_data[RCD_DESIGN_MODE] == RCD_TURF && rcd_data[RCD_DESIGN_PATH] == /turf/open/floor/plating/rcd)
		ChangeTurf(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
		return TRUE
	return FALSE

/turf/open/floor/plating/foam/ex_act()
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return TRUE

//reinforced plating deconstruction states
#define PLATE_INTACT 0
#define PLATE_BOLTS_LOOSENED 1
#define PLATE_CUT 2

/turf/open/floor/plating/reinforced //RCD Proof plating designed to be used on Multi-Z maps to protect the rooms below
	name = "强化钢板"
	desc = "由多层金属构成的厚实、坚固的地板。"
	icon_state = "r_plate-0"

	thermal_conductivity = 0.025
	heat_capacity = INFINITY

	baseturfs = /turf/open/floor/plating
	rcd_proof = TRUE
	upgradable = FALSE
	rust_resistance = RUST_RESISTANCE_REINFORCED

	//Used to track which stage of deconstruction the plate is currently in, Intact > Bolts Loosened > Cut
	var/deconstruction_state = PLATE_INTACT

/turf/open/floor/plating/reinforced/examine(mob/user)
	. += ..()
	. += deconstruction_hints(user)

/turf/open/floor/plating/reinforced/proc/deconstruction_hints(mob/user)
	switch(deconstruction_state)
		if(PLATE_INTACT)
			return span_notice("钢板加固件已用<b>螺栓</b>牢固固定。")
		if(PLATE_BOLTS_LOOSENED)
			return span_notice("钢板加固件已<i>拧松</i>，但仍<b>焊接</b>在钢板上。")
		if(PLATE_CUT)
			return span_notice("钢板加固件已被<i>切开</i>，但仍<b>松散地</b>固定在原处。")

/turf/open/floor/plating/reinforced/update_icon_state()
	icon_state = "r_plate-[deconstruction_state]"
	return ..()

/turf/open/floor/plating/reinforced/attackby(obj/item/tool_used, mob/user, list/modifiers)
	user.changeNext_move(CLICK_CD_MELEE)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("你没有足够的灵巧度来做这件事！"))
		return

	//get the user's location
	if(!isturf(user.loc))
		return //can't do this stuff whilst inside objects and such

	add_fingerprint(user)

	if(deconstruct_steps(tool_used, user))
		return
	return ..()

/turf/open/floor/plating/reinforced/proc/deconstruct_steps(obj/item/tool_used, mob/user)
	switch(deconstruction_state)
		if(PLATE_INTACT)
			if(tool_used.tool_behaviour == TOOL_WRENCH)
				balloon_alert(user, "拧松螺栓...")
				if(tool_used.use_tool(src, user, 10 SECONDS, volume=100))
					if(!istype(src, /turf/open/floor/plating/reinforced) || deconstruction_state != PLATE_INTACT)
						return TRUE
					deconstruction_state = PLATE_BOLTS_LOOSENED
					update_appearance(UPDATE_ICON)
					drop_screws()
					balloon_alert(user, "已移除螺栓")
				return TRUE

		if(PLATE_BOLTS_LOOSENED)
			switch(tool_used.tool_behaviour)
				if(TOOL_WELDER)
					if(!tool_used.tool_start_check(user, amount=3))
						return
					balloon_alert(user, "切割中...")
					if(tool_used.use_tool(src, user, 15 SECONDS, volume=100))
						if(!istype(src, /turf/open/floor/plating/reinforced) || deconstruction_state != PLATE_BOLTS_LOOSENED)
							return TRUE
						deconstruction_state = PLATE_CUT
						update_appearance(UPDATE_ICON)
						balloon_alert(user, "切穿")
					return TRUE

				if(TOOL_SCREWDRIVER)
					balloon_alert(user, "固定螺栓中...")
					if(tool_used.use_tool(src, user, 15 SECONDS, volume=100))
						if(!istype(src, /turf/open/floor/plating/reinforced) || deconstruction_state != PLATE_BOLTS_LOOSENED)
							return TRUE
						deconstruction_state = PLATE_INTACT
						update_appearance(UPDATE_ICON)
						balloon_alert(user, "已固定")
					return TRUE
			return FALSE

		if(PLATE_CUT)
			switch(tool_used.tool_behaviour)
				if(TOOL_CROWBAR)
					balloon_alert(user, "撬开中...")
					if(tool_used.use_tool(src, user, 20 SECONDS, volume=100))
						if(!istype(src,  /turf/open/floor/plating/reinforced) || deconstruction_state != PLATE_CUT)
							return TRUE
						balloon_alert(user, "已撬开")
						new /obj/item/stack/sheet/plasteel(src, 2)
						ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
					return TRUE

				if(TOOL_WELDER)
					if(!tool_used.tool_start_check(user, amount=3))
						return
					balloon_alert(user, "焊回中...")
					if(tool_used.use_tool(src, user, 15 SECONDS, volume=100))
						if(!istype(src,  /turf/open/floor/plating/reinforced) || deconstruction_state != PLATE_CUT)
							return TRUE
						deconstruction_state = PLATE_BOLTS_LOOSENED
						update_appearance(UPDATE_ICON)
						balloon_alert(user, "已焊回")
					return TRUE
			return FALSE
	return FALSE

/turf/open/floor/plating/reinforced/proc/drop_screws() //When you start dismantling R-Plates they'll drop their bolts on the Z-level below, a little visible warning.
	var/turf/below_turf = get_step_multiz(src, DOWN)
	while(istype(below_turf, /turf/open/openspace))
		below_turf = get_step_multiz(below_turf, DOWN)
	if(!isnull(below_turf) && !isspaceturf(below_turf))
		new /obj/effect/decal/cleanable/glass/plastitanium/screws(below_turf)
		playsound(src, 'sound/effects/structure_stress/pop3.ogg', 100, vary = TRUE)

/turf/open/floor/plating/reinforced/airless
	initial_gas_mix = AIRLESS_ATMOS

///not an actual turf its used just for rcd ui purposes
/turf/open/floor/plating/rcd
	name = "Floor/Wall"
	icon = 'icons/hud/radial.dmi'
	icon_state = "wallfloor"

#undef PLATE_INTACT
#undef PLATE_BOLTS_LOOSENED
#undef PLATE_CUT
