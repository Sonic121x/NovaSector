// LOADOUT ITEM DATUMS FOR THE SUIT SLOT
/datum/loadout_item/suit/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE) // don't bother storing in backpack, can't fit
	if(initial(outfit_important_for_life.suit))
		return TRUE

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.suit)
			LAZYADD(outfit.backpack_contents, outfit.suit)
		outfit.suit = item_path
	else
		outfit.suit = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/suit/dagger_mantle
	name = "'Dagger' Designer Mantle"
	item_path = /obj/item/clothing/suit/dagger_mantle

/datum/loadout_item/suit/croptop
	name = "露脐高领衫"
	item_path = /obj/item/clothing/suit/jacket/croptop
	reskin_datum = /datum/atom_skin/cableknit_sweater

/datum/loadout_item/suit/czech
	name = "捷克大衣"
	item_path = /obj/item/clothing/suit/modernwintercoatthing

/datum/loadout_item/suit/henchcoat
	name = "Henchmen Coat"
	item_path = /obj/item/clothing/suit/jacket/henchmen_coat
	group = "Jackets"

/datum/loadout_item/suit/korea
	name = "东方大衣"
	item_path = /obj/item/clothing/suit/koreacoat

/datum/loadout_item/suit/hawaiian_shirt
	name = "夏威夷衬衫"
	item_path = /obj/item/clothing/suit/costume/hawaiian

/datum/loadout_item/suit/overcoat
	name = "大衣（可着色）"
	item_path = /obj/item/clothing/suit/nova/overcoat
	group = "Jackets"

/datum/loadout_item/suit/wellwornshirt
	name = "超大号衬衫"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt

/datum/loadout_item/suit/wellworn_graphicshirt
	name = "超大号衬衫（印花）"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/graphic

/datum/loadout_item/suit/ianshirt
	name = "超大号衬衫（伊恩）"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/graphic/ian

/datum/loadout_item/suit/wornoutshirt
	name = "超大号衬衫 - 破旧款"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/wornout

/datum/loadout_item/suit/wornout_graphicshirt
	name = "超大号衬衫 - 破旧款（印花）"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic

/datum/loadout_item/suit/wornout_ianshirt
	name = "超大号衬衫 - 破旧款（伊恩）"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic/ian

/datum/loadout_item/suit/messyshirt
	name = "超大号衬衫 - 凌乱款"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/messy

/datum/loadout_item/suit/messy_graphicshirt
	name = "超大号衬衫 - 凌乱款（印花）"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic

/datum/loadout_item/suit/messy_ianshirt
	name = "超大号衬衫 - 凌乱款（伊恩）"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic/ian

/datum/loadout_item/suit/wornshirt
	name = "超大号衬衫 - 褶皱款"
	item_path = /obj/item/clothing/suit/wornshirt

/datum/loadout_item/suit/suspenders
	name = "背带裤（可着色）"
	item_path = /obj/item/clothing/suit/toggle/suspenders

/datum/loadout_item/suit/big_sweater
	name = "大号蝴蝶结毛衣（可着色）"
	item_path = /obj/item/clothing/suit/nova/sweater/bow

/datum/loadout_item/suit/big_sweater_bowless
	name = "大号毛衣（可着色）"
	item_path = /obj/item/clothing/suit/nova/sweater

/*
*	WINTER COATS
*/

/datum/loadout_item/suit/winter_coat
	name = "冬季大衣"
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/gags_wintercoat
	name = "冬季大衣（可着色）"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/colourable

/datum/loadout_item/suit/aformal
	name = "冬季大衣 - 助手正装"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/nova

/datum/loadout_item/suit/brass
	name = "冬季大衣 - 黄铜色"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/nova/ratvar

/datum/loadout_item/suit/winter_coat/christmas
	name = "冬季大衣 - 圣诞款"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/nova/christmas

/datum/loadout_item/suit/winter_coat/christmas/green
	name = "冬季大衣 - 圣诞款（绿色）"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/nova/christmas/green

/datum/loadout_item/suit/runed
	name = "冬季大衣 - 符文款"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/nova/narsie

/datum/loadout_item/suit/winter_coat_greyscale
	name = "冬季大衣 - 定制款（可着色）"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/custom

/datum/loadout_item/suit/winter_coat_fancy
	name = "冬季大衣 - 风衣款（可着色）"
	item_path = /obj/item/clothing/suit/nova/furred_trenchcoat

//Job Winter Coats (Don't want to alphabetize these mixed with the other wintercoats)
/datum/loadout_item/suit/coat_atmos
	name = "冬季大衣 - 大气处理部"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos

