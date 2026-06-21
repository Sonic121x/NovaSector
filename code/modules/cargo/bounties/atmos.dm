/datum/bounty/item/atmospherics
	name = "气体起源"
	description = "如果你看到这个，说明出问题了。"
	reward = CARGO_CRATE_VALUE * 15
	wanted_types = list(/obj/item/tank = TRUE)
	/// How many moles are needed to fufill the bounty?
	var/moles_required = 20
	/// Typepath of the gas datum required to fufill the bounty
	var/gas_type

/datum/bounty/item/atmospherics/applies_to(obj/applied_obj)
	if(!..())
		return FALSE
	var/obj/item/tank/applied_tank = applied_obj
	var/datum/gas_mixture/our_mix = applied_tank.return_air()
	if(!our_mix.gases[gas_type])
		return FALSE
	return our_mix.gases[gas_type][MOLES] >= moles_required

/datum/bounty/item/atmospherics/contribution_amount(obj/shipped)
	var/obj/item/tank/shipped_tank = shipped
	var/datum/gas_mixture/our_mix = shipped_tank.return_air()
	return our_mix.gases[gas_type][MOLES]

/datum/bounty/item/atmospherics/pluox_tank
	name = "满钚罗索伦气瓶"
	description = "中央司令部研发部门正在研究超紧凑型内部呼吸装置。给我们运送一罐装满普路奥克西姆的气体，你将获得报酬。（20摩尔）"
	gas_type = /datum/gas/pluoxium

/datum/bounty/item/atmospherics/nitrium_tank
	name = "满亚硝基兴奋气气瓶"
	description = "88号空间站的非人员工已被自愿招募来测试性能增强药物。给他们运送一罐装满氮气的气体，以便他们开始测试。（20摩尔）"
	gas_type = /datum/gas/nitrium

/datum/bounty/item/atmospherics/freon_tank
	name = "满氟利昂气瓶"
	description = "33号空间站的超物质已开始分层过程。运送一罐氟利昂气体帮助他们阻止它！（20摩尔）"
	gas_type = /datum/gas/freon

/datum/bounty/item/atmospherics/tritium_tank
	name = "满氚气瓶"
	description = "49号空间站希望启动他们的研究计划。给他们运送一罐装满氚的储气罐。（20摩尔）"
	gas_type = /datum/gas/tritium

/datum/bounty/item/atmospherics/hydrogen_tank
	name = "满氢气气瓶"
	description = "我们的研发部门正在开发使用氢作为催化剂的更高效电池。给我们运送一罐装满氢气的储气罐。（20摩尔）"
	gas_type = /datum/gas/hydrogen

/datum/bounty/item/atmospherics/zauker_tank
	name = "满祖克气瓶"
	description = "The main planet of \[REDACTED] has been chosen as testing grounds for the new weapon that uses Zauker gas. Ship us a tank full of it. (20 Moles)"
	reward = CARGO_CRATE_VALUE * 20
	gas_type = /datum/gas/zauker
