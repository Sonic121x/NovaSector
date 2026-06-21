// LOADOUT ITEM DATUMS FOR THE SHOE SLOT

/datum/loadout_category/shoes
	tab_order = /datum/loadout_category/hands::tab_order + 1

/datum/loadout_item/shoes
	abstract_type = /datum/loadout_item/shoes

/datum/loadout_item/shoes/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.shoes))
		.. ()
		return TRUE

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.shoes)
			LAZYADD(outfit.backpack_contents, outfit.shoes)
		outfit.shoes = item_path
	else
		outfit.shoes = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/shoes/kim
	name = "气动鞋"
	item_path = /obj/item/clothing/shoes/jackboots/kim

/datum/loadout_item/shoes/high_heels
	name = "高跟鞋"
	item_path = /obj/item/clothing/shoes/high_heels

/datum/loadout_item/shoes/black_heels
	name = "高跟鞋 - 华丽款"
	item_path = /obj/item/clothing/shoes/fancy_heels

/datum/loadout_item/shoes/laceup
	name = "系带鞋"

/datum/loadout_item/shoes/recolorable_laceups
	name = "系带鞋 (可着色)"
	item_path = /obj/item/clothing/shoes/colorable_laceups

/datum/loadout_item/shoes/disco
	name = "蜥蜴皮鞋"
	item_path = /obj/item/clothing/shoes/discoshoes

/datum/loadout_item/shoes/sandals
	name = "凉鞋"
	item_path = /obj/item/clothing/shoes/sandal

/datum/loadout_item/shoes/recolorable_sandals
	name = "凉鞋 (可着色)"
	item_path = /obj/item/clothing/shoes/colorable_sandals

/datum/loadout_item/shoes/sandals_black
	name = "凉鞋 (黑色)"
	item_path = /obj/item/clothing/shoes/sandal/alt

/datum/loadout_item/shoes/sandals_laced
	name = "凉鞋 - 魔术贴款"

/datum/loadout_item/shoes/sandals_laced_black
	name = "凉鞋 - 魔术贴款 (黑色)"

/datum/loadout_item/shoes/sportshoes
	name = "运动鞋"
	item_path = /obj/item/clothing/shoes/sports

/datum/loadout_item/shoes/sport_boots
	name = "运动靴"
	item_path = /obj/item/clothing/shoes/sport_boots

/*
*	BOOTS
*/

/datum/loadout_item/shoes/colonial_boots
	name = "靴子 - 殖民地半筒靴"
	item_path = /obj/item/clothing/shoes/jackboots/colonial
	species_blacklist = list(SPECIES_TESHARI)

/datum/loadout_item/shoes/cowboy_recolorable
	name = "靴子 - 牛仔靴 (可着色)"
	item_path = /obj/item/clothing/shoes/cowboy/laced/recolorable

/datum/loadout_item/shoes/cowboy_black
	name = "靴子 - 系带牛仔靴 (黑色)"

/datum/loadout_item/shoes/cowboy_brown
	name = "靴子 - 系带牛仔靴 (棕色)"

/datum/loadout_item/shoes/cowboy_white
	name = "靴子 - 系带牛仔靴 (白色)"

/datum/loadout_item/shoes/jackboots/frontier
	name = "靴子 - 重型边疆靴"
	item_path = /obj/item/clothing/shoes/jackboots/frontier_colonist

/datum/loadout_item/shoes/timbs
	name = "靴子 - 徒步靴"
	item_path = /obj/item/clothing/shoes/jackboots/timbs

/datum/loadout_item/shoes/jackboots
	name = "靴子 - 长筒军靴"
	item_path = /obj/item/clothing/shoes/jackboots

/datum/loadout_item/shoes/recolorable_jackboots
	name = "靴子 - 长筒军靴 (可着色)"
	item_path = /obj/item/clothing/shoes/jackboots/recolorable