/datum/loadout_item/suit/coat_bar
	name = "冬季大衣 - 调酒师"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/nova/bartender

/datum/loadout_item/suit/coat_cargo
	name = "冬季大衣 - 货运"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/cargo

/datum/loadout_item/suit/coat_eng
	name = "冬季大衣 - 工程"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering

/datum/loadout_item/suit/coat_hydro
	name = "冬季大衣 - 水培"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/hydro

/datum/loadout_item/suit/coat_med
	name = "冬季大衣 - 医疗"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/medical

/datum/loadout_item/suit/coat_miner
	name = "冬季大衣 - 矿业"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/miner

/datum/loadout_item/suit/coat_paramedic
	name = "冬季大衣 - 护理员"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/medical/paramedic

/datum/loadout_item/suit/coat_robotics
	name = "冬季大衣 - 机器人学"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/science/robotics

/datum/loadout_item/suit/coat_sci
	name = "冬季大衣 - 科研"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/science

/*
*	SUITS / SUIT JACKETS
*/

/datum/loadout_item/suit/recolorable
	name = "Suit Jacket (Colorable)"
	item_path = /obj/item/clothing/suit/toggle/lawyer/greyscale
	group = "Jackets"

/datum/loadout_item/suit/black_suit_jacket
	name = "西装外套（黑色）"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black
	group = "Jackets"

/datum/loadout_item/suit/blue_suit_jacket
	name = "西装外套（蓝色）"
	item_path = /obj/item/clothing/suit/toggle/lawyer
	group = "Jackets"

/datum/loadout_item/suit/purple_suit_jacket
	name = "西装外套（紫色）"
	item_path = /obj/item/clothing/suit/toggle/lawyer/purple
	group = "Jackets"

/datum/loadout_item/suit/suitwhite
	name = "西装外套 - 德克萨斯款"
	item_path = /obj/item/clothing/suit/texas
	group = "Jackets"

/datum/loadout_item/suit/dutchjacket
	name = "西装外套 - 西部款"
	item_path = /obj/item/clothing/suit/dutchjacketsr
	group = "Jackets"

/*
*	JACKETS
*/

/datum/loadout_item/suit/big_jacket
	name = "阿尔法工坊飞行员夹克"
	item_path = /obj/item/clothing/suit/big_jacket
	group = "Jackets"

/datum/loadout_item/suit/blazer_jacket
	name = "西装外套（可着色）"
	item_path = /obj/item/clothing/suit/jacket/blazer
	group = "Jackets"

/datum/loadout_item/suit/discojacket
	name = "西装外套 - 迪斯科款"
	item_path = /obj/item/clothing/suit/jacket/discoblazer
	group = "Jackets"

/datum/loadout_item/suit/bomber_jacket
	name = "轰炸机夹克"
	item_path = /obj/item/clothing/suit/jacket/bomber
	group = "Jackets"

/datum/loadout_item/suit/jacketbomber_alt
	name = "带拉链轰炸机夹克"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova
	group = "Jackets"

/datum/loadout_item/suit/kimjacket
	name = "气动轰炸机夹克"
	item_path = /obj/item/clothing/suit/kimjacket
	group = "Jackets"

/datum/loadout_item/suit/cardigan
	name = "开襟羊毛衫"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/cardigan
	group = "Jackets"

/datum/loadout_item/suit/sports_jacket
	name = "可定制夹克（可着色）"
	item_path = /obj/item/clothing/suit/crop_jacket/long
	group = "Jackets"

/datum/loadout_item/suit/shortsleeve_sports_jacket
	name = "可定制夹克（短袖，可着色）"
	item_path = /obj/item/clothing/suit/crop_jacket/shortsleeve/long
	group = "Jackets"

/datum/loadout_item/suit/sleeveless_sports_jacket
	name = "可定制夹克（无袖，可着色）"
	item_path = /obj/item/clothing/suit/crop_jacket/sleeveless/long
	group = "Jackets"

/datum/loadout_item/suit/crop_jacket
	name = "可定制夹克 - 露脐款（可着色）"
	item_path = /obj/item/clothing/suit/crop_jacket
	group = "Jackets"

/datum/loadout_item/suit/shortsleeve_crop_jacket
	name = "可定制夹克 - 露脐款（短袖，可着色）"
	item_path = /obj/item/clothing/suit/crop_jacket/shortsleeve
	group = "Jackets"

/datum/loadout_item/suit/sleeveless_crop_jacket
	name = "可定制夹克 - 露脐款（无袖，可着色）"
	item_path = /obj/item/clothing/suit/crop_jacket/sleeveless
	group = "Jackets"

