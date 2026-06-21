// HUDs

/datum/design/health_hud
	name = "健康扫描目镜"
	desc = "一个抬头显示器，能够扫描视野中的人类，并提供有关其健康状态的准确状况。"
	id = "health_hud"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/hud/health
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/health_hud_night
	name = "夜视健康扫描目镜"
	desc = "一个医用抬头显示器，能让医生在完全黑暗中定位病人。"
	id = "health_hud_night"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*3.5,
	)
	build_path = /obj/item/clothing/glasses/hud/health/night
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/security_hud
	name = "安保目镜"
	desc = "一种抬头显示系统，可以扫描视野中的人员，并提供有关其身份状态的准确数据。"
	id = "security_hud"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/hud/security
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/security_hud_night
	name = "夜视安保目镜"
	desc = "一种在完全黑暗中提供身份数据和视觉的头戴显示器。"
	id = "security_hud_night"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*3.5,
	)
	build_path = /obj/item/clothing/glasses/hud/security/night
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/diagnostic_hud
	name = "诊断目镜"
	desc = "一种用于分析和探知机器人零件故障的目镜。"
	id = "diagnostic_hud"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/hud/diagnostic
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/diagnostic_hud_night
	name = "夜视诊断目镜"
	desc = "升级版的诊断HUD，被设计用于在电源故障时工作。"
	id = "diagnostic_hud_night"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/clothing/glasses/hud/diagnostic/night
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Misc

/datum/design/welding_goggles
	name = "焊接目镜"
	desc = "保护眼睛不受明亮闪光的伤害;经疯狂科学家协会批准。"
	id = "welding_goggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/welding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/welding_mask
	name = "焊接防毒面具"
	desc = "一个内置焊接护目镜和面罩的防毒面具。看起来像个头骨，显然是书呆子设计的。"
	id = "weldingmask"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/mask/gas/welding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/bright_helmet
	name = "工作场所消防头盔"
	desc = "通过将尖端照明技术与符合工业标准的、采用光化学固化法的防火头盔相结合，这项安全帽将为您提供针对高强度作业危害的可靠防护。"
	id = "bright_helmet"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/clothing/head/utility/hardhat/red/upgraded
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/mauna_mug
	name = "莫纳马克杯"
	desc = "这个很棒的马克杯将确保你的咖啡永远不会冰凉！"
	id = "mauna_mug"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	build_path = /obj/item/reagent_containers/cup/maunamug
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/rolling_table
	name = "滚来滚去"
	desc = "我们给桌子底下粘了几个轮子。这他妈就是科研，对吧？"
	id = "rolling_table"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/structure/table/rolling
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/portaseeder
	name = "便携式种子提取机"
	desc = "对于有上进心的植物学家来说，它的效率比固定式的要低，每株植物只产生一颗种子"
	id = "portaseeder"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/storage/bag/plants/portaseeder
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_TOOLS_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/clown_firing_pin
	name = "滑稽击针"
	id = "clown_firing_pin"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bananium =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/firing_pin/clown
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/water_balloon
	name = "水气球"
	id = "water_balloon"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/toy/waterballoon
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/mesons
	name = "光学介子目镜"
	desc = "供工程与采矿人员使用，可无视光照条件穿透墙壁观察基本结构与地形布局。"
	id = "mesons"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/meson
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/engine_goggles
	name = "工程扫描护目镜"
	desc = "工程师使用的护目镜。其介子扫描模式可无视光照条件穿透墙壁观察基本结构与地形布局；T射线扫描模式则能探测电缆、管道等埋藏于地板下的物体。"
	id = "engine_goggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/glasses/meson/engine
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tray_goggles
	name = "光线T-射线扫描目镜"
	desc = "供工程人员使用，用于查看电缆、管道等埋藏于地板下的物体。"
	id = "tray_goggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/meson/engine/tray
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ATMOSPHERICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/atmos_thermal
	name = "大气热成像目镜"
	desc = "大气技术员用来测定空气的温度的显示器"
	id = "atmos_thermal"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/glasses/meson/engine/atmos_imaging
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ATMOSPHERICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/nvgmesons
	name = "光学介子夜视目镜"
	desc = "原型介子扫描仪配备了一个额外的传感器，可以放大可见光光谱，并将其覆盖到超高清显示器上。"
	id = "nvgmesons"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT*3.5,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/glasses/meson/night
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/night_vision_goggles
	name = "夜视镜"
	desc = "让你不受阻碍地看透黑暗的护目镜。"
	id = "night_visision_goggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT*3.5,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/glasses/night
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design/magboots
	name = "磁力靴"
	desc = "一双磁力靴，通常在飞船外活动时使用，可确保使用者安全地附着在船体上."
	id = "magboots"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT*1.25,
	)
	build_path = /obj/item/clothing/shoes/magboots
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/forcefield_projector
	name = "力场投影仪"
	desc = "一种可以投射临时力场来封锁一个区域的装置。"
	id = "forcefield_projector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/forcefield_projector
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/sci_goggles
	name = "科研护目镜"
	desc = "配有便携式分析仪的护目镜，能够评估一个项目或机器部件的研究价值。"
	id = "scigoggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/glasses/science
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/nv_sci_goggles
	name = "夜视科研目镜"
	desc = "一副能让用户在黑暗中视物并一眼识别化学化合物的护目镜。"
	id = "nv_scigoggles"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT*3.5,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/glasses/science/night
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/roastingstick
	name = "先进烘焙棒"
	desc = "一根用于在异国烤炉中烤制香肠的烤肉棒。"
	id = "roastingstick"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT*2.5,
	)
	build_path = /obj/item/melee/roastingstick
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/locator
	name = "蓝空定位器"
	desc = "用来定位便携式传送信标和带有跟踪植入物的目标."
	id = "locator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/locator
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/quantum_keycard
	name = "量子钥匙卡"
	desc = "允许构建量子钥匙卡"
	id = "quantum_keycard"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5, /datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/quantum_keycard
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/botpad_remote
	name = "机器人发射台控制器"
	desc = "允许你控制连接的机器人发射台"
	id = "botpad_remote"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/botpad_remote
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/anomaly_neutralizer
	name = "异常中和器"
	desc = "一种能够瞬时消除异常现象的先进工具，专为捕捉引擎产生的短暂畸变而设计。"
	id = "anomaly_neutralizer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/gold =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/uranium =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/anomaly_neutralizer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/donksoft_refill
	name = "杜松玩具售货机补充单元"
	desc = "一个用于唐克软玩具贩卖机的补充罐。"
	id = "donksoft_refill"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*12.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT*10,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/vending_refill/donksoft
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SERVICE

