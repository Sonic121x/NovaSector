/datum/loadout_category/erp
	category_name = "Erotic"
	category_ui_icon = FA_ICON_HEART
	erp_category = TRUE
	type_to_generate = /datum/loadout_item/erp
	tab_order = /datum/loadout_category/pocket::tab_order + 1

/datum/loadout_category/erp/New()
	. = ..()
	category_info = "([MAX_ALLOWED_ERP_ITEMS] allowed)"

/datum/loadout_category/erp/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/erp/other_items = list()
	for(var/datum/loadout_item/erp/other_item in all_loadout_items)
		other_items += other_item

	if(length(other_items) >= MAX_ALLOWED_ERP_ITEMS)
		manager.deselect_item(other_items[1])
	return TRUE

/datum/loadout_item/erp/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	return FALSE

/datum/loadout_item/erp
	abstract_type = /datum/loadout_item/erp
	erp_item = TRUE
	erp_box = TRUE

/*
*	SEX TOYS
*/

/datum/loadout_item/erp/buttplug
	name = "肛塞"
	item_path = /obj/item/clothing/sextoy/buttplug

/datum/loadout_item/erp/clamps
	name = "乳头夹"
	item_path = /obj/item/clothing/sextoy/nipple_clamps

/datum/loadout_item/erp/egg
	name = "震动蛋"
	item_path = /obj/item/clothing/sextoy/eggvib

/datum/loadout_item/erp/egg/signal
	name = "信号震动蛋"
	item_path = /obj/item/clothing/sextoy/eggvib/signalvib

/datum/loadout_item/erp/signaler
	name = "信号器"
	item_path = /obj/item/assembly/signaler

/datum/loadout_item/erp/vibroring
	name = "震动环"
	item_path = /obj/item/clothing/sextoy/vibroring

/*
*	DILDOS
*/

/datum/loadout_item/erp/dildo
	name = "按摩棒"
	item_path = /obj/item/clothing/sextoy/dildo

/datum/loadout_item/erp/dildo/custom
	name = "自定义按摩棒"
	item_path = /obj/item/clothing/sextoy/dildo/custom_dildo

/datum/loadout_item/erp/dildo/double
	name = "双头按摩棒"
	item_path = /obj/item/clothing/sextoy/dildo/double_dildo

/datum/loadout_item/erp/fleshlight
	name = "飞机杯"
	item_path = /obj/item/clothing/sextoy/fleshlight

/datum/loadout_item/erp/magic_wand
	name = "魔法棒"
	item_path = /obj/item/clothing/sextoy/magic_wand

/datum/loadout_item/erp/vibrator
	name = "震动棒"
	item_path = /obj/item/clothing/sextoy/vibrator

/*
*	BELT
*/

/datum/loadout_item/erp/strapon
	name = "穿戴式假阳具"
	item_path = /obj/item/clothing/strapon

/*
*	MULTI USE
*/

/datum/loadout_item/erp/kinky_shocker
	name = "情趣电击器"
	item_path = /obj/item/kinky_shocker

/datum/loadout_item/erp/whip
	name = "鞭子"
	item_path = /obj/item/clothing/mask/leatherwhip

/datum/loadout_item/erp/candle
	name = "大豆蜡烛"
	item_path = /obj/item/bdsm_candle

/datum/loadout_item/erp/spanking_pad
	name = "拍打垫"
	item_path = /obj/item/spanking_pad

/datum/loadout_item/erp/feather
	name = "搔痒羽毛"
	item_path = /obj/item/tickle_feather

/datum/loadout_item/erp/borg_dom
	name = "博格女主人模块"
	item_path = /obj/item/borg/upgrade/dominatrixmodule

/datum/loadout_item/erp/holosign
	name = "个人全息标志投影仪"
	item_path = /obj/item/holosign_creator/privacy

/*
*	RESTRAINTS
*/

/datum/loadout_item/erp/handcuffs_lewd
	name = "情趣手铐"
	item_path = /obj/item/restraints/handcuffs/lewd

/datum/loadout_item/erp/shibari
	name = "缚绳"
	item_path = /obj/item/stack/shibari_rope/full

/datum/loadout_item/erp/shibari/glow
	name = "发光缚绳"
	item_path = /obj/item/stack/shibari_rope/glow/full

/datum/loadout_item/erp/ballgag
	name = "口球"
	item_path = /obj/item/clothing/mask/muzzle/ballgag

/datum/loadout_item/erp/ballgag/choking
	name = "阴茎状口球"
	item_path = /obj/item/clothing/mask/muzzle/ballgag/choking
	reskin_datum = /datum/atom_skin/ballgag

/datum/loadout_item/erp/muzzle_ring
	name = "环形口塞"
	item_path = /obj/item/clothing/mask/muzzle/ring

/datum/loadout_item/erp/deprivation_helmet
	name = "感官剥夺头盔"
	item_path = /obj/item/clothing/head/deprivation_helmet
	reskin_datum = /datum/atom_skin/deprivation_helmet

/datum/loadout_item/erp/blindfold
	name = "奢华眼罩"
	item_path = /obj/item/clothing/glasses/blindfold/dorms

/datum/loadout_item/erp/kinky_headphones
	name = "加厚耳机"
	item_path = /obj/item/clothing/ears/dorms_headphones