/datum/loadout_item/suit/colourable_leather_jacket
	name = "皮夹克（可着色）"
	item_path = /obj/item/clothing/suit/jacket/leather/colourable
	group = "Jackets"

/datum/loadout_item/suit/duster
	name = "长风衣（可着色）"
	item_path = /obj/item/clothing/suit/duster
	group = "Jackets"

/datum/loadout_item/suit/parka
	name = "瀑布派克大衣"
	item_path = /obj/item/clothing/suit/fallsparka
	group = "Jackets"

/datum/loadout_item/suit/jacket_fancy
	name = "奢华毛皮大衣（可着色）"
	item_path = /obj/item/clothing/suit/jacket/fancy
	group = "Jackets"

/datum/loadout_item/suit/flannel_gags
	name = "法兰绒衬衫（可着色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/flannel/gags

/datum/loadout_item/suit/flannel_aqua
	name = "法兰绒衬衫（水绿色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/flannel/aqua

/datum/loadout_item/suit/flannel_black
	name = "法兰绒衬衫（黑色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/flannel

/datum/loadout_item/suit/flannel_brown
	name = "法兰绒衬衫（棕色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/flannel/brown

/datum/loadout_item/suit/flannel_red
	name = "法兰绒衬衫（红色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/flannel/red

/datum/loadout_item/suit/frontierjacket
	abstract_type = /datum/loadout_item/suit/frontierjacket

/datum/loadout_item/suit/frontierjacket/short
	name = "边疆夹克（短款）"
	item_path = /obj/item/clothing/suit/jacket/frontier_colonist/short
	group = "Jackets"

/datum/loadout_item/suit/maxson
	name = "毛边大衣（棕色）"
	item_path = /obj/item/clothing/suit/brownbattlecoat

/datum/loadout_item/suit/bossu
	name = "毛边大衣（黑色）"
	item_path = /obj/item/clothing/suit/blackfurrich

/datum/loadout_item/suit/leather_jacket
	name = "皮夹克"
	item_path = /obj/item/clothing/suit/jacket/leather
	group = "Jackets"

/datum/loadout_item/suit/leather_jacket/hooded
	name = "带兜帽皮夹克"
	item_path = /obj/item/clothing/suit/hooded/leather
	group = "Jackets"

/datum/loadout_item/suit/leather_jacket/biker
	name = "带拉链皮夹克"
	item_path = /obj/item/clothing/suit/jacket/leather/biker
	group = "Jackets"

/datum/loadout_item/suit/woolcoat
	name = "皮大衣"
	item_path = /obj/item/clothing/suit/woolcoat

/datum/loadout_item/suit/military_jacket
	name = "军用夹克"
	item_path = /obj/item/clothing/suit/jacket/miljacket
	group = "Jackets"

/datum/loadout_item/suit/jacket_oversized
	name = "超大号夹克（可着色）"
	item_path = /obj/item/clothing/suit/jacket/oversized

/datum/loadout_item/suit/peacoat
	name = "双排扣大衣（可着色）"
	item_path = /obj/item/clothing/suit/toggle/peacoat
	group = "Jackets"

/datum/loadout_item/suit/puffer_jacket
	name = "羽绒夹克"
	item_path = /obj/item/clothing/suit/jacket/puffer
	group = "Jackets"

/datum/loadout_item/suit/puffer_vest
	name = "羽绒背心"
	item_path = /obj/item/clothing/suit/jacket/puffer/vest
	group = "Jackets"

/datum/loadout_item/suit/jacket_sweater
	name = "毛衣夹克（可着色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/sweater
	group = "Jackets"

/datum/loadout_item/suit/tailored_jacket
	name = "定制夹克（可着色）"
	item_path = /obj/item/clothing/suit/tailored_jacket
	group = "Jackets"

/datum/loadout_item/suit/tailored_short_jacket
	name = "定制短夹克（可着色）"
	item_path = /obj/item/clothing/suit/tailored_jacket/short
	group = "Jackets"

/datum/loadout_item/suit/trackjacket
	name = "运动夹克"
	item_path = /obj/item/clothing/suit/toggle/trackjacket
	group = "Jackets"

/datum/loadout_item/suit/jacket_trenchcoat
	name = "风衣（可着色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/trenchcoat

/datum/loadout_item/suit/bltrench
	name = "风衣（黑色）"
	item_path = /obj/item/clothing/suit/trenchblack

/datum/loadout_item/suit/frenchtrench
	name = "风衣（蓝色）"
	item_path = /obj/item/clothing/suit/frenchtrench

/datum/loadout_item/suit/brtrench
	name = "风衣（棕色）"
	item_path = /obj/item/clothing/suit/trenchbrown

