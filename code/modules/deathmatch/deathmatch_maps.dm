/datum/lazy_template/deathmatch
	map_dir = "_maps/minigame/deathmatch"
	place_on_top = TRUE
	turf_reservation_type = /datum/turf_reservation/turf_not_baseturf
	/// Map UI Name
	var/name
	/// Map Description
	var/desc = ""
	/// Minimum players for this map
	var/min_players = 2
	/// Maximum players for this map
	var/max_players = 2 // TODO: make this automatic.
	/// The map will end in this time
	var/automatic_gameend_time = 8 MINUTES
	/// List of allowed loadouts for this map, otherwise defaults to all loadouts
	var/list/allowed_loadouts = list()
	/// whether we are currently being loaded by a lobby
	var/template_in_use = FALSE

/datum/lazy_template/deathmatch/ragecage
	name = "狂怒牢笼"
	desc = "适合全家同乐，经典的狂怒牢笼。"
	max_players = 4
	automatic_gameend_time = 4 MINUTES // its a 10x10 cage what are you guys doing in there
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/assistant)
	map_name = "ragecage"
	key = "ragecage"

/datum/lazy_template/deathmatch/maintenance
	name = "维护狂潮"
	desc = "黑暗的维护隧道、地上的药片、临时武器和血腥的殴打。欢迎来到助理的乌托邦。"
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/assistant)
	map_name = "maint_mania"
	key = "maint_mania"

/datum/lazy_template/deathmatch/osha_violator
	name = "OSHA违规者"
	desc = "如果没有一个过度复杂的引擎，配上四处散落的传送带、发射器和护盾发生器，那还叫工程部吗？没错，那就不是工程部了。"
	max_players = 10
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/assistant)
	map_name = "OSHA_violator"
	key = "OSHA_violator"

/datum/lazy_template/deathmatch/the_brig
	name = "禁闭室"
	desc = "MetaStation禁闭室的复刻版。"
	max_players = 12
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/assistant)
	map_name = "meta_brig"
	key = "meta_brig"

/datum/lazy_template/deathmatch/shooting_range
	name = "射击场"
	desc = "一个简单的房间，里面有一堆木质路障。"
	max_players = 6
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/operative/ranged,
		/datum/outfit/deathmatch_loadout/operative/melee,
	)
	map_name = "shooting_range"
	key = "shooting_range"

/datum/lazy_template/deathmatch/securing
	name = "安保环"
	desc = "隆重推出安保环，一直想用眩晕枪射人吗？现在你可以了。"
	max_players = 4
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/securing_sec)
	map_name = "secu_ring"
	key = "secu_ring"

/datum/lazy_template/deathmatch/instagib
	name = "秒杀场"
	desc = "人手一把秒杀步枪！"
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/assistant/instagib)
	map_name = "instagib"
	key = "instagib"

/datum/lazy_template/deathmatch/mech_madness
	name = "机甲狂潮"
	desc = "讨厌机甲？是吗？无所谓！去互相厮杀吧！"
	max_players = 4
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/operative)
	map_name = "mech_madness"
	key = "mech_madness"

/datum/lazy_template/deathmatch/sniper_elite
	name = "狙击精英"
	desc = "枪声与人们的尖叫让我的一天充满活力"
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/operative/sniper)
	map_name = "sniper_elite"
	key = "sniper_elite"

/datum/lazy_template/deathmatch/meatower
	name = "肉塔"
	desc = "这个厨房只能有一位主厨"
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/chef)
	map_name = "meat_tower"
	key = "meat_tower"

/datum/lazy_template/deathmatch/sunrise
	name = "日出"
	desc = "去人性化并直面血腥 去人性化并直面血腥 去人性化并直面血腥 去人性化并直面血腥"
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/samurai)
	map_name = "sunrise"
	key = "sunrise"

/datum/lazy_template/deathmatch/starwars
	name = "竞技场空间站"
	desc = "选择你的斗士！"
	max_players = 10
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/battler/soldier, // First because its a good and easy loadout and is picked by default
		/datum/outfit/deathmatch_loadout/battler/bloodminer,
		/datum/outfit/deathmatch_loadout/battler/clown,
		/datum/outfit/deathmatch_loadout/battler/cowboy,
		/datum/outfit/deathmatch_loadout/battler/druid,
		/datum/outfit/deathmatch_loadout/battler/enginer,
		/datum/outfit/deathmatch_loadout/battler/janitor,
		/datum/outfit/deathmatch_loadout/battler/northstar,
		/datum/outfit/deathmatch_loadout/battler/raider,
		/datum/outfit/deathmatch_loadout/battler/ripper,
		/datum/outfit/deathmatch_loadout/battler/scientist,
		/datum/outfit/deathmatch_loadout/battler/surgeon,
		/datum/outfit/deathmatch_loadout/battler/tgcoder,
		/datum/outfit/deathmatch_loadout/naked,
	)
	map_name = "arena_station"
	key = "arena_station"

