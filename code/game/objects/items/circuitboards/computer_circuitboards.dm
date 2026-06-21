/obj/item/circuitboard/computer
	name = "通用"
	abstract_type = /obj/item/circuitboard/computer
	name_extension = "(Computer Board)"

/obj/item/circuitboard/computer/examine()
	. = ..()
	if(GetComponent(/datum/component/gps))
		. += span_info("有个小灯在闪烁！")

//Command

/obj/item/circuitboard/computer/aiupload
	name = "AI上传"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/upload/ai

/obj/item/circuitboard/computer/borgupload
	name = "机械人上传"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/upload/borg

/obj/item/circuitboard/computer/bsa_control
	name = "蓝空火炮控制台"
	build_path = /obj/machinery/computer/bsa_control

/obj/item/circuitboard/computer/accounting
	name = "账户查询控制台"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/accounting

/obj/item/circuitboard/computer/bankmachine
	name = "银行机器控制台"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/bank_machine

//Engineering

/obj/item/circuitboard/computer/apc_control
	name = "\improper 电力流向控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/apc_control

/obj/item/circuitboard/computer/atmos_alert
	name = "大气警报"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/atmos_alert
	var/station_only = FALSE

/obj/item/circuitboard/computer/atmos_alert/station_only
	station_only = TRUE

/obj/item/circuitboard/computer/atmos_alert/examine(mob/user)
	. = ..()
	. += span_info("该主板配置为[station_only ? "track all station and mining alarms" : "track alarms on the same z-level"]。")
	. += span_notice("The board mode can be changed with a [EXAMINE_HINT("multitool")].")

/obj/item/circuitboard/computer/atmos_alert/multitool_act(mob/living/user)
	station_only = !station_only
	balloon_alert(user, "追踪范围设置为[station_only ? "station" : "z-level"]")
	return TRUE

/obj/item/circuitboard/computer/atmos_control
	name = "大气控制"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/atmos_control

/obj/item/circuitboard/computer/atmos_control/nocontrol
	name = "大气监控器"
	build_path = /obj/machinery/computer/atmos_control/nocontrol

/obj/item/circuitboard/computer/atmos_control/noreconnect
	name = "大气控制"
	build_path = /obj/machinery/computer/atmos_control/noreconnect

/obj/item/circuitboard/computer/atmos_control/fixed
	name = "大气监控器"
	build_path = /obj/machinery/computer/atmos_control/fixed

/obj/item/circuitboard/computer/atmos_control/nocontrol/master
	name = "空间站大气监控器"
	build_path = /obj/machinery/computer/atmos_control/nocontrol/master

/obj/item/circuitboard/computer/atmos_control/nocontrol/incinerator
	name = "焚化炉室监控器"
	build_path = /obj/machinery/computer/atmos_control/nocontrol/incinerator

/obj/item/circuitboard/computer/atmos_control/ordnancemix
	name = "弹药室控制台"
	build_path = /obj/machinery/computer/atmos_control/ordnancemix

/obj/item/circuitboard/computer/atmos_control/oxygen_tank
	name = "氧气供应控制"
	build_path = /obj/machinery/computer/atmos_control/oxygen_tank

/obj/item/circuitboard/computer/atmos_control/plasma_tank
	name = "等离子体供应控制"
	build_path = /obj/machinery/computer/atmos_control/plasma_tank

/obj/item/circuitboard/computer/atmos_control/air_tank
	name = "混合空气供应控制"
	build_path = /obj/machinery/computer/atmos_control/air_tank

/obj/item/circuitboard/computer/atmos_control/mix_tank
	name = "气体混合供应控制"
	build_path = /obj/machinery/computer/atmos_control/mix_tank

/obj/item/circuitboard/computer/atmos_control/nitrous_tank
	name = "一氧化二氮供应控制"
	build_path = /obj/machinery/computer/atmos_control/nitrous_tank

/obj/item/circuitboard/computer/atmos_control/nitrogen_tank
	name = "氮气供应控制"
	build_path = /obj/machinery/computer/atmos_control/nitrogen_tank