/datum/loadout_item/suit/frontiertrench
	name = "风衣 - 边疆款"
	item_path = /obj/item/clothing/suit/jacket/frontier_colonist

/datum/loadout_item/suit/cossak
	name = "乌克兰大衣"
	item_path = /obj/item/clothing/suit/cossack

/datum/loadout_item/suit/urban
	name = "都市大衣"
	item_path = /obj/item/clothing/suit/urban

/datum/loadout_item/suit/warm_coat
	name = "保暖大衣（可着色）"
	item_path = /obj/item/clothing/suit/warm_coat

/datum/loadout_item/suit/warm_sweater
	name = "保暖毛衣（可着色）"
	item_path = /obj/item/clothing/suit/warm_sweater

/datum/loadout_item/suit/heart_sweater
	name = "保暖毛衣（可着色，心形图案）"
	item_path = /obj/item/clothing/suit/heart_sweater

/datum/loadout_item/suit/varsity
	name = "校队夹克"
	item_path = /obj/item/clothing/suit/varsity

/datum/loadout_item/suit/offdep_jacket
	name = "工作夹克 - 非本部门"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber
	group = "Jackets"

/datum/loadout_item/suit/engi_jacket
	name = "工作夹克 - 工程"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/engi
	group = "Jobs"

/datum/loadout_item/suit/sci_jacket
	name = "工作夹克 - 科研"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/sci
	group = "Jobs"

/datum/loadout_item/suit/med_jacket
	name = "工作夹克 - 医疗部"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/med
	group = "Jobs"

/datum/loadout_item/suit/supply_jacket
	name = "工作夹克 - 补给部"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/colorable_bomber/supply
	group = "Jobs"

/*
*	HOODIES
*/

/datum/loadout_item/suit/hoodie
	abstract_type = /datum/loadout_item/suit/hoodie

/datum/loadout_item/suit/hoodie/greyscale
	name = "Hoodie (Colorable)"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie

/datum/loadout_item/suit/hoodie/greyscale_trim_alt
	name = "Hoodie (Colorable, Pocket Trim)"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/trim/alt

/datum/loadout_item/suit/hoodie/greyscale_trim
	name = "Hoodie (Colorable, Zipper Trim)"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/trim

/datum/loadout_item/suit/hoodie/black
	name = "连帽衫（黑色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/black

/datum/loadout_item/suit/hoodie/red
	name = "连帽衫（红色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/red

/datum/loadout_item/suit/hoodie/blue
	name = "连帽衫（蓝色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/blue

/datum/loadout_item/suit/hoodie/green
	name = "连帽衫（绿色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/green

/datum/loadout_item/suit/hoodie/orange
	name = "连帽衫（橙色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/orange

/datum/loadout_item/suit/hoodie/yellow
	name = "连帽衫（黄色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/yellow

/datum/loadout_item/suit/hoodie/grey
	name = "连帽衫（灰色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/grey

/datum/loadout_item/suit/hoodie/nt
	name = "连帽衫 - NT"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded

/datum/loadout_item/suit/hoodie/smw
	name = "连帽衫 - SMW"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/smw

/datum/loadout_item/suit/hoodie/nrti
	name = "连帽衫 - NRTI"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/nrti

/datum/loadout_item/suit/hoodie/cti
	name = "连帽衫 - CTI"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/cti

/datum/loadout_item/suit/hoodie/mu
	name = "连帽衫 - MU"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/mu

/datum/loadout_item/suit/recolorable_apron
	name = "围裙"
	item_path = /obj/item/clothing/suit/apron/chef/colorable_apron
	group = "Jobs"

/datum/loadout_item/suit/gear_harness
	name = "装备背带（外套）"
	item_path = /obj/item/clothing/under/misc/nova/gear_harness/suit

/datum/loadout_item/suit/frontierjacket/short/medical
	name = "边疆夹克 - 医疗（短款）"
	item_path = /obj/item/clothing/suit/jacket/frontier_colonist/medical
	group = "Jobs"

/datum/loadout_item/suit/cargo_gorka_jacket
	name = "戈尔卡夹克 - 货运"
	item_path = /obj/item/clothing/suit/toggle/cargo_tech
	group = "Jobs"

/datum/loadout_item/suit/labcoat_highvis
	name = "高能见度夹克"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/highvis
	group = "Jobs"

/datum/loadout_item/suit/labcoat
	name = "实验袍"
	item_path = /obj/item/clothing/suit/toggle/labcoat
	group = "Jobs"

/datum/loadout_item/suit/labcoat_custom
	name = "实验袍（可着色）"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/custom
	group = "Jobs"

/datum/loadout_item/suit/labcoat_green
	name = "实验袍（绿色）"
	item_path = /obj/item/clothing/suit/toggle/labcoat/mad
	group = "Jobs"

