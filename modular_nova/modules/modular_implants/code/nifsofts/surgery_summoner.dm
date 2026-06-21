/obj/item/disk/nifsoft_uploader/job/summoner/surgery
	name = "阿斯克勒庇俄斯之书"
	loaded_nifsoft = /datum/nifsoft/summoner/job/surgery

/datum/nifsoft/summoner/job/surgery
	name = "医典·阿斯克勒庇俄斯"
	program_desc = "Grimoire Asclepius is a fork of the Grimoire Caeruleam NIFSoft utilised by the Marsian EMTs of Red Manila. A set of emergency-nanite-surgical tools for \
	the Marsian city of Red Manila,	where the surrounding red-deserts make immediate-access to medical facilities challenging on a good day, and outright impossible on a bad one. \
	Take your life, and your friends into your hands, with the Manilian Emergency Surgical set!"
	summonable_items = list(
		/obj/item/scalpel/nanite,
		/obj/item/retractor/nanite,
		/obj/item/hemostat/nanite,
		/obj/item/circular_saw/nanite,
		/obj/item/surgicaldrill/nanite,
		/obj/item/cautery/nanite,
		/obj/item/surgical_drapes/nanite,
		/obj/item/healthanalyzer/nanite,
		/obj/item/autopsy_scanner/nanite,
	)
	max_summoned_items = 2
	activation_cost = 150
	name_tag = "manilian "
	buying_category = NIFSOFT_CATEGORY_UTILITY
	ui_icon = FA_ICON_CROSS
	able_to_keep = FALSE

/obj/item/scalpel/nanite
	toolspeed = 1.5
	force = 0
	throwforce = 0
	desc = "由锋利无比、且不知为何能自我锐化的纳米机器人构成……虽然有点脆弱，但切口干净利落！"

/obj/item/retractor/nanite
	toolspeed = 1.5

/obj/item/hemostat/nanite
	toolspeed = 1.5

/obj/item/circular_saw/nanite
	toolspeed = 1.5
	force = 0
	throwforce = 0
	desc = "这突破了纳米机器人的极限，是一把完全由纳米机器人构成的完整功能锯……虽然它会闪烁和消退，但锯片似乎始终存在！"

/obj/item/surgicaldrill/nanite
	toolspeed = 1.5
	force = 0

/obj/item/cautery/nanite
	toolspeed = 1.5

/obj/item/surgical_drapes/nanite

/obj/item/healthanalyzer/nanite

/obj/item/autopsy_scanner/nanite