/obj/item/circuitboard/computer/atmos_control/carbon_tank
	name = "二氧化碳供应控制"
	build_path = /obj/machinery/computer/atmos_control/carbon_tank

/obj/item/circuitboard/computer/atmos_control/bz_tank
	name = "BZ供应控制"
	build_path = /obj/machinery/computer/atmos_control/bz_tank

/obj/item/circuitboard/computer/atmos_control/freon_tank
	name = "氟利昂供应控制"
	build_path = /obj/machinery/computer/atmos_control/freon_tank

/obj/item/circuitboard/computer/atmos_control/halon_tank
	name = "哈龙供应控制"
	build_path = /obj/machinery/computer/atmos_control/halon_tank

/obj/item/circuitboard/computer/atmos_control/healium_tank
	name = "希利姆供应控制"
	build_path = /obj/machinery/computer/atmos_control/healium_tank

/obj/item/circuitboard/computer/atmos_control/hydrogen_tank
	name = "氢气供应控制"
	build_path = /obj/machinery/computer/atmos_control/hydrogen_tank

/obj/item/circuitboard/computer/atmos_control/hypernoblium_tank
	name = "超导氦供应控制"
	build_path = /obj/machinery/computer/atmos_control/hypernoblium_tank

/obj/item/circuitboard/computer/atmos_control/miasma_tank
	name = "瘴气供应控制"
	build_path = /obj/machinery/computer/atmos_control/miasma_tank

/obj/item/circuitboard/computer/atmos_control/nitrium_tank
	name = "硝基气供应控制"
	build_path = /obj/machinery/computer/atmos_control/nitrium_tank

/obj/item/circuitboard/computer/atmos_control/pluoxium_tank
	name = "普洛氧供应控制"
	build_path = /obj/machinery/computer/atmos_control/pluoxium_tank

/obj/item/circuitboard/computer/atmos_control/proto_nitrate_tank
	name = "原硝酸盐供应控制"
	build_path = /obj/machinery/computer/atmos_control/proto_nitrate_tank

/obj/item/circuitboard/computer/atmos_control/tritium_tank
	name = "氚供应控制"
	build_path = /obj/machinery/computer/atmos_control/tritium_tank

/obj/item/circuitboard/computer/atmos_control/water_vapor
	name = "水蒸气供应控制"
	build_path = /obj/machinery/computer/atmos_control/water_vapor

/obj/item/circuitboard/computer/atmos_control/zauker_tank
	name = "佐克供应控制"
	build_path = /obj/machinery/computer/atmos_control/zauker_tank

/obj/item/circuitboard/computer/atmos_control/helium_tank
	name = "氦气供应控制"
	build_path = /obj/machinery/computer/atmos_control/helium_tank

/obj/item/circuitboard/computer/atmos_control/antinoblium_tank
	name = "反锘供应控制"
	build_path = /obj/machinery/computer/atmos_control/antinoblium_tank

/obj/item/circuitboard/computer/auxiliary_base
	name = "辅助基地管理控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/auxiliary_base

/obj/item/circuitboard/computer/base_construction
	name = "通用基地建造控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/camera_advanced/base_construction

/obj/item/circuitboard/computer/base_construction/aux
	name = "辅助采矿基地建造控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/camera_advanced/base_construction/aux

/obj/item/circuitboard/computer/base_construction/centcom
	name = "中央指挥部基地建造控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/camera_advanced/base_construction/centcom

/obj/item/circuitboard/computer/comm_monitor
	name = "电信监控器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/telecomms/monitor

/obj/item/circuitboard/computer/comm_server
	name = "电信服务器监控器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/telecomms/server

/obj/item/circuitboard/computer/communications
	name = "通信控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/communications

/obj/item/circuitboard/computer/communications/syndicate
	name = "辛迪加通信控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/communications/syndicate


/obj/item/circuitboard/computer/message_monitor
	name = "信息监控器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/message_monitor

/obj/item/circuitboard/computer/modular_shield_console
	name = "模块化护盾生成器控制台"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/modular_shield