/datum/loadout_item/suit/labcoat_medical
	name = "实验袍 - 医疗"
	item_path = /obj/item/clothing/suit/toggle/labcoat/medical
	group = "Jobs"

/datum/loadout_item/suit/labcoat_lalunevest
	name = "实验袍 - 设计师款"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/lalunevest
	group = "Jobs"

/datum/loadout_item/suit/fancy_labcoat
	name = "实验袍 - 华丽款（可着色）"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/fancy
	group = "Jobs"

/datum/loadout_item/suit/labcoat_regular
	name = "实验袍 - 华丽款，研究部"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/fancy/regular
	group = "Jobs"

/datum/loadout_item/suit/labcoat_pharmacist
	name = "实验袍 - 华丽款，药房"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/fancy/pharmacist
	group = "Jobs"

/datum/loadout_item/suit/labcoat_geneticist
	name = "实验袍 - 华丽款，遗传学"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/fancy/geneticist
	group = "Jobs"

/datum/loadout_item/suit/labcoat_roboticist
	name = "实验袍 - 华丽款，机器人学"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/fancy/roboticist
	group = "Jobs"

/datum/loadout_item/suit/overall
	name = "工装裤（可重着色）" // can't have both job palettes and player coloring, so we prefer player colors
	loadout_flags = LOADOUT_FLAG_ALLOW_NAMING
	group = "Jobs"

/datum/loadout_item/suit/overalls_loneskirt
	name = "工装裙"
	item_path = /obj/item/clothing/suit/apron/overalls_loneskirt
	group = "Jobs"

//Religious Clothing
/datum/loadout_item/suit/chap_eastmonk
	name = "宗教 - 东方僧侣袍"
	item_path = /obj/item/clothing/suit/chaplainsuit/monkrobeeast
	group = "Jobs"

/datum/loadout_item/suit/chap_holiday
	name = "宗教 - 节日祭司袍"
	item_path = /obj/item/clothing/suit/chaplainsuit/holidaypriest
	group = "Jobs"

/datum/loadout_item/suit/chap_brownmonk
	name = "宗教 - 僧侣常服"
	item_path = /obj/item/clothing/suit/hooded/chaplainsuit/monkhabit
	group = "Jobs"

/datum/loadout_item/suit/chap_nun
	name = "宗教 - 修女袍"
	item_path = /obj/item/clothing/suit/chaplainsuit/nun
	group = "Jobs"

/datum/loadout_item/suit/chap_shrinehand
	name = "宗教 - 神社侍者袍"
	item_path = /obj/item/clothing/suit/chaplainsuit/shrinehand
	group = "Jobs"

/datum/loadout_item/suit/chap_blackmonk
	name = "宗教 - 束腰外衣"
	item_path = /obj/item/clothing/suit/chaplainsuit/habit
	group = "Jobs"

/*
*	COSTUMES
*/

/datum/loadout_item/suit/syndi
	name = "黑红太空服复制品"
	item_path = /obj/item/clothing/suit/syndicatefake
	group = "Costumes"

/datum/loadout_item/suit/blastwave_suit
	name = "冲击波风衣"
	item_path = /obj/item/clothing/suit/blastwave
	group = "Costumes"

/datum/loadout_item/suit/caretaker
	name = "看护员夹克"
	item_path = /obj/item/clothing/suit/victoriantailcoatbutler
	group = "Costumes"

/datum/loadout_item/suit/deckers
	name = "甲板工连帽衫"
	item_path = /obj/item/clothing/suit/costume/deckers
	group = "Costumes"

/datum/loadout_item/suit/flakjack
	name = "防弹背心"
	item_path = /obj/item/clothing/suit/flakjack
	group = "Costumes"

/datum/loadout_item/suit/plague_doctor
	name = "瘟疫医生长袍"
	item_path = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	group = "Costumes"

/datum/loadout_item/suit/pg
	name = "PG大衣"
	item_path = /obj/item/clothing/suit/costume/pg
	group = "Costumes"

/datum/loadout_item/suit/poncho
	name = "斗篷"
	item_path = /obj/item/clothing/suit/costume/poncho
	group = "Costumes"

/datum/loadout_item/suit/poncho_green
	name = "斗篷（绿色）"
	item_path = /obj/item/clothing/suit/costume/poncho/green
	group = "Costumes"

/datum/loadout_item/suit/poncho_red
	name = "斗篷（红色）"
	item_path = /obj/item/clothing/suit/costume/poncho/red
	group = "Costumes"

/datum/loadout_item/suit/redhood
	name = "红色斗篷"
	item_path = /obj/item/clothing/suit/hooded/cloak/david
	group = "Costumes"

