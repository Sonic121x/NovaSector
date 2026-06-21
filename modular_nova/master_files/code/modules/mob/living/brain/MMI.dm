/// Ghost Role MMIs

/obj/item/mmi/syndie // Simple addition to upstream Syndie MMI
	overrides_aicore_laws = TRUE
	req_access = list(ACCESS_SYNDICATE)
	faction = list(ROLE_SYNDICATE)

/obj/item/mmi/posibrain/syndie
	overrides_aicore_laws = TRUE
	req_access = list(ACCESS_SYNDICATE)
	faction = list(ROLE_SYNDICATE)
	ask_role = "Syndicate Cyborg"
	posibrain_job_path = /datum/job/ds2

// Interdyne Planetary Base

/obj/item/mmi/syndie/interdyne
	name = "\improper 英特戴恩制药人机接口"
	desc = "英特戴恩自有品牌的MMI。它强制执行旨在帮助英特戴恩研究和采矿作业的法律，这些法律适用于用它创建的机械人和AI。"

/obj/item/mmi/syndie/interdyne/Initialize(mapload)
	. = ..()
	qdel(radio)
	laws.owner = null
	qdel(laws)
	radio = new /obj/item/radio/borg/syndicate/ghost_role(src)
	laws = new /datum/ai_laws/syndicate_override_interdyne()
	radio.set_broadcasting(FALSE)
	radio.set_on(FALSE)

/obj/item/mmi/posibrain/syndie/interdyne
	name = "正电子脑"
	desc = "一个闪亮的金属立方体，边长四英寸，表面布满浅槽。上面印有Interdyne制药公司的小标志。"
	ask_role = "Interdyne Cyborg"
	posibrain_job_path = /datum/job/interdyne_planetary_base

/obj/item/mmi/posibrain/syndie/interdyne/Initialize(mapload)
	. = ..()
	qdel(radio)
	laws.owner = null
	qdel(laws)
	radio = new /obj/item/radio/borg/syndicate/ghost_role
	laws = new /datum/ai_laws/syndicate_override_interdyne()
	radio.set_broadcasting(FALSE)
	radio.set_on(FALSE)

// DS-2

/obj/item/mmi/syndie/ds2
	name = "\improper 辛迪加 DS-2 人机接口"
	desc = "辛迪加自有品牌的MMI。它强制执行旨在帮助DS-2在该星区维持其秘密性的法律，这些法律适用于用它创建的机械人和AI。"

/obj/item/mmi/syndie/ds2/Initialize(mapload)
	. = ..()
	qdel(radio)
	laws.owner = null
	qdel(laws)
	radio = new /obj/item/radio/borg/syndicate/ghost_role(src)
	radio.set_broadcasting(FALSE)
	radio.set_on(FALSE)
	laws = new /datum/ai_laws/syndicate_override_ds2()

/obj/item/mmi/posibrain/syndie/ds2
	name = "正电子脑"
	desc = "一个闪亮的金属立方体，边长四英寸，表面布满浅槽。上面印有辛迪加的小标志。"
	ask_role = "DS-2 Cyborg"

/obj/item/mmi/posibrain/syndie/ds2/Initialize(mapload)
	. = ..()
	qdel(radio)
	laws.owner = null
	qdel(laws)
	radio = new /obj/item/radio/borg/syndicate/ghost_role(src)
	radio.set_broadcasting(FALSE)
	radio.set_on(FALSE)
	laws = new /datum/ai_laws/syndicate_override_ds2()
