//map and direction signs

/obj/structure/sign/map
	name = "空间站地图"
	desc = "一份空间站的导航图。"
	max_integrity = 500

/obj/structure/sign/map/left
	icon_state = "map-left"
	desc = "A navigational chart of the decommissioned Spinward Sector Station SS-02: 'Box' Class Outpost."

/obj/structure/sign/map/right
	icon_state = "map-right"
	desc = "A navigational chart of the decommissioned Spinward Sector Station SS-02: 'Box' Class Outpost."

/obj/structure/sign/map/meta
	desc = "A framed picture of the station. Clockwise from security at the top (red), you see engineering (yellow), science (purple), \
			escape (red and white), medbay (green), arrivals (blue and white), and finally cargo (brown)."

/obj/structure/sign/map/meta/left
	icon_state = "map-left-MS"

/obj/structure/sign/map/meta/right
	icon_state = "map-right-MS"

/obj/structure/sign/map/pubby
	icon_state = "map-pubby"

/obj/structure/sign/directions/science
	name = "科研部路标"
	desc = "指明科研部方向的指示牌。"
	icon_state = "direction_sci"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/science, 32)

/obj/structure/sign/directions/engineering
	name = "工程部路标"
	desc = "指明工程部方向的指示牌。"
	icon_state = "direction_eng"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/engineering, 32)

/obj/structure/sign/directions/security
	name = "安保部路标"
	desc = "指明安保部方向的指示牌。"
	icon_state = "direction_sec"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/security, 32)

/obj/structure/sign/directions/medical
	name = "医疗部标识"
	desc = "指明医疗部方向的指示牌。"
	icon_state = "direction_med"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/medical, 32)

/obj/structure/sign/directions/evac
	name = "撤离点标识"
	desc = "指明撤离点方向的指示牌。"
	icon_state = "direction_evac"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/evac, 32)

/obj/structure/sign/directions/supply
	name = "货舱路标"
	desc = "指明货舱方向的指示牌。"
	icon_state = "direction_supply"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/supply, 32)

/obj/structure/sign/directions/command
	name = "指挥部路标"
	desc = "指明指挥部方向的指示牌。"
	icon_state = "direction_bridge"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/command, 32)

/obj/structure/sign/directions/vault
	name = "金库路标"
	desc = "指明空间站金库方向的指示牌。"
	icon_state = "direction_vault"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/vault, 32)

/obj/structure/sign/directions/upload
	name = "上传标识"
	desc = "指明AI上传方向的指示牌。"
	icon_state = "direction_upload"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/upload, 32)

/obj/structure/sign/directions/dorms
	name = "宿舍路标"
	desc = "指明宿舍方向的指示牌。"
	icon_state = "direction_dorms"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/dorms, 32)

/obj/structure/sign/directions/lavaland
	name = "岩浆标识"
	desc = "指明滚烫岩浆所在位置的指示牌。"
	icon_state = "direction_lavaland"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/lavaland, 32)

/obj/structure/sign/directions/arrival
	name = "撤离点标志"
	desc = "指明接送站方向的指示牌。"
	icon_state = "direction_arrival"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/directions/arrival, 32)
