//departmental signs

/obj/structure/sign/departments
	is_editable = TRUE

///////MEDBAY

/obj/structure/sign/departments/med
	name = "\improper 医疗区标识"
	sign_change_name = "Department - Medbay"
	desc = "标识医疗部门区域的标牌。"
	icon_state = "med"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/med, 32)

/obj/structure/sign/departments/med_alt
	name = "\improper 医疗区标识"
	sign_change_name = "Department - Medbay Alt"
	icon_state = "medbay"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/med_alt, 32)

/obj/structure/sign/departments/medbay
	name = "\improper 医疗部标志"
	sign_change_name = "Generic Medical"
	desc = "医疗机构的星际标识。你可能会在这里得到帮助。"
	icon_state = "bluecross"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/medbay, 32)

/obj/structure/sign/departments/medbay/alt
	name = "\improper 医疗区标识"
	sign_change_name = "Generic Medical Alt"
	icon_state = "bluecross2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/medbay/alt, 32)

/obj/structure/sign/departments/exam_room
	name = "\improper 诊疗室标识"
	sign_change_name = "Department - Medbay: Exam Room"
	desc = "指示标识上写着“诊疗室”。"
	icon_state = "examroom"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/exam_room, 32)

/obj/structure/sign/departments/chemistry
	name = "\improper 化学标识"
	sign_change_name = "Department - Medbay: Chemistry"
	desc = "标有“化学设备存放区域”的标识。"
	icon_state = "chemistry1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/chemistry, 32)

/obj/structure/sign/departments/chemistry/alt
	sign_change_name = "Department - Medbay: Chemistry Alt"
	icon_state = "chemistry2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/chemistry/alt, 32)

/obj/structure/sign/departments/chemistry/pharmacy
	name = "\improper 药房标识"
	sign_change_name = "Department - Medbay: Pharmacy"
	desc = "标有“药房设备存放区域”的标识。"
	icon_state = "pharmacy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/chemistry/pharmacy, 32)

/obj/structure/sign/departments/psychology
	name = "\improper 心理学标识"
	sign_change_name = "Department - Medbay: Psychology"
	desc = "标识心理学家工作区域的标牌，他们或许能帮你理清思路。"
	icon_state = "psychology"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/psychology, 32)

/obj/structure/sign/departments/virology
	name = "\improper 病毒学实验室标识"
	sign_change_name = "Department - Medbay: Virology"
	desc = "标识病毒学家实验室所在区域的标牌。"
	icon_state = "pharmacy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/virology, 32)

/obj/structure/sign/departments/morgue
	name = "\improper 停尸间标识"
	sign_change_name = "Department - Medbay: Morgue"
	desc = "标识一个区域，站内不断堆积的尸体就存放在此。"
	icon_state = "morgue"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/morgue, 32)

///////ENGINEERING

/obj/structure/sign/departments/engineering
	name = "\improper 工程标识"
	sign_change_name = "Department - Engineering"
	desc = "标有“工程师工作区域”的标识。"
	icon_state = "engine"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/engineering, 32)

/obj/structure/sign/departments/atmospherics
	name = "\improper 大气处理标识"
	sign_change_name = "Department - Engineering: Atmospherics"
	desc = "标识一个区域，你赖以生存的空气就来自这里。"
	icon_state = "atmos"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/engineering, 32)

///////SCIENCE

/obj/structure/sign/departments/science
	name = "\improper 科学标识"
	sign_change_name = "Department - Science"
	desc = "实施研究与实验的地方的标志。"
	icon_state = "science1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/science, 32)

/obj/structure/sign/departments/science/alt
	sign_change_name = "Department - Science Alt"
	icon_state = "science2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/science/alt, 32)

/obj/structure/sign/departments/xenobio
	name = "\improper 异种生物学标识"
	sign_change_name = "Department - Science: Xenobiology"
	desc = "标识一个区域，用于研究外星生物实体。"
	icon_state = "xenobio1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/xenobio, 32)

/obj/structure/sign/departments/xenobio/alt
	sign_change_name = "Department - Science: Xenobiology Alt"
	icon_state = "xenobio2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/xenobio/alt, 32)

/obj/structure/sign/departments/genetics
	name = "\improper 遗传学标识"
	sign_change_name = "Department - Science: Genetics"
	desc = "标识一个区域，用于研究遗传学领域。"
	icon_state = "gene"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/genetics, 32)

/obj/structure/sign/departments/rndserver
	name ="\improper 研发服务器标识"
	sign_change_name = "Department - Science: R&D Server"
	desc = "科研数据被存储的地方的标志。"
	icon_state = "rndserver"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/rndserver, 32)

///////SERVICE

/obj/structure/sign/departments/botany
	name = "\improper 植物学标识"
	sign_change_name = "Department - Botany (Flower)"
	desc = "标有“植物种植区”的标识。"
	icon_state = "hydro1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/botany, 32)

/obj/structure/sign/departments/botany/alt1
	sign_change_name = "Department - Botany (Tray)"
	icon_state = "hydro2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/botany/alt1, 32)

/obj/structure/sign/departments/botany/alt2
	sign_change_name = "Department - Botany (Watering Can)"
	icon_state = "hydro3"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/botany/alt2, 32)

