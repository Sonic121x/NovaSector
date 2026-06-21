/obj/item/clothing/under/plasmaman/captain
	name = "舰长的等离子环境服"
	desc = "那是件蓝色的环境防护服，上面有一些金色的标记，代表着“上尉”的军衔。"
	icon_state = "captain_envirosuit"
	inhand_icon_state = null
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	armor_type = /datum/armor/clothing_under/rank_captain/plasmaman

/datum/armor/clothing_under/rank_captain/plasmaman
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/under/plasmaman/head_of_personnel
	name = "人事部长的等离子环境服"
	desc = "那些获得了“人事主管”职位的人所穿的环境防护服。"
	icon_state = "hop_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/security/head_of_security
	name = "安保部长的等离子环境服"
	desc = "一套等离子人防护服，上面装饰着一些字样，彰显着那些有幸获得安保部长职位者的荣誉与决心。"
	icon_state = "hos_envirosuit"
	inhand_icon_state = null
	armor_type = /datum/armor/clothing_under/security_head_of_security/plasmaman
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/clothing_under/security_head_of_security/plasmaman
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/under/plasmaman/chief_engineer
	name = "工程部长的等离子环境服"
	desc = "这是一套专为那些疯狂到足以获得“总工程师”头衔的等离子人设计的密封防护服。"
	icon_state = "ce_envirosuit"
	inhand_icon_state = null
	armor_type = /datum/armor/clothing_under/engineering_chief_engineer/plasmaman

/datum/armor/clothing_under/engineering_chief_engineer/plasmaman
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/under/plasmaman/chief_medical_officer
	name = "首席医疗官的等离子环境服"
	desc = "这是一种环境防护服，只有具备担任“首席医疗官”职责资格的人才能穿戴使用。"
	icon_state = "cmo_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/research_director
	name = "科研部长的等离子环境服"
	desc = "这是一套由那些有能力担任“研究总监”职位的人所穿的环境防护服。"
	icon_state = "rd_envirosuit"
	inhand_icon_state = null
	armor_type = /datum/armor/clothing_under/rnd_research_director/plasmaman

/datum/armor/clothing_under/rnd_research_director/plasmaman
	bio = 100
	fire = 95
	acid = 95
