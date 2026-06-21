/datum/design/integrated_circuit
	name = "集成电路"
	desc = "所有电路的基础。所有的电路都以此为基础展开。"
	id = "integrated_circuit"
	build_path = /obj/item/integrated_circuit
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_CATEGORY_CIRCUITRY_CORE
	)
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/circuit_multitool
	name = "电路多功能工具"
	desc = "一个用于标记实体并将其加载进系统的电路多功能工具。"
	id = "circuit_multitool"
	build_path = /obj/item/multitool/circuit
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_CATEGORY_CIRCUITRY_CORE
	)
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/usb_cable
	name = "USB 接口线"
	desc = "一种电缆，能够使某些设备与附近的计算机和机器实现连接。"
	id = "usb_cable"
	build_path = /obj/item/usb_cable
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_CATEGORY_CIRCUITRY_CORE
	)
	// Yes, it would make sense to make them take plastic, but then less people would make them, and I think they're cool
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT*2.5)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/component
	name = "组件（空项）"
	desc = "一种用于集成电路的组件。"
	build_type = COMPONENT_PRINTER
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_COMPONENTS
	)

/datum/design/component/New()
	. = ..()
	if(build_path)
		var/obj/item/circuit_component/component_path = build_path
		desc = initial(component_path.desc)

/datum/design/component/arithmetic
	name = "算术组件"
	id = "comp_arithmetic"
	build_path = /obj/item/circuit_component/arithmetic

/datum/design/component/trigonometry
	name = "三角函数组件"
	id = "comp_trigonometry"
	build_path = /obj/item/circuit_component/trigonometry

/datum/design/component/arctan2
	name = "双参数反正切组件"
	id = "comp_arctan2"
	build_path = /obj/item/circuit_component/arctan2

/datum/design/component/clock
	name = "时钟组件"
	id = "comp_clock"
	build_path = /obj/item/circuit_component/clock

/datum/design/component/comparison
	name = "比较组件"
	id = "comp_comparison"
	build_path = /obj/item/circuit_component/compare/comparison

/datum/design/component/logic
	name = "逻辑组件"
	id = "comp_logic"
	build_path = /obj/item/circuit_component/compare/logic

/datum/design/component/toggle
	name = "切换组件"
	id = "comp_toggle"
	build_path = /obj/item/circuit_component/compare/toggle

/datum/design/component/delay
	name = "延迟组件"
	id = "comp_delay"
	build_path = /obj/item/circuit_component/delay

/datum/design/component/format
	name = "格式列表组件"
	id = "comp_format"
	build_path = /obj/item/circuit_component/format

/datum/design/component/format_assoc
	name = "格式关联列表组件"
	id = "comp_format_assoc"
	build_path = /obj/item/circuit_component/format/assoc

/datum/design/component/index
	name = "索引访问组件"
	id = "comp_index"
	build_path = /obj/item/circuit_component/index

/datum/design/component/index_assoc
	name = "索引关联组件"
	id = "comp_index_assoc"
	build_path = /obj/item/circuit_component/index/assoc_string

/datum/design/component/length
	name = "长度组件"
	id = "comp_length"
	build_path = /obj/item/circuit_component/length

/datum/design/component/light
	name = "灯光组件"
	id = "comp_light"
	build_path = /obj/item/circuit_component/light

/datum/design/component/not
	name = "非组件"
	id = "comp_not"
	build_path = /obj/item/circuit_component/not

/datum/design/component/random
	name = "随机组件"
	id = "comp_random"
	build_path = /obj/item/circuit_component/random

/datum/design/component/binary_conversion
	name = "二进制转换组件"
	id = "comp_binary_convert"
	build_path = /obj/item/circuit_component/binary_conversion

/datum/design/component/decimal_conversion
	name = "十进制转换组件"
	id = "comp_decimal_convert"
	build_path = /obj/item/circuit_component/decimal_conversion

/datum/design/component/species
	name = "获取物种组件"
	id = "comp_species"
	build_path = /obj/item/circuit_component/species

