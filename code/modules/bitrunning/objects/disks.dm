/**
 * Bitrunning tech disks which let you load items or programs into the vdom on first avatar generation.
 * For the record: Balance shouldn't be a primary concern.
 * You can make the custom cheese spells you've always wanted.
 * Just make it fun and engaging, it's PvE content.
 */
/obj/item/disk/bitrunning
	name = "通用比特奔跑程序"
	desc = "一张包含源代码的磁盘。"
	base_icon_state = "datadisk"
	icon_state = "datadisk0"
	sticker_icon_state = "o_code"
	/// Name of the choice made
	var/choice_made

/obj/item/disk/bitrunning/Initialize(mapload)
	. = ..()

	icon_state = "[base_icon_state][rand(0, 7)]"
	update_icon()

	AddComponent(/datum/component/loads_avatar_gear, \
		load_callback = CALLBACK(src, PROC_REF(load_onto_avatar)), \
	)

/obj/item/disk/bitrunning/setup_reskins()
	return

/obj/item/disk/bitrunning/examine(mob/user)
	. = ..()
	. += span_infoplain("此磁盘必须由你本人携带进入网络舱才能使用。")

	if(isnull(choice_made))
		. += span_notice("要做出选择，请在手中切换磁盘。")
		return

	. += span_info("它已被用于选择：<b>[choice_made]</b>。")
	. += span_notice("它无法再进行选择。")

/// Handles loading our stuff onto avatars
/obj/item/disk/bitrunning/proc/load_onto_avatar(mob/living/carbon/human/neo, mob/living/carbon/human/avatar, domain_flags)
	return NONE

/obj/item/disk/bitrunning/ability
	desc = "一张包含源代码的磁盘。可用于将能力预加载到虚拟域中。重复的能力将被忽略。"
	/// The selected ability that this grants
	var/datum/action/granted_action
	/// The list of actions that this can grant
	var/list/datum/action/selectable_actions = list()

/obj/item/disk/bitrunning/ability/load_onto_avatar(mob/living/carbon/human/neo, mob/living/carbon/human/avatar, domain_flags)
	if(domain_flags & DOMAIN_FORBIDS_ABILITIES)
		return BITRUNNER_GEAR_LOAD_BLOCKED

	if(isnull(granted_action))
		return BITRUNNER_GEAR_LOAD_FAILED

	if(locate(granted_action) in avatar.actions)
		return BITRUNNER_GEAR_LOAD_FAILED

	var/datum/action/our_action = new granted_action()
	our_action.Grant(avatar)
	return NONE

/obj/item/disk/bitrunning/ability/attack_self(mob/user, modifiers)
	// Not calling parent to not flip the protection tab

	if(choice_made)
		return

	var/names = list()
	for(var/datum/action/thing as anything in selectable_actions)
		names += initial(thing.name)

	var/choice = tgui_input_list(user, message = "选择一个能力",  title = "比特奔跑程序", items = names)
	if(isnull(choice) || !user.is_holding(src))
		return

	for(var/datum/action/thing as anything in selectable_actions)
		if(initial(thing.name) == choice)
			granted_action = thing

	if(isnull(granted_action))
		return

	balloon_alert(user, "已选择")
	playsound(user, 'sound/items/click.ogg', 50, TRUE)
	choice_made = choice

/// Tier 1 programs. Simple, funny, or helpful.
/obj/item/disk/bitrunning/ability/tier1
	name = "比特奔跑程序：基础"
	selectable_actions = list(
		/datum/action/cooldown/spell/conjure/cheese,
		/datum/action/cooldown/spell/basic_heal,
	)

/// Tier 2 programs. More complex, powerful, or useful.
/obj/item/disk/bitrunning/ability/tier2
	name = "比特奔跑程序：复杂"
	selectable_actions = list(
		/datum/action/cooldown/spell/pointed/projectile/fireball,
		/datum/action/cooldown/spell/pointed/projectile/lightningbolt,
		/datum/action/cooldown/spell/forcewall,
	)

/// Tier 3 abilities. Very powerful, game breaking.
/obj/item/disk/bitrunning/ability/tier3
	name = "比特奔跑程序：精英"
	selectable_actions = list(
		/datum/action/cooldown/spell/shapeshift/dragon,
		/datum/action/cooldown/spell/shapeshift/polar_bear,
	)


/obj/item/disk/bitrunning/item
	desc = "一张包含源代码的磁盘。可用于将物品预加载到虚拟域中。"
	/// The selected item that this grants
	var/obj/granted_item
	/// The list of actions that this can grant
	var/list/obj/selectable_items = list()