/obj/item/circuitboard/computer/powermonitor
	name = "电力监控器"  //name fixed 250810
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/monitor

/obj/item/circuitboard/computer/sat_control
	name = "卫星网络控制"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/sat_control

/obj/item/circuitboard/computer/solar_control
	name = "太阳能控制"  //name fixed 250810
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/solar_control

/obj/item/circuitboard/computer/station_alert
	name = "空间站警报"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/station_alert

/obj/item/circuitboard/computer/turbine_computer
	name = "涡轮机计算机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/turbine_computer

//Generic

/obj/item/circuitboard/computer/arcade/amputation
	name = "医疗机器人截肢大冒险"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/arcade/amputation

/obj/item/circuitboard/computer/arcade/battle
	name = "街机对战"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/arcade/battle

/obj/item/circuitboard/computer/arcade/orion_trail
	name = "猎户座征途"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/arcade/orion_trail

/obj/item/circuitboard/computer/holodeck// Not going to let people get this, but it's just here for future
	name = "全息甲板控制台"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/holodeck

/obj/item/circuitboard/computer/libraryconsole
	name = "图书馆访客终端"
	build_path = /obj/machinery/computer/libraryconsole

/obj/item/circuitboard/computer/libraryconsole/bookconsole
	name =  "图书库存管理终端"
	build_path = /obj/machinery/computer/libraryconsole/bookmanagement

/obj/item/circuitboard/computer/libraryconsole/screwdriver_act(mob/living/user, obj/item/tool)
	if(build_path == /obj/machinery/computer/libraryconsole/bookmanagement)
		name = "图书馆访客终端"
		build_path = /obj/machinery/computer/libraryconsole
		to_chat(user, span_notice("默认访问协议."))
	else
		name = "图书库存管理终端"
		build_path = /obj/machinery/computer/libraryconsole/bookmanagement
		to_chat(user, span_notice("访问协议已成功更新."))
	return TRUE

/obj/item/circuitboard/computer/monastery_shuttle
	name = "修道院穿梭机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/monastery_shuttle

/obj/item/circuitboard/computer/olddoor
	name = "DoorMex"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/computer/pod
	name = "质量驱动器控制台"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/pod

/obj/item/circuitboard/computer/slot_machine
	name = "老虎机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/slot_machine
	desc = "You can change the theme using a screwdriver."
	/// List of pickable slot machines
	var/static/list/slot_themes = list(
		"Default" = /obj/machinery/computer/slot_machine,
		"Command" = /obj/machinery/computer/slot_machine/command,
		"Security" = /obj/machinery/computer/slot_machine/security,
		"Medical" = /obj/machinery/computer/slot_machine/medical,
		"Engineering" = /obj/machinery/computer/slot_machine/engineering,
		"Cargo" = /obj/machinery/computer/slot_machine/cargo,
		"Service" = /obj/machinery/computer/slot_machine/service,
		"Science" = /obj/machinery/computer/slot_machine/science,
		"Clown" = /obj/machinery/computer/slot_machine/clown,
		"Mime" = /obj/machinery/computer/slot_machine/mime,
	)

/obj/item/circuitboard/computer/slot_machine/examine(mob/user)
	. = ..()
	var/current_theme = "Unknown"
	for(var/theme_name in slot_themes)
		if(slot_themes[theme_name] == build_path)
			current_theme = theme_name
			break
	. += span_info("[src] is set to the [current_theme] theme. You can use a screwdriver to reconfigure it.")

/obj/item/circuitboard/computer/slot_machine/screwdriver_act(mob/living/user, obj/item/tool)
	if(obj_flags & EMAGGED)
		balloon_alert(user, "board mode is broken!")
		return FALSE

	var/choice = tgui_input_list(user, "Choose a slot machine theme", "Theme Selection", slot_themes)
	if(isnull(choice))
		return ITEM_INTERACT_BLOCKING
	build_path = slot_themes[choice]
	to_chat(user, span_notice("You set the board to the [choice] theme."))
	return ITEM_INTERACT_SUCCESS

