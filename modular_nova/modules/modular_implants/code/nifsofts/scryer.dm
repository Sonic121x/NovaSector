/obj/item/disk/nifsoft_uploader/scryer
	name = "NIFSoft 窥视者上传磁盘"
	loaded_nifsoft = /datum/nifsoft/scryer

/datum/nifsoft/scryer
	name = "NIFLink 全息呼叫器"
	program_desc = "This ubiquitous NIFSoft adds Scryer functionality similar to MODSuits to the user's NIF; allowing for real-time communication through AR hologlass screens from a hardlight projector sat around the wearer's neck"
	active_mode = TRUE
	active_cost = 1
	activation_cost = 20
	purchase_price = 200
	buying_category = NIFSOFT_CATEGORY_UTILITY
	ui_icon = "video"
	/// What is the scryer currently associated with the NIFSoft?
	var/obj/item/clothing/neck/link_scryer/loaded/nifsoft/linked_scryer

/datum/nifsoft/scryer/New()
	. = ..()
	var/obj/item/organ/cyberimp/brain/nif/parent_resolved = parent_nif.resolve()
	if(!istype(parent_resolved))
		stack_trace("[src] ([REF(src)]) tried to create a linked scryer but it had no parent_nif!")
	linked_scryer = new (parent_resolved)
	linked_scryer.parent_nifsoft = WEAKREF(src)

/datum/nifsoft/scryer/Destroy()
	if(!QDELETED(linked_scryer))
		QDEL_NULL(linked_scryer)

	return ..()

/datum/nifsoft/scryer/activate()
	. = ..()
	if(. == FALSE)
		return FALSE

	if(!active)
		if(linked_scryer)
			var/parent_resolved = parent_nif.resolve()
			if(parent_resolved)
				return linked_mob.transferItemToLoc(linked_scryer, parent_resolved, TRUE)
		return FALSE

	if(linked_mob.handcuffed)
		linked_mob.balloon_alert(linked_mob, "被铐住了")
		activate()
		return FALSE

	if(!linked_mob.equip_to_slot_if_possible(linked_scryer, ITEM_SLOT_NECK)) //This sends out a message to the mob if it can't be put on.
		activate()
		return FALSE

	return TRUE

/obj/item/clothing/neck/link_scryer
	/// Do we have custom controls? This is only affects the text shown when examining
	var/custom_examine_controls = FALSE

/obj/item/clothing/neck/link_scryer/loaded/nifsoft
	name = "\improper NIFLink 全息呼叫器"
	desc = "一种纳米机器构造体，作为 MODlink 窥视器的改良版本，通过 NIF 召唤而成；功能相同，但能以更便携的格式进行全息通话。"
	custom_examine_controls = TRUE
	/// A weakref of the parent NIFSoft that the scryer belongs to.
	var/datum/weakref/parent_nifsoft

/obj/item/clothing/neck/link_scryer/loaded/nifsoft/Initialize(mapload)
	. = ..()
	if(cell)
		QDEL_NULL(cell)

	cell = new /obj/item/stock_parts/power_store/cell/infinite/nif_cell(src)

/obj/item/clothing/neck/link_scryer/loaded/nifsoft/Destroy()
	if(parent_nifsoft)
		var/datum/nifsoft/scryer/resolved_nifsoft = parent_nifsoft.resolve()
		if(!QDELETED(resolved_nifsoft))
			resolved_nifsoft.linked_scryer = null

	return ..()

/obj/item/clothing/neck/link_scryer/loaded/nifsoft/examine(mob/user)
	. = ..()
	. += span_notice("MODlink 的 ID 是 [mod_link.id]，频率是 [mod_link.frequency || "unset"]。<b>右键点击</b>用多功能工具来复制/刻印频率。")
	. += span_notice("<b>右键点击</b>使用空手来更改名称。")

/obj/item/clothing/neck/link_scryer/loaded/nifsoft/equipped(mob/living/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_NECK)
		return TRUE

	var/datum/nifsoft/scryer/scryer_nifsoft = parent_nifsoft.resolve()
	if(!istype(scryer_nifsoft))
		return FALSE

	scryer_nifsoft.activate() //If it's not on the neck, it shouldn't be active.
	return TRUE

/obj/item/clothing/neck/link_scryer/loaded/nifsoft/screwdriver_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "电池不可拆卸！")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/neck/link_scryer/loaded/nifsoft/attack_hand_secondary(mob/user, list/modifiers)
	var/new_label = reject_bad_text(tgui_input_text(user, "更改可见名称", "设置名称", label, max_length = MAX_NAME_LEN))
	if(!new_label)
		balloon_alert(user, "无效的名称！")
		return
	label = new_label
	balloon_alert(user, "名称已设置！")
	update_name()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/// This cell is only meant for use in items temporarily created by a NIF. Do not let players extract this from devices.
/obj/item/stock_parts/power_store/cell/infinite/nif_cell
	name = "纳米电池"
	desc = "如果你看到这个，请在 GitHub 上提交问题。"

