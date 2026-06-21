// LOADOUT ITEM DATUMS FOR THE NECK SLOT

/datum/loadout_category/neck
	tab_order = /datum/loadout_category/ears::tab_order + 1

/datum/loadout_item/neck/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.neck))
		.. ()
		return TRUE

/datum/loadout_item/neck/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.neck)
			LAZYADD(outfit.backpack_contents, outfit.neck)
		outfit.neck = item_path
	else
		outfit.neck = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/neck/face_scarf
	name = "面巾（可着色）"
	item_path = /obj/item/clothing/neck/face_scarf

/datum/loadout_item/neck/maid_neck_cover
	name = "女仆颈饰（可着色）"
	item_path = /obj/item/clothing/neck/maid_neck_cover

/datum/loadout_item/neck/stethoscope
	name = "听诊器"
	item_path = /obj/item/clothing/neck/stethoscope

/datum/loadout_item/neck/tarkon_gauntlet
	name = "塔肯亲信护手"
	item_path = /obj/item/clothing/neck/security_cape/tarkon
	blacklisted_roles = list(ALL_JOBS_SEC, ALL_JOBS_COM, JOB_PRISONER)

/*
*	COLLARS
*/

/// THIN
/datum/loadout_item/neck/thinchoker
	name = "项圈"
	item_path = /obj/item/clothing/neck/collar

/datum/loadout_item/neck/collar
	name = "项圈（带标签）"
	item_path = /obj/item/clothing/neck/collar/tagged

/datum/loadout_item/neck/cbellcollar
	name = "项圈（牛铃）"
	item_path = /obj/item/clothing/neck/collar/cowbell

/datum/loadout_item/neck/bellcollar
	name = "项圈（铃铛）"
	item_path = /obj/item/clothing/neck/collar/bell

/datum/loadout_item/neck/hcollar
	name = "项圈（全息）"
	item_path = /obj/item/clothing/neck/collar/holocollar

/datum/loadout_item/neck/crosscollar
	name = "项圈（十字）"
	item_path = /obj/item/clothing/neck/collar/cross

/// THICK
/datum/loadout_item/neck/choker
	name = "项圈（粗款）"
	item_path = /obj/item/clothing/neck/collar/thick

/datum/loadout_item/neck/thick_bellcollar
	name = "项圈（铃铛，粗款）"
	item_path = /obj/item/clothing/neck/collar/thick/bell

/datum/loadout_item/neck/thick_cowbellcollar
	name = "项圈（牛铃，粗款）"
	item_path = /obj/item/clothing/neck/collar/thick/cowbell

/datum/loadout_item/neck/thick_crosscollar
	name = "项圈（十字，粗款）"
	item_path = /obj/item/clothing/neck/collar/thick/cross

/datum/loadout_item/neck/thick_holocollar
	name = "项圈（全息，粗款）"
	item_path = /obj/item/clothing/neck/collar/thick/holocollar

/datum/loadout_item/neck/thick_collar
	name = "项圈（粗款）"
	item_path = /obj/item/clothing/neck/collar/thick/tagged

/// LEATHER
/datum/loadout_item/neck/leater_collar
	name = "项圈（皮革）"
	item_path = /obj/item/clothing/neck/collar/leather

/datum/loadout_item/neck/leather_bellcollar
	name = "项圈（铃铛，皮革）"
	item_path = /obj/item/clothing/neck/collar/leather/bell

/datum/loadout_item/neck/leather_cowbellcollar
	name = "项圈（牛铃，皮革）"
	item_path = /obj/item/clothing/neck/collar/leather/cowbell

/datum/loadout_item/neck/leather_crosscollar
	name = "项圈（十字，皮革）"
	item_path = /obj/item/clothing/neck/collar/leather/cross

/datum/loadout_item/neck/leather_holocollar
	name = "项圈（全息，皮革）"
	item_path = /obj/item/clothing/neck/collar/leather/holocollar

/datum/loadout_item/neck/leather_collar
	name = "项圈（带标签，皮革）"
	item_path = /obj/item/clothing/neck/collar/leather/tagged

