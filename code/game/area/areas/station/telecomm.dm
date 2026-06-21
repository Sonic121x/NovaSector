/*
* Telecommunications Satellite Areas
*/

/area/station/tcommsat
	icon_state = "tcomsatcham"
	ambientsounds = list(
		'sound/ambience/engineering/ambisin2.ogg',
		'sound/ambience/misc/signal.ogg',
		'sound/ambience/misc/signal.ogg',
		'sound/ambience/general/ambigen9.ogg',
		'sound/ambience/engineering/ambitech.ogg',
		'sound/ambience/engineering/ambitech2.ogg',
		'sound/ambience/engineering/ambitech3.ogg',
		'sound/ambience/misc/ambimystery.ogg',
		)
	airlock_wires = /datum/wires/airlock/engineering
	tacmap_color = TACMAP_AREA_ENGINEERING

/area/station/tcommsat/maints
	name = "\improper Telecomms Maintenance Room"

/area/station/tcommsat/computer
	name = "\improper 电信控制室"
	icon_state = "tcomsatcomp"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/tcommsat/server
	name = "\improper 电信服务器室"
	icon_state = "tcomsatcham"

/area/station/tcommsat/server/upper
	name = "\improper 上层电信服务器室"

/*
* On-Station Telecommunications Areas
*/

/area/station/comms
	name = "\improper 通讯中继站"
	icon_state = "tcomsatcham"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/server
	name = "\improper 消息服务器室"
	icon_state = "server"
	sound_environment = SOUND_AREA_STANDARD_STATION