/datum/loadout_item/erp/lewd_filter
	name = "克罗辛过滤器"
	item_path = /obj/item/reagent_containers/cup/lewd_filter

/datum/loadout_item/erp/hypno_glasses
	name = "可疑眼镜"
	item_path = /obj/item/clothing/glasses/hypno

/datum/loadout_item/erp/leash
	name = "牵绳"
	item_path = /obj/item/clothing/erp_leash

/datum/loadout_item/erp/ball_mittens
	name = "球形连指手套"
	item_path = /obj/item/clothing/gloves/ball_mittens

/datum/loadout_item/erp/collar_shock
	name = "电击项圈"
	item_path = /obj/item/electropack/shockcollar

/datum/loadout_item/erp/collar_mind
	name = "心智项圈"
	item_path = /obj/item/clothing/neck/mind_collar

/datum/loadout_item/erp/collar_size
	name = "尺寸项圈（仅限互联）"
	item_path = /obj/item/clothing/neck/size_collar

/datum/loadout_item/erp/collar_key
	name = "项圈钥匙"
	item_path = /obj/item/key/collar

/datum/loadout_item/erp/latex_straight_jacket
	name = "乳胶束缚衣"
	item_path = /obj/item/clothing/suit/straight_jacket/latex_straight_jacket

/datum/loadout_item/erp/shackles
	name = "镣铐"
	item_path = /obj/item/clothing/suit/straight_jacket/shackles

/datum/loadout_item/erp/kinky_sleepbag
	name = "乳胶睡袋"
	item_path = /obj/item/clothing/suit/straight_jacket/kinky_sleepbag

/datum/loadout_item/erp/libidine
	name = "力比多契约"
	item_path = /obj/item/disk/nifsoft_uploader/dorms/contract

/*
*	CONSUMABLES
*/

/datum/loadout_item/erp/condom
	name = "安全套包"
	item_path = /obj/item/condom_pack

/datum/loadout_item/erp/serviette_pack
	name = "湿巾包"
	item_path = /obj/item/serviette_pack

/datum/loadout_item/erp/pillow
	name = "精美枕头"
	item_path = /obj/item/fancy_pillow

/datum/loadout_item/erp/crocin
	name = "克罗辛瓶"
	item_path = /obj/item/reagent_containers/cup/bottle/crocin

/datum/loadout_item/erp/camphor
	name = "樟脑瓶"
	item_path = /obj/item/reagent_containers/cup/bottle/camphor

/datum/loadout_item/erp/hexacrocin
	name = "六克罗辛瓶"
	item_path = /obj/item/reagent_containers/cup/bottle/hexacrocin

/datum/loadout_item/erp/pentacamphor
	name = "五樟脑瓶"
	item_path = /obj/item/reagent_containers/cup/bottle/pentacamphor

/datum/loadout_item/erp/crocin/pill
	name = "克罗辛药片"
	item_path = /obj/item/reagent_containers/applicator/pill/crocin

/datum/loadout_item/erp/camphor/pill
	name = "樟脑药片"
	item_path = /obj/item/reagent_containers/applicator/pill/camphor

/datum/loadout_item/erp/hexacrocin/pill
	name = "六克罗辛药片"
	item_path = /obj/item/reagent_containers/applicator/pill/hexacrocin

/datum/loadout_item/erp/pentacamphor/pill
	name = "五樟脑药片"
	item_path = /obj/item/reagent_containers/applicator/pill/pentacamphor

/datum/loadout_item/erp/succubus_milk
	name = "魅魔乳汁瓶"
	item_path = /obj/item/reagent_containers/cup/bottle/succubus_milk

/datum/loadout_item/erp/incubus_draft
	name = "梦魇精粹瓶"
	item_path = /obj/item/reagent_containers/cup/bottle/incubus_draft

/datum/loadout_item/erp/crocin_neuroware
	name = "情欲刺激神经芯片"
	item_path = /obj/item/disk/neuroware/crocin

/datum/loadout_item/erp/hexacrocin_neuroware
	name = "情欲刺激豪华神经芯片"
	item_path = /obj/item/disk/neuroware/hexacrocin

/datum/loadout_item/erp/camphor_neuroware
	name = "爱神镇静神经芯片"
	item_path = /obj/item/disk/neuroware/camphor

/datum/loadout_item/erp/pentacamphor_neuroware
	name = "诺比多极限神经芯片"
	item_path = /obj/item/disk/neuroware/pentacamphor

/datum/loadout_item/erp/crocin_neuroware_box
	name = "神经芯片盒（情欲刺激）"
	item_path = /obj/item/storage/box/flat/neuroware/crocin

/datum/loadout_item/erp/hexacrocin_neuroware_box
	name = "神经芯片盒（情欲刺激豪华版）"
	item_path = /obj/item/storage/box/flat/neuroware/hexacrocin

/datum/loadout_item/erp/camphor_neuroware_box
	name = "神经芯片盒（爱神镇静）"
	item_path = /obj/item/storage/box/flat/neuroware/camphor

/datum/loadout_item/erp/pentacamphor_neuroware_box
	name = "神经芯片盒（诺比多极限）"
	item_path = /obj/item/storage/box/flat/neuroware/pentacamphor