/datum/loadout_item/suit/soviet
	name = "苏维埃大衣"
	item_path = /obj/item/clothing/suit/costume/soviet
	group = "Costumes"

/datum/loadout_item/suit/bee
	name = "套装 - 蜜蜂"
	item_path = /obj/item/clothing/suit/hooded/bee_costume
	group = "Costumes"

/datum/loadout_item/suit/cardborg
	name = "套装 - 纸板机器人"
	item_path = /obj/item/clothing/suit/costume/cardborg
	group = "Costumes"

/datum/loadout_item/suit/carp_costume
	name = "套装 - 鲤鱼"
	item_path = /obj/item/clothing/suit/hooded/carp_costume
	group = "Costumes"

/datum/loadout_item/suit/chicken
	name = "套装 - 小鸡"
	item_path = /obj/item/clothing/suit/costume/chickensuit
	group = "Costumes"

/datum/loadout_item/suit/ian_costume
	name = "套装 - 柯基犬"
	item_path = /obj/item/clothing/suit/hooded/ian_costume
	group = "Costumes"

/datum/loadout_item/suit/griffin
	name = "套装 - 狮鹫"
	item_path = /obj/item/clothing/suit/toggle/owlwings/griffinwings
	group = "Costumes"

/datum/loadout_item/suit/monkey
	name = "套装 - 猴子"
	item_path = /obj/item/clothing/suit/costume/monkeysuit
	group = "Costumes"

/datum/loadout_item/suit/owl
	name = "套装 - 猫头鹰"
	item_path = /obj/item/clothing/suit/toggle/owlwings
	group = "Costumes"

/datum/loadout_item/suit/shark_costume
	name = "套装 - 鲨鱼"
	item_path = /obj/item/clothing/suit/hooded/shark_costume
	group = "Costumes"

/datum/loadout_item/suit/shork_costume
	name = "套装 - 短吻鲨"
	item_path = /obj/item/clothing/suit/hooded/shork_costume
	group = "Costumes"

/datum/loadout_item/suit/snowman
	name = "套装 - 雪人"
	item_path = /obj/item/clothing/suit/costume/snowman
	group = "Costumes"

/datum/loadout_item/suit/xenos
	name = "套装 - 异形"
	item_path = /obj/item/clothing/suit/costume/xenos
	group = "Costumes"

/datum/loadout_item/suit/tmc
	name = "TMC大衣"
	item_path = /obj/item/clothing/suit/costume/tmc
	group = "Costumes"

/datum/loadout_item/suit/white_dress
	name = "白色连衣裙"
	item_path = /obj/item/clothing/suit/costume/whitedress
	group = "Costumes"

/datum/loadout_item/suit/tailcoat
	name = "Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatbartender
	name = "Bartender's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/bartender
	restricted_roles = list(JOB_BARTENDER)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatwizard
	name = "Magician's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/magician
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatbrit
	name = "Brit's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/british
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatussr
	name = "Soviet's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/communist
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatusa
	name = "Yank's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/usa
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatcargo
	name = "Cargo's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/cargo
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatbitrunner
	name = "Gamer's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/bitrunner
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatmedical
	name = "Doctor's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatmedicalpara
	name = "Paramedic's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/paramedic/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatmedicalchem
	name = "Chemist's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/chemist/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatmedicalviro
	name = "Pathologist's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/virologist/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatmedicalcoroner
	name = "Edgelord's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/coroner/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatrnd
	name = "Scientist's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/science/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatrndrobo
	name = "Roboticist's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/roboticist/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatrndgenetics
	name = "Geneticist's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/genetics/doctor_tailcoat
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatjanitor
	name = "Janitor's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/janitor
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatcook
	name = "Chef's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/cook
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoathydro
	name = "Botanist's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/botanist
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatclown
	name = "Clown's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/clown
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatmime
	name = "Mime's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/mime
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatchaplain
	name = "Priest's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/chaplain
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatcuratorred
	name = "Curator's Red Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/curator_red
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatcuratorgreen
	name = "Curator's Green Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/curator_green
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatcuratorteal
	name = "Curator's Teal Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/curator_teal
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatlawyerblack
	name = "Lawyer's Black Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/lawyer_black
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatlawyerblue
	name = "Lawyer's Blue Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/lawyer_blue
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatlawyerred
	name = "Lawyer's Red Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/lawyer_red
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatlawyergood
	name = "Lawyer's Good Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/lawyer_good
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatshrink
	name = "Psychologist's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/psychologist
	group = "Tailcoats"