/datum/design/oxygen_tank
	name = "氧气气瓶"
	desc = "一个空的气瓶。"
	id = "oxygen_tank"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/tank/internals/oxygen/empty
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design/plasma_tank
	name = "等离子气瓶"
	desc = "一个空的气瓶。"
	id = "plasma_tank"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/tank/internals/plasma/empty
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/id
	name = "ID卡"
	desc = "一个用于提供ID信息和在空间站范围内的通行权限的卡，拥有集成式数字显示器和高级微处理器."
	id = "idcard"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/card/id/advanced
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/eng_gloves
	name = "修理工手套"
	desc = "设计精良的工程手套，内嵌自动化建造子程序，穿戴后可提升建造速度。"
	id = "eng_gloves"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/silver=HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/gloves/tinkerer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/lavarods
	name = "抗熔岩铁棒"
	id = "lava_rods"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plasma=SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium=SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/rods/lava
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/plasticducky
	name = "橡胶鸭鸭"
	desc = "纳米传讯经典的、价格具有竞争力的浴缸鸭子玩具设计。无需华夫公司的花哨橡胶，今天就购买塑料鸭子吧！"
	id = "plasticducky"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/bikehorn/rubberducky/plasticducky
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/pneumatic_seal
	name = "气动气闸密封"
	desc = "用于密封气闸的沉重支架。对于那些没有足够技巧移除它们的人来说非常有用，能有效的将其阻挡在外。"
	id = "pneumatic_seal"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*10, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*5)
	build_path = /obj/item/door_seal
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Janitor Designs

