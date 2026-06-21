/datum/mod_theme/responsory/ancient_milsim
	armor_type = /datum/armor/armor_sf_hardened

/obj/item/mod/control/pre_equipped/responsory/milsim
	theme = /datum/mod_theme/responsory/ancient_milsim
	applied_cell = /obj/item/stock_parts/power_store/cell/super
	starting_frequency = MODLINK_FREQ_NANOTRASEN
	req_access = null

/obj/item/mod/control/pre_equipped/responsory/milsim/mechanic
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/medhud,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/medhud,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_mechanic
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/mechanic

/obj/item/mod/control/pre_equipped/responsory/milsim/trapper
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/thermal,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/thermal,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_trapper
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/trapper

/obj/item/mod/control/pre_equipped/responsory/milsim/marksman
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/active_sonar,
		/obj/item/mod/module/visor/night,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/active_sonar,
		/obj/item/mod/module/visor/night,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_marksman
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/marksman

/obj/item/mod/control/pre_equipped/responsory/milsim/medic
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/medhud,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/medhud,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_medic
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/medic

/obj/item/mod/control/pre_equipped/responsory/milsim/saboteur
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/meson,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/visor/meson,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_saboteur
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/saboteur

/obj/item/mod/control/pre_equipped/responsory/milsim/sentinel
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/active_sonar,
		/obj/item/mod/module/visor/night,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/active_sonar,
		/obj/item/mod/module/visor/night,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_sentinel
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/sentinel

/obj/item/mod/control/pre_equipped/responsory/milsim/trooper
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/status_readout/operational,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/active_sonar,
		/obj/item/mod/module/visor/night,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/active_sonar,
		/obj/item/mod/module/visor/night,
	)
	insignia_type = /obj/item/mod/module/insignia/milsim_trooper
	additional_modules = /obj/item/mod/module/dispenser/ancient_milsim/trooper

/obj/item/mod/module/dispenser/ancient_milsim
	removable = FALSE
	var/first_use = TRUE
	var/new_dispense_type = /obj/item/food/burger/tofu
	var/new_cooldown_time = 2 SECONDS

/obj/item/mod/module/dispenser/ancient_milsim/on_use()
	. = ..()
	if(first_use)
		first_use = FALSE
		cooldown_time = new_cooldown_time
		dispense_type = new_dispense_type

/obj/item/mod/module/dispenser/ancient_milsim/mechanic
	name = "MOD外星工具-电缆分发器模块"
	desc = "该模块可以根据使用者的喜好创建一套高级工具和额外的电缆卷。"
	dispense_type = /obj/item/storage/belt/military/abductor/full
	cooldown_time = 5 SECONDS
	new_dispense_type = /obj/item/stack/cable_coil
	new_cooldown_time = 15 SECONDS

/obj/item/mod/module/dispenser/ancient_milsim/trapper
	name = "MOD变色龙投影仪-隐形地雷分发器模块"
	desc = "该模块可以根据使用者的喜好创建一个变色龙投影仪和额外的隐形地雷。"
	dispense_type = /obj/item/chameleon
	cooldown_time = 10 SECONDS
	new_dispense_type = /obj/item/minespawner/ancient_milsim
	new_cooldown_time = 10 SECONDS

/obj/item/mod/module/dispenser/ancient_milsim/marksman
	name = "MOD路障箱-投掷飞刀分发器模块"
	desc = "该模块可以根据使用者的喜好创建一箱路障和额外的投掷飞刀。"
	dispense_type = /obj/item/storage/barricade
	cooldown_time = 15 SECONDS
	new_dispense_type = /obj/item/knife/combat/throwing
	new_cooldown_time = 5 SECONDS

/obj/item/mod/module/dispenser/ancient_milsim/medic
	name = "MOD定制注射器-注射器药瓶分发器模块"
	desc = "该模块可以根据使用者的喜好创建一个单兵战斗注射器和额外的药筒。"
	dispense_type = /obj/item/hypospray/mkii/deluxe/cmo/combat/ancient_milsim
	cooldown_time = 5 SECONDS
	new_dispense_type = /obj/item/reagent_containers/cup/vial/large/ancient_milsim
	new_cooldown_time = 15 SECONDS

/obj/item/hypospray/mkii/deluxe/cmo/combat/ancient_milsim
	start_vial = /obj/item/reagent_containers/cup/vial/large/ancient_milsim

/obj/item/reagent_containers/cup/vial/large/ancient_milsim
	name = "全愈-虚拟"
	icon_state = "hypoviallarge-buff"
	list_reagents = list(
		/datum/reagent/medicine/muscle_stimulant = 15,
		/datum/reagent/medicine/regen_jelly = 30,
		/datum/reagent/iron = 25,
		/datum/reagent/medicine/coagulant = 15,
		/datum/reagent/medicine/c2/penthrite = 15,
	)

/obj/item/mod/module/dispenser/ancient_milsim/saboteur
	name = "MOD比尼亚特植入器-EMP手榴弹分发器模块"
	desc = "该模块可以根据使用者的喜好创建一个比尼亚特牌组植入器和额外的EMP手榴弹。"
	dispense_type = /obj/item/autosurgeon/syndicate/binyat
	cooldown_time = 15 SECONDS
	new_dispense_type = /obj/item/grenade/empgrenade
	new_cooldown_time = 10 SECONDS

/obj/item/autosurgeon/syndicate/binyat
	starting_organ = /obj/item/organ/cyberimp/hackerman_deck

/obj/item/mod/module/dispenser/ancient_milsim/sentinel
	name = "MOD固定机枪-机枪弹药箱模块"
	desc = "该模块可以根据使用者的喜好创建一个拆解的重机枪和额外的弹药箱。"
	dispense_type = /obj/item/mounted_machine_gun_folded
	cooldown_time = 15 SECONDS
	new_dispense_type = /obj/item/ammo_box/magazine/mmg_box
	new_cooldown_time = 15 SECONDS

/obj/item/mod/module/dispenser/ancient_milsim/trooper
	name = "MOD索尔步枪-索尔步枪弹匣分发器模块"
	desc = "该模块可以根据使用者的喜好创建一个.40索尔口径突击步枪和额外的弹匣。"
	dispense_type = /obj/item/gun/ballistic/automatic/sol_rifle/evil
	cooldown_time = 25 SECONDS
	new_dispense_type = /obj/item/ammo_box/magazine/c40sol_rifle/standard
	new_cooldown_time = 15 SECONDS

/obj/item/mod/module/insignia/milsim_mechanic
	color = "#ff7300"

/obj/item/mod/module/insignia/milsim_trapper
	color = "#372297"

/obj/item/mod/module/insignia/milsim_marksman
	color = "#a01d1d"

/obj/item/mod/module/insignia/milsim_medic
	color = "#2fdab4"

/obj/item/mod/module/insignia/milsim_saboteur
	color = "#1eff00"

/obj/item/mod/module/insignia/milsim_sentinel
	color = "#b536c0"

/obj/item/mod/module/insignia/milsim_trooper
	color = "#7e7e7e"