/// SPIKE
/datum/loadout_item/neck/spikecollar
	name = "项圈（带刺）"
	item_path = /obj/item/clothing/neck/collar/spike

/*
*	SCARVES
*/

/datum/loadout_item/neck/scarf_greyscale
	name = "围巾（可着色）"

/datum/loadout_item/neck/scarf_black
	name = "围巾（黑色）"
	item_path = /obj/item/clothing/neck/scarf/black
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_cyan
	name = "围巾（青色）"
	item_path = /obj/item/clothing/neck/scarf/cyan
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_dark_blue
	name = "围巾（深蓝色）"
	item_path = /obj/item/clothing/neck/scarf/darkblue
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_green
	name = "围巾（绿色）"
	item_path = /obj/item/clothing/neck/scarf/green
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_pink
	name = "围巾（粉色）"
	item_path = /obj/item/clothing/neck/scarf/pink
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_purple
	name = "围巾（紫色）"
	item_path = /obj/item/clothing/neck/scarf/purple
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_red
	name = "围巾（红色）"
	item_path = /obj/item/clothing/neck/scarf/red
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_orange
	name = "围巾（橙色）"
	item_path = /obj/item/clothing/neck/scarf/orange
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_yellow
	name = "围巾（黄色）"
	item_path = /obj/item/clothing/neck/scarf/yellow
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_zebra
	name = "围巾（斑马纹）"
	item_path = /obj/item/clothing/neck/scarf/zebra
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_christmas
	name = "围巾 - 圣诞款"
	item_path = /obj/item/clothing/neck/scarf/christmas
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/greyscale_large
	name = "围巾 - 大号（可着色）"

/datum/loadout_item/neck/scarf_red_striped
	name = "围巾 - 大号（红色）"
	item_path = /obj/item/clothing/neck/large_scarf/red
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_blue_striped
	name = "围巾 - 大号（蓝色）"
	item_path = /obj/item/clothing/neck/large_scarf/blue
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_green_striped
	name = "围巾 - 大号（绿色）"
	item_path = /obj/item/clothing/neck/large_scarf/green
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/neck/scarf_infinity
	name = "围巾 - 无限符号"
	item_path = /obj/item/clothing/neck/infinity_scarf

/*
*	TIES
*/

/datum/loadout_item/neck/necktie
	name = "领带（可着色）"

/datum/loadout_item/neck/necktie_black
	name = "领带（黑色）"
	item_path = /obj/item/clothing/neck/tie/black

/datum/loadout_item/neck/necktie_blue
	name = "领带（蓝色）"
	item_path = /obj/item/clothing/neck/tie/blue

/datum/loadout_item/neck/necktie_red
	name = "领带（红色）"
	item_path = /obj/item/clothing/neck/tie/red

/datum/loadout_item/neck/bowtie_black
	name = "领带 - 蝴蝶结"
	item_path = /obj/item/clothing/neck/bowtie

/datum/loadout_item/neck/discoproper
	name = "领带 - 糟糕"
	item_path = /obj/item/clothing/neck/tie/disco

/datum/loadout_item/neck/necktie_loose
	name = "领带 - 松散"

/datum/loadout_item/neck/necktie_disco
	name = "领带 - 丑陋"

