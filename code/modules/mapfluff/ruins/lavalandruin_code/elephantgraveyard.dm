//******Decoration objects
//***Bone statues and giant skeleton parts.
/obj/structure/statue/bone
	anchored = TRUE
	max_integrity = 120
	impressiveness = 18 // Carved from the bones of a massive creature, it's going to be a specticle to say the least
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	custom_materials = list(/datum/material/bone= SHEET_MATERIAL_AMOUNT * 5)
	abstract_type = /obj/structure/statue/bone

/obj/structure/statue/bone/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_DEFAULT)

/obj/structure/statue/bone/rib
	name = "巨型生物肋骨"
	desc = "这么大的东西居然还活着真是令人难以置信，更别说还能被杀死了。"
	custom_materials = list(/datum/material/bone=SHEET_MATERIAL_AMOUNT * 10)
	icon = 'icons/obj/art/statuelarge.dmi'
	icon_state = "rib"
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "rib"

/obj/structure/statue/bone/skull
	name = "巨型生物头骨"
	desc = "一只死去的巨型怪物张着大嘴。"
	custom_materials = list(/datum/material/bone=SHEET_MATERIAL_AMOUNT * 6)
	icon = 'icons/obj/art/statuelarge.dmi'
	icon_state = "skull"
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "skull"

/obj/structure/statue/bone/skull/half
	desc = "一只死去的巨型怪物张着大嘴。不过这个裂成两半了。"
	custom_materials = list(/datum/material/bone=SHEET_MATERIAL_AMOUNT * 3)
	icon = 'icons/obj/art/statuelarge.dmi'
	icon_state = "skull-half"
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "halfskull"

//***Wasteland floor and rock turfs here.
/turf/open/misc/asteroid/basalt/wasteland //Like a more fun version of living in Arizona.
	name = "龟裂的大地"
	icon = 'icons/turf/floors.dmi'
	icon_state = "wasteland"
	base_icon_state = "wasteland"
	baseturfs = /turf/open/misc/asteroid/basalt/wasteland
	dig_result = /obj/item/stack/ore/glass/basalt
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	slowdown = 0.5
	floor_variance = 30

/turf/open/misc/asteroid/basalt/wasteland/break_tile()
	return

/turf/open/misc/asteroid/basalt/wasteland/Initialize(mapload)
	.=..()
	if(prob(floor_variance))
		icon_state = "[base_icon_state][rand(0,6)]"

/turf/open/misc/asteroid/basalt/wasteland/basin
	icon_state = "wasteland_dug"
	base_icon_state = "wasteland_dug"
	floor_variance = 0
	dug = TRUE

/turf/closed/mineral/strong/wasteland
	name = "古老干燥岩石"
	color = "#B5651D"
	turf_type = /turf/open/misc/asteroid/basalt/wasteland
	baseturfs = /turf/open/misc/asteroid/basalt/wasteland
	icon = 'icons/turf/walls/rock_wall.dmi'
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER

/turf/closed/mineral/strong/wasteland/drop_ores()
	if(prob(10))
		new /obj/item/stack/ore/iron(src)
		new /obj/item/stack/ore/glass(src)
		new /obj/effect/decal/remains/human(src, 1)
	else
		new /obj/item/stack/sheet/bone(src)

//***Oil well puddles.
/obj/structure/sink/oil_well //You're not going to enjoy bathing in this...
	name = "油井"
	desc = "一个冒着热气的油池。倘若蓝空间技术没有在 200 年前就终结了对化石燃料的需求，那么这些石油想必会很有价值。"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "puddle-oil"
	capacity = 20
	dispensedreagent = /datum/reagent/fuel/oil

/obj/structure/sink/oil_well/Initialize(mapload)
	. = ..()
	//I'm pretty much aware that, because how oil wells and sinks work, attackby() won't work unless in combat mode.
	//Thankfully, the user can cast the line from a distance.
	AddComponent(/datum/component/fishing_spot, /datum/fish_source/oil_well)

/obj/structure/sink/oil_well/find_and_mount_on_atom(mark_for_late_init, late_init)
	///Oil wells exist indepent of any wall structure
	return FALSE

