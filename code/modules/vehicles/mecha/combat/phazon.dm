/obj/vehicle/sealed/mecha/phazon
	desc = "这是一台法赞外骨骼。它是科学研究的顶峰，也是纳米传讯公司的骄傲，运用了尖端的异常技术和昂贵的材料。"
	name = "\improper 法宗"
	icon_state = "phazon"
	base_icon_state = "phazon"
	movedelay = 2
	step_energy_drain = 4
	max_integrity = 200
	armor_type = /datum/armor/mecha_phazon
	max_temperature = 25000
	accesses = list(ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY)
	destruction_sleep_duration = 40
	exit_delay = 40
	wreckage = /obj/structure/mecha_wreckage/phazon
	mech_type = EXOSUIT_MODULE_PHAZON
	force = 15
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 2,
	)
	phase_state = "phazon-phase"

/datum/armor/mecha_phazon
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 30
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/phazon/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_phasing)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_switch_damtype)

/datum/action/vehicle/sealed/mecha/mech_switch_damtype
	name = "重新配置手臂工具阵列"
	button_icon_state = "mech_damtype_brute"

/datum/action/vehicle/sealed/mecha/mech_switch_damtype/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	if(!chassis || !(owner in chassis.occupants))
		return
	var/new_damtype
	switch(chassis.damtype)
		if(TOX)
			new_damtype = BRUTE
			chassis.balloon_alert(owner, "你的拳击现在将造成钝击伤害")
		if(BRUTE)
			new_damtype = BURN
			chassis.balloon_alert(owner, "你的拳头现在会造成灼烧伤害")
		if(BURN)
			new_damtype = TOX
			chassis.balloon_alert(owner,"你的拳头现在会造成毒素伤害")
	chassis.damtype = new_damtype
	button_icon_state = "mech_damtype_[new_damtype]"
	playsound(chassis, 'sound/vehicles/mecha/mechmove01.ogg', 50, TRUE)
	build_all_button_icons()

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing
	name = "切换相位"
	button_icon_state = "mech_phasing_off"

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	if(!chassis || !(owner in chassis.occupants))
		return
	chassis.phasing = chassis.phasing ? "" : "phasing"
	button_icon_state = "mech_phasing_[chassis.phasing ? "on" : "off"]"
	chassis.balloon_alert(owner, "[chassis.phasing ? "enabled" : "disabled"] 相位移动")
	build_all_button_icons()