/datum/loadout_item/suit/jacket/long_robe
	name = "长袍"
	item_path = /obj/item/clothing/suit/jacket/long_robe
	reskin_datum = /datum/atom_skin/long_robe
	group = "Costumes"

/datum/loadout_item/suit/jacket/haori
	name = "羽织"
	item_path = /obj/item/clothing/suit/jacket/haori
	reskin_datum = /datum/atom_skin/haori
	group = "Costumes"

/datum/loadout_item/suit/witch
	name = "女巫袍"
	item_path = /obj/item/clothing/suit/wizrobe/marisa/fake
	group = "Costumes"

/datum/loadout_item/suit/wizard
	name = "巫师袍"
	item_path = /obj/item/clothing/suit/wizrobe/fake
	group = "Costumes"

/datum/loadout_item/suit/yuri
	name = "尤里大衣"
	item_path = /obj/item/clothing/suit/costume/yuri
	group = "Costumes"

/*
*	SPECIES-UNIQUE
*/

/datum/loadout_item/suit/mothcoat
	name = "飞蛾族飞行服"
	item_path = /obj/item/clothing/suit/mothcoat
	group = "Species-Unique"

/datum/loadout_item/suit/mantella
	name = "飞蛾族曼特拉披风"
	item_path = /obj/item/clothing/suit/mothcoat/winter
	group = "Species-Unique"

/datum/loadout_item/suit/ethereal_raincoat
	name = "虚灵雨衣"
	item_path = /obj/item/clothing/suit/hooded/ethereal_raincoat
	group = "Species-Unique"

/*
*	Jobs
*/

//COM
/datum/loadout_item/suit/tailcoatcc
	name = "Centcom Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/centcom
	restricted_roles = list(ALL_JOBS_CC)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatcap
	name = "Captain's Tailcoat"
	item_path = /obj/item/clothing/suit/armor/vest/capcarapace/tailcoat_captain
	restricted_roles = list(JOB_CAPTAIN)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoathop
	name = "Head of Personnel's Tailcoat"
	item_path = /obj/item/clothing/suit/armor/hop_tailcoat
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL)
	group = "Tailcoats"

//CARGO
/datum/loadout_item/suit/qm_jacket
	name = "军需官的大衣"
	item_path = /obj/item/clothing/suit/jacket/quartermaster
	restricted_roles = list(JOB_QUARTERMASTER)
	group = "Jobs"

/datum/loadout_item/suit/tailcoatqm
	name = "Quartermaster's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/quartermaster
	restricted_roles = list(JOB_QUARTERMASTER)
	group = "Tailcoats"

//ENGI

/datum/loadout_item/suit/tailcoatengi/ce
	name = "Chief Engineer's Tailcoat"
	item_path = /obj/item/clothing/suit/utility/fire/ce_tailcoat
	restricted_roles = list(JOB_CHIEF_ENGINEER)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatengi
	name = "Engineer's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/tailcoat/engineer
	restricted_roles = list(ALL_JOBS_ENGI)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatengiatmos
	name = "Atmos Tech's Tailcoat"
	item_path = /obj/item/clothing/suit/utility/fire/atmos_tech_tailcoat
	restricted_roles = list(ALL_JOBS_ENGI)
	group = "Tailcoats"

//MED
/datum/loadout_item/suit/tailcoatmedcmo
	name = "Chief Medical Officer's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/cmo/doctor_tailcoat
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	group = "Tailcoats"

//SCI
/datum/loadout_item/suit/tailcoatrndrd
	name = "Research Director's Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/research_director/tailcoat
	restricted_roles = list(JOB_RESEARCH_DIRECTOR)
	group = "Tailcoats"

//SEC
/datum/loadout_item/suit/navybluejackethos
	name = "安全主管正装夹克（海军蓝）"
	item_path = /obj/item/clothing/suit/jacket/hos/blue
	restricted_roles = list(JOB_HEAD_OF_SECURITY)
	group = "Jobs"

/datum/loadout_item/suit/tailcoatsechos
	name = "Head of Security's Tailcoat"
	item_path = /obj/item/clothing/suit/armor/hos_tailcoat
	restricted_roles = list(JOB_HEAD_OF_SECURITY)
	group = "Tailcoats"

/datum/loadout_item/suit/navybluejacketwarden
	name = "典狱长正装夹克（海军蓝）"
	item_path = /obj/item/clothing/suit/jacket/warden/blue
	restricted_roles = list(JOB_WARDEN)
	group = "Jobs"

/datum/loadout_item/suit/tailcoatsecwarden
	name = "Warden's Tailcoat"
	item_path = /obj/item/clothing/suit/armor/security_tailcoat/warden
	restricted_roles = list(JOB_WARDEN)
	group = "Tailcoats"

