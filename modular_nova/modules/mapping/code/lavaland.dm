/*----- Template for ruins, prevents needing to re-type the filepath prefix -----*/
/datum/map_template/ruin/lavaland/nova
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
/*------*/

/datum/map_template/ruin/lavaland/ash_walker
	name = "熔岩遗迹-灰烬行者巢穴"
	id = "ash-walker"
	description = "A race of unbreathing lizards live here, that run faster than a human can, worship a broken dead city, and are capable of reproducing by something involving tentacles? \
	Probably best to stay clear."
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_ash_walker1.dmm"
	cost = 1000
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/nova/interdyne_base
	name = "熔岩遗迹-因特戴恩制药新星扇区基地 3c76928"
	id = "lava-base"
	description = "一个行星表面的英特戴恩研究设施，致力于开发生物武器；它由一支精英特工小队严密守卫。"
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_interdyne_base1.dmm"
	allow_duplicates = FALSE
	never_spawn_with = list(/datum/map_template/ruin/icemoon/underground/nova/interdyne_base)
	always_place = TRUE

/datum/map_template/ruin/lavaland/arena
	name = "熔岩遗迹-宏伟竞技场"
	id = "arena"
	description = "一座古老的角斗场，里面有一位致命的战士。"
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_arena.dmm"
	cost = 0
	always_place = TRUE //WOULD BE UNFAIR IF SOMETHING THAT IS ALWAYS PLACED HAD A COST...
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/nova/colonist_homestead
	name = "熔岩遗迹-殖民者家园"
	id = "colonist_homestead"
	description = "Some Tiziran bushcraft club members adopted the name of a historical figure for 'immersion.' They didn't realize how hard that would make things..."
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_prefab_homestead.dmm"
	allow_duplicates = FALSE
	cost = 5

/datum/map_template/ruin/lavaland/nova/geosite
	name = "熔岩遗迹-地质站点"
	id = "lava_geosite"
	description = "地质站点开采期间遭遇军团，让所有人都丢了性命。连那个矮人也不例外。"
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_geosite.dmm"
	allow_duplicates = FALSE
	cost = 0 // We'll steal ore vent costs, since this provides 2 vents on lavaland in a public manner
	mineral_cost = 2

/datum/map_template/ruin/lavaland/nova/boss_vent
	name = "熔岩遗迹-仪式地点"
	id = "lava_r_boss_vent"
	description = "一座由石板铺就的神庙，惊扰它便是与内心的恐惧作战。"
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_boss_vent.dmm" // 11x11
	allow_duplicates = FALSE
	cost = 0 // We'll steal ore vent costs for vents
	mineral_cost = 1 //One vent

/datum/map_template/ruin/lavaland/nova/elite_vent
	name = "熔岩遗迹-熔岩井"
	id = "lava_r_elite_vent"
	description = "一个隐藏在小型熔岩湖下的富矿物水井。至少它被铺平了，这还不错。"
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_surface_elite_vent.dmm" // 5x5
	allow_duplicates = FALSE
	cost = 0 // We'll steal ore vent costs for vents
	mineral_cost = 1 //One vent

/datum/map_template/ruin/lavaland/nova/duo_hermit
	name = "熔岩遗迹-双人临时庇护所"
	id = "lavaland-duo-hermit"
	description = "一对隐士的庇护所，他们勉强度日，只为活到明天。"
	prefix = "_maps/RandomRuins/LavaRuins/nova/"
	suffix = "lavaland_duo_hermit.dmm"
	allow_duplicates = FALSE
	cost = 5
