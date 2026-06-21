/*----- Template for ruins, prevents needing to re-type the filepath prefix -----*/
/datum/map_template/ruin/icemoon/underground/nova/
	prefix = "_maps/RandomRuins/IceRuins/nova/"

/datum/map_template/ruin/icemoon/nova/
	prefix = "_maps/RandomRuins/IceRuins/nova/"
/*----- Underground -----*/

/datum/map_template/ruin/icemoon/underground/nova/interdyne_base
	name = "冰原遗迹英特戴恩制药新星扇区基地 8817238"
	id = "ice-base"
	description = "一个行星际动力研究设施，正在开发生物武器；它由一支精英特工小队严密守卫。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_interdyne_base1.dmm"
	allow_duplicates = FALSE
	never_spawn_with = list(/datum/map_template/ruin/lavaland/nova/interdyne_base)
	always_place = TRUE

/datum/map_template/ruin/icemoon/underground/nova/magic_hotsprings
	name = "魔法温泉"
	id = "magic-hotsprings"
	description = "一处美丽的温泉点，周围环绕着不自然的仙草和奇异的树木。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_magical_hotsprings.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/underground/nova/abandoned_hearth
	name = "废弃的壁炉"
	id = "abandoned-hearth"
	description = "如果挣扎的迹象能说明什么的话，这个炉心出了可怕的问题。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_abandoned_icewalker_den.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/underground/nova/duo_hermit
	name = "冰原遗迹双人隐士"
	id = "icemoon-duo-hermit"
	description = "一对隐士的庇护所，勉强维持生计以求活过另一天。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_duo_hermit.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/underground/nova/abandoned_sacred_temple
	name = "神圣殿堂"
	id = "abandoned-sacred-temple"
	description = "一座布满灰尘的寺庙遗迹，本质神圣。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_abandoned_sacred_temple.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/underground/nova/ice_boss_vent
	name = "冰封遗迹仪式地点"
	id = "ice_r_boss_vent"
	description = "他们相信献祭能带来更多回报。他们并未准备好面对其傲慢的陨落。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_boss_vent.dmm"
	allow_duplicates = FALSE
	cost = 0
	mineral_cost = 1

/datum/map_template/ruin/icemoon/underground/nova/ice_elite_vent
	name = "冰原遗迹-冻结深井地点"
	id = "ice_r_elite_vent"
	description = "吉米从未掉进井里。但走出来的也不是吉米"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_elite_vent.dmm"
	allow_duplicates = FALSE
	cost = 0
	mineral_cost = 1

//Code for the Abandoned Sacred Temple
/obj/structure/statue/hearthkin/odin
	name = "奥丁雕像"
	desc = "一座黄金雕像，代表着众神之父奥丁。它奇怪地保持着完好的状态。"
	icon = 'modular_nova/modules/primitive_catgirls/icons/gods_statue.dmi'
	icon_state = "odin_statue"

/obj/item/paper/crumpled/bloody/fluff/stations/lavaland/sacred_temple/
	name = "2283年，第34个月亮"
	desc = "一张用Ættmál语写的便条。它似乎是从某种日记上撕下来的。"
	default_raw_text = "<i>I refuse to believe we're reduced to this- to sacrifice our own in hopes of our gods taking pity and rescuing us. We've lost too many already... I regret not joining with the rest. But I won't sit here and wait for my turn to be sacrificed, moping about like some sort of useless bastard. Me, my husband, and my sibling Halko will soon make our move, once the grand priest goes to sleep.</i>"

/obj/item/paper/crumpled/bloody/fluff/stations/lavaland/sacred_temple/ui_status(mob/user, datum/ui_state/state)
	if(!user.has_language(/datum/language/primitive_catgirl))
		to_chat(user, span_warning("这似乎是一种你不理解的语言！"))
		return UI_CLOSE

	. = ..()

//declaration for the Frozenwake ruin, the rest can be found in modular_nova\modules\mapping\code\frozenwake.dm
/datum/map_template/ruin/icemoon/underground/nova/frozenwake
	name = "frozenwake"
	id = "frozenwake"
	description = "一座被遗忘的炉心族神殿，掩埋在冰层与寂静之中，古老的符文低语着陨落的光芒与久候的归来。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_underground_frozenwake.dmm"
	allow_duplicates = FALSE

/*----- Above Ground -----*/
////// Yes, I know the "Above Ground" Is very limited in space. This is a... ~17x17? ruin.
/datum/map_template/ruin/icemoon/nova/turret_bunker
	name = "冰原遗迹地表地质研究掩体"
	id = "turret_bunker"
	description = "一个用于冰卫星地质勘测的简陋研究掩体。然而，其居民在一次电力事件后忘记清除炮塔的人工智能。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_surface_turretbunker.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/nova/snow_geosite
	name = "冰原遗迹地表地质站点"
	id = "snow_geosite"
	description = "地质站点测试期间发生的事故夺走了一个可怜人的生命。总之，掷一个d10来搜刮尸体。"
	prefix = "_maps/RandomRuins/IceRuins/nova/"
	suffix = "icemoon_surface_geosite.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/nova/anchor_buoy
	name = "冰原遗迹地表锚定浮标"
	id = "nova-anchor-buoy-icemoon-1"
	description = "一个用于测绘未探索冻原的小型单向发射导航信标。"
	suffix = "icemoon_beacon.dmm"
	cost = 0
	always_place = TRUE
	allow_duplicates = FALSE