/datum/lazy_template/deathmatch/underground_thunderdome
	name = "地下雷霆穹顶"
	desc = "一个非法的地下雷霆穹顶，用于更大规模的谋杀。"
	max_players = 15
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/operative,
		/datum/outfit/deathmatch_loadout/naked,
	)
	map_name = "underground_arena"
	key = "underground_arena"

/datum/lazy_template/deathmatch/backalley
	name = "后巷"
	desc = "你并非为这些街道而生。"
	max_players = 8
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/assistant,
		/datum/outfit/deathmatch_loadout/naked,
	)
	map_name = "backalley"
	key = "backalley"

/datum/lazy_template/deathmatch/raginmages
	name = "狂怒法师"
	desc = "问候！我们是巫师联邦的巫师！"
	max_players = 8
	automatic_gameend_time = 4 MINUTES // ill be surprised if this lasts more than two minutes
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/wizard,
		/datum/outfit/deathmatch_loadout/wizard/pyro,
		/datum/outfit/deathmatch_loadout/wizard/electro,
		/datum/outfit/deathmatch_loadout/wizard/necromancer,
		/datum/outfit/deathmatch_loadout/wizard/larp,
		/datum/outfit/deathmatch_loadout/wizard/chuuni,
		/datum/outfit/deathmatch_loadout/wizard/battle,
		/datum/outfit/deathmatch_loadout/wizard/apprentice,
		/datum/outfit/deathmatch_loadout/wizard/gunmancer,
		/datum/outfit/deathmatch_loadout/wizard/monkey,
		/datum/outfit/deathmatch_loadout/wizard/chaos,
		/datum/outfit/deathmatch_loadout/wizard/clown,
	)
	map_name = "ragin_mages"
	key = "ragin_mages"

/datum/lazy_template/deathmatch/train
	name = "列车劫持"
	desc = "提兹拉暗流涌动..."
	max_players = 8
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/battler/cowboy)
	map_name = "train"
	key = "train"
	turf_reservation_type = /datum/turf_reservation/indestructible_plating

/datum/lazy_template/deathmatch/finaldestination
	name = "最终目的地"
	desc = "1v1v1v1，1条命，最终目的地。"
	max_players = 8
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/captain,
		/datum/outfit/deathmatch_loadout/head_of_security,
		/datum/outfit/deathmatch_loadout/traitor,
		/datum/outfit/deathmatch_loadout/nukie,
		/datum/outfit/deathmatch_loadout/tider,
		/datum/outfit/deathmatch_loadout/abductor,
		/datum/outfit/deathmatch_loadout/chef/upgraded,
		/datum/outfit/deathmatch_loadout/battler/clown/upgraded,
		/datum/outfit/deathmatch_loadout/mime,
		/datum/outfit/deathmatch_loadout/pete,
	)
	map_name = "finaldestination"
	key = "finaldestination"

/datum/lazy_template/deathmatch/species_warfare
	name = "物种战争"
	desc = "选择你最喜欢的物种，证明它比其他所有逊色的物种都更优越。当然，也包括你同族的其他人。"
	max_players = 8
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/humanity,
		/datum/outfit/deathmatch_loadout/lizardkind,
		/datum/outfit/deathmatch_loadout/mothman,
		/datum/outfit/deathmatch_loadout/ethereal,
		/datum/outfit/deathmatch_loadout/plasmamen,
		/datum/outfit/deathmatch_loadout/felinid,
	)
	map_name = "species_warfare"
	key = "species_warfare"

/datum/lazy_template/deathmatch/lattice_battles
	name = "格栅战场"
	desc = "厌倦了总是拳脚相向？直接把脚下的网格剪断吧！"
	max_players = 8
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/lattice_battles,
	)
	map_name = "lattice_battles"
	key = "lattice_battles"

/datum/lazy_template/deathmatch/ragnarok
	name = "诸神黄昏"
	desc = "邪教徒、异端和牧师在丛林中混战，争夺麦高芬。"
	max_players = 8
	allowed_loadouts = list(
		/datum/outfit/deathmatch_loadout/cultish/invoker,
		/datum/outfit/deathmatch_loadout/cultish/artificer,
		/datum/outfit/deathmatch_loadout/heresy/warrior,
		/datum/outfit/deathmatch_loadout/heresy/scribe,
		/datum/outfit/deathmatch_loadout/holy_crusader,
		/datum/outfit/deathmatch_loadout/clock_cult,
	)
	map_name = "ragnarok"
	key = "ragnarok"

/datum/turf_reservation/indestructible_plating
	turf_type = /turf/open/indestructible/plating //a little hacky but i guess it has to be done

/datum/lazy_template/deathmatch/deep_space
	name = "Deep Space"
	desc = "A deep-space cargo shipping station has fallen under attack by a Syndicate boarding party."
	max_players = 8
	automatic_gameend_time = 15 MINUTES //its a pretty big map
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/cargo_spaceman, /datum/outfit/deathmatch_loadout/syndicate_spaceman, /datum/outfit/deathmatch_loadout/spacetider)
	map_name = "deep_space"
	key = "deep_space"
