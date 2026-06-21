/datum/job/nanotrasen_consultant
	title = JOB_NT_REP
	description = "在空间站代表纳米传讯，与安保部长争论为什么不能因为小偷小摸就当场处决人，然后在你的办公室里喝个烂醉。"
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = JOB_CENTCOM
	minimal_player_age = 14
	exp_requirements = 600
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "NANOTRASEN_CONSULTANT"

	department_for_prefs = /datum/job_department/captain

	departments_list = list(
		/datum/job_department/command,
		/datum/job_department/central_command
	)

	outfit = /datum/outfit/job/nanotrasen_consultant
	plasmaman_outfit = /datum/outfit/plasmaman/nanotrasen_consultant

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_CMD

	display_order = JOB_DISPLAY_ORDER_NANOTRASEN_CONSULTANT
	bounty_types = CIV_JOB_SEC

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)

	mail_goodies = list(
		/obj/item/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 10
	)

	nova_stars_only = TRUE
	job_flags = STATION_JOB_FLAGS | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS | JOB_ANTAG_PROTECTED

/datum/outfit/job/nanotrasen_consultant
	name = "纳米传讯顾问"
	jobtype = /datum/job/nanotrasen_consultant

	belt = /obj/item/modular_computer/pda/nanotrasen_consultant
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/heads/nanotrasen_consultant
	gloves = /obj/item/clothing/gloves/combat/naval/nanotrasen_consultant/black
	uniform =  /obj/item/clothing/under/rank/nanotrasen_consultant
	suit = /obj/item/clothing/suit/armor/vest/nanotrasen_consultant
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/nanotrasen_consultant
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1,
		/obj/item/choice_beacon/ntc = 1,
		)

	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag
	messenger = /obj/item/storage/backpack/messenger

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/nanotrasen_consultant

	chameleon_extras = list(/obj/item/gun/energy/e_gun, /obj/item/stamp/centcom)

	id = /obj/item/card/id/advanced/centcom/station
	id_trim = /datum/id_trim/job/nanotrasen_consultant

/obj/item/encryptionkey/headset_cent/ccrep
	name = "\improper 中央司令部代表的加密密钥"
	channels = list(RADIO_CHANNEL_CENTCOM = 1, RADIO_CHANNEL_SECURITY = 1)

/obj/item/radio/headset/heads/nanotrasen_consultant
	name = "\proper 纳米传讯顾问的耳机"
	desc = "一副中央司令部的官方耳机。"
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/headset_com
	keyslot2 = new /obj/item/encryptionkey/headset_cent/ccrep

/obj/item/radio/headset/heads/nanotrasen_consultant/alt
	name = "\proper 纳米传讯顾问的鲍曼式耳机"
	desc = "一副中央司令部的官方耳机。可保护耳朵免受闪光弹影响。"
	icon_state = "cent_headset_alt"

/obj/item/radio/headset/heads/nanotrasen_consultant/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/effect/landmark/start/nanotrasen_consultant
	name = "Nanotrasen Consultant"
	icon_state = "Nanotrasen Consultant"
	icon = 'modular_nova/master_files/icons/mob/landmarks.dmi'

/obj/item/clothing/accessory/medal/gold/nanotrasen_consultant
	name = "外交勋章"
	desc = "一枚金质勋章，专门授予晋升为纳米传讯顾问的人员。它象征着该人员的外交能力以及对纳米传讯的坚定奉献。"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/datum/outfit/plasmaman/nanotrasen_consultant
	name = "纳米传讯顾问等离子人"

	uniform = /obj/item/clothing/under/plasmaman/centcom_official
	gloves = /obj/item/clothing/gloves/captain //Too iconic to be replaced with a plasma version
	head = /obj/item/clothing/head/helmet/space/plasmaman/centcom_official

/obj/item/modular_computer/pda/nanotrasen_consultant
	name = "纳米传讯顾问的PDA"
	inserted_disk = /obj/item/disk/computer/command/captain
	inserted_item = /obj/item/pen/fountain/green
	greyscale_colors = "#017941#0060b8"

/obj/item/storage/bag/garment/nanotrasen_consultant
	name = "纳米传讯顾问的衣物袋"
	desc = "一个用于存放额外衣物和鞋子的袋子。这个属于纳米传讯顾问。"

/obj/item/storage/bag/garment/nanotrasen_consultant/PopulateContents()
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/glasses/sunglasses/gar/giga(src)
	new /obj/item/clothing/gloves/combat/naval/nanotrasen_consultant(src)
	new /obj/item/clothing/gloves/combat/naval/nanotrasen_consultant/black(src)
	new /obj/item/clothing/suit/hooded/wintercoat/centcom/nt_consultant(src)
	new /obj/item/clothing/under/rank/nanotrasen_consultant(src)
	new /obj/item/clothing/under/rank/nanotrasen_consultant/skirt(src)
	new /obj/item/clothing/under/imperial/nanotrasen_consultant(src)
	new /obj/item/clothing/under/imperialskirt/nanotrasen_consultant(src)
	new /obj/item/clothing/under/rank/centcom/officer(src)
	new /obj/item/clothing/under/rank/centcom/officer_skirt(src)
	new /obj/item/clothing/head/nanotrasen_consultant(src)
	new /obj/item/clothing/head/nanotrasen_consultant/beret(src)
	new /obj/item/clothing/head/beret/centcom_formal/nt_consultant(src)
	new /obj/item/clothing/head/hats/centhat(src)
	new /obj/item/clothing/suit/armor/centcom_formal/nt_consultant(src)
	new /obj/item/clothing/under/rank/centcom/intern(src)
	new /obj/item/clothing/head/hats/intern(src)

/obj/structure/closet/secure_closet/nanotrasen_consultant
	name = "纳米传讯顾问的储物柜"
	req_access = list(ACCESS_CAPTAIN, ACCESS_CENT_GENERAL)
	icon_state = "cc"
	icon = 'modular_nova/master_files/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/nanotrasen_consultant/PopulateContents()
	..()
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/disk/computer/command/captain(src)
	new /obj/item/radio/headset/heads/nanotrasen_consultant/alt(src)
	new /obj/item/radio/headset/heads/nanotrasen_consultant(src)
	new /obj/item/storage/photo_album/personal(src)
	new /obj/item/bedsheet/centcom(src)
	new /obj/item/storage/bag/garment/nanotrasen_consultant(src)

//Choice Beacon, I hope in the future they're going to be given proper unique gun but this will do.


/obj/item/choice_beacon/ntc
	name = "枪械套装信标"
	desc = "一个单次使用的信标，用于传送您选择的枪械套装。请仅在您的办公室内呼叫。"
	icon_state = "cc_beacon"
	inhand_icon_state = "cc_beacon"
	icon = 'modular_nova/modules/modular_items/icons/remote.dmi'
	lefthand_file = 'modular_nova/modules/modular_items/icons/inhand/mobs/lefthand_remote.dmi'
	righthand_file = 'modular_nova/modules/modular_items/icons/inhand/mobs/righthand_remote.dmi'
	company_source = "Trappiste Fabriek Company"
	company_message = span_bold("补给舱即将抵达，请稍候")

/obj/item/choice_beacon/ntc/generate_display_names()
	var/static/list/selectable_gun_types = list(
		"Takbok Revolver Set" = /obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/takbok,
		"Skild Pistol Set" = /obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/skild,
	)

	return selectable_gun_types

/obj/item/pen/fountain/green
	name = "nanotrasen fountain pen"
	desc = "It's an expensive green fountain pen. The case may be plastic, but that gold is real!"
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi'
	icon_state = "pen-fountain-nt"
	colour = "#18610D"
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5)