/datum/loadout_item/shoes/jackboots/toeless
	name = "无趾军靴"
	item_path = /obj/item/clothing/shoes/jackboots/toeless

/datum/loadout_item/shoes/jackboots/heel //Donator reward for Thedragmeme, unrestricted at their request
	name = "靴子 - 军靴，高跟"
	item_path = /obj/item/clothing/shoes/jackboots/heel

/datum/loadout_item/shoes/kneeboot
	name = "靴子 - 军靴，及膝"
	item_path = /obj/item/clothing/shoes/jackboots/knee

/datum/loadout_item/shoes/kneeboot/recolorable
	name = "靴子 - 军靴，及膝（可着色）"
	item_path = /obj/item/clothing/shoes/jackboots/knee/recolorable

/datum/loadout_item/shoes/jungle
	name = "靴子 - 丛林靴"
	item_path = /obj/item/clothing/shoes/jungleboots

/datum/loadout_item/shoes/mining_boots
	name = "靴子 - 矿工靴"
	item_path = /obj/item/clothing/shoes/workboots/mining

/datum/loadout_item/shoes/duck_boots
	name = "靴子 - 东北鸭嘴靴"
	item_path = /obj/item/clothing/shoes/jackboots/duckboots

/datum/loadout_item/shoes/russian_boots
	name = "靴子 - 俄式军靴"
	item_path = /obj/item/clothing/shoes/russian

/datum/loadout_item/shoes/winter_boots
	name = "靴子 - 冬季靴"
	item_path = /obj/item/clothing/shoes/winterboots

/datum/loadout_item/shoes/work_boots
	name = "靴子 - 工作靴"
	item_path = /obj/item/clothing/shoes/workboots

/datum/loadout_item/shoes/work_boots/toeless
	name = "无趾工作靴"
	item_path = /obj/item/clothing/shoes/workboots/toeless

/*
*	SNEAKERS
*/

/datum/loadout_item/shoes/greyscale_sneakers
	name = "运动鞋（可着色）"
	item_path = /obj/item/clothing/shoes/sneakers

/datum/loadout_item/shoes/black_sneakers
	name = "运动鞋（黑色）"
	item_path = /obj/item/clothing/shoes/sneakers/black
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/blue_sneakers
	name = "运动鞋（蓝色）"
	item_path = /obj/item/clothing/shoes/sneakers/blue
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/brown_sneakers
	name = "运动鞋（棕色）"
	item_path = /obj/item/clothing/shoes/sneakers/brown
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/green_sneakers
	name = "运动鞋（绿色）"
	item_path = /obj/item/clothing/shoes/sneakers/green
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/orange_sneakers
	name = "运动鞋（橙色）"
	item_path = /obj/item/clothing/shoes/sneakers/orange
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/purple_sneakers
	name = "运动鞋（紫色）"
	item_path = /obj/item/clothing/shoes/sneakers/purple
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/white_sneakers
	name = "运动鞋（白色）"
	item_path = /obj/item/clothing/shoes/sneakers/white
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/shoes/yellow_sneakers
	name = "运动鞋（黄色）"
	item_path = /obj/item/clothing/shoes/sneakers/yellow
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/*
*	LEG WRAPS
*/

/datum/loadout_item/shoes/wraps_colorable
	name = "裹足布（可着色）"
	item_path = /obj/item/clothing/shoes/wraps/colourable

/datum/loadout_item/shoes/bluecuffs
	name = "裹足布（蓝色）"
	item_path = /obj/item/clothing/shoes/wraps/blue

/datum/loadout_item/shoes/gildedcuffs
	name = "裹足布（镀金）"
	item_path = /obj/item/clothing/shoes/wraps

/datum/loadout_item/shoes/redcuffs
	name = "裹足布（红色）"
	item_path = /obj/item/clothing/shoes/wraps/red

/datum/loadout_item/shoes/silvercuffs
	name = "裹足布（银色）"
	item_path = /obj/item/clothing/shoes/wraps/silver