/obj/item/circuitboard/computer/slot_machine/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE

	obj_flags |= EMAGGED
	build_path = /obj/machinery/computer/slot_machine/syndicate
	balloon_alert(user, "illegal slot machine loaded")
	return TRUE

/obj/item/circuitboard/computer/swfdoor
	name = "Magix"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/circuitboard/computer/syndicate_shuttle
	name = "辛迪加穿梭机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/syndicate
	/// If operatives declared war this will be the time challenge was started
	var/challenge_start_time
	var/moved = FALSE

/obj/item/circuitboard/computer/syndicate_shuttle/Initialize(mapload)
	. = ..()
	GLOB.syndicate_shuttle_boards += src

/obj/item/circuitboard/computer/syndicate_shuttle/Destroy()
	GLOB.syndicate_shuttle_boards -= src
	return ..()

/obj/item/circuitboard/computer/syndicatedoor
	name = "ProComp Executive"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/circuitboard/computer/white_ship
	name = "白色飞船"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/white_ship

/obj/item/circuitboard/computer/white_ship/bridge
	name = "白色飞船舰桥"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/white_ship/bridge

/obj/item/circuitboard/computer/bountypad
	name = "悬赏传送台"
	build_path = /obj/machinery/computer/piratepad_control/civilian

/obj/item/circuitboard/computer/tram_controls
	name = "轨道电车控制台"
	build_path = /obj/machinery/computer/tram_controls
	var/split_mode = FALSE

/obj/item/circuitboard/computer/tram_controls/split
	split_mode = TRUE

/obj/item/circuitboard/computer/tram_controls/examine(mob/user)
	. = ..()
	. += span_info("该主板配置为[split_mode ? "split window" : "normal window"]。")
	. += span_notice("该电路板的模式可以用一个[EXAMINE_HINT("multitool")]来更改。")

/obj/item/circuitboard/computer/tram_controls/multitool_act(mob/living/user)
	split_mode = !split_mode
	to_chat(user, span_notice("[src] 定位模式已设置为[split_mode ? "split window" : "normal window"]。"))
	return TRUE

/obj/item/circuitboard/computer/terminal
	name = "终端"
	build_path = /obj/machinery/computer/terminal

//Medical

/obj/item/circuitboard/computer/crew
	name = "乘员监控控制台"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/crew

/obj/item/circuitboard/computer/med_data
	name = "医疗记录控制台"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/records/medical

/obj/item/circuitboard/computer/operating
	name = "手术计算机"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/operating

/obj/item/circuitboard/computer/pandemic
	name = "PanD.E.M.I.C. 2200"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/pandemic

/obj/item/circuitboard/computer/experimental_cloner
	name = "实验性克隆控制台"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/computer/experimental_cloner

//Science

/obj/item/circuitboard/computer/aifixer
	name = "AI完整性修复器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/aifixer

/obj/item/circuitboard/computer/launchpad_console
	name = "发射台控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/launchpad

/obj/item/circuitboard/computer/mech_bay_power_console
	name = "机甲舱电源控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/mech_bay_power_console

/obj/item/circuitboard/computer/mecha_control
	name = "外骨骼控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/computer/rdconsole
	name = "研发控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/rdconsole
	req_access = list(ACCESS_RESEARCH) // Research access is required to toggle the lock.

	var/silence_announcements = FALSE
	var/locked = TRUE

// An unlocked subtype of the board for mapping.
/obj/item/circuitboard/computer/rdconsole/unlocked
	locked = FALSE

/obj/item/circuitboard/computer/rdconsole/examine(mob/user)
	. = ..()
	. += span_info("该电路板配置为在无线电上[silence_announcements ? "silence" : "announce"]已研究节点。")
	. += span_notice("该电路板的模式可以用一个[EXAMINE_HINT("multitool")]来更改。")
	. += span_notice("该电路板当前为[locked ? "locked" : "unlocked"]状态，可以用一张拥有研究权限的ID卡来[locked ? "unlocked" : "locked"]。")

