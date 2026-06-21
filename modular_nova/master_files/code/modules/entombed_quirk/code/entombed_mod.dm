/datum/mod_theme/entombed
	name = "融合"
	desc = "环境已将这身防护服变成了某人的第二层皮肤。字面意义上的。"
	extended_desc = "Some great aspect of someone's past has permanently bound them to this device, for better or worse."

	default_skin = "standard"
	armor_type = /datum/armor/mod_entombed
	resistance_flags = FIRE_PROOF | ACID_PROOF // It is better to die for the Emperor than live for yourself.
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	complexity_max = DEFAULT_MAX_COMPLEXITY - 5
	charge_drain = DEFAULT_CHARGE_DRAIN / 2
	slowdown_deployed = 0.95
	inbuilt_modules = list(
		/obj/item/mod/module/joint_torsion/entombed,
		/obj/item/mod/module/storage/large_capacity,
	)
	allowed_suit_storage = list(
		/obj/item/tank/internals,
		/obj/item/flashlight,
	)

/datum/armor/mod_entombed
	melee = ARMOR_LEVEL_WEAK
	bullet = ARMOR_LEVEL_WEAK
	laser = ARMOR_LEVEL_WEAK
	energy = ARMOR_LEVEL_WEAK
	bomb = ARMOR_LEVEL_WEAK
	bio = ARMOR_LEVEL_WEAK
	fire = ARMOR_LEVEL_WEAK
	acid = ARMOR_LEVEL_WEAK
	wound = WOUND_ARMOR_WEAK

/obj/item/mod/module/joint_torsion/entombed
	name = "内部关节扭转适应"
	desc = "你对这套MOD防护服内生活的适应，使你能够以某种方式行走，从而略微为防护服的内置电池充电，但这仅在重力环境下有效。"
	removable = FALSE
	complexity = 0
	power_per_step = DEFAULT_CHARGE_DRAIN * 0.6

/obj/item/mod/module/plasma_stabilizer/entombed
	name = "菌落稳定化内部密封"
	desc = "你的菌落已完全将防护服甲板的内层部分整合进你的骨骼，在你与外部世界之间形成了一个密封层，使你的大气无法逸出。这足以让你的头部在头盔缩回时观察世界。"
	complexity = 0
	idle_power_cost = 0
	removable = FALSE

// ENTOMBED MOD CLOTHING COMPONENT

/datum/component/entombed_mod_piece
	// This component handles returning errant MODsuit pieces back to their control module in the event of shenanigans. Entombed pieces should *never* be outside the unit.
	/// Ref to the source MODsuit we came from.
	var/datum/weakref/host

/datum/component/entombed_mod_piece/Initialize(host_suit)
	. = ..()
	if (!isnull(host_suit))
		host = WEAKREF(host_suit)
	else
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(piece_dropped))

/datum/component/entombed_mod_piece/proc/piece_dropped(datum/source)
	SIGNAL_HANDLER
	// The piece of MOD clothing has been dropped, somehow. Find our source suit and send it back, or delete us if the host suit does not exist.
	var/obj/item/mod/control/host_suit = host.resolve()
	if (!host_suit)
		//if we have no host suit, we shouldn't exist, so delete
		host = null
		if(!QDELETED(parent))
			qdel(parent)
		return

	var/obj/item/clothing/piece = parent
	if (!isnull(piece))
		piece.doMove(host_suit)

/obj/item/mod/module/anomaly_locked/antigrav/entombed
	name = "辅助反重力行走器"
	desc = "这是纳米传讯科研部门根据《太空残障法案》强制加装的增补装置，该增强功能允许你的防护服投射一个有限的反重力场，以协助你在空间站内进行日常和紧急情况下的移动。它由一小片引力异常核心碎片供能，该碎片与维持你生命的供能系统密不可分。警告：未针对电磁脉冲防护进行评级。"
	complexity = 1
	allow_flags = MODULE_ALLOW_INACTIVE // the suit is never off, so this just allows this to be used w/o being parts-deployed for cosmetic reasons
	removable = FALSE
	active_power_cost = 0 // torsion does not generate power in antigrav, so this is effectively -0.4 * DEFAULT_CHARGE_DRAIN
	prebuilt = TRUE
	core_removable = FALSE

// MOD CONTROL UNIT

/obj/item/mod/control/pre_equipped/entombed
	theme = /datum/mod_theme/entombed
	applied_cell = /obj/item/stock_parts/power_store/cell/high

// CUSTOM BEHAVIOR

/obj/item/mod/control/pre_equipped/entombed/canStrip(mob/who)
	return TRUE //you can always try, and it'll hit doStrip below

/obj/item/mod/control/pre_equipped/entombed/doStrip(mob/who)
	// attempt to handle custom stripping behavior - if we have a storage module of some kind
	var/obj/item/mod/module/storage/inventory = locate() in src.modules
	if (!isnull(inventory))
		src.atom_storage.remove_all()
		to_chat(who, span_notice("你清空了MOD防护服存储模块中的所有物品！"))
		who.balloon_alert(who, "清空了MOD存储物品！")
		return TRUE

	to_chat(who, span_warning("这身防护服似乎永久地融合在了他们的躯体上——你无法将其移除！"))
	who.balloon_alert(who, "无法脱下融合的MOD防护服！")
	return ..()

/obj/item/mod/control/pre_equipped/entombed/retract(mob/user, obj/item/part, instant)
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/datum/quirk/equipping/entombed/tomb_quirk = human_user.get_quirk(/datum/quirk/equipping/entombed)
		//check to make sure we're not retracting something we shouldn't be able to
		if (tomb_quirk && tomb_quirk.deploy_locked)
			if (istype(part, /obj/item/clothing)) // make sure it's a modsuit piece and not a module, we retract those too
				if (!istype(part, /obj/item/clothing/head/mod)) // they can only retract the helmet, them's the sticks
					human_user.balloon_alert(human_user, "部件已与你融合 - 无法收回！")
					playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
					return
	return ..()

/obj/item/mod/control/pre_equipped/entombed/quick_deploy(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/datum/quirk/equipping/entombed/tomb_quirk = human_user.get_quirk(/datum/quirk/equipping/entombed)
		//if we're deploy_locked, just disable this functionality entirely
		if (tomb_quirk && tomb_quirk.deploy_locked)
			human_user.balloon_alert(human_user, "你只能收回头盔，且只能手动操作！")
			playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
			return
	return ..()

/obj/item/mod/control/pre_equipped/entombed/Initialize(mapload, new_theme, new_skin, new_core)
	. = ..()
	// Apply the entombed mod piece component to our applicable clothing pieces, so that they *always* return to the unit or self-delete if they can't.
	for (var/obj/item/part as anything in get_parts())
		part.AddComponent(/datum/component/entombed_mod_piece, host_suit = src)

	ADD_TRAIT(src, TRAIT_NODROP, QUIRK_TRAIT)

/obj/item/mod/control/pre_equipped/entombed/dropped(mob/user)
	. = ..()
	// we do this so that in the rare event that someone gets gibbed/destroyed, their suit can be retrieved easily w/o requiring admin intervention
	REMOVE_TRAIT(src, TRAIT_NODROP, QUIRK_TRAIT)