/datum/design/component/speech
	name = "语音组件"
	id = "comp_speech"
	build_path = /obj/item/circuit_component/speech

/datum/design/component/laserpointer
	name = "激光指示器组件"
	id = "comp_laserpointer"
	build_path = /obj/item/circuit_component/laserpointer

/datum/design/component/timepiece
	name = "计时器组件"
	id = "comp_timepiece"
	build_path = /obj/item/circuit_component/timepiece

/datum/design/component/tostring
	name = "记入字符串组件"
	id = "comp_tostring"
	build_path = /obj/item/circuit_component/tostring

/datum/design/component/tonumber
	name = "记入编号"
	id = "comp_tonumber"
	build_path = /obj/item/circuit_component/tonumber

/datum/design/component/typecheck
	name = "类型检查组件"
	id = "comp_typecheck"
	build_path = /obj/item/circuit_component/compare/typecheck

/datum/design/component/concat
	name = "连接组件"
	id = "comp_concat"
	build_path = /obj/item/circuit_component/concat

/datum/design/component/textcase
	name = "文本框组件"
	id = "comp_textcase"
	build_path = /obj/item/circuit_component/textcase

/datum/design/component/hear
	name = "语音激活组件"
	id = "comp_hear"
	build_path = /obj/item/circuit_component/hear

/datum/design/component/contains
	name = "字符串包含组件"
	id = "comp_string_contains"
	build_path = /obj/item/circuit_component/compare/contains

/datum/design/component/self
	name = "自我组件"
	id = "comp_self"
	build_path = /obj/item/circuit_component/self

/datum/design/component/radio
	name = "无线电组件"
	id = "comp_radio"
	build_path = /obj/item/circuit_component/radio

/datum/design/component/gps
	name = "GPS组件"
	id = "comp_gps"
	build_path = /obj/item/circuit_component/gps

/datum/design/component/direction
	name = "方向组件"
	id = "comp_direction"
	build_path = /obj/item/circuit_component/direction

/datum/design/component/reagentscanner
	name = "试剂扫描仪"
	id = "comp_reagents"
	build_path = /obj/item/circuit_component/reagentscanner

/datum/design/component/health
	name = "健康组件"
	id = "comp_health"
	build_path = /obj/item/circuit_component/health

/datum/design/component/compare/health_state
	name = "生命状态比较组件"
	id = "comp_health_state"
	build_path = /obj/item/circuit_component/compare/health_state

/datum/design/component/matscanner
	name = "材料扫描仪"
	id = "comp_matscanner"
	build_path = /obj/item/circuit_component/matscanner

/datum/design/component/split
	name = "拆分组件"
	id = "comp_split"
	build_path = /obj/item/circuit_component/split

/datum/design/component/pull
	name = "拉取组件"
	id = "comp_pull"
	build_path = /obj/item/circuit_component/pull

/datum/design/component/soundemitter
	name = "声源组件"
	id = "comp_soundemitter"
	build_path = /obj/item/circuit_component/soundemitter

/datum/design/component/mmi
	name = "人机接口组件"
	id = "comp_mmi"
	build_path = /obj/item/circuit_component/mmi

/datum/design/component/router
	name = "路由器组件"
	id = "comp_router"
	build_path = /obj/item/circuit_component/router

/datum/design/component/multiplexer
	name = "多路复用器组件"
	id = "comp_multiplexer"
	build_path = /obj/item/circuit_component/router/multiplexer

/datum/design/component/get_column
	name = "获取列组件"
	id = "comp_get_column"
	build_path = /obj/item/circuit_component/get_column

/datum/design/component/index_table
	name = "索引表组件"
	id = "comp_index_table"
	build_path = /obj/item/circuit_component/index_table

/datum/design/component/concat_list
	name = "连接列表组件"
	id = "comp_concat_list"
	build_path = /obj/item/circuit_component/concat_list

/datum/design/component/list_add
	name = "列表添加"
	id = "comp_list_add"
	build_path = /obj/item/circuit_component/variable/list/listadd