/datum/loadout_item/neck/bowtie
	name = "Tie - Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiewizard
	name = "Tie - Magical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/magician
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiecc
	name = "Tie - Centcom Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/centcom
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiesoviet
	name = "Tie - Soviet Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/communist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtieblue
	name = "Tie - Blue Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/blue
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtienocap
	name = "Tie - Captain Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/captain
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiecargo
	name = "Tie - Cargo Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/cargo
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemail
	name = "Tie - Courier Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/mailman
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiebitrunner
	name = "Tie - Gamer Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/bitrunner
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtieengi
	name = "Tie - Engineer Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/engineer
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtieengiatmos
	name = "Tie - Atmos Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/atmos_tech
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtieengice
	name = "Tie - Chief Engineer Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/ce
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemed
	name = "Tie - Medical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/doctor
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemedpara
	name = "Tie - Paramedical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/paramedic
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemedchem
	name = "Tie - Chemical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/chemist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemedviro
	name = "Tie - Pathological Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/pathologist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemedcoroner
	name = "Tie - Coroner's Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/coroner
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiemedcmo
	name = "Tie - Chief Medical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/cmo
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiernd
	name = "Tie - Scientific Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/scientist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtierndrobo
	name = "Tie - Robotical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/roboticist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtierndgene
	name = "Tie - Genetical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/geneticist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtierndrd
	name = "Tie - Director Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/rd
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiesec
	name = "Tie - Secure Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/security
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiesecdept
	name = "Tie - Less Secure Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/security_assistant
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiesecdept
	name = "Tie - Secure Medical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/brig_phys
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiesecdet
	name = "Tie - Curious Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/detective
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiesecprison
	name = "Tie - Criminal Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/prisoner
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiehop
	name = "Tie - Paper Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/hop
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiejanitor
	name = "Tie - Clean Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/janitor
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiebar
	name = "Tie - Drunk Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/bartender
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiecook
	name = "Tie - Hungry Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/cook
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtiehydro
	name = "Tie - Botanical Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/botanist
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtieclown
	name = "Tie - Large Bow Collar"
	item_path = /obj/item/clothing/neck/tie/clown

/datum/loadout_item/neck/rabbit
	name = "Rabbit Necklace"
	item_path = /obj/item/clothing/neck/bunny_pendant

/datum/loadout_item/neck/bowtielawyerblack
	name = "Tie - Black Lawful Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/lawyer_black
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtielawyerblue
	name = "Tie - Blue Lawful Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/lawyer_blue
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtielawyerred
	name = "Tie - Red Lawful Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/lawyer_red
	group = "Bunny Ties"

/datum/loadout_item/neck/bowtielawyergood
	name = "Tie - Lawful Good Bow Collar"
	item_path = /obj/item/clothing/neck/tie/bunnytie/lawyer_good
	group = "Bunny Ties"

/*
*	CAPES, CLOAKS, MANTLES, PONCHOS, SHROUDS, AND VEILS
*/

/datum/loadout_item/neck/long_cape
	name = "披风 - 长款（可着色）"
	item_path = /obj/item/clothing/neck/long_cape
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/robe_cape
	name = "披风 - 长袍式（可着色）"
	item_path = /obj/item/clothing/neck/robe_cape
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/wide_cape
	name = "披风 - 宽大（可着色）"
	item_path = /obj/item/clothing/neck/wide_cape
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/gags_cloak
	name = "斗篷（可着色）"
	item_path = /obj/item/clothing/neck/cloak/colourable
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/colonial_cloak
	name = "殖民斗篷"
	item_path = /obj/item/clothing/neck/cloak/colonial
	group = "Cloaks and Shrouds"
	species_blacklist = list(SPECIES_TESHARI)

/datum/loadout_item/neck/coalition_police_cloak
	name = "殖民斗篷 - 联合警察"
	item_path = /obj/item/clothing/neck/cloak/colonial/hc_police
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/mantle
	name = "披肩"
	item_path = /obj/item/clothing/neck/mantle
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/gags_mantle
	name = "披肩（可着色）"
	item_path = /obj/item/clothing/neck/mantle/recolorable
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/gags_boat //This isn't actually a boatcloak (its way too short)
	name = "披肩 - 长款（可着色）"
	item_path = /obj/item/clothing/neck/cloak/colourable/boat
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/tesharian_mantle
	name = "披肩 - 特沙里安式"
	item_path = /obj/item/clothing/neck/tesharian_mantle
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/ponchocowboy
	name = "斗篷 - 牛仔"
	item_path = /obj/item/clothing/neck/cowboylea
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/ranger_poncho_greyscale
	name = "斗篷 - 游侠（可着色）"
	item_path = /obj/item/clothing/neck/ranger_poncho
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/security_cape
	name = "安保披风"
	item_path = /obj/item/clothing/neck/security_cape
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/gags_shroud
	name = "裹尸布（可着色）"
	item_path = /obj/item/clothing/neck/cloak/colourable/shroud
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/gags_veil
	name = "面纱（可着色）"
	item_path = /obj/item/clothing/neck/cloak/colourable/veil
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/shortcloak
	name = "短斗篷（可着色）"
	item_path = /obj/item/clothing/neck/greyscaled
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/seecloak
	name = "先知斗篷（可着色）"
	item_path = /obj/item/clothing/neck/greyscaled/seecloak
	group = "Cloaks and Shrouds"
	reskin_datum = /datum/atom_skin/seecloak

