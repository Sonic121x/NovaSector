//兔耳头饰

/datum/loadout_item/head/playbunnyearssyndicate
	name = "辛迪加兔耳发箍"
	item_path = /obj/item/clothing/head/playbunnyears/syndicate

/datum/loadout_item/head/playbunnyearsminer
	name = "矿工兔耳发箍"
	item_path = /obj/item/clothing/head/playbunnyears/miner

//兔耳领结
/datum/loadout_item/neck/bunnytiegreyscale
	name = "灰度兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/greyscale

/datum/loadout_item/neck/bunnytiesyndicate
	name = "辛迪加兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/syndicate

/datum/loadout_item/neck/bunnytiecentcom
	name = "中央司令部兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/centcom
	restricted_roles = list(JOB_NT_REP)

/datum/loadout_item/neck/bunnytiecommunist
	name = "红色阵营兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/communist

/datum/loadout_item/neck/bunnytieblue
	name = "蓝色兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/blue

/datum/loadout_item/neck/bunnytiebunnyears_captain
	name = "船长兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/captain
	restricted_roles = list(JOB_CAPTAIN)

/datum/loadout_item/neck/bunnytiecargo
	name = "货运兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/cargo

/datum/loadout_item/neck/bunnytieminer
	name = "矿工兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/miner

/datum/loadout_item/neck/bunnytiemailman
	name = "邮递员兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/mailman

/datum/loadout_item/neck/bunnytiebitrunner
	name = "数据行者兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/bitrunner

/datum/loadout_item/neck/bunnytieengineer
	name = "工程师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/engineer

/datum/loadout_item/neck/bunnytieatmos_tech
	name = "大气技术员兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/atmos_tech

/datum/loadout_item/neck/bunnytiece
	name = "总工程师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/ce
	restricted_roles = list(JOB_CHIEF_ENGINEER)

/datum/loadout_item/neck/bunnytiedoctor
	name = "医师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/doctor

/datum/loadout_item/neck/bunnytieparamedic
	name = "急救员兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/paramedic

/datum/loadout_item/neck/bunnytiechemist
	name = "药剂师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/chemist

/datum/loadout_item/neck/bunnytiepathologist
	name = "病理学家兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/pathologist

/datum/loadout_item/neck/bunnytiecoroner
	name = "验尸官兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/coroner

/datum/loadout_item/neck/bunnytiecmo
	name = "医疗主管兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/cmo
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/neck/bunnytiescientist
	name = "科研员兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/scientist

/datum/loadout_item/neck/bunnytieroboticist
	name = "机器人学家兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/roboticist

//修复原代码错误路径，改为标准loadout条目
/datum/loadout_item/neck/bunnytiegeneticist
	name = "遗传学家兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/geneticist

/datum/loadout_item/neck/bunnytierd
	name = "科研主管兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/rd
	restricted_roles = list(JOB_RESEARCH_DIRECTOR)

/datum/loadout_item/neck/bunnytiesecurity
	name = "安保兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/security
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER, JOB_BOUNCER, JOB_ORDERLY, JOB_SCIENCE_GUARD, JOB_CUSTOMS_AGENT, JOB_ENGINEERING_GUARD, JOB_BLUESHIELD)

/datum/loadout_item/neck/bunnytiesecurity/assistant
	name = "安保助理兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/security_assistant
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER, JOB_BOUNCER, JOB_ORDERLY, JOB_SCIENCE_GUARD, JOB_CUSTOMS_AGENT, JOB_ENGINEERING_GUARD, JOB_BLUESHIELD)

/datum/loadout_item/neck/bunnytiebrig_phys
	name = "禁闭区医师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/brig_phys
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER, JOB_BOUNCER, JOB_ORDERLY, JOB_SCIENCE_GUARD, JOB_CUSTOMS_AGENT, JOB_ENGINEERING_GUARD, JOB_BLUESHIELD)

/datum/loadout_item/neck/bunnytiedetective
	name = "探员兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/detective
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER, JOB_BOUNCER, JOB_ORDERLY, JOB_SCIENCE_GUARD, JOB_CUSTOMS_AGENT, JOB_ENGINEERING_GUARD, JOB_BLUESHIELD)

/datum/loadout_item/neck/bunnytieprisoner
	name = "囚犯兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/prisoner

/datum/loadout_item/neck/bunnytiehop
	name = "人事主管兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/hop
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL)

/datum/loadout_item/neck/bunnytiejanitor
	name = "保洁兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/janitor

/datum/loadout_item/neck/bunnytiebartender
	name = "酒保兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/bartender

/datum/loadout_item/neck/bunnytiecook
	name = "厨师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/cook

/datum/loadout_item/neck/bunnytiebotanist
	name = "植培师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/botanist

/datum/loadout_item/neck/bunnytielawyer_black
	name = "黑色律师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/lawyer_black

/datum/loadout_item/neck/bunnytielawyer_blue
	name = "蓝色律师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/lawyer_blue

/datum/loadout_item/neck/bunnytielawyer_red
	name = "红色律师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/lawyer_red

/datum/loadout_item/neck/bunnytielawyer_good
	name = "正义律师兔耳领结"
	item_path = /obj/item/clothing/neck/bunny/bunnytie/lawyer_good

//燕尾礼服

/datum/loadout_item/suit/tailcoatsyndicate
	name = "辛迪加燕尾礼服"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/syndicate

/datum/loadout_item/suit/tailcoatplasmaman
	name = "等离子体人燕尾礼服"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/plasmaman

/datum/loadout_item/suit/tailcoatminer
	name = "矿工燕尾礼服"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/miner

/datum/loadout_item/suit/tailcoatparamedic
	name = "急救员燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/paramedic

/datum/loadout_item/suit/tailcoatchemist
	name = "药剂师燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/chemist

/datum/loadout_item/suit/tailcoatpathologist
	name = "病理学家燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/pathologist

/datum/loadout_item/suit/tailcoatcoroner
	name = "验尸官燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/coroner

/datum/loadout_item/suit/tailcoatcmo
	name = "医疗主管燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/cmo
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/suit/tailcoatscientist
	name = "科研员燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/science

/datum/loadout_item/suit/tailcoatroboticist
	name = "机器人学家燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/science/robotics

/datum/loadout_item/suit/tailcoatgeneticist
	name = "遗传学家燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/science/genetics

/datum/loadout_item/suit/tailcoatrd
	name = "科研主管燕尾礼服"
	item_path = /obj/item/clothing/suit/jacket/research_director/tailcoat
	restricted_roles = list(JOB_RESEARCH_DIRECTOR)

/datum/loadout_item/suit/tailcoatbrig_phys
	name = "禁闭区医师燕尾礼服"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat/sec
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER, JOB_BOUNCER, JOB_ORDERLY, JOB_SCIENCE_GUARD, JOB_CUSTOMS_AGENT, JOB_ENGINEERING_GUARD, JOB_BLUESHIELD)

//兔女郎紧身衣

/datum/loadout_item/under/playbunnysuitsyndicate
	name = "辛迪加兔女郎紧身衣"
	item_path = /obj/item/clothing/under/syndicate/syndibunny

/datum/loadout_item/under/playbunnysuitminer
	name = "矿工兔女郎紧身衣"
	item_path = /obj/item/clothing/under/rank/cargo/miner/bunnysuit
