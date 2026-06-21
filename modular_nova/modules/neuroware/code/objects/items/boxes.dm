/obj/item/storage/box/flat/neuroware
	name = "神经软件芯片盒"
	desc = "一个廉价的纸板盒，最适合携带最多五片神经软件芯片。"
	icon = 'modular_nova/modules/neuroware/icons/box.dmi'
	icon_state = "neuroware_case"
	w_class = WEIGHT_CLASS_SMALL
	illustration = null
	foldable_result = null
	storage_type = /datum/storage/box/neuroware

///Neuroware storage box
/datum/storage/box/neuroware
	max_slots = 5

/datum/storage/box/neuroware/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/disk/neuroware,
	))

/obj/item/storage/box/flat/neuroware/happiness
	name = "神经软件芯片（微笑ML）"

/obj/item/storage/box/flat/neuroware/happiness/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/happiness(src)

/obj/item/storage/box/flat/neuroware/mindbreaker
	name = "神经芯片（PosiBlaster64）"

/obj/item/storage/box/flat/neuroware/mindbreaker/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/mindbreaker(src)

/obj/item/storage/box/flat/neuroware/space_drugs
	name = "神经芯片（卡莱多）"

/obj/item/storage/box/flat/neuroware/space_drugs/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/space_drugs(src)

/obj/item/storage/box/flat/neuroware/synaptizine
	name = "神经芯片（突触调谐器）"

/obj/item/storage/box/flat/neuroware/synaptizine/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/synaptizine(src)

/obj/item/storage/box/flat/neuroware/thc
	name = "神经芯片（Mr.Stoned v1）"

/obj/item/storage/box/flat/neuroware/thc/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/thc(src)

// Lewd neurowares

/obj/item/storage/box/flat/neuroware/crocin
	name = "神经软件芯片（情欲刺激）"

/obj/item/storage/box/flat/neuroware/crocin/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/crocin(src)

/obj/item/storage/box/flat/neuroware/hexacrocin
	name = "神经芯片（情欲刺激豪华版）"

/obj/item/storage/box/flat/neuroware/hexacrocin/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/hexacrocin(src)

/obj/item/storage/box/flat/neuroware/camphor
	name = "神经芯片（安神剂）"

/obj/item/storage/box/flat/neuroware/camphor/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/camphor(src)

/obj/item/storage/box/flat/neuroware/pentacamphor
	name = "神经芯片（诺比多极限版）"

/obj/item/storage/box/flat/neuroware/pentacamphor/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/disk/neuroware/pentacamphor(src)