/datum/loadout_item/neck/matroncloak
	name = "女族长斗篷（可着色）"
	item_path = /obj/item/clothing/neck/greyscaled/matroncloak
	group = "Cloaks and Shrouds"

/datum/loadout_item/neck/xylixcloak
	name = "西利克斯斗篷（可着色）"
	item_path = /obj/item/clothing/neck/greyscaled/xylixcloak
	group = "Cloaks and Shrouds"

/*
*	JOB-LOCKED
*/

//COM
/datum/loadout_item/neck/mantle_cap
	name = "舰长披风"
	item_path = /obj/item/clothing/neck/mantle/capmantle
	restricted_roles = list(JOB_CAPTAIN)
	group = "Job-Locked"

/datum/loadout_item/neck/mantle_bs
	//Weird name, but the B in Blueshield alphabetically sorts and puts the Job-Locked group high in the loadout.
	//So don't add any B items to this group. Please.
	name = "指挥保镖披风"
	item_path = /obj/item/clothing/neck/mantle/bsmantle
	restricted_roles = list(JOB_BLUESHIELD)
	group = "Job-Locked"

//SERV
/datum/loadout_item/neck/mantle_hop
	name = "人事主管披风"
	item_path = /obj/item/clothing/neck/mantle/hopmantle
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL)
	group = "Job-Locked"

/datum/loadout_item/neck/mantle_chap
	name = "牧师斗篷"
	item_path = /obj/item/clothing/neck/chaplain
	restricted_roles = list(JOB_CHAPLAIN)
	group = "Job-Locked"

/datum/loadout_item/neck/mantle_bchap
	name = "牧师斗篷（黑色）"
	item_path = /obj/item/clothing/neck/chaplain/black
	restricted_roles = list(JOB_CHAPLAIN)
	group = "Job-Locked"

//MED
/datum/loadout_item/neck/mantle_cmo
	name = "首席医疗官披风"
	item_path = /obj/item/clothing/neck/mantle/cmomantle
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	group = "Job-Locked"

//ENGI
/datum/loadout_item/neck/mantle_ce
	name = "首席工程师披风"
	item_path = /obj/item/clothing/neck/mantle/cemantle
	restricted_roles = list(JOB_CHIEF_ENGINEER)
	group = "Job-Locked"

//SCI
/datum/loadout_item/neck/mantle_rd
	name = "研究主管披风"
	item_path = /obj/item/clothing/neck/mantle/rdmantle
	restricted_roles = list(JOB_RESEARCH_DIRECTOR)
	group = "Job-Locked"

//CARGO
/datum/loadout_item/neck/mantle_qm
	name = "军需官披风"
	item_path = /obj/item/clothing/neck/mantle/qm
	restricted_roles = list(JOB_QUARTERMASTER)
	group = "Job-Locked"

//SEC
/datum/loadout_item/neck/mantle_hos
	name = "安全主管披风"
	item_path = /obj/item/clothing/neck/mantle/hosmantle
	restricted_roles = list(JOB_HEAD_OF_SECURITY)
	group = "Job-Locked"

/datum/loadout_item/neck/security_gauntlet
	name = "安保臂铠"
	item_path = /obj/item/clothing/neck/security_cape/armplate
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Job-Locked"

/*
*	DONATOR
*/

/datum/loadout_item/neck/donator
	abstract_type = /datum/loadout_item/neck/donator
	donator_only = TRUE

/datum/loadout_item/neck/donator/mantle
	abstract_type = /datum/loadout_item/neck/donator/mantle

/datum/loadout_item/neck/donator/mantle/regal
	name = "皇家披风"
	item_path = /obj/item/clothing/neck/mantle/regal
	group = "Cloaks and Shrouds"