/obj/item/circuitboard/computer/rdconsole/multitool_act(mob/living/user)
	. = ..()
	if(obj_flags & EMAGGED)
		balloon_alert(user, "电路板模式已损坏！")
		return
	silence_announcements = !silence_announcements
	balloon_alert(user, "公告 [silence_announcements ? "enabled" : "disabled"]")

/obj/item/circuitboard/computer/rdconsole/emag_act(mob/user, obj/item/card/emag/emag_card)
	if (locked)
		locked = FALSE
		to_chat(user, span_notice("你通过磁力触发了锁定机制，使其解锁。"))

	if (obj_flags & EMAGGED)
		return FALSE

	obj_flags |= EMAGGED
	silence_announcements = FALSE
	to_chat(user, span_notice("你过载了节点公告芯片，强制所有节点在公共频道上公告。"))
	return TRUE

/obj/item/circuitboard/computer/rdconsole/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if (user.combat_mode || !isidcard(attacking_item))
		return ..()
	if (check_access(attacking_item))
		locked = !locked
		balloon_alert(user, locked ? "locked" : "unlocked")
		user.visible_message(
			message = span_notice("\The [user] unlock[user.p_s()] \the [src] with \the [attacking_item]."),
			self_message = span_notice("你用 \the [attacking_item] 解锁了 \the [src]。"),
			blind_message = span_hear("你听到一声轻柔的哔哔声。"),
		)
	else
		balloon_alert(user, "无访问权限！")

/obj/item/circuitboard/computer/rdservercontrol
	name = "研发服务器控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/computer/research
	name = "研究监控器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/security/research

/obj/item/circuitboard/computer/robotics
	name = "机器人控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/robotics

/obj/item/circuitboard/computer/teleporter
	name = "传送器控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/teleporter

/obj/item/circuitboard/computer/xenobiology
	name = "异种生物学控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/camera_advanced/xenobio

/obj/item/circuitboard/computer/scan_consolenew
	name = "DNA控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/dna_console

/obj/item/circuitboard/computer/mechpad
	name = "机甲轨道发射台控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/mechpad

//Security

/obj/item/circuitboard/computer/labor_shuttle
	name = "劳役穿梭机控制台"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/shuttle/labor

/obj/item/circuitboard/computer/labor_shuttle/one_way
	name = "囚犯穿梭机控制台"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/shuttle/labor/one_way

/obj/item/circuitboard/computer/gulag_teleporter_console
	name = "劳改营传送器控制台"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/prisoner/gulag_teleporter_computer

/obj/item/circuitboard/computer/prisoner
	name = "囚犯管理控制台"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/prisoner/management

/obj/item/circuitboard/computer/secure_data
	name = "安保记录控制台"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/records/security

/obj/item/circuitboard/computer/warrant
	name = "安保搜查令查看器"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/warrant

/obj/item/circuitboard/computer/security
	name = "安保摄像头"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/security

/obj/item/circuitboard/computer/advanced_camera
	name = "高级摄像头控制台"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/camera_advanced/syndie

//Service
/obj/item/circuitboard/computer/order_console
	name = "农产品订购控制台"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/order_console/cook

//Supply

/obj/item/circuitboard/computer/cargo
	name = "补给控制台"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/cargo
	var/contraband = FALSE

/obj/item/circuitboard/computer/cargo/multitool_act(mob/living/user)
	. = ..()
	if(!(obj_flags & EMAGGED))
		contraband = !contraband
		to_chat(user, span_notice("接收器频谱设置为[contraband ? "Broad" : "Standard"]。"))
	else
		to_chat(user, span_alert("频谱芯片无响应。"))

/obj/item/circuitboard/computer/cargo/emag_act(mob/user, obj/item/card/emag/emag_card)
	if (obj_flags & EMAGGED)
		return FALSE

	contraband = TRUE
	obj_flags |= EMAGGED
	to_chat(user, span_notice("你调整了[src]的路由和接收频谱，解锁了特殊补给和违禁品。"))
	return TRUE