/datum/design/component/list_remove
	name = "列表删除"
	id = "comp_list_remove"
	build_path = /obj/item/circuit_component/variable/list/listremove

/datum/design/component/assoc_list_set
	name = "关联列表设置"
	id = "comp_assoc_list_set"
	build_path = /obj/item/circuit_component/variable/assoc_list/list_set

/datum/design/component/assoc_list_remove
	name = "关联列表移除"
	id = "comp_assoc_list_remove"
	build_path = /obj/item/circuit_component/variable/assoc_list/list_remove


/datum/design/component/list_clear
	name = "清空列表"
	id = "comp_list_clear"
	build_path = /obj/item/circuit_component/variable/list/listclear

/datum/design/component/element_find
	name = "元素查找"
	id = "comp_element_find"
	build_path = /obj/item/circuit_component/listin

/datum/design/component/select_query
	name = "选择查询组件"
	id = "comp_select_query"
	build_path = /obj/item/circuit_component/select

/datum/design/component/pathfind
	name = "探路者"
	id = "comp_pathfind"
	build_path = /obj/item/circuit_component/pathfind

/datum/design/component/tempsensor
	name = "温度传感器组件"
	id = "comp_tempsensor"
	build_path = /obj/item/circuit_component/tempsensor

/datum/design/component/pressuresensor
	name = "压力传感器组件"
	id = "comp_pressuresensor"
	build_path = /obj/item/circuit_component/pressuresensor

/datum/design/component/module
	name = "模块组件"
	id = "comp_module"
	build_path = /obj/item/circuit_component/module

/datum/design/component/ntnet_receive
	name = "NTNet 接收器"
	id = "comp_ntnet_receive"
	build_path = /obj/item/circuit_component/ntnet_receive

/datum/design/component/ntnet_send
	name = "NTNet 发射器"
	id = "comp_ntnet_send"
	build_path = /obj/item/circuit_component/ntnet_send

/datum/design/component/nfc_send
	name = "NFC发射器"
	id = "comp_nfc_send"
	build_path = /obj/item/circuit_component/nfc_send

/datum/design/component/nfc_receive
	name = "NFC接收器"
	id = "comp_nfc_receive"
	build_path = /obj/item/circuit_component/nfc_receive

/datum/design/component/list_literal/ntnet_send
	name = "纳米传讯网络发射器列表字面量"
	id = "comp_ntnet_send_list_literal"
	build_path = /obj/item/circuit_component/list_literal/ntnet_send

/datum/design/component/list_literal
	name = "列表字面量组件"
	id = "comp_list_literal"
	build_path = /obj/item/circuit_component/list_literal

/datum/design/component/list_assoc_literal
	name = "关联列表字面值"
	id = "comp_list_assoc_literal"
	build_path = /obj/item/circuit_component/assoc_literal

/datum/design/component/typecast
	name = "类型化组件"
	id = "comp_typecast"
	build_path = /obj/item/circuit_component/typecast

/datum/design/component/pinpointer
	name = "近距追踪器组件"
	id = "comp_pinpointer"
	build_path = /obj/item/circuit_component/pinpointer

/datum/design/component/equipment_action
	name = "装备动作组件"
	id = "comp_equip_action"
	build_path = /obj/item/circuit_component/equipment_action

/datum/design/component/bci/object_overlay
	name = "对象覆盖组件"
	id = "comp_object_overlay"
	build_path = /obj/item/circuit_component/object_overlay

/datum/design/component/bci/bar_overlay
	name = "条形图叠加组件"
	id = "comp_bar_overlay"
	build_path = /obj/item/circuit_component/object_overlay/bar

/datum/design/component/bci/vox
	name = "VOX 公告组件"
	id = "comp_vox"
	build_path = /obj/item/circuit_component/vox

/datum/design/component/bci/thought_listener
	name = "思想倾听者组件"
	id = "comp_thought_listener"
	build_path = /obj/item/circuit_component/thought_listener