/obj/structure/sign/departments/botany/botany/alt3
	sign_change_name = "Department - Botany (Tray) Alt"
	icon_state = "botany"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/botany/alt3, 32)

/obj/structure/sign/departments/custodian
	name = "\improper 清洁工标识"
	sign_change_name = "Department - Janitor"
	desc = "清洁工干活的地方的标志。"
	icon_state = "custodian1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/custodian, 32)

/obj/structure/sign/departments/custodian_alt
	name = "\improper 清洁工标识"
	sign_change_name = "Department - Janitor Alt"
	desc = "清洁工干活的地方的标志。"
	icon_state = "custodian2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/custodian_alt, 32)

/obj/structure/sign/departments/holy
	name = "\improper 礼拜堂标识"
	sign_change_name = "Department - Chapel"
	desc = "宗教区域的标志。"
	icon_state = "holy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/holy, 32)

/obj/structure/sign/departments/holy_alt
	name = "\improper 礼拜堂标识"
	sign_change_name = "Department - Chapel Alt"
	desc = "宗教区域的标志。"
	icon_state = "chapel"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/holy, 32)

/obj/structure/sign/departments/lawyer
	name = "\improper 法务部路标"
	sign_change_name = "Department - Legal"
	desc = "律师工作的地方的标志，旁边还写着“在此办理班车导致的扭伤事故的处理事宜”。"
	icon_state = "lawyer"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/lawyer, 32)

/obj/structure/sign/departments/restaurant
	name = "\improper 餐厅标识"
	sign_change_name = "Department - Restaurant"
	desc = "标识一个区域，食物在此供应。"
	icon_state = "restaurant"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/restaurant, 32)

/obj/structure/sign/departments/bar
	name = "\improper 酒吧标识"
	sign_change_name = "Department - Bar"
	desc = "标识饮品调制区域的标牌。"
	icon_state = "bar"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/bar, 32)

///////SUPPLY

/obj/structure/sign/departments/cargo
	name = "\improper 货舱标识"
	sign_change_name = "Department - Cargo"
	desc = "货舱运输船停靠的地方的标志。"
	icon_state = "cargo"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/cargo, 32)

/obj/structure/sign/departments/exodrone
	name = "\improper 外勤无人机标牌"
	sign_change_name = "Department - Cargo: exodrone"
	desc = "标识外勤无人机使用区域的标牌。"
	icon_state = "exodrone"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/exodrone, 32)

///////SECURITY

/obj/structure/sign/departments/security
	name = "\improper 安保标识"
	sign_change_name = "Department - Security"
	desc = "法律最被当回事的区域的标志。"
	icon_state = "security"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/security, 32)

////MISC LOCATIONS

/obj/structure/sign/departments/restroom
	name = "\improper 洗手间标识"
	sign_change_name = "Location - Restroom"
	desc = "标有“洗手间”的标识。"
	icon_state = "restroom"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/restroom, 32)

/obj/structure/sign/departments/maint
	name = "\improper 维护通道标识"
	sign_change_name = "Location - Maintenance"
	desc = "空间站几个部门连接处的区域的标志。"
	icon_state = "mait1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/maint, 32)

/obj/structure/sign/departments/maint/alt
	name = "\improper 维护隧道标牌"
	sign_change_name = "Location - Maintenance Alt"
	desc = "A sign labelling an area where the departments of the station are linked together."
	icon_state = "mait2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/maint/alt, 32)

/obj/structure/sign/departments/evac
	name = "\improper 撤离点标志"
	sign_change_name = "Location - Evacuation"
	desc = "撤离程序发生区域的标志。"
	icon_state = "evac"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/evac, 32)

/obj/structure/sign/departments/drop
	name = "\improper 空投舱标志"
	sign_change_name = "Location - Drop Pods"
	desc = "空降仓装载程序所在区域的标志。"
	icon_state = "drop"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/drop, 32)

/obj/structure/sign/departments/court
	name = "\improper 法庭标识"
	sign_change_name = "Location - Courtroom"
	desc = "法庭所在地，也就是神圣的太空法被奉行的地方的标志"
	icon_state = "court"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/court, 32)

/obj/structure/sign/departments/telecomms
	name = "\improper 电信标志"
	sign_change_name = "Location - Telecommunications"
	desc = "空间站无线电和纳米网服务器所在区域的标志。"
	icon_state = "telecomms"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/telecomms, 32)

/obj/structure/sign/departments/telecomms/alt
	icon_state = "telecomms2"
	sign_change_name = "Location - Telecommunications Alt"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/telecomms/alt, 32)

/obj/structure/sign/departments/aiupload
	name = "\improper AI上传标志"
	sign_change_name = "Location - AI Upload"
	desc = "站点AI及赛博法律上传所在区域的标志。"
	icon_state = "aiupload"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/aiupload, 32)

/obj/structure/sign/departments/aisat
	name = "\improper AI卫星标识"
	sign_change_name = "Location - AI Satellite"
	desc = "AI被重火力把守的卫星所在区域的标志。"
	icon_state = "aisat"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/aisat, 32)

/obj/structure/sign/departments/vault
	name = "\improper 金库标识"
	sign_change_name = "Location - Vault"
	desc = "空间站的一些资源与自毁装置被安全存放的地方的标志。"
	icon_state = "vault"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/departments/vault, 32)
