// Nova Sector area ruins

/area/ruin/powered/miningfacility
	name = "废弃的纳米传讯采矿设施"
	icon_state = "dk_yellow"
	ambientsounds = list('sound/music/lobby_music/title3.ogg') //Classic vibes

/area/ruin/powered/crashedshuttle
	name = "坠毁的穿梭机"
	icon_state = "dk_yellow"
	ambientsounds = list('sound/ambience/misc/ambiodd.ogg')

/area/ruin/powered/cozycabin
	name = "舒适小屋"
	icon_state = "dk_yellow"
	ambientsounds = list('sound/ambience/holy/ambicha1.ogg', 'sound/ambience/holy/ambicha2.ogg', 'sound/ambience/holy/ambicha3.ogg')

/area/ruin/powered/biodome
	name = "丛林生物穹顶"
	icon_state = "dk_yellow"

/area/ruin/turretbunker
	name = "地质研究掩体" //yes, code is "Turret bunker", But this is more for immersion reasons

/area/ruin/unpowered/magic_hotsprings
	name = "魔法温泉"
	icon_state = "ruins"
	ambientsounds = list('sound/ambience/icemoon/ambiicemelody2.ogg')

/area/ruin/unpowered/abandoned_hearth
	name = "废弃的壁炉"
	icon_state = "ruins"
	ambientsounds = list('sound/ambience/icemoon/ambiicesting4.ogg', 'sound/ambience/icemoon/ambiicemelody1.ogg')

/area/ruin/unpowered/abandoned_sacred_temple
	name = "废弃的神圣庙宇"
	icon_state = "ruins"
	ambientsounds = list('sound/ambience/holy/ambiholy.ogg')

/area/ruin/unpowered/frozenwake
	name = "冰封觉醒"
	icon_state = "ruins"
	ambientsounds = null
	ambience_index = AMBIENCE_SPOOKY
	ambient_buzz = null
	forced_ambience = TRUE
	sound_environment = SOUND_ENVIRONMENT_QUARRY
	mood_bonus = -5
	mood_message = "The weight of loss clings to the air. Every step feels like an echo of mourning."
	var/frozenwake_stasis_target = null
	var/datum/frozenwake_puzzle/frozenwake_puzzle_controller = new

/area/ruin/unpowered/luna
	name = "\improper 未注册结构"
	ambientsounds = list(
		'modular_nova/modules/mapping/sounds/ambience/luna.ogg',
		)
	min_ambience_cooldown = 2 MINUTES
	max_ambience_cooldown = 10 MINUTES

/area/ruin/unpowered/bloodzone
	name = "\improper 未知结构"

/area/ruin/unpowered/trilogy_research
	name = "\improper 未经批准的结构"