/obj/item/disk/bitrunning/item/load_onto_avatar(mob/living/carbon/human/neo, mob/living/carbon/human/avatar, domain_flags)
	if(domain_flags & DOMAIN_FORBIDS_ITEMS)
		return BITRUNNER_GEAR_LOAD_BLOCKED

	if(isnull(granted_item))
		return BITRUNNER_GEAR_LOAD_FAILED

	avatar.put_in_hands(new granted_item())
	return NONE

/obj/item/disk/bitrunning/item/attack_self(mob/user, modifiers)
	. = ..()

	if(choice_made)
		return

	var/names = list()
	for(var/obj/thing as anything in selectable_items)
		names += initial(thing.name)

	var/choice = tgui_input_list(user, message = "选择一个能力",  title = "比特奔跑程序", items = names)
	if(isnull(choice) || !user.is_holding(src))
		return

	for(var/obj/thing as anything in selectable_items)
		if(initial(thing.name) == choice)
			granted_item = thing

	balloon_alert(user, "已选择")
	playsound(user, 'sound/items/click.ogg', 50, TRUE)
	choice_made = choice

/// Tier 1 items. Simple, funny, or helpful.
/obj/item/disk/bitrunning/item/tier1
	name = "比特奔跑装备：简易"
	selectable_items = list(
		/obj/item/pizzabox/infinite,
		/obj/item/gun/medbeam,
		/obj/item/grenade/c4,
	)

/// Tier 2 items. More complex, powerful, or useful.
/obj/item/disk/bitrunning/item/tier2
	name = "比特奔跑装备：复杂"
	selectable_items = list(
		/obj/item/reagent_containers/hypospray/medipen/survival/luxury,
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/clothing/suit/armor/vest,
	)

/// Tier 3 items. Very powerful, game breaking.
/obj/item/disk/bitrunning/item/tier3
	name = "比特奔跑装备：高级"
	selectable_items = list(
		/obj/item/gun/energy/e_gun/nuclear,
		/obj/item/dualsaber/green,
		/obj/item/grenade/syndieminibomb,
	)

///proto-kinetic accelerator mods, to be applied to pka's given inside domains
/obj/item/disk/bitrunning/item/pka_mods
	name = "位面疾走装备：原型动能加速器模组"
	selectable_items = list(
		/obj/item/borg/upgrade/modkit/range,
		/obj/item/borg/upgrade/modkit/damage,
		/obj/item/borg/upgrade/modkit/cooldown,
		/obj/item/borg/upgrade/modkit/cooldown/aoe/mobs,
		/obj/item/borg/upgrade/modkit/human_passthrough,
	)

/obj/item/disk/bitrunning/item/pka_mods/premium
	name = "位面疾走装备：高级原型动能加速器模组"
	selectable_items = list(
		/obj/item/borg/upgrade/modkit/cooldown/repeater,
		/obj/item/borg/upgrade/modkit/lifesteal,
		/obj/item/borg/upgrade/modkit/resonator_blasts,
		/obj/item/borg/upgrade/modkit/bounty,
		/obj/item/borg/upgrade/modkit/indoors,
	)

///proto-kinetic crusher trophies, to be applied to pkc's given inside domains
/obj/item/disk/bitrunning/item/pkc_mods
	name = "位面疾走装备：原型动能粉碎器模组"
	selectable_items = list(
		/obj/item/crusher_trophy/watcher_wing,
		/obj/item/crusher_trophy/blaster_tubes/magma_wing,
		/obj/item/crusher_trophy/legion_skull,
		/obj/item/crusher_trophy/wolf_ear,
	)

/obj/item/disk/bitrunning/item/pkc_mods/premium
	name = "位面疾走装备：高级原型动能粉碎器模组"
	selectable_items = list(
		/obj/item/crusher_trophy/watcher_wing/ice_wing,
		/obj/item/crusher_trophy/blaster_tubes,
		/obj/item/crusher_trophy/miner_eye,
		/obj/item/crusher_trophy/tail_spike,
		/obj/item/crusher_trophy/demon_claws,
		/obj/item/crusher_trophy/vortex_talisman,
		/obj/item/crusher_trophy/ice_demon_cube,
	)

/obj/item/disk/bitrunning/item/mini_uzi
	name = "位面疾走装备：迷你乌兹冲锋枪"
	selectable_items = list(
		/obj/item/gun/ballistic/automatic/mini_uzi,
	)