/datum/design/advmop
	name = "先进拖把"
	desc = "一个升级版的拖把，其内部拥有可储存大量水或其他清洁化学品的大容量空间。"
	id = "advmop"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/mop/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/normtrash
	name = "垃圾袋"
	desc = "这是装垃圾的袋子，你可以垃圾放进去。"
	id = "normtrash"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/storage/bag/trash
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/blutrash
	name = "蓝空垃圾袋"
	desc = "一个具有蓝空特性的垃圾袋，可以容纳大量垃圾，可惜装不了你。"
	id = "blutrash"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/storage/bag/trash/bluespace
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/light_replacer
	name = "灯泡更换器"
	desc = "一种可以自动更换灯泡的装置，可以使用完整的灯泡进行填充。"
	id = "light_replacer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/lightreplacer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/light_replacer_blue
	name = "蓝空灯泡更换器"
	desc = "一种可远程自动更换灯泡的装置。用完好的灯泡补充。"
	id = "light_replacer_blue"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/lightreplacer/blue
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/buffer_upgrade
	name = "地板缓冲升级"
	desc = "一种可安装在清洁车上的地板打磨机。"
	id = "buffer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/janicart_upgrade/buffer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_JANITOR
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/vacuum_upgrade
	name = "真空升级"
	desc = "一种可以安装在清洁车上的真空装置。"
	id = "vacuum"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/janicart_upgrade/vacuum
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_JANITOR
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/paint_remover
	name = "脱漆剂"
	desc = "清除地板上的污渍，仅此而已。"
	id = "paint_remover"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/paint/paint_remover
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/spraybottle
	name = "喷雾罐"
	desc = "一个喷雾瓶，盖子无法拧开。"
	id = "spraybottle"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/reagent_containers/spray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/beartrap
	name = "捕熊陷阱"
	desc = "用来捕捉太空熊和其他有腿生物的陷阱。"
	id = "beartrap"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/restraints/legcuffs/beartrap
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE


// Hydroponics

/datum/design/adv_watering_can
	name = "先进喷壶"
	id = "adv_watering_can"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY_ADVANCED
	)
	build_path = /obj/item/reagent_containers/cup/watering_can/advanced
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

// Holobarriers

/datum/design/holosign
	name = "全息标志投影仪"
	desc = "一种用于投射各种警告标志的全息投影仪。"
	id = "holosign"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/holobarrier_jani
	name = "清洁全息屏障投影仪"
	desc = "一种用于投射硬光湿滑地面屏障的全息投影仪。"
	id = "holobarrier_jani"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator/janibarrier
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/holosignsec
	name = "安保全息屏障投影仪"
	desc = "制造全息安全屏障的全息投影仪。"
	id = "holosignsec"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator/security
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/holosignengi
	name = "工程全息屏障投影仪"
	desc = "全息投影仪，可生成全息工程屏障。"
	id = "holosignengi"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator/engineering
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/holosignatmos
	name = "大气全息气扇投影仪"
	desc = "一种全息投影仪，可以制造全息屏障，以防止大气条件的变化。"
	id = "holosignatmos"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator/atmos
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ATMOSPHERICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/holobarrier_med
	name = "PENLITE牌全息投影仪"
	desc = "PENLITE全息屏障，一种阻止患有恶性疾病的人进入的设备。"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/holosign_creator/medical
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT) //a hint of silver since it can troll 2 antags (bad viros and sentient disease)
	id = "holobarrier_med"
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

// Armour

/datum/design/reactive_armour
	name = "反应式装甲外壳"
	desc = "一套实验性盔甲，能够利用植入的异常核心来保护使用者。"
	id = "reactive_armour"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT*4,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT*2.5,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/reactive_armor_shell
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/knight_armour
	name = "骑士盔甲"
	desc = "一位王室骑士所钟爱的服饰。可由任何友好的人进行裁剪。"
	id = "knight_armour"
	build_type = AUTOLATHE
	materials = list(/datum/material_requirement/armor_material = SHEET_MATERIAL_AMOUNT * 5)
	build_path = /obj/item/clothing/suit/armor/riot/knight/greyscale
	category = list(RND_CATEGORY_IMPORTED)

