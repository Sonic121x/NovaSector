// Hey! Listen! Update \config\jungleruinblacklist.txt with your new ruins!

/// Surface ///
/datum/map_template/ruin/jungle
	ruin_type = ZTRAIT_JUNGLE_RUINS
	prefix = "_maps/RandomRuins/JungleRuins/"
	default_area = /area/forestplanet/outdoors/unexplored
	cost = 1
	allow_duplicates = FALSE

/datum/map_template/ruin/jungle/luna
	id = "surface_luna"
	suffix = "surface_luna.dmm"
	name = "丛林地表-遗迹 LUNA"
	description = "一位逝去梦想家的梦想。"
	cost = 0
	always_place = TRUE

/datum/map_template/ruin/jungle/blooddraw
	id = "surface_blooddraw"
	suffix = "surface_blooddraw.dmm"
	name = "丛林地表-遗迹血液作业场"
	description = "出于某些愚蠢的原因，许多献血诊所在克隆技术被禁止后就关闭了。这就是其中之一。"

/datum/map_template/ruin/jungle/fountain
	name = "丛林地表-遗迹喷泉大厅"
	id = "jungle_fountain"
	description = "喷泉侧面有一个警告。危险：可能具有未声明的副作用，仅在实施后才会显现。"
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "fountain_hall.dmm"

/// Caves ///
/datum/map_template/ruin/jungle_cave
	ruin_type = ZTRAIT_JUNGLE_CAVE_RUINS
	prefix = "_maps/RandomRuins/JungleRuins/"
	default_area = /area/forestplanet/outdoors/unexplored/deep
	cost = 1
	allow_duplicates = FALSE

/datum/map_template/ruin/jungle_cave/trilogy_research
	id = "caves_trilogy_research"
	suffix = "caves_trilogy_research.dmm"
	name = "丛林洞穴-遗迹三部曲（研究部门）"
	description = "我们曾试图赚取数百万；但没成功。其他东西拥有更好的市场份额。"