/datum/design/component/bci/target_intercept
	name = "BCI 目标拦截器"
	id = "comp_target_intercept"
	build_path = /obj/item/circuit_component/target_intercept

/datum/design/component/bci/counter_overlay
	name = "计数器覆盖组件"
	id = "comp_counter_overlay"
	build_path = /obj/item/circuit_component/counter_overlay

/datum/design/component/bci/reagent_injector
	name = "试剂注射器组件"
	id = "comp_reagent_injector"
	build_path = /obj/item/circuit_component/reagent_injector

/datum/design/component/bci/install_detector
	name = "安装检测器组件"
	id = "comp_install_detector"
	build_path = /obj/item/circuit_component/install_detector

/datum/design/component/foreach
	name = "全量组件"
	id = "comp_foreach"
	build_path = /obj/item/circuit_component/foreach

/datum/design/component/filter_list
	name = "过滤列表组件"
	id = "comp_filter_list"
	build_path = /obj/item/circuit_component/filter_list

/datum/design/component/id_getter
	name = "ID 获取器组件"
	id = "comp_id_getter"
	build_path = /obj/item/circuit_component/id_getter

/datum/design/component/id_info_reader
	name = "身份信息读取组件"
	id = "comp_id_info_reader"
	build_path = /obj/item/circuit_component/id_info_reader

/datum/design/component/id_access_reader
	name = "身份访问读取器组件"
	id = "comp_id_access_reader"
	build_path = /obj/item/circuit_component/id_access_reader

/datum/design/component/setter_trigger
	name = "设置变量触发器"
	id = "comp_set_variable_trigger"
	build_path = /obj/item/circuit_component/variable/setter/trigger

/datum/design/component/view_sensor
	name = "查看传感器组件"
	id = "comp_view_sensor"
	build_path = /obj/item/circuit_component/view_sensor

/datum/design/component/access_checker
	name = "访问检查器组件"
	id = "comp_access_checker"
	build_path = /obj/item/circuit_component/compare/access

/datum/design/component/list_pick
	name = "列表选取组件"
	id = "comp_list_pick"
	build_path = /obj/item/circuit_component/list_pick

/datum/design/component/list_pick_assoc
	name = "关联列表选取组件"
	id = "comp_assoc_list_pick"
	build_path = /obj/item/circuit_component/list_pick/assoc

/datum/design/component/wire_bundle
	name = "线缆束"
	id = "comp_wire_bundle"
	build_path = /obj/item/circuit_component/wire_bundle

/datum/design/component/wirenet_receive
	name = "线网接收器组件"
	id = "comp_wirenet_receive"
	build_path = /obj/item/circuit_component/wirenet_receive

/datum/design/component/wirenet_send
	name = "线网发射器组件"
	id = "comp_wirenet_send"
	build_path = /obj/item/circuit_component/wirenet_send

/datum/design/component/wirenet_send_literal
	name = "线网列表字面量发射器组件"
	id = "comp_wirenet_send_literal"
	build_path = /obj/item/circuit_component/list_literal/wirenet_send

/datum/design/component/bci/bci_camera
	name = "脑机接口摄像头"
	id = "comp_camera_bci"
	build_path = /obj/item/circuit_component/remotecam/bci