/obj/item/circuitboard/computer/cargo/configure_machine(obj/machinery/computer/cargo/machine)
	if(!istype(machine))
		CRASH("Cargo board attempted to configure incorrect machine type: [machine] ([machine?.type])")

	machine.contraband = contraband
	if (obj_flags & EMAGGED)
		machine.obj_flags |= EMAGGED
	else
		machine.obj_flags &= ~EMAGGED

/obj/item/circuitboard/computer/cargo/express
	name = "快速补给控制台"
	build_path = /obj/machinery/computer/cargo/express

/obj/item/circuitboard/computer/cargo/express/emag_act(mob/user, obj/item/card/emag/emag_card)
	if (obj_flags & EMAGGED)
		return FALSE

	contraband = TRUE
	obj_flags |= EMAGGED
	to_chat(user, span_notice("你更改了路由协议，允许空投舱降落在空间站的任何位置。"))
	return TRUE

/obj/item/circuitboard/computer/cargo/express/multitool_act(mob/living/user)
	if (!(obj_flags & EMAGGED))
		contraband = !contraband
		to_chat(user, span_notice("接收器频谱已设置为 [contraband ? "Broad" : "Standard"]。"))
		return TRUE
	else
		to_chat(user, span_notice("你将目的地路由协议和接收频谱重置为出厂默认设置。"))
		contraband = FALSE
		obj_flags &= ~EMAGGED
		return TRUE

/obj/item/circuitboard/computer/cargo/request
	name = "补给申请控制台"
	build_path = /obj/machinery/computer/cargo/request

/obj/item/circuitboard/computer/order_console/mining
	name = "采矿自动售货控制台"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/order_console/mining

/obj/item/circuitboard/computer/order_console/mining/golem
	name = "魔像飞船设备供应商控制台"
	build_path = /obj/machinery/computer/order_console/mining/golem

/obj/item/circuitboard/computer/order_console/bitrunning
	name = "比特运行供应商控制台"
	build_path = /obj/machinery/computer/order_console/bitrunning

/obj/item/circuitboard/computer/ferry
	name = "运输渡轮"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle/ferry

/obj/item/circuitboard/computer/ferry/request
	name = "运输渡轮控制台"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle/ferry/request

/obj/item/circuitboard/computer/mining
	name = "前哨站状态显示器"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/security/mining

/obj/item/circuitboard/computer/mining_shuttle
	name = "采矿穿梭机"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle/mining

/obj/item/circuitboard/computer/mining_shuttle/common
	name = "熔岩地穿梭机"
	build_path = /obj/machinery/computer/shuttle/mining/common

/obj/item/circuitboard/computer/emergency_pod
	name = "紧急舱控制台"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/pod

/obj/item/circuitboard/computer/exoscanner_console
	name = "扫描阵列控制台"
	build_path = /obj/machinery/computer/exoscanner_control

/obj/item/circuitboard/computer/exodrone_console
	name = "勘探无人机控制台"
	build_path = /obj/machinery/computer/exodrone_control_console

/obj/item/circuitboard/computer/shuttle
	var/shuttle_id

/obj/item/circuitboard/computer/shuttle/configure_machine(obj/machinery/machine)
	var/obj/docking_port/mobile/custom/shuttle = shuttle_id ? SSshuttle.getShuttle(shuttle_id) : SSshuttle.get_containing_shuttle(machine)
	if(!shuttle)
		var/on_shuttle_frame = HAS_TRAIT((get_turf(machine)), TRAIT_SHUTTLE_CONSTRUCTION_TURF)
		machine.say(on_shuttle_frame ? "Console will automatically link on shuttle completion." : "No shuttle available for linking.")
	else if(!istype(shuttle))
		machine.say("Cannot link to this kind of shuttle!")
	else
		machine.connect_to_shuttle(TRUE, shuttle)

/obj/item/circuitboard/computer/shuttle/flight_control
	name = "穿梭机飞行控制"
	build_path = /obj/machinery/computer/shuttle/custom_shuttle

/obj/item/circuitboard/computer/shuttle/docker
	name = "穿梭机导航计算机"
	build_path = /obj/machinery/computer/camera_advanced/shuttle_docker/custom
