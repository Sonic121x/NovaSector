// LOADOUT ITEM DATUMS FOR BOTH IN-HANDS SLOTS

/datum/loadout_category/inhands
	tab_order = /datum/loadout_category/shoes::tab_order + 1

/datum/loadout_item/inhand/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	// if no hands are available then put in backpack
	if(initial(outfit_important_for_life.r_hand) && initial(outfit_important_for_life.l_hand))
		if(!visuals_only)
			LAZYADD(outfit.backpack_contents, item_path)
		return TRUE

/datum/loadout_item/inhand/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(outfit.l_hand && !outfit.r_hand)
		outfit.r_hand = item_path
	else
		if(outfit.l_hand)
			LAZYADD(outfit.backpack_contents, outfit.l_hand)
		outfit.l_hand = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/inhand/bouquet_mixed
	name = "花束 - 混合"
	item_path = /obj/item/bouquet

/datum/loadout_item/inhand/bouquet_sunflower
	name = "花束 - 向日葵"
	item_path = /obj/item/bouquet/sunflower

/datum/loadout_item/inhand/bouquet_poppy
	name = "花束 - 罂粟"
	item_path = /obj/item/bouquet/poppy

/datum/loadout_item/inhand/bouquet_rose
	name = "花束 - 玫瑰"
	item_path = /obj/item/bouquet/rose

/datum/loadout_item/inhand/cane
	name = "手杖"
	item_path = /obj/item/cane

/datum/loadout_item/inhand/cane/white
	name = "手杖 - 白色"
	item_path = /obj/item/cane/white

/datum/loadout_item/inhand/cane/crutch
	name = "拐杖"
	item_path = /obj/item/cane/crutch

/datum/loadout_item/inhand/guncase_large
	name = "空枪盒（黑色，大号）"
	item_path = /obj/item/storage/toolbox/guncase/nova

/datum/loadout_item/inhand/guncase_small
	name = "空枪盒（黑色，小号）"
	item_path = /obj/item/storage/toolbox/guncase/nova/pistol

/datum/loadout_item/inhand/guncase_large/yellow
	name = "空枪盒（黄色，大号）"
	item_path = /obj/item/storage/toolbox/guncase/nova/carwo_large_case

/datum/loadout_item/inhand/flag_azulea
	name = "旗帜 - 阿祖利亚"
	item_path = /obj/item/sign/flag/azulea

/datum/loadout_item/inhand/flag_mothic
	name = "旗帜 - 大游牧舰队"
	item_path = /obj/item/sign/flag/mothic

/datum/loadout_item/inhand/flag_agurk
	name = "旗帜 - 阿古尔克拉尔王国"
	item_path = /obj/item/sign/flag/ssc

/datum/loadout_item/inhand/flag_nt
	name = "旗帜 - 纳米传讯"
	item_path = /obj/item/sign/flag/nanotrasen

/datum/loadout_item/inhand/flag_hc
	name = "旗帜 - 日光静止联盟"
	item_path = /obj/item/sign/flag/hc

/datum/loadout_item/inhand/flag_moghes
	name = "旗帜 - 北莫赫斯共和国"
	item_path = /obj/item/sign/flag/tizira

/datum/loadout_item/inhand/flag_solfed
	name = "旗帜 - 太阳系联邦"
	item_path = /obj/item/sign/flag/terragov

/datum/loadout_item/inhand/flag_teshari
	name = "旗帜 - 特沙里自决联盟"
	item_path = /obj/item/sign/flag/mars

/datum/loadout_item/inhand/toolbox
	name = "装满的工具箱"
	item_path = /obj/item/storage/toolbox/mechanical
	blacklisted_roles = list(JOB_PRISONER)

/datum/loadout_item/inhand/saddle // these should be in the other category but apparantly those are "pocket" loadout items so idk?
	name = "骑乘鞍具（皮革）"
	item_path = /obj/item/riding_saddle/leather

/datum/loadout_item/inhand/saddle_blue
	name = "骑乘鞍具（蓝色）"
	item_path = /obj/item/riding_saddle/leather/blue

/datum/loadout_item/inhand/skateboard
	name = "滑板"
	item_path = /obj/item/melee/skateboard

/datum/loadout_item/inhand/skub
	name = "斯卡布"
	item_path = /obj/item/skub

/datum/loadout_item/inhand/saddlebags
	name = "鞍囊"
	item_path = /obj/item/storage/backpack/saddlebags

/datum/loadout_item/inhand/wheelchair
	name = "Folded Wheelchair"
	item_path = /obj/item/wheelchair

/datum/loadout_item/inhand/pet
	abstract_type = /datum/loadout_item/inhand/pet

/datum/loadout_item/inhand/pet/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper)
	var/obj/item/mob_holder/pet/equipped_pet = locate(item_path) in equipper.get_all_gear()
	equipped_pet.held_mob.befriend(equipper)

/*
PLASMAMAN ENVIROSUIT KITS
SPECIES RESTRICTED
*/

/datum/loadout_item/inhand/envirokit_orange
	name = "环境防护服套装：橙色"
	item_path = /obj/item/storage/box/envirosuit
	species_whitelist = list(SPECIES_PLASMAMAN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_black
	name = "环境防护服套装：黑色"
	item_path = /obj/item/storage/box/envirosuit/black
	species_whitelist = list(SPECIES_PLASMAMAN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_white
	name = "环境防护服套装：白色"
	item_path = /obj/item/storage/box/envirosuit/white
	species_whitelist = list(SPECIES_PLASMAMAN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_khaki
	name = "环境防护服套装：卡其色"
	item_path = /obj/item/storage/box/envirosuit/khaki
	species_whitelist = list(SPECIES_PLASMAMAN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_slacks
	name = "环境防护服套装：正式环境裤装"
	item_path = /obj/item/storage/box/envirosuit/slacks
	species_whitelist = list(SPECIES_PLASMAMAN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_prototype
	name = "环境防护服套装：原型"
	item_path = /obj/item/storage/box/envirosuit/prototype
	species_whitelist = list(SPECIES_PLASMAMAN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_security
	name = "备用环境防护服套装：安保干员"
	item_path = /obj/item/storage/box/envirosuit/security
	species_whitelist = list(SPECIES_PLASMAMAN)
	restricted_roles = list(JOB_WARDEN, JOB_DETECTIVE, JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY, JOB_CORRECTIONS_OFFICER)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_security_warden
	name = "备用环境防护服套装：典狱长"
	item_path = /obj/item/storage/box/envirosuit/security_warden
	species_whitelist = list(SPECIES_PLASMAMAN)
	restricted_roles = list(JOB_WARDEN)
	group = "Species-Unique"

/datum/loadout_item/inhand/envirokit_head_of_security
	name = "备用环境防护服套装：安全主管"
	item_path = /obj/item/storage/box/envirosuit/security_hos
	species_whitelist = list(SPECIES_PLASMAMAN)
	restricted_roles = list(JOB_HEAD_OF_SECURITY)
	group = "Species-Unique"