/datum/design/knight_helmet
	name = "骑士头盔"
	desc = "A royal knight's favorite hat. If you hold it upside down it's actually a bucket."
	id = "knight_helmet"
	build_type = AUTOLATHE
	materials = list(/datum/material_requirement/armor_material = SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/clothing/head/helmet/knight/greyscale
	category = list(RND_CATEGORY_IMPORTED)

// Security

/datum/design/seclite
	name = "战术手电"
	desc = "安保人员使用的强健手电筒。"
	id = "seclite"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/flashlight/seclite
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/pepperspray
	name = "胡椒喷雾"
	desc = "由UhangInc制造，用于快速致盲和击倒对手。打印的胡椒喷雾不含试剂。"
	id = "pepperspray"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/spray/pepper/empty
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/bola_energy
	name = "能量抛绳"
	desc = "一种专门设计的强光抛绳，用于捕捉逃窜的罪犯并协助抓捕行动。"
	id = "bola_energy"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/silver =SMALL_MATERIAL_AMOUNT*5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/restraints/legcuffs/bola/energy
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
	autolathe_exportable = FALSE

/datum/design/zipties
	name = "扎带"
	desc = "一次性塑料束带，可临时用于约束，使用后即被销毁。"
	id = "zipties"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/restraints/handcuffs/cable/zipties
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/evidencebag
	name = "证物袋"
	desc = "一个空的证物袋。"
	id = "evidencebag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/evidencebag
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY


/datum/design/dragnet_beacon
	name = "DRAGnet信标"
	desc = "一个可用作DRAGnet捕捉弹传送目的地的信标。记得先与你的DRAGnet同步！"
	id = "dragnet_beacon"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/dragnet_beacon
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/inspector
	name = "视察扫描仪"
	desc = "中央指挥部下发的视察仪，激活时会根据纳米传讯协议开始检查，然后打印出一份有关空间站维护的加密报告，绝不会让你得癌症"
	id = "inspector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/uranium =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/inspector
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/sec_pen
	name = "安保钢笔"
	id = "sec_pen"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/pen/red/security
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/plumbing_rcd
	name = "管道构建机"
	id = "plumbing_rcd"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*38, /datum/material/glass = SHEET_MATERIAL_AMOUNT*18, /datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/construction/plumbing
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PLUMBING
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/gas_filter
	name = "气体过滤器"
	id = "gas_filter"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/gas_filter
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS_EQUIPMENT
	)
	departmental_flags = ALL

/datum/design/plasmaman_gas_filter
	name = "等离子人气体过滤器"
	id = "plasmaman_gas_filter"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/gas_filter/plasmaman
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS_EQUIPMENT
	)
	departmental_flags = ALL

// Tape

/datum/design/super_sticky_tape
	name = "超级胶带"
	id = "super_sticky_tape"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/stack/medical/wrap/sticky_tape/super
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/pointy_tape
	name = "尖锐胶带"
	id = "pointy_tape"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/medical/wrap/sticky_tape/pointy
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/super_pointy_tape
	name = "超尖锐粘带"
	id = "super_pointy_tape"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/medical/wrap/sticky_tape/pointy/super
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

// Tackle Gloves

/datum/design/tackle_dolphin
	name = "海豚手套"
	id = "tackle_dolphin"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/clothing/gloves/tackler/dolphin
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/tackle_rocket
	name = "火箭手套"
	id = "tackle_rocket"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/gloves/tackler/rocket
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

// Restaurant Equipment

/datum/design/holosign/restaurant
	name = "餐厅座位投影仪"
	desc = "一种能够为餐厅提供座位安排方案的全息投影仪。"
	id = "holosignrestaurant"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator/robot_seat/restaurant
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/holosign/bar
	name = "酒吧座位投影仪"
	desc = "一种能够为酒吧提供座位安排方案的全息投影仪。"
	id = "holosignbar"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/holosign_creator/robot_seat/bar
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/oven_tray
	name = "烤箱托盘"
	desc = "得赶紧把东西塞进去！"
	id = "oven_tray"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/plate/oven_tray
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