/obj/structure/sink/oil_well/attack_hand(mob/user, list/modifiers)
	flick("puddle-oil-splash",src)
	reagents.expose(user, TOUCH, 20) //Covers target in 20u of oil.
	to_chat(user, span_notice("你触碰了油池，结果弄得满身是油。最好用水洗掉。"))

/obj/structure/sink/oil_well/wrench_act(mob/living/user, obj/item/tool)
	//we deconstruct with a shovel
	return NONE

/obj/structure/sink/oil_well/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	flick("puddle-oil-splash",src)
	if(tool.tool_behaviour == TOOL_SHOVEL) //attempt to deconstruct the puddle with a shovel
		to_chat(user, "你用泥土填平了油井。")
		tool.play_tool_sound(src)
		deconstruct(TRUE)
		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/structure/sink/oil_well/atom_deconstruct(dissambled = TRUE)
	new /obj/effect/decal/cleanable/blood/oil(loc)

//***Grave mounds.
/// has no items inside unless you use the filled subtype
/obj/structure/closet/crate/grave
	name = "坟堆"
	desc = "一块有标记的土地，显示出很久以前埋葬过的痕迹。你不会打扰坟墓的……对吧?"
	icon = 'icons/obj/storage/crates.dmi'
	icon_state = "grave"
	base_icon_state = "grave"
	density = FALSE
	material_drop = /obj/item/stack/ore/glass/basalt
	material_drop_amount = 5
	anchorable = FALSE
	anchored = TRUE
	divable = FALSE //As funny as it may be, it would make little sense how you got yourself inside it in first place.
	breakout_time = 2 MINUTES
	open_sound = 'sound/effects/shovel_dig.ogg'
	close_sound = 'sound/effects/shovel_dig.ogg'
	can_install_electronics = FALSE
	can_weld_shut = FALSE
	cutting_tool = null
	paint_jobs = null
	elevation = 4 //It's a small mound.
	elevation_open = 0

	/// will this grave give you nightmares when opened
	var/lead_tomb = FALSE
	/// was this grave opened for the first time
	var/first_open = FALSE
	/// was a shovel used to close this grave
	var/dug_closed = FALSE
	/// do we have a mood effect tied to accessing this type of grave?
	var/affect_mood = FALSE

/obj/structure/closet/crate/grave/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		return NONE

	if(held_item.tool_behaviour == TOOL_SHOVEL)
		context[SCREENTIP_CONTEXT_RMB] = opened ? "Cover up" : "Dig open"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/structure/closet/crate/grave/close(mob/living/user)
	. = ..()
	// So that graves stay undense
	set_density(FALSE)

/obj/structure/closet/crate/grave/examine(mob/user)
	. = ..()
	. += span_notice("可以用铲子[EXAMINE_HINT((opened ? "closed" : "dug open"))]。")

/obj/structure/closet/crate/grave/filled
	affect_mood = TRUE

/obj/structure/closet/crate/grave/filled/PopulateContents()  //GRAVEROBBING IS NOW A FEATURE
	..()
	new /obj/effect/decal/remains/human(src)
	switch(rand(1,8))
		if(1)
			new /obj/item/coin/gold(src)
			new /obj/item/storage/wallet(src)
		if(2)
			new /obj/item/clothing/glasses/meson(src)
		if(3)
			new /obj/item/coin/silver(src)
			new /obj/item/shovel/spade(src)
		if(4)
			new /obj/item/book/bible/booze(src)
		if(5)
			new /obj/item/clothing/neck/stethoscope(src)
			new /obj/item/scalpel(src)
			new /obj/item/hemostat(src)

		if(6)
			new /obj/item/reagent_containers/cup/beaker(src)
			new /obj/item/clothing/glasses/science(src)
		if(7)
			new /obj/item/clothing/glasses/sunglasses/big(src)
			new /obj/item/cigarette/rollie(src)
		else
			//empty grave
			return

/obj/structure/closet/crate/grave/closet_update_overlays(list/new_overlays)
	return

/obj/structure/closet/crate/grave/before_open(mob/living/user, force)
	. = ..()
	if(!.)
		return FALSE

	if(!force)
		to_chat(user, span_notice("这里的土地太硬了，光用手挖不动。你需要一把铲子。"))
		return FALSE

	return TRUE

