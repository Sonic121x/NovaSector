/// Datum holding information about pod type visuals, VFX, name and description
/// These are not created anywhere and thus should not be assigned procs, only being used as data storage
/datum/pod_style
	/// Name that pods of this style will be named by default
	var/name = "补给舱"
	/// Name that is displayed to admins in pod config panel
	var/ui_name = "Standard"
	/// Description assigned to droppods of this style
	var/desc = "一个纳米特拉森补给空投舱。"
	/// Determines if this pod can use animations/masking/overlays
	var/shape = POD_SHAPE_NORMAL
	/// Base icon state assigned to this pod
	var/icon_state = "pod"
	/// Whenever this pod should have a door overlay added to it. Uses [icon_state]_door sprite
	var/has_door = TRUE
	/// Decals added to this pod, if any
	var/decal_icon = "default"
	/// Color that this pod glows when landing
	var/glow_color = "yellow"
	/// Type of rubble that this pod creates upon landing
	var/rubble_type = RUBBLE_NORMAL
	/// ID for TGUI data
	var/id = "standard"

/datum/pod_style/advanced
	name = "蓝空补给舱"
	ui_name = "Advanced"
	desc = "一个纳米特拉森蓝空补给舱。交付后传送回中央指挥部。"
	decal_icon = "bluespace"
	glow_color = "blue"
	id = "bluespace"

/datum/pod_style/centcom
	name = "\improper 中央指挥部补给舱"
	ui_name = "Nanotrasen"
	desc = "一个纳米特拉森补给舱。这个舱体标有中央指挥部的标识。交付后传送回中央指挥部。"
	decal_icon = "centcom"
	glow_color = "blue"
	id = "centcom"

/datum/pod_style/syndicate
	name = "血红色补给舱"
	ui_name = "Syndicate"
	desc = "一个令人生畏的补给舱，覆盖着辛迪加的血红色标记。最好离这东西远点。"
	icon_state = "darkpod"
	decal_icon = "syndicate"
	glow_color = "red"
	id = "syndicate"

/datum/pod_style/deathsquad
	name = "\improper 死亡小队空投舱"
	ui_name = "Deathsquad"
	desc = "一个纳米特拉森空投舱。这个舱体标有纳米特拉森精英突击队的标记。"
	icon_state = "darkpod"
	decal_icon = "deathsquad"
	glow_color = "blue"
	id = "deathsquad"

/datum/pod_style/cultist
	name = "血腥补给舱"
	ui_name = "Cultist"
	desc = "一个布满抓痕、血迹和奇怪符文的纳米特拉森补给舱。"
	decal_icon = "cultist"
	glow_color = "red"
	id = "cultist"

/datum/pod_style/missile
	name = "巡航导弹"
	ui_name = "Missile"
	desc = "一个似乎没有完全引爆的大号导弹。它很可能是从某个遥远的深空导弹发射井发射的。侧面似乎有一个辅助有效载荷舱口，不过手动打开它可能是不可能的。"
	shape = POD_SHAPE_OTHER
	icon_state = "missile"
	has_door = FALSE
	decal_icon = null
	glow_color = null
	rubble_type = RUBBLE_THIN
	id = "missile"

/datum/pod_style/missile/syndicate
	name = "\improper 辛迪加巡航导弹"
	ui_name = "Syndie Missile"
	desc = "一枚巨大的、血红色的导弹，似乎没有完全引爆。它很可能是从某个深空辛迪加导弹发射井发射的。侧面似乎有一个辅助有效载荷舱口，但手动打开它很可能是不可能的。"
	icon_state = "smissile"
	id = "syndie_missile"

/datum/pod_style/box
	name = "\improper 奥塞克补给箱"
	ui_name = "Supply Box"
	desc = "一个极其坚固的补给箱，设计用于承受轨道再入。侧面刻有'Aussec Armory - 2532'。"
	shape = POD_SHAPE_OTHER
	icon_state = "box"
	decal_icon = null
	glow_color = null
	rubble_type = RUBBLE_WIDE
	id = "supply_box"

/datum/pod_style/clown
	name = "\improper HONK 舱"
	ui_name = "Clown Pod"
	desc = "一个颜色鲜艳的补给舱。它很可能来自小丑联邦。"
	icon_state = "clownpod"
	decal_icon = "clown"
	glow_color = "green"
	id = "clown"

/datum/pod_style/orange
	name = "\improper 橙色"
	ui_name = "Fruit"
	desc = "一个愤怒的橙子。"
	shape = POD_SHAPE_OTHER
	icon_state = "orange"
	decal_icon = null
	glow_color = null
	rubble_type = RUBBLE_WIDE
	id = "orange"

/datum/pod_style/invisible
	name =  "\improper S.T.E.A.L.T.H. 舱 MKVII"
	ui_name = "Invisible"
	desc = "一个在正常情况下，对常规探测方法完全隐形的补给舱。你到底是怎么看到这个的？"
	shape = POD_SHAPE_OTHER
	has_door = FALSE
	icon_state = null
	decal_icon = null
	glow_color = null
	rubble_type = RUBBLE_NONE
	id = "invisible"

/datum/pod_style/gondola
	name = "gondola"
	ui_name = "Gondola"
	desc = "沉默的行者。这一个似乎是某个快递机构的一部分。"
	shape = POD_SHAPE_OTHER
	icon_state = "gondola"
	has_door = FALSE
	decal_icon = null
	glow_color = null
	rubble_type = RUBBLE_NONE
	id = "gondola"

/datum/pod_style/seethrough
	name = null
	ui_name = "Seethrough"
	desc = null
	shape = POD_SHAPE_OTHER
	has_door = FALSE
	icon_state = null
	decal_icon = null
	glow_color = null
	rubble_type = RUBBLE_NONE
	id = "seethrough"
