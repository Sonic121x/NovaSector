/mob/living/silicon/robot/model/admin
	set_model = /obj/item/robot_model/admin
/*
//THIS LIKELY GOING TO BREAK STUFF
/mob/living/silicon/ai/Initialize()
	. = ..()
	initial_language_holder = /datum/language_holder/synthetic
*/
//UNICORN

/obj/item/robot_model/admin
	name = "VI"
	//initial_language_holder = /datum/language_holder/synthetic/silicon
	basic_modules = list(
		/obj/item/gripper/utility,
		/obj/item/gripper/utility,
		//obj/item/assembly/flash/cyborg,
		/obj/item/hand_tele,
		/obj/item/healthanalyzer/advanced,
		/obj/item/reagent_containers/borghypo/medical/admin,
		/obj/item/borg/apparatus/beaker,
		/obj/item/reagent_containers/dropper,
		//obj/item/reagent_containers/syringe/bluespace,
		/obj/item/gun/chem,
		/obj/item/reagent_containers/syringe/piercing,
		/obj/item/surgical_processor/surgical_drapes/admin,
		//obj/item/surgical_processor/admin,
		//obj/item/surgical_drapes,
		/obj/item/scalpel/advanced,
		/obj/item/retractor/advanced,
		/obj/item/cautery/advanced,
		/obj/item/borg/cyborg_omnitool/medical,
		//obj/item/bonesetter,
		/obj/item/stack/medical/bone_gel,
		/obj/item/blood_filter,
		/obj/item/debug/omnitool,
		/obj/item/shears,
		/obj/item/shockpaddles/cyborg,
		//obj/item/extinguisher/xl,
		/obj/item/extinguisher/mini/cyborg,
		/obj/item/extinguisher/advanced/xl,
		/obj/item/flashlight/pen/paramedic,
		//obj/item/roller/robo,
		/obj/item/emergency_bed/silicon,
		/obj/item/borg/cyborghug/admin,
		/obj/item/stack/medical/gauze,
		//obj/item/stack/medical/splint,
		/obj/item/stack/medical/suture/medicated,
		//obj/item/stack/medical/ointment,
		/obj/item/stack/medical/mesh/advanced,
		//obj/item/stack/medical/poultice,
		/obj/item/stack/sticky_tape/surgical,
		/obj/item/reagent_containers/spray/chemsprayer,
		//obj/item/reagent_containers/spray/medical,
		//obj/item/reagent_containers/medigel,
		/obj/item/borg/apparatus/organ_storage,
		//obj/item/weapon/gripper/medical,
		/obj/item/pinpointer/crew,
		/obj/item/sensor_device,
		/obj/item/construction/plumbing/admin,
		//obj/item/stack/ducts,
		/obj/item/borg/lollipop,
		/obj/item/rsf/unicorn,
		//obj/item/rsf/cookiesynth,
		/obj/item/construction/rcd/arcd/mattermanipulator/admin,
		/obj/item/construction/rtd/admin,
		/obj/item/pipe_dispenser/bluespace/admin,
		/obj/item/inducer/admin,
		/obj/item/t_scanner,
		/obj/item/geiger_counter,
		//obj/item/weldingtool/largetank/cyborg,
		//obj/item/weldingtool_electric,
		/obj/item/borg/cyborg_omnitool/engineering,
		/obj/item/screwdriver/cyborg/power,
		/obj/item/crowbar/cyborg/power,
		/obj/item/weldingtool/abductor/admin,
		/obj/item/multitool/abductor,
		//obj/item/borg/sight/meson,
		//obj/item/borg/sight/thermal,
		/obj/item/borg/sight/xray,
		/obj/item/analyzer/ranged,
		/obj/item/stack/cable_coil,
		//obj/item/multitool/cyborg,
		//obj/item/stackspawner,
		/obj/item/borg/apparatus/sheet_manipulator,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/glass,
		//obj/item/stack/sheet/rglass/cyborg,
		/obj/item/stack/rods/cyborg,
		//obj/item/stack/tile/iron/base/cyborg,

		/obj/item/stack/sheet/plasteel,
		/obj/item/stack/sheet/mineral/plasma/safe,
		/obj/item/stack/sheet/plasmaglass,
		/obj/item/stack/sheet/plasmarglass,
		/obj/item/stack/sheet/mineral/titanium,
		/obj/item/stack/sheet/titaniumglass,
		/obj/item/stack/sheet/mineral/silver,
		/obj/item/stack/sheet/mineral/gold,
		/obj/item/stack/sheet/mineral/diamond,
		/obj/item/stack/sheet/mineral/uranium,
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/stack/sheet/mineral/sandstone,
		/obj/item/stack/sheet/plastic,

		/obj/item/construction/rld/admin,
		/obj/item/lightreplacer/blue,
		/obj/item/holosign_creator/atmos/admin,
		//obj/item/holosign_creator/medical/admin,
		/obj/item/holosign_creator/janibarrier/admin,
		/obj/item/holosign_creator/admin,
		//obj/item/assembly/signaler/cyborg,
		/obj/item/blueprints/cyborg,
		/obj/item/electroadaptive_pseudocircuit,
		/obj/item/borg/apparatus/circuit,
		//obj/item/weapon/gripper,
		//obj/item/storage/bag/construction,
		//obj/item/storage/bag/sheetsnatcher/borg,
		//obj/item/storage/part_replacer/cyborg,
		/obj/item/storage/part_replacer/bluespace/tier4/bst,
		//obj/item/cautery/prt,
		/obj/item/pushbroom,
		/obj/item/mop/advanced,
		/obj/item/soap/nanotrasen/cyborg/omega,
		/obj/item/storage/bag/trash/bluespace/cyborg/vi,
		/obj/item/melee/flyswatter,
		/obj/item/reagent_containers/spray/chemsprayer/janitor,
		//obj/item/paint/paint_remover,
		//obj/item/storage/bag/plants,
		//obj/item/storage/bag/plants/portaseeder,
		/obj/item/paint/anycolor,
		/obj/item/airlock_painter/decal/cyborg,
		//obj/item/airlock_painter/decal/tile/debug,
		/obj/item/experi_scanner,
		/obj/item/storage/bag/bio,
		/obj/item/storage/bag/ore/holding,
		/obj/item/cyborg_clamp,
		//obj/item/weapon/gripper/mining,
		/obj/item/t_scanner/adv_mining_scanner/cyborg,
		/obj/item/shield_module,
		//obj/item/kinetic_crusher,
		/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg/unicorn,
		/obj/item/gun/energy/plasmacutter/unicorn,
		//obj/item/resonator/upgraded,
		//obj/item/gun/energy/kinetic_accelerator/cyborg,
		//obj/item/gun/energy/plasmacutter/recharge,
		/obj/item/pickaxe/drill/jackhammer,
		//obj/item/shovel,
		/obj/item/gps/cyborg,
		//obj/item/stamp/chameleon,
		//obj/item/pen,
		//obj/item/razor,
		/obj/item/toy/crayon/spraycan/borg,
		/obj/item/storage/bag/tray,
		/obj/item/rolling_table_dock,
		//obj/item/rolling_table_dock/rtable,
		/obj/item/borg/apparatus/service,
		/obj/item/knife/kitchen/silicon,
		//obj/item/cooking/cyborg/power,
		//obj/item/reagent_containers/food/condiment/enzyme,
		/obj/item/reagent_containers/borghypo/borgshaker/admin,
		/obj/item/reagent_containers/borghypo/borgshaker,
		/obj/item/borg/apparatus/beaker/service,
		//obj/item/instrument/guitar,
		/obj/item/harmalarm,
		/obj/item/borg/projectile_dampen,
		/obj/item/dest_tagger/borg,
		/obj/item/instrument/piano_synth,
		/obj/item/card/id/advanced/centcom,
		/obj/item/gun/medbeam,
		//obj/item/gun/microfusion/mcr01/advanced,
		/obj/item/binoculars,
		/obj/item/reagent_containers/borghypo/medical/admin/hacked
		)
	emag_modules = list(
	/obj/item/card/emag,
	//obj/item/reagent_containers/borghypo/borgshaker/hacked,
	//obj/item/gun/ballistic/revolver/grenadelauncher/cyborg,
	//obj/item/energy_katana
	//obj/item/vi_katana
	)
	special_light_key = null
	//clean_on_move = TRUE
	radio_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SUPPLY, RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_AI_PRIVATE, RADIO_CHANNEL_COMMAND, RADIO_CHANNEL_CENTCOM)
	canDispose = TRUE
	breakable_modules = FALSE
	model_traits = list(TRAIT_NEGATES_GRAVITY)
	borg_skins = list(
		"Unicorn" = list(SKIN_ICON_STATE = "unicorn", SKIN_ICON = 'modular_z121/icons/mob/robots_Vi.dmi', SKIN_FEATURES = list(TRAIT_R_TALL,TRAIT_R_UNIQUEWRECK,TRAIT_R_UNIQUETIP), SKIN_HAT_OFFSET = 4),
		"Unicorn(Modest)" = list(SKIN_ICON_STATE = "mo-unicorn", SKIN_ICON = 'modular_z121/icons/mob/robots.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK,TRAIT_R_UNIQUETIP), SKIN_HAT_OFFSET = 4),
		"Shark" = list(SKIN_ICON_STATE = "shark", SKIN_ICON = 'modular_z121/icons/mob/robots.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK), SKIN_HAT_OFFSET = -12),
		"Junimo" = list(SKIN_ICON_STATE =  "juni", SKIN_ICON = 'modular_z121/icons/mob/robots.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK), SKIN_HAT_OFFSET = -12),
		"Meka" = list(SKIN_ICON_STATE =  "mekajani", SKIN_ICON = 'modular_z121/icons/mob/robots_tall.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK), SKIN_HAT_OFFSET = 15),
		"B.13" = list(SKIN_ICON_STATE =  "B.13", SKIN_ICON = 'modular_z121/icons/mob/robots.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK), SKIN_HAT_OFFSET = 4)
		)
	var/datum/weakref/night_vision_ref
	var/datum/weakref/thermal_vision_ref
/*
//modular_nova/modules/altborgs/code/modules/mob/living/silicon/robot/robot_modules.dm
//MEDICAL
/obj/item/robot_model/admin/be_transformed_to(obj/item/robot_model/old_model)
	var/mob/living/silicon/robot/cyborg = loc
	var/static/list/uni_icons
	if(!uni_icons)
		uni_icons = list(
		"Unicorn" = image(icon = 'modular_z121/icons/mob/robots_Vi.dmi', icon_state = "unicorn"),
		"Unicorn(Modest)" = image(icon = 'modular_z121/icons/mob/robots.dmi', icon_state = "mo-unicorn"),
		"Shark" = image(icon = 'modular_z121/icons/mob/robots.dmi', icon_state = "shark"),
		"Junimo" = image(icon = 'modular_z121/icons/mob/robots.dmi', icon_state = "juni"),
		"Meka" = image(icon = 'modular_z121/icons/mob/robots_tall.dmi', icon_state = "mekajani"),
		"B.13" = image(icon = 'modular_z121/icons/mob/robots.dmi', icon_state = "B.13")
		)
		uni_icons = sort_list(uni_icons)
	var/uni_borg_icon = show_radial_menu(cyborg, cyborg , uni_icons, custom_check = CALLBACK(src, .proc/check_menu, cyborg, old_model), radius = 42, require_near = TRUE)
	switch(uni_borg_icon)
		if("Unicorn")
			cyborg_base_icon = "unicorn"
			cyborg_icon_override = 'modular_z121/icons/mob/robots_Vi.dmi'
			model_features = list(R_TRAIT_UNIQUEWRECK,R_TRAIT_UNIQUETIP)
			hat_offset = 4
		if("Unicorn(Modest)")
			cyborg_base_icon = "mo-unicorn"
			cyborg_icon_override = 'modular_z121/icons/mob/robots.dmi'
			model_features = list(R_TRAIT_UNIQUEWRECK,R_TRAIT_UNIQUETIP)
			hat_offset = 4
		if("Junimo")
			cyborg_base_icon = "juni"
			cyborg_icon_override = 'modular_z121/icons/mob/robots.dmi'
			model_features = list(R_TRAIT_UNIQUEWRECK)
			hat_offset = -12
		if("Shark")
			cyborg_base_icon = "shark"
			cyborg_icon_override = 'modular_z121/icons/mob/robots.dmi'
			model_features = list(R_TRAIT_UNIQUEWRECK)
			hat_offset = -12
		if("Meka")
			cyborg_base_icon = "mekajani"
			cyborg_icon_override = 'modular_z121/icons/mob/robots_tall.dmi'
			model_features = list(R_TRAIT_UNIQUEWRECK)
			hat_offset = 15
		if("B.13")
			cyborg_base_icon = "B.13"
			cyborg_icon_override = 'modular_z121/icons/mob/robots.dmi'
			model_features = list(R_TRAIT_UNIQUEWRECK)
			hat_offset = -4
		else
			return FALSE
	return ..()
*/
/obj/item/robot_model/admin/be_transformed_to(obj/item/robot_model/old_model, forced = FALSE)
	var/datum/action/cooldown/borg_meson/night_vision = new(loc)
	. = ..()
	if(!.)
		return
	night_vision.Grant(loc)
	night_vision_ref = WEAKREF(night_vision)
	var/datum/action/cooldown/borg_thermal/thermal_vision = new(loc)
	. = ..()
	if(!.)
		return
	thermal_vision.Grant(loc)
	thermal_vision_ref = WEAKREF(thermal_vision)

/obj/item/robot_model/admin/Destroy()
	QDEL_NULL(night_vision_ref)
	QDEL_NULL(thermal_vision_ref)
	return ..()

/obj/item/borg/cyborghug/admin
	shockallowed = TRUE
	boop = TRUE

/obj/item/borg/upgrade/lavaproof/Initialize()
	. = ..()
	model_type += /obj/item/robot_model/admin
/*
/obj/item/borg/upgrade/hypospray/Initialize()
	. = ..()
	model_type += /obj/item/robot_model/admin

/obj/item/borg/upgrade/defib/Initialize()
	. = ..()
	model_type += /obj/item/robot_model/admin

/obj/item/borg/upgrade/beaker_app/Initialize()
	. = ..()
	model_type += /obj/item/robot_model/admin

/obj/item/borg/upgrade/pinpointer/Initialize()
	. = ..()
	model_type += /obj/item/robot_model/admin

/obj/item/borg/upgrade/rped/Initialize()
	. = ..()
	model_type += /obj/item/robot_model/admin
*/