/obj/structure/closet/crate/grave/before_close(mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	if(!dug_closed)
		to_chat(user, span_notice("你需要一把铲子才能把它埋上。"))
		return FALSE

	dug_closed = FALSE
	return TRUE

/obj/structure/closet/crate/grave/tool_interact(obj/item/weapon, mob/living/carbon/user)
	//anything that isn't a shovel does normal stuff to the grave[like putting stuff in]
	if(weapon.tool_behaviour != TOOL_SHOVEL)
		return ..()

	//player is attempting to open/close the grave with a shovel
	if(!user.combat_mode)
		user.visible_message(
			span_notice("[user] Is attempting to [opened ? "close" : "dig open"] [src]."),
			span_notice("You start [opened ? "closing" : "digging open"] [src]."),
		)
		if(!weapon.use_tool(src, user, delay = 15, volume = 40))
			return TRUE

		var/is_chill_with_robbing = HAS_MIND_TRAIT(user, TRAIT_MORBID) || HAS_PERSONALITY(user, /datum/personality/callous) || HAS_PERSONALITY(user, /datum/personality/misanthropic)
		if(opened)
			dug_closed = TRUE
			close(user)
		else if(open(user, force = TRUE) && affect_mood)
			user.add_mood_event("graverobbing", is_chill_with_robbing ? /datum/mood_event/morbid_graverobbing : /datum/mood_event/graverobbing)
			if(lead_tomb && first_open)
				if(is_chill_with_robbing)
					to_chat(user, span_notice("有人说了什么吗？肯定没什么。"))
				else
					user.gain_trauma(/datum/brain_trauma/magic/stalker)
					to_chat(user, span_boldwarning("哦不，不不不，他们无处不在！他们每一个都无处不在！"))
				first_open = FALSE

		return TRUE

	//player is attempting to destroy the open grave with a shovel
	else
		if(!opened)
			return TRUE

		user.visible_message(
			span_notice("[user] 正试图移除 [src]。"),
			span_notice("你开始移除 [src]。"),
		)
		if(!weapon.use_tool(src, user, delay = 15, volume = 40) || !opened)
			return TRUE

		to_chat(user, span_notice("你完全移除了\the [src]。"))
		user.add_mood_event("graverobbing", /datum/mood_event/graverobbing)
		deconstruct(TRUE)
		return TRUE

/obj/structure/closet/crate/grave/container_resist_act(mob/living/user, loc_required = TRUE)
	if(opened)
		return
	// The player is trying to dig themselves out of an early grave
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(
		span_warning("[src] 的泥土开始移动并隆隆作响！"),
		span_notice("你绝望地开始抓挠周围的泥土，试图将自己从土壤中向上推挤出来...（这大约需要 [DisplayTimeText(breakout_time)]。）"),
		span_hear("你听到 [src] 传来泥土移动的声音。"),
	)
	if(do_after(user, breakout_time, target = src))
		if(opened)
			return
		user.visible_message(
			span_danger("[user] 从 [src] 中钻了出来，泥土散落得到处都是！"),
			span_notice("你胜利地从 [src] 中钻了出来，泥土散落在坟墓周围！"),
		)
		bust_open()
	else
		if(user.loc == src)
			to_chat(user, span_warning("你没能把自己从 [src] 里挖出来！"))

/obj/structure/closet/crate/grave/fresh
	name = "临时坟墓"
	desc = "一个匆忙挖掘的坟墓。这绝对没有六英尺深，但足以容纳一具尸体。"
	icon = 'icons/obj/storage/crates.dmi'
	icon_state = "grave_fresh"
	base_icon_state = "grave_fresh"
	material_drop_amount = 0

/obj/structure/closet/crate/grave/filled/lead_researcher
	name = "不祥的坟堆"
	desc = "即使在一个遍地都是坟墓的地方，这个坟墓所展现出的准备和规划程度也让你充满了恐惧。"
	icon = 'icons/obj/storage/crates.dmi'
	icon_state = "grave_lead"
	lead_tomb = TRUE
	first_open = TRUE

/obj/structure/closet/crate/grave/filled/lead_researcher/PopulateContents()  //ADVANCED GRAVEROBBING
	..()
	new /obj/effect/decal/cleanable/blood/gibs/old(src)
	new /obj/item/book/granter/crafting_recipe/boneyard_notes(src)

//***Fluff items for lore/intrigue
/obj/item/paper/crumpled/muddy/fluff/elephant_graveyard
	name = "发布警告"
	desc = "它似乎被泥巴弄脏了……石油?"
	default_raw_text = "<B>致相关人士</B><BR><BR>此区域为纳米传讯矿业部门所有。<BR><BR>擅自进入此区域是违法的、高度危险的，并且受多项保密协议约束。<br><br>请立即返回，依据星际法律第48-R条。"

/obj/item/paper/crumpled/muddy/fluff/elephant_graveyard/rnd_notes
	name = "研究成果：第26天"
	desc = "这一页看起来像是从整本书里撕下来的。多么奇怪。"
	icon_state = "docs_part"
	default_raw_text = "<b>Researcher name:</b> B--*--* J--*s.<BR><BR>Detailed findings:<i>Today the camp site's cond-tion has wor--ene*. The ashst--ms keep blocking us off from le-ving the sit* for m-re supplies, and it's lo-king like we're out of pl*sma to p-wer the ge-erat*r. Can't rea-*y study c-*bon *ating with no li--ts, ya know? Da-*y's been going -*f again and ag-*n a-*ut h*w the company's left us to *ie here, but I j-s* keep tell-ng him to stop che*-in* out these damn graves. We m-y b*  archaeologists, but -e sho*ld have t-e dec-**cy to know these grav-s are *-l NEW.</i><BR><BR><b>The rest of the page is just semantics about carbon dating methods.</b>"

/obj/item/paper/crumpled/muddy/fluff/elephant_graveyard/mutiny
	name = "字迹潦草的笔记"
	desc = "看来当时有人在赶时间嘛。"
	default_raw_text = "Alright, we all know that stuck up son a bitch is just doing this to keep us satisifed. Who the hell does he think he is, taking extra rations? We're OUT OF FOOD, CARL. Tomorrow at noon, we're going to try and take the ship by force. He HAS to be lying about the engine cooling down. He HAS TO BE. I'm tellin ya, with this implant I lifted off that last supply ship, I got the smarts to get us offa this shithole. Keep your knife handy carl."

/obj/item/paper/fluff/ruins/elephant_graveyard/hypothesis
	name = "研究文件"
	desc = "重要研究文件的标准纳米传讯字体。"
	default_raw_text = "<b>Day 9: Tenative Conclusions</b><BR><BR>While the area appears to be of significant cultural importance to the lizard race, outside of some sparce contact with native wildlife, we're yet to find any exact reasoning for the nature of this phenomenon. It seems that organic life is communally drawn to this planet as though it functions as a final resting place for intelligent life. As per company guidelines, this site shall be given the following classification: 'LZ-0271 - Elephant Graveyard' <BR><BR><u>Compiled list of Artifact findings (Currently Sent Offsite)</u><BR>Cultist Blade Fragments: x8<BR>Brass Multiplicative Ore Sample: x105<BR>Syndicate Revolutionary Leader Implant (Broken) x1<BR>Extinct Cortical Borer Tissue Sample x1<BR>Space Carp Fossil x3"

/obj/item/paper/fluff/ruins/elephant_graveyard/final_message
	name = "好像很重要的笔记"
	desc = "这张纸条写得很好，好像是特意放在这里的，所以你会发现。"
	default_raw_text = "If you find this... you don't need to know who I am.<BR><BR>You need to leave this place. I dunno what shit they did to me out here, but I don't think I'm going to be making it out of here.<BR><BR>This place... it wears down your psyche. The other researchers out here laughed it off but... They were the first to go.<BR><BR>One by one they started turning on each other. The more they found out, the more they started fighting and arguing...<BR>As I speak now, I had to... I wound up having to put most of my men down. I know what I had to do, and I know there's no way left for me to live with myself.<BR> If anyone ever finds this, just don't touch the graves.<BR><BR>DO NOT. TOUCH. THE GRAVES. Don't be a dumbass, like we all were."
