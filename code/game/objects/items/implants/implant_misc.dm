/obj/item/implant/weapons_auth
	name = "火器认证植入体"
	desc = "让你能开枪射击。"
	icon_state = "auth"
	actions_types = null

	implant_info = "Automatically activates upon implantation. Provides authentication for weapons with \
		appropriate security systems, typically in the firing pin."

	implant_lore = "The Cybersun Equipment Authentication Implant is a subdermal RFID authentication module \
		and paired transmitter, designed to interface with equipment that has appropriate security systems, \
		such as implant-locked firing pins popular with associated covert operatives and non-state actors. \
		Equipment with such authentication systems is noteworthy for inconveniencing those trying to \
		pilfer equipment from fallen enemies' hands, preventing their equipment from easily being used. \
		However, it should be noted that the weakest link in a digital authentication scheme is oftentimes the physical layer."

/obj/item/implant/emp
	name = "\improper EMP植入体"
	desc = "触发一次EMP。"
	icon_state = "emp"
	uses = 3

	implant_info = "Activated manually. Generates an indiscriminate electromagnetic pulse of moderate size when triggered."

	implant_lore = "The Cybersun Subdermal Electromagnetic Pulse Generator is, true to its name, \
		a subdermal implant designed to generate indiscriminate electromagnetic pulses when triggered, \
		disrupting electronic equipment, such as energy weaponry, and lifeforms, \
		such as stationbound silicon units, within the user's radius. \
		Prospective users are reminded that the S-EPG does not protect the host from their own electromagnetic pulses."

/obj/item/implant/emp/activate()
	. = ..()
	uses--
	empulse(imp_in, 3, 5, emp_source = src)
	if(!uses)
		qdel(src)

/obj/item/implanter/emp
	name = "植入器" // NOVA EDIT, was implanter (EMP)
	imp_type = /obj/item/implant/emp
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // NOVA EDIT
	special_desc = "A Syndicate implanter used for a EMP implant" // NOVA EDIT

/obj/item/implant/smoke
	name = "烟雾植入体"
	desc = "释放一股烟雾。"
	icon_state = "smoke"
	uses = 3

	implant_info = "Activated manually. Generates an indiscriminate cloud of smoke of moderate size when triggered."

	implant_lore = "The Cybersun Subdermal Visual Obstruction Generator is, true to its name, \
		a subdermal implant designed to generate visual obstructions in the form of smoke clouds when triggered, \
		disrupting lines of sight to the user. \
		Prospective users are reminded that the S-VOG does not protect the host particularly well from \
		thermal imaging, nor does it actually stop blind fire into the smoke, nor does it stop movement."

/obj/item/implant/smoke/activate()
	. = ..()
	uses--
	do_smoke(6, imp_in, imp_in.loc, smoke_type = /datum/effect_system/fluid_spread/smoke/bad)
	if(!uses)
		qdel(src)

/obj/item/implanter/smoke
	name = "植入器（烟雾）"
	imp_type = /obj/item/implant/smoke

/obj/item/implant/radio
	name = "内置无线电植入体"
	var/obj/item/radio/radio
	var/radio_type = /obj/item/radio // NOVA EDIT ADDITION
	var/radio_key
	var/subspace_transmission = FALSE
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "walkietalkie"

	implant_info = "Automatically activates upon implantation. Provides radio transmission and reception capabilities."

	implant_lore = "The Internal Radio Implant, a long open-sourced design manufactured by \
		just about everyone from Nanotrasen to Cybersun, is a subdermal two-way radio system designed \
		to interface with telecommunications networks. It's mainly useful for those who expect either \
		equipment loss or lack the ability to use standalone radio equipment easily."

/obj/item/implant/radio/activate()
	. = ..()
	// needs to be GLOB.deep_inventory_state otherwise it won't open
	radio.ui_interact(usr, state = GLOB.deep_inventory_state)

/obj/item/implant/radio/Initialize(mapload, radio_key_1, radio_key_2) // NOVA EDIT CHANGE - ORIGINAL: /obj/item/implant/radio/Initialize(mapload)
	. = ..()

	radio = new radio_type(src) // NOVA EDIT CHANGE - ORIGINAL: radio = new(src)
	// almost like an internal headset, but without the
	// "must be in ears to hear" restriction.
	radio.name = "内置无线电"
	radio.subspace_transmission = subspace_transmission
	radio.canhear_range = 0
	if(radio_key)
		radio.keyslot = new radio_key
	radio.recalculateChannels()

/obj/item/implant/radio/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/item/implant/radio/mining
	radio_key = /obj/item/encryptionkey/headset_cargo

/obj/item/implant/radio/syndicate
	desc = "上帝你在吗？是我，辛迪加通讯特工。"
	radio_key = /obj/item/encryptionkey/syndicate
	subspace_transmission = TRUE

/obj/item/implant/radio/slime
	name = "史莱姆无线电"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "adamantine_resonator"
	radio_key = /obj/item/encryptionkey/headset_sci
	subspace_transmission = TRUE

/obj/item/implanter/radio
	name = "植入器（内置无线电）"
	imp_type = /obj/item/implant/radio

/obj/item/implanter/radio/syndicate
	name = "植入器" // NOVA EDIT , was originally implanter (internal syndicate radio)
	imp_type = /obj/item/implant/radio/syndicate
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // NOVA EDIT
	special_desc = "A Syndicate implanter used for a internal radio implant" // NOVA EDIT