/datum/loadout_item/shoes/clothwrap
	name = "裹足布 - 布料"
	item_path = /obj/item/clothing/shoes/wraps/cloth

/*
*	COSTUME
*/

/datum/loadout_item/shoes/roman_sandles
	name = "Roman Sandles"
	item_path = /obj/item/clothing/shoes/roman
	group = "Costumes"

/datum/loadout_item/shoes/christmas
	name = "圣诞靴"
	item_path = /obj/item/clothing/shoes/winterboots/christmas
	group = "Costumes"

/datum/loadout_item/shoes/glow_shoes
	name = "发光鞋（可着色）"
	group = "Costumes"

/datum/loadout_item/shoes/griffin
	name = "狮鹫靴"
	item_path = /obj/item/clothing/shoes/griffin
	group = "Costumes"

/datum/loadout_item/shoes/jingleshoes
	name = "小丑鞋"
	item_path = /obj/item/clothing/shoes/jester_shoes
	group = "Costumes"

/datum/loadout_item/shoes/rollerskates
	name = "轮滑鞋"
	item_path = /obj/item/clothing/shoes/wheelys/rollerskates
	group = "Costumes"

/datum/loadout_item/shoes/wheelys
	name = "滑轮高跟鞋"
	item_path = /obj/item/clothing/shoes/wheelys
	group = "Costumes"

/*
*	JOB-RESTRICTED
*/

/datum/loadout_item/shoes/jackboots_sec_blue
	name = "安保长筒靴（蓝色）"
	item_path = /obj/item/clothing/shoes/jackboots/sec/blue
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/shoes/clown_shoes
	abstract_type = /datum/loadout_item/shoes/clown_shoes
	restricted_roles = list(JOB_CLOWN)
	group = "Job-Locked"

/datum/loadout_item/shoes/clown_shoes/jester
	name = "小丑的小丑鞋"
	item_path = /obj/item/clothing/shoes/clown_shoes/jester

/datum/loadout_item/shoes/clown_shoes/pink
	name = "粉色小丑鞋"
	item_path = /obj/item/clothing/shoes/clown_shoes/pink

/datum/loadout_item/shoes/clown_shoes/pink_heels
	name = "粉色小丑高跟鞋"
	item_path = /obj/item/clothing/shoes/clown_shoes/pink/heels

/datum/loadout_item/shoes/clown_shoes/pink_heels_mute
	name = "粉色小丑高跟鞋（无小丑效果）"
	item_path = /obj/item/clothing/shoes/pink_clown_heels
	restricted_roles = null
	group = "Costumes"

/datum/loadout_item/shoes/clown_shoes/pink_heels_mute/get_item_information()
	. = ..()
	.[FA_ICON_VOLUME_MUTE] = "No Clown Effects"

/*
*	erp_item
*/

/datum/loadout_item/shoes/ballet_heels
	name = "芭蕾高跟鞋"
	item_path = /obj/item/clothing/shoes/ballet_heels
	erp_item = TRUE

/datum/loadout_item/shoes/dominaheels
	name = "支配高跟鞋"
	item_path = /obj/item/clothing/shoes/ballet_heels/domina_heels
	erp_item = TRUE

/datum/loadout_item/shoes/latex_socks
	name = "乳胶袜"
	item_path = /obj/item/clothing/shoes/latex_socks
	erp_item = TRUE

/*
*	DONATOR
*/

/datum/loadout_item/shoes/donator
	abstract_type = /datum/loadout_item/shoes/donator
	donator_only = TRUE

/datum/loadout_item/shoes/donator/blackjackboots
	name = "靴子 - 长筒靴（黑色）"
	item_path = /obj/item/clothing/shoes/jackboots/black

/datum/loadout_item/shoes/donator/rainbow
	name = "运动鞋 - 彩虹色"
	item_path = /obj/item/clothing/shoes/sneakers/rainbow
