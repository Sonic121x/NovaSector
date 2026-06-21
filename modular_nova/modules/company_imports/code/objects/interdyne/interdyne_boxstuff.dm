/*
	This file is here to stop bloating in other files, this is mainly to make smaller stuff or individual items able to be kept here
they get called in files like interdyne_crates.dm and interdyne_kits.dm
*/

/obj/item/reagent_containers/cup/beaker/omnizine
	name = "Omnizine烧杯"
	list_reagents = list(/datum/reagent/medicine/omnizine = 60)

/obj/item/reagent_containers/cup/beaker/sal_acid
	name = "水杨酸烧杯"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 60)

/obj/item/reagent_containers/cup/beaker/dyne_brutemix
	name = "水杨酸/利比烧杯（钝伤）"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 30, /datum/reagent/medicine/c2/libital = 30)

/obj/item/reagent_containers/cup/beaker/dyne_burnmix
	name = "伦特/奥克桑烧杯（烧伤）"
	list_reagents = list(/datum/reagent/medicine/c2/lenturi = 30, /datum/reagent/medicine/oxandrolone = 30)

/obj/item/reagent_containers/cup/beaker/dyne_oxytox
	name = "康/赛弗烧杯（缺氧/毒素）"
	list_reagents = list(/datum/reagent/medicine/c2/convermol = 30, /datum/reagent/medicine/c2/seiver = 30)

/obj/item/reagent_containers/cup/beaker/oxandrolone
	name = "奥沙雄龙烧杯"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 60)

/obj/item/reagent_containers/cup/beaker/pen_acid
	name = "喷替酸烧杯"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 60)

/obj/item/reagent_containers/cup/beaker/atropine
	name = "阿托品烧杯"
	list_reagents = list(/datum/reagent/medicine/atropine = 60)

/obj/item/reagent_containers/cup/beaker/salbutamol
	name = "沙丁胺醇烧杯"
	list_reagents = list(/datum/reagent/medicine/salbutamol = 60)

/obj/item/reagent_containers/cup/beaker/rezadone
	name = "雷扎酮烧杯"
	list_reagents = list(/datum/reagent/medicine/rezadone = 60)

/obj/item/reagent_containers/cup/beaker/rezadone/less
	list_reagents = list(/datum/reagent/medicine/rezadone = 30)

/*
* Patches
*/

/obj/item/reagent_containers/applicator/patch/pen_acid
	name = "\improper 喷替酸贴片"
	icon_state = "bandaid_toxin"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 10)
	list_reagents_purity = 1

/obj/item/reagent_containers/applicator/patch/oxandrolone
	name = "\improper 奥沙雄龙贴片"
	icon_state = "bandaid_burn_2"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 10)
	list_reagents_purity = 1

/obj/item/reagent_containers/applicator/patch/salbutamol
	name = "\improper 沙丁胺醇贴片"
	icon_state = "bandaid_suffocation_2"
	list_reagents = list(/datum/reagent/medicine/salbutamol = 10)
	list_reagents_purity = 1

/obj/item/reagent_containers/applicator/patch/sal_acid
	name = "\improper 水杨酸贴片"
	icon_state = "bandaid_brute"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 10)
	list_reagents_purity = 1

/*
* Fluff
*/

/obj/item/paper/fluff/interdyne/medicines
	name = "公司便条"
	default_raw_text = "Please rememember to heat up your siever oxy/tox mix for maximum effectiveness elsewise we may have a lawsuit.\n\n \
		Interdyne leadership is not to be held responsible for the malpractice of the individual doctor."

/*
* Bandages
*/

/obj/item/storage/box/bandages/interdyne
	name = "\improper interdyne钝伤绷带盒"
	desc = "一个Interdyne盒子，装满了用于钝伤急救的医疗贴片"
	icon_state = "dynebox"
	base_icon_state = "dynebox"
	icon = 'modular_nova/master_files/icons/obj/storage/medkit.dmi'

/obj/item/storage/box/bandages/interdyne/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/applicator/patch/sal_acid(src)

/obj/item/storage/box/bandages/interdyne/burn
	name = "\improper interdyne烧伤绷带盒"
	desc = "一个Interdyne盒子，装满了用于烧伤急救的医疗贴片"

/obj/item/storage/box/bandages/interdyne/burn/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/applicator/patch/oxandrolone(src)

/obj/item/storage/box/bandages/interdyne/synthflesh
	name = "\improper 英特戴恩烧伤合成肉盒"
	desc = "一个装满急救医疗贴片的英特戴恩盒子，用于处理烧伤和钝器伤"

/obj/item/storage/box/bandages/interdyne/synthflesh/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/applicator/patch/synthflesh(src)

/obj/item/storage/box/bandages/interdyne/toxin
	name = "\improper 英特戴恩毒素绷带盒"
	desc = "一个装满急救医疗贴片的英特戴恩盒子，用于处理毒素伤害"

/obj/item/storage/box/bandages/interdyne/toxin/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/applicator/patch/pen_acid(src)

/obj/item/storage/box/bandages/interdyne/oxygen
	name = "\improper 英特戴恩氧气绷带盒"
	desc = "一个装满急救医疗贴片的英特戴恩盒子，用于处理缺氧损伤"

/obj/item/storage/box/bandages/interdyne/toxin/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/applicator/patch/salbutamol(src)