/datum/design/compact_remote_shell
	name = "紧凑型远程终端"
	desc = "一个带有一个大按钮的手持式装置。"
	id = "compact_remote_shell"
	build_path = /obj/item/compact_remote
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/controller_shell
	name = "控制器壳"
	desc = "一个带有多个按钮的手持式外壳。"
	id = "controller_shell"
	build_path = /obj/item/controller
	build_type = COMPONENT_PRINTER
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT*3.5)
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/scanner_shell
	name = "扫描器壳"
	desc = "一种手持式的扫描器外壳，能够对物体进行扫描。"
	id = "scanner_shell"
	build_path = /obj/item/wiremod_scanner
	build_type = COMPONENT_PRINTER
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT*3.5)
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/keyboard_shell
	name = "键盘壳"
	desc = "一款手持式的外壳，能让用户输入字符串"
	id = "keyboard_shell"
	build_path = /obj/item/keyboard_shell
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT*5)
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/gun_shell
	name = "枪壳"
	desc = "一种手持式弹药发射器，能够发射弹丸以击中目标对象。"
	id = "gun_shell"
	build_path = /obj/item/gun/energy/wiremod_gun
	build_type = COMPONENT_PRINTER
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/bot_shell
	name = "机器人壳"
	desc = "一个静止不动的外壳，能够容纳更多的组件。它配有 USB 接口，以便能够与电脑和机器连接。"
	id = "bot_shell"
	build_path = /obj/item/shell/bot
	build_type = COMPONENT_PRINTER
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT*5)
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/money_bot_shell
	name = "货币机器人壳"
	desc = "一种静止不动的外壳程序，与常规的机器人外壳程序类似，但它能够接受货币输入，并且还能进行货币发放操作。"
	id = "money_bot_shell"
	build_path = /obj/item/shell/money_bot
	build_type = COMPONENT_PRINTER
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/gold =SMALL_MATERIAL_AMOUNT*0.5)
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/drone_shell
	name = "无人机壳"
	desc = "一种能够自行移动的外壳。"
	id = "drone_shell"
	build_path = /obj/item/shell/drone
	build_type = COMPONENT_PRINTER
	materials = list(
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5.5,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/server_shell
	name = "服务器壳"
	desc = "一个非常大的容器，无法随意移动。能容纳最多的组件。"
	id = "server_shell"
	materials = list(
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/shell/server
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/airlock_shell
	name = "气闸壳"
	desc = "一种在组装完成后无法移动的门框结构。"
	id = "door_shell"
	materials = list(
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
	)
	build_path = /obj/item/shell/airlock
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/dispenser_shell
	name = "分配机壳"
	desc = "一种能够分发物品的分配器壳。"
	id = "dispenser_shell"
	materials = list(
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
	)
	build_path = /obj/item/shell/dispenser
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/bci_shell
	name = "脑机接口壳"
	desc = "一种可以植入使用者头部、通过其大脑来控制电路的装置。"
	id = "bci_shell"
	materials = list(
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*4,
	)
	build_path = /obj/item/shell/bci
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/scanner_gate_shell
	name = "扫描器门壳"
	desc = "一种扫描门壳，当人们通过时，它会对人体进行中深度扫描。"
	id = "scanner_gate_shell"
	materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*6,
	)
	build_path = /obj/item/shell/scanner_gate
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/board/bci_implanter
	name = "脑机接口操作室"
	desc = "一种机器，如果配备有脑机接口，就会将该装置植入使用者体内。否则，它会移除使用者身上已有的任何脑机接口设备。"
	id = "bci_implanter"
	build_path = /obj/item/circuitboard/machine/bci_implanter
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_CATEGORY_CIRCUITRY_CORE
	)

/datum/design/assembly_shell
	name = "装配壳"
	desc = "一种可附着于电线及其他组件上的组装壳。"
	id = "assembly_shell"
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/assembly/wiremod
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/mod_module_shell
	name = "MOD模块壳"
	desc = "一种模块壳，能够将电路插入其中，并与模块服进行连接。"
	id = "module_shell"
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/mod/module/circuit
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/undertile_shell
	name = "地板下外壳"
	desc = "一种可以安装在地板下的小型外壳。"
	id = "undertile_shell"
	materials = list(
		/datum/material/glass=HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*2.5,
	)
	build_path = /obj/item/undertile_circuit
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)


/datum/design/wallmount_shell
	name = "壁挂式外壳"
	desc = "一种可以安装在墙上的大型外壳。"
	id = "wallmount_shell"
	materials = list(
		/datum/material/glass=SHEET_MATERIAL_AMOUNT,
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/wallframe/circuit
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)

/datum/design/implant_shell
	name = "Implant Shell Case"
	desc = "A tiny shell that can be implanted in a living being."
	id = "implant_shell"
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 5,
	)
	build_path = /obj/item/implantcase/circuit
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