// Fishing Equipment

/datum/design/fishing_rod_tech
	name = "高级鱼竿"
	desc = "一根内置发电机的鱼竿，可无限供应鱼饵。"
	id = "fishing_rod_tech"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/fishing_rod/tech
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/fishing_gloves
	name = "运动钓鱼手套"
	desc = "一副无需鱼竿即可钓鱼并锻炼体能的手套。"
	id = "fishing_gloves"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/gloves/fishing
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/stabilized_hook
	name = "陀螺稳定鱼钩"
	desc = "一种先进的鱼钩，能在收线时让使用者对鱼有更强的控制力。"
	id = "stabilized_hook"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 3, /datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/fishing_hook/stabilized
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/auto_reel
	name = "鱼线自动卷轴"
	desc = "一种先进的线轴，可用于加速钓鱼或随意将其他物品拉向你的方向。"
	id = "auto_reel"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 4, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 3, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/fishing_line/auto_reel
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespace_reel
	name = "蓝空钓鱼线"
	desc = "一种先进的线轴，可用于触及普通鱼线无法到达的遥远钓点以及其他事物。"
	id = "bluespace_reel"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 4, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/fishing_line/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/fish_analyzer
	name = "鱼类分析仪"
	desc = "一种用于监测鱼类状态和特性的分析仪。"
	id = "fish_analyzer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/fish_analyzer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespace_fish_case
	name = "蓝空鱼箱"
	desc = "一个改进的鱼箱，可在紧凑的小空间内保持大型鱼类的停滞状态。"
	id = "bluespace_fish_case"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/plastic = SMALL_MATERIAL_AMOUNT, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/storage/fish_case/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespace_fish_tank
	name = "蓝空鱼缸套件"
	desc = "升级鱼缸容量所需的组件。"
	id = "bluespace_fish_tank_kit"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/titanium = SMALL_MATERIAL_AMOUNT, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/aquarium_upgrade/bluespace_tank
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/fish_genegun
	name = "鱼类基因枪"
	desc = "一种设计用于向鱼类注射或提取特性的设备。也兼容大多数水生或类似生物。"
	id = "fish_genegun"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 4, /datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/fish_genegun
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

// Coffeemaker Stuff

/datum/design/coffeepot
	name = "咖啡壶"
	id = "coffeepot"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/plastic =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/reagent_containers/cup/coffeepot
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/coffeepot_bluespace
	name = "蓝空咖啡壶"
	id = "bluespace_coffeepot"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic =SMALL_MATERIAL_AMOUNT*5, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/reagent_containers/cup/coffeepot/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/coffee_cartridge
	name = "空的咖啡机胶囊"
	id = "coffee_cartridge"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/blank_coffee_cartridge
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/syrup_bottle
	name = "糖浆瓶"
	id = "syrup_bottle"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/cup/bottle/syrup_bottle
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/radio_navigation_beacon
	name = "紧凑型无线电导航千兆信标"
	id = "gigabeacon"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/folded_navigation_gigabeacon
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design/shuttle_rods
	name = "穿梭机框架杆"
	id = "shuttlerods"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/rods/shuttle
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

// Experimental designs

/datum/design/polymorph_belt
	name = "多态场逆变器"
	id = "polymorph_belt"
	desc = "该设备能够扫描并存储其他生命形式的DNA，并利用其来转变穿戴者。它需要一个生物扰频器异常核心才能运作。"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/polymorph_belt
	materials = list(
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/perceptomatrix
	name = "感知矩阵头盔"
	id = "perceptomatrix"
	desc = "这个头盔利用幻觉能量来保护其所有者免受感知异常的影响。它需要一个幻觉异常核心才能运作。"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/clothing/head/helmet/perceptomatrix
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 0.5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Anomaly locked item

/datum/design/space_furnace
	name = "太空熔炉"
	desc = "一个重型熔炉，能够形成一个临时气泡来容纳可呼吸的空气。需要火成碎屑异常核心才能运作。"
	id = "space_furnace"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT*2.5,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/flashlight/lamp/space_bubble
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