/datum/loadout_item/suit/british_jacket
	name = "安保英式大衣"
	item_path = /obj/item/clothing/suit/british_officer
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/navybluejacketofficer
	name = "安保正装夹克（海军蓝）"
	item_path = /obj/item/clothing/suit/jacket/officer/blue
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/brit
	name = "安保高可见度防弹背心"
	item_path = /obj/item/clothing/suit/armor/vest/brit
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/vested_jacket
	name = "带背心安保夹克"
	item_path = /obj/item/clothing/suit/armor/vest/vested_jacket
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/security_wintercoat
	name = "安保冬季夹克"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/security
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/security_wintercoat_blue
	name = "安保冬季大衣（蓝色）"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/security/blue
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/security_jacket
	name = "安保工作夹克"
	item_path = /obj/item/clothing/suit/toggle/jacket/nova/sec
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/suit/tailcoatsec
	name = "Security's Tailcoat"
	item_path = /obj/item/clothing/suit/armor/security_tailcoat
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatsecdept
	name = "Security's Deputy Tailcoat"
	item_path = /obj/item/clothing/suit/armor/security_tailcoat/assistant
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatsecmedic
	name = "Security's Medicated Tailcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/nova/security_medic/doctor_tailcoat
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Tailcoats"

//Detective
/datum/loadout_item/suit/deckard
	name = "侦探跑者大衣"
	item_path = /obj/item/clothing/suit/toggle/deckard
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/suit/detectivearmorvest
	name = "侦探防弹背心"
	item_path = /obj/item/clothing/suit/armor/vest/det_suit
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/suit/detjacketbrown
	name = "侦探夹克"
	item_path = /obj/item/clothing/suit/jacket/det_suit
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/suit/detjackenoir
	name = "侦探夹克（黑色电影风格）"
	item_path = /obj/item/clothing/suit/jacket/det_suit/noir
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/suit/detjacketplain
	name = "侦探风衣"
	item_path = /obj/item/clothing/suit/toggle/jacket/det_trench
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/suit/detjacket
	name = "侦探风衣（深色）"
	item_path = /obj/item/clothing/suit/toggle/jacket/det_trench/noir
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/suit/tailcoatsecdet
	name = "Detective's Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/det_suit/tailcoat
	restricted_roles = list(JOB_DETECTIVE)
	group = "Tailcoats"

/datum/loadout_item/suit/tailcoatsecdetnoir
	name = "Detective's Noir Tailcoat"
	item_path = /obj/item/clothing/suit/jacket/det_suit/tailcoat/noir
	restricted_roles = list(JOB_DETECTIVE)
	group = "Tailcoats"

/*
*	DONATOR
*/

/datum/loadout_item/suit/donator
	abstract_type = /datum/loadout_item/suit/donator
	donator_only = TRUE

/datum/loadout_item/suit/donator/blondie
	name = "牛仔背心"
	item_path = /obj/item/clothing/suit/cowboyvest

/datum/loadout_item/suit/digicoat_glitched //Public donator reward for Razurath.
	name = "数码大衣 - 故障"
	item_path = /obj/item/clothing/suit/toggle/digicoat/glitched

/datum/loadout_item/suit/donator/digicoat
	abstract_type = /datum/loadout_item/suit/donator/digicoat

/datum/loadout_item/suit/donator/digicoat/interdyne
	name = "数码大衣 - 因特戴恩"
	item_path = /obj/item/clothing/suit/toggle/digicoat/interdyne

/datum/loadout_item/suit/donator/digicoat/nanotrasen
	name = "数码大衣 - 纳米传讯"
	item_path = /obj/item/clothing/suit/toggle/digicoat/nanotrasen

/datum/loadout_item/suit/donator/furredjacket
	name = "毛皮夹克"
	item_path = /obj/item/clothing/suit/brownfurrich/public

/datum/loadout_item/suit/donator/whitefurredjacket
	name = "毛皮夹克（白色）"
	item_path = /obj/item/clothing/suit/brownfurrich/white

/datum/loadout_item/suit/donator/creamfurredjacket
	name = "毛皮夹克（奶油色）"
	item_path = /obj/item/clothing/suit/brownfurrich/cream

/datum/loadout_item/suit/donator/chokha //All-donators donator item for BlindPoet
	name = "伊瑟里安乔卡"
	item_path = /obj/item/clothing/suit/chokha

/datum/loadout_item/suit/donator/modern_winter
	name = "现代冬季大衣"
	item_path = /obj/item/clothing/suit/modern_winter

/datum/loadout_item/suit/donator/replica_parade_jacket
	name = "复制阅兵夹克"
	item_path = /obj/item/clothing/suit/replica_parade_jacket
